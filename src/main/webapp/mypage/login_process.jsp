<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="kr.co.yeonflix.login.LoginService"%>
<%@page import="kr.co.yeonflix.login.LoginDTO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    boolean flag = false;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String id = request.getParameter("id");
        String pass = request.getParameter("pass");

        if (id != null && pass != null) {
            LoginDTO lDTO = new LoginDTO();
            lDTO.setId(id);
            lDTO.setPass(pass);
 
            LoginService ls = new LoginService();
            flag = ls.loginProcess(lDTO, session);

           
        }
    }

    response.setContentType("application/json;charset=UTF-8");
%>
{
  "loginResult": <%= flag %>
}
