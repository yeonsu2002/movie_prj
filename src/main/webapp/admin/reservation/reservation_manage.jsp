<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.reservation.UserReservationDTO"%>
<%@page import="kr.co.yeonflix.reservation.ReservationService"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@page import="kr.co.yeonflix.theater.TheaterService"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.theater.TheaterDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />

<%
int scheduleIdx = Integer.parseInt(request.getParameter("scheduleParam"));
	
//스케줄 정보 가져오기
ScheduleService ss = new ScheduleService();
ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);
//상영관 정보 가져오기
int theaterIdx = schDTO.getTheaterIdx();
TheaterService ts = new TheaterService();
TheaterDTO tDTO = ts.searchTheaterWithIdx(theaterIdx);

//영화 정보 가져오기
int movieIdx = schDTO.getMovieIdx();
MovieService ms = new MovieService();
MovieDTO mDTO = ms.searchOneMovie(movieIdx);

ReservationService rs = new ReservationService();

//바인딩
pageContext.setAttribute("schDTO", schDTO);
pageContext.setAttribute("tDTO", tDTO);
pageContext.setAttribute("mDTO", mDTO);
pageContext.setAttribute("scheduleIdx", scheduleIdx);
pageContext.setAttribute("moviePrice", tDTO.getMoviePrice());

%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>예매 관리</title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">
<link rel="stylesheet" href="http://localhost/movie_prj/admin/reservation/css/reservation_manage.css">
<link rel="stylesheet" type="text/css"
href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css">
 <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@docsearch/css@3">
 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<style type="text/css">

</style>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script>
var currentPage = 1;
var col = "memberId";
var key = null;

$(function(){
	loadReservation();
	
	//검색 조건 선택시
	$('#col-select').change(function() {
	    col = $(this).val();
	  });
	
	//페이징 버튼 클릭시
	$(document).on("click", ".page-item:not(.active)", function(){
	    var pageNum = parseInt($(this).find("span").text());
	    goToPage(pageNum);
	});
	
	$("#key-text").keyup(function() {
		currentPage = 1;
		var value = $(this).val();
		if(value == "" || value.trim() == ""){
			key = null;
		} else{
			key = value;
		}
		
		loadReservation();
	});
	
	//예매 취소
	$(document).on("click", ".cancelReservation", function(){
		var $clickedRow = $(this).closest("tr");
		var reservationIdx = $clickedRow.data("reservation-idx");
		
		if(confirm("정말 취소하시겠습니까?")){
			$.ajax({
				url:"cancel_reservation_process.jsp",
				method:"POST",
				data: {reservationIdx : reservationIdx},
				success: function(response){
					if(response.trim() == "success"){
						loadReservation();
					} else {
						alert("취소 실패");
					}
				},
				error: function(){
					alert("오류가 발생하였습니다. 다시 시도해주세요.");
				}
			});
		}
	});
});

//페이지 버튼 클릭시
function goToPage(pageNum) {
    currentPage = pageNum; 
    loadReservation();
}

//예매리스트 ajax로 불러오기
function loadReservation(){
    $.ajax({
        url:"reservation_list_ajax.jsp",
        method:"POST",
        data: {
               scheduleIdx:"${scheduleIdx}", 
               currentPage:currentPage,
               col:col, 
               key:key,
               moviePrice:"${moviePrice}"
              },
        success: function(response){
            $("#ajax-reservation-data").html(response);
        },
        error: function(xhr, status, error){
            alert("예매 정보를 불러오는 데 실패했습니다.");
        }
    });
}
</script>
</head>
<body>
<div class="content-container">
<h2 class="page-title">📋 예매 관리</h2>
<!-- 영화 정보 카드 -->
<div class="movie-info-card">
    <div class="theater-badge">🎬 ${tDTO.theaterType}</div>
    <div class="movie-title">${mDTO.movieName}</div>
    
    <div class="movie-details">
        <div class="detail-item">
            <div class="detail-label">상영관</div>
            <div class="detail-value">${tDTO.theaterName}</div>
        </div>
        
        <div class="detail-item">
            <div class="detail-label">시작 시간</div>
            <div class="detail-value">
                <fmt:formatDate value="${schDTO.startTime}" pattern="HH:mm"/>  
            </div>
        </div>
        
        <div class="detail-item">
            <div class="detail-label">상영 날짜</div>
            <div class="detail-value"><fmt:formatDate value="${schDTO.screenDate}" pattern="yyyy-MM-dd"/></div>
        </div>
        
        <div class="detail-item">
            <div class="detail-label">종료 시간</div>
            <div class="detail-value">
                <fmt:formatDate value="${schDTO.endTime}" pattern="HH:mm"/>
            </div>
        </div>
        
        <div class="seats-status">
            <div class="detail-label">좌석 현황</div>
            <div class="seats-count">${schDTO.remainSeats} / 140</div>
        </div>
    </div>
</div>

<!-- 검색 섹션 -->
<div class="search-section">
<select id="col-select" name="col" class="member-button">
	<option value="memberId" ${col == 'memberId' ? 'selected' : ''}>아이디</option>
	<option value="tel"  ${col == 'tel' ? 'selected' : ''}>전화번호</option>
	<option value="reservationNumber" ${col == 'reservationNumber' ? 'selected' : ''}>예매번호</option>
</select>
<input id="key-text" type="text" name="key" class="member-button" value="${key}" placeholder="검색어를 입력하세요"/>
<input type="submit" value="🔍 검색"  class="member-button"/>
<input type="submit" value="🔄 초기화"  class="member-button"/>
</div>

<div id="ajax-reservation-data">

</div>
</div>
</body>
</html>