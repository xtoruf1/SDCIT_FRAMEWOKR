/**
 * @Class Name  : ParamUtil.java
 * @Description : 파라미터 관련 유틸리티
 * @Modification Information
 *
 *     수정일         수정자                   수정내용
 *     -------          --------        ---------------------------
 *   2016.04.27     이인오          최초 생성
 *
 * @author 이인오
 * @since 2016. 04. 27
 * @version 1.0
 * @see
 *
 */

package egovframework.common.util;

import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;
import java.util.HashMap;


public class ParamUtils {

	private HttpServletRequest request = null;

	public ParamUtils(HttpServletRequest request){
		this.request = request;
	}

	public String[] gets(String key){
    	String[] tmp = {""};

    	return gets(key , tmp);
    }

	public String [] gets(String key, String [] dv){

    	if (request.getParameterValues(key) != null){
    		String[] values = new String[request.getParameterValues(key).length];
    		for( int i = 0; i < request.getParameterValues(key).length; i++ ){
    			values[i] = nvlString(request.getParameterValues(key)[i]);
    		}
    		return values;
    	} else {
    		return dv;
    	}
    }

	public HashMap<String, String> getParams() {
		HashMap<String, String> params = new HashMap<String, String>();
		String name = null;
		for (Enumeration<String> enu = request.getParameterNames(); enu.hasMoreElements(); params.put(name, get(name)))
			name = enu.nextElement();
		return params;
	}

	public String nvlString(String value){
		return nvlString(value, "");
	}

	public String nvlString(String value, String defaultValue){
		if( value == null ){
			return defaultValue;
		}else {
			return value;
		}
	}

	public String get(String name) {
        return get(name, "");
    }

	public String get(String name, String defaultValue) {
		String value = request.getParameterValues(name)[0];
        if (value == null)
            value = defaultValue;
        return value;
    }

}
