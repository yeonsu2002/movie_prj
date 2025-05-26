<%@page import="java.text.SimpleDateFormat"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String userId= request.getParameter("userId");

	String birth= request.getParameter("birth");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	java.util.Date birthJu = sdf.parse(birth);
  java.sql.Date birthSu = new java.sql.Date(birthJu.getTime());
  
	String email= request.getParameter("email");

	MemberService mService = new MemberService();
	
 	boolean isMember = mService.isMemberVerification(userId, birthSu, email);
	if(isMember){
	  //회원이다. 
	  out.print("haveUserdata");
	} else if(!isMember){
	  //회원이 아니다
	  out.print("noUserdata");
	}
	

%>