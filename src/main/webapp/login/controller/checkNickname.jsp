<%@page import="org.json.simple.JSONObject"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String nickname = request.getParameter("nickname");
	MemberService mService;
	
	boolean isDuplicate = true; //기본값: 중복이다 
	
	if(nickname != null && !nickname.trim().equals("")){
	  mService = new MemberService();
	  try{
	    isDuplicate = mService.checkNickNameDuplicate(nickname); //아이디가 중복된다.
	  }	catch (Exception e){
      e.printStackTrace();
      isDuplicate = true; // 오류 발생 시 중복으로 간주
  	}
	}
	
	JSONObject result = new JSONObject();
	result.put("available", !isDuplicate); //이미존재 -> false, 사용가능->true 

	out.print(result.toString());
	
%>