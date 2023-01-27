package egovframework.common.web;

import org.egovframe.rte.fdl.excel.util.AbstractPOIExcelView;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.egovframe.rte.fdl.excel.util.AbstractPOIExcelView;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EgovPOIExcel extends AbstractPOIExcelView {
	private static final Logger log  = LoggerFactory.getLogger(EgovPOIExcel.class);
	
	@SuppressWarnings("unchecked")
	@Override
	protected void buildExcelDocument(Map<String, Object> model, XSSFWorkbook wb, HttpServletRequest req, HttpServletResponse resp) throws Exception {

		//header cell style 세팅 
		XSSFCell headerCell = null;
		CellStyle headerStyle = wb.createCellStyle();
		headerStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
		headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		headerStyle.setAlignment(CellStyle.ALIGN_CENTER);
		headerStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		headerStyle.setBorderBottom(CellStyle.BORDER_THIN);
		headerStyle.setBorderTop(CellStyle.BORDER_THIN);
		headerStyle.setBorderRight(CellStyle.BORDER_THIN);
		headerStyle.setBorderLeft(CellStyle.BORDER_THIN);
		
		Font headerFont = wb.createFont();
		headerFont.setBold(true);
		headerStyle.setFont(headerFont);
		
		//list cell style 세팅 
		XSSFCell listCell = null;
		CellStyle listStyle = wb.createCellStyle();
		listStyle.setBorderBottom(CellStyle.BORDER_THIN);
		listStyle.setBorderTop(CellStyle.BORDER_THIN);
		listStyle.setBorderRight(CellStyle.BORDER_THIN);
		listStyle.setBorderLeft(CellStyle.BORDER_THIN);

		
		Map<String, Object> map= (Map<String, Object>) model.get("categoryMap");
		
		String mode = (String)map.get("mode");
		
		if(mode.equals("HEADER_LIST")){
			
			List<HashMap<String, String>> headerList = (List<HashMap<String, String>>) map.get("header");
			List<HashMap<String, String>> contentList = (List<HashMap<String, String>>) map.get("list");
			
			String fileName = (String) map.get("fileName");
			
	        XSSFSheet sheet = wb.createSheet("sheet1");
	        sheet.setDefaultColumnWidth(15);
	        
	        //엑셀파일 내용 
	        for (int i = 0; i < headerList.size(); i++) {

	        	headerCell = getCell(sheet, 0, i);
	    		headerCell.setCellStyle(headerStyle);
	        	setText(headerCell, headerList.get(i).get("name"));
	        	
	        	for (int j = 0; j < contentList.size(); j++) {
	        		//데이터가 null 로 넘어 올 경우 처리
	        		String value = String.valueOf( (contentList.get(j).get(headerList.get(i).get("key"))) ) ;
	        		if(value == null || value.toLowerCase().equals( "null" )){
	        			value = "";
	        		}
	        		
	        		listCell = getCell(sheet, j + 1, i);
	        		listCell.setCellStyle(listStyle);
	        		setText(listCell, value);
				}
			}
	                
	        sheet.createFreezePane(0, 1);	// 0열, 1행 고정
	        
	        fileName = new String(fileName.getBytes("euc-kr"), "8859_1");
	        model.put("filename", fileName);
			
		} else if(mode.equals("DOUBLE_HEADER_LIST")) {
			
			List<HashMap<String, String>> headerList = (List<HashMap<String, String>>) map.get("header");
			List<HashMap<String, String>> contentList = (List<HashMap<String, String>>) map.get("list");
			
			
			String fileName = (String) map.get("fileName");
			
	        XSSFSheet sheet = wb.createSheet("sheet1");
	        sheet.setDefaultColumnWidth(15);
	        
	        List<HashMap<String, Integer>> mergeList = new ArrayList<HashMap<String, Integer>>();
	
	        
	        //엑셀파일 내용 
	        for (int i = 0; i < headerList.size(); i++) {
	        	
	        	//헤더1 
	        	headerCell = getCell(sheet, 0, i);
	    		headerCell.setCellStyle(headerStyle);
	    		HashMap<String, Integer> mergeInfo = new HashMap<String, Integer>();
	    		
	    		if(headerList.get(i).get("headerType") != null && !headerList.get(i).get("headerType").isEmpty()){
	    			
	    			mergeInfo.put("startIdx", Integer.parseInt(headerList.get(i).get("startIdx")));
    				mergeInfo.put("endIdx", Integer.parseInt(headerList.get(i).get("endIdx")));
	    			
    				
	    			if(headerList.get(i).get("headerType").equals("ROW_MERGE")){
	    				mergeInfo.put("rowMerge", 1);
	    				setText(headerCell, headerList.get(i).get("group"));
	    			} else if(headerList.get(i).get("headerType").equals("GROUP_MERGE")){
	    				mergeInfo.put("rowMerge", 0);
		    			setText(headerCell, headerList.get(i).get("group"));
	    			}
	    			
	    			mergeList.add(mergeInfo);
	    			
	    		} else {
	    			setText(headerCell, "");
	    		}
	    			    	
	        	
	        	//헤더2 
	        	headerCell = getCell(sheet, 1, i);
	    		headerCell.setCellStyle(headerStyle);
	        	setText(headerCell, headerList.get(i).get("name"));
	        	
	        	for (int j = 0; j < contentList.size(); j++) {
	        		//데이터가 null 로 넘어 올 경우 처리
	        		String value = String.valueOf( (contentList.get(j).get(headerList.get(i).get("key"))) ) ;
	        		if(value == null || value.toLowerCase().equals( "null" )){
	        			value = "";
	        		}
	        		
	        		listCell = getCell(sheet, j + 2, i);
	        		listCell.setCellStyle(listStyle);
	        		setText(listCell, value);
				}
			}
	                
	        for (HashMap<String, Integer> mergeInfo : mergeList) {
	        	sheet.addMergedRegion(new CellRangeAddress(0, mergeInfo.get("rowMerge"), mergeInfo.get("startIdx"), mergeInfo.get("endIdx")));
			}

	        sheet.createFreezePane(0, 2);	// 0열, 2행 고정
    
	        
	        fileName = new String(fileName.getBytes("euc-kr"), "8859_1");
	        model.put("filename", fileName);
			
		} else if(mode.equals("DOUBLE_HEADER_MULTI_LIST")) {
			
			List<HashMap<String, String>> headerList1 = (List<HashMap<String, String>>) map.get("header1");
			List<HashMap<String, String>> contentList1 = (List<HashMap<String, String>>) map.get("list1");
			String title1 = (String)map.get("title1");
			
			String fileName = (String) map.get("fileName");
			
	        XSSFSheet sheet = wb.createSheet("sheet1");
	        sheet.setDefaultColumnWidth(15);
	        
	        List<HashMap<String, Integer>> mergeList = new ArrayList<HashMap<String, Integer>>();
	        
	        int startRow = 0;
	        int tmpStartRow = 0;
	        
	        //첫번째 타이틀 설정 
	        setText(getCell(sheet, startRow, 0), title1);	    
	        startRow++;
	        
	        HashMap<String, String> etcInfo1 = (HashMap<String, String>)map.get("etcInfo1"); 
	        
	        if(etcInfo1 != null && !etcInfo1.isEmpty()){
	        	setText(getCell(sheet, startRow, 0), etcInfo1.get("title"));	
		        setText(getCell(sheet, startRow, 1), etcInfo1.get("info"));
		        startRow++;
	        }
	        
	        tmpStartRow = startRow;
	        
	        //엑셀파일 내용 
	        for (int i = 0; i < headerList1.size(); i++) {
	        	
	        	startRow = tmpStartRow;
	        	
	        	//헤더1 
	        	headerCell = getCell(sheet, startRow, i);
	    		headerCell.setCellStyle(headerStyle);
	    		HashMap<String, Integer> mergeInfo = new HashMap<String, Integer>();
	    		
	    		if(headerList1.get(i).get("headerType") != null && !headerList1.get(i).get("headerType").isEmpty()){
	    			
	    			mergeInfo.put("startIdx", Integer.parseInt(headerList1.get(i).get("startIdx")));
    				mergeInfo.put("endIdx", Integer.parseInt(headerList1.get(i).get("endIdx")));
	    			
    				
	    			if(headerList1.get(i).get("headerType").equals("ROW_MERGE")){
	    				mergeInfo.put("rowMergeStIdx", startRow);
	    				mergeInfo.put("rowMergeEdIdx", startRow + 1);
	    				setText(headerCell, headerList1.get(i).get("group"));
	    			} else if(headerList1.get(i).get("headerType").equals("GROUP_MERGE")){
	    				mergeInfo.put("rowMergeStIdx", startRow);
	    				mergeInfo.put("rowMergeEdIdx", startRow);
		    			setText(headerCell, headerList1.get(i).get("group"));
	    			}
	    			
	    			mergeList.add(mergeInfo);
	    			
	    		} else {
	    			setText(headerCell, "");
	    		}
	    		
	    		//헤더 1 세팅 후 시작 행 증가 
	    		startRow++;
	        	
	        	//헤더2 
	        	headerCell = getCell(sheet, startRow, i);
	    		headerCell.setCellStyle(headerStyle);
	        	setText(headerCell, headerList1.get(i).get("name"));
	        	
	        	//헤더 2 세팅 후 시작 행 증가 
	    		startRow++;
	        	
	        	for (int j = 0; j < contentList1.size(); j++) {
	        		//데이터가 null 로 넘어 올 경우 처리
	        		String value = String.valueOf( (contentList1.get(j).get(headerList1.get(i).get("key"))) ) ;
	        		if(value == null || value.toLowerCase().equals( "null" )){
	        			value = "";
	        		}
	        		
	        		listCell = getCell(sheet, j + startRow, i);
	        		listCell.setCellStyle(listStyle);
	        		setText(listCell, value);
	        		
				}
	        	
	        	startRow = startRow + contentList1.size();
			}
	        
			//테이블 사이 간격 처리
			startRow++;
			startRow++;
			
			List<HashMap<String, String>> headerList2 = (List<HashMap<String, String>>) map.get("header2");
			List<HashMap<String, String>> contentList2 = (List<HashMap<String, String>>) map.get("list2");
			String title2 = (String)map.get("title2");
			
			//두번째 타이틀 설정 
	        setText(getCell(sheet, startRow, 0), title2);	    
	        startRow++;
	        
	        HashMap<String, String> etcInfo2 = (HashMap<String, String>)map.get("etcInfo2"); 
	        
	        if(etcInfo2 != null && !etcInfo2.isEmpty()){
	        	setText(getCell(sheet, startRow, 0), etcInfo2.get("title"));	
		        setText(getCell(sheet, startRow, 1), etcInfo2.get("info"));
		        startRow++;
	        }
	        
	        tmpStartRow = startRow;
	        
	        //엑셀파일 내용 
	        for (int i = 0; i < headerList2.size(); i++) {
	        	
	        	startRow = tmpStartRow;
	        	
	        	//헤더1 
	        	headerCell = getCell(sheet, startRow, i);
	    		headerCell.setCellStyle(headerStyle);
	    		HashMap<String, Integer> mergeInfo = new HashMap<String, Integer>();
	    		
	    		if(headerList2.get(i).get("headerType") != null && !headerList2.get(i).get("headerType").isEmpty()){
	    			
	    			mergeInfo.put("startIdx", Integer.parseInt(headerList2.get(i).get("startIdx")));
    				mergeInfo.put("endIdx", Integer.parseInt(headerList2.get(i).get("endIdx")));
	    			
    				
	    			if(headerList2.get(i).get("headerType").equals("ROW_MERGE")){
	    				mergeInfo.put("rowMergeStIdx", startRow);
	    				mergeInfo.put("rowMergeEdIdx", startRow + 1);
	    				setText(headerCell, headerList2.get(i).get("group"));
	    			} else if(headerList2.get(i).get("headerType").equals("GROUP_MERGE")){
	    				mergeInfo.put("rowMergeStIdx", startRow);
	    				mergeInfo.put("rowMergeEdIdx", startRow);
		    			setText(headerCell, headerList2.get(i).get("group"));
	    			}
	    			
	    			mergeList.add(mergeInfo);
	    			
	    		} else {
	    			setText(headerCell, "");
	    		}
	    		
	    		//헤더 1 세팅 후 시작 행 증가 
	    		startRow++;
	        	
	        	//헤더2 
	        	headerCell = getCell(sheet, startRow, i);
	    		headerCell.setCellStyle(headerStyle);
	        	setText(headerCell, headerList2.get(i).get("name"));
	        	
	        	//헤더 2 세팅 후 시작 행 증가 
	    		startRow++;
	        	
	        	for (int j = 0; j < contentList2.size(); j++) {
	        		//데이터가 null 로 넘어 올 경우 처리
	        		String value = String.valueOf( (contentList2.get(j).get(headerList2.get(i).get("key"))) ) ;
	        		if(value == null || value.toLowerCase().equals( "null" )){
	        			value = "";
	        		}
	        		
	        		listCell = getCell(sheet, j + startRow, i);
	        		listCell.setCellStyle(listStyle);
	        		setText(listCell, value);
	        		
				}
	        	
	        	startRow = startRow + contentList1.size();
			}
	        
	        //머지 설정 
	        for (HashMap<String, Integer> mergeInfo : mergeList) {
	        	sheet.addMergedRegion(new CellRangeAddress(mergeInfo.get("rowMergeStIdx"), mergeInfo.get("rowMergeEdIdx"), mergeInfo.get("startIdx"), mergeInfo.get("endIdx")));
			}
	          
	        
	        fileName = new String(fileName.getBytes("euc-kr"), "8859_1");
	        model.put("filename", fileName);
			
		}else if (mode.equals("MULTI_SHEET")){
			List<HashMap<String, String>> headerList = (List<HashMap<String, String>>) map.get("header");
			List<HashMap<String, String>> contentList = (List<HashMap<String, String>>) map.get("list");
			List<HashMap<String, String>> headerList2 = (List<HashMap<String, String>>) map.get("header2");
			List<HashMap<String, String>> contentList2 = (List<HashMap<String, String>>) map.get("list2");

			String fileName = (String) map.get("fileName");

			XSSFSheet sheet = wb.createSheet("sheet1");
			sheet.setDefaultColumnWidth(15);

			//엑셀파일 내용
			for (int i = 0; i < headerList.size(); i++) {

				headerCell = getCell(sheet, 0, i);
				headerCell.setCellStyle(headerStyle);
				setText(headerCell, headerList.get(i).get("name"));

				for (int j = 0; j < contentList.size(); j++) {
					//데이터가 null 로 넘어 올 경우 처리
					String value = String.valueOf( (contentList.get(j).get(headerList.get(i).get("key"))) ) ;
					if(value == null || value.toLowerCase().equals( "null" )){
						value = "";
					}

					listCell = getCell(sheet, j + 1, i);
					listCell.setCellStyle(listStyle);
					setText(listCell, value);
				}
			}

			sheet.createFreezePane(0, 1);	// 0열, 1행 고정


			XSSFSheet sheet2 = wb.createSheet("sheet2");
			sheet2.setDefaultColumnWidth(15);

			//엑셀파일 내용
			for (int i = 0; i < headerList2.size(); i++) {

				headerCell = getCell(sheet2, 0, i);
				headerCell.setCellStyle(headerStyle);
				setText(headerCell, headerList2.get(i).get("name"));

				for (int j = 0; j < contentList2.size(); j++) {
					//데이터가 null 로 넘어 올 경우 처리
					String value = String.valueOf( (contentList2.get(j).get(headerList2.get(i).get("key"))) ) ;
					if(value == null || value.toLowerCase().equals( "null" )){
						value = "";
					}

					listCell = getCell(sheet2, j + 1, i);
					listCell.setCellStyle(listStyle);
					setText(listCell, value);
				}
			}

			sheet2.createFreezePane(0, 1);	// 0열, 1행 고정

			fileName = new String(fileName.getBytes("euc-kr"), "8859_1");
			model.put("filename", fileName);
		}






	}
}
