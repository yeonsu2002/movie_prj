<%@page import="java.util.Enumeration"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String memberId = request.getParameter("memberId");
	String memberPwd = request.getParameter("memberPwd");
	
	MemberService memService = new MemberService();
	MemberDTO loginUser = memService.loginMember(memberId, memberPwd);
	
	//디버깅 
	//System.out.println("loginUser의 정보 = " + loginUser);
	
	//회원정보는 조회되지만, 탈퇴한 회원인 경우 
	if(loginUser != null && "N".equals(loginUser.getIsActive())){
		try {
			out.print("isDeleted");
		} catch (Exception e) {
	    e.printStackTrace();
		}
		return;
	}
	
	if(loginUser != null && loginUser.getUserIdx() > 0){
	  //보안상 초기화 
	  session.invalidate(); // 기존 세션 제거
	  session = request.getSession(true); // 새로운 세션 생성
	  
	  //로그인계정 세션 설정
		session.setAttribute("loginUser", loginUser);
		session.setAttribute("userId", loginUser.getUserIdx()); 

	  session.setMaxInactiveInterval(1800); //30분만 주자 
	  
	  if("Y".equals(loginUser.getHasTempPwd())){ //임시비밀번호 발급 유저(정보수정 전)는 다른 값을 
		  out.print("success-butHasTempPwd");
		  return;
	  }
		out.print("success");
	} else {
		out.print("fail");
	}

%>
