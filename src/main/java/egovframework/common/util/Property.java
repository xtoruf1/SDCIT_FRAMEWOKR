package egovframework.common.util;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Property {
	private static final Logger LOGGER = LoggerFactory.getLogger(Property.class);

	// 파일구분자
	final static  String FILE_SEPARATOR = System.getProperty("file.separator");

	// 프로퍼티 파일의 물리적 위치
	public static final String RELATIVE_PATH_PREFIX = Property.class.getResource("").getPath().substring(0, Property.class.getResource("").getPath().lastIndexOf("common"));
	public static final String GLOBALS_PROPERTIES_FILE = RELATIVE_PATH_PREFIX + "properties" + FILE_SEPARATOR + "globals.properties";

	/**
	 * 인자로 주어진 문자열을 Key값으로 하는 상대경로 프로퍼티 값을 절대경로로 반환한다(Globals.java 전용)
	 * @param keyName String
	 * @return String
	 */
	public static String getPathProperty(String keyName) {
		String value = "";

		LOGGER.debug("getPathProperty : {} = {}", GLOBALS_PROPERTIES_FILE, keyName);

		FileInputStream fis = null;
		
		try {
			Properties props = new Properties();

			fis = new FileInputStream(WebUtil.filePathBlackList(GLOBALS_PROPERTIES_FILE));
			props.load(new BufferedInputStream(fis));

			value = props.getProperty(keyName).trim();
			value = RELATIVE_PATH_PREFIX + "properties" + FILE_SEPARATOR + value;
		} catch (FileNotFoundException fne) {
			LOGGER.debug("Property file not found.", fne);
			throw new RuntimeException("Property file not found", fne);
		} catch (IOException ioe) {
			LOGGER.debug("Property file IO exception", ioe);
			throw new RuntimeException("Property file IO exception", ioe);
		} finally {
			ResourceCloseHelper.close(fis);
		}

		return value;
	}

	/**
	 * 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 값을 반환한다(Globals.java 전용)
	 * @param keyName String
	 * @return String
	 */
	public static String getProperty(String keyName) {
		String value = "";

		LOGGER.debug("getProperty : {} = {}", GLOBALS_PROPERTIES_FILE, keyName);

		FileInputStream fis = null;
		String globalsPropertiesFile = GLOBALS_PROPERTIES_FILE;
		
		try {
			Properties props = new Properties();

			fis = new FileInputStream(WebUtil.filePathBlackList(globalsPropertiesFile));
			props.load(new BufferedInputStream(fis));
			
			if (props.getProperty(keyName) == null) {
				return "";
			}
			
			value = props.getProperty(keyName).trim();
		} catch (FileNotFoundException fne) {
			LOGGER.debug("Property file not found.", fne);
			throw new RuntimeException("Property file not found", fne);
		} catch (IOException ioe) {
			LOGGER.debug("Property file IO exception", ioe);
			throw new RuntimeException("Property file IO exception", ioe);
		} finally {
			ResourceCloseHelper.close(fis);
		}

		return value;
	}

	/**
	 * 주어진 파일에서 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 상대 경로값을 절대 경로값으로 반환한다
	 * @param fileName String
	 * @param key String
	 * @return String
	 */
	public static String getPathProperty(String fileName, String key) {
		FileInputStream fis = null;
		
		try {
			Properties props = new Properties();

			fis = new FileInputStream(WebUtil.filePathBlackList(fileName));
			props.load(new BufferedInputStream(fis));
			fis.close();

			String value = props.getProperty(key);
			value = RELATIVE_PATH_PREFIX + "properties" + FILE_SEPARATOR + value;

			return value;
		} catch (FileNotFoundException fne) {
			LOGGER.debug("Property file not found.", fne);
			throw new RuntimeException("Property file not found", fne);
		} catch (IOException ioe) {
			LOGGER.debug("Property file IO exception", ioe);
			throw new RuntimeException("Property file IO exception", ioe);
		} finally {
			ResourceCloseHelper.close(fis);
		}
	}

	/**
	 * 주어진 파일에서 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 값을 반환한다
	 * @param fileName String
	 * @param key String
	 * @return String
	 */
	public static String getProperty(String fileName, String key) {
		FileInputStream fis = null;
		
		try {
			Pattern pattern = Pattern.compile("[^\\\\|//\\n]+$");
			Matcher matcher = pattern.matcher(fileName);
			String pathName = "";
			String propertyFileName = "";
			
			if (matcher.find()) {
				pathName = fileName.replace(matcher.group(0), "");
				propertyFileName = matcher.group(0);
				fileName = pathName + FILE_SEPARATOR + propertyFileName;
			}

			Properties props = new Properties();

			fis = new FileInputStream(WebUtil.filePathBlackList(fileName));
			props.load(new BufferedInputStream(fis));
			fis.close();

			String value = props.getProperty(key);

			return value;
		} catch (FileNotFoundException fne) {
			LOGGER.debug("Property file not found.", fne);
			throw new RuntimeException("Property file not found", fne);
		} catch (IOException ioe) {
			LOGGER.debug("Property file IO exception", ioe);
			throw new RuntimeException("Property file IO exception", ioe);
		} finally {
			ResourceCloseHelper.close(fis);
		}
	}

	/**
	 * 주어진 프로파일의 내용을 파싱하여 (key-value) 형태의 구조체 배열을 반환한다.
	 * @param property String
	 * @return ArrayList
	 */
	public static ArrayList<Map<String, String>> loadPropertyFile(String property) {
		// key - value 형태로 된 배열 결과
		ArrayList<Map<String, String>> keyList = new ArrayList<Map<String, String>>();

		String src = property.replace('\\', File.separatorChar).replace('/', File.separatorChar);
		
		FileInputStream fis = null;
		
		try {
			File srcFile = new File(WebUtil.filePathBlackList(src));
			
			if (srcFile.exists()) {
				Properties props = new Properties();
				
				fis = new FileInputStream(src);
				props.load(new BufferedInputStream(fis));
				fis.close();

				Enumeration<?> plist = props.propertyNames();
				
				if (plist != null) {
					while (plist.hasMoreElements()) {
						Map<String, String> map = new HashMap<String, String>();
						String key = (String) plist.nextElement();
						map.put(key, props.getProperty(key));
						keyList.add(map);
					}
				}
			}
		} catch (IOException ex) {
			LOGGER.debug("IO Exception", ex);
			throw new RuntimeException(ex);
		} finally {
			ResourceCloseHelper.close(fis);
		}

		return keyList;
	}
}