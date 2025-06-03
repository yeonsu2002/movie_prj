<%@page import="java.util.Enumeration"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String memberId = request.getParameter("memberId");
	String memberPwd = request.getParameter("memberPwd");
	
	MemberService memService = new MemberService();
	MemberDTO loginUser = memService.loginMember(memberId, memberPwd);
	
	System.out.println("loginUser = " + loginUser);
	
	if(loginUser != null && "N".equals(loginUser.getIsActive())){
		
		try {
			response.setContentType("text/plain;charset=UTF-8");
			out.print("isDeleted");
		} catch (Exception e) {
	    e.printStackTrace();
	    System.out.println("Forward 실패: " + e.getMessage());
		}
		return;
	}
	
	if(loginUser != null && loginUser.getUserIdx() > 0){
	  //보안상 초기화 
	  session.invalidate(); // 기존 세션 제거
	  session = request.getSession(true); // 새로운 세션 생성
	  //로그인계정 세션 설정
		session.setAttribute("loginUser", loginUser);
	  session.setMaxInactiveInterval(1800); //30분만 주자 
	  
		response.setContentType("text/plain;charset=UTF-8");
		out.print("success");
	} else {
	  response.setContentType("text/plain;charset=UTF-8");
		out.print("fail");
	}

%>
