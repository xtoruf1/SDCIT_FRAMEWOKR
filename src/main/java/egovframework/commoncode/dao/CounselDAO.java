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
public class CounselDAO extends CommonDAO {

	/**
	 * 무역 상담 코드 목록
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectCounselCodeList(SearchVO searchVO) throws Exception {
		return selectList("CommonCodeSQL.selectCounselCodeList", searchVO);
	}
	
	/**
	 * 무역 상담 코드 총 건수
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectCounselCodeTotalCnt(SearchVO searchVO) throws Exception {
		return selectOne("CommonCodeSQL.selectCounselCodeTotalCnt", searchVO);
	}
	
	/**
	 * 무역 상담 코드 조회
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public CommonHashMap<String, Object> selectCounselCodeView(SearchVO searchVO) throws Exception {
		return selectOne("CommonCodeSQL.selectCounselCodeView", searchVO);
	}
	
	/**
	 * 무역 상담 상세코드 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectCounselCodeDetailList(SearchVO searchVO) throws Exception {
		return selectList("CommonCodeSQL.selectCounselCodeDetailList", searchVO);
	}
	
	/**
	 * 무역 상담 상세코드 목록(사용중인것 만)
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectCounselDetailUseList(SearchVO searchVO) throws Exception {
		return selectList("CommonCodeSQL.selectCounselDetailUseList", searchVO);
	}
	
	/**
	 * 무역 상담 코드 삭제 여부 체크
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectCounselDeleteValidation(SearchVO searchVO) throws Exception {
		return selectOne("CommonCodeSQL.selectCounselDeleteValidation", searchVO);
	}
	
	/**
	 * 무역 상담 코드 저장(등록 / 수정)
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int mergeCounselCode(CommonCodeVO commonCodeVO) throws Exception {
		return update("CommonCodeSQL.mergeCounselCode", commonCodeVO);
	}
	
	/**
	 * 무역 상담 코드 삭제
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int deleteCounselCode(CommonCodeVO commonCodeVO) throws Exception {
		return delete("CommonCodeSQL.deleteCounselCode", commonCodeVO);
	}
	
	/**
	 * 무역 상담 상세코드 저장(등록 / 수정)
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int mergeCounselCodeDetail(CommonCodeVO commonCodeVO) throws Exception {
		return update("CommonCodeSQL.mergeCounselCodeDetail", commonCodeVO);
	}
	
	/**
	 * 무역 상담 상세코드 삭제
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int deleteCounselCodeDetail(CommonCodeVO commonCodeVO) throws Exception {
		return delete("CommonCodeSQL.deleteCounselCodeDetail", commonCodeVO);
	}
}