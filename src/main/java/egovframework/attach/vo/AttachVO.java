package egovframework.attach.vo;

import java.io.Serializable;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.ibatis.type.Alias;
import org.springframework.web.multipart.MultipartFile;

import egovframework.common.vo.CommonVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@Alias("attachVO")
@EqualsAndHashCode(callSuper = false)
public class AttachVO extends CommonVO implements Serializable {
	/**
	 * serialVersion UID
	 */
	private static final long serialVersionUID = 1L;

	/* 업무 아이디 */
	private String groupId;

	/* 첨부파일 시퀀스 */
	private String attachSeq;

	/* 파일 시퀀스 */
	private int fileSeq;

	/* 파일명 */
	private String fileNm;

	/* 파일경로 */
	private String savePath;

	/* 파일 저장명 */
	private String saveFileNm;

	/* 파일 크기 */
	private int fileSize;

	/* 파일타입 */
	private String fileTypeCd;

	/* QR_소스_내용 */
	private String qrSrcCntn;

	/* 등록일 */
	private String regDate;

	/* 파일 ID */
	private String fileId;
	/* 파일 확장자 */
	private String fileExt;
	private String mimeType;
	private String contentType;

	private MultipartFile file;

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}