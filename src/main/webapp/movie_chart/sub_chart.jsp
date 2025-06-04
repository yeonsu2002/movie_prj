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
    List<MovieCommonCodeDTO> commonCodeList = new ArrayList<MovieCommonCodeDTO>();
    commonCodeList = mccs.searchCommon(movieIdx);
    
    List<CommonDTO> genList = new ArrayList<CommonDTO>();
    List<CommonDTO> graList = new ArrayList<CommonDTO>();
    CommonService cs = new CommonService();
    genList = cs.genreList();
    graList = cs.gradeList();
    %>
    
<%
	int movieGenre = 0;
	int movieGrade = 0;
	MovieCommonCodeDTO mccDTO2 = new MovieCommonCodeDTO();
	for(MovieCommonCodeDTO mccDTO : commonCodeList){
		if("장르".equals(mccDTO.getCodeType())){
			movieGenre = mccDTO.getCodeIdx();
		}
		if("등급".equals(mccDTO.getCodeType())){
			movieGrade = mccDTO.getCodeIdx();
			
		}
	}
	
	String genre = "";
	String grade = "";
	for(CommonDTO cDTO : genList){
		if(cDTO.getCodeIdx() == movieGenre){
			
			genre = cDTO.getMovieCodeType();
			
		}
	}
	for(CommonDTO cDTO : graList){
		if(cDTO.getCodeIdx() == movieGrade){
			grade = cDTO.getMovieCodeType();
		}
	}
	
	
	
	request.setAttribute("genre", genre);
	request.setAttribute("grade", grade);
	
	
	
