package egovframework.common.auth.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

/**
 * Description : 통합 인증 연계 및 로컬세션 생성
 * 
 * @create 2020-04-28
 * @author schong
 *
 */
public interface AuthService {
	/**
     * Description : 토큰 검증 반환 정보로 로컬세션(로그인) 생성
     * @param JSONObject(tokenInfo), HttpServletRequest, HttpServletResponse
     * @return boolean
     */
	public boolean loginInjection(JSONObject tokenInfo, HttpServletRequest request, HttpServletResponse response);	
}