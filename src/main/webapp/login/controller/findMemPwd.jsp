<%@page import="kr.co.yeonflix.util.MailUtil"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@page import="java.util.Random"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%! 
	//랜덤알파벳 뽑기
	public static String getRandomLetters(int count){
	  StringBuilder sb = new StringBuilder();
	  Random random = new Random();
	  for(int i=0; i < count; i++){
	    char c = (char)('a' + random.nextInt(26)); //a~z
	    sb.append(c);
	  }
	  return sb.toString();
	}
%>
<%
	String userId = request.getParameter("userId");
	String birth = request.getParameter("birth");
	String email = request.getParameter("email");
	String verifiedCode = request.getParameter("verifiedCode");
	String action = request.getParameter("action");

	//임시비밀번호 발급하기 
	if("sendTempPwd".equals(action)){
	 	String pwd1 = String.valueOf((int)(Math.random() * 900000 + 100000)); // 6자리 숫자
		String pwd2 = getRandomLetters(5); //무작위 5자리 
		String tempPwd = pwd1 + pwd2;
		
		try {
		    MemberService mService = new MemberService();
		    boolean isChanged = mService.changePwd(email, tempPwd);

			if(isChanged){
				ServletContext context = application;
		        String mailType = "tempPassword";
		        MailUtil.sendEmail(context, email, tempPwd, mailType);

		        // 이메일 마스킹
		        String maskedEmail = "";
		        if(email != null){
		            int atIndex = email.indexOf("@");
		            if(atIndex > 2){
		                String prefix = email.substring(0,2);
		                String stars = "*".repeat(atIndex - 2);
		                String domain = email.substring(atIndex);
		                maskedEmail = prefix + stars + domain;
		            } else {
		                maskedEmail = email;
		            }
		        }
							
		        request.setAttribute("userId", userId);
		        request.setAttribute("email", maskedEmail);
		        RequestDispatcher dispatcher = request.getRequestDispatcher("/login/temporarily.jsp");
		        dispatcher.forward(request, response);
		        return; // forward 후 남은 코드 방지
		    } 

		} catch(Exception e) {
		    e.printStackTrace();
		}
	}
%>
