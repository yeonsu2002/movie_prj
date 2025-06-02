<%@page import="kr.co.yeonflix.member.NonMemberService"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="kr.co.yeonflix.member.NonMemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//비회원 예매하기 
	//이메일 인증번호 맞는지 확인 후, 예매사이트로 이동.
	
	//이때 비회원 정보를 세션에 올려놔야 예매를 '완료'한 후에 비회원 정보를 테이블에 insert가능
	//테이블 insert완료되고 난 후, 세션에서 삭제해야 함 
	
	String email = request.getParameter("email");
	String birth = request.getParameter("birth");
	String password = request.getParameter("pw");
	
	System.out.println(email + "/" + birth + "/" + password);
	
	NonMemberDTO nmDTO = new NonMemberDTO();
	NonMemberService nmService = new NonMemberService();
	nmDTO = nmService.saveNonMem(birth, email, password); //dao아직 안함
	
	System.out.println("DB에 저장된 nmDTO : " + nmDTO);
	
	session.setAttribute("nonMemberInfo", nmDTO);
	//세션객체 30분 유지, 단 마지막 통신으로부터 30분동안 아무 통신도 없을때를 의미(session.setAttribute()한 모든 내용을)
	session.setMaxInactiveInterval(1800);; 

	NonMemberDTO sessionNMDTO = (NonMemberDTO) session.getAttribute("nonMemberInfo");
	System.out.println("세션에 저장된 sessionNMDTO : " + sessionNMDTO);
	



%>
