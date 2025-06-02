<%@page import="kr.co.yeonflix.review.ReviewDTO"%>
<%@page import="java.util.List"%>
<%@ page import="kr.co.yeonflix.review.ReviewService" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Movie Review Page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String movieIdStr = request.getParameter("movieId");
if (movieIdStr == null) {
    movieIdStr = "";
}
int movieId = 0;
try {
    movieId = Integer.parseInt(movieIdStr);
} catch(Exception e) {
    movieId = 0;
}

ReviewService rs = new ReviewService();
List<ReviewDTO> reviewList = rs.getReviewsByMovie(movieId); // movieId int 타입으로 수정 필요

request.setAttribute("reviewList", reviewList);

// 예시로 영화 제목 지정 (DB에서 받아오도록 수정 권장)
String movieTitle = "릴로 스티치";
request.setAttribute("movieTitle", movieTitle);

// movieId를 EL에서 사용하려면 request attribute로도 설정
request.setAttribute("movieId", movieId);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 상세</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
<style>
/* 전체 배경 및 글자색 */
body {
    background: url("/movie_prj/images/background_movie.jpg") no-repeat center center fixed;
    background-size: cover;
    color: white;
}

/* 메인 컨테이너 */
#container {
    display: flex;
    flex-direction: column;
    min-height: 650px;
    margin: 30px auto 0;
    padding: 20px 40px;
    background-color: rgba(0, 0, 0, 0.7);
    border-radius: 12px;
    max-width: 1200px;
}

/* 영화 정보 영역 */
.movie-info {
    display: flex;
    gap: 20px;
    margin-bottom: 40px;
}

.poster {
    flex-shrink: 0;
}

.poster img {
    width: 200px;
    border-radius: 8px;
}

.info {
    flex: 1;
}

.info h2 {
    font-size: 28px;
    margin-bottom: 10px;
}

.info p {
    margin: 4px 0;
    font-size: 16px;
}

/* 예매 버튼 */
.reserve-btn {
    margin-top: 10px;
    background-color: #ff2f2f;
    border: none;
    padding: 10px 20px;
    color: white;
    font-weight: bold;
    border-radius: 6px;
    cursor: pointer;
}

/* 리뷰 섹션 */
.review-section {
    margin-top: 30px;
}

.review-section h3 {
    font-size: 24px;
    border-left: 5px solid #ff2f2f;
    padding-left: 10px;
    margin-bottom: 20px;
}

.review-card {
    background-color: #1e1e1e;
    padding: 15px;
    border-radius: 8px;
    margin-bottom: 10px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.review-content {
    display: flex;
    align-items: center;
    gap: 10px;
}

.review-content img {
    width: 36px;
    height: 36px;
    border-radius: 50%;
}

/* 리뷰 버튼들 */
.review-buttons button {
    margin-left: 10px;
    padding: 6px 10px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.review-buttons .edit-btn {
    background-color: #444;
    color: white;
}

.review-buttons .delete-btn {
    background-color: #ff4d4d;
    color: white;
}

.review-buttons .report-btn {
    background-color: #555;
    color: white;
}

/* 평점작성 버튼 */
.write-review-btn {
    float: right;
    background-color: #ff2f2f;
    color: white;
    padding: 10px 16px;
    border: none;
    border-radius: 6px;
    font-weight: bold;
    cursor: pointer;
}

/* === 모달 관련 스타일 === */

/* 모달 배경 */
.modal {
    display: none;
    position: fixed;
    z-index: 9999;
    left: 0;
    top: 0;
    width: 100vw;
    height: 100vh;
    background-color: rgba(0, 0, 0, 0.6);
}

/* 모달 내용 */
.modal-content {
    background-color: #f4f4f4;
    color: #333;
    width: 500px;
    margin: 100px auto;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
}

/* 모달 헤더 */
.modal-header {
    background-color: #444;
    padding: 15px;
    color: white;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.modal-title {
    font-size: 18px;
    font-weight: bold;
}

.close {
    font-size: 24px;
    cursor: pointer;
}

/* 모달 본문 */
.modal-body {
    padding: 20px;
    text-align: center;
}

.modal-body h3 {
    margin-bottom: 15px;
    font-size: 20px;
}

.modal-body textarea {
    width: 100%;
    padding: 12px;
    border: 1px solid #ccc;
    border-radius: 6px;
    resize: none;
    font-size: 14px;
}

/* 모달 푸터 */
.modal-footer {
    margin-top: 10px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

#byteCount {
    font-size: 12px;
    color: #666;
}

.submit-btn {
    background-color: #5c6bc0;
    color: white;
    padding: 8px 16px;
    border: none;
    border-radius: 6px;
    font-weight: bold;
    cursor: pointer;
}

</style>
</head>
<body>
<header>
    <c:import url="http://localhost/movie_prj/common/jsp/header.jsp"/>
</header>
<main>
<div id="container">
    <!-- 영화 정보 영역 -->
    <div class="movie-info">
        <div class="poster">
            <img src="http://localhost/movie_prj/common/img/main_movie_4.jpg" alt="영화 포스터">
        </div>
        <div class="info">
            <h2>릴로 스티치 <span style="font-size:14px; background-color: #444; padding: 2px 6px; border-radius: 4px;">현재 상영중</span></h2>
            <p>예매율: 29.86%</p>
            <p>장르: 애니메이션 / 국가: 미국 / 감독: 딘 플레이 셔-캠프</p>
            <p>출연: 크리스 샌더스, 마이아 케알로하, 시드니 아구동 외</p>
            <p>개봉일: 2025.05.21</p>
            <p>평점: 9.04</p>
            <button class="reserve-btn">예매하기</button>
        </div>
    </div>

<!-- 리뷰 헤더에만 작성 버튼 위치 -->
<h3>평점 리뷰
    <button class="write-review-btn" data-title="${movieTitle}" data-id="${param.movieId}">평점작성</button>
</h3>

<!-- 모달에는 작성 폼만 존재 -->
<div id="reviewModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <span class="modal-title">평점작성</span>
            <span class="close">&times;</span>
        </div>
        <div class="modal-body">
            <h3>${movieTitle}</h3>
            <form action="/movie_prj/lee/add_review.jsp" method="post">
                <input type="hidden" name="movieId" value="${param.movieId}">
                <textarea id="reviewText" name="content" rows="5" maxlength="280" placeholder="평점을 입력해주세요 (최대 280자)" required></textarea>
                <div class="modal-footer">
                    <span id="byteCount">0/280byte</span>
                    <button type="submit" class="submit-btn">등록하기</button>
                </div>
            </form>
        </div>
    </div>
</div>
</div>

<script>
document.addEventListener('DOMContentLoaded', () => {
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
            byteCount.textContent = `${currentBytes}/${maxBytes} bytes`;
        }
    }

    textarea.addEventListener('input', updateByteCount);

    // 초기 바이트 카운트 업데이트
    updateByteCount();

    // --- 모달 열기/닫기 코드 ---
    const modal = document.getElementById('reviewModal');
    const openBtn = document.querySelector('.write-review-btn');
    const closeBtn = modal.querySelector('.close');

    // 모달 열기
    openBtn.addEventListener('click', () => {
        modal.style.display = 'block';
    });

    // 모달 닫기 (X 버튼)
    closeBtn.addEventListener('click', () => {
        modal.style.display = 'none';
    });

    // 모달 바깥 영역 클릭 시 닫기
    window.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.style.display = 'none';
        }
    });
});

</script>

</main>
<footer>
    <c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
</footer>
</body>
</html>  