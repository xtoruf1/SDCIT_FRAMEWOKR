package egovframework.common.hndlr;

import org.egovframe.rte.fdl.cmmn.exception.handler.ExceptionHandler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CommonOthersExcepHndlr implements ExceptionHandler {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonOthersExcepHndlr.class);

	/**
	 * @param exception
	 * @param packageName
	 * @see 개발프레임웍크 실행환경 개발팀
	 */
	@Override
	public void occur(Exception exception, String packageName) {
		// LOGGER.debug("EgovServiceExceptionHandler run...............");
		
		LOGGER.error(packageName, exception);
	}
}