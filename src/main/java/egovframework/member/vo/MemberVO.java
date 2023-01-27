package egovframework.member.vo;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.ibatis.type.Alias;

import egovframework.common.vo.CommonVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@Alias("memberVO")
@EqualsAndHashCode(callSuper = false)
public class MemberVO extends CommonVO {
	/**
	 * serialVersion UID
	 */
	private static final long serialVersionUID = 1L;
	
	private int memberSeq;
	private String loginId;
	private String pwd;
	private String memberNm;
	private String memberType;
	private String email;
	private String hpTel;
	private String deptId;
		
	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}