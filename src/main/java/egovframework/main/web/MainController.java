package egovframework.main.web;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @author 이승준
 *
 * 메인 Controller
 */
@Controller
public class MainController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MainController.class);
	
	/**
	 * 초기 화면
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/")
	public ModelAndView index(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName("index");
		
		return mav;
	}
	
	/**
	 * 메인 화면
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main.do")
    public ModelAndView main(HttpServletRequest request, ModelMap model) throws Exception {
    	ModelAndView mav = new ModelAndView();
		
    	mav.setViewName("dashboard/main/main");
		
		return mav;
	}
}