package egovframework.common.login.dao;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.stereotype.Repository;

import egovframework.common.dao.CommonDAO;
import egovframework.common.login.vo.LoginUserVO;

@Repository
public class LoginDAO extends CommonDAO {

	/**
	 * 일반 로그인을 처리한다.
	 * 
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
    public LoginUserVO actionLogin(LoginUserVO loginVO) throws Exception {
    	String id = loginVO.getId();
    	
    	return selectOne("KitaLoginSQL.getLoginInfo", id);
    }
}