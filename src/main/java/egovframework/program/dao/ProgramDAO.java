package egovframework.program.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.common.dao.CommonDAO;
import egovframework.common.util.StringUtil;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import egovframework.program.vo.ProgramVO;

@Repository
public class ProgramDAO extends CommonDAO {

	private static final String ACTIVE_PROFILE = StringUtil.nvl(System.getProperty("spring.profiles.active"), "local");
	
//	하새결임시
	public List<CommonHashMap<String, Object>> getTestData(SearchVO searchVO) throws Exception {
		return selectList("ProgramSQL.getTestData", searchVO);
	}

	/**
	 * 프로그램 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectAdminProgramList(SearchVO searchVO) throws Exception {
		return selectList("ProgramSQL.selectAdminProgramList", searchVO);
	}

	/**
	 * 프로그램 총 건수
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectAdminProgramTotalCnt(SearchVO searchVO) throws Exception {
		return selectOne("ProgramSQL.selectAdminProgramTotalCnt", searchVO);
	}

	/**
	 * 프로그램 목록(팝업)
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectAdminPopupProgramList(SearchVO searchVO) throws Exception {
		return selectList("ProgramSQL.selectAdminPopupProgramList", searchVO);
	}

	/**
	 * 프로그램 조회
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public CommonHashMap<String, Object> selectAdminProgramView(SearchVO searchVO) throws Exception {
		return selectOne("ProgramSQL.selectAdminProgramView", searchVO);
	}

	/**
	 * 하위 프로그램 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectAdminSubProgramList(SearchVO searchVO) throws Exception {
		return selectList("ProgramSQL.selectAdminSubProgramList", searchVO);
	}

	/**
	 * 프로그램 URL 중복체크
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int getAdminProgramDuplicateCnt(SearchVO searchVO) throws Exception {
		return selectOne("ProgramSQL.getAdminProgramDuplicateCnt", searchVO);
	}

	/**
	 * 하위 프로그램 URL 중복체크
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int getAdminProgramListDuplicateCnt(SearchVO searchVO) throws Exception {
		return selectOne("ProgramSQL.getAdminProgramListDuplicateCnt", searchVO);
	}

	/**
	 * 프로그램 등록
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int insertAdminProgram(ProgramVO programVO) throws Exception {
		return insert("ProgramSQL.insertAdminProgram", programVO);
	}

	/**
	 * 프로그램 수정
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int updateAdminProgram(ProgramVO programVO) throws Exception {
		return update("ProgramSQL.updateAdminProgram", programVO);
	}

	/**
	 * 프로그램 삭제
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAdminProgramList(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteAdminProgramList", programVO);
	}

	/**
	 * 하위 프로그램 삭제
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAdminSubAllProgramList(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteAdminSubAllProgramList", programVO);
	}

	/**
	 * 메뉴 설정 존재하는 프로그램 삭제
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAdminMenuSettingList(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteAdminMenuSettingList", programVO);
	}

	/**
	 * 프로그램 삭제(단일)
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAdminProgram(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteAdminProgram", programVO);
	}

	/**
	 * 하위 프로그램 삭제(단일)
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAdminSubAllProgram(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteAdminSubAllProgram", programVO);
	}

	/**
	 * 메뉴 설정 존재하는 프로그램 삭제(단일)
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAdminMenuSetting(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteAdminMenuSetting", programVO);
	}

	/**
	 * 하위 프로그램 등록
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int insertAdminSubProgram(ProgramVO programVO) throws Exception {
		return insert("ProgramSQL.insertAdminSubProgram", programVO);
	}

	/**
	 * 하위 프로그램 수정
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int updateAdminSubProgram(ProgramVO programVO) throws Exception {
		return update("ProgramSQL.updateAdminSubProgram", programVO);
	}

	/**
	 * 하위 프로그램 삭제
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAdminSubProgramList(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteAdminSubProgramList", programVO);
	}

	/**
	 * 프로그램 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectUserProgramList(SearchVO searchVO) throws Exception {
		return selectList("ProgramSQL.selectUserProgramList", searchVO);
	}

	/**
	 * 프로그램 총 건수
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectUserProgramTotalCnt(SearchVO searchVO) throws Exception {
		return selectOne("ProgramSQL.selectUserProgramTotalCnt", searchVO);
	}

	/**
	 * 프로그램 목록(팝업)
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectUserPopupProgramList(SearchVO searchVO) throws Exception {
		return selectList("ProgramSQL.selectUserPopupProgramList", searchVO);
	}

	/**
	 * 프로그램 조회
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public CommonHashMap<String, Object> selectUserProgramView(SearchVO searchVO) throws Exception {
		return selectOne("ProgramSQL.selectUserProgramView", searchVO);
	}

	/**
	 * 하위 프로그램 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectUserSubProgramList(SearchVO searchVO) throws Exception {
		return selectList("ProgramSQL.selectUserSubProgramList", searchVO);
	}

	/**
	 * 프로그램 URL 중복체크
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int getUserProgramDuplicateCnt(SearchVO searchVO) throws Exception {
		return selectOne("ProgramSQL.getUserProgramDuplicateCnt", searchVO);
	}

	/**
	 * 하위 프로그램 URL 중복체크
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int getUserProgramListDuplicateCnt(SearchVO searchVO) throws Exception {
		return selectOne("ProgramSQL.getUserProgramListDuplicateCnt", searchVO);
	}

	/**
	 * 프로그램 등록
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int insertUserProgram(ProgramVO programVO) throws Exception {
		return insert("ProgramSQL.insertUserProgram", programVO);
	}

	/**
	 * 프로그램 수정
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int updateUserProgram(ProgramVO programVO) throws Exception {
		return update("ProgramSQL.updateUserProgram", programVO);
	}

	/**
	 * 프로그램 삭제
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteUserProgramList(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteUserProgramList", programVO);
	}

	/**
	 * 하위 프로그램 삭제
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteUserSubAllProgramList(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteUserSubAllProgramList", programVO);
	}

	/**
	 * 메뉴 설정 존재하는 프로그램 삭제
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteUserMenuSettingList(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteUserMenuSettingList", programVO);
	}

	/**
	 * 프로그램 삭제(단일)
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteUserProgram(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteUserProgram", programVO);
	}

	/**
	 * 하위 프로그램 삭제(단일)
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteUserSubAllProgram(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteUserSubAllProgram", programVO);
	}

	/**
	 * 메뉴 설정 존재하는 프로그램 삭제(단일)
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteUserMenuSetting(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteUserMenuSetting", programVO);
	}

	/**
	 * 하위 프로그램 등록
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int insertUserSubProgram(ProgramVO programVO) throws Exception {
		return insert("ProgramSQL.insertUserSubProgram", programVO);
	}

	/**
	 * 하위 프로그램 수정
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int updateUserSubProgram(ProgramVO programVO) throws Exception {
		return update("ProgramSQL.updateUserSubProgram", programVO);
	}

	/**
	 * 하위 프로그램 삭제
	 *
	 * @param programVO
	 * @return
	 * @throws Exception
	 */
	public int deleteUserSubProgramList(ProgramVO programVO) throws Exception {
		return delete("ProgramSQL.deleteUserSubProgramList", programVO);
	}
}