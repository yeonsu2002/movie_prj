<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatService"%>
<%@page import="kr.co.yeonflix.theater.TheaterDTO"%>
<%@page import="kr.co.yeonflix.theater.TheaterService"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
//파라미터로 받은 값으로 선택한 상영스케줄 찾기
int scheduleIdx = Integer.parseInt(request.getParameter("scheduleIdx"));
ScheduleService ss = new ScheduleService();
ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);

//상영스케줄의 해당 영화 찾기
int movieIdx = schDTO.getMovieIdx();
MovieDTO mDTO = ss.searchOneMovie(movieIdx);

//상영스케줄의 해당 상영관 찾기
int theaterIdx = schDTO.getTheaterIdx();
TheaterService ts = new TheaterService();
TheaterDTO tDTO = ts.searchTheaterWithIdx(theaterIdx);

//예매된 좌석 정보
ReservedSeatService rss = new ReservedSeatService();
List<String> occupiedSeats = rss.searchSeatNumberWithSchedule(scheduleIdx);

request.setAttribute("schDTO", schDTO);
request.setAttribute("mDTO", mDTO);
request.setAttribute("tDTO", tDTO);
request.setAttribute("occupiedSeats", occupiedSeats);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>영화관 좌석 예매</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp" />
<link rel="stylesheet"
	href="http://localhost/movie_prj/reservation/reservation.css/reservation_seat.css">
<style>
</style>

<script type="text/javascript"
	src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<script src="/main.js"></script>
<script type="text/javascript">
	IMP.init("imp03140165"); //결제관련코드
	var moviePrice = ${tDTO.moviePrice};
	var totalPrice;
	var occupiedSeats = [
	    <c:forEach var="seat" items="${occupiedSeats}" varStatus="status">
	        "${seat}"<c:if test="${!status.last}">,</c:if>
	    </c:forEach>
	];

	$(function() {

		$('.seat').each(function() {
	        var row = $(this).data('row');
	        var col = $(this).data('col');
	        var seatName = row + col;
	        
	        if (occupiedSeats.includes(seatName)) {
	            $(this).addClass('occupied');
	        }
	    });

		//좌석을 클릭했을 때
		$('.seat').click(function() {
		    var maxCnt = $('.num-btn.selected').text();
		    var totalSelected = $(".seat.selected").length;
		    
		    var row = $(this).data('row');
		    var col = $(this).data('col');
		    var seatName = row + col;
		    
		    // 관람인원이 선택되지 않은 경우
		    if (maxCnt == 0) {
		        alert("관람인원을 선택해주세요.");
		        return;
		    }
		    
		    // 이미 점유된 좌석인 경우
		    if ($(this).hasClass('occupied')) {
		        return;
		    }
		    
		    // 좌석 선택/해제
		    if ($(this).hasClass('selected')) {
		        // 선택된 좌석을 해제
		        $(this).removeClass("selected");
		        var currentText = $("#seatInfo").text();
		        var updateText = currentText.replace(seatName + " ", "");
		        $("#seatInfo").text(updateText);
		        
		    } else {
		        // 새로운 좌석 선택
		        if (totalSelected >= maxCnt) {
		            alert("이미 좌석을 모두 선택하였습니다.");
		            return;
		        }
		        $(this).addClass("selected");
		        $("#seatInfo").append(seatName + " ");
		    }
		    
		    updatePrice();
		    
		});
		
		//관람인원 선택 버튼 클릭시
		$('.num-btn').click(function() {
			var selectedCount = $('.seat.selected').length;
			var maxCnt = $(this).text();
			
			// 선택된 좌석이 새로운 인원수보다 많은 경우
			if(maxCnt < selectedCount){
				alert("선택한 좌석이 예매 인원보다 많습니다.")
				return;
			}
			
			// 기존 선택 해제하고 새로운 버튼 선택
			$('.num-btn.selected').removeClass('selected');
			$(this).addClass('selected');
		});

		$('.nav-left').click(function() {
			history.back();
		});

		$('.nav-right').click(function () {
		   /*  const selectedSeats = [];

		    $('.row').each(function (rowIdx) {
		        $(this).find('.seat.selected').each(function () {
		            const seatIdx = $(this).index() - 1;
		            selectedSeats.push({ row: rowIdx, seat: seatIdx });
		        });
		    }); */

		    var selectedCount = $('.seat.selected').length;
		    var maxCnt = $('.num-btn.selected').text();

		    if (maxCnt == 0) {
		        alert("관람인원을 선택해주세요.");
		        return;
		    }

		    if (selectedCount < maxCnt) {
		        alert("관람인원과 선택 좌석 수가 동일하지 않습니다.");
		        return;
		    }
			
		    alert("결제완료");
		    
		    var seatInfo = $("#seatInfo").text();
		    $('#seatsParam').val(seatInfo);
		    $('#priceParam').val(totalPrice);
		    
		    $('#reservationForm').submit();
		    // 결제 요청
		   /*  IMP.request_pay({
		        pg: "kakaopay",
		        pay_method: "card",
		        amount: "500000000",
		        name: "람보르기니",
		        merchant_uid: "merchant_" + new Date().getTime()
		    }, function (response) {
		        if (response.success) {
		            alert("결제 성공!");
		            // 성공 후 로직 추가 가능
		        } else {
		            alert("결제 실패: " + response.error_msg);
		            location.href = "http://localhost/movie_prj/reservation/reservation_complete.jsp";
		        }
		    }); */
		});
	});
	
    
    // 가격 업데이트 함수
    function updatePrice() {
		var moviePrice = ${tDTO.moviePrice}; 
        var selectedCount = $('.seat.selected').length;
        totalPrice = selectedCount * moviePrice;
        $('#priceInfo').text('가격: ' + moviePrice.toLocaleString() + " x " + selectedCount + " = " +totalPrice.toLocaleString() + '원');
    }
