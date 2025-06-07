<%@page import="kr.co.yeonflix.member.NonMemberService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String birth = request.getParameter("birth");
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	
	//디버깅
	System.out.println(birth + " / " + email + " / " + password);
	 
	//이메일과 생일로 좌석 가져오기
	NonMemberService nmService = new NonMemberService();
	
	try (birth != null && email != null && password != null){
	  
	  
	} catch (Exception e){
	  e.printStackTrace();
	  return;
	}
	
	
%>