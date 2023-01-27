package egovframework.sample.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.attach.dao.AttachDAO;
import egovframework.attach.vo.AttachVO;
import egovframework.common.Constants;
import egovframework.common.util.AttachUtil;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import egovframework.sample.dao.KmemberDAO;
import egovframework.sample.dao.TradeDAO;
import egovframework.sample.vo.SampleVO;

@Service
public class SampleService {
	private static final Logger LOGGER = LoggerFactory.getLogger(SampleService.class);

	/** KmemberDAO */
	@Autowired
	private KmemberDAO kmemberDAO;
	
	/** TradeDAO */
	@Autowired
	private TradeDAO tradeDAO;
	
	@Autowired
	private AttachDAO attachDAO;
	
	// default = readOnly
	public List<CommonHashMap<String, Object>> selectKmemberList(SearchVO searchVO) throws Exception {
		return kmemberDAO.selectSampleList(searchVO);
	}
	
	public List<CommonHashMap<String, Object>> selectTradeList(SearchVO searchVO) throws Exception {
		return tradeDAO.selectSampleList(searchVO);
	}
	
	public List<CommonHashMap<String, Object>> selectBoardList(SearchVO searchVO) throws Exception {
		return kmemberDAO.selectBoardList(searchVO);
	}
	
	public int selectBoardTotalCnt(SearchVO searchVO) throws Exception {
		return kmemberDAO.selectBoardTotalCnt(searchVO);
	}
	
	public CommonHashMap<String, Object> selectBoardView(HttpServletRequest request, SearchVO searchVO) throws Exception {
		// 조회수 수정
		kmemberDAO.updateBoardViewCnt(searchVO);
		
		CommonHashMap<String, Object> resultView = kmemberDAO.selectBoardView(searchVO);
		
		Object attachSeq = resultView.get("attachSeq");
		
		if (attachSeq != null) {
			AttachUtil attachUtil = new AttachUtil(attachDAO);
    		
    		AttachVO attachVO = new AttachVO();
    		// 업무구분
    		attachVO.setGroupId(Constants.GROUP_ID_MEMBERSHIP);
    		attachVO.setAttachSeq(attachSeq.toString());
    		
    		request.setAttribute("attachList", attachUtil.list(attachVO));
		}
		
		return resultView;
	}
	
	// default = REQUIRED
	@Transactional
    public void insertBoardArticle(MultipartHttpServletRequest request, SampleVO sampleVO) throws Exception {
		// 다중 파일 멀티 업로드
		AttachUtil attachUtil = new AttachUtil(attachDAO);
		sampleVO.setAttachSeq(attachUtil.uploadFileList(request, sampleVO.getAttachSeq(), Constants.GROUP_ID_MEMBERSHIP, "attachFile"));
    	
    	kmemberDAO.insertBoardArticle(sampleVO);
    	
    	// 트랜잭션 테스트
    	// tradeDAO.insertBoardArticle(sampleVO);
    }
	
	@Transactional
	public void updateBoardArticle(MultipartHttpServletRequest request, SampleVO sampleVO) throws Exception {
		// 다중 파일 멀티 업로드
		AttachUtil attachUtil = new AttachUtil(attachDAO);
		sampleVO.setAttachSeq(attachUtil.uploadFileList(request, sampleVO.getAttachSeq(), Constants.GROUP_ID_MEMBERSHIP, "attachFile"));
    	
		kmemberDAO.updateBoardArticle(sampleVO);
    }
	
	@Transactional
	public int deleteBoardArticle(HttpServletRequest request, SampleVO sampleVO) throws Exception {
		return kmemberDAO.deleteBoardArticle(sampleVO);
	}
	
	public List<CommonHashMap<String, String>> selectExcelForHeaderList(SearchVO searchVO) throws Exception {
		return kmemberDAO.selectExcelForHeaderList(searchVO);
	}
	
	public List<CommonHashMap<String, String>> selectExcelForDoubleList(SearchVO searchVO) throws Exception {
		return kmemberDAO.selectExcelForDoubleList(searchVO);
	}
	
	public List<CommonHashMap<String, String>> selectExcelForMultiList1(SearchVO searchVO) throws Exception {
		return kmemberDAO.selectExcelForMultiList1(searchVO);
	}
	
	public List<CommonHashMap<String, String>> selectExcelForMultiList2(SearchVO searchVO) throws Exception {
		return kmemberDAO.selectExcelForMultiList2(searchVO);
	}
	
	public List<CommonHashMap<String, String>> selectExcelForMultiSheet1(SearchVO searchVO) throws Exception {
		return tradeDAO.selectExcelForMultiSheet1(searchVO);
	}
	
	public List<CommonHashMap<String, String>> selectExcelForMultiSheet2(SearchVO searchVO) throws Exception {
		return tradeDAO.selectExcelForMultiSheet2(searchVO);
	}
}