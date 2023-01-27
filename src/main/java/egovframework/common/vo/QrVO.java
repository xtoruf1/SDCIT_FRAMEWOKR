package egovframework.common.vo;

@SuppressWarnings("serial")
public class QrVO extends SearchVO {

	private String qrUpldFileNm;		//업로드 파일명
	private String qrFileRuteCntn;		//파일 경로
	private String qrSrcCntn;			//소스 내용

	public String getQrUpldFileNm() {
		return qrUpldFileNm;
	}
	public void setQrUpldFileNm(String qrUpldFileNm) {
		this.qrUpldFileNm = qrUpldFileNm;
	}
	public String getQrFileRuteCntn() {
		return qrFileRuteCntn;
	}
	public void setQrFileRuteCntn(String qrFileRuteCntn) {
		this.qrFileRuteCntn = qrFileRuteCntn;
	}
	public String getQrSrcCntn() {
		return qrSrcCntn;
	}
	public void setQrSrcCntn(String qrSrcCntn) {
		this.qrSrcCntn = qrSrcCntn;
	}


}
