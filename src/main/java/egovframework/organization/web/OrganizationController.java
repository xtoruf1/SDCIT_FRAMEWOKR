package egovframework.organization.web;

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

import egovframework.common.exception.CommonException;
import egovframework.common.vo.CommonHashMap;
import egovframework.organization.service.OrganizationService;
import egovframework.organization.vo.OrganizationVO;

@Controller
@RequestMapping(value = "/organization")
public class OrganizationController {
	private static final Logger LOGGER = LoggerFactory.getLogger(OrganizationController.class);
	
	/** OrganizationService */
	@Autowired
	private OrganizationService organizationService;
	
	/**
	 * 조직관리
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/list.do")
	public ModelAndView list(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName("organization/list");
		
		return mav;
	}
	
	/**
	 * 조직 목록
	 * 
	 * @param request
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectList.do")
	public ModelAndView selectList(HttpServletRequest request, @ModelAttribute("organizationVO")OrganizationVO searchVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		List<CommonHashMap<String, Object>> organizationList = organizationService.selectOrganizationList(searchVO);
		
		mav.addObject("data", organizationList);
		
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	
	@RequestMapping(value = "/saveOrganization.do")
	public ModelAndView saveOrganization(HttpServletRequest request, @RequestBody OrganizationVO organizationVO, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		organizationService.saveOrganization(organizationVO);
		
		mav.setViewName("jsonView");
		
		return mav;
	}
}