package egovframework.organization.vo;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.builder.ToStringBuilder;

import egovframework.common.vo.CommonVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class OrganizationVO extends CommonVO {
	/**
	 * serialVersion UID
	 */
	private static final long serialVersionUID = 1L;
	
	private String organizationId;
	private String organizationNm;
	private String etc;
	
	private List<Map<String, Object>> organizationList = new ArrayList<Map<String, Object>>();
	private List<Map<String, Object>> insertOrganizationList = new ArrayList<Map<String, Object>>();
	private List<Map<String, Object>> deleteOrganizationList = new ArrayList<Map<String, Object>>();
	
	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}