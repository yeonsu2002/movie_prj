package kr.co.yeonflix.login;

import java.sql.SQLException;
import javax.servlet.http.HttpSession;

import kr.co.yeonflix.member.MemberDTO;

public class LoginService {

	 /**
     * 로그인 처리를 수행하는 메서드
     * 
     * 사용자가 입력한 로그인 정보(LoginDTO)를 기반으로 데이터베이스에서 회원 정보를 조회하고,  
     * 일치하는 회원이 존재하면 로그인 성공 처리 후 세션에 사용자 정보를 저장한다.
     * 
     * @param lDTO 사용자가 입력한 아이디/비밀번호 등의 로그인 정보
     * @param session HttpSession 객체, 로그인 성공 시 사용자 정보를 세션에 저장하기 위해 사용
     * @return 로그인 성공 여부 (true: 성공, false: 실패)
     */
    public boolean loginProcess(LoginDTO lDTO, HttpSession session) {
        boolean flag = false;

        LoginDAO lDAO = LoginDAO.getInstance();

        try {
            MemberDTO mDTO = lDAO.selectLogin(lDTO);
            flag = mDTO != null;

            if (flag) {
                session.setAttribute("loginUser", mDTO);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return flag;
    }


}
