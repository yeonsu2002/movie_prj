<%@ page import="kr.co.yeonflix.review.ReviewDTO" %>
<%@ page import="kr.co.yeonflix.review.ReviewService" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
request.setCharacterEncoding("UTF-8");

// 파라미터 추출
int reviewId = Integer.parseInt(request.getParameter("reviewId"));
int movieId = Integer.parseInt(request.getParameter("movieId"));
int rating = Integer.parseInt(request.getParameter("rating"));
String content = request.getParameter("content");

// DTO 생성
ReviewDTO dto = new ReviewDTO();
dto.setReviewId(reviewId);
dto.setMovieId(movieId);
dto.setRating(Double.valueOf(rating));
dto.setContent(content);

// 서비스 호출
ReviewService service = new ReviewService();
int result = 0;
try {
    result = service.updateReview(dto);
} catch (Exception e) {
    e.printStackTrace();
}

// 결과 처리
if (result > 0) {
    response.sendRedirect(request.getContextPath() + "/movie/movie_detail.jsp?movieIdx=" + movieId + "&tabType=review");
} else {
%>
    <div style="text-align:center; margin-top:50px; color:red;">
        리뷰 수정에 실패했습니다. <a href="javascript:history.back();">뒤로가기</a>
    </div>
<%
}
%>
