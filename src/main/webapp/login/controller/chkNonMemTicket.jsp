<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String birth = request.getParameter("birth");
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	
	//디버깅
	System.out.println(birth + " / " + email + " / " + password);
	 
	
	
%>