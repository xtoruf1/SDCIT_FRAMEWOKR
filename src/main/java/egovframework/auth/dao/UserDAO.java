package egovframework.auth.dao;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.stereotype.Repository;

import egovframework.common.dao.CommonDAO;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;

@Repository
public class UserDAO extends CommonDAO {
	// KTSTMEM DB로 접속
	/*@Resource(name = "ktstmemSqlSession")
	public void setSqlSessionFactory(SqlSessionFactory sqlSession) {
		super.setSqlSessionFactory(sqlSession);
	}*/

	/**
	 * 사용자 선택 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectUserList(SearchVO searchVO) throws Exception {
		return selectList("UserSQL.selectUserList", searchVO);
	}

	/**
	 * 사용자 확인
	 * @param userId
	 * @return
	 */
	public String selectCheckUserId(String userId) {
		return selectOne("UserSQL.selectCheckUserId", userId);
	}

}