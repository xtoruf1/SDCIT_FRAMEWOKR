package egovframework.commoncode.vo;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.builder.ToStringBuilder;

import egovframework.common.vo.CommonVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class CommonCodeVO extends CommonVO {
	/**
	 * serialVersion UID
	 */
	private static final long serialVersionUID = 1L;

	private String codeId;
	private String groupId;
	private String code;
	private String codeNm;
	private String codeDesc;
	private String codeSort;
	private String attr1;
	private String attr2;
	private String attr3;
	private String attr4;
	private String attr5;
	private String useYn;
	private String orderField;
	private String orderDirection;

	// 코드목록 입력(데이터 가공)
	private List<Map<String, Object>> codeList = new ArrayList<Map<String, Object>>();
	private List<Map<String, Object>> insertCodeList = new ArrayList<Map<String, Object>>();
	private List<Map<String, Object>> deleteCodeList = new ArrayList<Map<String, Object>>();

	private String clCode;
	private String clCodeNm;
	private String clCodeDc;

	private String codeDc;

	private String codeIdNm;
	private String codeIdDc;
	private String useAt;

	private String basecd;
	private String basenm;
	private String remark;

	private String detailcd;
	private String detailnm;
	private String detailsortnm;
	private String lvl;
	private String chgCode01;
	private String chgCode02;
	private String chgCode03;
	private String chgCode04;
	private String chgCode05;
	private String chgCode06;
	private String chgCode07;
	private String chgCode08;
	private String chgCode09;
	private String chgCode10;
	private String chgCode11;
	private String chgCode12;
	private String chgCode13;
	private String chgCode14;
	private String chgCode15;
	private String chgCode16;
	private String chgCode17;
	private String chgCode18;
	private String chgCode19;
	private String chgCode20;
	private String sortNo;

	private String cls;
	private String name;
	private String eng;
	private String abbr;
	private String status;
	private String ord;
	private String note;
	private String grp;

	private String cdGrpId;
	private String cdGrpNm;
	private String explain;

	private String cdId;
	private String cdNm;
	private String etc1;
	private String etc2;
	private String etc3;

	private String searchClCode;

	private String acctTypeId;

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}