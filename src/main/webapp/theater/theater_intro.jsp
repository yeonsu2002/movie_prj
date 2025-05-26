<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>특별관</title>
<jsp:include page="/common/jsp/external_file.jsp" />
<link rel="stylesheet" href="http://localhost/movie_prj/theater/theater.css/theater_intro.css"/>
<script type="text/javascript">
function showTab(tabName) {
    // 모든 탭 버튼에서 active 클래스 제거
    var buttons = document.querySelectorAll('.tab-button');
    buttons.forEach(button => button.classList.remove('active'));
    
    // 모든 탭 컨텐츠 숨기기
    var contents = document.querySelectorAll('.tab-content');
    contents.forEach(content => content.classList.remove('active'));
    
    // 클릭된 탭 버튼에 active 클래스 추가
    event.target.classList.add('active');
    
    // 해당 탭 컨텐츠 보이기
    document.getElementById(tabName).classList.add('active');
}
</script>
</head>
<body>
<header>
<jsp:include page="/common/jsp/header.jsp" />
</header>
<main>
<div id="container">
 
 <div class="special-cinema-container">
        <!-- 탭 버튼 영역 -->
        <div class="tab-buttons">
            <button class="tab-button active" onclick="showTab('imax')">IMAX</button>
            <button class="tab-button" onclick="showTab('threeD')">4DX</button>
            <button class="tab-button" onclick="showTab('screenx')">SCREENX</button>
            <button class="tab-button" onclick="showTab('premium')">PREMIUM</button>
        </div>
        
        <!-- 컨텐츠 영역 -->
        <div class="content-area">
            <!-- IMAX 탭 -->
            <div id="imax" class="tab-content active">
             <div class="cinema-top-image">
	        		<img src="http://localhost/movie_prj/common/img/IMAX_1.jpg" alt="IMAX 이미지" />
	    	 </div>
                <div class="cinema-layout">
                    <div class="cinema-info">
                        <h1 class="cinema-title imax">IMAX</h1>
                        <p class="cinema-description">
                            세계 최고 수준의 영상과 음향 기술로 만나는 극한의 몰입감을 경험하세요. 
                            IMAX만의 독특한 화면비와 초고해상도 영상, 그리고 전용 사운드 시스템으로 
                            영화 속 세계에 완전히 빠져들 수 있습니다.
                        </p>
                        <div class="features">
                            <div class="feature-item">
                                <div class="feature-icon">📺</div>
                                <div class="feature-title">IMAGE</div>
                                <div class="feature-desc">초고해상도 대형 스크린</div>
                            </div>
                            <div class="feature-item">
                                <div class="feature-icon">🖥️</div>
                                <div class="feature-title">SCREEN</div>
                                <div class="feature-desc">독특한 화면비와 크기</div>
                            </div>
                            <div class="feature-item">
                                <div class="feature-icon">🔊</div>
                                <div class="feature-title">SOUND</div>
                                <div class="feature-desc">전용 음향 시스템</div>
                            </div>
                        </div>
                    </div>
                    <div class="cinema-visual">
                        <div class="main-image"><img src="http://localhost/movie_prj/common/img/IMAX_2.jpg"/></div>
                    </div>
                </div>
            </div>
            
            <!-- 4DX 탭 -->
