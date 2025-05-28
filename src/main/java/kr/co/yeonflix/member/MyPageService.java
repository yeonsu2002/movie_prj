package kr.co.yeonflix.member;

import java.sql.SQLException;
import javax.servlet.http.HttpSession;

import at.favre.lib.crypto.bcrypt.BCrypt;
import kr.co.sist.cipher.DataDecryption;

public class MyPageService {

	public boolean modifyMember(MemberDTO memberDTO, HttpSession session) {
	    boolean flag = false;
	    MyPageDAO mpDAO = MyPageDAO.getInstance();

	    try {
	        if (session == null || session.getAttribute("userData") == null) {
	            return false;
	        }

	        MemberDTO userData = (MemberDTO) session.getAttribute("userData");

	        memberDTO.setMemberId(userData.getMemberId());

	        MemberDTO existingMember = mpDAO.selectOne(memberDTO.getMemberId());

	        if (memberDTO.getMemberPwd() == null || memberDTO.getMemberPwd().isEmpty()) {
	            memberDTO.setMemberPwd(existingMember.getMemberPwd());
	        } else {
	            // 새 비밀번호가 있으면 암호화
	            String hashedPwd = BCrypt.withDefaults().hashToString(12, memberDTO.getMemberPwd().toCharArray());
	            memberDTO.setMemberPwd(hashedPwd);
	        }

	        if (memberDTO.getNickName() == null || memberDTO.getNickName().isEmpty()) {
	            memberDTO.setNickName(existingMember.getNickName());
	        }
	        if (memberDTO.getTel() == null || memberDTO.getTel().isEmpty()) {
	            memberDTO.setTel(existingMember.getTel());
	        }
	        if (memberDTO.getEmail() == null || memberDTO.getEmail().isEmpty()) {
	            memberDTO.setEmail(existingMember.getEmail());
	        }
	        if (memberDTO.getIsSmsAgreed() == null) {
	            memberDTO.setIsSmsAgreed(existingMember.getIsSmsAgreed());
	        }
	        if (memberDTO.getIsEmailAgreed() == null) {
	            memberDTO.setIsEmailAgreed(existingMember.getIsEmailAgreed());
	        }
	        if (memberDTO.getPicture() == null || memberDTO.getPicture().isEmpty()) {
	            memberDTO.setPicture("default_img.png");
	        }

	        int updateCount = mpDAO.updateMember(memberDTO);
	        flag = updateCount > 0;

	        if (flag) {
	            // 갱신된 DB 상태로 세션 업데이트
	            MemberDTO updatedMember = mpDAO.selectOne(memberDTO.getMemberId());
	            session.setAttribute("userData", updatedMember);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return flag;
	}




    // 회원정보 조회 메서드 (필요시)
    public MemberDTO searchMember(String memberId) {
        MemberDTO dto = null;
        MyPageDAO dao = MyPageDAO.getInstance();
        try {
            dto = dao.selectOne(memberId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dto;
    }
}
