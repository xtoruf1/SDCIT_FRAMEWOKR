package egovframework.common;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.MultipartFile;

public class ExcelManager {
    private int mStartRow = 1;
    private int mStartCol = 1;
    private int mWidth = 5000;

    private IndexedColors mHeaderColor =  IndexedColors.LIGHT_CORNFLOWER_BLUE;
    private IndexedColors mDataColor =  IndexedColors.WHITE;

    private HSSFWorkbook mWorkbook;

    private XSSFWorkbook xWorkbook;

    private String mSheetName = "sheet1";

    private List<Object> mHeader;
    private List<List<Object>> mData;

    private FileInputStream mReadFile;


    public ExcelManager(List<Object> header, List<List<Object>> data) {
        mHeader = header;
        mData = data;
    }

    public ExcelManager() {

    }

    public void setStartRow(int startRow) {
        mStartRow = startRow;
    }

    public void setStartCol(int startCol) {
        mStartCol = startCol;
    }

    public void setSheetName(String sheetName) {
        mSheetName = sheetName;
    }

    public void setWidth(int width) {
        mWidth = width;
    }

    public void setHeaderColor(IndexedColors headerColor) {
        mHeaderColor = headerColor;
    }

    public void setDataColor(IndexedColors dataColor) {
        mDataColor = dataColor;
    }


