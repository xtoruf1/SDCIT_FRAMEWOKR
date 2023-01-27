package egovframework.common.util;

import java.util.regex.Pattern;

/**
 * 교차접속 스크립트 공격 취약성 방지(파라미터 문자열 교체)
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    	--------    ---------------------------
 *   2011.10.10  한성곤          최초 생성
 *
 * </pre>
 */
public class WebUtil {
	public static String clearXSSMinimum(String value) {
		if (value == null || value.trim().equals("")) {
			return "";
		}

		String returnValue = value;

		returnValue = returnValue.replaceAll("&", "&amp;");
		returnValue = returnValue.replaceAll("<", "&lt;");
		returnValue = returnValue.replaceAll(">", "&gt;");
		returnValue = returnValue.replaceAll("\"", "&#34;");
		returnValue = returnValue.replaceAll("\'", "&#39;");
		returnValue = returnValue.replaceAll(".", "&#46;");
		returnValue = returnValue.replaceAll("%2E", "&#46;");
		returnValue = returnValue.replaceAll("%2F", "&#47;");
		
		return returnValue;
	}

	public static String clearXSSMinimum2(String value) {
		if (value == null || value.trim().equals("")) {
			return "";
		}
		
		String returnValue = value;
		
		return returnValue;
	}
	
	public static String clearXSSMaximum(String value) {
		String returnValue = value;
		returnValue = clearXSSMinimum(returnValue);

		returnValue = returnValue.replaceAll("%00", null);

		returnValue = returnValue.replaceAll("%", "&#37;");

		// \\. => .

		returnValue = returnValue.replaceAll("\\.\\./", "");		// ../
		returnValue = returnValue.replaceAll("\\.\\.\\\\", "");		// ..\
		returnValue = returnValue.replaceAll("\\./", "");			// ./
		returnValue = returnValue.replaceAll("%2F", "");

		return returnValue;
	}
	
	public static String getReXSSFilter(String value) {
		value = value.replaceAll("&amp;", "&");
		value = value.replaceAll("&#35;", "#");
		value = value.replaceAll("&#59;", ";");
		value = value.replaceAll("&#92;", "\\\\");
		value = value.replaceAll("&lt;", "<");
		value = value.replaceAll("&gt;", ">");
		value = value.replaceAll("&#40;", "(");
		value = value.replaceAll("&#41;", ")");
		value = value.replaceAll("&#39;", "'");
		value = value.replaceAll("&quot;", "\"");
		value = value.replaceAll("&#36;", "\\$");
		value = value.replaceAll("&#42;", "*");
		value = value.replaceAll("&#43;", "+");
		value = value.replaceAll("&#124;", "|");
		value = value.replaceAll("&#46;", "\\.");
		value = value.replaceAll("&#63;", "\\?");
		value = value.replaceAll("&#91;", "\\[");
		value = value.replaceAll("&#93;", "\\]");
		value = value.replaceAll("&#94;", "\\^");
		value = value.replaceAll("&#123;", "\\{");
		value = value.replaceAll("&#125;", "\\}");
		value = value.replaceAll("&#33;", "!");
		value = value.replaceAll("&#37;", "%");
		value = value.replaceAll("&#44;", ",");
		value = value.replaceAll("&#45;", "-");
		value = value.replaceAll("&#47;", "/");
		value = value.replaceAll("&#58;", ":");
		value = value.replaceAll("&#61;", "=");
		value = value.replaceAll("&#64;", "@");
		value = value.replaceAll("&#95;", "_");
		value = value.replaceAll("&#96;", "`");
		value = value.replaceAll("&#126;", "~");

		return value;
	}

	public static String filePathBlackList(String value) {
		String returnValue = value;
		if (returnValue == null || returnValue.trim().equals("")) {
			return "";
		}

		returnValue = returnValue.replaceAll("\\.\\./", ""); 		// ../
		returnValue = returnValue.replaceAll("\\.\\.\\\\", "");		// ..\

		return returnValue;
	}

	/**
	 * 행안부 보안취약점 점검 조치 방안.
	 *
	 * @param value
	 * @return
	 */
	public static String filePathReplaceAll(String value) {
		String returnValue = value;
		if (returnValue == null || returnValue.trim().equals("")) {
			return "";
		}

		returnValue = returnValue.replaceAll("/", "");
		returnValue = returnValue.replaceAll("\\", "");
		returnValue = returnValue.replaceAll("\\.\\.", "");			// ..
		returnValue = returnValue.replaceAll("&", "");

		return returnValue;
	}

	public static String filePathWhiteList(String value) {
		return value;
	}

	public static boolean isIPAddress(String str) {
		Pattern ipPattern = Pattern.compile("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}");

		return ipPattern.matcher(str).matches();
	}

	public static String removeCRLF(String parameter) {
		return parameter.replaceAll("\r", "").replaceAll("\n", "");
	}

	public static String removeSQLInjectionRisk(String parameter) {
		return parameter.replaceAll("\\p{Space}", "").replaceAll("\\*", "").replaceAll("%", "").replaceAll(";", "").replaceAll("-", "").replaceAll("\\+", "").replaceAll(",", "");
	}

	public static String removeOSCmdRisk(String parameter) {
		return parameter.replaceAll("\\p{Space}", "").replaceAll("\\*", "").replaceAll("|", "").replaceAll(";", "");
	}
}