</script>
</head>
<body>
	<header>
		<jsp:include page="../common/jsp/header.jsp"/>
	</header>
	<main>
		<div id="container">
			<div class="seat-reservation-container">
				<div class="seat-header">인원/좌석</div>
				<div class="info-bar">
					<div class="flex-space-between">
						<div class="flex-1">
							<br>
							<div class="flex-gap-center">
								<br>

								<div class="label-small">일반</div>
								<div>
									<c:forEach var="i" begin="0" end="6">
										<c:choose>
											<c:when test="${i == 0}">
												<button class="num-btn selected">${i}</button>
											</c:when>
											<c:otherwise>
												<button class="num-btn">${i}</button>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</div>

								<div class="note-red-small">* 최대 6명 선택 가능</div>
							</div>
						</div>
						<div class="divider-vertical"></div>
						<div class="flex-1 flex-col-center pl-120">
							<div style="margin-bottom: 5px;">
								<span>연플릭스</span> &nbsp;|&nbsp; <span>${tDTO.theaterName}</span>
								&nbsp;|&nbsp; <span>남은좌석 <span style="color: red;"><c:out
											value="${schDTO.remainSeats}"/></span>/140
								</span>
							</div>
							<div class="schedule-time">
								<fmt:formatDate value="${schDTO.screenDate}"
									pattern="yyyy.MM.dd (E)" />
								&nbsp; <span><fmt:formatDate value="${schDTO.startTime}"
										pattern="HH:mm" /> ~ <fmt:formatDate
										value="${schDTO.endTime}" pattern="HH:mm" /></span>
							</div>
						</div>
					</div>
				</div>

				<div class="screen-container">
					<div class="screen">SCREEN</div>
					<br> <br>
					<div class="seat-layout">
						<c:forEach var="i" begin="1" end="10">
							<c:set var="rowLetter"
								value="${fn:substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ', i - 1, i)}" />
							<div class="row">
								<span class="row-label">${rowLetter}</span>
								<c:forEach var="j" begin="1" end="14">
									<div class="seat" data-row="${rowLetter}" data-col="${j}">${j}</div>
								</c:forEach>
							</div>
						</c:forEach>
					</div>
					<br>
					<div class="legend-container">
						<div class="legend-item">
							<div class="seat-ex selected"></div>
							선택됨
						</div>
						<div class="legend-item">
							<div class="seat-ex"></div>
							일반
						</div>
						<div class="legend-item">
							<div class="seat-ex occupied"></div>
							예매됨
						</div>
					</div>
				</div>

				<div class="reservation-nav">
					<div class="nav-left">
						<span class="back-arrow">&#8592;</span> 뒤로
					</div>
					<div class="nav-center">
						<div class="movie-poster"></div>
						<div class="movie-info">
							<div class="movie-title">${mDTO.movieName}</div>
							<div>장르</div>
							<div>${mDTO.runningTime}분</div>
							<div>15세 이용가</div>
							<div>좌석: <span id="seatInfo"></span></div>
							<div id="priceInfo">가격: 0원</div>
						</div>
					</div>
					<div class="nav-right">
						<span class="checkmark">&#10003;</span> 결제하기
					</div>
				</div>
			</div>
			<br> <br>
			<div class="main-banner">
				<img src="http://localhost/movie_prj/common/img/banner/banner1.png"
					style="width: 100%;">
			</div>
			<br> <br>
		</div>
		
		<form id="reservationForm" action="reservation_process.jsp" method="post">
			<input type="hidden" id="seatsParam" name="seatsParam">
			<input type="hidden" id="priceParam" name="priceParam">
			<input type="hidden" name="scheduleParam" value="${schDTO.scheduleIdx}"/>
		</form>

	</main>
	<footer>
		<c:import url="http://localhost/movie_prj/common/jsp/footer.jsp" />
	</footer>
</body>


</html>
