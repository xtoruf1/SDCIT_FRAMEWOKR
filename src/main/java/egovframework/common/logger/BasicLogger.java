package egovframework.common.logger;

import java.util.logging.Level;
import java.util.logging.Logger;

public class BasicLogger {
	private static final Level INFO_INFO_LEVEL = Level.INFO;
	private static final Level DEBUG_INFO_LEVEL = Level.FINEST;
	private static final Level IGNORE_INFO_LEVEL = Level.OFF;
	
	private static final Logger INFO_LOGGER = Logger.getLogger("info");
	private static final Logger DEBUG_LOGGER = Logger.getLogger("debug");
	private static final Logger IGNORE_LOGGER = Logger.getLogger("ignore");
	
	/**
	 * 일반적이 정보를 기록하는 경우 사용.
	 * @param message
	 * @param exception
	 */
	public static void info(String message) {
		INFO_LOGGER.log(INFO_INFO_LEVEL, message);
	}
	
	/**
	 * 디버그 정보를 기록하는 경우 사용.
	 * @param message
	 * @param exception
	 */
	public static void debug(String message, Exception exception) {
		if (exception == null) {
			DEBUG_LOGGER.log(DEBUG_INFO_LEVEL, message);
		} else {
			DEBUG_LOGGER.log(DEBUG_INFO_LEVEL, message, exception);
		}
	}
	
	/**
	 * 디버그 정보를 기록하는 경우 사용.
	 * @param message
	 * @param exception
	 */
	public static void debug(String message) {
		debug(message, null);
	}
	
	/**
	 * 기록이나 처리가 불필요한 경우 사용.
	 * @param message
	 * @param exception
	 */
	public static void ignore(String message, Exception exception) {
		if (exception == null) {
			IGNORE_LOGGER.log(IGNORE_INFO_LEVEL, message);
		} else {
			IGNORE_LOGGER.log(IGNORE_INFO_LEVEL, message, exception);
		}
	}
	
	/**
	 * 기록이나 처리가 불필요한 경우 사용.
	 * @param message
	 * @param exception
	 */
	public static void ignore(String message) {
		ignore(message, null);
	}
}