<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="java.sql.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@page import="java.util.Random"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  
<%
  String name = request.getParameter("name");
  String email = request.getParameter("email");
  String birthStr = request.getParameter("birth");
  
  SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd"); // yyyyMMdd형식의 문자열을 java.util.Date형식의 객체로 바꿔줌
  java.util.Date birthJu = sdf.parse(birthStr); 
  java.sql.Date birthSu = new java.sql.Date(birthJu.getTime());
  
  //이름, 이메일, 생일 모두 일치하는 회원 조회
  MemberService mService = new MemberService();
  String memberId = mService.isMember(name, birthSu, email);
  
  //이메일중복확인
  boolean isEmailDupl = mService.checkEmailDuplicate(email);
  
  //탈퇴여부 확인(null인경우엔? )
  String isActive = "Y";
  try {
	  MemberDTO memberDTO = mService.getOneMember(email);
	  if(memberDTO != null){
	    isActive = memberDTO.getIsActive();
	  }
  } catch (Exception e){
    e.printStackTrace();
  } 
  
  if(memberId != null && !memberId.isBlank()){ //가입정보가 이미 존재함 
    request.setAttribute("name", name);
    request.setAttribute("userId", memberId);
    
    RequestDispatcher dispatcher = request.getRequestDispatcher("/login/alreadyMember.jsp");
    dispatcher.forward(request, response);
  } else if (isEmailDupl) {
%>    
  <script type="text/javascript">
      alert("이미 가입된 이메일입니다.");
      location.href = "<%= request.getContextPath() %>/login/isMemberChk.jsp";
  </script>
<%
  } else if ("N".equals(isActive)){
%>    
   <script type="text/javascript">
       alert("이미 탈퇴한 이메일입니다. 관련문의는 고객센터로 문의해 주세요.");
       location.href = "<%= request.getContextPath() %>/login/isMemberChk.jsp";
   </script>
<%  	
  } else { //가입된 정보 없음 
    
  	//넘기기 = 세션 or request객체
  	//1.세션에 
  	session.setAttribute("email", email);
  	
  	//2.request객체에 
  	request.setAttribute("email", email);
  	request.setAttribute("alert", "'가입 정보가 존재하지 않습니다.'");
  	
  	RequestDispatcher dispatcher = request.getRequestDispatcher("/login/join1verification.jsp");
  	dispatcher.forward(request, response);
  }
%>


<%-- 
%>
	<script>
	  alert("가입 정보가 존재하지 않습니다.");
	  location.href = "<%= request.getContextPath() %>/login/join1verification.jsp?email=<%=email %>"; //이건 사용자가 url수정으로 변경이 되버려 
  </script>
<% 
--%>