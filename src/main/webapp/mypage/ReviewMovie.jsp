<%@page import="kr.co.yeonflix.review.ReviewService"%>
<%@page import="kr.co.yeonflix.review.ReviewDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.member.MemberDAO"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    
    
    ReviewService rs=new ReviewService();
    List<ReviewDTO> reviewList = rs.getReviewsMyMovie(loginUserIdx);
    request.setAttribute("reviewList", reviewList);
    
    
 %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내가 쓴 리뷰</title>
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
  padding: 0 10px;
  margin-right: 50px;
  position: relative;
  min-height: 100%;
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

/* 우측 메인 콘텐츠 영역 */
.header-container {
  flex: 1;
}

.main-content {
  padding: 20px;
  margin-left: 0; /* 사이드바가 flex로 따로 있으니 margin-left 필요 없음 */
}

.content-header h1 {
  font-size: 30px;
  font-weight: bold;
}

/* 리뷰 테이블 */
.review-table-container table {
  width: 100%;
  border-collapse: collapse;
}

.review-table-container th, .review-table-container td {
  border: 1px solid #ddd;
  padding: 10px;
  text-align: center;
  vertical-align: middle;
}

.review-table-container th {
  background-color: #f8f9fa;
  font-weight: bold;
}

/* 빈 데이터 표시 */
.empty-content {
  text-align: center;
  padding: 40px;
  background-color: white;
  border-radius: 5px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

/* 버튼 */
.btn {
  display: inline-block;
  padding: 10px 20px;
  margin: 5px 0;
  border-radius: 4px;
  text-decoration: none;
  font-weight: 600;
  cursor: pointer;
}

.btn-danger {
  background-color: #dc3545;
  color: white;
  border: none;
}

.btn-danger:hover {
  background-color: #c82333;
}

.btn-light {
  background-color: #f8f9fa;
  color: #212529;
  border: 1px solid #ced4da;
}

.btn-light:hover {
  background-color: #e2e6ea;
}

/* 고정 버튼 */
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
  transition: background-color 0.3s;
}

.fixed-btn:hover {
  background-color: #e2e6ea;
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
<a href="http://localhost/movie_prj/mypage/WatchMovie.jsp" class="btn btn-light" style="width:230px; height:50px">내가 본 영화</a>
<a href="http://localhost/movie_prj/mypage/ReviewMovie.jsp" class="btn btn-danger" style="width:230px; height:50px">내가 쓴 평점</a>
<a href="http://localhost/movie_prj/mypage/MainPage.jsp" class="fixed-btn" style="width:230px; height:40px;  margin-top: 280px;">뒤로</a>
  </div>
  
  <div class="header-container">
  <!-- 메인 콘텐츠 -->
  <div class="main-content">
    <div class="content-header">
      <h1 class="content-title" style="font-size: 30px; font-weight:bold;">
        내가 쓴 리뷰 <span class="review-count">${fn:length(reviewList)}건</span>
      </h1>
    </div>
    <br><br>
    <div class="review-table-container">
      <table border="1" cellpadding="10" cellspacing="0" style="width:100%; border-collapse: collapse;">
  <thead>
    <tr>
      <th>포스터</th>
      <th>영화 제목</th>
      <th>평점</th>
      <th>리뷰 내용</th>
      <th>작성일</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="review" items="${reviewList}">
      <tr>
		<td><img src="/movie_prj/common/img/${review.movieDTO.posterPath}"  style="width:50px;"/></td>
        <td><c:out value="${review.movieDTO.movieName}" /></td>
        <td><c:out value="${review.rating}" /></td>
        <td><c:out value="${review.content}" /></td>
        <td><c:out value="${review.writeDate}" /></td>
      </tr>
    </c:forEach>
    <c:if test="${empty reviewList}">
      <tr>
        <td colspan="4" style="text-align:center;">작성한 리뷰이 없습니다.</td>
      </tr>
    </c:if>
  </tbody>
</table>
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