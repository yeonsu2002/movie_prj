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
String type=request.getParameter("type");
String input=request.getParameter("input");
%>

<script type="text/javascript">
$(function(){

});//ready
</script>
</body>
</html>