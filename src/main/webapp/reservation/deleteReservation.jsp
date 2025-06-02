<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="java.sql.SQLException"%>
<%@page import="kr.co.yeonflix.reservation.ReservationDAO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatService"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatDTO"%>
<%@page import="kr.co.yeonflix.purchaseHistory.PurchaseHistoryService"%>
<%@page import="kr.co.yeonflix.purchaseHistory.PurchaseHistoryDTO"%>
<%@page import="kr.co.yeonflix.reservation.ReservationDTO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ page import="kr.co.yeonflix.reservation.ReservationService" %>

<%
    request.setCharacterEncoding("UTF-8"); 

    String reservationIdxParam = request.getParameter("reservationIdx");
    boolean success = false;

    if (reservationIdxParam != null) {
        try {
			int reservationIdx = Integer.parseInt(reservationIdxParam);
			ReservationService rs = new ReservationService();
			ReservationDTO resDTO = rs.searchOneSchedule(reservationIdx);
			
			//예매내역 취소시간 업데이트
			boolean reservationSuccess = rs.modifyReservation(resDTO);
			
			//구매내역 취소로 업데이트
			PurchaseHistoryService ps = new PurchaseHistoryService();
			PurchaseHistoryDTO phDTO = ps.searchOnePurchaseHistory(reservationIdx);
			boolean purchaseSuccess = ps.modifyPurchaseHistory(phDTO);
			
			//예매한 좌석들 일괄적으로 0으로 변경
			ReservedSeatService rss = new ReservedSeatService();
			int canceledSeats = rss.modifyReservedSeatAll(reservationIdx);
			
			//남은 좌석 업데이트
			int scheduleIdx = resDTO.getScheduleIdx();
			ScheduleService ss = new ScheduleService();
			ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);
			schDTO.setRemainSeats(schDTO.getRemainSeats() + canceledSeats);
			boolean remainSeats = ss.modifySchedule(schDTO);
			
			

            success = purchaseSuccess && reservationSuccess && (canceledSeats > 0) && remainSeats;
        } catch (NumberFormatException e) {
            success = false;
        }
        
    }

    response.getWriter().write("{\"success\": " + success + "}"); 
%>

