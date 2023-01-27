package egovframework.commoncode.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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
import egovframework.common.util.StringUtil;
import egovframework.common.vo.CommonHashMap;
import egovframework.commoncode.service.CommonCodeService;
import egovframework.commoncode.vo.CommonCodeVO;

@Controller
@RequestMapping(value = "/commonCode")
public class CommonCodeController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonCodeController.class);

	/** CommonCodeService */
	@Autowired
	private CommonCodeService commonCodeService;

	/** CommonService */
	@Autowired
	private CommonService commonService;

	@Autowired
	CommonMessageSource messageSource;

	/**
	 * 공통코드관리
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/list.do")
	public ModelAndView list(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> groupList = commonCodeService.selectGroupList(searchVO);

		mav.addObject("group", groupList);

		mav.setViewName("commoncode/list");

		return mav;
	}

	/**
	 * 코드목록 가져오기
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectGroupList.do")
	public ModelAndView selectGroupList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> resultList = commonCodeService.selectCommonCodeList(searchVO);

		mav.addObject("data", resultList);

		mav.setViewName("jsonView");

	    return mav;
 	}

	/**
	 * 그룹코드, 코드 등록/수정
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveGroupCode.do")
	public ModelAndView saveGroupCode(HttpServletRequest request, @RequestBody CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		commonCodeService.mergeGroupCode(commonCodeVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 그룹코드, 코드 삭제
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteGroupCode.do")
	public ModelAndView deleteGroupCode(HttpServletRequest request, @ModelAttribute("commonCodeVO")CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		commonCodeService.deleteGroupCode(commonCodeVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드 캐시 초기화
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/initCommonCodeList.do")
	public ModelAndView initCommonCodeList(HttpServletRequest request, @ModelAttribute("commonCodeVO")CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		commonCodeService.initCommonCodeList();

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통분류코드
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/class/list.do")
	public ModelAndView classList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		// 페이지 사이즈
		mav.addObject("pageUnitList", commonService.getPageUnitList());

		mav.setViewName("commoncode/class/list");

		return mav;
	}

	/**
	 * 공통분류코드 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/class/selectList.do")
	public ModelAndView selectClassList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		searchVO.setPagingInfo();

		int totalCnt = commonCodeService.selectClassCodeTotalCnt(searchVO);
		mav.addObject("resultCnt", totalCnt);

		List<CommonHashMap<String, Object>> codeList = new ArrayList<CommonHashMap<String,Object>>();
		if (totalCnt > 0) {
			codeList = commonCodeService.selectClassCodeList(searchVO);
		}
		mav.addObject("resultList", codeList);

		searchVO.setPagingCount(totalCnt);
		mav.addObject("paginationInfo", searchVO.getPaginationInfo());

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통분류코드 등록 / 수정
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/class/write.do")
	public ModelAndView classWrite(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			if (StringUtil.isNotEmpty(searchVO.getClCode())) {
				CommonHashMap<String, Object> codeView = commonCodeService.selectClassCodeView(searchVO);
				mav.addObject("resultView", codeView);
			}

			mav.setViewName("commoncode/class/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 공통분류코드 조회
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/class/view.do")
	public ModelAndView classView(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			CommonHashMap<String, Object> codeView = commonCodeService.selectClassCodeView(searchVO);

			// 분류코드 설명 BR 처리
			String desc = "";
			Object descObj = codeView.get("clCodeDc");

			if (descObj != null) {
				desc = descObj.toString();
				codeView.put("clCodeDc", StringUtil.setBr(desc));
			}

			mav.addObject("resultView", codeView);

			mav.setViewName("commoncode/class/view");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 공통분류코드 등록
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/class/insert.do")
	public ModelAndView insertClass(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		CommonHashMap<String, Object> codeView = commonCodeService.selectClassCodeView(commonCodeVO);

		if (codeView == null) {
			commonCodeService.insertClassCode(commonCodeVO);

			mav.addObject("result", true);
			mav.addObject("message", "Success");
		} else {
			mav.addObject("result", false);
			// 중복된 분류코드가 존재합니다.
			mav.addObject("message", messageSource.getMessage("commoncode.class.clcode.duplication"));
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통분류코드 수정
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/class/update.do")
	public ModelAndView updateClass(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		commonCodeService.updateClassCode(commonCodeVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통분류코드 삭제
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/class/delete.do")
	public ModelAndView deleteClass(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		commonCodeService.deleteClassCode(commonCodeVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(업무포털)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/portal/list.do")
	public ModelAndView portalList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> classCodeList = commonCodeService.selectSearchClassList();
		mav.addObject("classCodeList", classCodeList);

		// 페이지 사이즈
		mav.addObject("pageUnitList", commonService.getPageUnitList());

		mav.setViewName("commoncode/portal/list");

		return mav;
	}

	/**
	 * 공통코드관리(업무포털) 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/portal/selectList.do")
	public ModelAndView selectPortalList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		searchVO.setPagingInfo();

		int totalCnt = commonCodeService.selectPortalCodeTotalCnt(searchVO);
		mav.addObject("resultCnt", totalCnt);

		List<CommonHashMap<String, Object>> codeList = new ArrayList<CommonHashMap<String,Object>>();
		if (totalCnt > 0) {
			codeList = commonCodeService.selectPortalCodeList(searchVO);
		}
		mav.addObject("resultList", codeList);

		searchVO.setPagingCount(totalCnt);
		mav.addObject("paginationInfo", searchVO.getPaginationInfo());

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(업무포털) 등록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/portal/regist.do")
	public ModelAndView portalRegist(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			List<CommonHashMap<String, Object>> classCodeList = commonCodeService.selectSearchClassList();
			mav.addObject("classCodeList", classCodeList);

			mav.setViewName("commoncode/portal/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 공통코드관리(업무포털) 수정
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/portal/modify.do")
	public ModelAndView portalModify(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			List<CommonHashMap<String, Object>> classCodeList = commonCodeService.selectSearchClassList();
			mav.addObject("classCodeList", classCodeList);

			CommonHashMap<String, Object> codeView = commonCodeService.selectPortalCodeView(searchVO);
			mav.addObject("resultView", codeView);

			mav.setViewName("commoncode/portal/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 공통코드관리(업무포털) 코드상세목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/portal/detailList.do")
	public ModelAndView portalDetailList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> datailList = commonCodeService.selectPortalCodeDetailAllList(searchVO);
		mav.addObject("resultList", datailList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(업무포털) 코드 등록
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/portal/insert.do")
	public ModelAndView insertPortal(HttpServletRequest request, @RequestBody CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		CommonHashMap<String, Object> codeView = commonCodeService.selectPortalCodeView(commonCodeVO);

		if (codeView == null) {
			commonCodeService.mergePortalCode(commonCodeVO);

			mav.addObject("result", true);
			mav.addObject("message", "Success");
		} else {
			mav.addObject("result", false);
			// 중복된 공통코드가 존재합니다.
			mav.addObject("message", messageSource.getMessage("commoncode.code.duplication"));
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(업무포털) 코드 수정
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/portal/update.do")
	public ModelAndView updatePortal(HttpServletRequest request, @RequestBody CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		commonCodeService.mergePortalCode(commonCodeVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(용역/전자적 무체물)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/service/list.do")
	public ModelAndView serviceList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		// 페이지 사이즈
		mav.addObject("pageUnitList", commonService.getPageUnitList());

		mav.setViewName("commoncode/service/list");

		return mav;
	}

	/**
	 * 공통코드관리(용역/전자적 무체물) 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/service/selectList.do")
	public ModelAndView selectServiceList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		searchVO.setPagingInfo();

		int totalCnt = commonCodeService.selectServiceCodeTotalCnt(searchVO);
		mav.addObject("resultCnt", totalCnt);

		List<CommonHashMap<String, Object>> codeList = new ArrayList<CommonHashMap<String,Object>>();
		if (totalCnt > 0) {
			codeList = commonCodeService.selectServiceCodeList(searchVO);
		}
		mav.addObject("resultList", codeList);

		searchVO.setPagingCount(totalCnt);
		mav.addObject("paginationInfo", searchVO.getPaginationInfo());

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(용역/전자적 무체물) 등록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/service/regist.do")
	public ModelAndView serviceRegist(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			mav.setViewName("commoncode/service/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 공통코드관리(용역/전자적 무체물) 수정
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/service/modify.do")
	public ModelAndView serviceModify(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			CommonHashMap<String, Object> codeView = commonCodeService.selectServiceCodeView(searchVO);
			mav.addObject("resultView", codeView);

			mav.setViewName("commoncode/service/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 공통코드관리(용역/전자적 무체물) 코드상세목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/service/detailList.do")
	public ModelAndView serviceDetailList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> datailList = commonCodeService.selectServiceCodeDetailList(searchVO);
		mav.addObject("resultList", datailList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(용역/전자적 무체물) 코드 등록
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/service/insert.do")
	public ModelAndView insertService(HttpServletRequest request, @RequestBody CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		CommonHashMap<String, Object> codeView = commonCodeService.selectServiceCodeView(commonCodeVO);

		if (codeView == null) {
			commonCodeService.mergeServiceCode(commonCodeVO);

			mav.addObject("result", true);
			mav.addObject("message", "Success");
		} else {
			mav.addObject("result", false);
			// 중복된 공통코드가 존재합니다.
			mav.addObject("message", messageSource.getMessage("commoncode.code.duplication"));
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(용역/전자적 무체물) 코드 수정
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/service/update.do")
	public ModelAndView updateService(HttpServletRequest request, @RequestBody CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		commonCodeService.mergeServiceCode(commonCodeVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(용역/전자적 무체물) 코드 삭제
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/service/deleteList.do")
	public ModelAndView deleteService(HttpServletRequest request, @RequestBody CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		if (commonCodeVO.getDeleteCodeList().size() > 0) {
			boolean isValid = true;
			for (Map<String, Object> map : commonCodeVO.getDeleteCodeList()) {
				CommonCodeVO ccVO = new CommonCodeVO();

				String basecd = (String)map.get("basecd");
				ccVO.setBasecd(basecd);

				List<CommonHashMap<String, Object>> detailList = commonCodeService.selectServiceCodeDetailList(ccVO);

				if (detailList.size() > 0) {
					isValid = false;

					break;
				}
			}

			if (isValid) {
				commonCodeService.deleteServiceCode(commonCodeVO);

				mav.addObject("result", true);
				mav.addObject("message", "Success");
			} else {
				mav.addObject("result", false);
				// 상세목록이 존재합니다. 상세목록을 먼저 삭제하세요.
				mav.addObject("message", messageSource.getMessage("commoncode.code.detail.exist"));
			}
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(물류지원)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/support/list.do")
	public ModelAndView supportList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		// 페이지 사이즈
		mav.addObject("pageUnitList", commonService.getPageUnitList());

		mav.setViewName("commoncode/support/list");

		return mav;
	}

	/**
	 * 공통코드관리(물류지원) 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/support/selectList.do")
	public ModelAndView selectSupportList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		searchVO.setPagingInfo();

		int totalCnt = commonCodeService.selectSupportCodeTotalCnt(searchVO);
		mav.addObject("resultCnt", totalCnt);

		List<CommonHashMap<String, Object>> codeList = new ArrayList<CommonHashMap<String,Object>>();
		if (totalCnt > 0) {
			codeList = commonCodeService.selectSupportCodeList(searchVO);
		}
		mav.addObject("resultList", codeList);

		searchVO.setPagingCount(totalCnt);
		mav.addObject("paginationInfo", searchVO.getPaginationInfo());

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(물류지원) 등록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/support/regist.do")
	public ModelAndView supportRegist(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			mav.setViewName("commoncode/support/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 공통코드관리(물류지원) 수정
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/support/modify.do")
	public ModelAndView supportModify(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			CommonHashMap<String, Object> codeView = commonCodeService.selectSupportCodeView(searchVO);
			mav.addObject("resultView", codeView);

			mav.setViewName("commoncode/support/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 공통코드관리(물류지원) 코드상세목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/support/detailList.do")
	public ModelAndView supportDetailList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> datailList = commonCodeService.selectSupportCodeDetailList(searchVO);
		mav.addObject("resultList", datailList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(물류지원) 코드 등록
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/support/insert.do")
	public ModelAndView insertSupport(HttpServletRequest request, @RequestBody CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		CommonHashMap<String, Object> codeView = commonCodeService.selectSupportCodeView(commonCodeVO);

		if (codeView == null) {
			commonCodeService.mergeSupportCode(commonCodeVO);

			mav.addObject("result", true);
			mav.addObject("message", "Success");
		} else {
			mav.addObject("result", false);
			// 중복된 공통코드가 존재합니다.
			mav.addObject("message", messageSource.getMessage("commoncode.code.duplication"));
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(물류지원) 코드 수정
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/support/update.do")
	public ModelAndView updateSupport(HttpServletRequest request, @RequestBody CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		commonCodeService.mergeSupportCode(commonCodeVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(물류지원) 코드 삭제
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/support/deleteList.do")
	public ModelAndView deleteSupport(HttpServletRequest request, @RequestBody CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		if (commonCodeVO.getDeleteCodeList().size() > 0) {
			boolean isValid = true;
			for (Map<String, Object> map : commonCodeVO.getDeleteCodeList()) {
				CommonCodeVO ccVO = new CommonCodeVO();

				String cls = (String)map.get("cls");
				ccVO.setCls(cls);

				List<CommonHashMap<String, Object>> detailList = commonCodeService.selectSupportCodeDetailList(ccVO);

				if (detailList.size() > 0) {
					isValid = false;

					break;
				}
			}

			if (isValid) {
				commonCodeService.deleteSupportCode(commonCodeVO);

				mav.addObject("result", true);
				mav.addObject("message", "Success");
			} else {
				mav.addObject("result", false);
				// 상세목록이 존재합니다. 상세목록을 먼저 삭제하세요.
				mav.addObject("message", messageSource.getMessage("commoncode.code.detail.exist"));
			}
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(무역상담)
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/counsel/list.do")
	public ModelAndView counselList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("commoncode/counsel/list");

		return mav;
	}

	/**
	 * 공통코드관리(무역상담) 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/counsel/selectList.do")
	public ModelAndView selectCounselList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		int totalCnt = commonCodeService.selectCounselCodeTotalCnt(searchVO);
		mav.addObject("resultCnt", totalCnt);

		List<CommonHashMap<String, Object>> codeList = new ArrayList<CommonHashMap<String,Object>>();
		if (totalCnt > 0) {
			codeList = commonCodeService.selectCounselCodeList(searchVO);
		}
		mav.addObject("resultList", codeList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(무역상담) 등록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/counsel/regist.do")
	public ModelAndView counselRegist(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			mav.setViewName("commoncode/counsel/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 공통코드관리(무역상담) 수정
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/counsel/modify.do")
	public ModelAndView counselModify(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			CommonHashMap<String, Object> codeView = commonCodeService.selectCounselCodeView(searchVO);
			mav.addObject("resultView", codeView);

			mav.setViewName("commoncode/counsel/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 공통코드관리(무역상담) 코드상세목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/counsel/detailList.do")
	public ModelAndView counselDetailList(HttpServletRequest request, @ModelAttribute("searchVO")CommonCodeVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<CommonHashMap<String, Object>> datailList = commonCodeService.selectCounselCodeDetailList(searchVO);
		mav.addObject("resultList", datailList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(무역상담) 코드 등록
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/counsel/insert.do")
	public ModelAndView insertCounsel(HttpServletRequest request, @RequestBody CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		CommonHashMap<String, Object> codeView = commonCodeService.selectCounselCodeView(commonCodeVO);

		if (codeView == null) {
			// 공통코드 삭제여부
			int validCnt = commonCodeService.selectCounselDeleteValidation(commonCodeVO);

			if (validCnt > 0) {
				mav.addObject("result", false);
				// 삭제된 공통코드입니다 다른 코드로 변경해주세요.
				mav.addObject("message", messageSource.getMessage("commoncode.code.delete.status"));
			} else {
				commonCodeService.mergeCounselCode(commonCodeVO);

				mav.addObject("result", true);
				mav.addObject("message", "Success");
			}
		} else {
			mav.addObject("result", false);
			// 중복된 공통코드가 존재합니다.
			mav.addObject("message", messageSource.getMessage("commoncode.code.duplication"));
		}

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(무역상담) 코드 수정
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/counsel/update.do")
	public ModelAndView updateCounsel(HttpServletRequest request, @RequestBody CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		commonCodeService.mergeCounselCode(commonCodeVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 공통코드관리(무역상담) 코드 삭제
	 *
	 * @param request
	 * @param commonCodeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/counsel/deleteList.do")
	public ModelAndView deleteCounsel(HttpServletRequest request, @RequestBody CommonCodeVO commonCodeVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		if (commonCodeVO.getDeleteCodeList().size() > 0) {
			boolean isValid = true;
			for (Map<String, Object> map : commonCodeVO.getDeleteCodeList()) {
				CommonCodeVO ccVO = new CommonCodeVO();

				String cdGrpId = (String)map.get("cdGrpId");
				ccVO.setCdGrpId(cdGrpId);

				List<CommonHashMap<String, Object>> detailList = commonCodeService.selectCounselCodeDetailList(ccVO);

				if (detailList.size() > 0) {
					isValid = false;

					break;
				}
			}

			if (isValid) {
				commonCodeService.deleteCounselCode(commonCodeVO);

				mav.addObject("result", true);
				mav.addObject("message", "Success");
			} else {
				mav.addObject("result", false);
				// 상세목록이 존재합니다. 상세목록을 먼저 삭제하세요.
				mav.addObject("message", messageSource.getMessage("commoncode.code.detail.exist"));
			}
		}

		mav.setViewName("jsonView");

		return mav;
	}
}