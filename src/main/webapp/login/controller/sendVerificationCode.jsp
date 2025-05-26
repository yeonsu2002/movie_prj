<%@page import="kr.co.yeonflix.util.MailUtil"%>
<%@page import="kr.co.yeonflix.member.VerificationService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String email = request.getParameter("email");
	
	//인증번호 6자리생성
 	String verificationCode = String.valueOf((int)(Math.random() * 900000 + 100000)); // 6자리 숫자
	System.out.println("인증번호 6자리 : " + verificationCode);

 	//DB: 인증번호 테이블 데이터 생성
 	VerificationService vService = new VerificationService();
 	Boolean isSuccess = vService.makeVirifiCode(email, verificationCode);
 	if(isSuccess){
 	  out.print("make_success");
 	  
 	  //인증번호생성 성공 -> 이메일 전송
 	  ServletContext context = application; 
		try {
		    MailUtil.sendEmail(context ,email, verificationCode);
		} catch (Exception e) {
		    e.printStackTrace();
		}
	 	  
 	  
 	} else {
 	  out.print("make_false");
 	}
 	
 	
 	
%>