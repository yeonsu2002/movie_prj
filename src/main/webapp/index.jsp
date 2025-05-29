<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>연플릭스</title>
<jsp:include page="/common/jsp/external_file.jsp" />
<link rel="stylesheet" href="http://localhost/movie_prj/common/css/main_screen.css"/>
<script type="text/javascript">
//DOM이 로드된 후 실행되도록 수정
document.addEventListener('DOMContentLoaded', function() {
    // 스크롤 이벤트
    window.addEventListener("scroll", function() {
    	var buttonWrap = document.querySelector(".fixedBtn_wrap");
    	var goTopButton = document.querySelector(".btn_gotoTop");
    	var ticketingButton = document.querySelector(".btn_ticketing");
        // 스크롤이 100px 이상 내려가면 상단 버튼과 예매 버튼을 보이도록 설정
        if (window.scrollY > 100) {
            if (buttonWrap) {
                buttonWrap.classList.add("visible");
                buttonWrap.classList.add("topBtn");
            }
        } else {
            if (buttonWrap) {
                buttonWrap.classList.remove("visible");
                buttonWrap.classList.remove("topBtn");
            }
        }
    });
    
    // 특별관 메뉴 항목들과 이미지 요소 가져오기
    var menuItems = document.querySelectorAll('.specialhall_list li');
    var image = document.getElementById('hallImage');
    var name = document.getElementById('hallName');
    var desc = document.getElementById('hallDesc');
    
    // 요소가 존재하는지 확인 후 이벤트 리스너 추가
    if (menuItems.length > 0 && image && name && desc) {
        // 각 메뉴 항목에 마우스 올렸을 때 이미지 변경
        menuItems.forEach(function(item) {
            item.addEventListener('mouseenter', function() {
                if (this.dataset.image && this.dataset.name && this.dataset.desc) {
                    image.src = this.dataset.image;
                    name.textContent = this.dataset.name;
                    desc.textContent = this.dataset.desc;
                }
            });
        });
    }
});

function showTab(tabName) {
	var contents = document.querySelectorAll(".tab-content");
	var buttons = document.querySelectorAll(".tab-button");
    contents.forEach(c => c.classList.remove("active"));
    buttons.forEach(b => b.classList.remove("active"));
    
    var targetTab = document.getElementById(tabName);
    if (targetTab) {
        targetTab.classList.add("active");
    }
    
    if (event && event.currentTarget) {
        event.currentTarget.classList.add("active");
    }
}
</script>
</head>
<body>
<header>
<jsp:include page="/common/jsp/header.jsp" />
</header>
<main>


<div class="fixedBtn_wrap">
    <div class="btn_group">
        <a href="reservation/reservation.jsp" class="btn_ticketing">예매하기</a>
        <a href="#" class="btn_gotoTop">
            <img src="http://localhost/movie_prj/common/img/up_arrow.png"/>
        </a>
    </div>
</div>

<div id="trailer-wrapper">
<div id="trailer-container">
  <iframe 
    src="https://www.youtube.com/embed/J8qqMLZPPTo?autoplay=1&mute=1&loop=1&playlist=J8qqMLZPPTo" 
    frameborder="0" 
    allowfullscreen
    allow="autoplay; encrypted-media">
  </iframe>
  <div class="trailer-overlay"></div>
</div>
</div>


<div id="container">

 <!-- 영화 차트 -->
        <!-- 탭 버튼 영역 -->
<div class="tab-buttons">
  <div class="tab-buttons-left">
    <button class="tab-button active" onclick="showTab('movieChart')">무비차트</button>
    <button class="tab-button" onclick="showTab('UpcomingMovies')">상영예정작</button>
  </div>
  <a href="http://localhost/movie_prj/movie_chart/main_chart.jsp" id="btn_allView_Movie" class="btn_allView">전체보기 &gt;</a>
