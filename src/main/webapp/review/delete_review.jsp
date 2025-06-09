<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="kr.co.yeonflix.review.ReviewService" %>
<%@ page import="java.io.IOException" %>

<%
    // 1. 로그인 여부 확인
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login/loginFrm.jsp");
        return;
    }

    // 2. 파라미터 받기
    String reviewIdParam = request.getParameter("reviewId");
    String movieIdParam = request.getParameter("movieId");

    if (reviewIdParam == null || movieIdParam == null) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }

    int reviewId = 0;
    int movieId = 0;

    try {
        reviewId = Integer.parseInt(reviewIdParam);
        movieId = Integer.parseInt(movieIdParam);
    } catch (NumberFormatException e) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }

    // 3. 리뷰 삭제 서비스 호출
    ReviewService reviewService = new ReviewService();
    boolean deleted = false;
    try {
        deleted = reviewService.removeReview(reviewId);
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('서버 오류가 발생했습니다.'); history.back();</script>");
        return;
    }

    // 4. 결과 처리
    if (deleted) {
        // 삭제 성공하면 영화 상세 페이지로 리다이렉트
        response.sendRedirect("movie_chart/movieDetail.jsp?movieIdx=" + movieId);
    } else {
        // 삭제 실패 시 경고 후 이전 페이지로 이동
        out.println("<script>alert('삭제 권한이 없거나 삭제에 실패했습니다.'); history.back();</script>");
    }
%>
