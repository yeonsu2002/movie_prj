<%@page import="java.sql.Timestamp"%>
<%@page import="kr.co.yeonflix.movie.common.CommonDTO"%>
<%@page import="kr.co.yeonflix.movie.common.CommonService"%>
<%@page import="kr.co.yeonflix.movie.code.MovieCommonCodeService"%>
<%@page import="kr.co.yeonflix.movie.code.MovieCommonCodeDTO"%>
<%@page import="java.time.Duration"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatService"%>
<%@page import="kr.co.yeonflix.reservedSeat.TempSeatDTO"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleTheaterDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="java.sql.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
//날짜 가공
List<Map<String, String>> dateList = new ArrayList<>();
SimpleDateFormat monthSdf = new SimpleDateFormat("M월");
SimpleDateFormat daySdf = new SimpleDateFormat("dd");
SimpleDateFormat weekSdf = new SimpleDateFormat("E");
SimpleDateFormat fullSdf = new SimpleDateFormat("yyyy-MM-dd");

Calendar cal = Calendar.getInstance();
String minDate = fullSdf.format(cal.getTime());

for (int i = 0; i < 7; i++) {
	Map<String, String> dateMap = new HashMap<>();
	dateMap.put("month", monthSdf.format(cal.getTime()));
	dateMap.put("day", daySdf.format(cal.getTime()));
	dateMap.put("week", weekSdf.format(cal.getTime()));
	dateMap.put("fullDate", fullSdf.format(cal.getTime()));
	dateList.add(dateMap);
	cal.add(Calendar.DATE, 1);
}

//클릭한 날짜 parameter로 가져오기
Date todayDate = null;
String dateParam = request.getParameter("date");

if (dateParam != null && !dateParam.isEmpty()) {
	todayDate = Date.valueOf(dateParam);
} else {
	todayDate = Date.valueOf(minDate);
}

pageContext.setAttribute("dateList", dateList);
pageContext.setAttribute("minDate", minDate);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상영스케줄</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp" />
<link rel="stylesheet"
	href="http://localhost/movie_prj/reservation/reservation.css/reservation.css">
<style>
</style>
<script type="text/javascript">
	$(function() {

		var currentDate = $(".day_list.on").data("date");
		
	    if (currentDate) {
	        loadSchedule(currentDate);
	    }
	    
	    //날짜 버튼 클릭시
	    $(".day_list").click(function() {
	        var selectedDate = $(this).data("date");
	        
	        $(".day_list").removeClass("on");
	        $(this).addClass("on");
	        
	        loadSchedule(selectedDate);
	    });

	    //다음 버튼 클릭시
	    $(".btn_prev").click(function () {
	        var days = $(".day_list");
	        var idx = getCurrentIdx(days);
	        if (idx > 0) {
	            updateActive(days, idx - 1);
	            var selectedDate = days.eq(idx - 1).data("date");
	            loadSchedule(selectedDate);
	        }
	    });

	    //이전 버튼 클릭시
	    $(".btn_next").click(function () {
	        var days = $(".day_list");
	        var idx = getCurrentIdx(days);
	        if (idx < days.length - 1) {
	            updateActive(days, idx + 1);
	            var selectedDate = days.eq(idx + 1).data("date");
	            loadSchedule(selectedDate);
	        }
	    });

		//상영시간 버튼 클릭시 예매페이지로 이동
	    $(document).on("click", ".showtime", function(){
	    	$(this).closest("form").submit();
	    });
	    
		//관람등급 클릭시
		$(".grade").click(function() {
			$("#gradeModal").fadeIn();
		});

		// 닫기 버튼 클릭 시 모달 닫기
		$(".close").click(function() {
			$("#gradeModal").fadeOut();
		});

	});

	function updateActive(days, idx) {
		days.removeClass("on");
		days.eq(idx).addClass("on");
	}

	function getCurrentIdx(days) {
		return days.index(days.filter(".on"));
	}

	function loadSchedule(date) {
		$.ajax({
			url : "ajax_reservation.jsp",
			method : "POST",
			data : {date : date},
			success : function(response) {
				$("#movie-items").html(response);
			},
			error : function() {
				alert("스케줄을 불러오는데 실패했습니다.");
			}
		});
	}
