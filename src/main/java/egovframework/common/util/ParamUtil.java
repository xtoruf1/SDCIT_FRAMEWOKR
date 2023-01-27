package egovframework.common.util;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

public class ParamUtil {
	/**
	 * request 파라미터의 개수가 1개인 파라미터들만 HashMap에 담는다
	 * @param request
	 * @return HashMap
	 */
	public static HashMap<String, String> getMap(HttpServletRequest request) {		
		HashMap<String, String> map = new HashMap<String, String>();
		Enumeration<String> pNameArr = request.getParameterNames();
		List<String> paramName = new ArrayList<String>();
		
		while(pNameArr.hasMoreElements()) {
			String pName = pNameArr.nextElement();
			paramName.add(pName);
		}
		
		for (int i = 0; i < paramName.size(); i++) {
			if (request.getParameterValues(paramName.get(i)).length == 1) {
				String pramValue = request.getParameterValues(paramName.get(i))[0];
				map.put(paramName.get(i), pramValue);
			}
		}
		
		return map;
	}
	
	public static String cvtHTML(String str) {
		StringBuffer sb = new StringBuffer();

		int len = (str != null) ? str.length() : 0;
		for (int i = 0; i < len; i++) {
			char ch = str.charAt(i);
			
			switch (ch) {
				case '<':
					sb.append("&lt;");
					
					break;
				case '>':
					sb.append("&gt;");
					
					break;
				case '&':
					sb.append("&amp;");
					
					break;
				case '"':
					sb.append("&quot;");
					
					break;
				case '\'':
					sb.append("&acute;");
					
					break;
				case '\t':
					sb.append("&nbsp;&nbsp;&nbsp;&nbsp;");
					
					break;
				case '\n':
					sb.append("<br>");
					
					break;
				default:
					sb.append(ch);
			}
		}
		
		return sb.toString();
	}
	
	public static String cvtHTML4(String str) {
		StringBuffer sb = new StringBuffer();

		int len = (str != null) ? str.length() : 0;
		
		for (int i = 0; i < len; i++) {
        	char ch = str.charAt(i);
        	
        	switch (ch) {
				case ' ':
					sb.append("&nbsp;");
					
					break;
				case '<':
					sb.append("&lt;");
					
					break;
				case '>':
					sb.append("&gt;");
					
					break;
				case '&':
					sb.append("&amp;");
					
					break;
				case '"':
					sb.append("&quot;");
					
					break;
				case '\'':
					sb.append("&acute;");
					
					break;
				case '\t':
					sb.append("&nbsp;&nbsp;&nbsp;&nbsp;");
					
					break;
				case '\n':
					sb.append("<br>");
					
					break;
				default:
					sb.append(ch);
        	}
		}
		
		return sb.toString();
	}
	
	public static HashMap<String, String> getParams(HttpServletRequest request) {
		String name = null;
		HashMap<String, String> params = new HashMap<String, String>();
		for (Enumeration<String> enu = request.getParameterNames(); enu.hasMoreElements(); params.put(name, get(request, name)))
			name = enu.nextElement();

		return params;
	}
	
	/**
	 * request 파라미터를 List<HashMap<String, String>>에 담는다
	 * @param request
	 * @return List<HashMap<String, String>>
	 */
	public static List<HashMap<String, String>> getListMap(HttpServletRequest request) {		
		List<HashMap<String, String>> listMap = new ArrayList<HashMap<String, String>>();
		
		Enumeration<String> pNameArr = request.getParameterNames();
		List<String> paramName = new ArrayList<String>();
		
		while (pNameArr.hasMoreElements()) {
			String pName = pNameArr.nextElement();
			
			paramName.add(pName);
		}
		
		int maxCnt = 0;
		
		for (int i = 0; i < paramName.size(); i++) {
			int cnt = request.getParameterValues(paramName.get(i)).length;
			
			if (maxCnt < cnt) {
				maxCnt = cnt;
			}
		}
		
		for (int row = 0; row < maxCnt; row++) {
			HashMap<String, String> map = new HashMap<String, String>();
			
			for (int i = 0; i < paramName.size(); i++) {
				String pName = paramName.get(i);
				String pValue = "";
				
				if (row < request.getParameterValues(paramName.get(i)).length) {
					pValue = request.getParameterValues(paramName.get(i))[row];
				}
				
				map.put(pName,pValue);
			}
			
			listMap.add(map);
		}
		
		return listMap;
	}
	
	public static String get(HttpServletRequest request, String name) {
		return get(request, name, "");
	}
	
	public static String get(HttpServletRequest request, String name, String defaultValue) {
		String value = request.getParameterValues(name)[0];
		
		if (value == null)
			value = defaultValue;
		
		return value;
	}
	
	public static String nvlStr(String value) {
		return nvlStr(value, "");
	}
	
	public static String nvlStr(String value, String defaultValue) {
		if (value == null)
			value = defaultValue;
		
		return value;
	}
}