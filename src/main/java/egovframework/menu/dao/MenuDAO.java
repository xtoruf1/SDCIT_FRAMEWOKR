package egovframework.menu.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.common.dao.CommonDAO;
import egovframework.common.util.StringUtil;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import egovframework.menu.vo.MenuVO;

@Repository
public class MenuDAO extends CommonDAO {

	private static final String ACTIVE_PROFILE = StringUtil.nvl(System.getProperty("spring.profiles.active"), "local");

	/**
	 * 시스템 메뉴 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectSystemTopList(SearchVO searchVO) throws Exception {
		return selectList("MenuSQL.selectSystemTopList", searchVO);
	}

	/**
	 * 좌측 메뉴 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectSystemLeftList(SearchVO searchVO) throws Exception {
		return selectList("MenuSQL.selectSystemLeftList", searchVO);
	}

	/**
	 * 시스템 메뉴 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectAdminSystemList(SearchVO searchVO) throws Exception {
		return selectList("MenuSQL.selectAdminSystemList", searchVO);
	}

	/**
	 * 시스템 메뉴 총 건수
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectSystemTotalCnt(SearchVO searchVO) throws Exception {
		return selectOne("MenuSQL.selectSystemTotalCnt", searchVO);
	}

	/**
	 * 시스템 메뉴 조회
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public CommonHashMap<String, Object> selectAdminSystemView(SearchVO searchVO) throws Exception {
		return selectOne("MenuSQL.selectAdminSystemView", searchVO);
	}

	/**
	 * 등록/수정시 시스템 메뉴명 중복 건수
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int getAdminSystemDuplicateCnt(SearchVO searchVO) throws Exception {
		return selectOne("MenuSQL.getAdminSystemDuplicateCnt", searchVO);
	}

	/**
	 * 시스템 메뉴 등록
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int insertAdminSystem(MenuVO menuVO) throws Exception {
		return insert("MenuSQL.insertAdminSystem", menuVO);
	}

	/**
	 * 시스템 메뉴 수정
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int updateAdminSystem(MenuVO menuVO) throws Exception {
		return update("MenuSQL.updateAdminSystem", menuVO);
	}

	/**
	 * 시스템 메뉴 삭제
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAdminSystem(MenuVO menuVO) throws Exception {
		return delete("MenuSQL.deleteAdminSystem", menuVO);
	}

	/**
	 * 시스템 메뉴 목록 삭제
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAdminSystemList(MenuVO menuVO) throws Exception {
		return delete("MenuSQL.deleteAdminSystemList", menuVO);
	}

	/**
	 * 대메뉴 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectUserSystemList(SearchVO searchVO) throws Exception {
		return selectList("MenuSQL.selectUserSystemList", searchVO);
	}

	/**
	 * 대메뉴 총 건수
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectUserSystemTotalCnt(SearchVO searchVO) throws Exception {
		return selectOne("MenuSQL.selectUserSystemTotalCnt", searchVO);
	}

	/**
	 * 대메뉴 조회
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public CommonHashMap<String, Object> selectUserSystemView(SearchVO searchVO) throws Exception {
		return selectOne("MenuSQL.selectUserSystemView", searchVO);
	}

	/**
	 * 등록/수정시 대메뉴명 중복 건수
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int getUserSystemDuplicateCnt(SearchVO searchVO) throws Exception {
		return selectOne("MenuSQL.getUserSystemDuplicateCnt", searchVO);
	}

	/**
	 * 대메뉴 등록
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int insertUserSystem(MenuVO menuVO) throws Exception {
		return insert("MenuSQL.insertUserSystem", menuVO);
	}

	/**
	 * 대메뉴 수정
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int updateUserSystem(MenuVO menuVO) throws Exception {
		return update("MenuSQL.updateUserSystem", menuVO);
	}

	/**
	 * 대메뉴 삭제
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int deleteUserSystem(MenuVO menuVO) throws Exception {
		return delete("MenuSQL.deleteUserSystem", menuVO);
	}

	/**
	 * 대메뉴 목록 삭제
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int deleteUserSystemList(MenuVO menuVO) throws Exception {
		return delete("MenuSQL.deleteUserSystemList", menuVO);
	}

	/**
	 * 시스템메뉴 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectAdminSystemMenuList() throws Exception {
		return selectList("MenuSQL.selectAdminSystemMenuList");
	}

	/**
	 * 메뉴 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectAdminMenuList(SearchVO searchVO) throws Exception {
		return selectList("MenuSQL.selectAdminMenuList", searchVO);
	}

	/**
	 * 프로그램 목록 팝업에서 선택된 프로그램 메뉴에 등록
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int insertAdminMenuProgram(MenuVO menuVO) throws Exception {
		return insert("MenuSQL.insertAdminMenuProgram", menuVO);
	}

	/**
	 * 메뉴 목록(뎁스)
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectAdminMenuDepthList(SearchVO searchVO) throws Exception {
		return selectList("MenuSQL.selectAdminMenuDepthList", searchVO);
	}

	/**
	 * 메뉴 정렬순서 변경
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int updateAdminMenuSort(MenuVO menuVO) throws Exception {
		return update("MenuSQL.updateAdminMenuSort", menuVO);
	}

	/**
	 * 메뉴 삭제
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAdminMenuList(MenuVO menuVO) throws Exception {
		return update("MenuSQL.deleteAdminMenuList", menuVO);
	}

	/**
	 * 권한설정에서 메뉴 삭제
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAuthSettingDetailList(MenuVO menuVO) throws Exception {
		return update("MenuSQL.deleteAuthSettingDetailList", menuVO);
	}


	/**
	 * 대메뉴 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectUserTopMenuList(SearchVO searchVO) throws Exception {
		return selectList("MenuSQL.selectUserTopMenuList", searchVO);
	}

	/**
	 * 권한 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectUserAuthList(SearchVO searchVO) throws Exception {
		return selectList("MenuSQL.selectUserAuthList", searchVO);
	}

	/**
	 * 메뉴 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectUserMenuList(SearchVO searchVO) throws Exception {
		return selectList("MenuSQL.selectUserMenuList", searchVO);
	}

	/**
	 * 프로그램 목록 팝업에서 선택된 프로그램 메뉴에 등록
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int insertUserMenuProgram(MenuVO menuVO) throws Exception {
		return insert("MenuSQL.insertUserMenuProgram", menuVO);
	}

	/**
	 * 메뉴 목록(뎁스)
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectUserMenuDepthList(SearchVO searchVO) throws Exception {
		return selectList("MenuSQL.selectUserMenuDepthList", searchVO);
	}

	/**
	 * 메뉴 정렬순서 변경
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int updateUserMenuSort(MenuVO menuVO) throws Exception {
		return update("MenuSQL.updateUserMenuSort", menuVO);
	}

	/**
	 * 메뉴 삭제
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int deleteUserMenuList(MenuVO menuVO) throws Exception {
		return update("MenuSQL.deleteUserMenuList", menuVO);
	}

	/**
	 * 메뉴 권한 수정
	 *
	 * @param menuVO
	 * @return
	 * @throws Exception
	 */
	public int updateUserMenu(MenuVO menuVO) throws Exception {
		return update("MenuSQL.updateUserMenu", menuVO);
	}

	/**
	 * 관리자 프로그램에 해당 URL이 존재하는지 여부
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectAdminUrlProgramCnt(SearchVO searchVO) throws Exception {
		return selectOne("MenuSQL.selectAdminUrlProgramCnt", searchVO);
	}

	/**
	 * 관리자 메뉴에 해당 URL로 권한이 존재하는지 여부
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectAdminMenuAuthExist(SearchVO searchVO) throws Exception {
		return selectOne("MenuSQL.selectAdminMenuAuthExist", searchVO);
	}

	public CommonHashMap<String, Object> getAwardAndFundAuthType(SearchVO searchVO) throws Exception {
		return selectOne("MenuSQL.getAwardAndFundAuthType", searchVO);
	}

}