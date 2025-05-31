<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.reservation.UserReservationDTO"%>
<%@page import="kr.co.yeonflix.reservation.ReservationService"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@page import="kr.co.yeonflix.theater.TheaterService"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.theater.TheaterDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />

<%
int scheduleIdx = Integer.parseInt(request.getParameter("scheduleParam"));
	
//스케줄 정보 가져오기
ScheduleService ss = new ScheduleService();
ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);
//상영관 정보 가져오기
int theaterIdx = schDTO.getTheaterIdx();
TheaterService ts = new TheaterService();
TheaterDTO tDTO = ts.searchTheaterWithIdx(theaterIdx);

//영화 정보 가져오기
int movieIdx = schDTO.getMovieIdx();
MovieService ms = new MovieService();
MovieDTO mDTO = ms.searchOneMovie(movieIdx);

//예매리스트 가져오기
ReservationService rs = new ReservationService();
List<UserReservationDTO> urDTOList = rs.searchUserReservationListBySchedule(scheduleIdx);

pageContext.setAttribute("schDTO", schDTO);
pageContext.setAttribute("tDTO", tDTO);
pageContext.setAttribute("mDTO", mDTO);
pageContext.setAttribute("urDTOList", urDTOList);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>예매 관리</title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">
<link rel="stylesheet" href="http://localhost/movie_prj/admin/reservation/css/reservation_manage.css">
<style type="text/css">
</style>
</head>
<body>
<div class="content-container">
<h2 class="title">예매 리스트</h2><br>
<p class="time-info">
  ${tDTO.theaterType} ${tDTO.theaterName}<br>
  ${mDTO.movieName }<br>
  상영 시각: <span class="start-time"><fmt:formatDate value="${schDTO.startTime}" pattern="HH:mm"/> ~ <fmt:formatDate value="${schDTO.endTime}" pattern="HH:mm"/></span><br>
  좌석 현황( <span class="reserved">${schDTO.remainSeats}</span> / 140 )
</p>

<button class="member-button">회원 ▼</button>

<table id="booking-table">
  <thead>
    <tr>
      <th>번호</th>
      <th>예매 번호</th>
      <th>예매 상태</th>
      <th>좌석 번호</th>
      <th>예매 날짜</th>
      <th>회원 여부</th>
      <th>아이디</th>
      <th>전화번호</th>
    </tr>
  </thead>
  <tbody>
  <c:forEach var="urDTO" items="${urDTOList}" varStatus="i">
  	<tr>
  		<td>${i.count}</td>
  		<td>${urDTO.reservationNumber}</td>
  	<c:choose>
  	<c:when test="${urDTO.canceledDate == null}">
  		<td>예매 완료</td>
  	</c:when>
  	<c:otherwise>
  		<td class="canceled">취소 완료</td>
  	</c:otherwise>
  	</c:choose>
  		<td>${urDTO.seatsInfo}</td>
  		<td><fmt:formatDate value="${urDTO.reservationDate}" pattern="yyy-MM-dd HH:mm"/></td>
  	<c:choose>
  		<c:when test="${urDTO.userType == 'MEMBER'}">
  			<td>회원</td>
  		</c:when>
  		<c:otherwise>
  			<td>비회원</td>
  		</c:otherwise>
  	</c:choose>
  		<td>${urDTO.memberId}</td>
  		<td>${urDTO.tel}</td>
  	</tr>
  </c:forEach>
  </tbody>
</table>
</div>
</body>
</html>
