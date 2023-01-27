package egovframework.common.login;

import java.util.*;
import java.io.Serializable;
import javax.servlet.http.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author 이승준
 *
 * 로그인 세션 관련 클래스
 */
public class LoginManager implements Serializable {
	private static final Logger LOGGER = LoggerFactory.getLogger(LoginManager.class);
	
	/**
	 * serialVersion UID
	 */
	private static final long serialVersionUID = 1L;
	
    private static LoginManager instance;
    private static HashMap<Object, Object> sessionMap;
    
    /**
     * 로그인사용자 세션관리 생성자 싱글턴으로 클래스를 생성한다.
     * 
     * @return instance
     */
    public static synchronized LoginManager getInstance() {
        if (instance == null) {
        	instance = new LoginManager();
        }

        return instance;
    }
    
    /**
     * 클래스 생성자
     */
    private LoginManager() {
    	sessionMap = new HashMap<Object, Object>();
    }

    /**
     * 해쉬테이블에 로그인사용자 세션을 추가한다.
     * 
     * @param loginId 사용자ID
     * @param request HttpServletRequest
     */
    public synchronized void setLogon(String loginId, HttpServletRequest request) {
    	sessionMap.put(loginId, request.getSession());
    }
    
    /**
     * 해쉬테이블에서 로그아웃 사용자 세션을 삭제한다.
     * 
     * @param loginId 사용자ID
     */
    public synchronized void setLogoff(String loginId) {    	
    	HttpSession session = get(loginId);
    	sessionMap.remove(loginId);
    	
    	if (session!=null) {
    		try {
    			session.invalidate();
    		} catch(Exception e) {
    			LOGGER.debug(e.getMessage());
    		}
    	}	
    }
    
    /**
     * 이전 로그인정보를 강제적으로 로그아웃처리한다 - 단일로그인
     * 
     * @param loginId 사용자ID
     * @return success 로그아웃처리결과
     */
    public synchronized boolean forceLogout(String loginId) {
        try {
        	setLogoff(loginId);
        	
        	return true;
        } catch(Exception ex) {
            return false;           
        }       
    }
        
    /**
     * 해당키값 리턴
     * 
     * @param key 사용자ID
     * @return object HttpSession 
     */
    public HttpSession get(String key) {
        if (key == null || sessionMap == null) {
        	return null;
        }
        
        Object object = sessionMap.get(key);	
        if (object != null) {
        	return (HttpSession)object;
        }
        
        return null;
    }

    /**
     * 현재 로그인한 세션의 총갯수
     * 
     * @return int 세션의 총갯수
     */
    public synchronized int getSessionCount() {
        return sessionMap.size();
    }

    /**
     * 로그인여부
     * 
     * @param loginId 사용자ID
     * @return true/false 로그인여부 
     */
    public boolean isLogging(String loginId) {
        if (sessionMap.containsKey(loginId)) {
        	HttpSession session = (HttpSession)sessionMap.get(loginId);
        	if(session == null) {
        		return false;
        	}
        	
        	return true;
        } else {
        	return false;
        }
    }

    /**
     * 현재 사용중인 아이디가 자신의 세션인지 검사
     * 
     * @param loginId 사용자ID
     * @param sid HttpSession
     * @return true/false 현재 사용중인 아이디가 자신의 세션인지 여부
     */
    public boolean isMySession(String loginId, HttpSession sid) {
    	if (sessionMap.containsKey(loginId) && get(loginId).equals(sid)) {
        	return true;
    	} else {
        	return false;
        }
    }

    /**
     * 로그인한 사용자정보
     * 
     * @return HashMap 로그인사용자정보들
     */
    public HashMap<Object, Object> getSessionList() {
        return sessionMap;
    }
}