<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@page import="kr.co.yeonflix.util.MailUtil"%>
<%@page import="kr.co.yeonflix.member.VerificationService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String email = request.getParameter("email");
	String action = request.getParameter("action");
	
	/* 공통 작업 처리 */
	//인증번호 6자리생성
 	String verificationCode = String.valueOf((int)(Math.random() * 900000 + 100000)); // 6자리 숫자
	System.out.println("인증번호 6자리 : " + verificationCode);
 	
	//요청이 비밀번호 찾기의 인증(findMemberPwdFrm.jsp)
	if("findPwd".equals(action)){
	 	//DB: 인증번호 테이블 데이터 생성
	 	VerificationService vService = new VerificationService();
	 	Boolean isSuccess = vService.makeVirifiCode(email, verificationCode);
	 	if(isSuccess){
	 	  
	 	  //인증번호생성 성공 -> 이메일 전송
	 	  ServletContext context = application; 
	 	  session.setAttribute("verificationCode", verificationCode);
			System.out.println("비번찾기 세션 인증번호 : " + session.getAttribute("verificationCode"));
			try {
			    MailUtil.sendEmail(context ,email, verificationCode);
			 	  out.print("success");
			} catch (Exception e) {
			    e.printStackTrace();
			}
	 	  
	 	} else {
	 	  out.print("fail");
	 	}
		
	};
		
	//요청이 회원가입 때의 인증 
	if("join".equals(action)){
		ServletContext context = application;
		try {
			MailUtil.sendEmail(context, email, verificationCode);
			session.setAttribute("verificationCode", verificationCode); //세션에 인증번호 저장 
			System.out.println("회원가입 세션 인증번호 : " + session.getAttribute("verificationCode"));
			
			//long expirationTime = System.currentTimeMillis() + ( 1000 * 60 * 5); //5분의 만료시간 
			//session.setAttribute("expirationTime", expirationTime); //세션에 인증번호 만료시간 저장 
			
			//System.out.println("세션 만료시각 : " + session.getAttribute("expirationTime"));
			out.print("success");
		} catch( Exception e){
			e.printStackTrace();
		}
		
	} else {
	 	  out.print("fail");
 	}
	

 	
 	
 	
%>