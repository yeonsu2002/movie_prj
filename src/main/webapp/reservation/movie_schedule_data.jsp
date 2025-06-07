<%@page import="kr.co.yeonflix.reservedSeat.TempSeatDTO"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleTheaterDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="java.sql.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
// 클릭한 날짜 parameter로 가져오기
Date todayDate = null;
String dateParam = request.getParameter("date");

if (dateParam != null && !dateParam.isEmpty()) {
    todayDate = Date.valueOf(dateParam);
} else {
    // 오늘 날짜를 기본값으로 설정
    todayDate = new Date(System.currentTimeMillis());
}

// 해당 날짜의 상영스케줄 가져오기
ScheduleService ss = new ScheduleService();
List<ScheduleDTO> todayScheduleList = ss.searchAllScheduleWithDate(todayDate);

// 해당 날짜에 상영하는 영화 목록 가져오기
List<MovieDTO> todayMovieList = ss.searchAllMovieWithSchedule(todayScheduleList);

// 해당 날짜에 상영하는 영화가 가진 스케줄 및 상영관 정보
Map<Integer, List<ScheduleTheaterDTO>> scthMap = new HashMap<>();
for (MovieDTO mDTO : todayMovieList) {
    List<ScheduleTheaterDTO> scthList = ss.searchtAllScheduleAndTheaterWithDate(mDTO.getMovieIdx(), todayDate);
    scthMap.put(mDTO.getMovieIdx(), scthList);
}

pageContext.setAttribute("todayMovieList", todayMovieList);
pageContext.setAttribute("scthMap", scthMap);
%>

<!-- Movie items (Ajax로 로드될 부분) -->
<c:forEach var="tml" items="${todayMovieList}">
    <div class="movie-item">
        <div class="movie-info">
            <div>
                <img src="http://localhost/movie_prj/common/img/icon_15.svg" />&nbsp
            </div>
            <div class="movie-name">${tml.movieName}</div>
            <div class="meta">
                <span class="status">상영중</span> | 장르 / ${tml.runningTime}분 /
                <fmt:formatDate value="${tml.releaseDate}" pattern="yyyy.MM.dd" />
                개봉
            </div>
        </div>
        <c:set var="previousKey" value="" />
        <c:forEach var="scth" items="${scthMap[tml.movieIdx]}">
            <c:set var="currentKey" value="${scth.theaterType}_${scth.theaterName}" />
            <c:if test="${currentKey != previousKey}">
                <c:set var="previousKey" value="${currentKey}" />

                <div class="theater-block">
                    <div class="theater-info">⯈ ${scth.theaterType} |
                        ${scth.theaterName} | 총 140석</div>
                    <div class="showtimes">
                        <c:forEach var="scth2" items="${scthMap[tml.movieIdx]}">
                            <c:if test="${scth2.theaterType == scth.theaterType && scth2.theaterName == scth.theaterName}">
                                <c:choose>
                                    <c:when test="${scth2.scheduleStatus == 0}">
                                        <form action="reservation_seat.jsp" name="selectedSchedule" method="post">
                                            <div class="showtime">
                                                <fmt:formatDate value="${scth2.startTime}" pattern="HH:mm" />
                                                <br> <span>${scth2.remainSeats}석</span>
                                            </div>
                                            <input type="hidden" name="scheduleIdx" value="${scth2.scheduleIdx}" />
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="showtime-end">
                                            <fmt:formatDate value="${scth2.startTime}" pattern="HH:mm" />
                                            <br> <span>마감</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </c:forEach>

        <br> <br>
    </div>
    <br>
    <br>
</c:forEach>
<br> <br>
<p class="info_screen">[공지]입장 지연에 따른 관람 불편을 최소화하기 위해 영화는 10분 후 상영이 시작됩니다.</p>