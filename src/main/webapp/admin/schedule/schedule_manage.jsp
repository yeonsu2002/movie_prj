<%@page import="kr.co.yeonflix.schedule.ShowScheduleDTO"%>
<%@page import="java.sql.Date"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.theater.TheaterDTO"%>
<%@page import="kr.co.yeonflix.theater.TheaterService"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />

<%
//상단 탭 용 날짜 처리
SimpleDateFormat sdf = new SimpleDateFormat("M/d E");
SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");

Calendar cal = Calendar.getInstance();

String minDate = sdf2.format(cal.getTime());

String[][] tabs = new String[7][2];
for (int i = 0; i < 7; i++) {
	tabs[i][0] = sdf.format(cal.getTime());
	tabs[i][1] = sdf2.format(cal.getTime());

	if (i == 6) {
	} else {
		cal.add(Calendar.DATE, 1);
	}
}

//클릭한 날짜 parameter로 가져오기
Date todayDate = null;
String dateParam = request.getParameter("date");

if (dateParam != null && !dateParam.isEmpty()) {
	todayDate = Date.valueOf(dateParam);
} else {
	todayDate = Date.valueOf(minDate);
}

//선택한 상영관 Parameter로 가져오기
String theaterParam = request.getParameter("theater");
int theaterIdx = 1;
if (theaterParam != null) {
	theaterIdx = Integer.parseInt(theaterParam);
}

//상영관 정보 처리
TheaterService ths = new TheaterService();
List<TheaterDTO> theaterList = ths.searchAllTheater();

//영화 정보 처리
ScheduleService ss = new ScheduleService();
List<MovieDTO> movieList = ss.searchAllMovie();

//스케줄 가져오기
List<ScheduleDTO> scheduleList = ss.searchScheduleWithDateAndTheater(theaterIdx, todayDate);
List<ShowScheduleDTO> showScheduleList = ss.createScheduleDTOs(scheduleList);
showScheduleList.sort((a, b) -> a.getStartClock().compareTo(b.getStartClock()));

pageContext.setAttribute("tabs", tabs);
pageContext.setAttribute("movieList", movieList);
pageContext.setAttribute("minDate", minDate);
pageContext.setAttribute("theaterList", theaterList);
pageContext.setAttribute("showScheduleList", showScheduleList);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>스케줄 관리</title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">
<link rel="stylesheet"
	href="http://localhost/movie_prj/admin/schedule/css/schedule.css" />
<style type="text/css">
</style>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script>
	$(function() {
		$("#theaterSelect").change(function() {
					var selectedTheater = $(this).val();
					var currentDate = new URLSearchParams(location.search)
							.get("date");

					if (!currentDate) {
						currentDate = "${minDate}";
					}

					location.href = "schedule_manage.jsp?date=" + currentDate
							+ "&theater=" + selectedTheater;
		});
		
		$("#reload-btn").click(function(){
			location.href = "schedule_reload.jsp";
		});
		
		$(".coudNotEdit").click(function(){
			alert("상영중이거나 상영종료된 스케줄은 수정 및 삭제할 수 없습니다.")
		});
		
		$(".btn-detail").click(function(){
			$("#reservationParam").submit();
		})
		
	});
</script>
</head>
<body>
	<div class="content-container">
		<h2>상영스케줄 목록</h2>
		<div class="tabs">
			<c:set var="selectedDate"
				value="${param.date != null ? param.date : minDate}" />

			<c:forEach var="tab" items="${tabs}" varStatus="i">
				<a href="schedule_manage.jsp?date=${tab[1]}">
					<div class="tab ${tab[1] == selectedDate ? 'active' : ''}">
						${tab[0]}</div>
				</a>
			</c:forEach>
		</div>
		<br>
		<div class="filter">
			<label>상영관 : </label> <select id="theaterSelect">
				<c:forEach var="thList" items="${theaterList}">
					<option value="${thList.theaterIdx}"
						<c:if test="${param.theater == thList.theaterIdx}">selected</c:if>>
						${thList.theaterName}</option>
				</c:forEach>
			</select>
		</div>
		<br>
		<table>
			<thead>
				<tr>
					<th>영화제목</th>
					<th>시작 시간</th>
					<th>종료 시간</th>
					<th>상태</th>
					<th>예매내역</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${empty showScheduleList}">
					<tr>
						<td colspan="5">등록된 상영 스케줄이 없습니다.</td>
					</tr>
				</c:if>
				<c:forEach var="ssList" items="${showScheduleList}" varStatus="i">
					<tr>
						<c:choose>
						<c:when test="${ssList.scheduleStatus == '상영예정' }">
						<td><a
							href="schedule_edit.jsp?scheduleIdx=${ssList.scheduleIdx}">${ssList.movieName}</a></td>
						</c:when>
						<c:otherwise>
						<td><span class="coudNotEdit">${ssList.movieName}</span></td>
						</c:otherwise>
						</c:choose>
						<td>${ssList.startClock}</td>
						<td>${ssList.endClock}</td>
						<td>${ssList.scheduleStatus}</td>
						<td>
						<form id="reservationParam" action="http://localhost/movie_prj/admin/reservation/reservation_manage.jsp" method="post">
						<button class="btn-detail" name="scheduleParam" value="${ssList.scheduleIdx}">자세히</button>
						</form>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div style="text-align: center;">
			<button type="button" class="reload-btn" id="reload-btn">새로고침</button>
		</div>
	</div>
</body>
</html>
