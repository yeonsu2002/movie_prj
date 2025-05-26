<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상영관 소개</title>
<jsp:include page="/common/jsp/external_file.jsp" />
<link rel="stylesheet" href="http://localhost/movie_prj/theater/theater.css/theater_main.css"/>
<script type="text/javascript">
function goToTheaterList() {
    // 상영관 목록 페이지로 이동
    // 실제 JSP 파일명으로 변경하세요
    window.location.href = 'theater_intro.jsp';
}

// 페이지 로드 시 애니메이션 효과
window.addEventListener('load', function() {
    const card = document.querySelector('.theater-card');
    card.style.opacity = '0';
    card.style.transform = 'translateY(50px)';
    
    setTimeout(() => {
        card.style.transition = 'all 0.8s ease';
        card.style.opacity = '1';
        card.style.transform = 'translateY(0)';
    }, 100);
});
</script>
</head>
<body>
<header>
<jsp:include page="/common/jsp/header.jsp" />
</header>
<main>
<div id="container">
<div class="theater-container">
       <div class="theater-container">
        <h1 class="theater-title">YEONFLIX</h1>
        
        <div class="theater-image-section">
            <div class="theater-background-image">
                <!-- 여기에 극장 배경 이미지를 넣으세요 -->
                <img src="http://localhost/movie_prj/common/img/theater_main.jpg"/>
            </div>
            <div class="theater-overlay">
                <div class="theater-info-left">
                    <div class="theater-description">
                        서울 강남구 테헤란로 132 한독빌딩 8층스<br>
                        서울특별시 강남구 역삼로 지하철 2호선 (역삼역)
                    </div>
                    
                    <div class="theater-contact">
                        <div class="contact-item">1577-1577</div>
                        <div class="contact-item">8층</div>
                    </div>
                </div>
                
                <div class="theater-info-right">
                    <button class="visit-button" onclick="goToTheaterList()">
                        상영관 보러가기
                    </button>
                </div>
            </div>
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