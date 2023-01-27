package egovframework.attach.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.attach.vo.AttachVO;
import egovframework.common.dao.CommonDAO;

/**
 * @author 이승준
 *
 * 첨부파일 DAO
 */
@Repository
public class AttachDAO extends CommonDAO {
	/**
     * 첨부파일 그룹시퀀스 생성
     * 
     * @param attachVO
     * @return
     * @throws Exception
     */
	public String getNewAttachSeq(AttachVO attachVO) throws Exception {
		return selectOne("AttachSQL.getNewAttachSeq", attachVO);
    }
	
	/**
     * 첨부파일 파일시퀀스 생성
     * 
     * @param attachVO
     * @return
     * @throws Exception
     */
	public int getNewFileSeq(AttachVO attachVO) throws Exception {
		return selectOne("AttachSQL.getNewFileSeq", attachVO);
    }
	
	/**
	 * 첨부파일 등록
	 * 
	 * @param attachVO
	 * @throws Exception
	 */
	public int insertFile(AttachVO attachVO) throws Exception {
		return insert("AttachSQL.insertFile", attachVO);
	}
    
    /**
     * 첨부파일 목록 조회
     * 
     * @param attachVO
     * @return
     * @throws Exception
     */
	public List<AttachVO> fileList(AttachVO attachVO) throws Exception {
    	return selectList("AttachSQL.fileList", attachVO);
    }
	
	/**
	 * 첨부파일 상세 조회
	 * 
	 * @param attachVO
	 * @return
	 * @throws Exception
	 */
	public AttachVO fileInfo(AttachVO attachVO) throws Exception {
		return selectOne("AttachSQL.fileList", attachVO);
	}
    
    /**
     * 첨부파일 조회
     * 
     * @param attachVO
     * @return
     * @throws Exception
     */
	public AttachVO fileView(AttachVO attachVO) throws Exception {
		return selectOne("AttachSQL.fileView", attachVO);
    }
    
    /**
     * 첨부파일 삭제
     * 
     * @param attachVO
     * @throws Exception
     */
	public void deleteFile(AttachVO attachVO) throws Exception {
		delete("AttachSQL.deleteFile", attachVO);
    }
}