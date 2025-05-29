<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<% 
	String veri = (String) session.getAttribute("verificationCode");
	System.out.println("세션 verificationCode 삭제 : " + veri);
	
	session.removeAttribute("verificationCode");	
%>
