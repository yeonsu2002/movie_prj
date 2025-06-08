<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
MovieService ms = new MovieService();
List<MovieDTO> movieList = ms.searchMovieChart();
request.setAttribute("movieList", movieList);

    int listSize = movieList.size();
    int randomIndex = (int)(Math.random() * listSize);
    MovieDTO randomMovie = movieList.get(randomIndex);
    
    String trailerUrl = randomMovie.getTrailerUrl();
    String videoId = "";

    if(trailerUrl.contains("youtu.be/")) {
        videoId = trailerUrl.substring(trailerUrl.lastIndexOf("/") + 1);
    } else if (trailerUrl.contains("watch?v=")) {
        videoId = trailerUrl.substring(trailerUrl.indexOf("v=") + 2);

        int eqIdx = videoId.indexOf("=");
        if (eqIdx != -1) {
        	videoId = videoId.substring(0, eqIdx);
        }
    }
    
String embedUrl = "https://www.youtube.com/embed/" + videoId + "?autoplay=1&mute=1&loop=1&playlist=" + videoId;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>연플릭스</title>
<jsp:include page="/common/jsp/external_file.jsp" />
<link rel="stylesheet" href="http://localhost/movie_prj/common/css/main_screen.css"/>
<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function() {
    // 스크롤 이벤트
    window.addEventListener("scroll", function() {
    	var buttonWrap = document.querySelector(".fixedBtn_wrap");
    	var goTopButton = document.querySelector(".btn_gotoTop");
    	var ticketingButton = document.querySelector(".btn_ticketing");
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
    
    var menuItems = document.querySelectorAll('.specialhall_list li');
    var image = document.getElementById('hallImage');
    var name = document.getElementById('hallName');
    var desc = document.getElementById('hallDesc');
    
    if (menuItems.length > 0 && image && name && desc) {
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
  src="<%= embedUrl %>" 
  frameborder="0" 
  allowfullscreen
  allow="autoplay; encrypted-media">
</iframe>
  <div class="trailer-overlay"></div>
</div>
</div>

<div id="container">

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

				<c:forEach var="movie" items="${movieList}" varStatus="status">
				    <div class="movie-item">
				    	<a href="movie_chart/sub_chart.jsp?movieIdx=${movie.movieIdx}">
				        <img src="/movie_prj/common/img/${movie.posterPath}" alt="${movie.movieName}" />
				    	</a>
				    <div class="rank">${status.index + 1}</div>
				    </div>
				</c:forEach>
				<c:forEach var="movie" items="${movieList}" varStatus="status">
				    <div class="movie-item">
				    	<a href="movie_chart/sub_chart.jsp?movieIdx=${movie.movieIdx}">
				        <img src="/movie_prj/common/img/${movie.posterPath}" alt="${movie.movieName}" />
				    	</a>
				    <div class="rank">${status.index + 1}</div>
				    </div>
				</c:forEach>
				<!-- <div class="movie-item">
				    <img src="http://localhost/movie_prj/common/img/main_movie_1.jpg" alt="영화 1">
				    <img src="http://localhost/movie_prj/common/img/age_12.png" alt="관람 등급 아이콘" class="rating-icon">
				</div> -->
		</div>
		</div>
	</div>

<div id="UpcomingMovies" class="tab-content">
	<div class="poster-marquee">
	<div class="poster-track">
	
			<c:forEach var="movie" items="${movieList}" varStatus="status">
				    <div class="movie-item">
				    	<a href="movie_chart/sub_chart.jsp?movieIdx=${movie.movieIdx}">
				        <img src="/movie_prj/common/img/${movie.posterPath}" alt="${movie.movieName}" />
				    	</a>
				    <div class="rank">${status.index + 1}</div>
				    </div>
				</c:forEach>
				<c:forEach var="movie" items="${movieList}" varStatus="status">
				    <div class="movie-item">
				    	<a href="movie_chart/sub_chart.jsp?movieIdx=${movie.movieIdx}">
				        <img src="/movie_prj/common/img/${movie.posterPath}" alt="${movie.movieName}" />
				    	</a>
				    <div class="rank">${status.index + 1}</div>
				    </div>
				</c:forEach>
				
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