package egovframework.sample.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.common.dao.CommonDAO;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import egovframework.sample.vo.SampleVO;

@Repository
public class KmemberDAO extends CommonDAO {
	public List<CommonHashMap<String, Object>> selectSampleList(SearchVO searchVO) throws Exception {
		return selectList("KmemberSQL.selectSampleList", searchVO);
	}

	/**
	 * 게시물 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectBoardList(SearchVO searchVO) throws Exception {
		return selectList("KmemberSQL.selectBoardList", searchVO);
	}

	/**
	 * 게시물 목록 카운트
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectBoardTotalCnt(SearchVO searchVO) throws Exception {
		return selectOne("KmemberSQL.selectBoardTotalCnt", searchVO);
	}

	/**
	 * 게시물 조회
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public CommonHashMap<String, Object> selectBoardView(SearchVO searchVO) throws Exception {
		return selectOne("KmemberSQL.selectBoardView", searchVO);
	}

	/**
	 * 게시물 조회수 수정
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int updateBoardViewCnt(SearchVO searchVO) throws Exception {
		return update("KmemberSQL.updateBoardViewCnt", searchVO);
	}

	/**
	 * 게시물 등록
	 *
	 * @param sampleVO
	 * @return
	 * @throws Exception
	 */
	public int insertBoardArticle(SampleVO sampleVO) throws Exception {
		return insert("KmemberSQL.insertBoardArticle", sampleVO);
	}

	/**
	 * 게시물 수정
	 *
	 * @param sampleVO
	 * @return
	 * @throws Exception
	 */
	public int updateBoardArticle(SampleVO sampleVO) throws Exception {
		return update("KmemberSQL.updateBoardArticle", sampleVO);
	}

	/**
	 * 게시물 삭제
	 *
	 * @param sampleVO
	 * @return
	 * @throws Exception
	 */
	public int deleteBoardArticle(SampleVO sampleVO) throws Exception {
		return update("KmemberSQL.deleteBoardArticle", sampleVO);
	}

	public List<CommonHashMap<String, String>> selectExcelForHeaderList(SearchVO searchVO) throws Exception {
		return selectList("KmemberSQL.selectExcelForHeaderList", searchVO);
	}

	public List<CommonHashMap<String, String>> selectExcelForDoubleList(SearchVO searchVO) throws Exception {
		return selectList("KmemberSQL.selectExcelForDoubleList", searchVO);
	}

	public List<CommonHashMap<String, String>> selectExcelForMultiList1(SearchVO searchVO) throws Exception {
		return selectList("KmemberSQL.selectExcelForMultiList1", searchVO);
	}

	public List<CommonHashMap<String, String>> selectExcelForMultiList2(SearchVO searchVO) throws Exception {
		return selectList("KmemberSQL.selectExcelForMultiList2", searchVO);
	}
}