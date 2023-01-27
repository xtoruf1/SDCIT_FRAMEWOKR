package egovframework.common.util;

import org.egovframe.rte.psl.dataaccess.util.CamelUtil;

import egovframework.common.vo.CommonHashMap;

public class ExcelUtil {
	/**
	 * 엑셀 헤더 셋팅(name, key만 있는 경우)
	 * 
	 * @param name
	 * @param key
	 * @return
	 */
	public static CommonHashMap<String, String> setHeaderList(String name, String key) {
		return setHeader(null, null, null, null, name, key);
	}
	
	/**
	 * 엑셀 헤더 셋팅
	 * 
	 * @param type
	 * @param start
	 * @param end
	 * @param group
	 * @param name
	 * @param key
	 * @return
	 */
	public static CommonHashMap<String, String> setHeader(String type, String start, String end, String group, String name, String key) {
		CommonHashMap<String, String> header = new CommonHashMap<String, String>();
		
		if (!StringUtil.isEmpty(type)) {
			header.put("headerType", type);
		}
		
		if (!StringUtil.isEmpty(start)) {
			header.put("startIdx", start);
		}
		
		if (!StringUtil.isEmpty(end)) {
			header.put("endIdx", end);
		}
		
		if (!StringUtil.isEmpty(group)) {
			header.put("group", group);
		}
		
		if (!StringUtil.isEmpty(name)) {
			header.put("name", name);
		}
		
		if (!StringUtil.isEmpty(key)) {
			header.put("key", CamelUtil.convert2CamelCase((String) key));
		}
		
		return header;
	}
}