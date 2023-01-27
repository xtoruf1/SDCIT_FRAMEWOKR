package egovframework.auth.vo;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.builder.ToStringBuilder;

import egovframework.common.vo.CommonVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class AuthVO extends CommonVO {
	/**
	 * serialVersion UID
	 */
	private static final long serialVersionUID = 1L;

	// 시스템 메뉴아이디
	private int systemMenuId;

	// 권한아이디
	private int authId;

	// 메뉴설정아이디
	private int menuSetId;

	// 권한명
	private String authName;

	// 메뉴 접근 권한
	private String accessAuthYn;

	// 데이터 수정 권한
	private String modifyAuthYn;

	// 사용자아이디
	private String userId;

	// 사용자명
	private String userNm;

	// 개인정보 조회여부
	private String infoCheckYn;

	// 제외할 권한아이디(권한 선택 팝업)
	private String exceptIds;

	// 기타코드
	private String etcCode;

	// 비고
	private String dscr;

	// 검색 조건(시스템)
	private String searchSystemMenuId;

	// 검색 조건(권한명)
	private String searchAuthName;

	// 검색 조건(아이디/성명)
	private String searchNameId;

	// 검색 조건(아이디)
	private String searchUserId;

	// 검색 조건(성명)
	private String searchUserName;

	private String deptCd;
	private String fundDeptCd;
	private String awardDeptCd;
	private String telNo;
	private String faxNo;

	private List<Map<String, Object>> authList = new ArrayList<Map<String, Object>>();
	private List<Map<String, Object>> deleteAuthList = new ArrayList<Map<String, Object>>();
	private List<String> exceptIdList = new ArrayList<String>();

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}