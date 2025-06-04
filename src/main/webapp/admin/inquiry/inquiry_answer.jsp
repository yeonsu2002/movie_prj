<%@page import="kr.co.yeonflix.inquiry.inquiryDAO"%>
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
		inquiryDAO iDAO = new inquiryDAO();
		String num= request.getParameter("num");
		String answer= request.getParameter("answer_content");
		iDAO.alterinquiry(num, answer);
		response.sendRedirect("http://localhost/movie_prj/admin/inquiry/inquiry_admin_main.jsp");
	%>

<script type="text/javascript">
$(function(){

});//ready
</script>
</body>
</html>