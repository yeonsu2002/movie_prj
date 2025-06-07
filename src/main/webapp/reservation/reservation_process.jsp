<%@page import="kr.co.yeonflix.member.NonMemberDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="kr.co.yeonflix.purchaseHistory.PurchaseHistoryDTO"%>
<%@page import="kr.co.yeonflix.purchaseHistory.PurchaseHistoryService"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatDTO"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatService"%>
<%@page import="kr.co.yeonflix.reservation.ReservationService"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="java.util.Random"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" info="Main template page"%>

<jsp:useBean id="resDTO" class="kr.co.yeonflix.reservation.ReservationDTO" scope="page" />

<%
    //세션에 저장된 유저값 가져오기
 	MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    NonMemberDTO guestUser = (NonMemberDTO)session.getAttribute("guestUser");
    
    int userIdx = 0;
    
    if (loginUser != null) {
        userIdx = loginUser.getUserIdx();
    } else{
    	userIdx = guestUser.getUserIdx();
    }
 
    // 파라미터 받아오기
    int totalPrice = Integer.parseInt(request.getParameter("priceParam"));
    String seatsInfo = request.getParameter("seatsParam");
    int scheduleIdx = Integer.parseInt(request.getParameter("scheduleParam"));


    Calendar cal = Calendar.getInstance();
    String thisYear = new SimpleDateFormat("yyyy").format(cal.getTime());
    String thisDay = new SimpleDateFormat("MMdd").format(cal.getTime());

    Random random = new Random();
    String reservationNumber = String.format("%s-%s-%04d-%04d", thisYear, thisDay, random.nextInt(9000) + 1000, random.nextInt(9000) + 1000);

    // 좌석 정보 분리
    String[] seats = seatsInfo.split(" ");

    ScheduleService ss = new ScheduleService();
    ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);

    ReservedSeatService rss = new ReservedSeatService();

    // 예매 등록
    resDTO.setScheduleIdx(scheduleIdx);
    resDTO.setTotalPrice(totalPrice);
    resDTO.setReservationNumber(reservationNumber);
    resDTO.setUserIdx(userIdx);

    ReservationService rs = new ReservationService();
    rs.addReservation(resDTO);
    int reservationIdx = rs.getCurrentReservationIdx();

    // 좌석 예매 등록 or 갱신
    for (String seat : seats) {
        int seatIdx = rss.searchSeatIdx(seat);

        ReservedSeatDTO rsDTO = new ReservedSeatDTO();
            rsDTO.setSeatIdx(seatIdx);
            rsDTO.setScheduleIdx(scheduleIdx);

        rsDTO.setReservedSeatStatus(1);
        rsDTO.setReservationIdx(reservationIdx);

            rss.addReservedSeat(rsDTO);
        
        //임시 좌석 삭제 후 잔여좌석 돌려놓기
        boolean removed = rss.removeTempSeat(seatIdx, scheduleIdx);
        if(removed) {  // 실제로 삭제된 경우에만
            schDTO.setRemainSeats(schDTO.getRemainSeats() + 1);
            ss.modifySchedule(schDTO);
        }
    }

    // 구매 내역 등록
    PurchaseHistoryService phs = new PurchaseHistoryService();
    PurchaseHistoryDTO phDTO = new PurchaseHistoryDTO();
    phDTO.setUserIdx(userIdx);
    
    
    phDTO.setReservationIdx(reservationIdx);
    phs.addPurchaseHistory(phDTO);
    

    // 남은 좌석 수 업데이트
    schDTO.setRemainSeats(schDTO.getRemainSeats() - seats.length);
    ss.modifySchedule(schDTO);

%>
<form id="sendForm" action="reservation_complete.jsp" method="post">
    <input type="hidden" name="scheduleParam" value="<%=scheduleIdx%>">
    <input type="hidden" name="reservationParam" value="<%=reservationIdx%>">
    <input type="hidden" name="seatsParam" value="<%=seatsInfo%>">
</form>
<script>
    alert('예매 성공');
    document.getElementById("sendForm").submit();
</script>