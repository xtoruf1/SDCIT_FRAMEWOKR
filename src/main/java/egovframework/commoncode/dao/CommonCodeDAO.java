package egovframework.commoncode.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.common.dao.CommonDAO;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;

@Repository
public class CommonCodeDAO extends CommonDAO {
	/**
	 * 공통코드 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectCommonCodeList(SearchVO searchVO) throws Exception {
		return selectList("CommonCodeSQL.selectCommonCodeList", searchVO);
	}

	/**
	 * 그룹코드 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectGroupList(SearchVO searchVO) throws Exception {
		return selectList("CommonCodeSQL.selectGroupList", searchVO);
	}

	/**
	 * 그룹코드 등록/수정
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int mergeGroupCode(SearchVO searchVO) throws Exception {
		return update("CommonCodeSQL.mergeGroupCode", searchVO);
	}

	/**
	 * 그룹코드 삭제
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int deleteGroupCode(SearchVO searchVO) throws Exception {
		return delete("CommonCodeSQL.deleteGroupCode", searchVO);
	}

	/**
	 * 코드 등록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int insertCodeList(SearchVO searchVO) throws Exception {
		return insert("CommonCodeSQL.insertCodeList", searchVO);
	}

	/**
	 * 코드 수정
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int updateCode(SearchVO searchVO) throws Exception {
		return update("CommonCodeSQL.updateCode", searchVO);
	}

	/**
	 * 코드 삭제
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int deleteCodeList(SearchVO searchVO) throws Exception {
		return delete("CommonCodeSQL.deleteCodeList", searchVO);
	}

	/**
	 * 상세코드 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectCodeDetailList(SearchVO searchVO) throws Exception {
		return selectList("CommonCodeSQL.selectCodeDetailList", searchVO);
	}

	/**
	 * 공통분류코드 목록
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectClassCodeList(SearchVO searchVO) throws Exception {
		return selectList("CommonCodeSQL.selectClassCodeList", searchVO);
	}
	
	/**
	 * 공통분류코드 총 건수
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectClassCodeTotalCnt(SearchVO searchVO) throws Exception {
		return selectOne("CommonCodeSQL.selectClassCodeTotalCnt", searchVO);
	}
	
	/**
	 * 공통분류코드 조회
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public CommonHashMap<String, Object> selectClassCodeView(SearchVO searchVO) throws Exception {
		return selectOne("CommonCodeSQL.selectClassCodeView", searchVO);
	}
	
	/**
	 * 공통분류코드 등록
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int insertClassCode(SearchVO searchVO) throws Exception {
		return insert("CommonCodeSQL.insertClassCode", searchVO);
	}
	
	/**
	 * 공통분류코드 수정
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int updateClassCode(SearchVO searchVO) throws Exception {
		return update("CommonCodeSQL.updateClassCode", searchVO);
	}
	
	/**
	 * 공통분류코드 삭제
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int deleteClassCode(SearchVO searchVO) throws Exception {
		return delete("CommonCodeSQL.deleteClassCode", searchVO);
	}
	
	/**
	 * 공통분류 코드목록
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectSearchClassList() throws Exception {
		return selectList("CommonCodeSQL.selectSearchClassList");
	}
}