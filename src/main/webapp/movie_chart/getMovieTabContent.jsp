<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.review.ReviewService"%>
<%@page import="kr.co.yeonflix.review.ReviewDTO"%>
<%@page import="kr.co.yeonflix.review.ReviewDTO"%>
<%@page import="kr.co.yeonflix.review.ReviewService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
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

// 트레일러 URL 가져오기 (실제 필드명에 맞게 수정 필요)
String trailerUrl = movie.getTrailerUrl(); // 또는 실제 트레일러 URL 필드명
String embedUrl = "";

// YouTube URL을 embed URL로 변환
if (trailerUrl != null && !trailerUrl.trim().isEmpty()) {
    String videoId = "";
    
    if (trailerUrl.contains("youtu.be/")) {
        int idx = trailerUrl.lastIndexOf("/");
        if (idx != -1) {
            videoId = trailerUrl.substring(idx + 1);
            int paramIdx = videoId.indexOf("?");
            if (paramIdx != -1) {
                videoId = videoId.substring(0, paramIdx);
            }
        }
    } else if (trailerUrl.contains("watch?v=")) {
        int idx = trailerUrl.indexOf("v=") + 2;
        if (idx != -1) {
            videoId = trailerUrl.substring(idx);
            int endIdx = videoId.indexOf("&");
            if (endIdx == -1) endIdx = videoId.indexOf("=");
            if (endIdx != -1) {
                videoId = videoId.substring(0, endIdx);
            }
        }
    }
    
    if (!videoId.isEmpty()) {
        embedUrl = "https://www.youtube.com/embed/" + videoId + "?autoplay=1&mute=1&loop=1&playlist=" + videoId;
    }
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
        
        <% 
        if (embedUrl != null && !embedUrl.trim().isEmpty()) { %>
        <iframe id="trailer-iframe" class="trailer-iframe"
            src="<%= embedUrl %>"
            frameborder="0"
            allowfullscreen
            allow="autoplay; encrypted-media">
        </iframe>
        <% } else { %>
        <div class="no-trailer">
            트레일러를 찾을 수 없습니다.
        </div> 
        <% } %>
    </div>
</div>
<%

} else if ("review".equals(tabType)) {
    ReviewService rs = new ReviewService();
    List<ReviewDTO> reviewList = null;

    try {
        reviewList = rs.getReviewsByMovie(movieIdx);  // 영화 번호로 리뷰 조회
    } catch (Exception e) {
%>
<div class='tab-content active' style='text-align: center; padding: 60px 20px; color: #e74c3c;'>
    리뷰를 불러오는 중 오류가 발생했습니다.
</div>
<%
        e.printStackTrace();
        return;
    }

    // 로그인 ID 세션에서 가져오기
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
%>
<div class="tab-content active">
<h3>관람평</h3>

<div class="review-section">
    <% if (reviewList != null && !reviewList.isEmpty()) {
        for (ReviewDTO review : reviewList) {
            String safeContent = review.getContent()
                .replaceAll("&", "&amp;")
                .replaceAll("<", "&lt;")
                .replaceAll(">", "&gt;")
                .replaceAll("\"", "&quot;")
                .replaceAll("\n", "<br>");
    %>
        <div class="review-box">
            <div class="review-user"><strong><%= review.getUserLoginId() %></strong> 님의 리뷰</div>
            <div class="review-rating">⭐ 평점: <%= review.getRating() %>점</div>
            <div class="review-content"><%= safeContent %></div>
            <div class="review-date"><small><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(review.getWriteDate()) %></small></div>
        </div>
        <hr>
    <%  }
    } else { %>
        <div class="review-placeholder">리뷰가 아직 등록되지 않았습니다.<br><br><small>첫 리뷰를 남겨보세요!</small></div>
    <% } %>
</div>

<div style="margin-top: 20px;">
    <% if (loginUser != null) { %>
        <button id="openReviewBtn" 
     style="
    padding: 8px 16px;
    background: #000;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    float: right;
">
            리뷰 작성
        </button>
    <% } else { %>
        <p>리뷰를 작성하려면 <a href="<%=request.getContextPath()%>/movie_prj/login/loginFrm.jsp"><strong>로그인</strong></a> 해주세요.</p>
    <% } %>
</div>
</div>

<!-- 모달 오버레이 -->
<div id="modalOverlay" style="display:none; position:fixed; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.5); backdrop-filter:blur(6px); z-index:1000;"></div>

<!-- 모달 박스 -->
<div id="reviewModal" role="dialog" aria-modal="true" aria-labelledby="modalTitle" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%, -50%); background:#f4f4f4; padding:20px 30px; border-radius:12px; width:450px; max-width:90vw; box-shadow:0 8px 16px rgba(0,0,0,0.3); z-index:1100;">
<h2 id="modalTitle"> <%= movie.getMovieName() %></h2>
<form action="<%=request.getContextPath()%>/review/add_review.jsp" method="post">
    <input type="hidden" name="movieId" value="<%= movieIdx %>" />

    <label for="rating">평점 (1~10점):</label><br>
    <select name="rating" id="rating" required style="padding:6px; margin-bottom:15px; width:100%;">
        <option value="">평점을 선택하세요</option>
        <% for(int i=1; i<=10; i++) { %>
            <option value="<%= i %>"><%= i %> 점</option>
        <% } %>
    </select>

    <label for="reviewText">리뷰 내용 (최대 280바이트):</label><br>
    <textarea id="reviewText" name="content" maxlength="280" placeholder="리뷰를 입력하세요" required style="width:100%; height:120px; resize:none; font-size:14px; padding:10px; border:1px solid #ccc; border-radius:6px;"></textarea>
    <div id="byteCount" style="font-size:12px; color:#666; margin-top:6px;">0/280byte</div>

    <div style="margin-top:15px; display:flex; justify-content:flex-end; gap:10px;">
        <button type="submit" id="submitBtn" style="background:#5c6bc0; color:#fff; padding:8px 16px; font-weight:bold; border:none; border-radius:6px; cursor:pointer;">등록하기</button>
        <button type="button" id="cancelBtn" style="background:#ccc; padding:8px 16px; font-weight:bold; border:none; border-radius:6px; cursor:pointer;">취소</button>
    </div>
</form>
</div>

<script>
const openBtn = document.getElementById('openReviewBtn');
const modal = document.getElementById('reviewModal');
const overlay = document.getElementById('modalOverlay');
const cancelBtn = document.getElementById('cancelBtn');
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

// 모달 열기
openBtn.addEventListener('click', () => {
    modal.style.display = 'block';
    overlay.style.display = 'block';
    updateByteCount();
});

// 모달 닫기 함수
function closeModal() {
    modal.style.display = 'none';
    overlay.style.display = 'none';
    textarea.value = '';
    byteCount.textContent = `0/${maxBytes}byte`;
    document.getElementById('rating').value = '';
}

cancelBtn.addEventListener('click', closeModal);
overlay.addEventListener('click', closeModal);
</script>
<%
} else {
%>
<div class='tab-content active' style='text-align: center; padding: 60px 20px; color: #e74c3c;'>
    잘못된 탭 요청입니다.
</div>
<%
} // 탭별 if-else 종료
%>