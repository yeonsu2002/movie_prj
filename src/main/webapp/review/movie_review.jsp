<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.yeonflix.movie.MovieDTO" %>
<%@ page import="kr.co.yeonflix.movie.MovieService" %>
<%@ page import="kr.co.yeonflix.review.ReviewService" %>

<%
    // 로그인된 userId (Integer 타입) 세션에서 꺼내기
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
%>
    <div style="text-align:center; margin-top:50px; color:#e74c3c;">
        로그인이 필요합니다. <a href="<%=request.getContextPath()%>/login/loginFrm.jsp">로그인 페이지</a>로 이동하세요.
    </div>
<%
        return;
    }

    // 파라미터 영화 아이디
    String movieIdxParam = request.getParameter("movieIdx");
    int movieIdx = 0;
    String movieTitle = "알 수 없음";

    if (movieIdxParam != null) {
        try {
            movieIdx = Integer.parseInt(movieIdxParam);
            MovieService ms = new MovieService();
            MovieDTO movie = ms.searchOneMovie(movieIdx);
            if (movie != null) {
                movieTitle = movie.getMovieName();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 리뷰 작성 여부 체크
    ReviewService reviewService = new ReviewService();
    boolean hasReviewed = false;
    try {
        hasReviewed = reviewService.hasUserReviewedMovie(userId, movieIdx);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>리뷰 작성 - <%= movieTitle %></title>

<style>
  /* 스타일은 생략 가능, 위 예시 참고 */
  #modalOverlay {
    position: fixed;
    top: 0; left: 0; right: 0; bottom: 0;
    background: rgba(0,0,0,0.5);
    backdrop-filter: blur(6px);
    z-index: 1000;
    display: none;
  }
  #reviewModal {
    position: fixed;
    top: 50%; left: 50%;
    transform: translate(-50%, -50%);
    background: #f4f4f4;
    padding: 20px 30px;
    border-radius: 12px;
    width: 450px;
    max-width: 90vw;
    box-shadow: 0 8px 16px rgba(0,0,0,0.3);
    z-index: 1100;
    display: none;
  }
  /* ... 나머지 스타일 생략 ... */
</style>

</head>
<body>

<% if (!hasReviewed) { %>
  <!-- 리뷰 작성 버튼 -->
  <button id="openReviewBtn">리뷰 작성</button>

  <!-- 모달 배경 -->
  <div id="modalOverlay"></div>

  <!-- 리뷰 작성 모달 -->
  <div id="reviewModal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
    <h2 id="modalTitle">리뷰 작성 - <%= movieTitle %></h2>
    <form action="<%=request.getContextPath()%>/review/add_review.jsp" method="post">
      <input type="hidden" name="movieId" value="<%= movieIdx %>" />
      <input type="hidden" name="movieName" value="<%= movieTitle %>" />

      <label for="rating">평점 (1~10점):</label><br>
      <select name="rating" id="rating" required>
        <option value="">평점을 선택하세요</option>
        <% for(int i=1; i<=10; i++) { %>
          <option value="<%= i %>"><%= i %> 점</option>
        <% } %>
      </select>

      <br>

      <label for="reviewText">리뷰 내용 (최대 280바이트):</label><br>
      <textarea id="reviewText" name="content" maxlength="280" placeholder="리뷰를 입력하세요" required></textarea>
      <div id="byteCount">0/280byte</div>

      <div class="btn-group" style="margin-top:15px;">
        <button type="submit" id="submitBtn">등록하기</button>
        <button type="button" id="cancelBtn">취소</button>
      </div>
    </form>
  </div>

  <script>
    const openBtn = document.getElementById('openReviewBtn');
    const modal = document.getElementById('reviewModal');
    const overlay = document.getElementById('modalOverlay');
    const cancelBtn = document.getElementById('cancelBtn');

    // 모달 열기
    openBtn.addEventListener('click', () => {
      modal.style.display = 'block';
      overlay.style.display = 'block';
    });

    // 모달 닫기 함수
    function closeModal() {
      modal.style.display = 'none';
      overlay.style.display = 'none';
    }
    cancelBtn.addEventListener('click', closeModal);
    overlay.addEventListener('click', closeModal);

    // 바이트 수 체크
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
    updateByteCount();
  </script>

<% } else { %>
<script>
  alert('이미 이 영화에 대해 리뷰를 작성하셨습니다.');
  history.back();
</script>
<% } %>

</body>
</html>
