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

        if (id != null && pass != null && sessionUser != null) {
            // 로그인한 유저와 입력한 아이디가 일치할 때만 로그인 허용
            if (sessionUser.getMemberId().equals(id)) {
                LoginDTO lDTO = new LoginDTO();
                lDTO.setId(id);
                lDTO.setPass(pass);

                LoginService ls = new LoginService();
                flag = ls.loginProcess(lDTO, session);  // 비밀번호 확인 포함
            } else {
                System.out.println("세션 사용자와 입력된 ID가 일치하지 않음. 접근 거부");
            }
        } else {
            System.out.println("세션 없음 또는 id/pass 누락");
        }
    }

    
    response.setContentType("application/json;charset=UTF-8");
%>
{
  "loginResult": <%= flag %>
}
