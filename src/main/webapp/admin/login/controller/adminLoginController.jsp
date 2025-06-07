<%@page import="kr.co.yeonflix.admin.AdminDTO"%>
<%@page import="kr.co.yeonflix.admin.AdminService"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
    pageEncoding="UTF-8"
    info="관리자 로그인 프로세스"%>
<% 
	String adminId = request.getParameter("adminId");
	String adminPwd = request.getParameter("adminPwd");

	AdminService adService = new AdminService();
	
	AdminDTO loginAdmin = adService.adminLogin(adminId, adminPwd);
	
	//디버깅	
	System.out.println("loginAdmin 정보 : " + loginAdmin);

	//관리자계정 조회는 되지만, 비활동 계정인 경우 
	if(loginAdmin != null && "N".equals(loginAdmin.getIsActive())){
		out.print("isDeleted");
		return;
	}
	
	//정상적인 관리자 계정일 때 
	if(loginAdmin != null && loginAdmin.getUserIdx() > 0){
		//세션 초기화
		session.invalidate();
		//새 세션 받아, 위에서 초기화 했잔하 
		session = request.getSession(true);
		//세션에 관리자 계정 저장
		session.setAttribute("loginAdmin", loginAdmin);
		//세션객체 무응답 대기시간 30분 제한
		session.setMaxInactiveInterval(1800);
		out.print("success");
	} else {
		out.print("fail"); //관리자 로그인 실패 
	}
	

%>