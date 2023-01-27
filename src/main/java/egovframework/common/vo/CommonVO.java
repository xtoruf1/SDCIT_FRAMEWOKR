package egovframework.common.vo;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@SuppressWarnings("serial")
@EqualsAndHashCode(callSuper = false)
public class CommonVO extends SearchVO {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonVO.class);
	
	/* 등록자 아이디 */
	private String regId;
	
	/* 등록자 이름 */
	private String regNm;
	
	/* 수정자 아이디 */
	private String updId;
	
	/* 수정자 이름 */
	private String updNm;
	
	/* 서버 프로파일 */
	private String activeProfile;

	/* 개인정보 조회권한 */
	private String infoCheckYn;
	
	/* 공통코드 조회용 */
	private String codeId;
	
    @Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}