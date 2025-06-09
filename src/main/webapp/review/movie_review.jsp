<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" info="Movie Review Write Modal" %>
<%@ page import="kr.co.yeonflix.movie.MovieDTO" %>
<%@ page import="kr.co.yeonflix.movie.MovieService" %>

<%
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
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>리뷰 작성 - <%= movieTitle %></title>

<style>
  /* 배경 흐림 오버레이 */
  #modalOverlay {
    position: fixed;
    top: 0; left: 0; right: 0; bottom: 0;
    background: rgba(0,0,0,0.5);
    backdrop-filter: blur(6px);
    z-index: 1000;
    display: none;
  }

  /* 모달 박스 */
  #reviewModal {
    position: fixed;
    top: 50%; left: 50%;
    transform: translate(-50%, -50%);
    background: #f4f4f4;
    color: #333;
    padding: 20px 30px;
    border-radius: 12px;
    width: 450px;
    max-width: 90vw;
    box-shadow: 0 8px 16px rgba(0,0,0,0.3);
    z-index: 1100;
    display: none;
  }

  #reviewModal h2 {
    margin-top: 0;
    margin-bottom: 15px;
    color: #222;
  }

  #reviewModal textarea {
    width: 100%;
    height: 120px;
    resize: none;
    font-size: 14px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 6px;
  }

  #byteCount {
    font-size: 12px;
    color: #666;
    margin-top: 6px;
  }

  #reviewModal select {
    padding: 6px;
    margin-bottom: 15px;
  }

  #reviewModal .btn-group {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
  }

  #reviewModal button {
    padding: 8px 16px;
    font-weight: bold;
    border-radius: 6px;
    border: none;
    cursor: pointer;
  }

  #submitBtn {
    background-color: #5c6bc0;
    color: white;
  }

  #cancelBtn {
    background-color: #ccc;
  }

  /* 리뷰작성 버튼 */
  #openReviewBtn {
    padding: 10px 20px;
    background-color: #3b82f6;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
  }
</style>

</head>
<body>

<!-- 실제 페이지에 리뷰 작성 버튼 -->
<button id="openReviewBtn">리뷰 작성</button>

<!-- 모달 배경 -->
<div id="modalOverlay"></div>

<!-- 모달 창 -->
<div id="reviewModal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
  <h2 id="modalTitle">리뷰 작성 - <%= movieTitle %></h2>
  <form action="/movie_prj/review/add_review.jsp" method="post">
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

  // 열기
  openBtn.addEventListener('click', () => {
    modal.style.display = 'block';
    overlay.style.display = 'block';
  });

  // 닫기
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

</body>
</html>
