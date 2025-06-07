package kr.co.yeonflix.login;

import java.sql.SQLException;
import javax.servlet.http.HttpSession;

import kr.co.yeonflix.member.MemberDTO;

public class LoginService {

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
