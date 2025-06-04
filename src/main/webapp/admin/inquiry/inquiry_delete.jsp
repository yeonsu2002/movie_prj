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
    String[] deleteIds = request.getParameterValues("choose");

    if (deleteIds != null) {
        inquiryDAO dao = new inquiryDAO();
        for (String idx : deleteIds) {
            dao.deleteinquiry(idx);
        }
    }

    // 삭제 후 목록 페이지로 이동
    response.sendRedirect("inquiry_admin_main.jsp");
%>

<script type="text/javascript">
$(function(){

});//ready
</script>
</body>
</html>