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
String col = request.getParameter("col");
String key = request.getParameter("key");
	
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
List<UserReservationDTO> urDTOList = rs.searchUserReservationListBySchedule(scheduleIdx, col, key);

//페이징


pageContext.setAttribute("schDTO", schDTO);
pageContext.setAttribute("tDTO", tDTO);
pageContext.setAttribute("mDTO", mDTO);
pageContext.setAttribute("urDTOList", urDTOList);
pageContext.setAttribute("scheduleIdx", scheduleIdx);
pageContext.setAttribute("col", col);
pageContext.setAttribute("key", key);


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
<link rel="stylesheet" type="text/css"
href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css">
 <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@docsearch/css@3">
 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<style type="text/css">

</style>
</head>
<body>
<div class="content-container">
<h2 class="page-title">📋 예매 관리</h2>

<!-- 영화 정보 카드 -->
<div class="movie-info-card">
    <div class="theater-badge">🎬 ${tDTO.theaterType}</div>
    <div class="movie-title">${mDTO.movieName}</div>
    
    <div class="movie-details">
        <div class="detail-item">
            <div class="detail-label">상영관</div>
            <div class="detail-value">${tDTO.theaterName}</div>
        </div>
        
        <div class="detail-item">
            <div class="detail-label">시작 시간</div>
            <div class="detail-value">
                <fmt:formatDate value="${schDTO.startTime}" pattern="HH:mm"/>  
            </div>
        </div>
        
        <div class="detail-item">
            <div class="detail-label">상영 날짜</div>
            <div class="detail-value"><fmt:formatDate value="${schDTO.screenDate}" pattern="yyyy-MM-dd"/></div>
        </div>
        
        <div class="detail-item">
            <div class="detail-label">종료 시간</div>
            <div class="detail-value">
                <fmt:formatDate value="${schDTO.endTime}" pattern="HH:mm"/>
            </div>
        </div>
        
        <div class="seats-status">
            <div class="detail-label">좌석 현황</div>
            <div class="seats-count">${schDTO.remainSeats} / 140</div>
        </div>
    </div>
</div>

<!-- 검색 섹션 -->
<div class="search-section">
<form name="search" method="post" action="" style="display:inline-block;">
<select name="col" class="member-button">
	<option value="memberId" ${col == 'memberId' ? 'selected' : ''}>아이디</option>
	<option value="tel"  ${col == 'tel' ? 'selected' : ''}>전화번호</option>
	<option value="reservationNumber" ${col == 'reservationNumber' ? 'selected' : ''}>예매번호</option>
</select>
	<input type="text" name="key" class="member-button" value="${key}" placeholder="검색어를 입력하세요"/>
	<input type="submit" value="🔍 검색"  class="member-button"/>
	<input type="hidden" name="scheduleParam" value="${scheduleIdx}"/>
</form>
<form name="reset" method="post" action=""  style="display:inline-block;">
	<input type="submit" value="🔄 초기화"  class="member-button"/>
	<input type="hidden" name="scheduleParam" value="${scheduleIdx}"/>
</form>
</div>

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
      <th>결제금액</th>
    </tr>
  </thead>
  <tbody>
  <c:forEach var="urDTO" items="${urDTOList}" varStatus="i">
  	<tr>
  		<td>${i.count}</td>
  		<td>${urDTO.reservationNumber}</td>
  	<c:choose>
  	<c:when test="${urDTO.canceledDate == null}">
  		<td>✅ 예매 완료</td>
  	</c:when>
  	<c:otherwise>
  		<td class="canceled">❌ 취소 완료</td>
  	</c:otherwise>
  	</c:choose>
  		<td>${urDTO.seatsInfo}</td>
  		<td><fmt:formatDate value="${urDTO.reservationDate}" pattern="yyy-MM-dd HH:mm"/></td>
  	<c:choose>
  		<c:when test="${urDTO.userType == 'MEMBER'}">
  			<td>👤 회원</td>
  		</c:when>
  		<c:otherwise>
  			<td>👥 비회원</td>
  		</c:otherwise>
  	</c:choose>
  		<td>${urDTO.memberId}</td>
  		<td>${urDTO.tel}</td>
  		<td><fmt:formatNumber value="${urDTO.seatsCnt * tDTO.moviePrice}" type="number" groupingUsed="true"/>원</td>
  	</tr>
  </c:forEach>
  </tbody>
</table>
<br>
<div class="d-flex justify-content-center mt-3">
<nav aria-label="Page navigation example" style="text-align:center">
  <ul class="pagination ">
  	<%-- <c:forEach var="i" begin="1" end="${totalPage}"> --%>
    <li class="page-item"><a class="page-link" href="#">1</a></li>
    <%-- </c:forEach> --%>
  </ul>
</nav>
</div>
</div>
</body>
</html>