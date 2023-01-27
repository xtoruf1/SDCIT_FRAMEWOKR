package egovframework.common.util;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jdom2.CDATA;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.view.AbstractView;

public class XmlWorker extends AbstractView {
	private String encoding = "utf-8";
		
	public void setEncoding(String encoding) {
		this.encoding = encoding;
	}

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {		
		Format format = Format.getRawFormat();
		format.setEncoding(this.encoding);

		XMLOutputter outputter = new XMLOutputter();
		outputter.setFormat(format);
		Document doc = new Document();
		
		String resultType = ServletRequestUtils.getStringParameter(request, "result_type", "SUCCESS");
		String requestURI = request.getRequestURI();
		String event = ServletRequestUtils.getStringParameter(request, "event_sdcit", "");
		String params = ParamUtil.getParams(request).toString();
		
		Element result = new Element("RESULT");
		result.setAttribute("type",resultType);
		
		Element req = new Element("REQUEST");
		result.addContent(req);
		req.setText(params);
		req.setAttribute("uri",requestURI);
		req.setAttribute("event",event);
		
		Element success = new Element("SUCCESS");
		result.addContent(success);
		success.setText(""+(String)model.get("MESSAGE"));
		success.setAttribute("value",""+model.get("SUCCESS"));
		
		if (resultType.equalsIgnoreCase("SELECT") || resultType.equalsIgnoreCase("VALUEOBJECT")) {
			@SuppressWarnings("unchecked")
			HashMap<String, String> vo = (HashMap<String, String>)model.get(resultType);
			int cols = 0;
			
			if (vo != null) {
				cols = vo.size();
			}
			
			Element voElement = new Element("VALUE-OBJECT");
			result.addContent(voElement);
			voElement.setAttribute("size", "" + cols);
			
			if (vo != null) {
				Set<String> key = vo.keySet();
				for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
					String keyName = "" + (String)iterator.next();
					String valueName = WebUtil.clearXSSMinimum2(String.valueOf(vo.get(keyName)));
					
					if (keyName.equals("CO_NM_CH") || keyName.equals("CEO_NM_CH") || keyName.equals("USER_NM_CH") || keyName.indexOf("ATT_") >= 0) {
						valueName = String.valueOf(vo.get(keyName));
					}
					
					Element valElement = new Element("VALUE");
					voElement.addContent(valElement);
					valElement.addContent(new CDATA(valueName));
					valElement.setAttribute("name", keyName);
				}
			}			
		} else if (resultType.equalsIgnoreCase("ROWSET")) {
			@SuppressWarnings("unchecked")
			List<HashMap<String, String>> rowSet = (List<HashMap<String, String>>)model.get(resultType);
			int cols = 0;
			int rows = 0;
			if (rowSet != null && rowSet.size() > 0) {
				HashMap<String, String> tempVo = rowSet.get(0);
				cols = tempVo.size();
				rows = rowSet.size();
			}
			
			Element rowSetElement = new Element("ROW-SET");
			result.addContent(rowSetElement);
			rowSetElement.setAttribute("cols", "" + cols);
			rowSetElement.setAttribute("rows", "" + rows);
			
			if (rowSet != null && rowSet.size() > 0) {
				for (int row = 0; row < rowSet.size(); row++) {
					Element rowElement = new Element("ROW");
					rowSetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);
					
					HashMap<String, String> vo = (HashMap<String, String>)rowSet.get(row);
					Set<String> key = vo.keySet();
					
					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = ""+(String) iterator.next();
						String valueName = WebUtil.clearXSSMinimum2(String.valueOf(vo.get(keyName)));
						
						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}					
				}
			}
		} else if (resultType.equalsIgnoreCase("ROW_ROW")) {
			@SuppressWarnings("unchecked")
			List<HashMap<String, String>> rowSet = (List<HashMap<String, String>>)model.get("ROWSET");
			int cols = 0;
			int rows = 0;
			if (rowSet != null && rowSet.size() > 0) {
				HashMap<String, String> tempVo = rowSet.get(0);
				cols = tempVo.size();
				rows = rowSet.size();
			}
			
			Element rowSetElement = new Element("ROW-SET");
			result.addContent(rowSetElement);
			rowSetElement.setAttribute("cols", "" + cols);
			rowSetElement.setAttribute("rows", "" + rows);

			if (rowSet != null && rowSet.size() > 0) {
				for (int row = 0; row < rowSet.size(); row++) {
					Element rowElement = new Element("ROW");
					rowSetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);

					HashMap<String, String> vo = (HashMap<String, String>) rowSet.get(row);
					Set<String> key = vo.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = "" + (String)iterator.next();
						String valueName = WebUtil.clearXSSMinimum2(String.valueOf(vo.get(keyName)));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}
                    
			List<HashMap<String, String>> rowSet2 = (List<HashMap<String, String>>)model.get("ROWSET2");
			Element row2SetElement = new Element("ROW-SET2");
			int cols2 = 0;
			int rows2 = 0;
			
			if (rowSet2 != null && rowSet2.size() > 0) {
				HashMap<String, String> tempVo = rowSet2.get(0);
				cols2 = tempVo.size();
				rows2 = rowSet2.size();
			}
			
			result.addContent(row2SetElement);
			row2SetElement.setAttribute("cols", "" + cols2);
			row2SetElement.setAttribute("rows", "" + rows2);

			if (rowSet2 != null && rowSet2.size() > 0) {
				for (int row = 0; row < rowSet2.size(); row++) {
					Element rowElement = new Element("ROW");
					row2SetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);

					HashMap<String, String> vo = (HashMap<String, String>)rowSet2.get(row);
					Set<String> key = vo.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = "" + (String)iterator.next();
						String valueName = WebUtil.clearXSSMinimum2(String.valueOf(vo.get(keyName)));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}       
		} else if (resultType.equalsIgnoreCase("ROW4_VO")) {
		    @SuppressWarnings("unchecked")
		    HashMap<String, String> vo = (HashMap<String, String>)model.get("VALUEOBJECT");
		    int cols = 0;
		    if (vo != null) {
		    	cols = vo.size();
		    }

			Element voElement = new Element("VALUE-OBJECT");
			result.addContent(voElement);
			voElement.setAttribute("size", "" + cols);
			
			if (vo != null) {
				Set<String> key = vo.keySet();
				for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
					String keyName = "" + (String)iterator.next();
					String valueName = WebUtil.clearXSSMinimum2(String.valueOf(vo.get(keyName)));

					Element valElement = new Element("VALUE");
					voElement.addContent(valElement);
					valElement.addContent(new CDATA(valueName));
					valElement.setAttribute("name", keyName);
				}
			}
                    
			List<HashMap<String, String>> rowSet = (List<HashMap<String, String>>)model.get("ROWSET");
			int cols1 = 0;
			int rows1 = 0;
			
			if (rowSet != null && rowSet.size() > 0) {
				HashMap<String, String> tempVo = rowSet.get(0);
				cols1 = tempVo.size();
				rows1 = rowSet.size();
			}
			
			Element rowSetElement = new Element("ROW-SET");
			result.addContent(rowSetElement);
			rowSetElement.setAttribute("cols", "" + cols1);
			rowSetElement.setAttribute("rows", "" + rows1);

			if (rowSet != null && rowSet.size() > 0) {
				for (int row = 0; row < rowSet.size(); row++) {
					Element rowElement = new Element("ROW");
					rowSetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);

					HashMap<String, String> vo1 = (HashMap<String, String>)rowSet.get(row);
					Set<String> key = vo1.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = "" + (String)iterator.next();
						String valueName = WebUtil.clearXSSMinimum2(String.valueOf(vo1.get(keyName)));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}
                    
			List<HashMap<String, String>> rowSet2 = (List<HashMap<String, String>>)model.get("ROWSET2");
			Element row2SetElement = new Element("ROW-SET2");
			int cols2 = 0;
			int rows2 = 0;
			if (rowSet2 != null && rowSet2.size() > 0) {
				HashMap<String, String> tempVo = rowSet2.get(0);
				cols2 = tempVo.size();
				rows2 = rowSet2.size();
			}
			
			result.addContent(row2SetElement);
			row2SetElement.setAttribute("cols", "" + cols2);
			row2SetElement.setAttribute("rows", "" + rows2);

			if (rowSet2 != null && rowSet2.size() > 0) {
				for (int row = 0; row < rowSet2.size(); row++) {
					Element rowElement = new Element("ROW");
					row2SetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);

					HashMap<String, String> vo2 = (HashMap<String, String>)rowSet2.get(row);
					Set<String> key = vo2.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = "" + (String)iterator.next();
						String valueName = WebUtil.clearXSSMinimum2(String.valueOf(vo2.get(keyName)));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}
                    
			List<HashMap<String, String>> rowSet3 = (List<HashMap<String, String>>)model.get("ROWSET3");
			Element row3SetElement = new Element("ROW-SET3");
			int cols3 = 0;
			int rows3 = 0;
			if (rowSet3 != null && rowSet3.size() > 0) {
				HashMap<String, String> tempVo = rowSet3.get(0);
				cols3 = tempVo.size();
				rows3 = rowSet3.size();
			}
			
			result.addContent(row3SetElement);
			row3SetElement.setAttribute("cols", "" + cols3);
			row3SetElement.setAttribute("rows", "" + rows3);

			if (rowSet3 != null && rowSet3.size() > 0) {
				for (int row = 0; row < rowSet3.size(); row++) {
					Element rowElement = new Element("ROW");
					row3SetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);

					HashMap<String, String> vo2 = (HashMap<String, String>)rowSet3.get(row);
					Set<String> key = vo2.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = "" + (String)iterator.next();
						String valueName = WebUtil.clearXSSMinimum2(String.valueOf(vo2.get(keyName)));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}
                    
			List<HashMap<String, String>> rowSet4 = (List<HashMap<String, String>>)model.get("ROWSET4");
			Element row4SetElement = new Element("ROW-SET4");
			int cols4 = 0;
			int rows4 = 0;
			if (rowSet4 != null && rowSet4.size() > 0) {
				HashMap<String, String> tempVo = rowSet4.get(0);
				cols4 = tempVo.size();
				rows4 = rowSet4.size();
			}
			
			result.addContent(row4SetElement);
			row4SetElement.setAttribute("cols", "" + cols4);
			row4SetElement.setAttribute("rows", "" + rows4);

			if (rowSet4 != null && rowSet4.size() > 0) {
				for (int row = 0; row < rowSet4.size(); row++) {
					Element rowElement = new Element("ROW");
					row4SetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);

					HashMap<String, String> vo2 = (HashMap<String, String>) rowSet4.get(row);
					Set<String> key = vo2.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = "" + (String)iterator.next();
						String valueName = WebUtil.clearXSSMinimum2(String.valueOf(vo2.get(keyName)));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}
		} else if (resultType.equalsIgnoreCase("ROW6_VO")) {
			@SuppressWarnings("unchecked")
			HashMap<String, String> vo = (HashMap<String, String>)model.get("VALUEOBJECT");
			int cols = 0;
			if (vo != null) {
				cols = vo.size();
			}

			Element voElement = new Element("VALUE-OBJECT");
			result.addContent(voElement);
			voElement.setAttribute("size", "" + cols);
			
			if (vo != null) {
				Set<String> key = vo.keySet();
				for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
					String keyName = "" + (String)iterator.next();
					String valueName = WebUtil.clearXSSMinimum2(String.valueOf(vo.get(keyName)));

					Element valElement = new Element("VALUE");
					voElement.addContent(valElement);
					valElement.addContent(new CDATA(valueName));
					valElement.setAttribute("name", keyName);
				}
			}
            
			List<HashMap<String, String>> rowSet = (List<HashMap<String, String>>)model.get("ROWSET");
			int cols1 = 0;
			int rows1 = 0;
			if (rowSet != null && rowSet.size() > 0) {
				HashMap<String, String> tempVo = rowSet.get(0);
				cols1 = tempVo.size();
				rows1 = rowSet.size();
			}
			
			Element rowSetElement = new Element("ROW-SET");
			result.addContent(rowSetElement);
			rowSetElement.setAttribute("cols", "" + cols1);
			rowSetElement.setAttribute("rows", "" + rows1);

			if (rowSet != null && rowSet.size() > 0) {
				for (int row = 0; row < rowSet.size(); row++) {
					Element rowElement = new Element("ROW");
					rowSetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);

					HashMap<String, String> vo1 = (HashMap<String, String>)rowSet.get(row);
					Set<String> key = vo1.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = "" + (String)iterator.next();
						String valueName = String.valueOf(vo1.get(keyName));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}
            
			List<HashMap<String, String>> rowSet2 = (List<HashMap<String, String>>)model.get("ROWSET2");
			Element row2SetElement = new Element("ROW-SET2");
			int cols2 = 0;
			int rows2 = 0;
			if (rowSet2 != null && rowSet2.size() > 0) {
				HashMap<String, String> tempVo = rowSet2.get(0);
				cols2 = tempVo.size();
				rows2 = rowSet2.size();
			}
			
			result.addContent(row2SetElement);
			row2SetElement.setAttribute("cols", "" + cols2);
			row2SetElement.setAttribute("rows", "" + rows2);

			if (rowSet2 != null && rowSet2.size() > 0) {
				for (int row = 0; row < rowSet2.size(); row++) {
					Element rowElement = new Element("ROW");
					row2SetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);

					HashMap<String, String> vo2 = (HashMap<String, String>) rowSet2.get(row);
					Set<String> key = vo2.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = ""+(String) iterator.next();
						String valueName = String.valueOf(vo2.get(keyName));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}
            
            List<HashMap<String, String>> rowSet3 = (List<HashMap<String, String>>)model.get("ROWSET3");
            Element row3SetElement = new Element("ROW-SET3");
            int cols3 = 0;
            int rows3 = 0;
            if (rowSet3 != null && rowSet3.size() > 0) {
				HashMap<String, String> tempVo = rowSet3.get(0);
				cols3 = tempVo.size();
				rows3 = rowSet3.size();
            }
            
			result.addContent(row3SetElement);
			row3SetElement.setAttribute("cols", "" + cols3);
			row3SetElement.setAttribute("rows", "" + rows3);

			if (rowSet3 != null && rowSet3.size() > 0) {
				for (int row = 0; row < rowSet3.size(); row++) {
					Element rowElement = new Element("ROW");
					row3SetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);

					HashMap<String, String> vo2 = (HashMap<String, String>)rowSet3.get(row);
					Set<String> key = vo2.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = "" + (String)iterator.next();
						String valueName = String.valueOf(vo2.get(keyName));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}
            
			List<HashMap<String, String>> rowSet4 = (List<HashMap<String, String>>)model.get("ROWSET4");
			Element row4SetElement = new Element("ROW-SET4");
			int cols4 = 0;
			int rows4 = 0;
			if (rowSet4 != null && rowSet4.size() > 0) {
				HashMap<String, String> tempVo = rowSet4.get(0);
				cols4 = tempVo.size();
				rows4 = rowSet4.size();
			}
			
			result.addContent(row4SetElement);
			row4SetElement.setAttribute("cols", "" + cols4);
			row4SetElement.setAttribute("rows", "" + rows4);

			if (rowSet4 != null && rowSet4.size() > 0) {
				for (int row = 0; row < rowSet4.size(); row++) {
					Element rowElement = new Element("ROW");
					row4SetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);

					HashMap<String, String> vo2 = (HashMap<String, String>)rowSet4.get(row);
					Set<String> key = vo2.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = "" + (String)iterator.next();
						String valueName = String.valueOf(vo2.get(keyName));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}
            
			List<HashMap<String, String>> rowSet5 = (List<HashMap<String, String>>)model.get("ROWSET5");
			Element row5SetElement = new Element("ROW-SET5");
			int cols5 = 0;
			int rows5 = 0;
			if (rowSet5 != null && rowSet5.size() > 0) {
				HashMap<String, String> tempVo = rowSet5.get(0);
				cols5 = tempVo.size();
				rows5 = rowSet5.size();
			}
			
			result.addContent(row5SetElement);
			row5SetElement.setAttribute("cols", "" + cols5);
			row5SetElement.setAttribute("rows", "" + rows5);

			if (rowSet5 != null && rowSet5.size() > 0) {
				for (int row = 0; row < rowSet5.size(); row++) {
					Element rowElement = new Element("ROW");
					row5SetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);

					HashMap<String, String> vo2 = (HashMap<String, String>)rowSet5.get(row);
					Set<String> key = vo2.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = "" + (String)iterator.next();
						String valueName = String.valueOf(vo2.get(keyName));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}
            
			List<HashMap<String, String>> rowSet6 = (List<HashMap<String, String>>)model.get("ROWSET6");
			Element row6SetElement = new Element("ROW-SET6");
			int cols6 = 0;
			int rows6 = 0;
			if (rowSet6 != null && rowSet6.size() > 0) {
				HashMap<String, String> tempVo = rowSet6.get(0);
				cols6 = tempVo.size();
				rows6 = rowSet6.size();
			}
			
			result.addContent(row6SetElement);
			row6SetElement.setAttribute("cols", "" + cols6);
			row6SetElement.setAttribute("rows", "" + rows6);

			if (rowSet6 != null && rowSet6.size() > 0) {
				for (int row = 0; row < rowSet6.size(); row++) {
					Element rowElement = new Element("ROW");
					row6SetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);

					HashMap<String, String> vo2 = (HashMap<String, String>)rowSet6.get(row);
					Set<String> key = vo2.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = "" + (String)iterator.next();
						String valueName = String.valueOf(vo2.get(keyName));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}
		} else if (resultType.equalsIgnoreCase("ROW_VO")) {
			@SuppressWarnings("unchecked")
			HashMap<String, String> vo = (HashMap<String, String>)model.get("VALUEOBJECT");
			int cols = 0;
			if (vo != null) {
				cols = vo.size();
			}

			Element voElement = new Element("VALUE-OBJECT");
			result.addContent(voElement);
			voElement.setAttribute("size", "" + cols);
			if (vo != null) {
				Set<String> key = vo.keySet();
				for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
					String keyName = "" + (String)iterator.next();
					String valueName = WebUtil.clearXSSMinimum2(String.valueOf(vo.get(keyName)));

					Element valElement = new Element("VALUE");
					voElement.addContent(valElement);
					valElement.addContent(new CDATA(valueName));
					valElement.setAttribute("name", keyName);
				}
			}
                            
			List<HashMap<String, String>> rowSet = (List<HashMap<String, String>>)model.get("ROWSET");
			cols = 0;
			int rows = 0;
			if (rowSet != null && rowSet.size() > 0) {
				HashMap<String, String> tempVo = rowSet.get(0);
				cols = tempVo.size();
				rows = rowSet.size();
			}
			
			Element rowSetElement = new Element("ROW-SET");
			result.addContent(rowSetElement);
			rowSetElement.setAttribute("cols", "" + cols);
			rowSetElement.setAttribute("rows", "" + rows);

			if (rowSet != null && rowSet.size() > 0) {
				for (int row = 0; row < rowSet.size(); row++) {
					Element rowElement = new Element("ROW");
					rowSetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);
					
					HashMap<String, String> vomap = (HashMap<String, String>)rowSet.get(row);
					Set<String> key = vomap.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = "" + (String)iterator.next();
						String valueName = String.valueOf(vomap.get(keyName));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}
		} else if (resultType.equalsIgnoreCase("ROW7_VO")) {
			@SuppressWarnings("unchecked")
			List<HashMap<String, String>> rowSet = (List<HashMap<String, String>>) model.get("ROWSET");
			int cols = 0;
			int rows = 0;
			if (rowSet != null && rowSet.size() > 0) {
				HashMap<String, String> tempVo = rowSet.get(0);
				cols = tempVo.size();
				rows = rowSet.size();
			}
			
			Element rowSetElement = new Element("ROW-SET");
			result.addContent(rowSetElement);
			rowSetElement.setAttribute("cols", "" + cols);
			rowSetElement.setAttribute("rows", "" + rows);

			if (rowSet != null && rowSet.size() > 0) {
				for (int row = 0; row < rowSet.size(); row++) {
					Element rowElement = new Element("ROW");
					rowSetElement.addContent(rowElement);
					rowElement.setAttribute("index", "" + row);
					
					HashMap<String, String> vomap = (HashMap<String, String>)rowSet.get(row);
					Set<String> key = vomap.keySet();

					for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
						String keyName = "" + (String) iterator.next();
						String valueName = String.valueOf(vomap.get(keyName));

						Element colElement = new Element("COLUMN");
						rowElement.addContent(colElement);
						colElement.addContent(new CDATA(valueName));
						colElement.setAttribute("name", keyName);
					}
				}
			}
		}
		
		doc.setRootElement(result);
		
		response.setContentType("text/xml; charset=utf-8");
		response.setHeader("Cache-Control", "no-cache");
		
		outputter.output(doc, response.getOutputStream());
	}
}