package egovframework.common.login;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;

import egovframework.common.util.HttpUtil;
import egovframework.common.util.PropertyUtil;

/**
 * @author 이승준
 *
 * 로그인 세션을 체크하기 위한 스프링 인터셉터.
 */
public class LoginSessionCheckInterceptor implements HandlerInterceptor {
	private static final Logger LOGGER = LoggerFactory.getLogger(LoginSessionCheckInterceptor.class);

	/*
	 * Dispatcher가 Controller를 실행하기 바로 직전 이 메소드가 호출된다.
	 *
	 * @see org.springframework.web.servlet.handler.HandlerInterceptorAdapter#
	 * preHandle (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, java.lang.Object)
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		LOGGER.info("===== INTERCEPTOR START (Profile : {}) =====", System.getProperty("spring.profiles.active"));

		/*
		String referer = request.getHeader("referer");
        String host = request.getHeader("host");
        */
		String contextPath = request.getContextPath();

		// if (referer == null || (referer != null && referer.contains(host))) {
			String path = request.getRequestURI();

			if (HttpUtil.checkLogin(request)) {
				// 로그인 세션이 있을때 로그인페이지 URL이 선택되었다면 메인페이지로 이동하도록 처리
				if (path.equals(contextPath + "/login.do")) {
					LOGGER.info("===== INTERCEPTER END MAIN PAGE =====");

					response.sendRedirect(contextPath);

					return false;
				} else {
					LOGGER.info("===== INTERCEPTER END GO {} =====", path);

					return true;
				}
			} else {
				LOGGER.info("===== INTERCEPTER END LOGIN PAGE =====");


				/* 통합로그인 제거
				String loginUrl = PropertyUtil.getProperty("variables.loginUrl");
				String serverName = PropertyUtil.getProperty("variables.serverName");
				path = path.replaceAll("/gateway.do", "");

				response.sendRedirect(loginUrl + "/join/login.do?applCd=KI&rtnUrl=" + serverName + path);
                */

				response.sendRedirect(contextPath + "/login.do");

				return false;
			}
		/*
		} else {
        	LOGGER.info("===== INTERCEPTER END MAIN PAGE =====");

			response.sendRedirect(contextPath);

			return false;
        }
        */
	}
}