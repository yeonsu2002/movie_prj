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
    window.location.href = 'theater_intro.jsp';
}
function scrollToParkingInfo() {
    const target = document.getElementById("parkingInfo");
    if (target) {
        target.scrollIntoView({ behavior: "smooth" });
    }
}
</script>
</head>
<body>
<header>
<jsp:include page="/common/jsp/header.jsp" />
</header>
<main>
<div id="container">
    <div class="theater-container">
        <h1 class="theater-title">YEONFLIX</h1>

        <div class="theater-image-section">
            <div class="theater-background-image">
                <img src="http://localhost/movie_prj/common/img/theater_main.jpg" alt="상영관 이미지" />
            </div>
            <div class="theater-overlay">
                <div class="theater-info-left">
                    <div class="theater-description">
                        서울 강남구 테헤란로 132 한독빌딩 8층<br />
                        서울특별시 강남구 역삼로 지하철 2호선 (역삼역)
                    </div>
                    <div class="addressInfo" style="font-size:12px; color:#A9A9A9; margin-bottom:15px; cursor:pointer;" onclick="scrollToParkingInfo()">
                        위치/주차안내 &gt;
                    </div>
                    <div class="theater-contact">
                        <div class="contact-item">1577-1577</div>
                        <div class="contact-item">8층</div>
                    </div>
                </div>
                <div class="theater-info-right">
                    <button class="visit-button" onclick="goToTheaterList()">상영관 보러가기</button>
                </div>
            </div>
        </div>

        <div class="parking_container">
            <div class="parking_map" id="map"></div>
            <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=0f0b3bb7c0f56621f9817ea53cbc8e85"></script>
            <script>
                var map = new kakao.maps.Map(document.getElementById('map'), {
                    center: new kakao.maps.LatLng(37.499473, 127.033253),
                    level: 3
                });
                var marker = new kakao.maps.Marker({
                    position: new kakao.maps.LatLng(37.499473, 127.033253)
                });
                marker.setMap(map);
            </script>

            <div class="parking_info" id="parkingInfo">
                <h2><span class="parking_icon"><img src="http://localhost/movie_prj/common/img/parking_icon.png" alt="주차 아이콘" />
                </span>주차안내</h2>
                <hr/>
                ■ 주차안내 (발렛주차)<br/>
                - 한독빌딩 건물 지상1층<br/>
                - 발렛서비스 운영시간<br/>
                : 오전 8시 이후 ~ 오후 24시<br/>
                : 발렛 무료 서비스는 영화 관람 고객 한 함 (영화 미관람 시 별도 정산)<br/>
                (22시 이후 입차 차량은 발렛서비스 제한 가능, 주차팀 사정에 따라 변경)<br/><br/>

                ■ 주차확인 (인증방법)<br/>
                - 출차 시 영화티켓 제시 (모바일/지류 모두 가능)<br/><br/>

                ■ 주차요금<br/>
                - 영화 관람 시 3시간 5,000원<br/>
                - 초과 시 10분 당 1,000원<br/>
            </div>
        </div>
    </div>
</div>
</main>

<footer><jsp:include page="/common/jsp/footer.jsp" /></footer>
</body>
</html>