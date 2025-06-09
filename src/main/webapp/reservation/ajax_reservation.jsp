<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleTheaterDTO"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="java.time.Duration"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="kr.co.yeonflix.reservedSeat.TempSeatDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatService"%>
<%@page import="kr.co.yeonflix.movie.code.MovieCommonCodeService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% 

Date todayDate = Date.valueOf(request.getParameter("date"));

//새로고침시 상영상태 변경
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

//모든 스케줄의 선점된 좌석들 5분이 지났으면 없애기
ReservedSeatService rss = new ReservedSeatService();
List<TempSeatDTO> tempSeatsList = rss.searchAllTempSeat();

if (tempSeatsList != null) {
	for (TempSeatDTO tempSeat : tempSeatsList) {
		LocalDateTime holdTime = tempSeat.getClickTime().toLocalDateTime();
		Duration d = Duration.between(holdTime, LocalDateTime.now());

		int seatIdx = tempSeat.getSeatIdx();
		int scheduleIdx = tempSeat.getScheduleIdx();

		//현재는 테스트용으로 1분으로 해놨으나 나중에 5분으로 변경
		if (d.toMinutes() >= 1) {
	boolean removed = rss.removeTempSeat(seatIdx, scheduleIdx);
	if (removed) {
		ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);
		schDTO.setRemainSeats(schDTO.getRemainSeats() + 1);
		ss.modifySchedule(schDTO);
	}
		}
	}
}

//해당 날짜의 상영스케줄 가져오기
List<ScheduleDTO> todayScheduleList = ss.searchAllScheduleWithDate(todayDate);

//해당 날짜에 상영하는 영화 목록 가져오기
List<MovieDTO> todayMovieList = ss.searchAllMovieWithSchedule(todayScheduleList);

//해당 날짜에 상영하는 영화가 가진 스케줄 및 상영관 정보
Map<Integer, List<ScheduleTheaterDTO>> scthMap = new HashMap<>();
for (MovieDTO mDTO : todayMovieList) {
	List<ScheduleTheaterDTO> scthList = ss.searchtAllScheduleAndTheaterWithDate(mDTO.getMovieIdx(), todayDate);
	
	// 상영관별로 그룹화한 후 각 그룹 내에서 startTime 순서로 정렬
	Collections.sort(scthList, new Comparator<ScheduleTheaterDTO>() {
		@Override
		public int compare(ScheduleTheaterDTO o1, ScheduleTheaterDTO o2) {
			// 먼저 상영관으로 그룹화 (theaterType + theaterName)
			String theater1 = o1.getTheaterType() + "_" + o1.getTheaterName();
			String theater2 = o2.getTheaterType() + "_" + o2.getTheaterName();
			int theaterCompare = theater1.compareTo(theater2);
			
			// 같은 상영관이면 startTime으로 정렬
			if (theaterCompare == 0) {
				return o1.getStartTime().compareTo(o2.getStartTime());
			}
			return theaterCompare;
		}
	});
	
	scthMap.put(mDTO.getMovieIdx(), scthList);
}

pageContext.setAttribute("todayScheduleList", todayScheduleList);
pageContext.setAttribute("todayMovieList", todayMovieList);
pageContext.setAttribute("scthMap", scthMap);

%>
<c:forEach var="tml" items="${todayMovieList}">
	<c:set var="selectedMovieIdx" value="${tml.movieIdx}" />
	<%
	//각 영화별 장르와 등급 가져오기
	int selectedMovieIdx = (Integer) pageContext.getAttribute("selectedMovieIdx");
	MovieCommonCodeService mccs = new MovieCommonCodeService();
	String genre = mccs.searchOneGenre(selectedMovieIdx);
	String grade = mccs.searchOneGrade(selectedMovieIdx);

	request.setAttribute("genre", genre);
	request.setAttribute("grade", grade);
	%>
	<div class="movie-item">
		<div class="movie-info">
			<div>
				<img src="http://localhost/movie_prj/common/img/icon_${grade}.svg" />&nbsp
			</div>
			<div class="movie-name">${tml.movieName}</div>
			<div class="meta">
				<span class="status">상영중</span> | ${genre} | ${tml.runningTime}분 |
				<fmt:formatDate value="${tml.releaseDate}" pattern="yyyy.MM.dd" />
				개봉
			</div>
		</div>
		<c:set var="previousKey" value="" />
		<c:forEach var="scth" items="${scthMap[tml.movieIdx]}">
			<c:set var="currentKey"
				value="${scth.theaterType}_${scth.theaterName}" />
			<c:if test="${currentKey != previousKey}">
				<c:set var="previousKey" value="${currentKey}" />

				<div class="theater-block">
					<div class="theater-info">⯈ ${scth.theaterType} |
						${scth.theaterName} | 총 140석</div>
					<div class="showtimes">
						<c:forEach var="scth2" items="${scthMap[tml.movieIdx]}">
							<c:if
								test="${scth2.theaterType == scth.theaterType && scth2.theaterName == scth.theaterName}">
								<c:choose>
									<c:when test="${scth2.scheduleStatus == 0}">
										<form action="reservation_seat.jsp" name="selectedSchedule"
											method="post">
											<div class="showtime">
												<fmt:formatDate value="${scth2.startTime}" pattern="HH:mm" />
												<br> <span>${scth2.remainSeats}석</span>
											</div>
											<input type="hidden" name="scheduleIdx"
												value="${scth2.scheduleIdx}" />
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