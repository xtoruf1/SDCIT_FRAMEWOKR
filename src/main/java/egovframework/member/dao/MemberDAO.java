package egovframework.member.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.common.dao.CommonDAO;
import egovframework.common.login.vo.LoginUserVO;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import egovframework.member.vo.MemberVO;

/**
 * @author 이승준
 * 
 * 회원 관련 DAO
 */
@Repository
public class MemberDAO extends CommonDAO {
	/**
	 * 로그인 처리
	 * 
	 * @param memberVO
	 * @return
	 * @throws Exception
	 */
	public LoginUserVO selectMemberInfo(MemberVO memberVO) throws Exception {
		return selectOne("MemberSQL.selectMemberInfo", memberVO);
	}
	
	/**
	 * 개인정보 뷰 권한 체크
	 * 
	 * @param memberVO
	 * @return
	 * @throws Exception
	 */
	public LoginUserVO selectPersonalInfoAuth(String userId) throws Exception {
		return selectOne("MemberSQL.selectPersonalInfoAuth", userId);
	}
	
	/**
	 * 로그인 시간 입력(TB_USR 업데이트)
	 * 
	 * @param memberVO
	 * @throws Exception
	 */
	public void updateLoginDt(MemberVO memberVO) throws Exception {
		update("MemberSQL.updateLoginDt", memberVO);
	}
	
	/**
	 * 사용자 목록
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonHashMap<String, Object>> selectMemberList(SearchVO searchVO) throws Exception {
		return selectList("MemberSQL.selectMemberList", searchVO);
	}
	
	/**
	 * 사용자 목록 카운트
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectMemberTotalCnt(SearchVO searchVO) throws Exception {
		return selectOne("MemberSQL.selectMemberTotalCnt", searchVO);
	}
	
	/**
	 * 사용자 조회
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public CommonHashMap<String, Object> selectMemberView(SearchVO searchVO) throws Exception {
		return selectOne("MemberSQL.selectMemberView", searchVO);
	}
	
	/**
	 * 사용자 등록
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int insertMemeber(SearchVO searchVO) throws Exception {
		return insert("MemberSQL.insertMemeber", searchVO);
	}
	
	/**
	 * 사용자 수정
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int updateMemeber(SearchVO searchVO) throws Exception {
		return update("MemberSQL.updateMemeber", searchVO);
	}
	
	/**
	 * 사용자 휴면처리
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int updateMemeberDormant(SearchVO searchVO) throws Exception {
		return update("MemberSQL.updateMemeberDormant", searchVO);
	}
	
	/**
	 * 사용자 탈퇴처리
	 * 
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int updateMemeberLeave(SearchVO searchVO) throws Exception {
		return update("MemberSQL.updateMemeberLeave", searchVO);
	}
}