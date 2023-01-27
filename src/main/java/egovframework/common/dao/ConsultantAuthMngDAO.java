package egovframework.common.dao;

import org.springframework.stereotype.Repository;

@Repository("consultantAuthMngDAO")
public class ConsultantAuthMngDAO extends CommonDAO {
    public void deleteConsultantAuth(String memberId) throws Exception {
    	delete("ConsultantAuthMng.deleteConsultantAuth", memberId);
    }
    
    /*
    public void insertConsultantAuth(HashMap<String, Object> paramMap) throws Exception {
    	insert("ConsultantAuthMng.insertConsultantAuth", paramMap);
    }
    */
}