package egovframework.common.dao;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.stereotype.Repository;

@Repository
public class ConsultantAuthCheckTradeDAO extends CommonDAO {

	public int getConsultantCount(String memberId) throws Exception {
		return selectOne("ConsultantAuthCheck.getConsultantCount", memberId);
	}
	
	public List<HashMap<String, Object>> getConsultantAuthProdList(String memberId) throws Exception {
		return selectList("ConsultantAuthCheck.getConsultantAuthProdList", memberId);
	}
	
	public List<HashMap<String, Object>> getConsultantAuthNotProdList(String memberId) throws Exception {
		return selectList("ConsultantAuthCheck.getConsultantAuthNotProdList", memberId);
	}
}