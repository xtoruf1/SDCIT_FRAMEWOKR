package egovframework.common.login.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.common.login.dao.LoginDAO;
import egovframework.common.login.vo.LoginUserVO;
import egovframework.common.util.StringUtil;

@Service
public class LoginService {
    /** LoginDAO */
	@Autowired
	private LoginDAO loginDAO;
    
    /**
	 * 일반 로그인을 처리한다
	 * 
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
    public LoginUserVO actionLogin(LoginUserVO loginVO) throws Exception {
    	LoginUserVO vo = new LoginUserVO();
    	
    	if (StringUtil.isNotEmpty(loginVO.getId())) {
    		vo = loginDAO.actionLogin(loginVO);
    	}

    	return vo;
    }
}