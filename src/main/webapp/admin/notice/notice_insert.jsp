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
<body>
	<%
		noticeDAO nDAO = new noticeDAO();
		String type= request.getParameter("type");
		String title= request.getParameter("title");
		String content= request.getParameter("content");
	    nDAO.insertNotice(type, title, content);
	    response.sendRedirect("notice_admin_main.jsp");
	%>

<script type="text/javascript">
$(function(){

});//ready
</script>
</body>
</html>