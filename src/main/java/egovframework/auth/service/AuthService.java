package egovframework.auth.service;

import egovframework.auth.dao.AuthDAO;
import egovframework.auth.vo.AuthVO;
import egovframework.common.Constants;
import egovframework.common.util.StringUtil;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Service
public class AuthService {
	private static final Logger LOGGER = LoggerFactory.getLogger(AuthService.class);

	/** AuthDAO */
	@Autowired
	private AuthDAO authDAO;

	public List<CommonHashMap<String, Object>> selectSettingList(SearchVO searchVO) throws Exception {
		return authDAO.selectSettingList(searchVO);
	}

	public int selectSettingTotalCnt(SearchVO searchVO) throws Exception {
		return authDAO.selectSettingTotalCnt(searchVO);
	}

	public CommonHashMap<String, Object> selectSettingView(SearchVO searchVO) throws Exception {
		return authDAO.selectSettingView(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectSettingAuthList(SearchVO searchVO) throws Exception {
		return authDAO.selectSettingAuthList(searchVO);
	}

	@Transactional
	public void mergeSettingAuthInfo(AuthVO authVO) throws Exception {
		// 수정
		if (authVO.getAuthId() > 0) {
			authDAO.updateAuthSetting(authVO);
		// 등록
		} else {
			authDAO.insertAuthSetting(authVO);
		}

		if (authVO.getAuthList().size() > 0) {
			for (Map<String, Object> map : authVO.getAuthList()) {
				AuthVO aVO = new AuthVO();

				String menuSetId = (String)map.get("menuSetId");
				String accessAuthYn = (String)map.get("accessAuthYn");
				String modifyAuthYn = (String)map.get("modifyAuthYn");

				aVO.setSystemMenuId(authVO.getSystemMenuId());
				aVO.setMenuSetId(Integer.parseInt(menuSetId));
				aVO.setAuthId(authVO.getAuthId());
				aVO.setAccessAuthYn(accessAuthYn);
				aVO.setModifyAuthYn(modifyAuthYn);

				// 병합
				authDAO.mergeAuthSettingDetail(aVO);
			}
		}

    }

	@Transactional
	public void deleteSettingAuthInfo(AuthVO authVO) throws Exception {
		authDAO.deleteGrantDetailList(authVO);
		authDAO.deleteAuthSettingDetailList(authVO);
		authDAO.deleteAuthSettingList(authVO);
    }

	public List<CommonHashMap<String, Object>> selectGrantList(SearchVO searchVO) throws Exception {
		return authDAO.selectGrantList(searchVO);
	}

	public int selectGrantTotalCnt(SearchVO searchVO) throws Exception {
		return authDAO.selectGrantTotalCnt(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectAuthList(AuthVO authVO) throws Exception {
		if (StringUtil.isNotEmpty(authVO.getExceptIds())) {
			authVO.setExceptIdList(Arrays.asList(authVO.getExceptIds().split("\\s*,\\s*")));
		}

		return authDAO.selectAuthList(authVO);
	}

	@Transactional
	public void mergeGrantAuthInfo(AuthVO authVO) throws Exception {
		// 병합
		authDAO.mergeAuthGrant(authVO);

		if (authVO.getAuthList().size() > 0) {
			for (Map<String, Object> map : authVO.getAuthList()) {
				String status = (String)map.get("status");

				AuthVO aVO = new AuthVO();

				String systemMenuId = (String)map.get("systemMenuId");
				String authId = (String)map.get("authId");

				aVO.setUserId(authVO.getUserId());
				aVO.setSystemMenuId(Integer.parseInt(systemMenuId));
				aVO.setAuthId(Integer.parseInt(authId));

				// 등록
				if (Constants.IBSHEET_STATUS_INSERT.equals(status)) {
					authDAO.insertAuthGrantDetail(aVO);
				// 삭제
				} else if (Constants.IBSHEET_STATUS_DELETE.equals(status)) {
					authDAO.deleteAuthGrantDetail(aVO);
				}
			}
		}

    }

	public CommonHashMap<String, Object> selectGrantView(SearchVO searchVO) throws Exception {
		return authDAO.selectGrantView(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectGrantAuthList(SearchVO searchVO) throws Exception {
		return authDAO.selectGrantAuthList(searchVO);
	}

	@Transactional
	public void deleteAuthGrantList(AuthVO authVO) throws Exception {
		if (authVO.getDeleteAuthList().size() > 0) {
			for (Map<String, Object> map : authVO.getDeleteAuthList()) {
				AuthVO aVO = new AuthVO();

				String userId = (String)map.get("userId");

				aVO.setUserId(userId);

				authDAO.deleteAuthGrantDetailList(aVO);
				authDAO.deleteAuthGrant(aVO);
			}
		}
    }
}