<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatService"%>
<%@page import="kr.co.yeonflix.purchaseHistory.PurchaseHistoryDTO"%>
<%@page import="kr.co.yeonflix.purchaseHistory.PurchaseHistoryService"%>
<%@page import="kr.co.yeonflix.reservation.ReservationDTO"%>
<%@page import="netscape.javascript.JSObject"%>
<%@page import="kr.co.yeonflix.reservation.ReservationService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String reservationParam = request.getParameter("reservationIdx");
	String result = "fail";

	if (reservationParam != null) {
		try {
			int reservationIdx = Integer.parseInt(reservationParam);
			ReservationService rs = new ReservationService();
			ReservationDTO resDTO = rs.searchOneSchedule(reservationIdx);
			
			//예매내역 취소시간 업데이트
			boolean resSuccess = rs.modifyReservation(resDTO);
			
			//구매내역 취소로 업데이트
			PurchaseHistoryService ps = new PurchaseHistoryService();
			PurchaseHistoryDTO phDTO = ps.searchOnePurchaseHistory(reservationIdx);
			boolean purSuccess = ps.modifyPurchaseHistory(phDTO);
			
			//예매한 좌석들 일괄적으로 0으로 변경
			ReservedSeatService rss = new ReservedSeatService();
			int canceledSeats = rss.modifyReservedSeatAll(reservationIdx);
			
			//남은 좌석 업데이트
			int scheduleIdx = resDTO.getScheduleIdx();
			ScheduleService ss = new ScheduleService();
			ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);
			schDTO.setRemainSeats(schDTO.getRemainSeats() + canceledSeats);
			boolean seatSuccess = ss.modifySchedule(schDTO);
			
			if (resSuccess && purSuccess && seatSuccess && (canceledSeats>0)) {
				result = "success";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	out.print(result);
%>