<%@page import="kr.co.yeonflix.notice.noticeDTO"%>
<%@page import="java.util.List"%>
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
    String keyword = request.getParameter("keyword");
    noticeDAO dao = new noticeDAO();
    List<noticeDTO> notices = null;

    if (keyword != null && !keyword.trim().isEmpty()) {
        notices = dao.searchNotice(keyword);
    } else {
        notices = dao.selectAllNotice(); // 기존 전체 목록
    }

    request.setAttribute("notices", notices);
%>


<script type="text/javascript">
$(function(){

});//ready
</script>
</body>
</html>