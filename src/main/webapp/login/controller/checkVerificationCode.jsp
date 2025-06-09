<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<% 
response.setContentType("application/json");

String code = request.getParameter("code");
String sessionCode = (String)session.getAttribute("verificationCode");

boolean isMatch = code != null && code.equals(sessionCode);
String result = isMatch ? "success" : "fail";

out.print("{\"result\":\"" + result + "\"}");

%>
