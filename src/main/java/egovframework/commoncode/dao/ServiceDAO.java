package egovframework.commoncode.dao;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.stereotype.Repository;

import egovframework.common.dao.CommonDAO;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import egovframework.commoncode.vo.CommonCodeVO;

@Repository
public class ServiceDAO extends CommonDAO {

	/**
	 * 용역/전자적 무체물 코드 목록
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectServiceCodeList(SearchVO searchVO) throws Exception {
		return selectList("CommonCodeSQL.selectServiceCodeList", searchVO);
	}
	
	/**
	 * 용역/전자적 무체물 코드 총 건수
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectServiceCodeTotalCnt(SearchVO searchVO) throws Exception {
		return selectOne("CommonCodeSQL.selectServiceCodeTotalCnt", searchVO);
	}
	
	/**
	 * 용역/전자적 무체물 코드 조회
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public CommonHashMap<String, Object> selectServiceCodeView(SearchVO searchVO) throws Exception {
		return selectOne("CommonCodeSQL.selectServiceCodeView", searchVO);
	}
	
	/**
	 * 용역/전자적 무체물 상세코드 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectServiceCodeDetailList(SearchVO searchVO) throws Exception {
		return selectList("CommonCodeSQL.selectServiceCodeDetailList", searchVO);
	}
	
	/**
	 * 용역/전자적 무체물 코드 저장(등록 / 수정)
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int mergeServiceCode(CommonCodeVO commonCodeVO) throws Exception {
		return update("CommonCodeSQL.mergeServiceCode", commonCodeVO);
	}
	
	/**
	 * 용역/전자적 무체물 코드 삭제
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int deleteServiceCode(CommonCodeVO commonCodeVO) throws Exception {
		return delete("CommonCodeSQL.deleteServiceCode", commonCodeVO);
	}
	
	/**
	 * 용역/전자적 무체물 상세코드 저장(등록 / 수정)
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int mergeServiceCodeDetail(CommonCodeVO commonCodeVO) throws Exception {
		return update("CommonCodeSQL.mergeServiceCodeDetail", commonCodeVO);
	}
	
	/**
	 * 용역/전자적 무체물 상세코드 삭제
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int deleteServiceCodeDetail(CommonCodeVO commonCodeVO) throws Exception {
		return delete("CommonCodeSQL.deleteServiceCodeDetail", commonCodeVO);
	}
}