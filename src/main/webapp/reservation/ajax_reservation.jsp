<%@page import="kr.co.yeonflix.schedule.ScheduleTheaterDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%@ page import="java.util.*, java.sql.Date" %>
<%@ page import="org.json.simple.*, org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
String dateParam = request.getParameter("date");
Date todayDate = Date.valueOf(dateParam);

ScheduleService ss = new ScheduleService();
List<ScheduleDTO> todayScheduleList = ss.searchAllScheduleWithDate(todayDate);
List<MovieDTO> todayMovieList = ss.searchAllMovieWithSchedule(todayScheduleList);

// movieList JSON 배열 생성
JSONArray movieArray = new JSONArray();
for (MovieDTO movie : todayMovieList) {
    JSONObject movieObj = new JSONObject();
    movieObj.put("movieIdx", movie.getMovieIdx());
    movieObj.put("movieName", movie.getMovieName());
    movieObj.put("runningTime", movie.getRunningTime());
    movieObj.put("releaseDate", movie.getReleaseDate().toString()); // Date to String
    movieArray.add(movieObj);
}

// scthMap JSON 객체 생성
JSONObject scthMap = new JSONObject();
for (MovieDTO movie : todayMovieList) {
    List<ScheduleTheaterDTO> scthList = ss.searchtAllScheduleAndTheaterWithDate(movie.getMovieIdx(), todayDate);
    JSONArray scthArray = new JSONArray();
    
    for (ScheduleTheaterDTO scth : scthList) {
        JSONObject scthObj = new JSONObject();
        scthObj.put("scheduleIdx", scth.getScheduleIdx());
        scthObj.put("movieIdx", scth.getMovieIdx());
        scthObj.put("theaterType", scth.getTheaterType());
        scthObj.put("theaterName", scth.getTheaterName());
        scthObj.put("startTime", scth.getStartTime().toString());
        scthObj.put("remainSeats", scth.getRemainSeats());
        scthObj.put("scheduleStatus", scth.getScheduleStatus());
        scthArray.add(scthObj);
    }

    scthMap.put(String.valueOf(movie.getMovieIdx()), scthArray);
}

// 최종 result JSON
JSONObject result = new JSONObject();
result.put("movieList", movieArray);
result.put("scthMap", scthMap);

out.print(result.toJSONString());
%>
    