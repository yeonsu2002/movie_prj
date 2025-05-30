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
	for(String seat : seats){
		int seatIdx = rss.searchSeatIdx(seat);
		ReservedSeatDTO rsDTO = rss.searchSeatWithIdxAndSchedule(seatIdx, scheduleIdx);
		
		//만약 해당스케줄 해당 좌석의 객체를 처음 생성한다면
		if(rsDTO == null){
			rsDTO = new ReservedSeatDTO();
			rsDTO.setSeatIdx(seatIdx);
			rsDTO.setScheduleIdx(scheduleIdx);
			rsDTO.setTempSeatStatus(1);
			rsDTO.setReservationIdx(0);
			
			rss.addReservedSeat(rsDTO);
		} else{
			rsDTO.setReservationIdx(0);
			rsDTO.setTempSeatStatus(1);
			rss.modifyReservedSeat(rsDTO);
		}//if
		
	}//for
%>