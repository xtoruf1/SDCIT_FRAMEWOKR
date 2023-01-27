package egovframework.program.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.common.Constants;
import egovframework.common.util.StringUtil;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import egovframework.program.dao.ProgramDAO;
import egovframework.program.vo.ProgramVO;

@Service
public class ProgramService {
	private static final Logger LOGGER = LoggerFactory.getLogger(ProgramService.class);

	/** ProgramDAO */
	@Autowired
	private ProgramDAO programDAO;
	
//	하새결임시
	public List<CommonHashMap<String, Object>> getTestData(SearchVO searchVO) throws Exception {
		return programDAO.getTestData(searchVO);
	}
	
	public List<CommonHashMap<String, Object>> selectAdminProgramList(SearchVO searchVO) throws Exception {
		return programDAO.selectAdminProgramList(searchVO);
	}
	
	public int selectAdminProgramTotalCnt(SearchVO searchVO) throws Exception {
		return programDAO.selectAdminProgramTotalCnt(searchVO);
	}
	
	public List<CommonHashMap<String, Object>> selectAdminPopupProgramList(SearchVO searchVO) throws Exception {
		return programDAO.selectAdminPopupProgramList(searchVO);
	}
	
	public CommonHashMap<String, Object> selectAdminProgramView(SearchVO searchVO) throws Exception {
		return programDAO.selectAdminProgramView(searchVO);
	}
	
	public List<CommonHashMap<String, Object>> selectAdminSubProgramList(SearchVO searchVO) throws Exception {
		return programDAO.selectAdminSubProgramList(searchVO);
	}
	
	public boolean adminProgramUrlDuplicateCheck(ProgramVO programVO) throws Exception {
		boolean result = true;
		
		// 프로그램 URL 체크
		if (programDAO.getAdminProgramDuplicateCnt(programVO) > 0) {
			result = false;
			
			return result;
		}
		
		for (Map<String, Object> map : programVO.getSubList()) {
			if (map.get("url") != null) {
				ProgramVO subVO = new ProgramVO();
				
				if (!StringUtil.isEmpty(map.get("pgmId").toString())) {
					subVO.setPgmId(Integer.parseInt(map.get("pgmId").toString()));
				}
				if (!StringUtil.isEmpty(map.get("seq").toString())) {
					subVO.setSeq(Integer.parseInt(map.get("seq").toString()));
				}
				subVO.setUrl(map.get("url").toString());
				
				// 하위 프로그램 URL 체크
				if (programDAO.getAdminProgramListDuplicateCnt(subVO) > 0) {
					result = false;
					
					return result;
				}
			}
		}
		
		return result;
	}
	
	@Transactional
    public void insertAdminProgram(ProgramVO programVO) throws Exception {
		programDAO.insertAdminProgram(programVO);
		
		if (programVO.getSubList().size() > 0) {
			for (Map<String, Object> map : programVO.getSubList()) {
				String status = (String)map.get("status");
				
				// 등록
				if (Constants.IBSHEET_STATUS_INSERT.equals(status)) {
					ProgramVO pVO = new ProgramVO();
					
					int pgmId = programVO.getPgmId();
					String pgmName = (String)map.get("pgmName");
					String url = (String)map.get("url");
					
					pVO.setPgmId(pgmId);
					pVO.setPgmName(pgmName);
					pVO.setUrl(url);
					
					programDAO.insertAdminSubProgram(pVO);
				}
			}
		}
    }
	
	@Transactional
    public void updateAdminProgram(ProgramVO programVO) throws Exception {
		programDAO.updateAdminProgram(programVO);
		
		if (programVO.getSubList().size() > 0) {
			for (Map<String, Object> map : programVO.getSubList()) {
				String status = (String)map.get("status");
				
				// 등록 / 수정
				if (Constants.IBSHEET_STATUS_INSERT.equals(status) || Constants.IBSHEET_STATUS_UPDATE.equals(status)) {
					ProgramVO pVO = new ProgramVO();
					
					int pgmId = StringUtil.isEmpty(map.get("pgmId").toString()) ? programVO.getPgmId() : Integer.parseInt(map.get("pgmId").toString());
					int seq = StringUtil.isEmpty(map.get("seq").toString()) ? programVO.getSeq() : Integer.parseInt(map.get("seq").toString());
					String pgmName = (String)map.get("pgmName");
					String url = (String)map.get("url");
					
					pVO.setPgmId(pgmId);
					pVO.setSeq(seq);
					pVO.setPgmName(pgmName);
					pVO.setUrl(url);
					
					if (Constants.IBSHEET_STATUS_INSERT.equals(status)) {
						programDAO.insertAdminSubProgram(pVO);
					} else if (Constants.IBSHEET_STATUS_UPDATE.equals(status)) {
						programDAO.updateAdminSubProgram(pVO);
					}
				// 삭제
				} else if (Constants.IBSHEET_STATUS_DELETE.equals(status)) {
					programVO.getDeleteSubList().add(map);
				}
			}
			
			if (programVO.getDeleteSubList().size() > 0) {
				programDAO.deleteAdminSubProgramList(programVO);
			}
		}
    }
	
	@Transactional
    public void deleteAdminProgramList(ProgramVO programVO) throws Exception {
		// 메뉴 설정 메뉴를 만들고 주석 풀기
		programDAO.deleteAdminMenuSettingList(programVO);
		programDAO.deleteAdminSubAllProgramList(programVO);
		programDAO.deleteAdminProgramList(programVO);
    }
	
