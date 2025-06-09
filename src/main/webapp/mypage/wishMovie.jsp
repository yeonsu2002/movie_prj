<%@page import="java.sql.Date"%>
<%@page import="kr.co.yeonflix.movie.saved.SavedMovieDTO"%>
<%@page import="kr.co.yeonflix.movie.saved.SavedMovieService"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.reservation.ReservationDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.purchaseHistory.PurchaseHistoryDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@page import="kr.co.yeonflix.reservation.ReservationService"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="kr.co.yeonflix.purchaseHistory.PurchaseHistoryService"%>
<%@page import="kr.co.yeonflix.member.MemberDAO"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    
   ///내가 찜한 영화/////
   
   SavedMovieService sms=new SavedMovieService();
   List<SavedMovieDTO> saveMovieList=sms.savedAllMovie(loginUserIdx);
   request.setAttribute("saveMovieList", saveMovieList); 
   
   
   
   
  
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기대되는 영화</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
<style>
#container {
  min-height: 650px;
  margin: 30px auto;
  max-width: 1200px;
  display: flex;
}

/* 좌측 사이드바 */
.sidebar {
  width: 250px;
  border-right: 1px solid #e0e0e0;
  padding: 20px 10px;  /* 위아래 여백 추가 */
  margin-right: 50px;
  position: relative;
  min-height: 100%;
  background-color: #fff;  /* 흰 배경 */
  box-shadow: 2px 0 5px rgba(0,0,0,0.05);
  border-radius: 5px;
}

/* 프로필 */
.profile {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.profile-img {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  margin-bottom: 10px;
  object-fit: cover;
}

.profile-info {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.profile-id {
  display: block;
  margin-top: 3px;
  font-size: 14px;
  color: gray;
}

/* 버튼 기본 스타일 */
.btn {
  display: inline-block;
  padding: 12px 0;
  margin: 10px 0;
  width: 230px;
  border-radius: 5px;
  text-decoration: none;
  font-weight: 600;
  cursor: pointer;
  text-align: center;
  font-size: 16px;
  box-sizing: border-box;
  user-select: none;
  transition: background-color 0.3s, color 0.3s;
}

/* 연한 버튼 스타일 */
.btn-light {
  background-color: #f8f9fa;
  color: #212529;
  border: 1px solid #ced4da;
}

.btn-light:hover {
  background-color: #e2e6ea;
  color: #212529;
}

/* 강조 버튼 스타일 */
.btn-danger {
  background-color: #dc3545;
  color: white;
  border: none;
}

.btn-danger:hover {
  background-color: #c82333;
}

/* 사이드바 하단 고정 버튼 */
.fixed-btn {
  position: absolute;
  bottom: 20px;
  left: 10px;
  width: 230px;
  height: 40px;
  background-color: #f8f9fa;
  border: 1px solid #ccc;
  text-align: center;
  line-height: 40px;
  border-radius: 5px;
  text-decoration: none;
  color: black;
  font-weight: 600;
  user-select: none;
  transition: background-color 0.3s;
}

.fixed-btn:hover {
  background-color: #e2e6ea;
}

/* 우측 콘텐츠 영역 */
.header-container {
  flex: 1;
}

.main-content {
  padding: 20px;
  margin-left: 0; /* 사이드바와 flex 구조라 필요 없음 */
}
.empty-content {
  display: flex;
  flex-direction: column;
  justify-content: center; /* 세로 가운데 정렬 */
  align-items: center;     /* 가로 가운데 정렬 */
  height: 100%;            /* 부모 높이에 따라 조정 가능 */
  text-align: center;      /* 텍스트도 중앙 정렬 */
  padding: 40px;
  background-color: white;
  border-radius: 5px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.main-content {
  padding: 20px;
  margin-left: 0; /* 사이드바와 flex 구조라 필요 없음 */
}

.movie-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 30px;
  justify-content: flex-start;
}
.movie-card {
  flex: 0 0 calc(50% - 15px);
  max-width: calc(50% - 15px);
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  padding: 20px 20px;
  box-sizing: border-box;
  transition: transform 0.2s ease;
  width: 180px;
}


.movie-card img {
  width: 180px;          /* 폭은 고정 */
  height: 270px;         
  object-fit: cover;     /* 비율에 맞춰 자르기 */
  margin-bottom: 15px;
  border-radius: 8px;
}

.movie-info {
  width: 180%; /* 너비를 100%로 설정해서 movie-card에 맞게 조정 */
  padding: 10px 0; /* 상하 여백만 적용 */
  text-align: center;
  word-break: keep-all;
  background-color: white;
  border-radius: 8px;
}
}

.movie-title {
  font-size: 16px;
  font-weight: bold;
  line-height: 1.4;
  white-space: normal;
  word-break: keep-all;
  margin-bottom: 6px;
}

.movie-date {
  font-size: 13px;
  color: #666;
  line-height: 1.4;
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
    <a href="http://localhost/movie_prj/mypage/wishMovie.jsp" class="btn btn-danger" style="width:230px; height:50px">기대되는 영화</a>
	<a href="http://localhost/movie_prj/mypage/WatchMovie.jsp" class="btn btn-light" style="width:230px; height:50px">내가 본 영화</a>
	<a href="http://localhost/movie_prj/mypage/ReviewMovie.jsp" class="btn btn-light" style="width:230px; height:50px">내가 쓴 평점</a>
	<a href="http://localhost/movie_prj/mypage/MainPage.jsp" class="fixed-btn" style="width:230px; height:40px;  margin-top: 280px;">뒤로</a>
  </div>
  
  
   <div class="header-container">

   <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="content-header">
            <h1 class="content-title" style="font-size: 30px; font-weight:bold;">내가 찜한 영화 <span class="movie-count">${fn:length(saveMovieList)}건</span></h1>
        </div>
        <br><br>
       <div class="movie-grid">
		 <c:choose>
    <c:when test="${empty saveMovieList}">
        <div class="empty-content">
            <p>기대되는 영화가 없습니다.</p><br>
            <p>영화 상세 페이지에서 '기대돼요!'를 선택하여 영화를 추가해보세요.</p>
            <a href="http://localhost/movie_prj/movie_chart/main_chart.jsp" type="button" class="btn btn-danger mt-3">무비 차트</a>
        </div>
    </c:when>
    <c:otherwise>
        <c:forEach var="movie" items="${saveMovieList}">
            <div class="movie-card">
                <div class="movie-poster">
                    <img src="/movie_prj/common/img/${movie.posterPath}"/>
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