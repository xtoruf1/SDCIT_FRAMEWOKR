package egovframework.common.util;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.text.StringEscapeUtils;

/**
 * @author 이승준
 * 
 * 스트링 유틸
 */
public class StringUtil {
	public StringUtil() {
	}
	
	public static String fromDb(String str) {
		String tmpstr = new String();
		
		try {
			String s = ksc2uni(str);
			
			return s;
		} catch(UnsupportedEncodingException e) {
		    e.printStackTrace(System.err);
		}
		
		return tmpstr;
    }

    public static String ksc2uni(String kscstr) throws UnsupportedEncodingException {
    	if (kscstr == null) {
    		return " ";
    	} else {
    		return new String(kscstr.getBytes("KSC5601"), "8859_1");
    	}    		
    }

    public static String ms2euc(String kscstr) throws UnsupportedEncodingException {
    	if (kscstr == null) {
    		return " ";
    	} else {
    		return new String(kscstr.getBytes("MS949"), "euc-kr");
    	}    		
    }

    public static String euc2ms(String kscstr) throws UnsupportedEncodingException {
    	if (kscstr == null) {
    		return " ";
    	} else {
    		return new String(kscstr.getBytes("euc-kr"), "MS949");
    	}        	
    }

    public static String toDb(String str) {
        String tmpstr = new String();
        
        try {
        	tmpstr = uni2ksc(str);
        } catch(UnsupportedEncodingException e) {
            e.printStackTrace(System.err);
        }
        
        return tmpstr;
    }

    public static String uni2ksc(String unicodestr) throws UnsupportedEncodingException {
    	if (unicodestr == null) {
    		return " ";
    	} else {
    		return new String(unicodestr.getBytes("8859_1"), "KSC5601");
    	}    		
    }

    public static String utf2uni(String kscstr) throws UnsupportedEncodingException {
    	if (kscstr == null) {
    		return " ";
    	} else {
    		return new String(kscstr.getBytes("UTF-8"), "8859_1");
    	}    		
    }

    public static String uni2utf(String unicodestr) throws UnsupportedEncodingException {
        if (unicodestr == null) {
        	return " ";
        } else {
        	return new String(unicodestr.getBytes("8859_1"), "UTF-8");
        }            
    }

	public static String convertHtml(String _text) {
		StringBuffer html = new StringBuffer(); 
		String text = _text;
      
		int startindex = 0;
		int endindex = 0;

		while ((endindex = text.indexOf("\n", startindex)) > -1) {
			html.append(text.substring(startindex, endindex));
			html.append("<br>");
			startindex = endindex + 1;
		}
		html.append(text.substring(startindex,text.length()));
		
		return html.toString();		
	}

  	/**
  	 * 문장을 HTML용으로 변환.
  	 * 
  	 * @param s
  	 * @return
  	 */
  	public static String setTag(String s) {
  		int j = s.length();

  		StringBuffer stringbuffer = new StringBuffer(j + 500);

  		for (int i = 0; i < j ;i++) {
  			if (s.charAt(i) == '<') {
  				stringbuffer.append("&lt");
  			} else if (s.charAt(i) == '>') {
  				stringbuffer.append("&gt");
  			} else {
  				stringbuffer.append(s.charAt(i));
  			}  				
  		}
  			
  		return stringbuffer.toString();
  	}

  	/**
  	 * HTML 사용 안 함.
  	 * 
  	 * @param s
  	 * @return
  	 */
  	public static String setBr(String s) {
  		int j = s.length();

  		StringBuffer stringbuffer = new StringBuffer(j + 500);

  		for (int i = 0; i < j ;i++) {
  			if (s.charAt(i) == '\n') {
  				stringbuffer.append("<br>");
  			} else if (s.charAt(i) == '\r') {
  				stringbuffer.append("");
  			} else {
  				stringbuffer.append(s.charAt(i));
  			}	
  		}
  		
  		return stringbuffer.toString();
  	}

	/**
	 * HTML 사용 안 함.(공백으로 변환.)
	 * 
	 * @param s
	 * @return
	 */
	public static String setSpace(String s) {
		int j = s.length();

		StringBuffer stringbuffer = new StringBuffer(j + 500);

		for (int i = 0; i < j; i++) {
			if (s.charAt(i) == '\n'){
				stringbuffer.append("\\n");
			} else if (s.charAt(i) == '\r') {
				stringbuffer.append("\\r");
			} else {
				stringbuffer.append(s.charAt(i));
			}	
		}
		
		return stringbuffer.toString();
	}
	
	public static String setSpc(String _text) {
		StringBuffer html = new StringBuffer(); 
		String text = _text;
      
		int startindex = 0;
		int endindex = 0;

		while ((endindex = text.indexOf(" ", startindex)) > -1) {
			html.append(text.substring(startindex, endindex));
			html.append("&nbsp;");
			startindex = endindex + 1;
		}
		html.append(text.substring(startindex, text.length()));
		
		return html.toString();		
	}
	  
	public static String a2k(String str) {
		String rtn = null;
		
		try {
			rtn = (str == null) ? "" : new String(str.getBytes("8859_1"),"euc-kr");
		} catch (java.io.UnsupportedEncodingException e) {			
		}
		
		return rtn;
	}
	
