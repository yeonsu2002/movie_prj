<%@page import="kr.co.yeonflix.member.NonMemberService"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="kr.co.yeonflix.member.NonMemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//비회원 예매하기 
	String email = request.getParameter("email");
	String birth = request.getParameter("birth");
	String password = request.getParameter("pw");
	
	/*  
	이거는 최종 결제 process에서 해야지 참..
	NonMemberDTO nmDTO = new NonMemberDTO();
	NonMemberService nmService = new NonMemberService();
	nmDTO = nmService.saveNonMem(birth, email, password); //dao아직 안함
	*/
	
	session.setAttribute("nonMemberInfo", nmDTO);
	//세션객체 30분 유지, 단 마지막 통신으로부터 30분동안 아무 통신도 없을때를 의미(session.setAttribute()한 모든 내용을)
	session.setMaxInactiveInterval(1800);;

	//디버깅용
	NonMemberDTO sessionNMDTO = (NonMemberDTO) session.getAttribute("nonMemberInfo");
	System.out.println("세션에 저장된 sessionNMDTO : " + sessionNMDTO);
	
	response.sendRedirect(request.getContextPath()+ "/reservation/reservation.jsp"); //예매로 이동혀 



%>
