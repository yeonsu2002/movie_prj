<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="Main template page"%>
<%
String totalPrice = request.getParameter("priceParam");
String seatsInfo = request.getParameter("seatsParam");
int scheduleIdx = Integer.parseInt(request.getParameter("scheduleParam"));

//좌석 정보 배열로 저장
String[] seats = seatsInfo.split(" ");
ScheduleService ss = new ScheduleService();
ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);

%>