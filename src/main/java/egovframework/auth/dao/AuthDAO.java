package egovframework.auth.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.auth.vo.AuthVO;
import egovframework.common.dao.CommonDAO;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;

@Repository
public class AuthDAO extends CommonDAO {
	/**
	 * 권한 설정 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectSettingList(SearchVO searchVO) throws Exception {
		return selectList("AuthSQL.selectSettingList", searchVO);
	}

	/**
	 * 권한 설정 목록 총 건수
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectSettingTotalCnt(SearchVO searchVO) throws Exception {
		return selectOne("AuthSQL.selectSettingTotalCnt", searchVO);
	}

	/**
	 * 권한 설정 상세 조회
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public CommonHashMap<String, Object> selectSettingView(SearchVO searchVO) throws Exception {
		return selectOne("AuthSQL.selectSettingView", searchVO);
	}

	/**
	 * 권한 설정 상세 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectSettingAuthList(SearchVO searchVO) throws Exception {
		return selectList("AuthSQL.selectSettingAuthList", searchVO);
	}

	/**
	 * 권한 설정 등록
	 *
	 * @param authVO
	 * @return
	 * @throws Exception
	 */
	public int insertAuthSetting(AuthVO authVO) throws Exception {
		return insert("AuthSQL.insertAuthSetting", authVO);
	}

	/**
	 * 권한 설정 수정
	 *
	 * @param authVO
	 * @return
	 * @throws Exception
	 */
	public int updateAuthSetting(AuthVO authVO) throws Exception {
		return update("AuthSQL.updateAuthSetting", authVO);
	}

	/**
	 * 권한 설정 상세 병합
	 *
	 * @param authVO
	 * @return
	 * @throws Exception
	 */
	public int mergeAuthSettingDetail(AuthVO authVO) throws Exception {
		return update("AuthSQL.mergeAuthSettingDetail", authVO);
	}

	/**
	 * 권한 설정 삭제
	 *
	 * @param authVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAuthSettingList(AuthVO authVO) throws Exception {
		return delete("AuthSQL.deleteAuthSettingList", authVO);
	}

	/**
	 * 권한 설정 삭제
	 *
	 * @param authVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAuthSettingDetailList(AuthVO authVO) throws Exception {
		return delete("AuthSQL.deleteAuthSettingDetailList", authVO);
	}

	/**
	 * 부여된 권한 설정 삭제
	 *
	 * @param authVO
	 * @return
	 * @throws Exception
	 */
	public int deleteGrantDetailList(AuthVO authVO) throws Exception {
		return delete("AuthSQL.deleteGrantDetailList", authVO);
	}

	/**
	 * 권한 부여 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectGrantList(SearchVO searchVO) throws Exception {
		return selectList("AuthSQL.selectGrantList", searchVO);
	}

	/**
	 * 권한 부여 목록 총 건수
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectGrantTotalCnt(SearchVO searchVO) throws Exception {
		return selectOne("AuthSQL.selectGrantTotalCnt", searchVO);
	}

	/**
	 * 사용자 선택 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectMemberList(SearchVO searchVO) throws Exception {
		return selectList("AuthSQL.selectMemberList", searchVO);
	}

	/**
	 * 사용자 선택 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectAuthList(SearchVO searchVO) throws Exception {
		return selectList("AuthSQL.selectAuthList", searchVO);
	}

	/**
	 * 권한 부여 수정
	 *
	 * @param authVO
	 * @return
	 * @throws Exception
	 */
	public int mergeAuthGrant(AuthVO authVO) throws Exception {
		return update("AuthSQL.mergeAuthGrant", authVO);
	}

	/**
	 * 권한 부여 등록만
	 *
	 * @param authVO
	 * @return
	 * @throws Exception
	 */
	public int mergeAuthGrantOnlyInsert(AuthVO authVO) throws Exception {
		return update("AuthSQL.mergeAuthGrantOnlyInsert", authVO);
	}

	/**
	 * 권한 부여 상세 등록
	 *
	 * @param authVO
	 * @return
	 * @throws Exception
	 */
	public int insertAuthGrantDetail(AuthVO authVO) throws Exception {
		return insert("AuthSQL.insertAuthGrantDetail", authVO);
	}

	/**
	 * 권한 부여 상세 삭제
	 *
	 * @param authVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAuthGrantDetail(AuthVO authVO) throws Exception {
		return delete("AuthSQL.deleteAuthGrantDetail", authVO);
	}

	/**
	 * 권한 부여 상세 조회
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public CommonHashMap<String, Object> selectGrantView(SearchVO searchVO) throws Exception {
		return selectOne("AuthSQL.selectGrantView", searchVO);
	}

	/**
	 * 부여받은 권한 목록
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectGrantAuthList(SearchVO searchVO) throws Exception {
		return selectList("AuthSQL.selectGrantAuthList", searchVO);
	}

	/**
	 * 권한 부여 목록 삭제
	 *
	 * @param authVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAuthGrant(AuthVO authVO) throws Exception {
		return delete("AuthSQL.deleteAuthGrant", authVO);
	}

	/**
	 * 권한 부여 상세 목록 삭제
	 *
	 * @param authVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAuthGrantDetailList(AuthVO authVO) throws Exception {
		return delete("AuthSQL.deleteAuthGrantDetailList", authVO);
	}

	/**
	 * 로그인시 권한
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectAuthSubList(String userId) throws Exception {
		return selectList("AuthSQL.selectAuthSubList", userId);
	}

	/**
	 * 특정 메뉴에 권한이 있는지 여부
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectParticularGrantCnt(SearchVO searchVO) throws Exception {
		return selectOne("AuthSQL.selectParticularGrantCnt", searchVO);
	}

	/**
	 * 해당 사용자에 권한이 있는지 있는지 여부
	 *
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectUserGrantCnt(SearchVO searchVO) throws Exception {
		return selectOne("AuthSQL.selectUserGrantCnt", searchVO);
	}
}