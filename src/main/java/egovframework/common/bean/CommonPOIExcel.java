package egovframework.common.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.Comment;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.egovframe.rte.fdl.excel.util.AbstractPOIExcelView;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.common.Constants;
import egovframework.common.vo.CommonHashMap;

public class CommonPOIExcel extends AbstractPOIExcelView {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonPOIExcel.class);

	@SuppressWarnings("unchecked")
	@Override
	protected void buildExcelDocument(Map<String, Object> model, XSSFWorkbook wb, HttpServletRequest req, HttpServletResponse resp) throws Exception {
		// Header Cell Style 세팅
		XSSFCell headerCell = null;
		CellStyle headerStyle = wb.createCellStyle();
		headerStyle.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		headerStyle.setAlignment(XSSFCellStyle.ALIGN_CENTER);
		headerStyle.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);

		headerStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);

		Font headerFont = wb.createFont();
		headerFont.setBold(true);
		headerStyle.setFont(headerFont);

		//List Cell Style 세팅
		XSSFCell listCell = null;
		CellStyle listStyle = wb.createCellStyle();
		listStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);
		listStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		listStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);
		listStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);

		Map<String, Object> map = (Map<String, Object>) model.get("infomationMap");

		String commentYn = (String)map.get("commentYn");

		String mode = (String)map.get("mode");

		if (Constants.EXCEL_HEADER_LIST.equals(mode)) {
			List<CommonHashMap<String, String>> headerList = (List<CommonHashMap<String, String>>)map.get("header");
			List<CommonHashMap<String, String>> contentList = (List<CommonHashMap<String, String>>)map.get("list");

			String fileName = (String)map.get("fileName");

	        XSSFSheet sheet = wb.createSheet("sheet1");
	        sheet.setDefaultColumnWidth(15);

	        // 엑셀파일 내용
	        for (int i = 0; i < headerList.size(); i++) {
	        	headerCell = getCell(sheet, 0, i);
	    		headerCell.setCellStyle(headerStyle);
	        	headerCell.setCellValue(headerList.get(i).get("name"));

	    		if (contentList != null) {
	    			for (int j = 0; j < contentList.size(); j++) {
	    				// 데이터가 null 로 넘어 올 경우 처리
		        		String value = String.valueOf((contentList.get(j).get(headerList.get(i).get("key"))));

		        		if (value == null || value.toLowerCase().equals("null")) {
		        			value = "";
		        		}

		        		listCell = getCell(sheet, j + 1, i);
		        		listCell.setCellStyle(listStyle);
		        		listCell.setCellValue(value);
					}
	    		}
			}

	        if(commentYn == null) {
	        	sheet.createFreezePane(0, 1);	// 0열, 1행 고정
	        }

			if(commentYn != null) {	// 메모 추가(맴버십카드 발급관리)

				String commentCardList = (String)map.get("commentCardList");

				String commentIssueFomat = (String)map.get("commentIssueFomat");

				if(commentCardList != null) {

					CreationHelper factory = wb.getCreationHelper();

					Cell cell = getCell(sheet, 0, 1);

					ClientAnchor anchor = factory.createClientAnchor();

					Drawing drawing = sheet.createDrawingPatriarch();
					Comment comment = drawing.createCellComment(anchor);

					comment.setString(factory.createRichTextString(commentCardList));

					cell.setCellComment(comment);
				}

				if(commentIssueFomat != null) {

					CreationHelper factory = wb.getCreationHelper();

					Cell cell = getCell(sheet, 0, 2);

					ClientAnchor anchor = factory.createClientAnchor();

					Drawing drawing = sheet.createDrawingPatriarch();
					Comment comment = drawing.createCellComment(anchor);

					comment.setString(factory.createRichTextString(commentIssueFomat));

					cell.setCellComment(comment);
				}

			}

	        fileName = new String(fileName.getBytes("euc-kr"), "8859_1");

	        model.put("filename", fileName);
		} else if (Constants.EXCEL_DOUBLE_HEADER_LIST.equals(mode)) {
			List<CommonHashMap<String, String>> headerList = (List<CommonHashMap<String, String>>)map.get("header");
			List<CommonHashMap<String, String>> contentList = (List<CommonHashMap<String, String>>)map.get("list");

			String fileName = (String)map.get("fileName");

	        XSSFSheet sheet = wb.createSheet("sheet1");
	        sheet.setDefaultColumnWidth(15);

	        List<HashMap<String, Integer>> mergeList = new ArrayList<HashMap<String, Integer>>();

	        // 엑셀파일 내용
	        for (int i = 0; i < headerList.size(); i++) {
	        	// 헤더1
	        	headerCell = getCell(sheet, 0, i);
	    		headerCell.setCellStyle(headerStyle);

	    		HashMap<String, Integer> mergeInfo = new HashMap<String, Integer>();

	    		if (headerList.get(i).get("headerType") != null && !headerList.get(i).get("headerType").isEmpty()) {
	    			mergeInfo.put("startIdx", Integer.parseInt(headerList.get(i).get("startIdx")));
    				mergeInfo.put("endIdx", Integer.parseInt(headerList.get(i).get("endIdx")));

	    			if (Constants.EXCEL_ROW_MERGE.equals(headerList.get(i).get("headerType"))) {
	    				mergeInfo.put("rowMerge", 1);

	    				headerCell.setCellValue(headerList.get(i).get("group"));
	    			} else if (Constants.EXCEL_GROUP_MERGE.equals(headerList.get(i).get("headerType"))) {
	    				mergeInfo.put("rowMerge", 0);

		    			headerCell.setCellValue(headerList.get(i).get("group"));
	    			}

	    			mergeList.add(mergeInfo);
	    		} else {
	    			headerCell.setCellValue("");
	    		}

	    		// 헤더2
	        	headerCell = getCell(sheet, 1, i);
	    		headerCell.setCellStyle(headerStyle);
	        	headerCell.setCellValue(headerList.get(i).get("name"));

	    		if (contentList != null) {
	    			for (int j = 0; j < contentList.size(); j++) {
		        		// 데이터가 null 로 넘어 올 경우 처리
		        		String value = String.valueOf((contentList.get(j).get(headerList.get(i).get("key"))));

		        		if (value == null || value.toLowerCase().equals("null")) {
		        			value = "";
		        		}

		        		listCell = getCell(sheet, j + 2, i);
		        		listCell.setCellStyle(listStyle);
		        		listCell.setCellValue(value);
					}
	    		}
			}

	        for (HashMap<String, Integer> mergeInfo : mergeList) {
	        	sheet.addMergedRegion(new CellRangeAddress(0, mergeInfo.get("rowMerge"), mergeInfo.get("startIdx"), mergeInfo.get("endIdx")));
			}

	        sheet.createFreezePane(0, 2);	// 0열, 2행 고정

	        fileName = new String(fileName.getBytes("euc-kr"), "8859_1");

	        model.put("filename", fileName);
		} else if (Constants.EXCEL_DOUBLE_HEADER_MULTI_LIST.equals(mode)) {
			List<CommonHashMap<String, String>> headerList1 = (List<CommonHashMap<String, String>>)map.get("header1");
			List<CommonHashMap<String, String>> contentList1 = (List<CommonHashMap<String, String>>)map.get("list1");

			String title1 = (String)map.get("title1");

			String fileName = (String)map.get("fileName");

	        XSSFSheet sheet = wb.createSheet("sheet1");
	        sheet.setDefaultColumnWidth(15);

	        List<HashMap<String, Integer>> mergeList = new ArrayList<HashMap<String, Integer>>();

	        int startRow = 0;
	        int tmpStartRow = 0;

			// 첫번째 타이틀 설정
			getCell(sheet, startRow, 0).setCellValue(title1);
			startRow++;

			CommonHashMap<String, String> etcInfo1 = (CommonHashMap<String, String>)map.get("etcInfo1");

	        if (etcInfo1 != null && !etcInfo1.isEmpty()) {
				getCell(sheet, startRow, 0).setCellValue(etcInfo1.get("title"));
				getCell(sheet, startRow, 1).setCellValue(etcInfo1.get("info"));

				startRow++;
	        }

	        tmpStartRow = startRow;

	        // 엑셀파일 내용
	        for (int i = 0; i < headerList1.size(); i++) {
	        	startRow = tmpStartRow;

	        	// 헤더1
	        	headerCell = getCell(sheet, startRow, i);
	    		headerCell.setCellStyle(headerStyle);

	    		HashMap<String, Integer> mergeInfo = new HashMap<String, Integer>();

	    		if (headerList1.get(i).get("headerType") != null && !headerList1.get(i).get("headerType").isEmpty()) {
	    			mergeInfo.put("startIdx", Integer.parseInt(headerList1.get(i).get("startIdx")));
    				mergeInfo.put("endIdx", Integer.parseInt(headerList1.get(i).get("endIdx")));

	    			if (Constants.EXCEL_ROW_MERGE.equals(headerList1.get(i).get("headerType"))) {
	    				mergeInfo.put("rowMergeStIdx", startRow);
	    				mergeInfo.put("rowMergeEdIdx", startRow + 1);

	    				headerCell.setCellValue(headerList1.get(i).get("group"));
	    			} else if (Constants.EXCEL_GROUP_MERGE.equals(headerList1.get(i).get("headerType"))) {
	    				mergeInfo.put("rowMergeStIdx", startRow);
	    				mergeInfo.put("rowMergeEdIdx", startRow);

		    			headerCell.setCellValue(headerList1.get(i).get("group"));
	    			}

	    			mergeList.add(mergeInfo);
	    		} else {
	    			headerCell.setCellValue("");
	    		}

	    		// 헤더 1 세팅 후 시작 행 증가
	    		startRow++;

	        	// 헤더2
	        	headerCell = getCell(sheet, startRow, i);
	    		headerCell.setCellStyle(headerStyle);
	        	headerCell.setCellValue(headerList1.get(i).get("name"));

	        	// 헤더 2 세팅 후 시작 행 증가
	    		startRow++;

	    		if (contentList1 != null) {
	    			for (int j = 0; j < contentList1.size(); j++) {
		        		// 데이터가 null 로 넘어 올 경우 처리
		        		String value = String.valueOf((contentList1.get(j).get(headerList1.get(i).get("key"))));

		        		if (value == null || value.toLowerCase().equals("null")) {
		        			value = "";
		        		}

		        		listCell = getCell(sheet, j + startRow, i);
		        		listCell.setCellStyle(listStyle);
		        		listCell.setCellValue(value);
					}

		        	startRow = startRow + contentList1.size();
	    		}
			}

			// 테이블 사이 간격 처리
			startRow++;
			startRow++;

			List<CommonHashMap<String, String>> headerList2 = (List<CommonHashMap<String, String>>)map.get("header2");
			List<CommonHashMap<String, String>> contentList2 = (List<CommonHashMap<String, String>>)map.get("list2");

			String title2 = (String)map.get("title2");

			// 두번째 타이틀 설정
	        getCell(sheet, startRow, 0).setCellValue(title2);
	        startRow++;

	        CommonHashMap<String, String> etcInfo2 = (CommonHashMap<String, String>)map.get("etcInfo2");

	        if (etcInfo2 != null && !etcInfo2.isEmpty()) {
	        	getCell(sheet, startRow, 0).setCellValue(etcInfo2.get("title"));
		        getCell(sheet, startRow, 1).setCellValue(etcInfo2.get("info"));

		        startRow++;
	        }

	        tmpStartRow = startRow;

	        // 엑셀파일 내용
	        for (int i = 0; i < headerList2.size(); i++) {
	        	startRow = tmpStartRow;

	        	// 헤더1
	        	headerCell = getCell(sheet, startRow, i);
	    		headerCell.setCellStyle(headerStyle);

	    		HashMap<String, Integer> mergeInfo = new HashMap<String, Integer>();

	    		if (headerList2.get(i).get("headerType") != null && !headerList2.get(i).get("headerType").isEmpty()) {
	    			mergeInfo.put("startIdx", Integer.parseInt(headerList2.get(i).get("startIdx")));
    				mergeInfo.put("endIdx", Integer.parseInt(headerList2.get(i).get("endIdx")));

	    			if (Constants.EXCEL_ROW_MERGE.equals(headerList2.get(i).get("headerType"))) {
	    				mergeInfo.put("rowMergeStIdx", startRow);
	    				mergeInfo.put("rowMergeEdIdx", startRow + 1);

	    				headerCell.setCellValue(headerList2.get(i).get("group"));
	    			} else if (Constants.EXCEL_GROUP_MERGE.equals(headerList2.get(i).get("headerType"))) {
	    				mergeInfo.put("rowMergeStIdx", startRow);
	    				mergeInfo.put("rowMergeEdIdx", startRow);

		    			headerCell.setCellValue(headerList2.get(i).get("group"));
	    			}

	    			mergeList.add(mergeInfo);
	    		} else {
	    			headerCell.setCellValue("");
	    		}

	    		// 헤더 1 세팅 후 시작 행 증가
	    		startRow++;

	        	// 헤더2
	        	headerCell = getCell(sheet, startRow, i);
	    		headerCell.setCellStyle(headerStyle);
	    		headerCell.setCellValue(headerList2.get(i).get("name"));

	        	// 헤더 2 세팅 후 시작 행 증가
	    		startRow++;

	    		if (contentList2 != null) {
	    			for (int j = 0; j < contentList2.size(); j++) {
		        		// 데이터가 null 로 넘어 올 경우 처리
		        		String value = String.valueOf((contentList2.get(j).get(headerList2.get(i).get("key"))));

		        		if (value == null || value.toLowerCase().equals("null")) {
		        			value = "";
		        		}

		        		listCell = getCell(sheet, j + startRow, i);
		        		listCell.setCellStyle(listStyle);
		        		listCell.setCellValue(value);
					}

		        	startRow = startRow + contentList1.size();
	    		}
			}

	        // 머지 설정
	        for (HashMap<String, Integer> mergeInfo : mergeList) {
	        	sheet.addMergedRegion(new CellRangeAddress(mergeInfo.get("rowMergeStIdx"), mergeInfo.get("rowMergeEdIdx"), mergeInfo.get("startIdx"), mergeInfo.get("endIdx")));
			}

	        fileName = new String(fileName.getBytes("euc-kr"), "8859_1");

	        model.put("filename", fileName);
		} else if (Constants.EXCEL_MULTI_SHEET.equals(mode)) {
			List<CommonHashMap<String, String>> headerList1 = (List<CommonHashMap<String, String>>)map.get("header1");
			List<CommonHashMap<String, String>> contentList1 = (List<CommonHashMap<String, String>>)map.get("list1");
			List<CommonHashMap<String, String>> headerList2 = (List<CommonHashMap<String, String>>)map.get("header2");
			List<CommonHashMap<String, String>> contentList2 = (List<CommonHashMap<String, String>>)map.get("list2");

			String fileName = (String)map.get("fileName");

			XSSFSheet sheet = wb.createSheet("sheet1");
			sheet.setDefaultColumnWidth(15);
			wb.setSheetName(0, (String)map.get("sheetName1"));

			// 엑셀파일 내용
			for (int i = 0; i < headerList1.size(); i++) {
				headerCell = getCell(sheet, 0, i);
				headerCell.setCellStyle(headerStyle);
				headerCell.setCellValue(headerList1.get(i).get("name"));

				if (contentList1 != null) {
					for (int j = 0; j < contentList1.size(); j++) {
						// 데이터가 null 로 넘어 올 경우 처리
						String value = String.valueOf((contentList1.get(j).get(headerList1.get(i).get("key"))));

						if (value == null || value.toLowerCase().equals("null")) {
							value = "";
						}

						listCell = getCell(sheet, j + 1, i);
						listCell.setCellStyle(listStyle);
						listCell.setCellValue(value);
					}
				}
			}

			sheet.createFreezePane(0, 1);	// 0열, 1행 고정

			XSSFSheet sheet2 = wb.createSheet("sheet2");
			sheet2.setDefaultColumnWidth(15);
			wb.setSheetName(1, (String)map.get("sheetName2"));

			// 엑셀파일 내용
			for (int i = 0; i < headerList2.size(); i++) {
				headerCell = getCell(sheet2, 0, i);
				headerCell.setCellStyle(headerStyle);
				headerCell.setCellValue(headerList2.get(i).get("name"));

				if (contentList2 != null) {
					for (int j = 0; j < contentList2.size(); j++) {
						// 데이터가 null 로 넘어 올 경우 처리
						String value = String.valueOf((contentList2.get(j).get(headerList2.get(i).get("key"))));

						if (value == null || value.toLowerCase().equals("null")) {
							value = "";
						}

						listCell = getCell(sheet2, j + 1, i);
						listCell.setCellStyle(listStyle);
						listCell.setCellValue(value);
					}
				}
			}

			sheet2.createFreezePane(0, 1);	// 0열, 1행 고정

			fileName = new String(fileName.getBytes("euc-kr"), "8859_1");

			model.put("filename", fileName);
		}
	}
}