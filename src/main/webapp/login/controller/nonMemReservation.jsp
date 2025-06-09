<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
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
	
	NonMemberDTO nmDTO = new NonMemberDTO();
  NonMemberService nmService = new NonMemberService();
  
	try{
	  boolean success = nmService.saveNonMem(birth, email, password);
	  if(!success){
	    System.out.println("비회원 생성 실패");
	    return;
	  } else if (success){
	    
	    try{
		    nmDTO = nmService.getNonMem(birth, email); //권한정보 없음
		    nmDTO.setUserType("GUEST"); //비회원 권한으로 딱히 접근제한 할만한 페이지는 아직 없는데.. 
	      if(nmDTO.getUserIdx() > 0){
					//일단 세션 깨긋하게 비우고
					session.removeAttribute("guestUser");
					session.invalidate();
					// 세션 새로 꺼내
					session = request.getSession(true); 
					//새 세션에 비회원 정보 저장 
					session.setAttribute("guestUser", nmDTO);
					//세션객체 30분 유지, 단 마지막 통신으로부터 30분동안 아무 통신도 없을때를 의미(session.setAttribute()한 모든 내용을)
					session.setMaxInactiveInterval(1800);;
	      }
	    } catch (Exception e){
	      e.printStackTrace();
	    }
	  }
	  
	} catch (Exception e){
	  e.printStackTrace();
	}
	  
	//디버깅용
	NonMemberDTO sessionNMDTO = (NonMemberDTO) session.getAttribute("guestUser");
	
	response.sendRedirect(request.getContextPath()+ "/reservation/reservation.jsp"); //예매로 이동혀 



%>
