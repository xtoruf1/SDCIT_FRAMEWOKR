package egovframework.organization.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.common.Constants;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import egovframework.organization.dao.OrganizationDAO;
import egovframework.organization.vo.OrganizationVO;

@Service
public class OrganizationService {
	private static final Logger LOGGER = LoggerFactory.getLogger(OrganizationService.class);

	/** OrganizationDAO */
	@Autowired
	private OrganizationDAO organizationDAO;
	
	public List<CommonHashMap<String, Object>> selectOrganizationList(SearchVO searchVO) throws Exception {
		return organizationDAO.selectOrganizationList(searchVO);
	}
	
	@Transactional
    public void saveOrganization(OrganizationVO organizationVO) throws Exception {
		if (organizationVO.getOrganizationList().size() > 0) {
			for (Map<String, Object> map : organizationVO.getOrganizationList()) {
				String status = (String)map.get("status");
				
				// 등록
				if (Constants.IBSHEET_STATUS_INSERT.equals(status)) {
					organizationVO.getInsertOrganizationList().add(map);
				// 수정
				} else if (Constants.IBSHEET_STATUS_UPDATE.equals(status)) {
					OrganizationVO oVO = new OrganizationVO();
					
					String organizationId = (String)map.get("organizationId");
					String organizationNm = (String)map.get("organizationNm");
					String etc = (String)map.get("etc");
					
					oVO.setOrganizationId(organizationId);
					oVO.setOrganizationNm(organizationNm);
					oVO.setEtc(etc);
					
					organizationDAO.updateOrganization(oVO);
				// 삭제
				} else if (Constants.IBSHEET_STATUS_DELETE.equals(status)) {
					organizationVO.getDeleteOrganizationList().add(map);
				}
			}
		}
		
		if (organizationVO.getInsertOrganizationList().size() > 0) {
			organizationDAO.insertOrganizationList(organizationVO);
		}
		
		if (organizationVO.getDeleteOrganizationList().size() > 0) {
			organizationDAO.deleteOrganizationList(organizationVO);
		}
    }
}