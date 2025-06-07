<%@page import="kr.co.yeonflix.theater.TheaterDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.theater.TheaterService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/common/jsp/admin_header.jsp" />
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
<title>상영관 목록 관리</title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">
<link rel="stylesheet"
	href="http://localhost/movie_prj/admin/theater/theater.css">
<link rel="stylesheet" type="text/css"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@docsearch/css@3">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<style>
</style>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script>
	$(function() {
		// 테이블 행 호버 효과 강화
		$('.theater-table tbody tr').hover(
			function() {
				$(this).css('box-shadow', '0 4px 15px rgba(0,0,0,0.1)');
			},
			function() {
				$(this).css('box-shadow', 'none');
			}
		);
		
		// 숫자 포맷팅 (가격에 콤마 추가)
		$('.movie-price').each(function() {
			var price = $(this).text();
			if (price && !isNaN(price)) {
				$(this).text(Number(price).toLocaleString());
			}
		});
	});
</script>
</head>
<body>
	<div class="content-container">
		<div class="table-card">
			<div class="table-title">등록된 상영관 현황</div>
			<div class="theater-table-container">
				<table class="theater-table">
					<thead>
						<tr>
							<th>🎭 종류</th>
							<th>🏛️ 이름</th>
							<th>💰 가격</th>
							<th>🪑 좌석 수</th>
							<th>📝 비고</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="list" items="${theaterList}" varStatus="i">
							<tr>
								<td><span class="theater-type">${list.theaterType}</span></td>
								<td><span class="theater-name">${list.theaterName}</span></td>
								<td><span class="movie-price">${list.moviePrice}</span></td>
								<td><span class="seat-count">140석</span></td>
								<td><span class="empty-note">-</span></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>