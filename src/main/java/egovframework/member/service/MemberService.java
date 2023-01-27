package egovframework.member.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.common.login.vo.LoginUserVO;
import egovframework.common.util.StringUtil;
import egovframework.common.vo.CommonHashMap;
import egovframework.common.vo.SearchVO;
import egovframework.member.dao.MemberDAO;
import egovframework.member.vo.MemberVO;

/**
 * @author 이승준
 * 
 * 회원 관련 Service
 */
@Service
public class MemberService {
	/** MemberDAO */
	@Autowired
	private MemberDAO memberDAO;
	
	/**
	 * 회원 정보 가져오기
	 * 
	 * @param memberVO
	 * @return
	 * @throws Exception
	 */
	public LoginUserVO selectMemberInfo(MemberVO memberVO) throws Exception {
		return memberDAO.selectMemberInfo(memberVO);
    }
	
	/**
	 * 로그인 일자 업데이트
	 * 
	 * @param memberVO
	 * @throws Exception
	 */
	@Transactional
	public void updateLoginDt(MemberVO memberVO) throws Exception {
		memberDAO.updateLoginDt(memberVO);
    }
	
	public List<CommonHashMap<String, Object>> selectMemberList(SearchVO searchVO) throws Exception {
		return memberDAO.selectMemberList(searchVO);
	}
	
	public int selectMemberTotalCnt(SearchVO searchVO) throws Exception {
		return memberDAO.selectMemberTotalCnt(searchVO);
	}
	
	public CommonHashMap<String, Object> selectMemberView(SearchVO searchVO) throws Exception {
		return memberDAO.selectMemberView(searchVO);
	}
	
	// default = REQUIRED
	@Transactional
    public void insertMemeber(MemberVO memberVO) throws Exception {
		String pwd = StringUtil.sha256Encode(memberVO.getPwd());
		memberVO.setPwd(pwd);
		
		memberDAO.insertMemeber(memberVO);
    }
	
	@Transactional
	public void updateMemeber(MemberVO memberVO) throws Exception {
		if (!StringUtil.isEmpty(memberVO.getPwd())) {
			String pwd = StringUtil.sha256Encode(memberVO.getPwd());
			memberVO.setPwd(pwd);
		}
		
		memberDAO.updateMemeber(memberVO);
    }
	
	@Transactional
	public void updateMemeberDormant(MemberVO memberVO) throws Exception {
		memberDAO.updateMemeberDormant(memberVO);
    }
	
	@Transactional
	public void updateMemeberLeave(MemberVO memberVO) throws Exception {
		memberDAO.updateMemeberLeave(memberVO);
    }
}