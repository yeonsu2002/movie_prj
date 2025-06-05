<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Admin review management page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="kr.co.yeonflix.review.*" %>
<%@ page import="java.util.*" %>

<%
String keyword = request.getParameter("keyword"); // 
ReviewService reviewService = new ReviewService();
List<ReviewDTO> reviewList;

if (keyword != null && !keyword.trim().isEmpty()) {
    reviewList = reviewService.searchReviewsByUserId(keyword.trim());
} else {
 
    reviewList = reviewService.getAllReviews(); 
}
request.setAttribute("reviewList", reviewList);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 영화 리뷰 관리</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
<style>
 * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Noto Sans KR', sans-serif;
}
body {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
    background-color: #f5f5f5;
}
.sidebar {
    width: 250px;
    background-color: #f9f9f9;
    padding: 20px;
    box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
    position: fixed;
    left: 0;
    top: 0;
    bottom: 0;
    overflow-y: auto;
}
.content-container {
    margin-left: 250px;
    padding: 30px;
    background-color: #f9fafb;
    flex-grow: 1;
}
h2 {
    margin-bottom: 20px;
    font-size: 22px;
}
.review-table {
    width: 100%;
    border-collapse: collapse;
    background-color: #fff;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}
.review-table thead {
    background-color: #f3f4f6;
}
.review-table th, .review-table td {
    padding: 12px;
    text-align: center;
    border-bottom: 1px solid #e5e7eb;
}
.review-table th {
    font-weight: bold;
    color: #374151;
}
.review-table a {
    color: #3b82f6;
    text-decoration: none;
}
.menu-category {
    margin-bottom: 20px;
}
.menu-title {
    background-color: #a3a3ad;
    color: #fff;
    padding: 6px 10px;
    font-weight: bold;
    font-size: 14px;
}
.menu-item {
    padding: 6px 10px;
    font-size: 13px;
    color: #333;
    cursor: pointer;
}
.menu-item:hover {
    background-color: #e5e5e5;
}
.menu-item.active {
    color: red;
    font-weight: bold;
}
.search-form {
    margin-bottom: 20px;
}
.search-form input[type="text"] {
    padding: 6px;
    width: 200px;
    border: 1px solid #ccc;
    border-radius: 3px;
}
.search-form button {
    padding: 6px 12px;
    background-color: #3b82f6;
    color: #fff;
    border: none;
    border-radius: 3px;
    cursor: pointer;
}
</style>
</head>
<body>
<header>
<%@ include file="/common/jsp/external_file.jsp" %>
</header>
<main>
<div id="container">
    <div class="sidebar">
        <div class="menu-category">
            <div class="menu-title">회원관리</div>
            <div class="menu-item">▶ 회원목록</div>
        </div>
        <div class="menu-category">
            <div class="menu-title">상영관 관리</div>
            <div class="menu-item">▶ 상영관 목록</div>
            <div class="menu-item">▶ 상영관 등록</div>
        </div>
        <div class="menu-category">
            <div class="menu-title">영화관리</div>
            <div class="menu-item">▶ 영화 리스트</div>
            <div class="menu-item">▶ 영화 등록</div>
            <div class="menu-item active">▶ 영화 리뷰 관리</div>
        </div>
        <div class="menu-category">
            <div class="menu-title">상영관리</div>
            <div class="menu-item">▶ 상영스케줄 관리</div>
            <div class="menu-item">▶ 상영등록</div>
        </div>
        <div class="menu-category">
            <div class="menu-title">문의관리</div>
            <div class="menu-item">▶ 공지/뉴스</div>
            <div class="menu-item">▶ 1:1문의</div>
        </div>
    </div>

    <div class="content-container">
        <h2>영화 리뷰 관리</h2>

        <!-- 검색 폼 -->
        <form class="search-form" method="get" action="admin_review.jsp">
            <input type="text" name="keyword" placeholder="회원 ID로 검색" value="<%= keyword != null ? keyword : "" %>">
            <button type="submit">검색</button>
        </form>

        <!-- 리뷰 목록 테이블 -->
        <table class="review-table">
            <thead>
                <tr>
                    <th>선택</th>
                    <th>리뷰 ID</th>
                    <th>영화 ID</th>
                    <th>작성자 ID</th>
                    <th>리뷰 내용</th>
                    <th>작성일</th>
                    <th>평점</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="review" items="${reviewList}">
                    <tr>
                        <td><input type="checkbox" name="reviewIds" value="${review.reviewId}"></td>
                        <td>${review.reviewId}</td>
                        <td>${review.movieId}</td>
                        <td>${review.userId}</td>
                        <td>${review.content}</td>
                        <td>${review.writeDate}</td>
                        <td>${review.rating}</td>
                    </tr>
                </c:forEach>

                <c:if test="${empty reviewList}">
                    <tr>
                        <td colspan="7">검색 결과가 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <!-- 이후 삭제버튼을 만들어, 체크된 리뷰들을 삭제할 수 있도록 하면 됩니다. -->

    </div>
</div>
</main>
<footer>
<c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
</footer>
</body>
</html>
