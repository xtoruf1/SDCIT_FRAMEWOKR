package egovframework.common.auth.web;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.util.JSONPObject;

import egovframework.common.auth.service.AuthService;
import egovframework.common.auth.service.RestApiManager;
import egovframework.common.auth.service.TokenManager;
import egovframework.common.login.LoginManager;
import egovframework.common.util.HttpUtil;
import egovframework.common.util.StringUtil;

@RestController
@RequestMapping("/auth")
public class AuthRestController {
	@Autowired
    private TokenManager tokenManager;
	
	@Autowired
    private RestApiManager restApiManager;
	
	@Autowired
    private AuthService authService;

	private	Logger logger = Logger.getLogger(this.getClass());
	
	private static final String PARAM_TOKEN_VALUE = "123DFS23DFGFGH44ER85DTRJULCT23423HRDUAAA";
	
	private final String AUTHLOGOUT = "authLogout";
	private final String AUTHTOKEN = "authToken";
	
	@RequestMapping(value = "/test.do", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> authTest(HttpServletRequest request, HttpServletResponse response) {
    	return new ResponseEntity<>("Auth Arrived!!!!!", HttpStatus.OK);
    }
	
	@RequestMapping(value = "/sessionChk.do", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> sessionChk(HttpServletRequest request, HttpServletResponse response) {		
		String authIp = (String) request.getSession().getAttribute("authIp");
		
		logger.debug(authIp);
		
    	return new ResponseEntity<>(authIp, HttpStatus.OK);
    }
	
	@RequestMapping(value = "/unlockToken.do", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public JSONPObject unlockToken(@RequestParam String token, @RequestParam String callback, HttpServletRequest request, HttpServletResponse response) {
		Map<String, String> paramMap = new HashMap<String, String>();
		
		// 토큰정보가 없는경우 방어로직
		if (StringUtil.isEmpty(token)) {
			logger.error(request.getRemoteAddr() + " :: Token value is null.");
			
			paramMap.put("massage", "Token value is null.");
			paramMap.put("result", "fail");
			
			return new JSONPObject(callback, paramMap);
		}
		
		try {			
			String connetUri = request.getRequestURL().toString().replace(request.getRequestURI(), "");
			JSONObject json = checkJwt(token, "checkJwt.do", connetUri);
			
			if (!authLoginBiz(json, request, response)) {
				logger.error(request.getRemoteAddr() + " :: An error occurred during login injection.");
				
				paramMap.put("massage", "An error occurred during login injection.");
				paramMap.put("result", "fail");
				
				return new JSONPObject(callback, paramMap);
			}
			
			// 원천 시스템 로그인 결과 작성
			paramMap.put("result", "success");
		} catch (Exception e) {
			logger.error(e.getMessage());
			paramMap.put("massage", e.getMessage());
			paramMap.put("result", "fail");
		}
		
		return new JSONPObject(callback, paramMap);
    }
	
	public boolean relToken(String token, HttpServletRequest request, HttpServletResponse response) {		
		System.out.println("relToken 들어옴");
		System.out.println("relToken 들어옴");
		System.out.println("relToken 들어옴");
				
		// 토큰정보가 없는경우 방어로직
		if (StringUtil.isEmpty(token)) {
			logger.error(request.getRemoteAddr() + " :: Token value is null.");
			
			return false;
		}
		
		try {			
			String connetUri = request.getRequestURL().toString().replace(request.getRequestURI(), "");
			JSONObject json = checkJwt(token, "relJwt.do", connetUri);

			if (!authLoginBiz(json, request, response)) {
				logger.error(request.getRemoteAddr() + " :: An error occurred during login injection.");
				
				return false;
			}			
		} catch (Exception e) {
			logger.error(e.getMessage());
			
			return false;
		}
		
		return true;
    }
	
	public JSONObject checkJwt(String token, String bizUri, String connetUri) throws Exception {
		System.out.println("checkJwt 들어옴");
		System.out.println("checkJwt 들어옴");
		System.out.println("checkJwt 들어옴");
		
		Map<String, String> paramMap = new HashMap<String, String>();
		
		// 토큰 해더(로그인 서버 정보) 유효성 체크 
		String authUri = tokenManager.getTargetSsoServerIp(token);
					
		// 토큰 유효성 체크 및 로그인 유저 정보 Pull
		paramMap.put("token", token);
		paramMap.put("serverToken", PARAM_TOKEN_VALUE);
		paramMap.put("connetUri", connetUri);
		
		String url = authUri + "auth/" + bizUri;
					
		JSONObject json = restApiManager.postResponseJson(url, paramMap);
		
		return json;
	}
	
	public boolean authLoginBiz(JSONObject json, HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("authLoginBiz 들어옴");
		System.out.println("authLoginBiz 들어옴");
		System.out.println("authLoginBiz 들어옴");
		
		// 원천 시스템 로그인 처리
		if (!authService.loginInjection(json, request, response)) {
			return false;
		}
					
		// 로그인 세션 부가정보 작성
		request.getSession().setAttribute("authSeqNo", String.valueOf(json.get("seqNo")));
		request.getSession().setAttribute("authClientIp", String.valueOf(json.get("clientIp")));
		request.getSession().setAttribute("authSourceCd", String.valueOf(json.get("source")));
		request.getSession().setAttribute("authLastUseDt", new Date());
		
		return true;
	}
	
	@RequestMapping(value = "/logoutAuth.do", method = RequestMethod.GET, produces = MediaType.TEXT_PLAIN_VALUE)
	public void logoutAuth(HttpServletRequest request, HttpServletResponse response) {
		try {
			LoginManager loginManager = LoginManager.getInstance();
			loginManager.setLogoff(HttpUtil.getUser(request).getLoginId());
			request.getSession().setAttribute(AUTHLOGOUT, "YES");
			request.getSession().invalidate();
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
    }
}