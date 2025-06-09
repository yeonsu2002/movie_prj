<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="kr.co.yeonflix.movie.saved.SavedMovieService"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// 로그인 여부 확인
MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

if (loginUser == null) {
    // 로그인하지 않은 경우 - 위시리스트에 없다고 응답
    out.print("{\"result\": \"success\", \"isWishlisted\": false, \"message\": \"로그인 필요\"}");
    return;
}

int userIdx = loginUser.getUserIdx();

// 파라미터 수신
String movieIdxStr = request.getParameter("movieIdx");
if (movieIdxStr == null || movieIdxStr.isEmpty()) {
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    out.print("{\"result\": \"fail\", \"message\": \"영화 번호 누락\"}");
    return;
}

int movieIdx = Integer.parseInt(movieIdxStr);

System.out.println("DEBUG: 위시리스트 상태 확인 - userIdx: " + userIdx + ", movieIdx: " + movieIdx);

try {
    // 위시리스트 서비스 호출 (상태 확인)
    SavedMovieService sms = new SavedMovieService();
    boolean isWishlisted = sms.checkSavedMovieStatus(movieIdx, userIdx);
    
    System.out.println("DEBUG: 위시리스트 상태: " + isWishlisted);
    
    out.print("{\"result\": \"success\", \"isWishlisted\": " + isWishlisted + "}");
    
} catch (Exception e) {
    System.out.println("DEBUG: 위시리스트 상태 확인 실패: " + e.getMessage());
    e.printStackTrace();
    
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    out.print("{\"result\": \"fail\", \"message\": \"서버 오류\"}");
}
%>