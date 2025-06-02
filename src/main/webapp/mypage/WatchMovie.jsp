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
<%
    // 로그인한 사용자 userIdx 가져오기
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

	if (loginUser == null) {
    // 로그인 안된 상태 -> 로그인 페이지로 이동
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
  gap: 20px;
  width: 100%;
}

.movie-card {
  width: calc((100% - 20px) / 2); /* gap 20px 고려해서 두 개 */
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.1);
  overflow: hidden;
  display: flex;
  flex-direction: row;
  align-items: center;
  padding: 20px;
  box-sizing: border-box;
}

.movie-poster img {
  width: 140px;     /* 기존: 100px */
  height: 200px;    /* 기존: 140px */
  object-fit: cover;
  border-radius: 5px;
  margin-right: 20px; /* 여백도 약간 더 */
}

.movie-info {
  display: flex;
  flex-direction: column;
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
  color: #999;
}

</style>
<script type="text/javascript">
</script>
</head>
<body>
<header>
<c:import url="http://localhost/movie_prj/common/jsp/header.jsp"/>
</header>
<main>
<div id="container">
  <div class="sidebar">
    <!-- 프로필 섹션 -->
    <div class="profile">
        <!-- 프로필 이미지 또는 아이콘 -->
        <img src="http://localhost/movie_prj/common/img/default_img.png"  class="profile-img" />
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
            <h1 class="content-title">내가 본 영화 <span class="movie-count">2건</span></h1>
        </div>
        <br><br>
       <div class="movie-grid">
  <c:forEach var="movie" items="${movieList}">
    <div class="movie-card">
      <div class="movie-poster">
        <img src="<c:out value='${movie.posterPath}'/>" alt="<c:out value='${movie.movieName}'/> 포스터" />
      </div>
      <div class="movie-info">
        <div class="movie-title"><c:out value="${movie.movieName}" /></div>
        <div class="movie-date">
          <c:out value="${movie.releaseDate}" /> 개봉 
          <c:out value="${movie.runningTime}" />분
        </div>
      </div>
    </div>
  </c:forEach>
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