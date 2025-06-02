<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>관람평 안내 모달</title>
  <c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
  <style>
    #container {
      min-height: 650px;
      margin-top: 30px;
      margin-left: 20px;
    }

    .modal-bg {
      display: none;
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }

    .modal {
      background: #fff;
      padding: 24px;
      border-radius: 10px;
      width: 400px;
      font-family: 'Arial', sans-serif;
      box-shadow: 0 4px 12px rgba(0,0,0,0.25);
      display: flex;
      flex-direction: column;
    }

    .modal strong {
      font-size: 16px;
      margin-bottom: 10px;
      color: #333;
    }

    .modal p {
      font-size: 14px;
      color: #555;
      line-height: 1.5;
      margin: 0 0 20px 0;
    }

    .modal-buttons {
      text-align: right;
    }

    .modal button {
      margin-left: 10px;
      padding: 8px 16px;
      border-radius: 4px;
      font-size: 14px;
      border: none;
      cursor: pointer;
    }

    .confirm-btn {
      background-color: #3f51b5;
      color: white;
    }

    .cancel-btn {
      background-color: white;
      color: #333;
      border: 1px solid #ccc;
    }
  </style>

  <script>
    function openModal() {
      document.getElementById("modal2").style.display = "flex";
    }

    function closeModal() {
      document.getElementById("modal2").style.display = "none";
    }

    function moveToRegister() {
      // 실관람객 등록 페이지로 이동
      window.location.href = "registerRealViewer.jsp";  // 실제 경로로 수정
    }
  </script>
</head>

<body>
  <header>
    <c:import url="http://localhost/movie_prj/common/jsp/header.jsp"/>
  </header>

  <main>
    <div id="container">
      <!-- 모달 열기 버튼 -->
      <button onclick="openModal()">관람평 작성후 안내</button>

      <!-- 모달 -->
      <div class="modal-bg" id="modal2">
        <div class="modal">
          <strong>www.cgv.co.kr 내용:</strong>
          <p>
            이미 관람평 작성을 완료하셨습니다.<br>
            관람평을 수정하시겠습니까?
          </p>
          <div class="modal-buttons">
            <button class="confirm-btn" onclick="moveToRegister()">확인</button>
            <button class="cancel-btn" onclick="closeModal()">취소</button>
          </div>
        </div>
      </div>
    </div>
  </main>

  <footer>
    <c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
  </footer>
</body>
</html>
