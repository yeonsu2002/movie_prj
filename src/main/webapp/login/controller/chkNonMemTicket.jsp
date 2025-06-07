<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	const birth = request.getParameter("birth");
	const email = request.getParameter("email");
	const password = request.getParameter("password");
	
	//디버깅
	System.out.println(birth + " / " + email + " / " + password);
	 
	
	
%>