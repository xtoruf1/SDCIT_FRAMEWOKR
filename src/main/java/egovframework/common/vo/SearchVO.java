package egovframework.common.vo;

import java.io.Serializable;

import org.apache.commons.lang3.builder.ToStringBuilder;

import egovframework.common.pagenation.PaginationInfo;
import lombok.Data;

@Data
public class SearchVO implements Serializable {
	/**
	 * serialVersion UID
	 */
	private static final long serialVersionUID = 1L;

	private PaginationInfo paginationInfo = new PaginationInfo();

	/* 검색조건 */
	private String searchCondition = "";
	private String searchCondition2 = "";

	private String searchCondition3 = "";

	private String searchCondition4 = "";

	/* 검색어 */
	private String searchKeyword = "";
	private String searchKeyword2 = "";

	/* 검색조건 */
	private String searchCnd = "";

	/* 현재페이지 */
	private int pageIndex = 1;

	/* 페이지갯수 */
	private int pageUnit = 10;

	/* 페이지사이즈 */
	private int pageSize = 10;

	/* firstIndex */
	private int firstIndex = 1;

	/* lastIndex */
	private int lastIndex = 1;

	/* recordCountPerPage */
	private int recordCountPerPage = 10;

	/** 리스트의 첫 일련번호 (전체 데이타수의 내림차수) */
    private int startIndex;

    /* 게시물 전체 카운트 */
    private int totalCnt = 0;

	/** 구분 유형 */
    private String typeFlag = "";

    public void setPagingInfo() {
		this.getPaginationInfo().setCurrentPageNo(this.getPageIndex());
		this.getPaginationInfo().setRecordCountPerPage(this.getPageUnit());
		this.getPaginationInfo().setPageSize(this.getPageSize());

		this.setFirstIndex(this.getPaginationInfo().getFirstRecordIndex());
		this.setLastIndex(this.getPaginationInfo().getLastRecordIndex());
		this.setRecordCountPerPage(this.getPaginationInfo().getRecordCountPerPage());
    }

    public void setPagingCount(int totCnt) {
    	this.getPaginationInfo().setTotalRecordCount(totCnt);
    	this.setStartIndex(totCnt - ((this.getPageIndex() - 1) * this.getPageUnit()));
    }

    public int getStartLimit() {
    	return (this.getPageIndex() - 1) * this.getPageUnit();
    }

    @Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}