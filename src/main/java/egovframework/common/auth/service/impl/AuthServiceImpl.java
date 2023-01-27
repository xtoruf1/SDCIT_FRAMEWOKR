package egovframework.common.auth.service.impl;

import egovframework.auth.dao.AuthDAO;
import egovframework.auth.vo.AuthVO;
import egovframework.common.auth.service.AuthService;
import egovframework.common.dao.ConsultantAuthCheckTradeDAO;
import egovframework.common.login.LoginManager;
import egovframework.common.login.service.LoginService;
import egovframework.common.login.vo.LoginUserVO;
import egovframework.common.util.PropertyUtil;
import egovframework.common.util.StringUtil;
import egovframework.common.vo.CommonHashMap;
import egovframework.member.dao.MemberDAO;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class AuthServiceImpl implements AuthService {
	private static final Logger LOGGER = LoggerFactory.getLogger(AuthServiceImpl.class);

	/** MemberDAO */
	@Autowired
	private MemberDAO memberDAO;

	/** AuthDAO */
	@Autowired
	private AuthDAO authDAO;

	/** ConsultantAuthCheckTradeDAO */
	@Autowired
	private ConsultantAuthCheckTradeDAO consultantAuthCheckTradeDAO;

	/** LoginService */
	@Autowired
	private LoginService loginService;

	private final String AUTHLOGOUT = "authLogout";

	@Transactional
	public boolean loginInjection(JSONObject tokenInfo, HttpServletRequest request, HttpServletResponse response) {
		try {
			// 시스템별 로그인 처리
			LoginManager manager = LoginManager.getInstance();
			LoginUserVO loginVO = new LoginUserVO();

			String userId = (String)tokenInfo.get("userId");
			loginVO.setId(userId);

			// 회원 테이블에서 회원 정보가 있는지 검색
			LoginUserVO user = loginService.actionLogin(loginVO);
			user.setLoginId(user.getUserId());

			if (user != null) {
				String profile = System.getProperty("spring.profiles.active");

				if( user.getFundAuthType() == null ) {
					user.setFundAuthType("");
				}
				if( user.getAwardAuthType() == null ) {
					user.setAwardAuthType("");
				}

				///////////////////////////////////////////////////////////////////////////////////////////////

				/*
				 * 2022-09-16
				 * 이승준
				 * 컨설턴트 자동 권한 부여
				 * - TradePro, 외국어 통번역(제외), 무역현장컨설턴트, 무역상담컨설턴트
				 * 진행순서
				 * 1. 등록된 컨설턴트 인지 확인 - TRADE
				 * 2. 등록된 컨설턴트면 권한삭제 - KMEMEBER
				 * 3. 활동중인 상태의 전문가 권한 ID가져오기
				 * 4. 권한입력
				 */
				// 1. 등록된 컨설턴트 인지 확인 - TRADE
				int consultantCount = consultantAuthCheckTradeDAO.getConsultantCount(loginVO.getId());

				// 2. 등록된 컨설턴트면 권한삭제 - KMEMEBER
				if (consultantCount > 0) {
					AuthVO consultantVO1 = new AuthVO();
					consultantVO1.setUserId(user.getMemberId());
					if ("local".equals(profile) || "dev".equals(profile)) {
						// 로컬, 개발서버의 TradePro(컨설턴트)
						consultantVO1.setSystemMenuId(73);
						consultantVO1.setAuthId(23);
					} else if ("prod".equals(profile)) {
						// 운영서버의 TradePro(컨설턴트)
						consultantVO1.setSystemMenuId(73);
						consultantVO1.setAuthId(23);
					}

					authDAO.deleteAuthGrantDetail(consultantVO1);

					AuthVO consultantVO2 = new AuthVO();
					consultantVO2.setUserId(user.getMemberId());
					if ("local".equals(profile) || "dev".equals(profile)) {
						// 로컬, 개발서버의 무역현장컨설턴트
						consultantVO2.setSystemMenuId(89);
						consultantVO2.setAuthId(26);
					} else if ("prod".equals(profile)) {
						// 운영서버의 무역현장컨설턴트
						consultantVO2.setSystemMenuId(89);
						consultantVO2.setAuthId(26);
					}

					authDAO.deleteAuthGrantDetail(consultantVO2);

					AuthVO consultantVO3 = new AuthVO();
					consultantVO3.setUserId(user.getMemberId());
					if ("local".equals(profile) || "dev".equals(profile)) {
						// 로컬, 개발서버의 무역상담컨설턴트
						consultantVO3.setSystemMenuId(90);
						consultantVO3.setAuthId(27);
					} else if ("prod".equals(profile)) {
						// 운영서버의 무역상담컨설턴트
						consultantVO3.setSystemMenuId(90);
						consultantVO3.setAuthId(27);
					}

					authDAO.deleteAuthGrantDetail(consultantVO3);
				}

				// 3. 활동중인 상태의 전문가 권한 ID가져오기
				List<HashMap<String, Object>> authList = new ArrayList<HashMap<String,Object>>();

				if ("local".equals(profile) || "dev".equals(profile)) {
					authList = consultantAuthCheckTradeDAO.getConsultantAuthNotProdList(loginVO.getId());
				} else if ("prod".equals(profile)) {
					authList = consultantAuthCheckTradeDAO.getConsultantAuthProdList(loginVO.getId());
				}

				// 4. 권한등록입력
				if (authList.size() > 0) {
					AuthVO masterVO = new AuthVO();
					masterVO.setUserId(loginVO.getId());
					masterVO.setUserNm(user.getMemberNm());
					authDAO.mergeAuthGrantOnlyInsert(masterVO);
				}

				for (int i = 0; i < authList.size(); i++) {
					AuthVO consultantVO = new AuthVO();
					consultantVO.setUserId(loginVO.getId());
					String systemMenuId = StringUtil.nullCheck(authList.get(i).get("systemMenuId"));
					String authId = StringUtil.nullCheck(authList.get(i).get("authId"));
					consultantVO.setSystemMenuId(Integer.parseInt(systemMenuId));
					consultantVO.setAuthId(Integer.parseInt(authId));

					authDAO.insertAuthGrantDetail(consultantVO);
				}

				///////////////////////////////////////////////////////////////////////////////////////////////


				int systemMenuId = Integer.valueOf(PropertyUtil.getProperty("dcsc.af.systemMenuId"));
				int authId = Integer.valueOf(PropertyUtil.getProperty("dcsc.af.authId"));

				AuthVO authVO = new AuthVO();
				authVO.setUserId(user.getMemberId());
				if ("local".equals(profile) || "dev".equals(profile)) {
					// 로컬, 개발서버의 할인서비스 신청현황 권한
					authVO.setSystemMenuId(systemMenuId);
					authVO.setAuthId(authId);
				} else if ("prod".equals(profile)) {
					// 운영서버의 할인서비스 신청현황 권한
					authVO.setSystemMenuId(systemMenuId);
					authVO.setAuthId(authId);
				}


				///////////////////////////////////////////////////////////////////////////////////////////////


				///////////////////////////////////////////////////////////////////////////////////////////////

				// 권한 상세에 권한이 없으면 권한마스터에서 아이디를 삭제

				AuthVO userAuthVO = new AuthVO();
				userAuthVO.setUserId(user.getMemberId());

				int userCnt = authDAO.selectUserGrantCnt(userAuthVO);
				if (userCnt == 0) {
					authDAO.deleteAuthGrant(userAuthVO);
				}

				///////////////////////////////////////////////////////////////////////////////////////////////

				// 개인정보 조회 권한
				LoginUserVO info = memberDAO.selectPersonalInfoAuth(userId);

				String infoCheckYn = info == null ? "N" : info.getInfoCheckYn();
				user.setInfoCheckYn(infoCheckYn);

				List<CommonHashMap<String, Object>> resultList = authDAO.selectAuthSubList(userId);

				for (int i = 0 ; i < resultList.size(); i++) {
					if ("4".equals(resultList.get(i).get("authId"))) {
						user.setAdminCheck(true);
					}
					// 콜센터 권한 체크
					if ("6".equals(resultList.get(i).get("authId"))) {
						user.setCallAdminCheck(true);
					}
					// 물류지원실일경우 : 9
					if ("9".equals(resultList.get(i).get("authId"))) {
						// 물류지원실 권한 구분값 삭제로 임의값(9) 입력
						user.setAuthSub1("9");
					}
					// 지부_용역무체물일경우 : 10
					if ("10".equals(resultList.get(i).get("authId"))) {
						user.setAuthSub2(String.valueOf(resultList.get(i).get("authSub")));
					}
				}

				// 공통코드(로그인 세션시간)
				String sessionTime = PropertyUtil.getProperty("globals.sessionTime");

				request.getSession().setAttribute(AUTHLOGOUT, null);
				request.getSession().setAttribute("user", user);
	    		request.getSession().setMaxInactiveInterval(Integer.parseInt(sessionTime));
	    		manager.setLogon(user.getLoginId(), request);
			}
		} catch(Exception e) {
			LOGGER.error(e.getMessage());

			return false;
		}

		return true;
	}
}