</script>
</head>
<body>
	<header>
		<jsp:include page="../common/jsp/header.jsp" />
	</header>

	<main>
		<div id="container">
			<h1 style="font-size: 40px; font-weight: bold;">상영스케줄</h1>
			<section class="schedule">
				<div class="timetable">
					<div class="date">
						<div class="date_list">
							<div class="btn btn_prev"></div>
							<ul class="day">
								<c:forEach var="day" items="${dateList}">
									<c:choose>
										<c:when
											test="${day.fullDate == minDate}">
											<li>
												<div class="day_list on" data-date="${day.fullDate}">
													<span>${day.month}<br> <em>${day.week}</em></span> <strong>${day.day}</strong>
												</div>
											</li>
										</c:when>
										<c:otherwise>
											<li>
												<div class="day_list" data-date="${day.fullDate}">
													<span>${day.month}<br> <em>${day.week}</em></span> <strong>${day.day}</strong>
												</div>
											</li>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</ul>
							<div class="btn btn_next"></div>
						</div>

						<ul class="desc">
							<li class="grade"><a href="#none">관람등급 안내</a></li>
						</ul>
					</div>

					<div class="timezone">
						<p>* 시간을 클릭하시면 빠른 예매를 하실 수 있습니다.</p>
					</div>
					<br> <br>
					<div id="movie-items"></div>
					<br> <br>
					<p class="info_screen">[공지]입장 지연에 따른 관람 불편을 최소화하기 위해 영화는 10분 후
						상영이 시작됩니다.</p>
				</div>
			</section>
			<br> <br>
			<div class="main-banner">
				<img src="http://localhost/movie_prj/common/img/banner/banner3.png"
					style="width: 100%;">
			</div>
			<br> <br>
		</div>

	</main>

	<footer>
		<c:import url="http://localhost/movie_prj/common/jsp/footer.jsp" />
	</footer>
	<!-- 관람등급 안내 모달창 -->
	<div id="gradeModal" class="modal">
		<div class="modal-content">
			<div class="modal-header">
				CGV 관람 등급 안내 <span class="close">&times;</span>
			</div>
			<div class="modal-body">
				<table class="grade-table">
					<thead>
						<tr>
							<th>구분</th>
							<th>설명</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="grade-label"><img
								src="http://localhost/movie_prj/common/img/icon_all.svg" />전체
								관람가</td>
							<td>모든 연령의 고객님께서 관람하실 수 있습니다.</td>
						</tr>
						<tr>
							<td class="grade-label"><img
								src="http://localhost/movie_prj/common/img/icon_12.svg" />12세
								관람가</td>
							<td>만 12세 미만의 고객님은 보호자를 동반하셔야 관람하실 수 있습니다.</td>
						</tr>
						<tr>
							<td class="grade-label"><img
								src="http://localhost/movie_prj/common/img/icon_15.svg" />15세
								관람가</td>
							<td>만 15세 미만의 고객님은 보호자를 동반하셔야 관람하실 수 있습니다.</td>
						</tr>
						<tr>
							<td class="grade-label-19"><img
								src="http://localhost/movie_prj/common/img/icon_18.svg" />청소년관람불가</td>
							<td>만 19세 미만(영/유아 포함)은 보호자가 동반하여도 관람이 불가합니다.<br> (단,
								만19세가 되는 해의 1월 1일을 맞이한 사람은 예외)<br> <br> - 입장 시 신분증을 꼭
								지참하시기 바랍니다<br> - 신분증(사진/캡처 불가)<br> 주민등록증, 운전면허증, 여권,
								모바일신분증(PASS, 정부24 등)
							</td>
						</tr>
						<tr>
							<td class="grade-label"><img
								src="http://localhost/movie_prj/common/img/icon_none.svg" />미정</td>
							<td>등급 미정 영화입니다.</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>

</html>