	public static String k2a(String str) {
		String rtn = null;
		
		try {
			rtn = (str == null) ? "" : new String(str.getBytes("euc-kr"),"8859_1");
		} catch (java.io.UnsupportedEncodingException e) {			
		}
		
		return rtn;
	}

	/**
	 * 문자열 치환.(src : 검색할 문자열, oldstr : 변경할 문자, newstr : 대체할 문자)
	 * 
	 * @param src
	 * @param oldstr
	 * @param newstr
	 * @return
	 */
	public static String replace(String src, String oldstr, String newstr) {
		if (src == null) {
			return null;
		}
		
		StringBuffer dest = new StringBuffer("");
		int len = oldstr.length();
		int srclen = src.length();
		int pos = 0;
		int oldpos = 0;
		
		while((pos = src.indexOf(oldstr, oldpos)) >= 0) {
			dest.append(src.substring(oldpos, pos));
			dest.append(newstr);
			oldpos = pos + len;
		}
		
		if (oldpos < srclen) {
			dest.append(src.substring(oldpos, srclen));
		}
		
		return dest.toString();
	}
	
	/**
	 * SCRIPT에서 FORM필드의 VALUE값 SETTING시 사용.
	 * 
	 * @param str
	 * @return
	 */
	static public String getScriptTag(String str) {
		if (str != null) {
			str = str.trim();
			str = replace(str, "\n", "\\n");				
			str = replace(str, "\r", "");				
			str = replace(str, "`|", "\\n");
			str = replace(str, "'", "\\'");
			str = replace(str, "\"", "\\\"");
			str = replace(str, "(", "\\(");
			str = replace(str, ")", "\\)");
			str = replace(str, "/", "\\/");
			str = replace(str, ",", "\\,");
			str = replace(str, "=", "\\=");
			str = replace(str, "-", "\\-");
			str = replace(str, "&", "\\&");
			str = replace(str, "#", "\\#");
			str = replace(str, "^", "\\^");
			str = replace(str, ";", "\\;");
			str = replace(str, ":", "\\:");
			str = replace(str, "*", "\\*");
			str = replace(str, "<", "\\<");
			str = replace(str, ">", "\\>");
		}
		
		return str;
	}
	
	/**
	 * TEXTFIELD에 VALUE값 SETTING시 사용
	 * 
	 * @param str
	 * @return
	 */
	public static String getTextTag(String str) {
		if (str != null) {
			str = str.trim();
			str = replace(str, "\"", "&quot;");
			str = replace(str, "'", "&#39;");
		}
		
		return str;
	}
	
	static public String setTextTag(String str) {
		if (str != null) {
			str = str.trim();
			str = str.replaceAll("&amp;", "&");
			str = str.replaceAll("&apos;", "'");			
		}
		
		return str;
	}
	
    /**
     * 문자를 숫자형으로 치환
     * 
     * @param str
     * @return
     */
    public static int stoi(String str) {
        if (str == null) {
        	return 0;
        }
        
        if (str.equals("")) {
        	return 0;
        } else {
        	return Integer.valueOf(str).intValue();
        }            
    }

    /**
     * 문자를 INT형으로 치환, 값이 NULL일 경우는 VAL로 돌려준다.
     * 
     * @param str
     * @param val
     * @return
     */
    public static int stoi(String str, int val) {
        if (str == null) {
        	return val;
        }
        
        if (str.equals("")) {
        	return val;
        } else {
        	return Integer.valueOf(str).intValue();
        }        	
    }
        
    public static String removeChar(String value, char remove_char) {
		int flag = 0;
		String newval = "";
		int index = 0;
		int temp = 0;
		flag = value.indexOf(remove_char, 0);
		
        if (flag == -1)
            return value.trim();
        do {
        	index = value.indexOf(remove_char, temp);
        	if (index == -1) {
        		newval = newval.concat(value.substring(temp));
                break;
            }
        	newval = newval.concat(value.substring(temp, index));
            temp = index + 1;
        } while (true);
        
        return newval.trim();
    }
    
    public static String nullCheck(String original_val) {
    	if (original_val == null) {
    		return "";
    	} else {
    		return original_val;
    	}    		
    }

	public static String nullCheck(String original_val, String replace_val) {
		if (original_val == null  || original_val.equals("null") || "".equals(original_val)) {
			return replace_val;
		} else {
			return original_val;
		}			
	}

	public static String nullCheck(String original_val, int replace_val) {
		if (original_val == null) {
			return replace_val + "";
		} else {
			return original_val;
		}			
	}

	public static String nullCheck(Object original_val) {
		if (original_val == null) {
			return "";
		} else {
			return original_val.toString();
		}			
	}
	
	public static boolean isEmpty(String str){
 		return (str == null || str.trim().equals(""));
 	}
	
	public static boolean isNotEmpty(String str){
		return !isEmpty(str);
	}
	
	public static String nvl(Object value) {
		return nvl(value, "");
	}
	
