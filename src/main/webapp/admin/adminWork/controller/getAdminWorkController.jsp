<%@page import="kr.co.yeonflix.admin.AdminService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.admin.AdminDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
 
	try {
		AdminService adService = new AdminService();
		List<AdminDTO> managerList = adService.getManagerList();
		request.setAttribute("managerList", managerList);
		request.getRequestDispatcher("/admin/adminWork/adminWork.jsp").forward(request, response);
	} catch (Exception e){
	  e.printStackTrace();
	  request.setAttribute("errorMsg", "관리자 목록을 불러오는 중 오류가 발생했습니다.");
	  request.getRequestDispatcher("/admin/adminWork/adminWork.jsp").forward(request, response);
	}
	/* getContextPath()는 RequestDispatcher.forward()에서는 쓰지 않는 게 일반적입니다. (절대 경로로 지정하면 됨)  */
%>