<%@page import="kr.co.yeonflix.review.ReviewService"%>
<%@page import="kr.co.yeonflix.review.ReviewDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
request.setCharacterEncoding("UTF-8");

// 파라미터 수신 (String으로 받기)
String movieIdStr = request.getParameter("movieId");
String content = request.getParameter("content");
String scoreStr = request.getParameter("score");
double rating = Double.parseDouble(request.getParameter("rating"));

// 파라미터 변환
int movieId = 0;
try {
    movieId = Integer.parseInt(movieIdStr);
} catch (Exception e) {
    movieId = 0; // 기본값 또는 오류 처리
}

int score = 0;
try {
    score = Integer.parseInt(scoreStr);
} catch (Exception e) {
    score = 0;
}

// 사용자 ID (세션에서 꺼내기, 숫자형으로 변환)
Integer userId = null;
Object sessionUserId = session.getAttribute("userId");
if (sessionUserId != null) {
    try {
        // 세션에 저장된 userId가 String일 수도, Integer일 수도 있으니 확인
        if (sessionUserId instanceof String) {
            userId = Integer.parseInt((String) sessionUserId);
        } else if (sessionUserId instanceof Integer) {
            userId = (Integer) sessionUserId;
        }
    } catch (Exception e) {
        userId = null;
    }
}

// 로그인 체크
/* if (userId == null) {
    out.println("<script>alert('로그인이 필요합니다.'); location.href='/movie_prj/login/loginFrm.jsp';</script>");
    return;
} */

// DTO 생성 및 데이터 설정
if(userId == null){
	
userId = 1; 
}

ReviewDTO dto = new ReviewDTO();

dto.setMovieId(movieId);
dto.setContent(content);
dto.setRating(rating);
dto.setUserId(userId);

// Service를 통해 DB 저장
ReviewService service = new ReviewService();
boolean result = service.addReview(dto);

if (result) {
    // 저장 성공 시 영화 상세 페이지로 리다이렉트
    response.sendRedirect("/movie_prj/lee/movie_review.jsp? movieId=" + movieId);
} else {
    // 저장 실패 시 경고창
    out.println("<script>alert('리뷰 저장에 실패했습니다.'); history.back();</script>");
}
%>
