package egovframework.member.web;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.common.bean.CommonMessageSource;
import egovframework.common.login.LoginManager;
import egovframework.common.login.vo.LoginUserVO;
import egovframework.common.util.HttpUtil;
import egovframework.common.util.PropertyUtil;
import egovframework.common.util.StringUtil;
import egovframework.common.vo.CommonHashMap;
import egovframework.member.service.MemberService;
import egovframework.member.vo.MemberVO;

@Controller
public class MemberController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MemberController.class);

	/** MemberService */
	@Autowired
	private MemberService memberService;

	@Autowired
	CommonMessageSource messageSource;

	/**
	 * 로그인 화면
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login.do")
	public ModelAndView login(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("login");

		return mav;
	}

	/**
	 * 게이트웨이 화면
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/gateway.do")
	@SuppressWarnings("unchecked")
	public ModelAndView gateway(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("gateway");

		List<Map<String, Object>> menuList = (List<Map<String, Object>>)request.getAttribute("systemMenuList");

		if (menuList.size() == 1) {
			String redirectUrl = String.valueOf(menuList.get(0).get("url"));

			mav.setViewName("redirect:" + redirectUrl);
		} else {
			mav.addObject("authMenuCnt", menuList.size());
		}

		return mav;
	}

	/**
	 * 로그인 처리
	 *
	 * @param request
	 * @param memberVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/processLogin.do")
    public ModelAndView processLogin(HttpServletRequest request, @ModelAttribute("memberVO")MemberVO memberVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		LoginManager manager = LoginManager.getInstance();

		// 패스워드 인코딩(SHA-256)
//		String pwd = StringUtil.sha256Encode(memberVO.getPwd());
//		memberVO.setPwd(pwd);
    	LoginUserVO user = memberService.selectMemberInfo(memberVO);

    	String contextPath = request.getContextPath();

    	if (user == null) {
    		mav.addObject("message", messageSource.getMessage("member.login.infomation.incorrect"));
    		mav.addObject("next", contextPath + "/login.do");
    	} else {
    		// 관리자 권한만 접속가능
    		if (!user.getCntrtCd().equals("A")) {
    			mav.addObject("message", messageSource.getMessage("member.not.admin.user"));
    			mav.addObject("next", contextPath + "/login.do");
    		// 휴면상태 아이디 접속불가
    		} else if (user.getDormantYn().equals("Y")) {
    			mav.addObject("message", messageSource.getMessage("member.dormant.user"));
    			mav.addObject("next", contextPath + "/login.do");
    		// 탈퇴상태 아이디 접속불가
    		} else if (user.getLeaveYn().equals("Y")) {
    			mav.addObject("message", messageSource.getMessage("member.leave.user"));
    			mav.addObject("next", contextPath + "/login.do");
    		} else {
    			// 공통코드(로그인 세션시간)
    			String sessionTime = PropertyUtil.getProperty("globals.sessionTime");

    			request.getSession().setAttribute("user", user);
        		request.getSession().setMaxInactiveInterval(Integer.parseInt(sessionTime));
        		manager.setLogon(user.getLoginId(), request);

    			memberVO.setMemberSeq(user.getMemberSeq());
    			//memberService.updateLoginDt(memberVO);

    			mav.addObject("message", "");
    			mav.addObject("next", contextPath + "/gateway.do");
    		}
    	}

    	mav.setViewName("jsonView");

    	return mav;
    }

	/**
	 * 로그아웃 처리
	 *
	 * @param request
	 * @param memberVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/processLogout.do")
	public ModelAndView processLogout(HttpServletRequest request, @ModelAttribute("memberVO")MemberVO memberVO) throws Exception {
		ModelAndView mav = new ModelAndView();

		LoginManager loginManager = LoginManager.getInstance();
		loginManager.setLogoff(HttpUtil.getUser(request).getLoginId());
		request.getSession().invalidate();

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자관리
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/member/list.do")
	public ModelAndView list(HttpServletRequest request, @ModelAttribute("searchVO")MemberVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("member/list");

		return mav;
	}

	/**
	 * 사용자 목록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/member/selectList.do")
	public ModelAndView selectList(HttpServletRequest request, @ModelAttribute("memberVO")MemberVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		searchVO.setPagingInfo();

		int totalCnt = memberService.selectMemberTotalCnt(searchVO);
		mav.addObject("resultCnt", totalCnt);

		List<CommonHashMap<String, Object>> memberList = new ArrayList<CommonHashMap<String,Object>>();
		if (totalCnt > 0) {
			memberList = memberService.selectMemberList(searchVO);
		}
		mav.addObject("resultList", memberList);

		searchVO.setPagingCount(totalCnt);
		mav.addObject("paginationInfo", searchVO.getPaginationInfo());

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 등록/수정 화면
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/member/write.do")
	public ModelAndView write(HttpServletRequest request, @ModelAttribute("memberVO")MemberVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			if (searchVO.getMemberSeq() != 0) {
				CommonHashMap<String, Object> memberView = memberService.selectMemberView(searchVO);
				mav.addObject("resultView", memberView);
			}

			mav.setViewName("member/write");
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());

			mav.setViewName("redirect:" + request.getContextPath() + "/error.do");
		}

		return mav;
	}

	/**
	 * 사용자 등록
	 *
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/member/insert.do")
	public ModelAndView insert(HttpServletRequest request, @ModelAttribute("memberVO")MemberVO memberVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		memberService.insertMemeber(memberVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 수정
	 *
	 * @param request
	 * @param memberVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/member/update.do")
	public ModelAndView update(HttpServletRequest request, @ModelAttribute("memberVO")MemberVO memberVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		memberService.updateMemeber(memberVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 휴면처리
	 *
	 * @param request
	 * @param memberVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/member/dormantUpdate.do")
	public ModelAndView dormantUpdate(HttpServletRequest request, @ModelAttribute("memberVO")MemberVO memberVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		memberService.updateMemeberDormant(memberVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 사용자 탈퇴처리
	 *
	 * @param request
	 * @param memberVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/member/dormantLeave.do")
	public ModelAndView dormantLeave(HttpServletRequest request, @ModelAttribute("memberVO")MemberVO memberVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		memberService.updateMemeberLeave(memberVO);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 조직 목록(팝업)
	 *
	 * @param request
	 * @param memberVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/member/popup/deptList.do")
	public ModelAndView popupProgramList(HttpServletRequest request, @ModelAttribute("memberVO")MemberVO memberVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("popup/member/popup/deptList");

		return mav;
	}
}