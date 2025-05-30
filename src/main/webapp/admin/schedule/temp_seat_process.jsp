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
		rss.addTempSeat(seatIdx, scheduleIdx);
	}//for
%>