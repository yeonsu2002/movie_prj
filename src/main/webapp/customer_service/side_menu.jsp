<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="${encoding}">
<title><c:out value="${site_name}"/></title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/customer_service/side_menu.css">
</head>
<body>
<!-- 왼쪽 고정 메뉴 -->
		<div class="side-menu">
			<table id="table1">
				<tr>
					<td><a
						href="http://localhost/movie_prj/customer_service/customer_service_center.jsp">고객센터
							메인</a></td>
				</tr>
				<tr>
					<td><a href="http://localhost/movie_prj/notice/notice_user_main.jsp">공지/뉴스</a></td>
				</tr>
				<tr>
					<td><a href="http://localhost/movie_prj/inquiry/inquiry_user_main.jsp">1:1문의</a></td>
				</tr>
			</table>
		</div>

</body>
</html>