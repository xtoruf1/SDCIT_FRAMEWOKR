package egovframework.program.web;

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
import egovframework.program.service.ProgramService;
import egovframework.program.vo.ProgramVO;

@Controller
@RequestMapping(value = "/menu")
public class ProgramController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ProgramController.class);

	/** ProgramService */
	@Autowired
	private ProgramService programService;

	/** CommonService */
	@Autowired
	private CommonService commonService;

	@Autowired
	CommonMessageSource messageSource;

	/**
	 * 관리자 메뉴 관리 > 프로그램 관리
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/program/adminProgramList.do")
	public ModelAndView adminProgramList(HttpServletRequest request, @ModelAttribute("programVO")ProgramVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		// 페이지 사이즈
//		mav.addObject("pageUnitList", commonService.getPageUnitList());

		mav.setViewName("menu/admin/program/adminProgramList");

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 프로그램 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/program/programSelectList.do")
	public ModelAndView selectAdminProgramList(HttpServletRequest request, @ModelAttribute("programVO")ProgramVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

//		searchVO.setPagingInfo();
//
//		int totalCnt = programService.selectAdminProgramTotalCnt(searchVO);
//		mav.addObject("resultCnt", totalCnt);
//
//		List<CommonHashMap<String, Object>> programList = new ArrayList<CommonHashMap<String,Object>>();
//		if (totalCnt > 0) {
//			programList = programService.selectAdminProgramList(searchVO);
//		}
//		mav.addObject("resultList", programList);
//
//		searchVO.setPagingCount(totalCnt);
//		mav.addObject("paginationInfo", searchVO.getPaginationInfo());
		
		List<CommonHashMap<String, Object>> programLis = programService.getTestData(searchVO);
		mav.addObject("resultList", programLis);
		
		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 프로그램 목록(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/popup/program/selectList.do")
	public ModelAndView selectAdminPopupList(HttpServletRequest request, @ModelAttribute("programVO")ProgramVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> programList = programService.selectAdminPopupProgramList(searchVO);
		mav.addObject("resultList", programList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 등록 화면
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/program/regist.do")
	public ModelAndView adminProgramRegist(HttpServletRequest request, @ModelAttribute("programVO")ProgramVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			mav.setViewName("menu/admin/program/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 수정 화면
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/program/modify.do")
	public ModelAndView adminProgramModify(HttpServletRequest request, @ModelAttribute("programVO")ProgramVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			CommonHashMap<String, Object> programView = programService.selectAdminProgramView(searchVO);
			mav.addObject("resultView", programView);

			mav.setViewName("menu/admin/program/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 하위 프로그램 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/program/selectSubList.do")
	public ModelAndView selectAdminSubList(HttpServletRequest request, @RequestBody ProgramVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> programList = programService.selectAdminSubProgramList(searchVO);
		mav.addObject("data", programList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 등록
	 *
	 * @param request
	 * @param programVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/program/insert.do")
	public ModelAndView insertAdminProgram(HttpServletRequest request, @RequestBody ProgramVO programVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		if (programService.adminProgramUrlDuplicateCheck(programVO)) {
			programService.insertAdminProgram(programVO);

			mav.addObject("result", true);
			mav.addObject("message", "Success");
		// 프로그램, 하위 프로그램 URL 중복
		} else {
			mav.addObject("result", false);
			// 중복된 URL이 존재합니다.
			mav.addObject("message", messageSource.getMessage("program.url.duplication"));
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 수정
	 *
	 * @param request
	 * @param programVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/program/update.do")
	public ModelAndView updateAdminProgram(HttpServletRequest request, @RequestBody ProgramVO programVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		if (programService.adminProgramUrlDuplicateCheck(programVO)) {
			programService.updateAdminProgram(programVO);

			mav.addObject("result", true);
			mav.addObject("message", "Success");
		// 프로그램, 하위 프로그램 URL 중복
		} else {
			mav.addObject("result", false);
			// 중복된 URL이 존재합니다.
			mav.addObject("message", messageSource.getMessage("program.url.duplication"));
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 목록 삭제
	 *
	 * @param request
	 * @param programVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/program/deleteList.do")
	public ModelAndView deleteAdminProgramList(HttpServletRequest request, @RequestBody ProgramVO programVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		programService.deleteAdminProgramList(programVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 관리자 메뉴 관리 > 프로그램 삭제
	 *
	 * @param request
	 * @param programVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/program/delete.do")
	public ModelAndView deleteAdminProgram(HttpServletRequest request, @ModelAttribute("programVO")ProgramVO programVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		programService.deleteAdminProgram(programVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 프로그램 관리
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/program/list.do")
	public ModelAndView userProgramList(HttpServletRequest request, @ModelAttribute("programVO")ProgramVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		// 페이지 사이즈
		mav.addObject("pageUnitList", commonService.getPageUnitList());

		mav.setViewName("menu/user/program/list");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 프로그램 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/program/selectList.do")
	public ModelAndView selectUserProgramList(HttpServletRequest request, @ModelAttribute("programVO")ProgramVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		searchVO.setPagingInfo();

		int totalCnt = programService.selectUserProgramTotalCnt(searchVO);
		mav.addObject("resultCnt", totalCnt);

		List<CommonHashMap<String, Object>> programList = new ArrayList<CommonHashMap<String,Object>>();
		if (totalCnt > 0) {
			programList = programService.selectUserProgramList(searchVO);
		}
		mav.addObject("resultList", programList);

		searchVO.setPagingCount(totalCnt);
		mav.addObject("paginationInfo", searchVO.getPaginationInfo());

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 프로그램 목록(팝업)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/popup/program/selectList.do")
	public ModelAndView selectUserPopupList(HttpServletRequest request, @ModelAttribute("programVO")ProgramVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> programList = programService.selectUserPopupProgramList(searchVO);
		mav.addObject("resultList", programList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 등록 화면
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/program/regist.do")
	public ModelAndView userProgramRegist(HttpServletRequest request, @ModelAttribute("programVO")ProgramVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			mav.setViewName("menu/user/program/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 등록/수정 화면
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/program/modify.do")
	public ModelAndView userProgramModify(HttpServletRequest request, @ModelAttribute("programVO")ProgramVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			CommonHashMap<String, Object> programView = programService.selectUserProgramView(searchVO);
			mav.addObject("resultView", programView);

			mav.setViewName("menu/user/program/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 하위 프로그램 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/program/selectSubList.do")
	public ModelAndView selectUserSubList(HttpServletRequest request, @ModelAttribute("programVO")ProgramVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();
		List<CommonHashMap<String, Object>> programList = programService.selectUserSubProgramList(searchVO);
		mav.addObject("data", programList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 등록
	 *
	 * @param request
	 * @param programVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/program/insert.do")
	public ModelAndView insertUserProgram(HttpServletRequest request, @RequestBody ProgramVO programVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		if (programService.userProgramUrlDuplicateCheck(programVO)) {
			programService.insertUserProgram(programVO);

			mav.addObject("result", true);
			mav.addObject("message", "Success");
		// 프로그램, 하위 프로그램 URL 중복
		} else {
			mav.addObject("result", false);
			// 중복된 URL이 존재합니다.
			mav.addObject("message", messageSource.getMessage("program.url.duplication"));
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 수정
	 *
	 * @param request
	 * @param programVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/program/update.do")
	public ModelAndView updateUserProgram(HttpServletRequest request, @RequestBody ProgramVO programVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		if (programService.userProgramUrlDuplicateCheck(programVO)) {
			programService.updateUserProgram(programVO);

			mav.addObject("result", true);
			mav.addObject("message", "Success");
		// 프로그램, 하위 프로그램 URL 중복
		} else {
			mav.addObject("result", false);
			// 중복된 URL이 존재합니다.
			mav.addObject("message", messageSource.getMessage("program.url.duplication"));
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 목록 삭제
	 *
	 * @param request
	 * @param programVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/program/deleteList.do")
	public ModelAndView deleteUserProgramList(HttpServletRequest request, @RequestBody ProgramVO programVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		programService.deleteUserProgramList(programVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 메뉴 관리 > 프로그램 삭제
	 *
	 * @param request
	 * @param programVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/program/delete.do")
	public ModelAndView deleteUserProgram(HttpServletRequest request, @ModelAttribute("programVO")ProgramVO programVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		programService.deleteUserProgram(programVO);

		mav.setViewName("jsonView");

		return mav;
	}
}