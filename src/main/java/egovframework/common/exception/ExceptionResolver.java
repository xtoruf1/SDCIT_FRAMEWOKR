package egovframework.common.exception;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

import egovframework.common.util.HttpUtil;

/**
 * @FileName : ExceptionResolver.java
 * @Date : 2020. 4. 23.
 * @작성자 : yilee
 * @프로그램 설명 : SimpleMappingExceptionResolver를 상속하여 Exception을 처리
 */
public class ExceptionResolver extends SimpleMappingExceptionResolver {
    private static final Logger LOGGER = LoggerFactory.getLogger(ExceptionResolver.class);

    /** AJAX Request Header 이름 */
    private String ajaxRequestHeaderKey;

    /** AJAX Exception 발생시 처리할 JSP */
    private String ajaxErrorView;

    public String getAjaxRequestHeaderKey() {
		return ajaxRequestHeaderKey;
	}

	public void setAjaxRequestHeaderKey(String ajaxRequestHeaderKey) {
		this.ajaxRequestHeaderKey = ajaxRequestHeaderKey;
	}

	public String getAjaxErrorView() {
		return ajaxErrorView;
	}

	public void setAjaxErrorView(String ajaxErrorView) {
		this.ajaxErrorView = ajaxErrorView;
	}

	@Override
	protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception exception) {
		// AJAX 여부 확인
		boolean isAjax = HttpUtil.isAjaxRequest(request);

		exception.printStackTrace();

		String viewName = determineViewName(exception, request, isAjax);
        
		if (viewName != null) {
			Integer statusCode = super.determineStatusCode(request, viewName);
			
			if (statusCode != null) {
				super.applyStatusCodeIfPossible(request, response, statusCode);
			}

			return getModelAndView(viewName, exception, request, response, isAjax);
		} else {
			return null;
		}
	}

    /**
	 * getModelAndView
	 * Ajax 호출과 그 외 케이스를 분리하여 modelAndView를 구성하여 리턴
	 * @param viewName
	 * @param ex
	 * @param request
	 * @param response
	 * @param isAjax
	 * @return
	 */
	protected ModelAndView getModelAndView(String viewName, Exception ex, HttpServletRequest request, HttpServletResponse response, boolean isAjax) {
		if (isAjax) {
    		response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    		response.setContentType("application/json");

			ModelAndView mv = super.getModelAndView(viewName, ex);
			ErrorInfo errInfo = new ErrorInfo();
			errInfo.setMessage(ex.getMessage());
			errInfo.setErrortype(ex.getClass().getSimpleName());

			if (ex instanceof CommonException) {
				CommonException commonException = (CommonException)ex;
				errInfo.setErrCode(commonException.getCommonErrCode());
			}

			// SQL Exception의 경우
			if (ex.getCause() instanceof java.sql.SQLException) {
				errInfo.setMessage(ErrorConst.DEFAULT_SQL_ERROR_MESSAGE);
			}

			if (errInfo.getMessage() == null || "".equals(errInfo.getMessage())) {
				errInfo.setMessage(ErrorConst.DEFAULT_ERROR_MESSAGE);
			}

			mv.addObject(errInfo);

			return mv;
		}

		return super.getModelAndView(viewName, ex, request);
	}

    /**
	 * 에러를 표시할 JSP를 결정.
	 * @param ex
	 * @param request
	 * @param isAjax
	 * @return
	 */
	protected String determineViewName(Exception ex, HttpServletRequest request, boolean isAjax) {
		String viewName = null;

		// AJAX 호출인 경우, json 처리 view 리턴
		if (isAjax) {
			viewName = this.ajaxErrorView;
		} else {
			viewName = super.determineViewName(ex, request);
		}

		return viewName;
	}
}