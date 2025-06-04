<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page import="java.util.List" %>
<%@ page import="kr.co.yeonflix.review.ReviewDTO" %>

<%
    String movieId = request.getParameter("movieId");
    List<ReviewDTO> reviewList = null;

    try {
        reviewList = kr.co.yeonflix.review.ReviewDAO.getInstance().selectReviewsByMovieId(movieId);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 목록</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">리뷰 목록</h2>
    <table class="table table-bordered table-hover">
        <thead class="table-light">
            <tr>
                <th>리뷰 번호</th>
                <th>작성자 ID</th>
                <th>영화 번호</th>
                <th>리뷰 내용</th>
                <th>평점</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty reviewList}">
                    <c:forEach var="review" items="${reviewList}">
                        <tr>
                            <td>${review.reviewId}</td>
                            <td>${review.userId}</td>
                            <td>${review.movieId}</td>
                            <td>${review.content}</td>
                            <td>${review.rating}</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5" class="text-center">작성된 리뷰가 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <a href="movieDetail.jsp?movieId=${param.movieId}" class="btn btn-primary">영화 상세로 돌아가기</a>
</div>
</body>
</html>
