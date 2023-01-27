package egovframework.organization.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.common.dao.CommonDAO;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;

@Repository
public class OrganizationDAO extends CommonDAO {
	/**
	 * 조직 목록
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectOrganizationList(SearchVO searchVO) throws Exception {
		return selectList("OrganizationSQL.selectOrganizationList", searchVO);
	}
	
	/**
	 * 조직 등록
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int insertOrganizationList(SearchVO searchVO) throws Exception {
		return insert("OrganizationSQL.insertOrganizationList", searchVO);
	}
	
	/**
	 * 조직 수정
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int updateOrganization(SearchVO searchVO) throws Exception {
		return update("OrganizationSQL.updateOrganization", searchVO);
	}
	
	/**
	 * 조직 삭제
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int deleteOrganizationList(SearchVO searchVO) throws Exception {
		return delete("OrganizationSQL.deleteOrganizationList", searchVO);
	}
}