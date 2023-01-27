package egovframework.menu.service;

import java.util.Arrays;
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
import egovframework.menu.dao.MenuDAO;
import egovframework.menu.vo.MenuVO;

@Service
public class MenuService {
	private static final Logger LOGGER = LoggerFactory.getLogger(MenuService.class);

	/** MenuDAO */
	@Autowired
	private MenuDAO menuDAO;

	public List<CommonHashMap<String, Object>> selectSystemTopList(SearchVO searchVO) throws Exception {
		return menuDAO.selectSystemTopList(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectSystemLeftList(SearchVO searchVO) throws Exception {
		return menuDAO.selectSystemLeftList(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectAdminSystemList(SearchVO searchVO) throws Exception {
		return menuDAO.selectAdminSystemList(searchVO);
	}

	public int selectSystemTotalCnt(SearchVO searchVO) throws Exception {
		return menuDAO.selectSystemTotalCnt(searchVO);
	}

	public CommonHashMap<String, Object> selectAdminSystemView(SearchVO searchVO) throws Exception {
		return menuDAO.selectAdminSystemView(searchVO);
	}

	public int getAdminSystemDuplicateCnt(SearchVO searchVO) throws Exception {
		return menuDAO.getAdminSystemDuplicateCnt(searchVO);
	}

	@Transactional
    public void insertAdminSystem(MenuVO menuVO) throws Exception {
		menuDAO.insertAdminSystem(menuVO);
    }

	@Transactional
    public void updateAdminSystem(MenuVO menuVO) throws Exception {
		menuDAO.updateAdminSystem(menuVO);
    }

	@Transactional
    public void deleteAdminSystem(MenuVO menuVO) throws Exception {
		menuDAO.deleteAdminSystem(menuVO);
    }

	@Transactional
    public void deleteAdminSystemList(MenuVO menuVO) throws Exception {
		menuDAO.deleteAdminSystemList(menuVO);
    }

	public List<CommonHashMap<String, Object>> selectUserSystemList(SearchVO searchVO) throws Exception {
		return menuDAO.selectUserSystemList(searchVO);
	}

	public int selectUserSystemTotalCnt(SearchVO searchVO) throws Exception {
		return menuDAO.selectUserSystemTotalCnt(searchVO);
	}

	public CommonHashMap<String, Object> selectUserSystemView(SearchVO searchVO) throws Exception {
		return menuDAO.selectUserSystemView(searchVO);
	}

	public int getUserSystemDuplicateCnt(SearchVO searchVO) throws Exception {
		return menuDAO.getUserSystemDuplicateCnt(searchVO);
	}

	@Transactional
    public void insertUserSystem(MenuVO menuVO) throws Exception {
		menuDAO.insertUserSystem(menuVO);
    }

	@Transactional
    public void updateUserSystem(MenuVO menuVO) throws Exception {
		menuDAO.updateUserSystem(menuVO);
    }

	@Transactional
    public void deleteUserSystem(MenuVO menuVO) throws Exception {
		menuDAO.deleteUserSystem(menuVO);
    }

	@Transactional
	public void deleteUserSystemList(MenuVO menuVO) throws Exception {
		menuDAO.deleteUserSystemList(menuVO);
	}

	public List<CommonHashMap<String, Object>> selectAdminSystemMenuList() throws Exception {
		return menuDAO.selectAdminSystemMenuList();
	}

	public List<CommonHashMap<String, Object>> selectAdminMenuList(SearchVO searchVO) throws Exception {
		return menuDAO.selectAdminMenuList(searchVO);
	}

	@Transactional
    public void insertAdminMenuProgram(MenuVO menuVO) throws Exception {
		if (menuVO.getPgmIdList().size() > 0) {
			for (String pgmId : menuVO.getPgmIdList()) {
				MenuVO mVO = new MenuVO();
				mVO.setSystemMenuId(menuVO.getSystemMenuId());
				mVO.setMenuSetId(menuVO.getMenuSetId());
				mVO.setPgmId(Integer.parseInt(pgmId));

				menuDAO.insertAdminMenuProgram(mVO);
			}
		}
    }

	public List<CommonHashMap<String, Object>> selectAdminMenuDepthList(SearchVO searchVO) throws Exception {
		return menuDAO.selectAdminMenuDepthList(searchVO);
	}

	@Transactional
    public void updateAdminMenuSort(MenuVO menuVO) throws Exception {
		if (!StringUtil.isEmpty(menuVO.getMenuSetIds())) {
			List<String> idList = Arrays.asList(menuVO.getMenuSetIds().split("\\s*,\\s*"));

			for (int i = 0; i < idList.size(); i++) {
				MenuVO mVO = new MenuVO();

				String menuGb = menuVO.getMenuGb();

				mVO.setMenuGb(menuGb);

				if ("A".equals(menuGb)) {
					mVO.setSortSeq(String.valueOf(i + 1));
					mVO.setSystemMenuId(Integer.parseInt(idList.get(i)));
				} else {
					mVO.setMenuSeq(i + 1);
					mVO.setMenuSetId(idList.get(i).toString());
				}


				menuDAO.updateAdminMenuSort(mVO);
			}
		}
    }

	@Transactional
    public void deleteAdminMenuList(MenuVO menuVO) throws Exception {
		if (menuVO.getMenuList().size() > 0) {
			for (Map<String, Object> map : menuVO.getMenuList()) {
				String status = (String)map.get("status");

				// 삭제
				if (Constants.IBSHEET_STATUS_DELETE.equals(status)) {
					menuVO.getDeleteMenuList().add(map);
				}
			}
		}

		if (menuVO.getDeleteMenuList().size() > 0) {
			menuDAO.deleteAuthSettingDetailList(menuVO);
			menuDAO.deleteAdminMenuList(menuVO);
		}
    }

	public List<CommonHashMap<String, Object>> selectUserTopMenuList(SearchVO searchVO) throws Exception {
		return menuDAO.selectUserTopMenuList(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectUserAuthList(SearchVO searchVO) throws Exception {
		return menuDAO.selectUserAuthList(searchVO);
	}

	public List<CommonHashMap<String, Object>> selectUserMenuList(SearchVO searchVO) throws Exception {
		return menuDAO.selectUserMenuList(searchVO);
	}

	@Transactional
    public void insertUserMenuProgram(MenuVO menuVO) throws Exception {
		menuDAO.insertUserMenuProgram(menuVO);
    }

	public List<CommonHashMap<String, Object>> selectUserMenuDepthList(SearchVO searchVO) throws Exception {
		return menuDAO.selectUserMenuDepthList(searchVO);
	}

	@Transactional
    public void updateUserMenuSort(MenuVO menuVO) throws Exception {
		if (!StringUtil.isEmpty(menuVO.getMenuSetIds())) {
			List<String> idList = Arrays.asList(menuVO.getMenuSetIds().split("\\s*,\\s*"));

			for (int i = 0; i < idList.size(); i++) {
				MenuVO mVO = new MenuVO();

				mVO.setMenuSeq(i + 1);
				mVO.setMenuSetId(idList.get(i).toString());

				menuDAO.updateUserMenuSort(mVO);
			}
		}
    }

	@Transactional
    public void updateUserMenu(MenuVO menuVO) throws Exception {
		if (menuVO.getMenuList().size() > 0) {
			for (Map<String, Object> map : menuVO.getMenuList()) {
				String status = (String)map.get("status");

				// 수정
				if (Constants.IBSHEET_STATUS_UPDATE.equals(status)) {
					MenuVO mVO = new MenuVO();

					String auth1 = (String)map.get("auth1");
					if ("Y".equals(auth1)) {
						mVO.setAuth1(auth1);
					}
					String auth2 = (String)map.get("auth2");
					if ("Y".equals(auth2)) {
						mVO.setAuth2(auth2);
					}
					String auth3 = (String)map.get("auth3");
					if ("Y".equals(auth3)) {
						mVO.setAuth3(auth3);
					}
					String auth4 = (String)map.get("auth4");
					if ("Y".equals(auth4)) {
						mVO.setAuth4(auth4);
					}
					String auth5 = (String)map.get("auth5");
					if ("Y".equals(auth5)) {
						mVO.setAuth5(auth5);
					}
					String auth6 = (String)map.get("auth6");
					if ("Y".equals(auth6)) {
						mVO.setAuth6(auth6);
					}
					String auth7 = (String)map.get("auth7");
					if ("Y".equals(auth7)) {
						mVO.setAuth7(auth7);
					}
					String auth8 = (String)map.get("auth8");
					if ("Y".equals(auth8)) {
						mVO.setAuth8(auth8);
					}
					String auth9 = (String)map.get("auth9");
					if ("Y".equals(auth9)) {
						mVO.setAuth9(auth9);
					}
					String auth10 = (String)map.get("auth10");
					if ("Y".equals(auth10)) {
						mVO.setAuth10(auth10);
					}
					String auth11 = (String)map.get("auth11");
					if ("Y".equals(auth11)) {
						mVO.setAuth11(auth11);
					}
					String auth12 = (String)map.get("auth12");
					if ("Y".equals(auth12)) {
						mVO.setAuth12(auth12);
					}
					String auth13 = (String)map.get("auth13");
					if ("Y".equals(auth13)) {
						mVO.setAuth13(auth13);
					}
					String auth14 = (String)map.get("auth14");
					if ("Y".equals(auth14)) {
						mVO.setAuth14(auth14);
					}
					String auth15 = (String)map.get("auth15");
					if ("Y".equals(auth15)) {
						mVO.setAuth15(auth15);
					}
					String auth16 = (String)map.get("auth16");
					if ("Y".equals(auth16)) {
						mVO.setAuth16(auth16);
					}
					String auth17 = (String)map.get("auth17");
					if ("Y".equals(auth17)) {
						mVO.setAuth17(auth17);
					}
					String auth18 = (String)map.get("auth18");
					if ("Y".equals(auth18)) {
						mVO.setAuth18(auth18);
					}
					String auth19 = (String)map.get("auth19");
					if ("Y".equals(auth19)) {
						mVO.setAuth19(auth19);
					}
					String auth20 = (String)map.get("auth20");
					if ("Y".equals(auth20)) {
						mVO.setAuth20(auth20);
					}

					mVO.setMenuSetId((String)map.get("menuSetId"));

					menuDAO.updateUserMenu(mVO);
				// 삭제
				} else if (Constants.IBSHEET_STATUS_DELETE.equals(status)) {
					menuVO.getDeleteMenuList().add(map);
				}
			}
		}

		if (menuVO.getDeleteMenuList().size() > 0) {
			menuDAO.deleteUserMenuList(menuVO);
		}
    }

	public int selectAdminUrlProgramCnt(SearchVO searchVO) throws Exception {
		return menuDAO.selectAdminUrlProgramCnt(searchVO);
	}

	public int selectAdminMenuAuthExist(SearchVO searchVO) throws Exception {
		return menuDAO.selectAdminMenuAuthExist(searchVO);
	}

	public CommonHashMap<String, Object> getAwardAndFundAuthType(SearchVO searchVO) throws Exception {
		return menuDAO.getAwardAndFundAuthType(searchVO);
	}
}