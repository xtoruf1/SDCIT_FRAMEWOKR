package egovframework.program.vo;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.builder.ToStringBuilder;

import egovframework.common.vo.CommonVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class ProgramVO extends CommonVO {
	/**
	 * serialVersion UID
	 */
	private static final long serialVersionUID = 1L;

	/* 프로그램 시퀀스 */
	private int programSeq;

	/* 프로그램명 */
	private String programNm;

	/* 하위 프로그램 시퀀스 */
	private int subProgramSeq;

	/* URL */
	private String url;

	/* SSL적용여부 */
	private String sslYn;

	/* 새창여부 */
	private String target;

	/* 모바일 메뉴표시여부 */
	private String mobileYn;

	/* 비고 */
	private String etc;

	// 검색조건(프로그램명)
	private String searchPgmName = "";

	// 검색조건(하위포함)
	private String searchDetailYn = "";

	// 검색조건(URL)
	private String searchUrl = "";

	// 검색조건(비고)
	private String searchDscr = "";

	/* 프로그램 아이디 */
	private int pgmId;

	/* 순번 */
	private int seq;

	/* 프로그램명 */
	private String pgmName;

	/* 새창 */
	private String linkTarget;

	/* 아이콘 이미지(기업 - 회원사) */
	private String iconImg1;

	/* 아이콘 이미지(기업 - 비회원사) */
	private String iconImg2;

	/* 아이콘 이미지(개인 - 회원사) */
	private String iconImg3;

	/* 아이콘 회비 */
	private String iconFee;

	/* 비고 */
	private String dscr;

	/* 프로그램 설명 */
	private String description;

	// 검색조건(팝업)
	private String searchPopupCondition;

	// 검색조건(검색어)
	private String searchPopupKeyword;

	// 링크 공유 이미지
	private String imgPath;

	// 하위 프로그램 목록 입력(데이터 가공)
	private List<Map<String, Object>> subList = new ArrayList<Map<String, Object>>();
	private List<Map<String, Object>> deleteList = new ArrayList<Map<String, Object>>();
	private List<Map<String, Object>> deleteSubList = new ArrayList<Map<String, Object>>();

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}