    public List<List<Object>> readExcel(MultipartFile file){
    	List<List<Object>> excelData = new ArrayList<List<Object>>();
    	List<Object> cellData = null;

        try {
			mWorkbook = new HSSFWorkbook(file.getInputStream());
			HSSFSheet sheet    =  null;
			HSSFRow row     =  null;
			HSSFCell cell    =  null;

			FormulaEvaluator evaluator = mWorkbook.getCreationHelper().createFormulaEvaluator();
			String data = "";

			int sheetNum =  mWorkbook.getNumberOfSheets();
			for(int i=0;i<sheetNum;i++){//시트가 여러개 있을 경우
			    sheet = mWorkbook.getSheetAt(i);

			    int lastRowNum = sheet.getLastRowNum();
			    for(int r=sheet.getFirstRowNum();r<=lastRowNum;r++){//row를 읽는다.
			    	row = sheet.getRow(r);
			        if(row== null) continue;

		    		int lastCellNum = row.getLastCellNum();
			        cellData = new ArrayList<Object>();
			        for(int c=0;c<lastCellNum;c++){//cell을 읽는다.
				        cell   =  row.getCell(c);
				        //if(cell== null) continue;
				        if(cell== null) {cellData.add(""); continue;}

				        switch(cell.getCellType()){
					        case HSSFCell.CELL_TYPE_NUMERIC:
//					        	cellData.add(cell.getNumericCellValue());
					        	cellData.add(new BigDecimal(cell.getNumericCellValue()).toPlainString());
					        	break;
					        case HSSFCell.CELL_TYPE_STRING:
					        	cellData.add(cell.getStringCellValue());
					        	break;
					        case HSSFCell.CELL_TYPE_FORMULA :
					        	//cellData.add(cell.getCellFormula());
					        	if(!(cell.toString().equalsIgnoreCase("")) ){
					        		if(evaluator.evaluateFormulaCell(cell)==HSSFCell.CELL_TYPE_NUMERIC){
					        			if( HSSFDateUtil.isCellDateFormatted(cell) ){
					        				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
					        				data = formatter.format(cell.getDateCellValue());
					        			}else {
					        				double fddata = cell.getNumericCellValue();
					        				DecimalFormat df = new DecimalFormat();
					        				data = df.format(fddata);
					        			}
					        		}else if(evaluator.evaluateFormulaCell(cell)==HSSFCell.CELL_TYPE_STRING){
					        			data = cell.getStringCellValue();
					        		}else if(evaluator.evaluateFormulaCell(cell)==HSSFCell.CELL_TYPE_BOOLEAN){
					        			boolean fbdata = cell.getBooleanCellValue();
					        			data = String.valueOf(fbdata);
					        		}
					        		cellData.add(data);
					        	}
					        	break;
					        default:
					        	cellData.add("");
				       }
			        }
				    excelData.add(cellData);
			    }

			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return excelData;
    }

    public List<List<Object>> readExcel2(MultipartFile file){
    	List<List<Object>> excelData = new ArrayList<List<Object>>();
    	List<Object> cellData = null;
    	try {
    		xWorkbook = new XSSFWorkbook(file.getInputStream());
    		XSSFSheet sheet    =  null;
    		XSSFRow row     =  null;
    		XSSFCell cell    =  null;

    		FormulaEvaluator evaluator = xWorkbook.getCreationHelper().createFormulaEvaluator();
    		String data = "";

    		int sheetNum =  xWorkbook.getNumberOfSheets();
    		for(int i=0;i<1;i++){//시트가 여러개 있을 경우(무체물 첫번째 sheet만 입력되기위해 강제로1값)
    			sheet = xWorkbook.getSheetAt(i);

    			int lastRowNum = sheet.getLastRowNum();
    			for(int r=sheet.getFirstRowNum();r<=lastRowNum;r++){//row를 읽는다.
    				row = sheet.getRow(r);
    				if(row== null) continue;

    				int lastCellNum = row.getLastCellNum();
    				cellData = new ArrayList<Object>();
    				for(int c=0;c<lastCellNum;c++){//cell을 읽는다.
    					cell   =  row.getCell(c);
    					//if(cell== null) continue;
    					if(cell== null) {cellData.add(""); continue;}

    					switch(cell.getCellType()){
    					case XSSFCell.CELL_TYPE_NUMERIC:
//					        	cellData.add(cell.getNumericCellValue());
    						cellData.add(new BigDecimal(cell.getNumericCellValue()).toPlainString());
    						break;
    					case XSSFCell.CELL_TYPE_STRING:
    						cellData.add(cell.getStringCellValue());
    						break;
    					case XSSFCell.CELL_TYPE_FORMULA :
    						//cellData.add(cell.getCellFormula());
    						if(!(cell.toString().equalsIgnoreCase("")) ){
    							if(evaluator.evaluateFormulaCell(cell)==XSSFCell.CELL_TYPE_NUMERIC){
    								double fddata = cell.getNumericCellValue();
    								DecimalFormat df = new DecimalFormat();
    								data = df.format(fddata);
    							}else if(evaluator.evaluateFormulaCell(cell)==XSSFCell.CELL_TYPE_STRING){
    								data = cell.getStringCellValue();
    							}else if(evaluator.evaluateFormulaCell(cell)==XSSFCell.CELL_TYPE_BOOLEAN){
    								boolean fbdata = cell.getBooleanCellValue();
    								data = String.valueOf(fbdata);
    							}
    							cellData.add(data);
    						}
    						break;
    					default:
    						cellData.add("");
    					}
    				}
    				excelData.add(cellData);
    			}

    		}
    	} catch (FileNotFoundException e) {
    		e.printStackTrace();
    	} catch (IOException e) {
    		e.printStackTrace();
    	}

    	return excelData;
    }

    private void setCell(HSSFCell headerCell, String data, short index) {
        headerCell.setCellValue(data);

        HSSFCellStyle cellStyle = mWorkbook.createCellStyle();

        cellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        cellStyle.setBottomBorderColor(IndexedColors.BLACK.getIndex());

        cellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        cellStyle.setLeftBorderColor(IndexedColors.BLACK.getIndex());

        cellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
        cellStyle.setRightBorderColor(IndexedColors.BLACK.getIndex());

        cellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
        cellStyle.setTopBorderColor(IndexedColors.BLACK.getIndex());

        cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        cellStyle.setFillForegroundColor(index);

        cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);

        headerCell.setCellStyle(cellStyle);
    }


    public List<List<Object>> readExcelAll(MultipartFile file, String fileExt){
    	List<List<Object>> excelData = new ArrayList<List<Object>>();
    	List<Object> cellData = null;
    	Workbook tempWorkbook;
    	DataFormatter formatter = new DataFormatter();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");


    	try {
    		if( ".xls".equals(fileExt) ){
    			tempWorkbook = new HSSFWorkbook(file.getInputStream());
    		}else if( ".xlsx".equals(fileExt) ){
    			tempWorkbook = new XSSFWorkbook(file.getInputStream());
    		}else {
    			throw new IllegalAccessError("xls , xlsx 확장자만 읽을 수 있습니다.");
    		}

    		try (Workbook workbook = tempWorkbook) {
    			Sheet sheet = workbook.getSheetAt(0);
    			for (Row row : sheet) {

					// cell (행의 각 열) 을 가져옵니다.
    				cellData = new ArrayList<Object>();
    				for( int i = 0; i < row.getLastCellNum(); i++ ){
    					Cell cell = row.getCell(i);
    					String value;

    					if( i == 0 && cell == null ){
    						break;
    					}

    					if( cell != null ){
    						// 날짜형 예외
							if (HSSFDateUtil.isInternalDateFormat(cell.getCellStyle().getDataFormat())) {
								value = sdf.format(cell.getDateCellValue());
							}else {
								value = formatter.formatCellValue(cell);
							}
    					} else{
    						value = "";
    					}

						cellData.add(value);
						System.out.print(value);
						System.out.print(" || ");
    				}

    				if( excelData.size() > 780 ){
    					System.out.println("asd");
    					System.out.println(sheet.getLastRowNum());
    				}

    				if( cellData!= null && cellData.size() > 0 ) {
    					excelData.add(cellData);
    					System.out.println();
    				}
				}

    		}

    	} catch (FileNotFoundException e) {
    		e.printStackTrace();
    	} catch (IOException e) {
    		e.printStackTrace();
    	}

    	return excelData;
    }
}