</div>
        <div>    
		<div class="content-area">
		
		<div id="movieChart" class="tab-content active">
		<div class="poster-marquee">
      <div class="poster-track">
      <div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_1.jpg" alt="영화 1">
		    <img src="https://i.namu.wiki/i/g_VAsyPtPWVWXj2Xwh50VuGJNasfuRP7EXsIBNJFuJ7uM0qUwUQTomIiYp36VaUfjO-_p8B0nZ3R6PtXmu_XwaFuh8E3NHIwTxuEWRMQ7oyGOFNJF3Jep6bfxNIqIamtihoAgcNkaELR4aqLVAq7pQ.svg" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">1</div>
		</div>
		<div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_2.jpg" alt="영화 2">
		    <img src="https://i.namu.wiki/i/c4gbRUKYTVYyRwXE-yTKjSfq7w1CZjvYUV2swif9FtqvD-afTZUttU7cqzEq2IhxNykxrI20c0ruGu8E8UB3jv7m1qiDfxihl2eShY3-PYL4xaDHTmLwfhQNvu42HFg_VLzTULC6-0tTfgD5pCit7Q.svg" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">2</div>
		</div>
		<div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_3.jpg" alt="영화 3">
		    <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAKcAAACnCAMAAABDyLzeAAAAaVBMVEXZLDX////eSE/iXmXxr7P1y8386+z2ztDuo6fbOkLjYWjslprtm6DeTFP53t/dQkrhWWDjZm3qjZLaNj/ogojfUVj+9/jxsLPlbXPmdHnaMTrzvcD41tj77e7++Pjyt7rof4T0w8bvqKsLZxsxAAACuklEQVR4nO3d0XaiMBAG4OBWEAQRUOyixcr7P+SqLAqlk0Rxm5k9/3/VC07Od6xMIOBEef34zSZLlPsk2abxBzJ1+6ue51vXvkG2+bweO8u4cA0bpYjLr8631DXq26S7ofNYuRYRqXZ9Z+6ao0l+dzauLdo0nTPg+k9vUwWt0w9dSwwJ/atz6dphTHxxfvCrm19TlGcn53O9y/Ls5DCfm5J4auXaYJWVil0TrBKrd9cEq/xWa9cEq0Rq5ppglZniPWd2kaFEEAQZJfS+z22SSPclcYh1DtF0Z25y7qcqzymnX7CvTE6fOOChTL7UWFMjv9b5a6qzkeGsPmQ438mReTnpk5mVkyqe3JwbIc6DDGeiGZmTcyHESRZPXk66ePJyHmU4w1o3Mh+npniycmqKJyenrnhycsZCnLriaec8fEb9ZJpp43lnZvgEzM7xsjp9Zj7v1BZPK+f4kWT6emehLZ5WzsVoUPpy9mnnp4HJxRnIcM5MTCbOpRCnuXizcEZGJg/njhyQl/OWNzjhhBNOOOGEE85e9qPRyIdmTp33Q7rQl2FOneVx2U+sWbBy6nwgcMIJJ5xwwgknnP+x8yTESb0oyM1pfuTAxFm84M3Kn3AqlS3mdiHfaP0Zp3XIrwiccMIJJ5xwwsnLSV51MHOSh8AJJ5xwwgknnHDCqXcyW18iD3kgcMIJJ5xwwgknnHDCCadc59R+QVbr3tOZk/sv2TjTye8zBDI6PSIIgkiLlP60MmaBSEz/ZCn9qKX095bSL11AO/+2//wL2oP+64SXfv4e/zNpcd3Hoea5Zcs9s7rdv+PAu8t3dfkp5fVG8eiaos31zqu9oeX8FW0bYP298T5xPemLk9d3eitee0l12XYdkW8LGXXDb5uZcHFrqNVbcCljXlNoEveeLA8XhoLNOuHwsYbJOh/+sPsPliE90NTv91MAAAAASUVORK5CYII=" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">3</div>
		</div>
		<div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_4.jpg" alt="영화 4">
		    <img src="https://i.namu.wiki/i/UA7u1h1BSfp2wQ8gGmQa-wCcl00QxF7MwSityvaTIGsyhx01dEhR69yKEAhsnQbikYCVNhDUudEZ5rpYIY89fDMjOlfi3MxlHe-eJq41Tl10V2FYy8kIF524tp9s0KHprIERPemzcL-uZhjIT23syQ.svg" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">4</div>
		</div> 
      <!-- 복사해서 루프 느낌 줄 수 있음 -->
      <div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_1.jpg" alt="영화 1">
		    <img src="https://i.namu.wiki/i/g_VAsyPtPWVWXj2Xwh50VuGJNasfuRP7EXsIBNJFuJ7uM0qUwUQTomIiYp36VaUfjO-_p8B0nZ3R6PtXmu_XwaFuh8E3NHIwTxuEWRMQ7oyGOFNJF3Jep6bfxNIqIamtihoAgcNkaELR4aqLVAq7pQ.svg" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">1</div>
		</div>
		<div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_2.jpg" alt="영화 2">
		    <img src="https://i.namu.wiki/i/c4gbRUKYTVYyRwXE-yTKjSfq7w1CZjvYUV2swif9FtqvD-afTZUttU7cqzEq2IhxNykxrI20c0ruGu8E8UB3jv7m1qiDfxihl2eShY3-PYL4xaDHTmLwfhQNvu42HFg_VLzTULC6-0tTfgD5pCit7Q.svg" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">2</div>
		</div>
		<div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_3.jpg" alt="영화 3">
		    <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAKcAAACnCAMAAABDyLzeAAAAaVBMVEXZLDX////eSE/iXmXxr7P1y8386+z2ztDuo6fbOkLjYWjslprtm6DeTFP53t/dQkrhWWDjZm3qjZLaNj/ogojfUVj+9/jxsLPlbXPmdHnaMTrzvcD41tj77e7++Pjyt7rof4T0w8bvqKsLZxsxAAACuklEQVR4nO3d0XaiMBAG4OBWEAQRUOyixcr7P+SqLAqlk0Rxm5k9/3/VC07Od6xMIOBEef34zSZLlPsk2abxBzJ1+6ue51vXvkG2+bweO8u4cA0bpYjLr8631DXq26S7ofNYuRYRqXZ9Z+6ao0l+dzauLdo0nTPg+k9vUwWt0w9dSwwJ/atz6dphTHxxfvCrm19TlGcn53O9y/Ls5DCfm5J4auXaYJWVil0TrBKrd9cEq/xWa9cEq0Rq5ppglZniPWd2kaFEEAQZJfS+z22SSPclcYh1DtF0Z25y7qcqzymnX7CvTE6fOOChTL7UWFMjv9b5a6qzkeGsPmQ438mReTnpk5mVkyqe3JwbIc6DDGeiGZmTcyHESRZPXk66ePJyHmU4w1o3Mh+npniycmqKJyenrnhycsZCnLriaec8fEb9ZJpp43lnZvgEzM7xsjp9Zj7v1BZPK+f4kWT6emehLZ5WzsVoUPpy9mnnp4HJxRnIcM5MTCbOpRCnuXizcEZGJg/njhyQl/OWNzjhhBNOOOGEE85e9qPRyIdmTp33Q7rQl2FOneVx2U+sWbBy6nwgcMIJJ5xwwgknnP+x8yTESb0oyM1pfuTAxFm84M3Kn3AqlS3mdiHfaP0Zp3XIrwiccMIJJ5xwwsnLSV51MHOSh8AJJ5xwwgknnHDCqXcyW18iD3kgcMIJJ5xwwgknnHDCCadc59R+QVbr3tOZk/sv2TjTye8zBDI6PSIIgkiLlP60MmaBSEz/ZCn9qKX095bSL11AO/+2//wL2oP+64SXfv4e/zNpcd3Hoea5Zcs9s7rdv+PAu8t3dfkp5fVG8eiaos31zqu9oeX8FW0bYP298T5xPemLk9d3eitee0l12XYdkW8LGXXDb5uZcHFrqNVbcCljXlNoEveeLA8XhoLNOuHwsYbJOh/+sPsPliE90NTv91MAAAAASUVORK5CYII=" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">3</div>
		</div>
		<div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_4.jpg" alt="영화 4">
		    <img src="https://i.namu.wiki/i/UA7u1h1BSfp2wQ8gGmQa-wCcl00QxF7MwSityvaTIGsyhx01dEhR69yKEAhsnQbikYCVNhDUudEZ5rpYIY89fDMjOlfi3MxlHe-eJq41Tl10V2FYy8kIF524tp9s0KHprIERPemzcL-uZhjIT23syQ.svg" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">4</div>
		</div> 
    </div>
    </div>
  </div>
		</div>
		
		
		<div id="UpcomingMovies" class="tab-content">
				<div class="poster-marquee">
    <div class="poster-track">
      <div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_1.jpg" alt="영화 1">
		    <img src="https://i.namu.wiki/i/g_VAsyPtPWVWXj2Xwh50VuGJNasfuRP7EXsIBNJFuJ7uM0qUwUQTomIiYp36VaUfjO-_p8B0nZ3R6PtXmu_XwaFuh8E3NHIwTxuEWRMQ7oyGOFNJF3Jep6bfxNIqIamtihoAgcNkaELR4aqLVAq7pQ.svg" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">1</div>
		</div>
		<div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_2.jpg" alt="영화 2">
		    <img src="https://i.namu.wiki/i/c4gbRUKYTVYyRwXE-yTKjSfq7w1CZjvYUV2swif9FtqvD-afTZUttU7cqzEq2IhxNykxrI20c0ruGu8E8UB3jv7m1qiDfxihl2eShY3-PYL4xaDHTmLwfhQNvu42HFg_VLzTULC6-0tTfgD5pCit7Q.svg" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">2</div>
		</div>
		<div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_3.jpg" alt="영화 3">
		    <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAKcAAACnCAMAAABDyLzeAAAAaVBMVEXZLDX////eSE/iXmXxr7P1y8386+z2ztDuo6fbOkLjYWjslprtm6DeTFP53t/dQkrhWWDjZm3qjZLaNj/ogojfUVj+9/jxsLPlbXPmdHnaMTrzvcD41tj77e7++Pjyt7rof4T0w8bvqKsLZxsxAAACuklEQVR4nO3d0XaiMBAG4OBWEAQRUOyixcr7P+SqLAqlk0Rxm5k9/3/VC07Od6xMIOBEef34zSZLlPsk2abxBzJ1+6ue51vXvkG2+bweO8u4cA0bpYjLr8631DXq26S7ofNYuRYRqXZ9Z+6ao0l+dzauLdo0nTPg+k9vUwWt0w9dSwwJ/atz6dphTHxxfvCrm19TlGcn53O9y/Ls5DCfm5J4auXaYJWVil0TrBKrd9cEq/xWa9cEq0Rq5ppglZniPWd2kaFEEAQZJfS+z22SSPclcYh1DtF0Z25y7qcqzymnX7CvTE6fOOChTL7UWFMjv9b5a6qzkeGsPmQ438mReTnpk5mVkyqe3JwbIc6DDGeiGZmTcyHESRZPXk66ePJyHmU4w1o3Mh+npniycmqKJyenrnhycsZCnLriaec8fEb9ZJpp43lnZvgEzM7xsjp9Zj7v1BZPK+f4kWT6emehLZ5WzsVoUPpy9mnnp4HJxRnIcM5MTCbOpRCnuXizcEZGJg/njhyQl/OWNzjhhBNOOOGEE85e9qPRyIdmTp33Q7rQl2FOneVx2U+sWbBy6nwgcMIJJ5xwwgknnP+x8yTESb0oyM1pfuTAxFm84M3Kn3AqlS3mdiHfaP0Zp3XIrwiccMIJJ5xwwsnLSV51MHOSh8AJJ5xwwgknnHDCqXcyW18iD3kgcMIJJ5xwwgknnHDCCadc59R+QVbr3tOZk/sv2TjTye8zBDI6PSIIgkiLlP60MmaBSEz/ZCn9qKX095bSL11AO/+2//wL2oP+64SXfv4e/zNpcd3Hoea5Zcs9s7rdv+PAu8t3dfkp5fVG8eiaos31zqu9oeX8FW0bYP298T5xPemLk9d3eitee0l12XYdkW8LGXXDb5uZcHFrqNVbcCljXlNoEveeLA8XhoLNOuHwsYbJOh/+sPsPliE90NTv91MAAAAASUVORK5CYII=" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">3</div>
		</div>
		<div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_4.jpg" alt="영화 4">
		    <img src="https://i.namu.wiki/i/UA7u1h1BSfp2wQ8gGmQa-wCcl00QxF7MwSityvaTIGsyhx01dEhR69yKEAhsnQbikYCVNhDUudEZ5rpYIY89fDMjOlfi3MxlHe-eJq41Tl10V2FYy8kIF524tp9s0KHprIERPemzcL-uZhjIT23syQ.svg" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">4</div>
		</div> 
      <!-- 복사해서 루프 느낌 줄 수 있음 -->
      <div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_1.jpg" alt="영화 1">
		    <img src="https://i.namu.wiki/i/g_VAsyPtPWVWXj2Xwh50VuGJNasfuRP7EXsIBNJFuJ7uM0qUwUQTomIiYp36VaUfjO-_p8B0nZ3R6PtXmu_XwaFuh8E3NHIwTxuEWRMQ7oyGOFNJF3Jep6bfxNIqIamtihoAgcNkaELR4aqLVAq7pQ.svg" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">1</div>
		</div>
		<div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_2.jpg" alt="영화 2">
		    <img src="https://i.namu.wiki/i/c4gbRUKYTVYyRwXE-yTKjSfq7w1CZjvYUV2swif9FtqvD-afTZUttU7cqzEq2IhxNykxrI20c0ruGu8E8UB3jv7m1qiDfxihl2eShY3-PYL4xaDHTmLwfhQNvu42HFg_VLzTULC6-0tTfgD5pCit7Q.svg" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">2</div>
		</div>
		<div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_3.jpg" alt="영화 3">
		    <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAKcAAACnCAMAAABDyLzeAAAAaVBMVEXZLDX////eSE/iXmXxr7P1y8386+z2ztDuo6fbOkLjYWjslprtm6DeTFP53t/dQkrhWWDjZm3qjZLaNj/ogojfUVj+9/jxsLPlbXPmdHnaMTrzvcD41tj77e7++Pjyt7rof4T0w8bvqKsLZxsxAAACuklEQVR4nO3d0XaiMBAG4OBWEAQRUOyixcr7P+SqLAqlk0Rxm5k9/3/VC07Od6xMIOBEef34zSZLlPsk2abxBzJ1+6ue51vXvkG2+bweO8u4cA0bpYjLr8631DXq26S7ofNYuRYRqXZ9Z+6ao0l+dzauLdo0nTPg+k9vUwWt0w9dSwwJ/atz6dphTHxxfvCrm19TlGcn53O9y/Ls5DCfm5J4auXaYJWVil0TrBKrd9cEq/xWa9cEq0Rq5ppglZniPWd2kaFEEAQZJfS+z22SSPclcYh1DtF0Z25y7qcqzymnX7CvTE6fOOChTL7UWFMjv9b5a6qzkeGsPmQ438mReTnpk5mVkyqe3JwbIc6DDGeiGZmTcyHESRZPXk66ePJyHmU4w1o3Mh+npniycmqKJyenrnhycsZCnLriaec8fEb9ZJpp43lnZvgEzM7xsjp9Zj7v1BZPK+f4kWT6emehLZ5WzsVoUPpy9mnnp4HJxRnIcM5MTCbOpRCnuXizcEZGJg/njhyQl/OWNzjhhBNOOOGEE85e9qPRyIdmTp33Q7rQl2FOneVx2U+sWbBy6nwgcMIJJ5xwwgknnP+x8yTESb0oyM1pfuTAxFm84M3Kn3AqlS3mdiHfaP0Zp3XIrwiccMIJJ5xwwsnLSV51MHOSh8AJJ5xwwgknnHDCqXcyW18iD3kgcMIJJ5xwwgknnHDCCadc59R+QVbr3tOZk/sv2TjTye8zBDI6PSIIgkiLlP60MmaBSEz/ZCn9qKX095bSL11AO/+2//wL2oP+64SXfv4e/zNpcd3Hoea5Zcs9s7rdv+PAu8t3dfkp5fVG8eiaos31zqu9oeX8FW0bYP298T5xPemLk9d3eitee0l12XYdkW8LGXXDb5uZcHFrqNVbcCljXlNoEveeLA8XhoLNOuHwsYbJOh/+sPsPliE90NTv91MAAAAASUVORK5CYII=" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">3</div>
		</div>
		<div class="movie-item">
		    <img src="http://localhost/movie_prj/common/img/main_movie_4.jpg" alt="영화 4">
		    <img src="https://i.namu.wiki/i/UA7u1h1BSfp2wQ8gGmQa-wCcl00QxF7MwSityvaTIGsyhx01dEhR69yKEAhsnQbikYCVNhDUudEZ5rpYIY89fDMjOlfi3MxlHe-eJq41Tl10V2FYy8kIF524tp9s0KHprIERPemzcL-uZhjIT23syQ.svg" alt="관람 등급 아이콘" class="rating-icon">
		    <div class="rank">4</div>
		</div> 
    </div>
  </div>

        </div>
          
      </div>
      
     <!-- 특별관 추가 -->
      <div class="sepecialHall_Wrap">
        <div class="contents">
            <div class="specialHall_title_wrap">
                <h2>특별관</h2>
                <a href="http://localhost/movie_prj/theater/theater_intro.jsp" class="btn_allView">전체보기 &gt;</a>
            </div>
            
            <div class="specialHall_content">
                <div class="hall_image_section">
                    <img id="hallImage" src="common/img/IMAX_main.jpg" 
                         alt="Special Hall" class="hall_image">
                    <div class="image_overlay">
                        <div id="hallName" class="hall_name">IMAX</div>
                        <div id="hallDesc" class="hall_description">#최고의 화질과 사운드</div>
                    </div>
                </div>
                
                <ul class="specialhall_list">
                    <li data-image="common/img/IMAX_main.jpg"
                        data-name="IMAX" 
                        data-desc="#최고의 화질과 사운드">
                        <div class="hall_title">IMAX</div>
                        <div class="hall_tag">최고의 화질과 사운드</div>
                    </li>
                    
                    <li data-image="common/img/4DX_main.jpg"
                        data-name="4DX" 
                        data-desc="#모션시트 #오감체험">
                        <div class="hall_title">4DX</div>
                        <div class="hall_tag">모션시트 #오감체험</div>
                    </li>
                    
                    <li data-image="common/img/screenX_mian.jpg"
                        data-name="SCREENX" 
                        data-desc="#270도 다면상영">
                        <div class="hall_title">SCREENX</div>
                        <div class="hall_tag">270도 다면상영</div>
                    </li>
                    
                    <li data-image="common/img/Premium_main.jpg"
                        data-name="PREMIUM" 
                        data-desc="#프리미엄 좌석 #럭셔리">
                        <div class="hall_title">PREMIUM</div>
                        <div class="hall_tag">프리미엄 좌석 #럭셔리</div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
      

</div>
</main>
<footer>
<jsp:include page="/common/jsp/footer.jsp" />
</footer>
</body>
</html>