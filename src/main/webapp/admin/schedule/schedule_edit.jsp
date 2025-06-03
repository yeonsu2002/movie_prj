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
<title>상영 스케줄 수정</title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">
<link rel="stylesheet"
	href="http://localhost/movie_prj/admin/schedule/css/schedule_edit.css">
<link rel="stylesheet" type="text/css"
href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@docsearch/css@3">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<style type="text/css">

</style>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script>
	$(function() {
		$("#edit-btn").click(function() {
			if ($("#movieIdx").val() == null || $("#movieIdx").val() == "") {
				alert('🎬 영화를 선택하세요');
				$("#movieIdx").focus();
				return;
			}

			if ($("#theaterIdx").val() == null || $("#theaterIdx").val() == "") {
				alert('🏛️ 상영관을 선택하세요');
				$("#theaterIdx").focus();
				return;
			}

			if ($("#screenDate").val() == "") {
				alert('📅 날짜를 선택하세요');
				$("#screenDate").focus();
				return;
			}

			if ($("#startTime").val() == "") {
				alert('🕒 시작 시간을 선택하세요');
				$("#startTime").focus();
				return;
			}

			// 버튼 로딩 효과
			$("#edit-btn").html("수정 중...").prop("disabled", true);
			
			$("#schedule-form").submit();
		});
		
		$("#delete-btn").click(function(){
			if (confirm("🗑️ 정말 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.")) {
		        var idx = $("#scheduleIdx").val();
		        
		        // 버튼 로딩 효과
				$("#delete-btn").html("삭제 중...").prop("disabled", true);
				
		        location.href = "schedule_remove_process.jsp?scheduleIdx=" + idx;
		    }
		});
		
		// 입력 필드 포커스 효과
		$("select, input").on("focus", function() {
			$(this).parent().addClass("focused");
		}).on("blur", function() {
			$(this).parent().removeClass("focused");
		});
	});
</script>
</head>
<body>
	<div class="content-container">
		<h2 class="page-title">✏️ 상영 스케줄 수정</h2>
		
		<div class="register-card">
			<div class="register-title">상영 일정 정보 수정</div>
			<div class="register-container">
				<form action="schedule_modify_process.jsp" id="schedule-form"
					name="schedule-form" method="post">
					<input type="hidden" id="scheduleIdx" name="scheduleIdx" value="${scheduleIdx}">
					
					<div class="form-group movie-field">
						<label for="movieIdx">영화 선택</label>
						<select name="movieIdx" id="movieIdx">
							<option value="" selected disabled>상영할 영화를 선택하세요</option>
							<c:forEach var="mList" items="${movieList}" varStatus="i">
								<option value="${mList.movieIdx}"
									<c:if test="${mList.movieIdx == schDTO.movieIdx}">selected</c:if>>
									${mList.movieName}</option>
							</c:forEach>
						</select>
					</div>
					
					<div class="form-group theater-field">
						<label for="theaterIdx">상영관 선택</label>
						<select name="theaterIdx" id="theaterIdx">
							<option value="" selected disabled>상영관을 선택하세요</option>
							<c:forEach var="thList" items="${theaterList}" varStatus="i">
								<option value="${thList.theaterIdx}"
									<c:if test="${thList.theaterIdx == schDTO.theaterIdx}">selected</c:if>>
									${thList.theaterName}</option>
							</c:forEach>
						</select>
					</div>
					
					<div class="form-group date-field">
						<label for="screenDate">상영 날짜</label>
						<input type="date" id="screenDate" min="${minDate}" max="${maxDate}" 
							name="screenDate" value="${schDTO.screenDate}">
					</div>
					
					<div class="form-group time-field">
						<label for="startTime">시작 시간</label>
						<input type="time" id="startTime" name="startTime" value="${startTime}">
					</div>
					
					<div class="button-group">
						<button type="button" class="edit-btn" id="edit-btn">
							💾 수정하기
						</button>
						<button type="button" class="delete-btn" id="delete-btn">
							🗑️ 삭제하기
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>