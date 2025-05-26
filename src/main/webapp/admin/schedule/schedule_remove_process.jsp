<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>

<%
	int scheduleIdx = Integer.parseInt(request.getParameter("scheduleIdx"));

	ScheduleService ss = new ScheduleService();
	
	ss.removeSchedule(scheduleIdx);
	out.println("<script>alert('상영스케줄이 삭제되었습니다.'); location.href='http://localhost/movie_prj/admin/schedule/schedule_manage.jsp';</script>");
%>