package egovframework.common.login.vo;

import java.io.Serializable;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.ibatis.type.Alias;

import lombok.Data;

@Alias("loginUserVO")
@Data
public class LoginUserVO implements Serializable {
	/**
	 * serialVersion UID
	 */
	private static final long serialVersionUID = 1L;

	private int memberSeq;
	private String loginId;
	private String loginPwd;
	private String memberNm;
	private String cntrtCd;
	private String hpTel;
	private String joinDate;
	private String dormantYn;
	private String dormantDate;
	private String leaveYn;
	private String leaveDate;
	private String loginDate;
	private String regDate;
	private String updDate;

	/** 아이디 */
	private String id = "";

	/** 이름 */
	private String name = "";

	/** 주민등록번호 */
	private String ihidNum = "";

	/** 이메일주소 */
	private String userEmail = "";

	/** 비밀번호 */
	private String password = "";

	/** 비밀번호 힌트 */
	private String passwordHint = "";

	/** 비밀번호 정답 */
	private String passwordCnsr = "";

	/** 사용자구분 */
	private String userSe = "";

	/** 조직(부서) 아이디 */
	private String orgnztId = "";

	/** 조직(부서)명 */
	private String orgnztNm = "";

	/** 고유아이디 */
	private String uniqId = "";

	/** 로그인 후 이동할 페이지 */
	private String url = "";

	/** 사용자 IP정보 */
	private String ip = "";

	/** GPKI인증 DN */
	private String dn = "";
	private String authId = "";
	private String adminYn = "";
	private String authNo = "";

	private String seqNo = "";
	private String memberId = "";
	private String tradeNo = "";
	private String saupjaNo = "";
	private String feeGb = "";
	private String regGb = "";
	private String userName = "";
	private String handTel = "";
	private String emEmailAddr = "";
	private String userType = "";
	private String telNo = "";
	private String faxNo = "";


	private String userId;
	private String userNm;
	private String infoCheckYn;


	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}