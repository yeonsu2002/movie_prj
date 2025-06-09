<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="kr.co.yeonflix.movie.saved.SavedMovieService"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// 로그인 여부 확인
MemberDTO userId = (MemberDTO) session.getAttribute("loginUser");

if (userId == null) {
    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
    out.print("{\"result\": \"fail\", \"message\": \"로그인이 필요합니다.\"}");
    return;
}

int userIdx = userId.getUserIdx();

// 파라미터 수신
String movieIdxStr = request.getParameter("movieIdx");
if (movieIdxStr == null || movieIdxStr.isEmpty()) {
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
    out.print("{\"result\": \"fail\", \"message\": \"영화 번호 누락\"}");
    return;
}

int movieIdx = Integer.parseInt(movieIdxStr);

System.out.println("userIdx : " + userIdx + " / movieIdx : " + movieIdx);
// 위시리스트 서비스 호출 (제거)
SavedMovieService sms = new SavedMovieService();
boolean success = sms.removeSavedMovie(movieIdx, userIdx);

if (success) {
    out.print("{\"result\": \"success\"}");
} else {
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
    out.print("{\"result\": \"fail\", \"message\": \"DB 오류\"}");
}
%>