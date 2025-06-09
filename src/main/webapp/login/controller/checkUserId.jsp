<%@page import="org.json.simple.JSONObject"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String userId = request.getParameter("userId");
	MemberService mService;
	
	boolean isDuplicate = false; //중복아님이 기본값임 
	
	if(userId != null && !userId.trim().equals("")){
	  mService = new MemberService();
	  try{
	    isDuplicate = mService.checkUserIdDuplicate(userId); //아이디가 중복된다.
	  }	catch (Exception e){
      e.printStackTrace();
      isDuplicate = true; // 오류 발생 시 중복으로 간주
  	}
	}
	
	JSONObject result = new JSONObject();
	result.put("available", !isDuplicate); // available = true면 사용 가능

	out.print(result.toString());
	
%>