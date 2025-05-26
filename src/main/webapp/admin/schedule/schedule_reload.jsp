<%@page import="java.util.Calendar"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%
ScheduleService ss = new ScheduleService();
List<ScheduleDTO> list = ss.searchAllSchedule();
Timestamp nowTime = new Timestamp(System.currentTimeMillis());

for (ScheduleDTO sDTO : list) {
	int status = sDTO.getScheduleStatus();
	Timestamp startTime = sDTO.getStartTime();
	Timestamp endTime = sDTO.getEndTime();

	if (nowTime.after(startTime) && nowTime.before(endTime)) {
		status = 1;
	} else if (nowTime.after(endTime)) {
		status = 2;
	} else {
		status = 0;
	}

	sDTO.setScheduleStatus(status);
	ss.modifySchedule(sDTO);
}

response.sendRedirect("http://localhost/movie_prj/admin/schedule/schedule_manage.jsp");
%>