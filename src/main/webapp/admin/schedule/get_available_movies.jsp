<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
Date screenDate = Date.valueOf(request.getParameter("screenDate"));

if(screenDate != null){
	try{
		ScheduleService ss = new ScheduleService();
		List<MovieDTO> movies = ss.getAvailableMoviesByDate(screenDate);
		
		JSONArray jsonArray = new JSONArray();
		for(MovieDTO movie : movies){
			JSONObject mJson = new JSONObject();
			mJson.put("movieIdx", movie.getMovieIdx());
			mJson.put("movieName", movie.getMovieName());
			jsonArray.add(mJson);
		}
		
		out.print(jsonArray.toJSONString());
	} catch(Exception e){
		e.printStackTrace();
		out.print("[]");
	}
} else{
	out.print("[]");
}
%>
