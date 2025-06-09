<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.SQLException"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.Catch"%>
<%@page import="kr.co.yeonflix.admin.AdminService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<% 
	response.setContentType("application/json; charset=UTF-8");

	String managerId = request.getParameter("managerId");
	
	AdminService adService = new AdminService();
	
	boolean result = false;
	
	try {
		result = adService.deleteAdmin(managerId);
	} catch (SQLException e){
		e.printStackTrace();
	}
	
	String status = result ? "success" : "fail"; 
	
	// 방법 1: 직접 JSON 문자열 출력
	// out.print("{\"result\":\"" + status + "\"}");

	// 방법 2: org.json 라이브러리 사용
	JSONObject jsonObj = new JSONObject();
	jsonObj.put("result", status);
	out.print(jsonObj.toString());
	
	
%>