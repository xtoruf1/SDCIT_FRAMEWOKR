package egovframework.menu.vo;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.builder.ToStringBuilder;

import egovframework.common.vo.CommonVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class MenuVO extends CommonVO {
	/**
	 * serialVersion UID
	 */
	private static final long serialVersionUID = 1L;

	// 메뉴 시퀀스
	private int menuSeq;

	// 메뉴 정렬순서
	private int menuSort;

	// 메뉴 뎁스
	private int depth;

	// 프로그램 시퀀스
	private int programSeq;

	// 탭여부
	private String tabYn;

	// 시스템 메뉴아이디
	private int systemMenuId;

	// 시스템 메뉴아이디(정렬순서)
	private String systemMenuIds;

	// 시스템 메뉴명
	private String systemMenuName;

	// 비고
	private String dscr;

	// 시스템 대메뉴아이디
	private int topMenuId;

	// 시스템 대메뉴명
	private String topMenuName;

	// 메뉴설정아이디
	private String menuSetId;

	// 메뉴설정아이디(정렬순서)
	private String menuSetIds;

	// 상위아이디
	private String upperId;

	// 프로그램아이디
	private int pgmId;

	//메뉴 타입
	private int menuType;

	// 이미지 ON
	private String imgOn;

	// 이미지 OFF
	private String imgOff;

	// 순번
	private String sortSeq;

	// 검색조건(시스템명)
	private String searchSystemMenuName = "";

	// 검색조건(비고)
	private String searchDscr = "";

	// 검색조건(비고)
	private String searchRmk = "";

	// 권한1
	private String auth1;

	// 권한2
	private String auth2;

	// 권한3
	private String auth3;

	// 권한4
	private String auth4;

	// 권한5
	private String auth5;

	// 권한6
	private String auth6;

	// 권한7
	private String auth7;

	// 권한8
	private String auth8;

	// 권한9
	private String auth9;

	// 권한10
	private String auth10;

	// 권한11
	private String auth11;

	// 권한12
	private String auth12;

	// 권한13
	private String auth13;

	// 권한14
	private String auth14;

	// 권한15
	private String auth15;

	// 권한16
	private String auth16;

	// 권한17
	private String auth17;

	// 권한18
	private String auth18;

	// 권한19
	private String auth19;

	// 권한20
	private String auth20;

	// 메뉴구분
	private String menuGb;

	// 유저아이디
	private String userId;

	// URL
	private String url;

	private List<String> menuSeqList = new ArrayList<String>();
	private List<String> pgmIdList = new ArrayList<String>();
	private List<Map<String, Object>> menuList = new ArrayList<Map<String, Object>>();
	private List<Map<String, Object>> deleteMenuList = new ArrayList<Map<String, Object>>();



	// 신규시작

	// 시스템 메뉴아이디
	private int sysMenuNo;

	// 시스템 대메뉴명
	private String menuMn;

	// 시스템 관리 비고
	private String rmkCntn;

	// 신규종료

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}