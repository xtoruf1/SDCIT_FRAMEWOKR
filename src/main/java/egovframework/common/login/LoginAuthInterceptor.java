package egovframework.common.login;

import java.util.Date;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.util.Strings;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;

import egovframework.common.auth.web.AuthRestController;
import egovframework.common.util.StringUtil;

public class LoginAuthInterceptor implements HandlerInterceptor {
	private static final Logger LOGGER = LoggerFactory.getLogger(LoginAuthInterceptor.class);
	
	@Autowired
    private AuthRestController authRestController;
	
	private final String AUTHLOGOUT = "authLogout";
	private final String AUTHTOKEN = "authToken";
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		/*
			2021.01.26
			이인오
			추가 의미없는 Interceptor 방지
		*/
		if (request.getRequestURI().indexOf(".jsp") > -1) {
			return true;
		}
		
		if (request.getSession().getAttribute(AUTHLOGOUT) != null) {
			Cookie cookie = new Cookie(AUTHTOKEN, null);
			cookie.setMaxAge(0);
			
			response.addCookie(cookie);
			request.getSession().setAttribute("user", null);
			request.getSession().setAttribute(AUTHLOGOUT, null);
			
			return true;
		}
		
		String token = getTokenInCookie(request.getCookies());
		
		if (!StringUtil.isEmpty(token)) {
			String connetUri = request.getRequestURL().toString().replace(request.getRequestURI(), "");
			
			if (request.getSession().getAttribute("authLastUseDt") == null) {
				// 통합세션은 존재하나 로컬세션이 만료되었을경우
				if (!authRestController.relToken(token, request, response)) {
					LOGGER.warn(request.getRemoteAddr() + " :: The Wrong Access.");
				}
			} else {
				// 통합세션은 존재하나 로컬세션 갱신이 기준시간 이상 지난경우
				Date authLastUseDt = (Date) request.getSession().getAttribute("authLastUseDt");
				Date nowDt = new Date();
				
				// 로그인일자 및 통합센션 갱신 후 10분 이상 경과 시
				if ((nowDt.getTime() - authLastUseDt.getTime()) > (1000L * 60L * 10L)) {
					if (updateJwt(request, token, connetUri)) {
						LOGGER.warn(request.getRemoteAddr() + " :: JWT Update Fail!!!");
					}
				}
			}
			
			String referer = request.getHeader("referer");
			
			// 통합세션이 존재하며 사이트 이동이 발생한 경우
			if (!StringUtil.isEmpty(referer) && !referer.startsWith(connetUri)) {
				if (updateJwt(request, token, connetUri)) {
					LOGGER.warn(request.getRemoteAddr() + " :: JWT Update Fail!!!");
				}
			}
		}
		
		return true;
	}
	
	public boolean updateJwt(HttpServletRequest request, String token, String connetUri) {
		JSONObject json;
		
		try {
			json = authRestController.checkJwt(token, "relJwt.do", connetUri);
			
			if (json == null) {
				LOGGER.error(request.getRemoteAddr() + " :: The wrong token. - " + token);
				
				return false;
			}
			
			request.getSession().setAttribute("authLastUseDt", new Date());
		} catch (Exception e) {
			LOGGER.error(request.getRemoteAddr() + " :: " + e.getMessage());
			
			return false;
		}
		
		return true;
	}
	
	public String getTokenInCookie(Cookie[] cookies) {
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (cookie.getName().equals("authToken")) {
					return cookie.getValue();
			    }
			}
		}
		
		return Strings.EMPTY;
	}
}