<%@page import="java.text.SimpleDateFormat"%>
<%@page import="kr.co.yeonflix.theater.TheaterDTO"%>
<%@page import="kr.co.yeonflix.theater.TheaterService"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatService"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatDAO"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="kr.co.yeonflix.reservation.ReservationService"%>
<%@page import="kr.co.yeonflix.reservation.ReservationDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
//파라미터로 예매 Idx 받아오기
System.out.println("reservationIdx : " + request.getParameter("reservationIdx"));


int reservationIdx = Integer.parseInt(request.getParameter("reservationIdx"));

System.out.println("reservationIdx : " + reservationIdx);
ReservationService rs = new ReservationService();
ReservationDTO resDTO = rs.searchOneSchedule(reservationIdx);
System.out.println("resDTO : " + resDTO);

//Schedule 객체 가져오기
int scheduleIdx = resDTO.getScheduleIdx();
System.out.println("scheduleIdx : " + scheduleIdx);
ScheduleService ss = new ScheduleService();
ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);
System.out.println("schDTO : " + schDTO);
//Movie 객체 가져오기
int movieIdx = schDTO.getMovieIdx();
MovieDTO mDTO = ss.searchOneMovie(movieIdx);
System.out.println("movieIdx : " + movieIdx);
System.out.println("mDTO : " + mDTO);

//좌석 정보 가져오기
ReservedSeatService rss = new ReservedSeatService();
List<String> seatList = rss.searchSeatNumberWithReservation(reservationIdx);

//Theater 객체 가져오기
int theaterIdx = schDTO.getTheaterIdx();
TheaterService ts = new TheaterService();
TheaterDTO tDTO = ts.searchTheaterWithIdx(theaterIdx);

pageContext.setAttribute("resDTO", resDTO);
pageContext.setAttribute("schDTO", schDTO);
pageContext.setAttribute("mDTO", mDTO);
pageContext.setAttribute("tDTO", tDTO);
pageContext.setAttribute("seatList", seatList);
%>
<!-- <!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> -->
<link rel="stylesheet"
	href="http://localhost/movie_prj/reservation/reservation.css/booking_modal.css" />
<!-- <style type="text/css">
</style>
</head>
<body> -->
<div class="booking-modal" id="bookingModal">
	<div class="booking-modal-content">
		<div class="modal-header">
			예매정보 확인 <span class="close-button" id="closeModalBtn">✕</span>
		</div>

		<div class="modal-content">
			<div class="warning">
				<p class="warning-text">본 화면으로는 입장이 불가합니다.</p>
				<p class="instruction">
					극장 매표소 또는 티켓판매기에서 아래의 예매번호로<br>영화 티켓을 발급 받으신 후 입장하시기 바랍니다.
				</p>
			</div>

			<div class="booking-number">${resDTO.reservationNumber}</div>

			<div class="booking-details">
				<strong>영화명</strong> ${mDTO.movieName}
			</div>
			<br>
			<div class="booking-details">
				<strong>관람일 </strong>
				<%-- 대체 무슨 연유로 fmt가 적용이 안되는건지 fuck --%>
				<%=new SimpleDateFormat("yyyy년 M월 dd일(E)").format(schDTO.getScreenDate())%>
				<%=new SimpleDateFormat("HH:mm").format(schDTO.getStartTime())%>
				~
				<%=new SimpleDateFormat("HH:mm").format(schDTO.getEndTime())%>
				<br>
			</div>
			<br>
			<div class="booking-details">
				<strong>상영관</strong> 연플릭스 · ${tDTO.theaterName}<br>
			</div>
			<br>
			<div class="booking-details">
				<strong>관람인원</strong> 일반 ${seatList.size()} 명<br>
			</div>
			<br>
			<div class="booking-details">
				<strong>좌석</strong>
				<c:forEach var="seat" items="${seatList}" varStatus="status">
        				${seat}<c:if test="${!status.last}">, </c:if>
				</c:forEach>
				<br>
			</div>
			<br>
			<div class="note">
				입장 지연에 따른 관람 불편을 최소화하기 위해 본<br>영화는 10분 후 상영이 시작됩니다.
			</div>

			<div class="modal-footer">
				<button id="closeModalBtn" class="close-btn">닫기</button>
			</div>
		</div>
	</div>
</div>
<!-- </body>
</html> -->