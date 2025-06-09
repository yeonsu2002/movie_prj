<%@page import="java.sql.Timestamp"%>
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
<jsp:include page="/common/jsp/admin_header.jsp" />

<%
//새로고침시 상영상태 변경
ScheduleService ss = new ScheduleService();
List<ScheduleDTO> list = ss.searchAllSchedule();
Timestamp nowTime = new Timestamp(System.currentTimeMillis());

for (ScheduleDTO sDTO : list) {
	int status = sDTO.getScheduleStatus();
	Timestamp startTime = sDTO.getStartTime();
	Timestamp endTime = sDTO.getEndTime();

	if (nowTime.after(startTime) && nowTime.before(endTime)) {
		status = 1;
	} else if (nowTime.after(endTime)) {
		status = 2;
	} else {
		status = 0;
	}

	sDTO.setScheduleStatus(status);
	ss.modifySchedule(sDTO);
}

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
			// 서버에서 설정한 현재 날짜 사용
			var currentDate = "${param.date != null ? param.date : minDate}";
			
			// hidden input 값 설정
			$("#theaterForm input[name='date']").val(currentDate);
			$("#theaterForm input[name='theater']").val(selectedTheater);
			
			// form 제출
			$("#theaterForm").submit();
		});
		
		$(".coudNotEdit").click(function(){
			alert("상영중이거나 상영종료된 스케줄은 수정 및 삭제할 수 없습니다.")
		});
		
		$(".btn-detail").click(function(){
			$("#reservationParam").submit();
		})
		
		$(".tab").click(function(){
			$(this).closest("form").submit();
		});
		
	});
</script>
</head>
<body>
	<div class="content-container">
		<h2 class="page-title">🎬 상영스케줄 관리</h2>
		
		<!-- 날짜 탭 섹션 -->
		<div class="tabs">
			<c:set var="selectedDate"
				value="${param.date != null ? param.date : minDate}" />

			<c:forEach var="tab" items="${tabs}" varStatus="i">
				<form method="post" action="" name="scheduleForm">
					<div class="tab ${tab[1] == selectedDate ? 'active' : ''}">
						📅 ${tab[0]}</div>
					<input type="hidden" name="date" value="${tab[1]}"/>
				</form>
			</c:forEach>
		</div>
		
		<!-- 필터 섹션 -->
		<div class="filter-section">
			<label>🎭 상영관 선택:</label> 
			<form id="theaterForm" method="post" action="" style="display: inline;">
				<input type="hidden" name="date" value="" />
				<input type="hidden" name="theater" value="" />
			</form>
			<select id="theaterSelect">
				<c:forEach var="thList" items="${theaterList}">
					<option value="${thList.theaterIdx}"
						<c:if test="${param.theater == thList.theaterIdx}">selected</c:if>>
						${thList.theaterName}</option>
				</c:forEach>
			</select>
		</div>
		
		<!-- 스케줄 테이블 -->
		<div class="table-container">
			<table>
				<thead>
					<tr>
						<th>🎥 영화제목</th>
						<th>⏰ 시작 시간</th>
						<th>⏳ 종료 시간</th>
						<th>📊 상태</th>
						<th>🎫 예매내역</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty showScheduleList}">
						<tr>
							<td colspan="5" class="empty-message">
								<div class="empty-icon">🎬</div>
								<div>등록된 상영 스케줄이 없습니다.</div>
							</td>
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
							<td>
								<c:choose>
									<c:when test="${ssList.scheduleStatus == '상영예정'}">
										<span class="status-upcoming">✅ ${ssList.scheduleStatus}</span>
									</c:when>
									<c:when test="${ssList.scheduleStatus == '상영중'}">
										<span class="status-playing">▶️ ${ssList.scheduleStatus}</span>
									</c:when>
									<c:otherwise>
										<span class="status-ended">⏹️ ${ssList.scheduleStatus}</span>
									</c:otherwise>
								</c:choose>
							</td>
							<td>
							<form id="reservationParam" action="http://localhost/movie_prj/admin/reservation/reservation_manage.jsp" method="post">
							<button class="btn-detail" name="scheduleParam" value="${ssList.scheduleIdx}">📋 자세히</button>
							</form>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>