<div id="threeD" class="tab-content">
    <!-- 큰 상단 이미지 -->
    <div class="cinema-top-image">
        <img src="http://localhost/movie_prj/common/img/specialtheater_4dx1.jpg" alt="4DX 이미지" />
    </div>

    <!-- 콘텐츠 레이아웃 -->
    <div class="cinema-layout">
        <div class="cinema-info">
            <h1 class="cinema-title threeD">4DX</h1>
            <p class="cinema-description">
                <strong>FEEL IT IN 4DX</strong><br/>
                4DX 상영관은 영화의 장면에 맞추어 움직이는 모션시트와 더불어 바람, 빛, 안개, 향기, 진동 등의 
                다양한 환경 효과를 제공하는 <strong>오감 체험 특별 상영관</strong>입니다.<br/><br/>
                
                단순한 영화 관람을 넘어 영화 속 주인공이 된 듯한 체험을 할 수 있으며, 
                장면마다 생생함을 극대화시키는 4DX 효과를 통해 영화에 더욱 깊이 몰입할 수 있습니다.
            </p>

            <div class="features">
                <div class="feature-item">
                    <div class="feature-icon">🌪️</div>
                    <div class="feature-title">Environmental Effects</div>
                    <div class="feature-desc">바람, 향기, 안개 등 실감 효과</div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">🎢</div>
                    <div class="feature-title">Motion Seat</div>
                    <div class="feature-desc">상하·좌우·앞뒤로 움직이는 시트</div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">🎬</div>
                    <div class="feature-title">Immersive</div>
                    <div class="feature-desc">영화 속 공간에 들어온 듯한 몰입감</div>
                </div>
            </div>
        </div>

        <div class="cinema-visual">
            <div class="main-image"><img src="http://localhost/movie_prj/common/img/specialtheater_4dx2.jpg" alt="4DX 이미지" /></div>
            </div>
        </div>
    </div>

            
            <!-- SCREENX 탭 -->
            <div id="screenx" class="tab-content">
            <div class="cinema-top-image">
	        		<img src="http://localhost/movie_prj/common/img/screenX_1.jpg" alt="screenX 이미지" />
	    	 </div>
                <div class="cinema-layout">
                    <div class="cinema-info">
                        <h1 class="cinema-title screenx">SCREENX</h1>
                        <p class="cinema-description">
                            270도 파노라마 스크린으로 영화 속 주인공이 된 듯한 경험을 선사합니다. 
                            좌우 벽면까지 확장된 스크린으로 시야 전체를 감싸는 
                            전례 없는 몰입감을 느껴보세요.
                        </p>
                        <div class="features">
                            <div class="feature-item">
                                <div class="feature-icon">📐</div>
                                <div class="feature-title">270°</div>
                                <div class="feature-desc">파노라마 스크린</div>
                            </div>
                            <div class="feature-item">
                                <div class="feature-icon">👁️</div>
                                <div class="feature-title">VISION</div>
                                <div class="feature-desc">확장된 시야</div>
                            </div>
                            <div class="feature-item">
                                <div class="feature-icon">🌟</div>
                                <div class="feature-title">EXPERIENCE</div>
                                <div class="feature-desc">새로운 경험</div>
                            </div>
                        </div>
                    </div>
                    <div class="cinema-visual">
                        <div class="main-image"><img src="http://localhost/movie_prj/common/img/screenX_2.jpg" alt="screenX 이미지"/></div>
                        </div>
                    </div>
                </div>
            
            <!-- PREMIUM 탭 -->
            <div id="premium" class="tab-content">
            <div class="cinema-top-image">
	        		<img src="http://localhost/movie_prj/common/img/premium1.jpg" alt="PREMIUM 이미지" />
	    	 </div>
                <div class="cinema-layout">
                    <div class="cinema-info">
                        <h1 class="cinema-title premium">PREMIUM</h1>
                        <p class="cinema-description">
                            프리미엄한 좌석과 최고급 서비스로 특별한 영화 관람을 즐기세요. 
                            넓고 편안한 리클라이너 좌석과 개인 테이블, 그리고 
                            프리미엄 음료 서비스까지 제공됩니다.
                        </p>
                        <div class="features">
                            <div class="feature-item">
                                <div class="feature-icon">🛋️</div>
                                <div class="feature-title">SEAT</div>
                                <div class="feature-desc">리클라이너 좌석</div>
                            </div>
                            <div class="feature-item">
                                <div class="feature-icon">☕</div>
                                <div class="feature-title">SERVICE</div>
                                <div class="feature-desc">프리미엄 서비스</div>
                            </div>
                            <div class="feature-item">
                                <div class="feature-icon">✨</div>
                                <div class="feature-title">COMFORT</div>
                                <div class="feature-desc">최고급 편의시설</div>
                            </div>
                        </div>
                    </div>
                    <div class="cinema-visual">
                        <div class="main-image"><img src="http://localhost/movie_prj/common/img/premium2.jpg" alt="PREMIUM 이미지"/></div>
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