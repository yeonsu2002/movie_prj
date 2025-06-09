<%@page import="kr.co.yeonflix.theater.TheaterDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.theater.TheaterService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
TheaterService ths = new TheaterService();
List<TheaterDTO> theaterList = ths.searchAllTheater();

pageContext.setAttribute("theaterList", theaterList);
%>
<c:forEach var="list" items="${theaterList}" varStatus="i">
	<tr>
		<td><span class="theater-type">${list.theaterType}</span></td>
		<td><span class="theater-name">${list.theaterName}</span></td>
		<td><span class="movie-price">${list.moviePrice}</span></td>
		<td><span class="seat-count">140석</span></td>
		<td><span class="empty-note">-</span></td>
	</tr>
</c:forEach>