	@Transactional
    public void deleteAdminProgram(ProgramVO programVO) throws Exception {
		// 메뉴 설정 메뉴를 만들고 주석 풀기
		programDAO.deleteAdminMenuSetting(programVO);
		programDAO.deleteAdminSubAllProgram(programVO);
		programDAO.deleteAdminProgram(programVO);
    }
	
	public List<CommonHashMap<String, Object>> selectUserProgramList(SearchVO searchVO) throws Exception {
		return programDAO.selectUserProgramList(searchVO);
	}
	
	public int selectUserProgramTotalCnt(SearchVO searchVO) throws Exception {
		return programDAO.selectUserProgramTotalCnt(searchVO);
	}
	
	public List<CommonHashMap<String, Object>> selectUserPopupProgramList(SearchVO searchVO) throws Exception {
		return programDAO.selectUserPopupProgramList(searchVO);
	}
	
	public CommonHashMap<String, Object> selectUserProgramView(SearchVO searchVO) throws Exception {
		return programDAO.selectUserProgramView(searchVO);
	}
	
	public List<CommonHashMap<String, Object>> selectUserSubProgramList(SearchVO searchVO) throws Exception {
		return programDAO.selectUserSubProgramList(searchVO);
	}
	
	public boolean userProgramUrlDuplicateCheck(ProgramVO programVO) throws Exception {
		boolean result = true;
		
		// 프로그램 URL 체크
		if (programDAO.getUserProgramDuplicateCnt(programVO) > 0) {
			result = false;
			
			return result;
		}
		
		for (Map<String, Object> map : programVO.getSubList()) {
			if (map.get("url") != null) {
				ProgramVO subVO = new ProgramVO();
				
				if (!StringUtil.isEmpty(map.get("pgmId").toString())) {
					subVO.setPgmId(Integer.parseInt(map.get("pgmId").toString()));
				}
				if (!StringUtil.isEmpty(map.get("seq").toString())) {
					subVO.setSeq(Integer.parseInt(map.get("seq").toString()));
				}
				subVO.setUrl(map.get("url").toString());
				
				// 하위 프로그램 URL 체크
				if (programDAO.getUserProgramListDuplicateCnt(subVO) > 0) {
					result = false;
					
					return result;
				}
			}
		}
		
		return result;
	}
	
	@Transactional
    public void insertUserProgram(ProgramVO programVO) throws Exception {
		programDAO.insertUserProgram(programVO);
		
		if (programVO.getSubList().size() > 0) {
			for (Map<String, Object> map : programVO.getSubList()) {
				String status = (String)map.get("status");
				
				// 등록
				if (Constants.IBSHEET_STATUS_INSERT.equals(status)) {
					ProgramVO pVO = new ProgramVO();
					
					int pgmId = programVO.getPgmId();
					String pgmName = (String)map.get("pgmName");
					String url = (String)map.get("url");
					String dscr = (String)map.get("dscr");
					
					pVO.setPgmId(pgmId);
					pVO.setPgmName(pgmName);
					pVO.setUrl(url);
					pVO.setDscr(dscr);
					
					programDAO.insertUserSubProgram(pVO);
				}
			}
		}
    }
	
	@Transactional
    public void updateUserProgram(ProgramVO programVO) throws Exception {
		programDAO.updateUserProgram(programVO);
		
		if (programVO.getSubList().size() > 0) {
			for (Map<String, Object> map : programVO.getSubList()) {
				String status = (String)map.get("status");
				
				// 등록 / 수정
				if (Constants.IBSHEET_STATUS_INSERT.equals(status) || Constants.IBSHEET_STATUS_UPDATE.equals(status)) {
					ProgramVO pVO = new ProgramVO();
					
					int pgmId = StringUtil.isEmpty(map.get("pgmId").toString()) ? programVO.getPgmId() : Integer.parseInt(map.get("pgmId").toString());
					int seq = StringUtil.isEmpty(map.get("seq").toString()) ? programVO.getSeq() : Integer.parseInt(map.get("seq").toString());
					String pgmName = (String)map.get("pgmName");
					String url = (String)map.get("url");
					String dscr = (String)map.get("dscr");
					
					pVO.setPgmId(pgmId);
					pVO.setSeq(seq);
					pVO.setPgmName(pgmName);
					pVO.setUrl(url);
					pVO.setDscr(dscr);
					
					if (Constants.IBSHEET_STATUS_INSERT.equals(status)) {
						programDAO.insertUserSubProgram(pVO);
					} else if (Constants.IBSHEET_STATUS_UPDATE.equals(status)) {
						programDAO.updateUserSubProgram(pVO);
					}
				// 삭제
				} else if (Constants.IBSHEET_STATUS_DELETE.equals(status)) {
					programVO.getDeleteSubList().add(map);
				}
			}
			
			if (programVO.getDeleteSubList().size() > 0) {
				programDAO.deleteUserSubProgramList(programVO);
			}
		}
    }
	
	@Transactional
    public void deleteUserProgramList(ProgramVO programVO) throws Exception {
		programDAO.deleteUserMenuSettingList(programVO);
		programDAO.deleteUserSubAllProgramList(programVO);
		programDAO.deleteUserProgramList(programVO);
    }
	
	@Transactional
    public void deleteUserProgram(ProgramVO programVO) throws Exception {
		programDAO.deleteUserMenuSetting(programVO);
		programDAO.deleteUserSubAllProgram(programVO);
		programDAO.deleteUserProgram(programVO);
    }
}