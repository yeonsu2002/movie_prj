<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<% 

	if(session.getAttribute("loginAdmin") != null){
		session.removeAttribute("loginAdmin");
		session.invalidate();
	}

	String contextPath = request.getContextPath();
	response.sendRedirect(contextPath + "/admin/login/adminLoginForm.jsp");
%>