<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@page import="kr.co.yeonflix.reservation.ReservationService"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.reservation.ReservationDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="kr.co.yeonflix.purchaseHistory.PurchaseHistoryDTO"%>
<%@page import="kr.co.yeonflix.purchaseHistory.PurchaseHistoryService"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.member.MemberDAO"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%

MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
if (loginUser == null) {
    response.sendRedirect(request.getContextPath() + "/login/loginFrm.jsp");
    return;
}
	int loginUserIdx = loginUser.getUserIdx();

    // 회원 정보 조회
    MemberService ms = new MemberService();
    MemberDAO mm=MemberDAO.getInstance();
    MemberDTO mDTO=mm.selectOneMember(loginUserIdx);

    // JSP에 member 객체 넘기기
    request.setAttribute("member", mDTO);
 
    
    PurchaseHistoryService phs = new PurchaseHistoryService();
    ReservationService rs = new ReservationService();
    ScheduleService ss = new ScheduleService();
    MovieService mov = new MovieService();

    List<PurchaseHistoryDTO> purchList = phs.searchAllPurchasebyUser(loginUserIdx);
    List<MovieDTO> movieList = new ArrayList<>();

    for (PurchaseHistoryDTO pDto : purchList) {
        int reservationIdx = pDto.getReservationIdx();

        ReservationDTO rDto = rs.searchOneSchedule(reservationIdx);
        if (rDto == null) continue;

        int scheduleIdx = rDto.getScheduleIdx();
        ScheduleDTO schDto = ss.searchOneSchedule(scheduleIdx);
        if (schDto == null) continue;

        int movieIdx = schDto.getMovieIdx();
        MovieDTO movDto = mov.searchOneMovie(movieIdx);
        if (movDto == null) continue;

        movieList.add(movDto); 
    }

    request.setAttribute("movieList", movieList);

 %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
<style>
  #container {
  min-height: 650px;
  margin: 30px auto; /* 위아래 여백 + 가운데 정렬 */
  max-width: 1200px;  /* 최대 너비 제한 */
  display: flex;
}

/* 좌측 사이드바 스타일 */
.sidebar {
  width: 250px;
  border-right: 1px solid #e0e0e0;
  padding: 0 10px;
}

/* 우측 콘텐츠 영역 */
.content-area {
  flex: 1;
  padding: 20px;
}
 
 
 
 .profile {
 display: flex;
  flex-direction: column;      /* 세로로 쌓기 */
  align-items: center;         /* 중앙 정렬 */
  text-align: center;
 }
 

 
 .profile-info {
   display: flex;
   flex-direction: column;
   justify-content: center;
 }
 
 
 .profile-id {
   display: block;              /* 줄바꿈 */
  margin-top: 3px;             /* 각 라인 간격 */
  font-size: 14px;
  color: gray;
 }
 
 
 
 
 .content-area {
   margin-left: 270px;
   padding: 20px;
 }
 

 
 .empty-content {
   text-align: center;
   padding: 40px;
   background-color: white;
   border-radius: 5px;
   box-shadow: 0 2px 5px rgba(0,0,0,0.1);
 }
 
 
 .profile-img {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  margin-bottom: 10px; 
  }
.movie-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 30px;
  justify-content: space-between;
}

.movie-card {
  flex: 1 1 200px;
  max-width: 220px;
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  display: flex;
  flex-direction: column; /* 수직 방향 */
  align-items: center;
  text-align: center;
  padding: 20px;
  box-sizing: border-box;
  transition: transform 0.2s ease;
}

.movie-card:hover {
  transform: translateY(-5px);
}

.movie-card img {
  width: 180px;          /* 폭은 고정 */
  height: 270px;         /* ✅ 세로를 더 길게 */
  object-fit: cover;     /* 비율에 맞춰 자르기 */
  margin-bottom: 15px;
  border-radius: 8px;
}

.movie-info h3 {
  font-size: 18px;
  margin: 10px 0 6px;
}

.movie-info p {
  font-size: 14px;
  line-height: 1.5;
  margin: 0;
}
.movie-title {
  font-size: 18px;
  font-weight: bold;
}
.movie-genre {
  font-size: 14px;
  color: #666;
  margin: 5px 0;
}
.movie-date {
  font-size: 13px;
  color: #666;
}

</style>
<script type="text/javascript">
</script>
</head>
<body>
<header>
	<jsp:include page="../common/jsp/header.jsp"/>
</header>
<main>
<div id="container">
  <div class="sidebar">
    <!-- 프로필 섹션 -->
    <div class="profile">
        <!-- 프로필 이미지 또는 아이콘 -->
        <img src="/profile/${member.picture}" class="profile-img" />
      <div class="profile-info">
       <h2><c:out value="${member.userName}" /></h2>
        <span class="profile-id">아이디: <c:out value="${member.memberId}" /></span>
        <span class="profile-id">닉네임: <c:out value="${member.nickName}" /></span>
      </div>
    </div>
    <br><br>
    <a href="http://localhost/movie_prj/mypage/wishMovie.jsp" class="btn btn-light" style="width:230px; height:50px">기대되는 영화</a>
	<a href="http://localhost/movie_prj/mypage/WatchMovie.jsp" class="btn btn-danger" style="width:230px; height:50px">내가 본 영화</a>
	<a href="http://localhost/movie_prj/mypage/ReviewMovie.jsp" class="btn btn-light" style="width:230px; height:50px">내가 쓴 평점</a>
  </div>
  
  
   <div class="header-container">

   <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="content-header">
            <h1 class="content-title" style="font-size: 20px; font-weight:bold;">내가 본 영화 <span class="movie-count">${fn:length(movieList)}건</span></h1>
        </div>
        <br><br>
       <div class="movie-grid">
		 <c:choose>
		  <c:when test="${empty movieList}">
		   <p style="font-size: 25px;"><strong>본 영화가 없습니다.</strong></p>
		  </c:when>
		  <c:otherwise>
		    <c:forEach var="movie" items="${movieList}">
		      <div class="movie-card">
		        <div class="movie-poster">
		          <img src="<c:out value='${movie.posterPath}'/>" alt="<c:out value='${movie.movieName}'/> 포스터" />
		        </div>
		        <br>
		        <div class="movie-info">
		          <div class="movie-title"><c:out value="${movie.movieName}" /></div>
		          <br>
		          <div class="movie-date">
		            <c:out value="${movie.releaseDate}" /> 개봉 
		            <c:out value="${movie.runningTime}" />분
		          </div>
		        </div>
		      </div>
		    </c:forEach>
		  </c:otherwise>
		</c:choose>
</div>
    </div>
</div>
</div>
</main>
<footer>
<c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
</footer>
</body>
</html>