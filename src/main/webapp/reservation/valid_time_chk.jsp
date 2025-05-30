<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="java.time.Duration"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.reservedSeat.TempSeatDTO"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%
	int scheduleIdx = Integer.parseInt(request.getParameter("scheduleIdx"));
	String seatsInfo = request.getParameter("seatsInfo");
	String[] seats = seatsInfo.split(" ");
	
	ScheduleService ss = new ScheduleService();
	ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);
	
	//선점된 좌석들 5분이 지났으면 없애기
	ReservedSeatService rss = new ReservedSeatService();
	List<TempSeatDTO> tempSeatsList = rss.searchAllTempSeat();
	for(TempSeatDTO tempSeat : tempSeatsList){
		LocalDateTime holdTime = tempSeat.getClickTime().toLocalDateTime();
		int seatIdx = tempSeat.getSeatIdx();
		Duration d = Duration.between(holdTime, LocalDateTime.now());
		//현재는 테스트용올 10초로 해놨으나 나중에 5분으로 변경
		if(d.toSeconds() >= 10){
			int plusSeats = rss.removeTempSeat(seatIdx, scheduleIdx);
			schDTO.setRemainSeats(schDTO.getRemainSeats() + plusSeats);
			ss.modifySchedule(schDTO);
		}
	}
	
	String isValid = "valid";
	
	for(String seat : seats){
		int seatIdx = rss.searchSeatIdx(seat);
		if(!rss.isTempSeatInTable(seatIdx, scheduleIdx)){
			isValid ="invalid";
			break;
		}
	}
	
	out.print(isValid);
%>