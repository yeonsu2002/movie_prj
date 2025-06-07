<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Tab content loader"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
// 파라미터 검증
String tabType = request.getParameter("tabType");
String movieIdxParam = request.getParameter("movieIdx");

// 파라미터 검증
if (tabType == null || movieIdxParam == null) {
    out.println("<div class='tab-content active' style='text-align: center; padding: 60px 20px; color: #e74c3c;'>잘못된 요청입니다.</div>");
    return;
}

int movieIdx = 0;
try {
    movieIdx = Integer.parseInt(movieIdxParam);
} catch (NumberFormatException e) {
    out.println("<div class='tab-content active' style='text-align: center; padding: 60px 20px; color: #e74c3c;'>영화 정보를 찾을 수 없습니다.</div>");
    return;
}

// 필요한 서비스 호출
MovieService ms = new MovieService();
MovieDTO movie = null;

try {
    movie = ms.searchOneMovie(movieIdx);
    if (movie == null) {
        out.println("<div class='tab-content active' style='text-align: center; padding: 60px 20px; color: #e74c3c;'>영화 정보를 찾을 수 없습니다.</div>");
        return;
    }
} catch (Exception e) {
    out.println("<div class='tab-content active' style='text-align: center; padding: 60px 20px; color: #e74c3c;'>데이터베이스 오류가 발생했습니다.</div>");
    e.printStackTrace();
    return;
}

// 탭별 분기 처리
if ("main-info".equals(tabType)) {
%>
<div class="tab-content active">
    <h3>줄거리</h3>
    <div class="movie-description">
        <% 
        String description = movie.getMovieDescription();
        if (description != null && !description.trim().isEmpty()) {
            out.println(description);
        } else {
            out.println("줄거리 정보가 없습니다.");
        }
        %>
    </div>
</div>
<%
} else if ("trailer".equals(tabType)) {
%>
<div class="tab-content active">
    <div class="trailer-container">
        <h3>트레일러</h3>
        <div class="trailer-preview">
            <div class="trailer-background"></div>
            <div class="trailer-overlay">
                <div class="play-button"></div>
            </div>
        </div>
        <iframe id="trailer-iframe" class="trailer-iframe"
            src="https://www.youtube.com/embed/HAfCX54YmB4?autoplay=1"
            frameborder="0"
            allowfullscreen
            allow="encrypted-media">
        </iframe>
    </div>
</div>
<%
} else if ("review".equals(tabType)) {
%>
<div class="tab-content active">
    <h3>관람평</h3>
    <div class="review-placeholder">
        리뷰가 아직 등록되지 않았습니다.
        <br><br>
        <small>곧 리뷰 기능이 추가될 예정입니다.</small>
    </div>
</div>
<%
} else {
    // 알 수 없는 탭 타입
    out.println("<div class='tab-content active' style='text-align: center; padding: 60px 20px; color: #e74c3c;'>지원되지 않는 탭입니다.</div>");
}
%>