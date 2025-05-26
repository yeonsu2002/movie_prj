package kr.co.yeonflix.login;

import java.sql.SQLException;
import javax.servlet.http.HttpSession;

import at.favre.lib.crypto.bcrypt.BCrypt;
import kr.co.yeonflix.member.MemberDTO;

public class LoginService {

    public boolean loginProcess(LoginDTO lDTO, HttpSession session) {
        boolean flag = false;

        LoginDAO lDAO = LoginDAO.getInstance();

        try {
            MemberDTO mDTO = lDAO.selectLogin(lDTO);
            flag = mDTO != null;

            if (flag) {
                session.setAttribute("userData", mDTO);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return flag;
    }

    
    
	/*
	 * // 회원 정보 id로 조회 메서드 추가 public MemberDTO getMemberById(String id) { MemberDTO
	 * member = null; LoginDAO lDAO = LoginDAO.getInstance(); try { member =
	 * lDAO.selectMemberById(id); } catch (SQLException e) { e.printStackTrace(); }
	 * return member; }
	 */
}
