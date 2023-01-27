package egovframework.common.taglibs;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.common.util.WebUtil;

public class CommonTag {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonTag.class);

	/**
	 * 디비에서 가져온 내용을 역 XSS처리한다.
	 * 
	 * @param contents
	 * @return
	 */
	public static String reverseXss(String contents) {
        return WebUtil.getReXSSFilter(contents);
   }
}