package egovframework.common.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import egovframework.common.login.vo.LoginUserVO;

/**
 * @author 이승준
 * 
 * HTTP 유틸
 */
public class HttpUtil {
	private HttpUtil() {
		super();
	}
	
	/**
	 * 세션 체크
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static final boolean checkLogin(HttpServletRequest request) throws Exception {
 		LoginUserVO user = (LoginUserVO)request.getSession().getAttribute("user");
 		
		if (user == null) {
			return false;
		} else {
			return true;
		}
	}
	
	/**
	 * 세션의 속성의 값 가져오기
	 * 
	 * @param request
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public static final String getUserInfo(HttpServletRequest request, String param) throws Exception {
 		LoginUserVO user = (LoginUserVO)request.getSession().getAttribute("user");
 		
		if (user == null) {
			throw new Exception("로그인 정보가 없습니다.");
		}
 		
 		return BeanUtils.getProperty(user, param);
	}
	
	/**
	 * 세션정보 가져오기
	 * 
	 * @return
	 * @throws Exception
	 */
	public static final LoginUserVO getSessionInfo() throws Exception {
		ServletRequestAttributes servletRequestAttribute = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();
		HttpSession session = servletRequestAttribute.getRequest().getSession(true);
		LoginUserVO user = (LoginUserVO)session.getAttribute("user");
		
		if (user == null) {
			throw new Exception("로그인 정보가 없습니다.");
		}
 		
 		return user;
	}
 	
 	/**
 	 * 세션정보 가져오기
 	 * 
 	 * @param request
 	 * @return
 	 * @throws Exception
 	 */
 	public static final LoginUserVO getUser(HttpServletRequest request)throws Exception {
 		LoginUserVO user = (LoginUserVO)request.getSession().getAttribute("user");
 		
		if (user == null) {
			throw new Exception("로그인 정보가 없습니다.");
		}
 		
 		return user;
	}
 	
 	/**
 	 * 클라이언트 접속 아이피 얻어오기
 	 * 
 	 * @param request
 	 * @return
 	 */
 	public static final String getClientIp(HttpServletRequest request) {
 		String ip = request.getHeader("HTTP_X_FORWARDED_FOR");    		   
	    if (ip == null || ip.length() == 0 || ip.toLowerCase().equals("unknown")) {
	    	ip = request.getHeader("REMOTE_ADDR");
	    }
	    if (ip == null || ip.length() == 0 || ip.toLowerCase().equals("unknown")) {
	    	ip = request.getRemoteAddr();
	    }
		
		return ip;
    }
 	
 	/**
 	 * 현재 request가 AJAX에서 일어난 것인지의 여부
 	 * 
 	 * @param request
 	 * @return
 	 */
 	public static final boolean isAjaxRequest(HttpServletRequest request) {
        String header1 = request.getHeader("AJAX");
        String header2 = request.getHeader("x-requested-with");
        
        if ((header1 != null && "true".equals(header1.toLowerCase())) || (header2 != null && header2.toLowerCase().equals("xmlhttprequest"))) {
        	return true;
        } else {
        	return false;
        }
    }
}