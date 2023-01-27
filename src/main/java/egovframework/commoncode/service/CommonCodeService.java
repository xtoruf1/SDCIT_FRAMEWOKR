package egovframework.commoncode.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.common.Constants;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import egovframework.commoncode.dao.CommonCodeDAO;
import egovframework.commoncode.dao.CounselDAO;
import egovframework.commoncode.dao.PortalDAO;
import egovframework.commoncode.dao.ServiceDAO;
import egovframework.commoncode.dao.SupportDAO;
import egovframework.commoncode.vo.CommonCodeVO;

@Service
public class CommonCodeService {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonCodeService.class);

	/** CommonCodeDAO */
	@Autowired
	private CommonCodeDAO commonCodeDAO;

	/** PortalDAO */
	@Autowired
	private PortalDAO portalDAO;

	/** ServiceDAO */
	@Autowired
	private ServiceDAO serviceDAO;

	/** SupportDAO */
	@Autowired
	private SupportDAO supportDAO;

	/** CounselDAO */
	@Autowired
	private CounselDAO counselDAO;

	// default = readOnly
	public List<CommonHashMap<String, Object>> selectCommonCodeList(SearchVO searchVO) throws Exception {
		return commonCodeDAO.selectCommonCodeList(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectGroupList(SearchVO searchVO) throws Exception {
		return commonCodeDAO.selectGroupList(searchVO);
	}

	@Transactional
	public void mergeGroupCode(CommonCodeVO commonCodeVO) throws Exception {
		if (commonCodeVO.getCodeList().size() > 0) {
			for (Map<String, Object> map : commonCodeVO.getCodeList()) {
				String status = (String)map.get("status");

				// 등록
				if (Constants.IBSHEET_STATUS_INSERT.equals(status)) {
					commonCodeVO.getInsertCodeList().add(map);
				// 수정
				} else if (Constants.IBSHEET_STATUS_UPDATE.equals(status)) {
					CommonCodeVO ccVO = new CommonCodeVO();

					String code = (String)map.get("code");
					String codeNm = (String)map.get("codeNm");
					String codeDesc = (String)map.get("codeDesc");
					String codeSort = (String)map.get("codeSort");
					String attr1 = (String)map.get("attr1");
					String attr2 = (String)map.get("attr2");
					String attr3 = (String)map.get("attr3");
					String attr4 = (String)map.get("attr4");
					String attr5 = (String)map.get("attr5");
					String useYn = (String)map.get("useYn");

					ccVO.setCodeId(commonCodeVO.getCodeId());
					ccVO.setCode(code);
					ccVO.setCodeNm(codeNm);
					ccVO.setCodeDesc(codeDesc);
					ccVO.setCodeSort(codeSort);
					ccVO.setAttr1(attr1);
					ccVO.setAttr2(attr2);
					ccVO.setAttr3(attr3);
					ccVO.setAttr4(attr4);
					ccVO.setAttr5(attr5);
					ccVO.setUseYn(useYn);

					commonCodeDAO.updateCode(ccVO);
				// 삭제
				} else if (Constants.IBSHEET_STATUS_DELETE.equals(status)) {
					commonCodeVO.getDeleteCodeList().add(map);
				}
			}

			if (commonCodeVO.getInsertCodeList().size() > 0) {
				commonCodeDAO.insertCodeList(commonCodeVO);
			}

			if (commonCodeVO.getDeleteCodeList().size() > 0) {
				commonCodeDAO.deleteCodeList(commonCodeVO);
			}
		}

		commonCodeDAO.mergeGroupCode(commonCodeVO);
    }

	@Transactional
	public void deleteGroupCode(CommonCodeVO commonCodeVO) throws Exception {
		// 코드 삭제
		commonCodeDAO.deleteCodeList(commonCodeVO);
		// 그룹코드 삭제
		commonCodeDAO.deleteGroupCode(commonCodeVO);
    }

	@CacheEvict(value = "COMMON_CODE_CACHE", allEntries = true)
	public void initCommonCodeList() throws Exception {
		LOGGER.debug("Common Code Cache Init!!!");
	}

	public List<CommonHashMap<String, Object>> selectCodeDetailList(SearchVO searchVO) throws Exception {
		return commonCodeDAO.selectCodeDetailList(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectClassCodeList(SearchVO searchVO) throws Exception {
		return commonCodeDAO.selectClassCodeList(searchVO);
	}

	public int selectClassCodeTotalCnt(SearchVO searchVO) throws Exception {
		return commonCodeDAO.selectClassCodeTotalCnt(searchVO);
	}

	public CommonHashMap<String, Object> selectClassCodeView(SearchVO searchVO) throws Exception {
		return commonCodeDAO.selectClassCodeView(searchVO);
	}

	@Transactional
    public void insertClassCode(CommonCodeVO commonCodeVO) throws Exception {
		commonCodeDAO.insertClassCode(commonCodeVO);
    }

	@Transactional
    public void updateClassCode(CommonCodeVO commonCodeVO) throws Exception {
		commonCodeDAO.updateClassCode(commonCodeVO);
    }

	@Transactional
    public void deleteClassCode(CommonCodeVO commonCodeVO) throws Exception {
		commonCodeDAO.deleteClassCode(commonCodeVO);
    }

	public List<CommonHashMap<String, Object>> selectSearchClassList() throws Exception {
		return commonCodeDAO.selectSearchClassList();
	}

	public List<CommonHashMap<String, Object>> selectPortalCodeListOrderByNumber(SearchVO searchVO) throws Exception {
		return portalDAO.selectPortalCodeListOrderByNumber(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectPortalCodeList(SearchVO searchVO) throws Exception {
		return portalDAO.selectPortalCodeList(searchVO);
	}

	public int selectPortalCodeTotalCnt(SearchVO searchVO) throws Exception {
		return portalDAO.selectPortalCodeTotalCnt(searchVO);
	}

	public CommonHashMap<String, Object> selectPortalCodeView(SearchVO searchVO) throws Exception {
		return portalDAO.selectPortalCodeView(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectPortalCodeDetailAllList(SearchVO searchVO) throws Exception {
		return portalDAO.selectPortalCodeDetailAllList(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectPortalCodeDetailList(SearchVO searchVO) throws Exception {
		return portalDAO.selectPortalCodeDetailList(searchVO);
	}

	@Transactional
    public void mergePortalCode(CommonCodeVO commonCodeVO) throws Exception {
		// 공통코드 등록 / 수정
		portalDAO.mergePortalCode(commonCodeVO);

		if (commonCodeVO.getCodeList().size() > 0) {
			for (Map<String, Object> map : commonCodeVO.getCodeList()) {
				CommonCodeVO ccVO = new CommonCodeVO();

				String codeId = commonCodeVO.getCodeId();
				String code = (String)map.get("code");
				String codeNm = (String)map.get("codeNm");
				String codeDc = (String)map.get("codeDc");
				String useAt = (String)map.get("useAt");

				ccVO.setCodeId(codeId);
				ccVO.setCode(code);
				ccVO.setCodeNm(codeNm);
				ccVO.setCodeDc(codeDc);
				ccVO.setUseAt(useAt);

				portalDAO.mergePortalCodeDetail(ccVO);
			}
		}
    }

	public List<CommonHashMap<String, Object>> selectServiceCodeList(SearchVO searchVO) throws Exception {
		return serviceDAO.selectServiceCodeList(searchVO);
	}

	public int selectServiceCodeTotalCnt(SearchVO searchVO) throws Exception {
		return serviceDAO.selectServiceCodeTotalCnt(searchVO);
	}

	public CommonHashMap<String, Object> selectServiceCodeView(SearchVO searchVO) throws Exception {
		return serviceDAO.selectServiceCodeView(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectServiceCodeDetailList(SearchVO searchVO) throws Exception {
		return serviceDAO.selectServiceCodeDetailList(searchVO);
	}

	@Transactional
    public void mergeServiceCode(CommonCodeVO commonCodeVO) throws Exception {
		// 공통코드 등록 / 수정
		serviceDAO.mergeServiceCode(commonCodeVO);

		if (commonCodeVO.getCodeList().size() > 0) {
			for (Map<String, Object> map : commonCodeVO.getCodeList()) {
				String status = (String)map.get("status");

				CommonCodeVO ccVO = new CommonCodeVO();

				String basecd = commonCodeVO.getBasecd();
				String detailcd = (String)map.get("detailcd");

				// 등록 / 수정
				if (
					Constants.IBSHEET_STATUS_INSERT.equals(status)
					|| Constants.IBSHEET_STATUS_UPDATE.equals(status)
				) {
					String detailnm = (String)map.get("detailnm");
					String detailsortnm = (String)map.get("detailsortnm");
					String lvl = (String)map.get("lvl");
					String chgCode01 = (String)map.get("chgCode01");
					String chgCode02 = (String)map.get("chgCode02");
					String chgCode03 = (String)map.get("chgCode03");
					String chgCode04 = (String)map.get("chgCode04");
					String chgCode05 = (String)map.get("chgCode05");
					String chgCode06 = (String)map.get("chgCode06");
					String chgCode07 = (String)map.get("chgCode07");
					String chgCode08 = (String)map.get("chgCode08");
					String chgCode09 = (String)map.get("chgCode09");
					String chgCode10 = (String)map.get("chgCode10");
					String chgCode11 = (String)map.get("chgCode11");
					String chgCode12 = (String)map.get("chgCode12");
					String chgCode13 = (String)map.get("chgCode13");
					String chgCode14 = (String)map.get("chgCode14");
					String chgCode15 = (String)map.get("chgCode15");
					String chgCode16 = (String)map.get("chgCode16");
					String chgCode17 = (String)map.get("chgCode17");
					String chgCode18 = (String)map.get("chgCode18");
					String chgCode19 = (String)map.get("chgCode19");
					String chgCode20 = (String)map.get("chgCode20");
					String remark = (String)map.get("remark");
					String sortNo = (String)map.get("sortNo");

					ccVO.setBasecd(basecd);
					ccVO.setDetailcd(detailcd);
					ccVO.setDetailnm(detailnm);
					ccVO.setDetailsortnm(detailsortnm);
					ccVO.setLvl(lvl);
					ccVO.setChgCode01(chgCode01);
					ccVO.setChgCode02(chgCode02);
					ccVO.setChgCode03(chgCode03);
					ccVO.setChgCode04(chgCode04);
					ccVO.setChgCode05(chgCode05);
					ccVO.setChgCode06(chgCode06);
					ccVO.setChgCode07(chgCode07);
					ccVO.setChgCode08(chgCode08);
					ccVO.setChgCode09(chgCode09);
					ccVO.setChgCode10(chgCode10);
					ccVO.setChgCode11(chgCode11);
					ccVO.setChgCode12(chgCode12);
					ccVO.setChgCode13(chgCode13);
					ccVO.setChgCode14(chgCode14);
					ccVO.setChgCode15(chgCode15);
					ccVO.setChgCode16(chgCode16);
					ccVO.setChgCode17(chgCode17);
					ccVO.setChgCode18(chgCode18);
					ccVO.setChgCode19(chgCode19);
					ccVO.setChgCode20(chgCode20);
					ccVO.setRemark(remark);
					ccVO.setSortNo(sortNo);

					serviceDAO.mergeServiceCodeDetail(ccVO);
				// 삭제
				} else if (Constants.IBSHEET_STATUS_DELETE.equals(status)) {
					ccVO.setBasecd(basecd);
					ccVO.setDetailcd(detailcd);

					serviceDAO.deleteServiceCodeDetail(ccVO);
				}
			}
		}
    }

	@Transactional
    public void deleteServiceCode(CommonCodeVO commonCodeVO) throws Exception {
		if (commonCodeVO.getDeleteCodeList().size() > 0) {
			for (Map<String, Object> map : commonCodeVO.getDeleteCodeList()) {
				CommonCodeVO ccVO = new CommonCodeVO();

				String basecd = (String)map.get("basecd");
				ccVO.setBasecd(basecd);

				serviceDAO.deleteServiceCode(ccVO);
			}
		}
	}

	public List<CommonHashMap<String, Object>> selectSupportCodeList(SearchVO searchVO) throws Exception {
		return supportDAO.selectSupportCodeList(searchVO);
	}

	public int selectSupportCodeTotalCnt(SearchVO searchVO) throws Exception {
		return supportDAO.selectSupportCodeTotalCnt(searchVO);
	}

	public CommonHashMap<String, Object> selectSupportCodeView(SearchVO searchVO) throws Exception {
		return supportDAO.selectSupportCodeView(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectSupportCodeDetailList(SearchVO searchVO) throws Exception {
		return supportDAO.selectSupportCodeDetailList(searchVO);
	}

	@Transactional
    public void mergeSupportCode(CommonCodeVO commonCodeVO) throws Exception {
		// 공통코드 등록 / 수정
		supportDAO.mergeSupportCode(commonCodeVO);

		if (commonCodeVO.getCodeList().size() > 0) {
			for (Map<String, Object> map : commonCodeVO.getCodeList()) {
				String status = (String)map.get("status");

				CommonCodeVO ccVO = new CommonCodeVO();

				String cls = commonCodeVO.getCls();
				String code = (String)map.get("code");

				// 등록 / 수정
				if (
					Constants.IBSHEET_STATUS_INSERT.equals(status)
					|| Constants.IBSHEET_STATUS_UPDATE.equals(status)
				) {
					String name = (String)map.get("name");
					String eng = (String)map.get("eng");
					String abbr = (String)map.get("abbr");
					String codeStatus = (String)map.get("codeStatus");
					String ord = (String)map.get("ord");
					String note = (String)map.get("note");
					String grp = (String)map.get("grp");

					ccVO.setCls(cls);
					ccVO.setCode(code);
					ccVO.setName(name);
					ccVO.setEng(eng);
					ccVO.setAbbr(abbr);
					ccVO.setStatus(codeStatus);
					ccVO.setOrd(ord);
					ccVO.setNote(note);
					ccVO.setGrp(grp);

					supportDAO.mergeSupportCodeDetail(ccVO);
				// 삭제
				} else if (Constants.IBSHEET_STATUS_DELETE.equals(status)) {
					ccVO.setCls(cls);
					ccVO.setCode(code);

					supportDAO.deleteSupportCodeDetail(ccVO);
				}
			}
		}
    }

	@Transactional
    public void deleteSupportCode(CommonCodeVO commonCodeVO) throws Exception {
		if (commonCodeVO.getDeleteCodeList().size() > 0) {
			for (Map<String, Object> map : commonCodeVO.getDeleteCodeList()) {
				CommonCodeVO ccVO = new CommonCodeVO();

				String cls = (String)map.get("cls");
				ccVO.setCls(cls);

				supportDAO.deleteSupportCode(ccVO);
			}
		}
	}

	public List<CommonHashMap<String, Object>> selectCounselCodeList(SearchVO searchVO) throws Exception {
		return counselDAO.selectCounselCodeList(searchVO);
	}

	public int selectCounselCodeTotalCnt(SearchVO searchVO) throws Exception {
		return counselDAO.selectCounselCodeTotalCnt(searchVO);
	}

	public CommonHashMap<String, Object> selectCounselCodeView(SearchVO searchVO) throws Exception {
		return counselDAO.selectCounselCodeView(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectCounselCodeDetailList(SearchVO searchVO) throws Exception {
		return counselDAO.selectCounselCodeDetailList(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectCounselDetailUseList(SearchVO searchVO) throws Exception {
		return counselDAO.selectCounselDetailUseList(searchVO);
	}

	public int selectCounselDeleteValidation(SearchVO searchVO) throws Exception {
		return counselDAO.selectCounselDeleteValidation(searchVO);
	}

	@Transactional
    public void mergeCounselCode(CommonCodeVO commonCodeVO) throws Exception {
		// 공통코드 등록 / 수정
		counselDAO.mergeCounselCode(commonCodeVO);

		if (commonCodeVO.getCodeList().size() > 0) {
			for (Map<String, Object> map : commonCodeVO.getCodeList()) {
				String status = (String)map.get("status");

				CommonCodeVO ccVO = new CommonCodeVO();

				String cdGrpId = commonCodeVO.getCdGrpId();
				String cdId = (String)map.get("cdId");

				// 등록 / 수정
				if (
					Constants.IBSHEET_STATUS_INSERT.equals(status)
					|| Constants.IBSHEET_STATUS_UPDATE.equals(status)
				) {
					String cdNm = (String)map.get("cdNm");
					String explain = (String)map.get("explain");
					String etc1 = (String)map.get("etc1");
					String etc2 = (String)map.get("etc2");
					String etc3 = (String)map.get("etc3");
					String ord = (String)map.get("ord");
					String useYn = (String)map.get("useYn");

					ccVO.setCdGrpId(cdGrpId);
					ccVO.setCdId(cdId);
					ccVO.setCdNm(cdNm);
					ccVO.setExplain(explain);
					ccVO.setEtc1(etc1);
					ccVO.setEtc2(etc2);
					ccVO.setEtc3(etc3);
					ccVO.setOrd(ord);
					ccVO.setUseYn(useYn);

					counselDAO.mergeCounselCodeDetail(ccVO);
				// 삭제
				} else if (Constants.IBSHEET_STATUS_DELETE.equals(status)) {
					ccVO.setCdGrpId(cdGrpId);
					ccVO.setCdId(cdId);

					counselDAO.deleteCounselCodeDetail(ccVO);
				}
			}
		}
    }

	@Transactional
    public void deleteCounselCode(CommonCodeVO commonCodeVO) throws Exception {
		if (commonCodeVO.getDeleteCodeList().size() > 0) {
			for (Map<String, Object> map : commonCodeVO.getDeleteCodeList()) {
				CommonCodeVO ccVO = new CommonCodeVO();

				String cdGrpId = (String)map.get("cdGrpId");
				ccVO.setCdGrpId(cdGrpId);

				counselDAO.deleteCounselCode(ccVO);
			}
		}
	}
}