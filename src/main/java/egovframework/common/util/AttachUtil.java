package egovframework.common.util;

import java.util.List;
import java.util.Random;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.attach.dao.AttachDAO;
import egovframework.attach.vo.AttachVO;

/**
 * @author 이승준
 *
 * 첨부파일 유틸
 */
public class AttachUtil {
	private static final Logger LOGGER = LoggerFactory.getLogger(AttachUtil.class);

	static String charArray = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	static Random random = new Random(System.currentTimeMillis());

	private volatile static AttachDAO uniqueInstance;
	private static AttachDAO attachDAO;

	/**
	 * 첨부파일 유틸 생성자
	 *
	 * @param attachDAO
	 */
	public AttachUtil() {
	}

	/**
	 * 첨부파일 유틸 생성자
	 *
	 * @param paramDAO
	 */
	public AttachUtil(AttachDAO paramDAO) {
		attachDAO = paramDAO;
		getInstance();
	}

	/**
	 * 첨부파일 유틸 인스턴스(싱글턴)
	 *
	 * @return
	 */
	public static AttachDAO getInstance() {
		if (uniqueInstance == null) {
			synchronized(AttachDAO.class) {
				if (uniqueInstance == null) {
					uniqueInstance = attachDAO;
				}
			}
		}

		return uniqueInstance;
	}

	/**
	 * 새로운 ATTACH_IDX 생성
	 *
	 * @return
	 */
	public static String newAttachIdx() {
		return System.currentTimeMillis() + "_" + getRandomKey(10);
	}

	/**
	 * 랜덤키 생성
	 *
	 * @param len
	 * @return
	 */
	public static String getRandomKey(int len) {
		String ret = "";

		for (int i = 0; i < len; i++) {
			ret += charArray.charAt(random.nextInt(charArray.length()));
		}

		return ret;
	}

	/**
	 * 첨부파일 업로드(디비 입력)
	 *
	 * @param attachVO
	 * @param uploadPath
	 * @return
	 * @throws Exception
	 */
	public String upload(AttachVO attachVO, String uploadPath) throws Exception {
		String attachSeq = "";

		if (attachVO.getFile().getSize() != 0) {
			if (StringUtil.isEmpty (attachVO.getAttachSeq())) {
				attachSeq = uniqueInstance.getNewAttachSeq(attachVO);
			} else {
				attachSeq = attachVO.getAttachSeq();
			}

			try {
				MultipartFile file = attachVO.getFile();

				String realNm = FileUtil.upload(file, uploadPath);

				attachVO.setAttachSeq(attachSeq);
				attachVO.setFileNm(file.getOriginalFilename());
				attachVO.setSavePath(uploadPath);
				attachVO.setSaveFileNm(realNm);
				attachVO.setFileSize((int)file.getSize());

				uniqueInstance.insertFile(attachVO);
			} catch (Exception e) {
				LOGGER.debug(e.getMessage());
			}
		}

		return attachSeq;
	}

	/**
	 * 첨부파일 목록 조회
	 *
	 * @param attachVO
	 * @return
	 * @throws Exception
	 */
	public List<AttachVO> list(AttachVO attachVO) throws Exception {
		return uniqueInstance.fileList(attachVO);
	}

	/**
	 * 첨부파일 상세 조회
	 *
	 * @param attachVO
	 * @return
	 * @throws Exception
	 */
	public AttachVO info(AttachVO attachVO) throws Exception {
		return uniqueInstance.fileInfo(attachVO);
	}

	/**
	 * 첨부파일 다운로드(정보 조회)
	 *
	 * @param attachVO
	 * @return
	 * @throws Exception
	 */
	public AttachVO download(AttachVO attachVO) throws Exception {
		return uniqueInstance.fileView(attachVO);
	}

	/**
	 * 첨부파일 삭제(디비 삭제)
	 *
	 * @param attachVO
	 * @throws Exception
	 */
	public void delete(AttachVO attachVO) throws Exception {
		attachVO = uniqueInstance.fileView(attachVO);

		if (attachVO != null) {
			uniqueInstance.deleteFile(attachVO);
		}
	}

	public AttachVO upload(MultipartFile file, String uploadPath) throws Exception {
		AttachVO attachVO = new AttachVO();

		if (file.getSize() != 0) {
			try {
				String realNm = FileUtil.upload(file, uploadPath);

				attachVO.setFileNm(file.getOriginalFilename());
				attachVO.setSavePath(uploadPath + realNm);
			} catch (Exception e) {
				LOGGER.debug(e.getMessage());
			}
		}

		return attachVO;
	}

	public String uploadFileList(MultipartHttpServletRequest request, String attachSeq, String groupId, String name) throws Exception {
		List<MultipartFile> attachFileList = request.getFiles(name);

		AttachVO attachVO = new AttachVO();
		if (!attachFileList.isEmpty()) {
    		for (int i = 0; i < attachFileList.size(); i++) {
    			MultipartFile attachFile = (MultipartFile)attachFileList.get(i);

    			if (attachFile.getSize() != 0) {
    				attachVO.setFile(attachFile);
    				attachVO.setGroupId(groupId);
    				if (!StringUtil.isEmpty(attachSeq)) {
    					attachVO.setAttachSeq(attachSeq);
    				}
    				attachVO.setFileSeq(uniqueInstance.getNewFileSeq(attachVO));

					// attachUtil.delete(attachVO);

					// 첨부파일 경로
		    		String uploadPath = PropertyUtil.getProperty("variables.uploadPath");

		    		// 첨부파일 업로드
		    		attachVO.setAttachSeq(this.upload(attachVO, uploadPath));
				}
			}
		}

		return attachVO.getAttachSeq();
	}
}