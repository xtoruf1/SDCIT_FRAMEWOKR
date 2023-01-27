package egovframework.common.auth;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;

import egovframework.common.login.vo.LoginUserVO;
import egovframework.common.util.HttpUtil;
import egovframework.common.vo.CommonHashMap;
import egovframework.menu.service.MenuService;
import egovframework.menu.vo.MenuVO;

public class AuthenticInterceptor implements HandlerInterceptor {
	private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());

	/** MenuService */
	@Autowired
	private MenuService menuService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		if (HttpUtil.checkLogin(request)) {
			String contextPath = request.getContextPath();
			String path = request.getRequestURI();

			// 로그인VO에서 사용자 정보 가져오기
			LoginUserVO user = HttpUtil.getSessionInfo();
			String userId = user.getLoginId();

			// 접근한 메뉴에 수정권한을 알아온다.
			request.setAttribute("pageModifyYn", "N");

			// AJAX 여부 확인
			boolean isAjax = HttpUtil.isAjaxRequest(request);

			// 팝업여부
			boolean isPopup = path.toLowerCase().contains("popup");

			String pageModifyYn = request.getParameter("popupModify");

			// AJAX 라면 탑, 좌측메뉴 호출도, 권한체크도 할 필요가 없다.
			if (isAjax || isPopup) {
				if ("Y".equals(pageModifyYn)) {
					request.setAttribute("pageModifyYn", "Y");
				}

				return true;
			}

			MenuVO mVO = new MenuVO();
			// 로그인한 아이디 셋팅
				mVO.setUserId(userId);

			// 로그인한 사용자가 가지고 있는 권한의 시스템 메뉴를 가져온다.(팝업 예외)
//			List<CommonHashMap<String, Object>> systemList = menuService.selectSystemTopList(mVO);
//
//			List<CommonHashMap<String, Object>> menuList = new ArrayList<CommonHashMap<String,Object>>();
//			CommonHashMap<String, Object> system = new CommonHashMap<String, Object>();
//
//			boolean isUrl = false;
//			if (systemList.size() > 0) {
//				for (CommonHashMap<String, Object> menu : systemList) {
//					String url = String.valueOf(menu.get("url"));
//
//					if (path.equals(url)) {
//						system = menu;
//
//						isUrl = true;
//
//						break;
//					}
//				}
//
//				if (!isUrl) {
//					system = systemList.get(0);
//				}
//
//				// 전체 중에 시스템별 대표(첫번째)만 그룹핑한다.
//				String id = "";
//				for (CommonHashMap<String, Object> menu : systemList) {
//					String systemMenuId = String.valueOf(menu.get("systemMenuId"));
//
//					if (!id.equals(systemMenuId)) {
//						menuList.add(menu);
//					}
//
//					id = systemMenuId;
//				}
//			}
//
//			// 현재 선택된 탑메뉴
//			request.setAttribute("selectMenu", system);
//
//			// 시스템 메뉴
//			request.setAttribute("systemMenuList", menuList);
//
//			if (!path.equals(contextPath + "/gateway.do")) {
//				MenuVO authMenuVO = new MenuVO();
//				authMenuVO.setUserId(userId);
//				authMenuVO.setUrl(path);
//
//				int programCnt = menuService.selectAdminUrlProgramCnt(authMenuVO);
//
//				if (programCnt > 0) {
//					int authYn = menuService.selectAdminMenuAuthExist(authMenuVO);
//
//					// URL 직접접근시 권한이 없으면 gateway 로 간다.
//					if (authYn == 0) {
//						response.sendRedirect(contextPath + "/gateway.do");
//
//						return false;
//					}
//				}
//
//				// 접근 권한이 없으면 접근권한 불가 페이지로 보낸다.
//				if (((CommonHashMap<String, Object>)system).isEmpty()) {
//					response.sendRedirect(contextPath + "/gateway.do");
//
//					return false;
//				} else {
//					String modifyAuthYn = String.valueOf(system.get("modifyAuthYn"));
//					if ("Y".equals(modifyAuthYn)) {
//						request.setAttribute("pageModifyYn", "Y");
//					}
//
//					// 좌측 메뉴에 필요한 시스템 메뉴 아이디
//					String systemId = String.valueOf(system.get("systemMenuId"));
//
//					// 시스템 메뉴 아이디 셋팅
//					mVO.setSystemMenuId(Integer.parseInt(systemId));
//
//					// 로그인한 사용자가 가지고 있는 권한의 좌측 메뉴를 가져온다.(팝업 예외)
//					List<CommonHashMap<String, Object>> leftList = menuService.selectSystemLeftList(mVO);
//
//					if (leftList.size() > 0) {
//						for (CommonHashMap<String, Object> menu : leftList) {
//							String urls = (String)menu.getString("menuUrl");
//							String[] urlArray = urls.split(",");
//
//							// 접근 URI가 어느 메뉴에 존재하는지 여부
//							if (Arrays.asList(urlArray).contains(path)) {
//								String url = (String)menu.getString("url");
//
//								request.setAttribute("currentMenu", url);
//							}
//						}
//					}
//
//					// 좌측 메뉴
//					request.setAttribute("leftList", leftList);
//				}
//			}

			return true;
		}

		return false;
	}
}