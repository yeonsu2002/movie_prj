<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>CGV 무비차트 - 썬더볼츠</title>
    <link rel="stylesheet" href="http://localhost/team_prj/css/main_chart.css">
    <style>
        body {
            margin: 0;
            font-family: 'Arial', sans-serif;
            color: #fff;
        }

  
        .movie-detail-container {
            display: flex;
            gap: 30px;
        }

        .movie-poster img {
            width: 250px;
            border-radius: 8px;
        }

        .movie-info {
            flex: 1;
        }

        .movie-info h2 {
            margin-top: 0;
            font-size: 28px;
        }

        .movie-info p {
            margin: 8px 0;
        }

        .highlight {
            color: #FB4357;
            font-weight: bold;
        }

        .tab-menu {
            display: flex;
            list-style: none;
            border-bottom: 1px solid #555;
            padding: 0;
            margin-top: 40px;
        }

        .tab-menu li {
            padding: 10px 20px;
            cursor: pointer;
            color: gray;
        }

        .tab-menu li.active {
            border-bottom: 2px solid #FB4357;
            color: #FB4357;
            font-weight: bold;
        }

        .tab-content {
            display: none;
            padding: 20px 0;
        }

        .tab-content.active {
            display: block;
        }

        .btn {
            background-color: #FB4357;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        .interest-btn {
	    	background-color: #333;
	    	color: #FB4357;
	    	border: 1px solid #FB4357;
		}

		.interest-btn:hover {
    		background-color: #FB4357;
	    	color: #fff;
		}
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            $('.tab-menu li').click(function () {
                var tabId = $(this).data('tab');

                $('.tab-menu li').removeClass('active');
                $('.tab-content').removeClass('active');

                $(this).addClass('active');
                $('#' + tabId).addClass('active');

                window.location.hash = tabId;
            });

            if (window.location.hash) {
                const hash = window.location.hash.substring(1);
                $('[data-tab="' + hash + '"]').click();
            } else {
                $('.tab-menu li:first').click();
            }
        });
    </script>
</head>
<body>
    <header>
        <%@ include file="../common/jsp/header.jsp" %>
    </header>
    <main>
        <div id="container">
            <div class="movie-detail-container">
                <div class="movie-poster">
                    <img src="http://localhost/team_prj/common/img/chart17.jpg"> 
                </div>
                <div class="movie-info">
                    <h2>썬더볼츠</h2>
                    <p><span class="highlight">예매율:</span> 29.6%</p>
                    <p><span class="highlight">감독:</span> 제이크 슈라이어</p>
                    <p><span class="highlight">배우:</span> 플로렌스 퓨, 세바스찬 스탠, 와이엇 러셀, 율카 쿠렐렌코 외</p>
                    <p><span class="highlight">장르:</span> 액션</p>
                    <p><span class="highlight">기본 정보:</span> 12세이상관람가, 127분, 미국</p>
                    <p><span class="highlight">개봉:</span> 2025.04.30</p>
                    <button class="btn">예매하기</button>
                    <button class="btn interest-btn">❤ 관심 1004</button>
                </div>
            </div>

            <ul class="tab-menu">
                <li data-tab="main-info">주요정보</li>
                <li data-tab="trailer">트레일러</li>
                <li data-tab="still-cut">스틸컷</li>
                <li data-tab="review">평점/리뷰</li>
            </ul>

            <div id="main-info" class="tab-content">
                <h3>주요정보</h3>
                <p>초능력 없음, 히어로 없음, 포기도 없음!<br>
                4월, 마블 역사를 새로 쓸 빌런 놈들의 예측불가 팀업이 폭발한다!</p>
                <p>예벳예쓰가 사라진 세상, CIA 국장 ‘발렌티나’는 새로운 팀을 꾸릴 계획을 세운다.<br>
                그녀가 설계한 위험한 작전에 빠진 '옐레나', '윈터 솔져', '레드 가디언', '존 워커', '고스트', '태스크마스터'.</p>
                <p>빌런 놈들만 모인 이들은 이깟 일 쯤이야 한 팀이 되고,<br>
                자신들의 어두운 과거와 맞서야 하는 위험한 임무에 투입된다.<br>
                서로를 믿지 못하는 상황에서 스스로의 생존과 세상의 구원을 위해<br>
                이들은 전쟁과 음모로 가득한 마침표 없는 미션을 시작하는데…!</p>
            </div>

            <div id="trailer" class="tab-content">
                <h3>트레일러</h3>
                <p>영화 예고편 영상이 여기에 표시됩니다.</p>
            </div>

            <div id="still-cut" class="tab-content">
                <h3>스틸컷</h3>
                <p>영화 스틸 이미지가 여기에 표시됩니다.</p>
            </div>

            <div id="review" class="tab-content">
                <h3>평점/리뷰</h3>
                <p>관람객 평점과 리뷰가 여기에 표시됩니다.</p>
            </div>
        </div>
    </main>
    <footer>
        <%@ include file="../common/jsp/footer.jsp" %>
    </footer>
</body>
</html>
