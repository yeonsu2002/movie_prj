<%@page import="kr.co.yeonflix.notice.noticeDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="${encoding}">
<title><c:out value="${site_name}"/></title>
</head>
<body>
<%
		noticeDAO nDAO = new noticeDAO();
		String num= request.getParameter("num");
		String content= request.getParameter("content");
		nDAO.alternotice(num, content);
		response.sendRedirect("http://localhost/movie_prj/admin/notice/notice_admin_main.jsp");
	%>



<script type="text/javascript">
$(function(){

});//ready
</script>
</body>
</html>