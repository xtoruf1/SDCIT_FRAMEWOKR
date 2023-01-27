package egovframework.common.util; 

import java.io.File;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PropertyUtil {
	private final static Logger LOGGER = LoggerFactory.getLogger(PropertyUtil.class);
	
	public static final String FILE_SEPARATOR = System.getProperty("file.separator");
	public static final String CONF_PROPERTIES_FILEPATH = Property.RELATIVE_PATH_PREFIX + "properties" + FILE_SEPARATOR;

    /**
      * getProperty
      * 시스템 프로퍼티파일(globals.properties)의 값을 리턴한다.
      * @param key
      * @return
      */
    public static String getGlobalsProperty(String key) {
    	return Property.getProperty(CONF_PROPERTIES_FILEPATH + "globals.properties", key);
    }

   /**
    * getProperty
    * 시스템 및 변수 프로퍼티 파일의 값을 리턴한다.
    * @param name
    * @param key
    * @return
    */
	public static String getProperty(String key) {
		String value = getGlobalsProperty(key);
		
		if (StringUtil.isEmpty(value)) {
			String path = CONF_PROPERTIES_FILEPATH + System.getProperty("spring.profiles.active");
			value = searchPropertyValue(path, key);
		}
		
		return value;
	}
	
	/**
	 * 파일에서 프로퍼티 값을 찾기
	 * 
	 * @param path
	 */
	public static String searchPropertyValue(String path, String key) {
		File dir = new File(path);
		File files[] = dir.listFiles();

		String value = "";
		
		for (int i = 0; i < files.length; i++) {
			File file = files[i];
			
			if (file.isDirectory()) {
				searchPropertyValue(file.getPath(), key);
			} else {
				if (file.getName().contains("properties")) {
					value = Property.getProperty(file.getPath(), key);
					
					if (!StringUtil.isEmpty(value)) {
						break;
					}
				}
			}
		}
		
		return value;
	}
}