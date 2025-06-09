<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="kr.co.yeonflix.login.LoginService"%>
<%@page import="kr.co.yeonflix.login.LoginDTO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    boolean flag = false;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String id = request.getParameter("id");
        String pass = request.getParameter("pass");

        // 세션에 저장된 로그인 사용자 정보 가져오기
        MemberDTO sessionUser = (MemberDTO) session.getAttribute("loginUser");

        if (sessionUser != null) {
            String sessionId = sessionUser.getMemberId();  // 세션에서 가져온 ID

            // 로그로 세션에 저장된 ID 값 확인
            System.out.println("세션 ID: " + sessionId);
            System.out.println("입력된 ID: " + id);

            // 세션 ID와 입력된 ID가 일치하는지 확인
            if (sessionId != null && sessionId.trim().equalsIgnoreCase(id.trim())) {
                // 로그인한 유저와 입력한 아이디가 일치할 때만 로그인 허용
                LoginDTO lDTO = new LoginDTO();  // lDTO 객체 선언
                lDTO.setId(id);
                lDTO.setPass(pass);

                LoginService ls = new LoginService();
                flag = ls.loginProcess(lDTO, session);  // 비밀번호 확인 포함

                if (flag) {
                    System.out.println("로그인 성공");
                } else {
                    System.out.println("비밀번호가 잘못되었습니다.");
                }
            } else {
                System.out.println("세션 ID와 입력된 ID가 일치하지 않습니다.");
            }
        } else {
            System.out.println("세션에 로그인 정보가 없습니다.");
        }
    }

    response.setContentType("application/json;charset=UTF-8");
%>
{
  "loginResult": <%= flag %>
}
