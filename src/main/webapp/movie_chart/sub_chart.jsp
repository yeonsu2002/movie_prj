<%@page import="kr.co.yeonflix.movie.common.CommonService"%>
<%@page import="kr.co.yeonflix.movie.common.CommonDTO"%>
<%@page import="kr.co.yeonflix.movie.code.MovieCommonCodeDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.movie.code.MovieCommonCodeService"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<%
    int movieIdx = Integer.parseInt(request.getParameter("movieIdx"));
    MovieService ms = new MovieService();
    MovieDTO mDTO = ms.searchOneMovie(movieIdx);
    MovieCommonCodeService mccs = new MovieCommonCodeService();
    
    request.setAttribute("genre", mccs.searchOneGenre(movieIdx));
    request.setAttribute("grade", mccs.searchOneGrade(movieIdx));
    
    String reservationRate = request.getParameter("reservationRate");
%>    
    <meta charset="UTF-8">
    <jsp:include page="../common/jsp/external_file.jsp" />
    <title>CGV 무비차트 - <%=mDTO.getMovieName() %> </title>
    <style>
        body {
            font-family: 'Malgun Gothic', sans-serif;
            line-height: 1.6;
            
            color: #333;
            margin: 0;
            padding: 0;
        }

        

        /* 메인 컨테이너 */
        #container {
            max-width: 980px;
            margin: 0 auto;
            padding: 0;
            background-color: #ffffff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        /* 영화 정보 섹션 */
        .movie-info-section {
            background: #ffffff;
            padding: 30px;
            border-bottom: 1px solid #e5e5e5;
        }

        .movie-detail-container {
            display: flex;
            gap: 30px;
        }

        /* 포스터 이미지 */
        .movie-poster {
            flex-shrink: 0;
        }

        .movie-poster img {
            width: 185px;
            height: 260px;
            object-fit: cover;
            border: 1px solid #ddd;
        }

        /* 영화 정보 */
        .movie-info {
            flex: 1;
        }

        .movie-title-container {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 15px;
        }

        .movie-title {
            font-size: 24px;
            font-weight: bold;
            color: #222;
        }

        .age-rating {
            display: inline-block;
            width: 22px;
            height: 22px;
            background: #f80;
            color: white;
            text-align: center;
            line-height: 22px;
            font-size: 11px;
            font-weight: bold;
            border-radius: 2px;
        }

        .age-rating.all {
            background: #00b04f;
        }

        .movie-meta {
            margin-bottom: 20px;
        }

        .rating-container {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }

        .reservation-rate {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .reservation-rate .label {
            font-size: 12px;
            color: #666;
        }

        .reservation-rate .percent {
            font-size: 16px;
            font-weight: bold;
            color: #fb4357;
        }

        .movie-details {
            font-size: 13px;
            line-height: 1.8;
            color: #666;
        }

        .movie-details div {
            margin-bottom: 5px;
        }

        .detail-label {
            color: #333;
            font-weight: normal;
            display: inline-block;
            width: 50px;
        }

        /* 버튼 영역 */
        .action-buttons {
            display: flex;
            gap: 8px;
            margin-top: 20px;
        }

        .btn-like {
            background: #fff;
            border: 1px solid #ddd;
            color: #666;
            padding: 8px 15px;
            font-size: 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .btn-like:hover {
            background: #f9f9f9;
        }

        .btn-reserve {
            background: #fb4357;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-reserve:hover {
            background: #e03a4e;
        }

        /* 탭 메뉴 */
        .tab-navigation {
            background: #fff;
            border-bottom: 1px solid #ddd;
        }

        .tab-menu {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
            max-width: 980px;
            margin: 0 auto;
        }

        .tab-menu li {
            padding: 15px 20px;
            cursor: pointer;
            color: #666;
            font-size: 14px;
            border-bottom: 3px solid transparent;
            transition: all 0.3s ease;
        }

        .tab-menu li:hover {
            color: #fb4357;
        }

        .tab-menu li.active {
            color: #fb4357;
            border-bottom-color: #fb4357;
            font-weight: bold;
        }

        /* 탭 콘텐츠 */
        .tab-content-container {
            background: #fff;
            min-height: 500px;
        }

        .tab-content {
            display: none;
            padding: 40px 30px;
            max-width: 980px;
            margin: 0 auto;
        }

        .tab-content.active {
            display: block;
        }

        .tab-content h3 {
            font-size: 18px;
            color: #222;
            margin: 0 0 20px 0;
            font-weight: bold;
        }

        .movie-description {
            font-size: 14px;
            line-height: 1.7;
            color: #555;
        }

        /* 트레일러 섹션 */
        .trailer-container {
            text-align: center;
        }

        .trailer-preview {
            position: relative;
            width: 100%;
            max-width: 640px;
            height: 360px;
            margin: 0 auto;
            background: #000;
            cursor: pointer;
            overflow: hidden;
        }

        .trailer-background {
            width: 100%;
            height: 100%;
            background-image: url('https://i.ytimg.com/vi/HAfCX54YmB4/maxresdefault.jpg');
            background-size: cover;
            background-position: center;
        }

        .trailer-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .play-button {
            width: 70px;
            height: 70px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .play-button:hover {
            background: rgba(255, 255, 255, 1);
            transform: scale(1.1);
        }

        .play-button::before {
            content: '';
            width: 0;
            height: 0;
            border-left: 20px solid #333;
            border-top: 12px solid transparent;
            border-bottom: 12px solid transparent;
            margin-left: 4px;
        }

        .trailer-iframe {
            display: none;
            width: 100%;
            max-width: 640px;
            height: 360px;
            border: none;
            margin: 0 auto;
        }

        /* 리뷰 섹션 */
        .review-placeholder {
            text-align: center;
            padding: 60px 20px;
            color: #999;
            font-size: 14px;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            #container {
                margin: 0 10px;
            }

            .movie-detail-container {
                flex-direction: column;
                text-align: center;
            }

            .movie-poster img {
                width: 150px;
                height: 210px;
                margin: 0 auto;
            }

            .tab-menu {
                flex-wrap: wrap;
            }

            .tab-menu li {
                flex: 1;
                text-align: center;
                min-width: 80px;
                padding: 12px 10px;
                font-size: 13px;
            }

            .tab-content {
                padding: 30px 20px;
            }
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
        
        function playTrailer() {
            $('.trailer-preview').hide();
            $('#trailer-iframe').show();
        }
    </script>
</head>
<body>
    <header>
        <jsp:include page="../common/jsp/header.jsp" />
    </header>
    
    
    
    <main>
        <div id="container">
            <div class="movie-info-section">
                <div class="movie-detail-container">
                    <div class="movie-poster">
                        <img src="/movie_prj/common/img/<%=mDTO.getPosterPath() %>" alt="<%=mDTO.getMovieName() %>"/>
                    </div>
                    <div class="movie-info">
                        <div class="movie-title-container">
                            <span class="age-rating all">ALL</span>
                            <h1 class="movie-title"><%=mDTO.getMovieName() %></h1>
                        </div>
                        
                        <div class="rating-container">
                            <div class="reservation-rate">
                                <span class="label">예매율</span>
                                <span class="percent"><%=reservationRate%>%</span>
                                <span style="margin-left: 5px;">⭐</span>
                                <span style="color: #f80; font-weight: bold;">99%</span>
                            </div>
                        </div>
                        
                        <div class="movie-details">
                            <div><span class="detail-label">감독</span>: <%= mDTO.getDirectors()%></div>
                            <div><span class="detail-label">배우</span>: <%= mDTO.getActors()%></div>
                            <div><span class="detail-label">장르</span>: ${genre}, 액션, 어드벤처, 나인 코믹스, 중국 대륙</div>
                            <div><span class="detail-label">기본</span>: ${grade}세이상관람가, <%= mDTO.getRunningTime() %>분, <%=mDTO.getCountry() %></div>
                            <div><span class="detail-label">개봉</span>: <%= mDTO.getReleaseDate() %></div>
                        </div>
                        
                        <div class="action-buttons">
                            <button class="btn-like">🤍 보고싶어요</button>
                            <button class="btn-reserve">예매하기</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tab-navigation">
                <ul class="tab-menu">
                    <li data-tab="main-info" class="active">주요정보</li>
                    <li data-tab="trailer">트레일러</li>
                    <li data-tab="review">실관람평</li>
                </ul>
            </div>

            <div class="tab-content-container">
                <div id="main-info" class="tab-content active">
                    <h3>줄거리</h3>
                    <div class="movie-description">
                        <%= mDTO.getMovieDescription() %>
                    </div>
                </div>

                <div id="trailer" class="tab-content">
                    <h3>트레일러</h3>
                    <div class="trailer-container">
                        <div class="trailer-preview" onclick="playTrailer()">
                            <div class="trailer-background"></div>
                            <div class="trailer-overlay">
                                <div class="play-button"></div>
                            </div>
                        </div>
                        <iframe id="trailer-iframe" class="trailer-iframe"
                          src="https://www.youtube.com/embed/HAfCX54YmB4?autoplay=1" 
                          frameborder="0" 
                          allowfullscreen
                          allow="encrypted-media">
                        </iframe>
                    </div>
                </div>

                <div id="review" class="tab-content">
                    <h3>실관람평</h3>
                    <div class="review-placeholder">
                        관람객 평점과 리뷰가 여기에 표시됩니다.
                    </div>
                </div>

                
            </div>
        </div>
    </main>
    
    <footer>
        <jsp:include page="../common/jsp/footer.jsp" />
    </footer>
</body>
</html>