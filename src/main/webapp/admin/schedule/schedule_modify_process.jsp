<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>

<%
int scheduleIdx = Integer.parseInt(request.getParameter("scheduleIdx"));
int movieIdx = Integer.parseInt(request.getParameter("movieIdx"));
int theaterIdx = Integer.parseInt(request.getParameter("theaterIdx"));
Date screenDate = Date.valueOf(request.getParameter("screenDate"));
String time = request.getParameter("startTime");
Timestamp startTime = Timestamp.valueOf(screenDate + " " + time + ":00");

//movieIdx를 통해 해당 영화의 상영시간 가져와서 끝나는 시간 설정
ScheduleService ss = new ScheduleService();
int runningTime = (ss.searchOneMovie(movieIdx)).getRunningTime();
Timestamp endTime = new Timestamp(startTime.getTime() + (runningTime * 60 * 1000L));

ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);
schDTO.setMovieIdx(movieIdx);
schDTO.setTheaterIdx(theaterIdx);
schDTO.setScreenDate(screenDate);
schDTO.setStartTime(startTime);
schDTO.setEndTime(endTime);

//겹치는 시간이 있는지 확인
if (ss.chkTime(schDTO)) {
	ss.modifySchedule(schDTO);
	// 성공 시
	out.println("<script>alert('상영 수정이 완료되었습니다.'); location.href='http://localhost/movie_prj/admin/schedule/schedule_manage.jsp';</script>");
} else {
	// 겹칠 경우
	out.println("<script>alert('해당 시간에 이미 상영이 존재합니다.'); history.back();</script>");
}
%>