	public static String nvl(Object inputValue, String returnValue) {
    	String inputValueStr = "";

    	if (inputValue != null) {
    		inputValueStr = String.valueOf(inputValue);
    	}

    	if (isEmpty(inputValueStr)) {
    		return returnValue;
    	} else {
    		return inputValueStr;
    	}
	}
	
	public static String voidNull(String param){
	    if (param == null) {
	    	return "";
	    }
	    
	    if (param.trim().equals("")) {
	    	return "";
	    } else {
	         return param.trim();
	    }
	}
	
	public static String sha256Encode(String text) {
		String encodeString = "";
		
		try {			 
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hash = digest.digest(text.getBytes("UTF-8"));
			StringBuffer hexString = new StringBuffer();
 
			for (int i = 0; i < hash.length; i++) {
				String hex = Integer.toHexString(0xff & hash[i]);
				if (hex.length() == 1) {
					hexString.append('0');
				}
				hexString.append(hex);
			}
			
			encodeString = hexString.toString();
		} catch(Exception ex){
			throw new RuntimeException(ex);
		}

	    return encodeString;
	}
	
	public static byte[] generateKey(String key) {
		byte[] desKey = new byte[8];
		byte[] bkey = key.getBytes();
	        
	    if (bkey.length < desKey.length) {
	    	System.arraycopy(bkey, 0, desKey, 0, bkey.length);
	            
	    	for (int i = bkey.length; i < desKey.length; i++)
	    		desKey[i] = 0;
	    } else
	    	System.arraycopy(bkey, 0, desKey, 0, desKey.length);
	        
	    return desKey;
	}
	
	/**
	 * 받은 키워드를 콤마로 구분하여 DESC 정렬 쿼리로 변환
	 * @param searchKeyword
	 * @return
	 * @throws Exception
	 */
	public static String getSortTxtByReplace(String searchKeyword) throws Exception {
	    String sortTxt = searchKeyword;
	    if (sortTxt.contains(",")) sortTxt = sortTxt.replaceAll(",", "*1 DESC, ");
	    if (!sortTxt.isEmpty()) sortTxt += "*1 DESC";
	    return sortTxt;
	}
	
	/**
	 * 입력된 내용에서 태그를 제거하고 내용을 반환한다. 
	 * 
	 * @param inputValue
	 * @return
	 * @throws Exception
	 */
	public static String removeTag(String inputValue) throws Exception {
		String returnValue = "";
		
		inputValue = voidNull(inputValue);
		inputValue = StringEscapeUtils.unescapeHtml4(inputValue);
		inputValue = inputValue.replaceAll("<(/)?([a-zA-Z0-9]*)(\\s[a-zA-Z0-9]*=[^>]*)?(\\s)*(/)?>", "");
		returnValue = inputValue.replaceAll("<!--.*-->", "");
		
	    return returnValue;
	}
	
	public static String specialCharRemove(String value) {
		if (value == null) {
			return "";
		}
        String match = "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]";
        value = value.replaceAll(match, "");
        
        return value;
    }
	
	/**
	 * 스트링 변수의 매핑값을 맵에 담긴 값으로 치환
	 * 
	 * @param content
	 * @param contentObj
	 * @return
	 */
	public static String setMappingString(String content, Map<String, String> contentObj) {
		String mapping = "";

		if (!((Map<String, String>)contentObj).isEmpty()) {
			for (Entry<String, String> val : contentObj.entrySet()) {
				String value = val.getValue();
				
				if (StringUtil.isNotEmpty(value)) {
					content = mapping = content.replace(val.getKey(), val.getValue());
				}
			}

			return mapping;
		} else {
			if (content == null || content.equals("null")) {
				return "";
			} else {
				return content;
			}
		}
	}
	
	public static String uniCode(String args) { 
		String text = args;
		String rtnVal = "";
		
		for (int i = 0; i < text.length(); i++) { 
			rtnVal +=  "\\" + String.format("%04X%n", (int)text.charAt(i));
		}
		
		return rtnVal.replaceAll("\n", "").replaceAll("\r", "");
	}
	
	/**
     * 데이터를 암호화하는 기능
     *
     * @param byte[] data 암호화할 데이터
     * @return String result 암호화된 데이터
     * @exception Exception
     */
    public static String encodeBinary(byte[] data) throws Exception {
		if (data == null) {
		    return "";
		}
	
		return new String(Base64.encodeBase64(data));
    }

    /**
     * 데이터를 복호화하는 기능
     *
     * @param String data 복호화할 데이터
     * @return String result 복호화된 데이터
     * @exception Exception
     */
    public static byte[] decodeBinary(String data) throws Exception {
    	return Base64.decodeBase64(data.getBytes());
    }
    
    public static String encodeURIComponent(String s) {
		String result = null;
	 
		try {
			result = URLEncoder.encode(s, "UTF-8")
				.replaceAll("\\+", "%20")
				.replaceAll("\\%21", "!")
				.replaceAll("\\%27", "'")
				.replaceAll("\\%28", "(")
				.replaceAll("\\%29", ")")
				.replaceAll("\\%7E", "~");
		} catch (UnsupportedEncodingException e) {
			result = s;
		}
	 
		return result;
	}
}