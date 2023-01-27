package egovframework.auth.web;

import egovframework.auth.service.AuthService;
import egovframework.auth.vo.AuthVO;
import egovframework.common.service.CommonService;
import egovframework.common.vo.CommonHashMap;
import egovframework.menu.service.MenuService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping(value = "/authority")
public class AuthController {
	private static final Logger LOGGER = LoggerFactory.getLogger(AuthController.class);

	/** AuthService */
	@Autowired
	private AuthService authService;

	/** MenuService */
	@Autowired
	private MenuService menuService;

	/** CommonService */
	@Autowired
	private CommonService commonService;


	/**
	 * 권한 관리 > 권한 설정
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/setting/list.do")
	public ModelAndView settingList(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> systemList = menuService.selectAdminSystemMenuList();
		mav.addObject("systemList", systemList);

		// 페이지 사이즈
		mav.addObject("pageUnitList", commonService.getPageUnitList());

		mav.setViewName("auth/setting/list");

		return mav;
	}

	/**
	 * 권한 관리 > 권한 설정 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/setting/selectList.do")
	public ModelAndView selectSettingList(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		searchVO.setPagingInfo();

		int totalCnt = authService.selectSettingTotalCnt(searchVO);
		mav.addObject("resultCnt", totalCnt);

		List<CommonHashMap<String, Object>> systemList = new ArrayList<CommonHashMap<String,Object>>();
		if (totalCnt > 0) {
			systemList = authService.selectSettingList(searchVO);
		}
		mav.addObject("resultList", systemList);

		searchVO.setPagingCount(totalCnt);
		mav.addObject("paginationInfo", searchVO.getPaginationInfo());

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 권한 시스템 선택(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/systemList.do")
	public ModelAndView popupAuthSystemList(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("layer/auth/popup/systemList");

		return mav;
	}

	/**
	 * 권한 시스템 선택 목록(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/selectSystemList.do")
	public ModelAndView selectPopupSystemList(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> systemList = menuService.selectAdminSystemMenuList();
		mav.addObject("resultList", systemList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 권한 관리 > 권한 설정 상세
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/setting/write.do")
	public ModelAndView settingWrite(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		CommonHashMap<String, Object> settingView = authService.selectSettingView(searchVO);
		mav.addObject("resultView", settingView);

		mav.setViewName("auth/setting/write");

		return mav;
	}

	/**
	 * 권한 관리 > 권한 설정 상세 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/setting/authList.do")
	public ModelAndView settingAuthList(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> authList = authService.selectSettingAuthList(searchVO);
		mav.addObject("resultList", authList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 권한 관리 > 권한 설정 상세 저장
	 *
	 * @param request
	 * @param authVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/setting/saveAuthInfo.do")
	public ModelAndView saveSettingAuthInfo(HttpServletRequest request, @RequestBody AuthVO authVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		authService.mergeSettingAuthInfo(authVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 권한 관리 > 권한 설정 목록 삭제
	 *
	 * @param request
	 * @param authVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/setting/deleteList.do")
	public ModelAndView deleteSettingList(HttpServletRequest request, @RequestBody AuthVO authVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		authService.deleteSettingAuthInfo(authVO);

		mav.setViewName("jsonView");

		return mav;
	}


	/**
	 * 권한 관리 > 권한 부여
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/grant/list.do")
	public ModelAndView grantList(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		// 페이지 사이즈
		mav.addObject("pageUnitList", commonService.getPageUnitList());

		mav.setViewName("auth/grant/list");

		return mav;
	}

	/**
	 * 권한 관리 > 권한 부여 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/grant/selectList.do")
	public ModelAndView selectGrantList(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		searchVO.setPagingInfo();

		int totalCnt = authService.selectGrantTotalCnt(searchVO);
		mav.addObject("resultCnt", totalCnt);

		List<CommonHashMap<String, Object>> systemList = new ArrayList<CommonHashMap<String,Object>>();
		if (totalCnt > 0) {
			systemList = authService.selectGrantList(searchVO);
		}
		mav.addObject("resultList", systemList);

		searchVO.setPagingCount(totalCnt);
		mav.addObject("paginationInfo", searchVO.getPaginationInfo());

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 권한 관리 > 권한 부여 상세
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/grant/write.do")
	public ModelAndView grantWrite(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		CommonHashMap<String, Object> settingView = new CommonHashMap<String, Object>();
		if ( searchVO.getUserId() != null && !"".equals(searchVO.getUserId()) ) {
			settingView = authService.selectGrantView(searchVO);
		}
		mav.addObject("resultView", settingView);

		mav.setViewName("auth/grant/write");

		return mav;
	}

	@RequestMapping(value = "/grant/getUserInfo.do")
	public ModelAndView getUserInfo(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		CommonHashMap<String, Object> settingView = new CommonHashMap<String, Object>();
		if ( searchVO.getUserId() != null && !"".equals(searchVO.getUserId()) ) {
			settingView = authService.selectGrantView(searchVO);
		}
		mav.addObject("resultView", settingView);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 권한 관리 > 권한 부여 상세 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/grant/authList.do")
	public ModelAndView grantAuthList(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> authList = new ArrayList<CommonHashMap<String,Object>>();
		if ( searchVO.getUserId() != null && !"".equals(searchVO.getUserId()) ) {
			authList = authService.selectGrantAuthList(searchVO);
		}
		mav.addObject("resultList", authList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 선택(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/userList.do")
	public ModelAndView popupAuthMemberList(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("layer/auth/popup/userList");

		return mav;
	}

	/**
	 * 사용자 선택 목록(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/selectUserList.do")
	public ModelAndView selectPopupUserList(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

/*		List<CommonHashMap<String, Object>> userList = authService.selectUserList(searchVO);
		mav.addObject("resultList", userList);*/

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 권한 선택(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/authList.do")
	public ModelAndView popupAuthList(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> systemList = menuService.selectAdminSystemMenuList();
		mav.addObject("systemList", systemList);

		mav.setViewName("layer/auth/popup/authList");

		return mav;
	}

	/**
	 * 권한 선택(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/selectAuthList.do")
	public ModelAndView selectPopupAuthList(HttpServletRequest request, @ModelAttribute("authVO")AuthVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> authList = authService.selectAuthList(searchVO);
		mav.addObject("resultList", authList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 권한 관리 > 권한 부여 상세 저장
	 *
	 * @param request
	 * @param authVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/grant/saveAuthInfo.do")
	public ModelAndView saveGrantAuthInfo(HttpServletRequest request, @RequestBody AuthVO authVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		authService.mergeGrantAuthInfo(authVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 권한 부여정보 삭제
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/grant/deleteList.do")
	public ModelAndView deleteGrantList(HttpServletRequest request, @RequestBody AuthVO authVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		authService.deleteAuthGrantList(authVO);

		mav.setViewName("jsonView");

		return mav;
	}
}