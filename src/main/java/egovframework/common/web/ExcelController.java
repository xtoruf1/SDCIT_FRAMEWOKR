package egovframework.common.web;

import java.awt.Color;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.ResultContext;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.common.Constants;
import egovframework.common.util.FileUtil;
import egovframework.common.util.StringUtil;

@Controller
@RequestMapping(value = "/common/excel")
public class ExcelController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ExcelController.class);
	
	@Autowired
    @Qualifier("sqlSession")
    private SqlSessionFactory sqlSessionFactory;
	
	@Autowired
    private SqlSessionFactory tradeSqlSessionFactory;
	
    @RequestMapping(value = "/massExcelDownload.do")
    public void massExcelDownload(
    	HttpServletRequest request
    	, HttpServletResponse response
    	, @RequestParam(value = "headers", required = true)String headers
    	, @RequestParam(value = "fileName", required = true)String fileName
    	, @RequestParam(value = "sessionId", required = false)String sessionId
    	, @RequestParam(value = "sqlId", required = true)String sqlId
    	, @RequestParam(value = "headerRowCnt", required = true)int headerRowCnt
    	, @RequestParam(value = "param", required = true)String param
    	, @RequestParam(value = "drmYn", defaultValue = "N", required = false)String drmYn
    	, ModelMap model
    ) {
    	String strHeaders = "";
		
		try {
			strHeaders = URLDecoder.decode(headers, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			LOGGER.error(e.getMessage());
		}

		List<HashMap<String, Object>> headerList = this.jsonHeaderDataToHashMap(strHeaders);

		JSONParser jsonParser = new JSONParser();
		HashMap<String, Object> mapParam = new HashMap<>();
        
		try {
			if (!StringUtil.isEmpty(param)) {
				JSONObject jsonObject = (JSONObject)jsonParser.parse(URLDecoder.decode(param, "UTF-8"));

				for (Object key : jsonObject.keySet()) {
					mapParam.put((String)key, jsonObject.get(key));
				}
			}
		} catch (ParseException e) {
			LOGGER.error(e.getMessage());
		} catch (UnsupportedEncodingException e ) {
			LOGGER.error(e.getMessage());
		}

		SqlSession sqlSession = null;
		
		if (Constants.EXCEL_DOWNLOAD_KEMMBER.equals(sessionId)) {
			sqlSession = sqlSessionFactory.openSession();
		} else if (Constants.EXCEL_DOWNLOAD_TRADE.equals(sessionId)) {
			sqlSession = tradeSqlSessionFactory.openSession();
		} else if (Constants.EXCEL_DOWNLOAD_ABTC.equals(sessionId)) {
			// sqlSession = abtcSqlSessionFactory.openSession();
		} else {
			sqlSession = sqlSessionFactory.openSession();
		}
		
		SXSSFWorkbook wb = new SXSSFWorkbook(10000);
		Sheet sheet = wb.createSheet(StringUtil.specialCharRemove(fileName));
		Cell cellHeader = null;
		int rowNo = 0;
		
		// 헤더
		Row rowHeader = sheet.createRow(rowNo++);
		rowHeader.setHeight((short)600);
		CellStyle[] arrCellStyle = new CellStyle[headerList.size()];
		DataFormat dataFormat = wb.createDataFormat();

		XSSFCellStyle headerStyle = (XSSFCellStyle)wb.createCellStyle();
		// XSSFColor headerColor = new XSSFColor(new byte[] {(byte)236, (byte)241, (byte)251}, null);
		XSSFColor headerColor = new XSSFColor(new Color(236,241,251));
		
		headerStyle.setFillForegroundColor(headerColor);
		headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		headerStyle.setAlignment(HorizontalAlignment.CENTER);
		headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);

		headerStyle.setBorderTop(BorderStyle.THIN);
		headerStyle.setBorderLeft(BorderStyle.THIN);
		headerStyle.setBorderRight(BorderStyle.THIN);
		headerStyle.setBorderBottom(BorderStyle.THIN);

        XSSFCellStyle cellBgStyle = (XSSFCellStyle)wb.createCellStyle();
        cellBgStyle.setFillForegroundColor(IndexedColors.LEMON_CHIFFON.getIndex());
        cellBgStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        for (int i = 0; i < headerList.size(); i++) {
        	// Hidden 값 true일 경우 Header 제외 - 데이터 처리용 컬럼
        	if (headerList.get(i).get("Hidden") == null || !headerList.get(i).get("Hidden").toString().equalsIgnoreCase("true")) {
				cellHeader = rowHeader.createCell(i);
				cellHeader.setCellValue((String)headerList.get(i).get("Header"));
				cellHeader.setCellStyle(headerStyle);
				sheet.setColumnWidth(i, (int)(long)headerList.get(i).get("Width"));
				CellStyle cellStyle = wb.createCellStyle();

				if (headerList.get(i).get("Format") != null && !headerList.get(i).get("Format").equals("")) {
					cellStyle.setDataFormat(dataFormat.getFormat((String) headerList.get(i).get("Format")));
        		} else {
        			cellStyle.setDataFormat(dataFormat.getFormat("@"));
        		}

        		if (headerList.get(i).get("Align") != null && headerList.get(i).get("Align").toString().equalsIgnoreCase("center")) {
        			cellStyle.setAlignment(CellStyle.ALIGN_CENTER);
        		} else if (headerList.get(i).get("Align") != null && headerList.get(i).get("Align").toString().equalsIgnoreCase("left")) {
        			cellStyle.setAlignment(CellStyle.ALIGN_LEFT);
        		} else if (headerList.get(i).get("Align") != null && headerList.get(i).get("Align").toString().equalsIgnoreCase("right")) {
        			cellStyle.setAlignment(CellStyle.ALIGN_RIGHT);
        		}
        		
        		cellStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);
        		cellStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);
        		cellStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);
        		cellStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);
        		
        		arrCellStyle[i] = cellStyle;
        	} else {
        		// Hidden 일 경우 숨김처리
        		sheet.setColumnHidden(i, true);
        	}
        }

        try {
        	sqlSession.select(sqlId, mapParam, new ResultHandler() {
				@Override
				public void handleResult(ResultContext resultContext) {
					int bgCellNo = 0;			// bg 컬럼 index
					int bgCellCnt = 0;			// bg 컬럼 유무
					String bgSaveName = "";		// bgColor 컬럼 명칭

					HashMap<String, Object> excelData = (HashMap<String, Object>)resultContext.getResultObject();
					
					// 데이터
					Cell cell = null;
					Row row = sheet.createRow(resultContext.getResultCount() + (headerRowCnt - 1));
					
					for (int j = 0; j < headerList.size(); j++) {
						// Hidden 값 true 일 경우 - 데이터 처리
						if (
							headerList.get(j).get("SaveName") != null
							&& headerList.get(j).get("Hidden") != null
						) {
							if (headerList.get(j).get("Hidden").toString().equalsIgnoreCase("true")) {
								bgSaveName = headerList.get(j).get("SaveName").toString();
								
	                    		// Yn 컬럼이고 값이 Y면
	                    		if (bgSaveName.contains("Yn") && ("Y").equals(excelData.get(bgSaveName).toString())) {
	                    			// saveName 에서 Yn 뺀 컬럼명
	                    			bgSaveName = bgSaveName.substring(0, bgSaveName.lastIndexOf("Yn"));

	                    			// bg 스타일 cell 번호
	                    			for (int k = 0; k < headerList.size(); k++) {
	                    				if (bgSaveName.equals(headerList.get(k).get("SaveName"))) {
	                    					bgCellNo = k;
	                    					
	                    					bgCellCnt++;
	                    				}
	                    			}
	                    		}
							}
                    	} else {
                    		cell = row.createCell(j);
                    		bgSaveName = headerList.get(j).get("SaveName").toString();
                    		cell.setCellValue(excelData.get(bgSaveName).toString());
                    		cell.setCellStyle(arrCellStyle[j]);
                    	}
					}

					// bgCell 이 있을 경우 실행
					if (bgCellCnt > 0) {
						if (sheet.getRow(resultContext.getResultCount()).getCell(bgCellNo) != null) {
							sheet.getRow(resultContext.getResultCount()).getCell(bgCellNo).setCellStyle(cellBgStyle);
						}
					}
				}
        	});
        } catch (Exception e) {
        	LOGGER.error(e.getMessage());
        } finally {
        	if (sqlSession != null) {
        		sqlSession.close();
        	}
        }

        try {
        	FileUtil.downloadExcelFile(wb, response, "application/octet-stream", this.getEncFileName(request.getHeader("User-Agent"), fileName), drmYn);
        } catch (IOException e) {
        	LOGGER.error(e.getMessage());
        }
    }
    
    public static List<HashMap<String, Object>> jsonHeaderDataToHashMap(String jsonData) {
    	List<HashMap<String, Object>> resultList = new ArrayList<HashMap<String, Object>>();

    	try {
			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObject = (JSONObject)jsonParser.parse(jsonData);
			JSONArray jsonArray = (JSONArray)jsonObject.get("headerData");

			HashMap<String, Object> mapData;
			for (int i = 0; i < jsonArray.size(); i++) {
				JSONObject objectInArray = (JSONObject)jsonArray.get(i);
				mapData = new HashMap<String, Object>();
				for (Object key : objectInArray.keySet()) {
					mapData.put((String) key, objectInArray.get(key));
				}
				
				resultList.add(mapData);
			}
    	} catch (ParseException e) {
    		LOGGER.error(e.getMessage());
    	}

    	return resultList;
    }
    
    private String getEncFileName(String browser, String fileName) {
    	String encFileNm = "";

    	try {
    		// 파일 인코딩
    		if (browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")) {
    			encFileNm = URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");
    		} else {
    			encFileNm = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
    		}
    	} catch (UnsupportedEncodingException ex) {
    		LOGGER.debug("UnsupportedEncodingException");
    	}

    	return encFileNm;
    }
}