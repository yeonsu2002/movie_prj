<%@page import="kr.co.yeonflix.theater.TheaterDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.theater.TheaterService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />
<%
TheaterService ths = new TheaterService();
List<TheaterDTO> theaterList = ths.searchAllTheater();

pageContext.setAttribute("theaterList", theaterList);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>관리자 대시보드</title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">
<link rel="stylesheet"
	href="http://localhost/movie_prj/admin/theater/theater.css">

</head>
<body>
	<div class="content-container">
		<br>
		<h2>상영관 목록</h2>
		<br>
		<table>
			<thead>
				<tr>
					<th>종류</th>
					<th>이름</th>
					<th>가격</th>
					<th>좌석 수</th>
					<th>비고</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<c:forEach var="list" items="${theaterList}" varStatus="i">
						<tr>
							<td>${list.theaterType}</td>
							<td>${list.theaterName}</td>
							<td>${list.moviePrice}</td>
							<td>140석</td>
							<td></td>
						</tr>
					</c:forEach>
				<tr>
			</tbody>
		</table>
	</div>
</body>
</html>
