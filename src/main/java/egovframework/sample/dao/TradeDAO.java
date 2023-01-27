package egovframework.sample.dao;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.stereotype.Repository;

import egovframework.common.dao.CommonDAO;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import egovframework.sample.vo.SampleVO;

@Repository
public class TradeDAO extends CommonDAO {
	
	public List<CommonHashMap<String, Object>> selectSampleList(SearchVO searchVO) throws Exception {
		return selectList("TradeSQL.selectSampleList", searchVO);
	}
	
	/**
	 * 게시물 등록
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int insertBoardArticle(SampleVO sampleVO) throws Exception {
		return insert("TradeSQL.insertBoardArticle", sampleVO);
	}
	
	public List<CommonHashMap<String, String>> selectExcelForMultiSheet1(SearchVO searchVO) throws Exception {
		return selectList("TradeSQL.selectExcelForMultiSheet1", searchVO);
	}
	
	public List<CommonHashMap<String, String>> selectExcelForMultiSheet2(SearchVO searchVO) throws Exception {
		return selectList("TradeSQL.selectExcelForMultiSheet2", searchVO);
	}
}