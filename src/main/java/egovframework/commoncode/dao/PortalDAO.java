package egovframework.commoncode.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.common.dao.CommonDAO;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import egovframework.commoncode.vo.CommonCodeVO;

@Repository
public class PortalDAO extends CommonDAO {
	/**
	 * 숫자 형식 정렬
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectPortalCodeListOrderByNumber(SearchVO searchVO) throws Exception {
		return selectList("CommonCodeSQL.selectPortalCodeListOrderByNumber", searchVO);
	}

	/**
	 * 업무포털 코드 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectPortalCodeList(SearchVO searchVO) throws Exception {
		return selectList("CommonCodeSQL.selectPortalCodeList", searchVO);
	}

	/**
	 * 업무포털 코드 총 건수
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectPortalCodeTotalCnt(SearchVO searchVO) throws Exception {
		return selectOne("CommonCodeSQL.selectPortalCodeTotalCnt", searchVO);
	}

	/**
	 * 업무포털 코드 조회
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public CommonHashMap<String, Object> selectPortalCodeView(SearchVO searchVO) throws Exception {
		return selectOne("CommonCodeSQL.selectPortalCodeView", searchVO);
	}

	/**
	 * 업무포털 상세코드 목록(전부)
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectPortalCodeDetailAllList(SearchVO searchVO) throws Exception {
		return selectList("CommonCodeSQL.selectPortalCodeDetailAllList", searchVO);
	}

	/**
	 * 업무포털 상세코드 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectPortalCodeDetailList(SearchVO searchVO) throws Exception {
		return selectList("CommonCodeSQL.selectPortalCodeDetailList", searchVO);
	}

	/**
	 * 업무포털 코드 저장(등록 / 수정)
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int mergePortalCode(CommonCodeVO commonCodeVO) throws Exception {
		return update("CommonCodeSQL.mergePortalCode", commonCodeVO);
	}

	/**
	 * 업무포털 상세코드 저장(등록 / 수정)
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int mergePortalCodeDetail(CommonCodeVO commonCodeVO) throws Exception {
		return update("CommonCodeSQL.mergePortalCodeDetail", commonCodeVO);
	}
}