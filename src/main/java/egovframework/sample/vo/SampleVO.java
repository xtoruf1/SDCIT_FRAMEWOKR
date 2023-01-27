package egovframework.sample.vo;

import org.apache.commons.lang3.builder.ToStringBuilder;

import egovframework.common.vo.CommonVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class SampleVO extends CommonVO {
	/**
	 * serialVersion UID
	 */
	private static final long serialVersionUID = 1L;

	/* 게시판 시퀀스 */
	private int boardSeq;
	
	/* 게시물 시퀀스 */
	private int articleSeq;
	
	/* 제목 */
	private String title;
	
	/* 내용 */
	private String contents;

	/* 신규 첨부파일 키 */
	private String attachSeq;
	private int fileSeq = 1;
	
	private int basicPageIndex = 1;
	private int boardPageIndex = 1;
	
	private int basicPageUnit = 10;
	private int boardPageUnit = 10;
	
	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}