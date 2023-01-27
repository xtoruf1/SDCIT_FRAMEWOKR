package egovframework.api.ktnet.vo;

public class DocListVO {
	private String docType;
	private String orgCd;
	private String issueStartDt;
	private String issueEndDt;
	private String busiRegNo;

	public String getDocType() {
		return docType;
	}

	public void setDocType(String docType) {
		this.docType = docType;
	}

	public String getOrgCd() {
		return orgCd;
	}

	public void setOrgCd(String orgCd) {
		this.orgCd = orgCd;
	}

	public String getIssueStartDt() {
		return issueStartDt;
	}

	public void setIssueStartDt(String issueStartDt) {
		this.issueStartDt = issueStartDt;
	}

	public String getIssueEndDt() {
		return issueEndDt;
	}

	public void setIssueEndDt(String issueEndDt) {
		this.issueEndDt = issueEndDt;
	}

	public String getBusiRegNo() {
		return busiRegNo;
	}

	public void setBusiRegNo(String busiRegNo) {
		this.busiRegNo = busiRegNo;
	}
}