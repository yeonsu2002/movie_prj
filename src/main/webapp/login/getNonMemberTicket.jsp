<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비회원 예매내역 조회</title>
<jsp:include page="/common/jsp/external_file.jsp" />
<link rel="stylesheet" href="http://localhost/movie_prj/theater/theater.css/theater_main.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/login/css/getNonMemberTicket.css">
<script type="text/javascript">
</script>
</head>
<body>
<header>
<jsp:include page="/common/jsp/header.jsp" />
</header>
<main>
<div class="nomem-container">
    <div class="nomem-header">
      <h1>나의 예매내역</h1>
    </div>

    <div class="nomem-notice">
      지난 1개월까지의 예매내역을 확인하실 수 있으며, 영수증은
      <span class="nomem-highlight">신용카드 결제 내역만</span> 출력 가능합니다.
    </div>

    <div class="nomem-main-content">
      <div class="nomem-main-title">
        <h2>현장에서 발권하실 경우 꼭 <span class="nomem-highlight">예매번호를</span> 확인하세요.</h2>
      </div>
      <div class="nomem-subtitle">
        티켓발매기에서 예매번호를 입력하면 티켓을 발급받을 수 있습니다.
      </div>

      <div class="nomem-booking-card">
        <div class="nomem-booking-header">
          <div class="nomem-booking-number">
            예매번호 <span class="nomem-number">0074-01</span>
          </div>
          <div class="nomem-booking-price">22,000원</div>
        </div>

        <div class="nomem-booking-content">
          <div class="nomem-movie-poster">
            영화 포스터<br>이미지 영역
          </div>

          <div class="nomem-movie-info">
            <div class="nomem-info-row">
              <span class="nomem-info-label">관람극장</span>
              <span class="nomem-info-value">YEONFLIX <span class="nomem-theater-rating">[강남점]</span></span>
            </div>

            <div class="nomem-info-row">
              <span class="nomem-info-label">관람일시</span>
              <span class="nomem-info-value">일반 1</span>
            </div>

            <div class="nomem-info-row">
              <span class="nomem-info-label">관람일시</span>
              <span class="nomem-info-value"></span>
            </div>

            <div class="nomem-info-row">
              <span class="nomem-info-label">관람좌석</span>
              <span class="nomem-info-value"></span>
            </div>

            <div class="nomem-info-row">
              <span class="nomem-info-label">상영관</span>
              <span class="nomem-info-value"></span>
            </div>

            <div class="nomem-info-row">
              <span class="nomem-info-label">매수</span>
              <span class="nomem-info-value">1매</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>


</div>
</main>

<footer><jsp:include page="/common/jsp/footer.jsp" /></footer>
</body>
</html>