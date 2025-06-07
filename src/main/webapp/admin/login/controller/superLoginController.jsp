<%@page import="kr.co.yeonflix.admin.AdminService"%>
<%@page import="kr.co.yeonflix.admin.AdminDTO"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<% 
	String password = request.getParameter("password");
	
if("superpwd".equals(password)){
	
	AdminDTO adminDTO = new AdminDTO();
	
	AdminService adService = new AdminService();
	String adminId = "superadmin";
	
	adminDTO = adService.adminLogin(adminId, password);
	
	//세션에 저장
	session.invalidate();
	session = request.getSession(true); //새거 
	session.setAttribute("loginAdmin", adminDTO);
	session.setMaxInactiveInterval(1800);
	
	out.print("success");
} else {
	out.print("fail");
}

%>