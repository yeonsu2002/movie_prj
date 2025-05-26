<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
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
SimpleDateFormat sdf2 = new SimpleDateFormat("HH:mm");

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

//수정될 상영스케줄 정보 처리
int scheduleIdx = Integer.parseInt(request.getParameter("scheduleIdx"));
ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);
String startTime = sdf2.format(schDTO.getStartTime());

//바인딩
pageContext.setAttribute("theaterList", theaterList);
pageContext.setAttribute("movieList", movieList);
pageContext.setAttribute("minDate", minDate);
pageContext.setAttribute("maxDate", maxDate);
pageContext.setAttribute("schDTO", schDTO);
pageContext.setAttribute("startTime", startTime);
pageContext.setAttribute("scheduleIdx", scheduleIdx);
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
		$("#edit-btn").click(function() {
			$("#schedule-form").submit();
		});
		
		$("#delete-btn").click(function(){
			if (confirm("정말 삭제하시겠습니까?")) {
		        var idx = $("#scheduleIdx").val();
		        location.href = "schedule_remove_process.jsp?scheduleIdx=" + idx;
		    }
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
					<form action="schedule_modify_process.jsp" id="schedule-form"
						name="schedule-form" method="post">
						<input type="hidden" id="scheduleIdx" name="scheduleIdx" value="${scheduleIdx}">
						<div class="form-group">
							<label for="title">제목</label> <select id="title" name="movieIdx">
								<option value="" selected disabled>영화 선택</option>
								<c:forEach var="mList" items="${movieList}" varStatus="i">
									<option value="${mList.movieIdx}"
										<c:if test="${mList.movieIdx == schDTO.movieIdx}">selected</c:if>>
										${mList.movieName}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group">
							<label for="theater">상영관</label> <select id="theater"
								name="theaterIdx">
								<option value="" selected disabled>상영관 선택</option>
								<c:forEach var="thList" items="${theaterList}" varStatus="i">
									<option value="${thList.theaterIdx}"
										<c:if test="${thList.theaterIdx == schDTO.theaterIdx}">selected</c:if>>
										${thList.theaterName}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group">
							<label for="date">날짜</label> <input type="date" id="date"
								min="${minDate}" max="${maxDate}" name="screenDate"
								value="${schDTO.screenDate}">
						</div>
						<div class="form-group">
							<label for="time">시작 시간</label> <input type="time" id="time"
								name="startTime" value="${startTime}">
						</div>
						<div style="text-align: center;">
							<button type="button" class="edit-btn" id="edit-btn">수정</button>
							<button type="button" class="delete-btn" id="delete-btn">삭제</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
