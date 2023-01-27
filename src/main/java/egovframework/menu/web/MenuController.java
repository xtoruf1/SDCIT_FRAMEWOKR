package egovframework.menu.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.common.bean.CommonMessageSource;
import egovframework.common.service.CommonService;
import egovframework.common.vo.CommonHashMap;
import egovframework.menu.service.MenuService;
import egovframework.menu.vo.MenuVO;

@Controller
public class MenuController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MenuController.class);

	/** MenuService */
	@Autowired
	private MenuService menuService;

	/** CommonService */
	@Autowired
	private CommonService commonService;

	@Autowired
	CommonMessageSource messageSource;

	/**
	 * 관리자 메뉴 관리 > 시스템 관리
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/menu/system/systemList.do")
	public ModelAndView systemList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		// 페이지 사이즈
		//mav.addObject("pageUnitList", commonService.getPageUnitList());

		mav.setViewName("menu/system/systemList");

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 시스템 관리 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/menu/system/selectSystemList.do")
	public ModelAndView selectAdminSystemList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		searchVO.setPagingInfo();

		List<CommonHashMap<String, Object>> systemList = new ArrayList<CommonHashMap<String,Object>>();
		systemList = menuService.selectAdminSystemList(searchVO);

		//전체카운트
		int totalCnt = 0;
		if( systemList.size() > 0 ) {
			totalCnt = Integer.parseInt( String.valueOf( systemList.get(0).get("totalCnt")));
		}

		mav.addObject("resultCnt", totalCnt);
		mav.addObject("resultList", systemList);

		searchVO.setPagingCount(totalCnt);
		mav.addObject("paginationInfo", searchVO.getPaginationInfo());

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 시스템 관리 등록 화면
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/menu/system/systemRegist.do")
	public ModelAndView adminSystemRegist(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			mav.setViewName("menu/system/systemRegist");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 시스템 관리 수정 화면
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/system/modify.do")
	public ModelAndView adminSystemModify(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			CommonHashMap<String, Object> systemView = menuService.selectAdminSystemView(searchVO);
			mav.addObject("resultView", systemView);

			mav.setViewName("menu/admin/system/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 시스템 관리 메뉴 추가
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/menu/system/insertSystem.do")
	public ModelAndView insertAdminSystem(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		if (menuService.getAdminSystemDuplicateCnt(menuVO) == 0) {
			menuService.insertAdminSystem(menuVO);

			mav.addObject("result", true);
			mav.addObject("message", "Success");
		// 시스템 메뉴명이 중복
		} else {
			mav.addObject("result", false);
			// 중복된 시스템 메뉴명이 존재합니다.
			mav.addObject("message", messageSource.getMessage("menu.system.menu.name.duplication"));
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 시스템 관리 메뉴 수정
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/system/update.do")
	public ModelAndView updateAdminSystem(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		if (menuService.getAdminSystemDuplicateCnt(menuVO) == 0) {
			menuService.updateAdminSystem(menuVO);

			mav.addObject("result", true);
			mav.addObject("message", "Success");
		// 시스템 메뉴명이 중복
		} else {
			mav.addObject("result", false);
			// 중복된 시스템 메뉴명이 존재합니다.
			mav.addObject("message", messageSource.getMessage("menu.system.menu.name.duplication"));
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 시스템 관리 메뉴 삭제
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/system/delete.do")
	public ModelAndView deleteAdminSystem(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		menuService.deleteAdminSystem(menuVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 시스템 관리 메뉴 목록 삭제
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/system/deleteList.do")
	public ModelAndView deleteAdminSystemList(HttpServletRequest request, @RequestBody MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		menuService.deleteAdminSystemList(menuVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 시스템 관리
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/system/list.do")
	public ModelAndView userSystemList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		// 페이지 사이즈
		mav.addObject("pageUnitList", commonService.getPageUnitList());

		mav.setViewName("menu/user/system/list");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 시스템 관리 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/system/selectList.do")
	public ModelAndView selectUserSystemList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		searchVO.setPagingInfo();

		int totalCnt = menuService.selectUserSystemTotalCnt(searchVO);
		mav.addObject("resultCnt", totalCnt);

		List<CommonHashMap<String, Object>> systemList = new ArrayList<CommonHashMap<String,Object>>();
		if (totalCnt > 0) {
			systemList = menuService.selectUserSystemList(searchVO);
		}
		mav.addObject("resultList", systemList);

		searchVO.setPagingCount(totalCnt);
		mav.addObject("paginationInfo", searchVO.getPaginationInfo());

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 시스템 관리 등록 화면
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/system/regist.do")
	public ModelAndView userSystemRegist(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			mav.setViewName("menu/user/system/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 시스템 관리 수정 화면
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/system/modify.do")
	public ModelAndView userSystemModify(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			CommonHashMap<String, Object> systemView = menuService.selectUserSystemView(searchVO);
			mav.addObject("resultView", systemView);

			mav.setViewName("menu/user/system/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 시스템 관리 메뉴 추가
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/system/insert.do")
	public ModelAndView insertUserSystem(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		if (menuService.getUserSystemDuplicateCnt(menuVO) == 0) {
			menuService.insertUserSystem(menuVO);

			mav.addObject("result", true);
			mav.addObject("message", "Success");
		// 시스템 메뉴명이 중복
		} else {
			mav.addObject("result", false);
			// 중복된 대메뉴명이 존재합니다.
			mav.addObject("message", messageSource.getMessage("menu.top.menu.name.duplication"));
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 시스템 관리 메뉴 수정
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/system/update.do")
	public ModelAndView updateUserSystem(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		if (menuService.getUserSystemDuplicateCnt(menuVO) == 0) {
			menuService.updateUserSystem(menuVO);

			mav.addObject("result", true);
			mav.addObject("message", "Success");
		// 시스템 메뉴명이 중복
		} else {
			mav.addObject("result", false);
			// 중복된 대메뉴명이 존재합니다.
			mav.addObject("message", messageSource.getMessage("menu.top.menu.name.duplication"));
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 시스템 관리 메뉴 삭제
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/system/delete.do")
	public ModelAndView deleteUserSystem(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		menuService.deleteUserSystem(menuVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 시스템 관리 메뉴 목록 삭제
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/system/deleteList.do")
	public ModelAndView deleteUserSystemList(HttpServletRequest request, @RequestBody MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		menuService.deleteUserSystemList(menuVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 메뉴 관리
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/list.do")
	public ModelAndView adminList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> systemList = menuService.selectAdminSystemMenuList();
		mav.addObject("systemList", systemList);

		mav.setViewName("menu/admin/list");

		return mav;
	}

	/**
	 * 메뉴 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/selectList.do")
	public ModelAndView selectAdminList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> menuList = menuService.selectAdminMenuList(searchVO);
		mav.addObject("resultList", menuList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 프로그램 목록(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/popup/programList.do")
	public ModelAndView adminPopupProgramList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("layer/menu/admin/popup/programList");

		return mav;
	}

	/**
	 * 프로그램 목록 팝업에서 선택된 프로그램 메뉴에 등록
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/insertMenuProgram.do")
	public ModelAndView insertAdminMenuProgram(HttpServletRequest request, @RequestBody MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		menuService.insertAdminMenuProgram(menuVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 메뉴 목록(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/popup/menuList.do")
	public ModelAndView adminPopupMenuList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("layer/menu/admin/popup/menuList");

		return mav;
	}

	/**
	 * 메뉴 목록(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/popup/menu/selectList.do")
	public ModelAndView selectAdminPopupMenuList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> menuDepthList = menuService.selectAdminMenuDepthList(searchVO);
		mav.addObject("resultList", menuDepthList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 메뉴 정렬순서 변경
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/updateMenuSort.do")
	public ModelAndView updateAdminMenuSort(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		menuService.updateAdminMenuSort(menuVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 메뉴정보 저장(삭제)
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/deleteMenuList.do")
	public ModelAndView deleteAdminMenuList(HttpServletRequest request, @RequestBody MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		menuService.deleteAdminMenuList(menuVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 메뉴 관리
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/list.do")
	public ModelAndView userList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> topList = menuService.selectUserTopMenuList(searchVO);
		mav.addObject("topList", topList);

		List<CommonHashMap<String, Object>> authList = menuService.selectUserAuthList(searchVO);
		mav.addObject("authList", authList);


		mav.setViewName("menu/user/list");

		return mav;
	}

	/**
	 * 메뉴 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/selectList.do")
	public ModelAndView selectUserList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> menuList = menuService.selectUserMenuList(searchVO);
		mav.addObject("resultList", menuList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 프로그램 목록(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/popup/programList.do")
	public ModelAndView userPopupProgramList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("layer/menu/user/popup/programList");

		return mav;
	}

	/**
	 * 프로그램 목록 팝업에서 선택된 프로그램 메뉴에 등록
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/insertMenuProgram.do")
	public ModelAndView insertUserMenuProgram(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		menuService.insertUserMenuProgram(menuVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 메뉴 목록(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/popup/menuList.do")
	public ModelAndView userPopupMenuList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("layer/menu/user/popup/menuList");

		return mav;
	}

	/**
	 * 메뉴 목록(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/popup/menu/selectList.do")
	public ModelAndView selectUserPopupMenuList(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> menuDepthList = menuService.selectUserMenuDepthList(searchVO);
		mav.addObject("resultList", menuDepthList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 메뉴 정렬순서 변경
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/updateMenuSort.do")
	public ModelAndView updateUserMenuSort(HttpServletRequest request, @ModelAttribute("menuVO")MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		menuService.updateUserMenuSort(menuVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 메뉴정보 저장(삭제, 권한)
	 *
	 * @param request
	 * @param menuVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/updateMenu.do")
	public ModelAndView updateUserMenu(HttpServletRequest request, @RequestBody MenuVO menuVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		menuService.updateUserMenu(menuVO);

		mav.setViewName("jsonView");

		return mav;
	}
}