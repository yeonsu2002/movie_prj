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
	
	String isValid = "valid";
	
	//만약 누가 선점한 좌석이라면
	for(String seat : seats){
		int seatIdx = rss.searchSeatIdx(seat);
		
		if(rss.isTempSeatInTable(seatIdx, scheduleIdx)){
			isValid = "invalid";
			out.print(isValid);
			return;
		}
			
	}
	
	//이선좌가 없으면 선점좌석 등록
	for(String seat: seats){
		int seatIdx = rss.searchSeatIdx(seat);
		rss.addTempSeat(seatIdx, scheduleIdx);
	}
	//잔여좌석 업데이트
	ScheduleService ss = new ScheduleService();
	ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);
	schDTO.setRemainSeats(schDTO.getRemainSeats() - seats.length);
	ss.modifySchedule(schDTO);
	
	out.print(isValid);
%>