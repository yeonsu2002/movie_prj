<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="kr.co.yeonflix.theater.TheaterDTO"%>
<%@page import="kr.co.yeonflix.theater.TheaterService"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.reservation.ReservationService"%>
<%@page import="kr.co.yeonflix.reservation.ReservationDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
int scheduleIdx = Integer.parseInt(request.getParameter("scheduleParam"));
int reservationIdx = Integer.parseInt(request.getParameter("reservationParam"));
String seatsInfo = request.getParameter("seatsParam");

//스케줄 객체 가져오기
ScheduleService ss = new ScheduleService();
ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);

//예매 객체 가져오기
ReservationService rs = new ReservationService();
ReservationDTO resDTO = rs.searchOneSchedule(reservationIdx);

//영화 객체 가져오기
int movieIdx = schDTO.getMovieIdx();
MovieService ms = new MovieService();
MovieDTO mDTO = ms.searchOneMovie(movieIdx);

//극장 객체 가져오기
int theaterIdx = schDTO.getTheaterIdx();
TheaterService ts = new TheaterService();
TheaterDTO tDTO = ts.searchTheaterWithIdx(theaterIdx);

//총 인원수 구하기
String[] seats = seatsInfo.split(" ");
int peopleCnt = seats.length;

pageContext.setAttribute("schDTO", schDTO);
pageContext.setAttribute("resDTO", resDTO);
pageContext.setAttribute("mDTO", mDTO);
pageContext.setAttribute("tDTO", tDTO);
pageContext.setAttribute("seatsInfo", seatsInfo);
pageContext.setAttribute("peopleCnt", peopleCnt);
pageContext.setAttribute("reservationIdx", reservationIdx);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예매 완료</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp" />
<link rel="stylesheet"
	href="http://localhost/movie_prj/reservation/reservation.css/reservation_complete.css" />
<script type="text/javascript">
	$(document).ready(function() {
		$('#showModalBtn').click(function() {
			$('#bookingModal').fadeIn();
		});

		$('#closeModalBtn').click(function() {
			$('#bookingModal').fadeOut();
		});

		// 배경 클릭 시 모달 닫기
		$('#bookingModal').click(function(e) {
			if (e.target === this) {
				$(this).fadeOut();
			}
		});

		$('.close-btn').click(function() {
			$('#bookingModal').fadeOut();
		});

		$("#toMyPage").click(function() {
			location.href = "http://localhost/movie_prj/mypage/MainPage.jsp";
		});
	});
</script>
</head>
<body>
	<header>
		<jsp:include page="../common/jsp/header.jsp" />
	</header>
	<main>
		<div id="container">
			<div class="booking-header">예매 완료</div>
			<div class="booking-complete-box">
				<br>
				<h1>예매가 완료되었습니다.</h1>

				<div class="booking-info">
				
					<img src="/movie_prj/common/img/${mDTO.posterPath}" alt="썬더볼츠 포스터"
						class="poster">

					<div class="details">
						<p>
							<span>예매번호</span>${resDTO.reservationNumber}
						</p>
						<p>
							<span>영화</span>${mDTO.movieName}
						</p>
						<p>
							<span>극장</span>연플릭스 / ${tDTO.theaterName}
						</p>
						<p>
							<span>일시</span><fmt:formatDate value="${schDTO.screenDate}"
								pattern="yyyy년 M월 dd일(E)" />
							<fmt:formatDate value="${schDTO.startTime}" pattern="HH:mm" />
							~
							<fmt:formatDate value="${schDTO.endTime}" pattern="HH:mm" />
						</p>
						<p>
							<span>인원</span>일반 ${peopleCnt}명
						</p>
						<p>
							<span>좌석</span>${seatsInfo}
						</p>
						<p>
							<%
							NumberFormat nf = NumberFormat.getInstance();
							String price = nf.format(resDTO.getTotalPrice());
							%>
							<span>결제금액</span><%= price %> 원
						</p>
						<p>
							<span>결제수단</span>신용카드 <%= price %> 원
						</p>

						<br>
						<div class="btn-box">
							<button class="red-btn" id="showModalBtn">예매정보 출력</button>
							<button class="gray-btn" id="toMyPage">예매확인/취소</button>
						</div>
					</div>
				</div>

				<div class="notice">
					<strong>예매 유의사항</strong>
					<ul>
						<li>CJ ONE 포인트는 상영일 익일 적립됩니다. (영화관람권, 비회원 예매 제외)</li>
						<li>영화 상영 스케줄은 영화관 사정에 의해 변경될 수 있습니다.</li>
						<li>비회원 예매하신 경우는 예매내역이 이메일로 발송되지 않습니다.</li>
					</ul>
				</div>
			</div>
			<br><br>
			<div class="main-banner">
				<img src="http://localhost/movie_prj/common/img/banner/banner2.png"
					style="width: 100%;">
			</div>
			<br> <br>
		</div>
		
		


	</main>
	<footer>
		<c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
	</footer>
	<c:import
		url="http://localhost/movie_prj/reservation/booking_modal.jsp" >
		<c:param name="reservationIdx" value="${reservationIdx}" />
		</c:import>

</body>
</html>