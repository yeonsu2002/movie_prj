<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="kr.co.yeonflix.theater.TheaterDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.theater.TheaterService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />
<%
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
Calendar cal = Calendar.getInstance();

String minDate = sdf.format(cal.getTime());
cal.add(Calendar.DATE, 6);
String maxDate = sdf.format(cal.getTime());

//상영관 정보 처리
TheaterService ths = new TheaterService();
List<TheaterDTO> theaterList = ths.searchAllTheater();

//영화 정보 처리
ScheduleService ss = new ScheduleService();
List<MovieDTO> movieList = ss.searchAllMovie();

pageContext.setAttribute("theaterList", theaterList);
pageContext.setAttribute("movieList", movieList);
pageContext.setAttribute("minDate", minDate);
pageContext.setAttribute("maxDate", maxDate);
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
	href="http://localhost/movie_prj/admin/schedule/css/schedule_register.css">
<style type="text/css">
</style>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script>
	$(function() {
		$("#submit-btn").click(function() {
			if ($("#movieIdx").val() == null) {
				alert('영화를 선택하세요');
				return;
			}

			if ($("#theaterIdx").val() == null) {
				alert('상영관을 선택하세요');
				return;
			}

			if ($("#screenDate").val() == "") {
				alert('날짜를 선택하세요');
				return;
			}

			if ($("#startTime").val() == "") {
				alert('시작 시간을 선택하세요');
				return;
			}

			$("#schedule-form").submit();
		});
	});
</script>
</head>
<body>
	<div class="content-container">
		<!-- 상영 등록 모달창 -->
		<div id="modal" class="modal">
			<div class="modal-content">
				<h2>상영 스케줄 등록</h2>
				<div class="register-container">
					<form action="schedule_add_process.jsp" id="schedule-form"
						name="schedule-form" method="post">
						<div class="form-group">
							<label for="title">제목</label> <select name="movieIdx"
								id="movieIdx">
								<option value="" selected disabled>영화 선택</option>
								<c:forEach var="mList" items="${movieList}" varStatus="i">
									<option value="${mList.movieIdx}">${mList.movieName}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group">
							<label for="theater">상영관</label> <select name="theaterIdx"
								id="theaterIdx">
								<option value="" selected disabled>상영관 선택</option>
								<c:forEach var="thList" items="${theaterList}" varStatus="i">
									<option value="${thList.theaterIdx}">${thList.theaterName}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group">
							<label for="date">날짜</label> <input type="date" id="screenDate"
								min="${minDate}" max="${maxDate}" name="screenDate">
						</div>
						<div class="form-group">

							<label for="time">시작 시간</label> <input type="time" id="startTime"
								name="startTime">
						</div>
						<div style="text-align: center;">
							<button type="button" class="edit-btn" id="submit-btn">등록</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
