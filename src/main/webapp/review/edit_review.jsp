<%@page import="kr.co.yeonflix.review.ReviewService"%>
<%@page import="kr.co.yeonflix.review.ReviewDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // 파라미터 및 세션 정보
    String loginId = (String) session.getAttribute("loginId");
    if (loginId == null) {
%>
    <div style="text-align:center; margin-top:50px; color:#e74c3c;">
        로그인이 필요합니다. <a href="<%=request.getContextPath()%>/movie_prj/login/loginFrm.jsp">로그인 페이지</a>로 이동하세요.
    </div>
<%
        return;
    }

    String reviewIdParam = request.getParameter("reviewId");
    String movieIdParam = request.getParameter("movieId");

    if (reviewIdParam == null || movieIdParam == null) {
%>
    <div style="text-align:center; margin-top:50px; color:#e74c3c;">
        잘못된 접근입니다.
    </div>
<%
        return;
    }

    int reviewId = 0;
    int movieId = 0;
    try {
        reviewId = Integer.parseInt(reviewIdParam);
        movieId = Integer.parseInt(movieIdParam);
    } catch (NumberFormatException e) {
%>
    <div style="text-align:center; margin-top:50px; color:#e74c3c;">
        잘못된 요청입니다.
    </div>
<%
        return;
    }

    ReviewService rs = new ReviewService();
    ReviewDTO review = null;
    try {
    	review = rs.getReviewById(reviewId);
        if (review == null) {
%>
    <div style="text-align:center; margin-top:50px; color:#e74c3c;">
        수정할 리뷰를 찾을 수 없습니다.
    </div>
<%
            return;
        }
        // 작성자와 로그인 ID가 다르면 접근 차단
        if (!loginId.equals(review.getUserLoginId())) {
%>
    <div style="text-align:center; margin-top:50px; color:#e74c3c;">
        권한이 없습니다.
    </div>
<%
            return;
        }
    } catch (Exception e) {
%>
    <div style="text-align:center; margin-top:50px; color:#e74c3c;">
        데이터베이스 오류가 발생했습니다.
    </div>
<%
        e.printStackTrace();
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>리뷰 수정 - <%= review.getMovieId() %></title>
<style>
    body { font-family: Arial, sans-serif; padding: 20px; background: #f9f9f9; }
    form { background: #fff; padding: 20px; border-radius: 8px; max-width: 500px; margin: 0 auto; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    label { display: block; margin-top: 15px; font-weight: bold; }
    select, textarea { width: 100%; padding: 8px; margin-top: 6px; border: 1px solid #ccc; border-radius: 6px; font-size: 14px; }
    button { margin-top: 20px; padding: 10px 20px; border:none; border-radius: 6px; cursor: pointer; font-weight: bold; }
    #submitBtn { background: #5c6bc0; color: #fff; }
    #cancelBtn { background: #ccc; margin-left: 10px; }
    #byteCount { font-size: 12px; color: #666; margin-top: 4px; }
</style>
</head>
<body>

<h2>리뷰 수정 - <%= review.getMovieId() %></h2>

<form action="<%=request.getContextPath()%>/review/update_review.jsp" method="post">
    <input type="hidden" name="reviewId" value="<%= reviewId %>"/>
    <input type="hidden" name="movieId" value="<%= movieId %>"/>

    <label for="rating">평점 (1~10점):</label>
    <select name="rating" id="rating" required>
        <option value="">평점을 선택하세요</option>
        <% for (int i = 1; i <= 10; i++) { %>
            <option value="<%= i %>" <%= (review.getRating() == i) ? "selected" : "" %>><%= i %> 점</option>
        <% } %>
    </select>

    <label for="reviewText">리뷰 내용 (최대 280바이트):</label>
    <textarea id="reviewText" name="content" maxlength="280" required><%= review.getContent() %></textarea>
    <div id="byteCount">0/280byte</div>

    <button type="submit" id="submitBtn">수정하기</button>
    <button type="button" id="cancelBtn">취소</button>
</form>

<script>
    const textarea = document.getElementById('reviewText');
    const byteCount = document.getElementById('byteCount');
    const maxBytes = 280;

    function updateByteCount() {
        const text = textarea.value;
        let totalBytes = 0;
        for (let i = 0; i < text.length; i++) {
            const charCode = text.charCodeAt(i);
            totalBytes += (charCode > 127) ? 2 : 1;
        }
        byteCount.textContent = `${totalBytes}/${maxBytes}byte`;

        if (totalBytes > maxBytes) {
            let trimmed = '';
            let currentBytes = 0;
            for (let i = 0; i < text.length; i++) {
                const char = text[i];
                const charByte = (char.charCodeAt(0) > 127) ? 2 : 1;
                if (currentBytes + charByte > maxBytes) break;
                trimmed += char;
                currentBytes += charByte;
            }
            textarea.value = trimmed;
            byteCount.textContent = `${currentBytes}/${maxBytes}byte`;
        }
    }

    textarea.addEventListener('input', updateByteCount);
    window.onload = updateByteCount;

    document.getElementById('cancelBtn').addEventListener('click', () => {
        history.back();
    });
</script>

</body>
</html>
