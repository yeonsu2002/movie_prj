<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatDTO"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatDAO"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatService"%>
<%@page import="kr.co.yeonflix.reservation.ReservationService"%>
<%@page import="java.util.Random"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="Main template page"%>
<jsp:useBean id="resDTO"
	class="kr.co.yeonflix.reservation.ReservationDTO" scope="page" />
<%
//파라미터 받아오기
int totalPrice = Integer.parseInt(request.getParameter("priceParam"));
String seatsInfo = request.getParameter("seatsParam");
int scheduleIdx = Integer.parseInt(request.getParameter("scheduleParam"));

//예매번호 생성
SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy");
SimpleDateFormat sdf2 = new SimpleDateFormat("MMdd");

Calendar cal = Calendar.getInstance();
String thisYear = sdf1.format(cal.getTime());
String thisDay = sdf2.format(cal.getTime());

Random random = new Random();
int randomNum1 = random.nextInt(9000) + 1000;
int randomNum2 = random.nextInt(9000) + 1000;

String reservationNumber = thisYear + "-" + thisDay + "-" + randomNum1 + "-" + randomNum2;

//임시 유저Idx;
int userIdx = random.nextInt(5) + 4;

//좌석 정보 배열로 저장
String[] seats = seatsInfo.split(" ");
ScheduleService ss = new ScheduleService();
ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);

boolean isSuccess = false;
int reservationIdx = 0;

try {
	//예매 등록
	resDTO.setScheduleIdx(scheduleIdx);
	resDTO.setTotalPrice(totalPrice);
	resDTO.setReservationNumber(reservationNumber);
	resDTO.setUserIdx(userIdx);

	ReservationService rs = new ReservationService();
	rs.addReservation(resDTO);

	//예매 좌석 등록
	reservationIdx = rs.getCurrentReservationIdx();
	ReservedSeatService rss = new ReservedSeatService();
	ReservedSeatDTO rsDTO = null;

	for (int i = 0; i < seats.length; i++) {
		rsDTO = new ReservedSeatDTO();

		int seatIdx = rss.searchSeatIdx(seats[i]);
		rsDTO.setSeatIdx(seatIdx);
		rsDTO.setScheduleIdx(scheduleIdx);
		rsDTO.setReservedSeatStatus(1);
		rsDTO.setReservationIdx(reservationIdx);

		rss.addReservedSeat(rsDTO);
	}
	
	//잔여 좌석 업데이트
	int remainSeats = schDTO.getRemainSeats();
	schDTO.setRemainSeats(remainSeats - seats.length);
	ss.modifySchedule(schDTO);
	
	isSuccess = true;
} catch (Exception e) {
	e.printStackTrace();
}

if (isSuccess) {
%>
    <form id="sendForm" action="reservation_complete.jsp" method="post">
        <input type="hidden" name="scheduleParam" value="<%= scheduleIdx %>">
        <input type="hidden" name="reservationParam" value="<%= reservationIdx %>">
        <input type="hidden" name="seatsParam" value="<%= seatsInfo %>">
    </form>
    <script>
        alert('예매 성공');
        document.getElementById("sendForm").submit();
    </script>
<%
} else {
%>
    <script>
        alert('예매에 실패했습니다. 다시 시도해 주세요.');
        history.back();
    </script>
<%
}
%>