%>    
    <meta charset="UTF-8">
    <jsp:include page="../common/jsp/external_file.jsp" />
    <title>CGV 무비차트 - <%=mDTO.getMovieName() %> </title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            line-height: 1.6;
            background-color: #ffffff;
            color: #333;
            margin: 0;
            padding: 0;
        }

        /* 메인 컨테이너 */
        #container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #ffffff;
        }

        /* 영화 상세 정보 컨테이너 */
        .movie-detail-container {
            display: flex;
            gap: 30px;
            background: #ffffff;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        /* 포스터 이미지 */
        .movie-poster {
            flex-shrink: 0;
        }

        .movie-poster img {
            width: 250px;
            height: 350px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        /* 영화 정보 */
        .movie-info {
            flex: 1;
            padding-left: 20px;
        }

        .movie-title {
            font-size: 28px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .age-rating {
            background: #FB4357;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .rating-info {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .rating-percentage {
            font-size: 16px;
            color: #666;
        }

        .rating-star {
            color: #FFB800;
            font-size: 16px;
        }

        .movie-details {
            margin-bottom: 20px;
        }

        .movie-details p {
            margin: 8px 0;
            font-size: 14px;
            color: #666;
        }

        .detail-label {
            font-weight: bold;
            color: #333;
            min-width: 60px;
            display: inline-block;
        }

        /* 버튼 컨테이너 */
        .button-container {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn-favorite {
            background: #ffffff;
            border: 1px solid #ddd;
            color: #666;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .btn-favorite:hover {
            background: #f5f5f5;
        }

        .btn-reservation {
            background: #FB4357;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        }

        .btn-reservation:hover {
            background: #e03a4e;
        }

        /* 탭 메뉴 */
        .tab-menu {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
            background: #FB4357;
            border-radius: 4px;
            overflow: hidden;
        }

        .tab-menu li {
            flex: 1;
            padding: 12px 20px;
            cursor: pointer;
            color: white;
            text-align: center;
            font-weight: 500;
            font-size: 14px;
            transition: background 0.3s ease;
        }

        .tab-menu li:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .tab-menu li.active {
            background: rgba(255, 255, 255, 0.2);
            font-weight: bold;
        }

        /* 탭 콘텐츠 */
        .tab-content {
            display: none;
            padding: 30px 20px;
            background: #ffffff;
            border: 1px solid #e0e0e0;
            border-top: none;
            min-height: 400px;
            color: #333;
            font-size: 14px;
            line-height: 1.6;
        }

        .tab-content.active {
            display: block;
        }

        .tab-content h3 {
            color: #333;
            margin: 0 0 20px 0;
            font-size: 18px;
            font-weight: bold;
        }

        /* 트레일러 컨테이너 */
        .trailer-container {
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .trailer-preview {
            position: relative;
            width: 100%;
            height: 300px;
            background: #f5f5f5;
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer;
            transition: transform 0.3s ease;
            border: 1px solid #e0e0e0;
        }
        
        .trailer-preview:hover {
            transform: scale(1.02);
        }
        
        .trailer-background {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('https://i.ytimg.com/vi/HAfCX54YmB4/maxresdefault.jpg');
            background-size: cover;
            background-position: center;
            opacity: 0.8;
        }
        
        .trailer-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .play-button {
            width: 60px;
            height: 60px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        
        .play-button:hover {
            background: rgba(255, 255, 255, 1);
            transform: scale(1.1);
        }
        
        .play-button::before {
            content: '';
            width: 0;
            height: 0;
            border-left: 16px solid #333;
            border-top: 10px solid transparent;
            border-bottom: 10px solid transparent;
            margin-left: 3px;
        }
        
        .trailer-iframe {
            display: none;
            width: 100%;
            height: 450px;
            border: none;
            border-radius: 8px;
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .movie-detail-container {
                flex-direction: column;
                gap: 20px;
                padding: 15px;
            }
            
            .movie-poster img {
                width: 200px;
                height: 280px;
                margin: 0 auto;
                display: block;
            }
            
            .movie-info {
                padding-left: 0;
                text-align: center;
            }
            
            .tab-menu {
                flex-direction: column;
            }
            
            .tab-menu li {
                padding: 10px 15px;
                font-size: 13px;
            }
            
            .button-container {
                justify-content: center;
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
            <div class="movie-detail-container">
                <div class="movie-poster">
                    <img src="/movie_prj/common/img/<%=mDTO.getPosterPath() %>" alt="<%=mDTO.getMovieName() %>"/>
                </div>
                <div class="movie-info">
                    <div class="movie-title">
                        <span class="age-rating">15</span>
                        <%=mDTO.getMovieName() %>
                    </div>
                    
                    <div class="rating-info">
                        <span class="rating-percentage">예매율 9.1%</span>
                        <span class="rating-star">⭐ 97%</span>
                    </div>
                    
                    <div class="movie-details">
                        <p><span class="detail-label">감독:</span> <%= mDTO.getDirectors()%></p>
                        <p><span class="detail-label">배우:</span> <%= mDTO.getActors()%></p>
                        <p><span class="detail-label">장르:</span> ${genre}</p>
                        <p><span class="detail-label">기본:</span> ${grade}세이상관람가, <%= mDTO.getRunningTime() %>분, <%=mDTO.getCountry() %></p>
                        <p><span class="detail-label">개봉:</span> <%= mDTO.getReleaseDate() %></p>
                    </div>
                    
                    <div class="button-container">
                        <button class="btn-favorite">🤍 보고싶어요</button>
                        <button class="btn-reservation">예매하기</button>
                    </div>
                </div>
            </div>

            <ul class="tab-menu">
                <li data-tab="main-info" class="active">주요정보</li>
                <li data-tab="trailer">트레일러</li>
                <li data-tab="review">평점/리뷰</li>
            </ul>

            <div id="main-info" class="tab-content active">
                <h3>주요정보</h3>
                <%= mDTO.getMovieDescription() %>
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
                      allow="autoplay; encrypted-media">
                    </iframe>
                </div>
            </div>

            

            <div id="review" class="tab-content">
                <h3>평점/리뷰</h3>
                <p>관람객 평점과 리뷰가 여기에 표시됩니다.</p>
            </div>

            
        </div>
    </main>
    
    <footer>
        <jsp:include page="../common/jsp/footer.jsp" />
    </footer>
</body>
</html>