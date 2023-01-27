package egovframework.commoncode.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.common.dao.CommonDAO;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import egovframework.commoncode.vo.CommonCodeVO;

@Repository
public class SupportDAO extends CommonDAO {
	// RADIS DB로 접속
	/*
	@Resource(name = "radisSqlSession")
	public void setSqlSessionFactory(SqlSessionFactory sqlSession) {
		super.setSqlSessionFactory(sqlSession);
	}
	*/
	
	/**
	 * 물류지원 코드 목록
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectSupportCodeList(SearchVO searchVO) throws Exception {
		// return selectList("CommonCodeSQL.selectSupportCodeList", searchVO);
		return null;
	}
	
	/**
	 * 물류지원 코드 총 건수
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectSupportCodeTotalCnt(SearchVO searchVO) throws Exception {
		// return selectOne("CommonCodeSQL.selectSupportCodeTotalCnt", searchVO);
		return 0;
	}
	
	/**
	 * 물류지원 코드 조회
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public CommonHashMap<String, Object> selectSupportCodeView(SearchVO searchVO) throws Exception {
		// return selectOne("CommonCodeSQL.selectSupportCodeView", searchVO);
		return null;
	}
	
	/**
	 * 물류지원 상세코드 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectSupportCodeDetailList(SearchVO searchVO) throws Exception {
		// return selectList("CommonCodeSQL.selectSupportCodeDetailList", searchVO);
		return null;
	}
	
	/**
	 * 물류지원 코드 저장(등록 / 수정)
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int mergeSupportCode(CommonCodeVO commonCodeVO) throws Exception {
		// return update("CommonCodeSQL.mergeSupportCode", commonCodeVO);
		return 0;
	}
	
	/**
	 * 물류지원 코드 삭제
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int deleteSupportCode(CommonCodeVO commonCodeVO) throws Exception {
		// return update("CommonCodeSQL.deleteSupportCode", commonCodeVO);
		return 0;
	}
	
	/**
	 * 물류지원 상세코드 저장(등록 / 수정)
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int mergeSupportCodeDetail(CommonCodeVO commonCodeVO) throws Exception {
		// return update("CommonCodeSQL.mergeSupportCodeDetail", commonCodeVO);
		return 0;
	}
	
	/**
	 * 물류지원 상세코드 삭제
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int deleteSupportCodeDetail(CommonCodeVO commonCodeVO) throws Exception {
		// return update("CommonCodeSQL.deleteSupportCodeDetail", commonCodeVO);
		return 0;
	}
}