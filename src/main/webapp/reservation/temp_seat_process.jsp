<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatDTO"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatService"%>
<%@page import="kr.co.yeonflix.reservation.ReservationService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%
	int scheduleIdx = Integer.parseInt(request.getParameter("scheduleIdx"));
	String seatsInfo = request.getParameter("seatsInfo");
	String[] seats = seatsInfo.split(" ");
	
	ReservedSeatService rss = new ReservedSeatService();
	
	//선점한 좌석들 등록
	for(String seat : seats){
		int seatIdx = rss.searchSeatIdx(seat);
		rss.addTempSeat(seatIdx, scheduleIdx);
	}//for
	
	//잔여좌석 업데이트
	ScheduleService ss = new ScheduleService();
	ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);
	schDTO.setRemainSeats(schDTO.getRemainSeats() - seats.length);
	ss.modifySchedule(schDTO);
%>