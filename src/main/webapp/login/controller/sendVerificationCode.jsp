<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@page import="kr.co.yeonflix.util.MailUtil"%>
<%@page import="kr.co.yeonflix.member.VerificationService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String email = request.getParameter("email");
	String action = request.getParameter("action");
	
	//인증번호 6자리생성
 	String verificationCode = String.valueOf((int)(Math.random() * 900000 + 100000)); // 6자리 숫자
 	
	//요청이 비밀번호 찾기의 인증(findMemberPwdFrm.jsp)
	if("findPwd".equals(action)){
	 	VerificationService vService = new VerificationService();
	 	Boolean isSuccess = vService.makeVirifiCode(email, verificationCode);
	 	if(isSuccess){
	 	  
	 	  //인증번호생성 성공 -> 이메일 전송
	 	  ServletContext context = application; 
	 	  session.setAttribute("verificationCode", verificationCode);
			try {
			  	String mailType = "authCode";
			    MailUtil.sendEmail(context ,email, verificationCode, mailType);
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
	  	String mailType = "authCode";
			MailUtil.sendEmail(context, email, verificationCode, mailType);
			session.setAttribute("verificationCode", verificationCode); //세션에 인증번호 저장 
			
			out.print("success");
		} catch( Exception e){
			e.printStackTrace();
		}
		
	} else {
	 	  out.print("fail");
 	}
	

	

 	
 	
 	
%>