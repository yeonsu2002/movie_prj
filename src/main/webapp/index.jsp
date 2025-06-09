<%@page import="kr.co.yeonflix.movie.code.MovieCommonCodeService"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8" info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<%
MovieService ms = new MovieService();
List<MovieDTO> movieList = ms.searchMovieChart();
List<MovieDTO> nonMovieList = ms.searchNonMovieChart();

List<MovieDTO> combinedList = new ArrayList<>();
if (movieList != null) combinedList.addAll(movieList);
if (nonMovieList != null) combinedList.addAll(nonMovieList);

request.setAttribute("movieList", movieList);
request.setAttribute("nonMovieList", nonMovieList);

MovieCommonCodeService mccs = new MovieCommonCodeService();
request.setAttribute("mccs", mccs);
// 예고편 있는 영화만 필터링 및 랜덤 선택하여 유튜브 임베드 URL 생성
String embedUrl = "";
List<MovieDTO> trailerMovies = new ArrayList<>();
for (MovieDTO movie : combinedList) {
    String trailerUrl = movie.getTrailerUrl();
    if (trailerUrl != null && !trailerUrl.trim().isEmpty()) {
        trailerMovies.add(movie);
    }
}
// videoId 추출
if (!trailerMovies.isEmpty()) {
    int randomIndex = (int)(Math.random() * trailerMovies.size());
    MovieDTO randomMovie = trailerMovies.get(randomIndex);
    String trailerUrl = randomMovie.getTrailerUrl();
    String videoId = "";

    if (trailerUrl.contains("youtu.be/")) {
        int idx = trailerUrl.lastIndexOf("/");
        if (idx != -1) {
            videoId = trailerUrl.substring(idx + 1);
            int paramIdx = videoId.indexOf("?");
            if (paramIdx != -1) {
                videoId = videoId.substring(0, paramIdx);
            }
        }
    } else if (trailerUrl.contains("watch?v=")) {
        int idx = trailerUrl.indexOf("v=") + 2;
        if (idx != -1) {
            videoId = trailerUrl.substring(idx);
            int endIdx = videoId.indexOf("&");
            if (endIdx == -1) endIdx = videoId.indexOf("=");
            if (endIdx != -1) {
                videoId = videoId.substring(0, endIdx);
            }
        }
    }

    if (!videoId.isEmpty()) {
        embedUrl = "https://www.youtube.com/embed/" + videoId + "?autoplay=1&mute=1&loop=1&playlist=" + videoId;
    }
}

//상영예정작 필터링
SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
String todayStr = sdf.format(new Date());
List<MovieDTO> upcomingMovieList = new ArrayList<>();
for (MovieDTO movie : combinedList) {
    if (movie.getReleaseDate() != null) {
        String releaseDateStr = sdf.format(movie.getReleaseDate());
        if (releaseDateStr.compareTo(todayStr) >= 0) {
            upcomingMovieList.add(movie);
        }
    }
}
request.setAttribute("upcomingMovieList", upcomingMovieList);
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
    window.addEventListener("scroll", function() {
       var buttonWrap = document.querySelector(".fixedBtn_wrap");
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
<iframe src="<%= embedUrl %>" allowfullscreen allow="autoplay; encrypted-media"></iframe>
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

<div class="content-area">
  <!-- 무비차트 탭 -->
  <div id="movieChart" class="tab-content active">
    <div class="poster-marquee">
    <div class="marquee">
    <div class="poster-track">
          <c:forEach var="movie" items="${movieList}" varStatus="status">
            <div class="movie-item">
              <a href="movie_chart/sub_chart.jsp?movieIdx=${movie.movieIdx}">
                <img src="/movie_prj/common/img/${movie.posterPath}" alt="${movie.movieName}" />
              </a>
              <div class="rank">${status.index + 1}</div>
              <img src="/movie_prj/common/img/icon_${ mccs.searchOneGrade(movie.movieIdx)}.svg" alt="관람 등급 아이콘" class="rating-icon" />
            </div>
          </c:forEach>

          <c:forEach var="movie" items="${nonMovieList}" varStatus="status">
            <div class="movie-item">
              <a href="movie_chart/sub_chart.jsp?movieIdx=${movie.movieIdx}">
                <img src="/movie_prj/common/img/${movie.posterPath}" alt="${movie.movieName}" />
              </a>
              <div class="rank">${movieList.size() + status.index + 1}</div>
            </div>
          </c:forEach>
    </div>
    </div>
    </div>
  </div>
  <!-- 상영예정작 탭 -->
  <div id="UpcomingMovies" class="tab-content">
    <div class="poster-marquee">
    <div class="marquee">
    <div class="poster-track">
          <c:forEach var="movie" items="${upcomingMovieList}" varStatus="status">
            <div class="movie-item">
              <a href="movie_chart/sub_chart.jsp?movieIdx=${movie.movieIdx}">
                <img src="/movie_prj/common/img/${movie.posterPath}" alt="${movie.movieName}" />
              </a>
              	<img src="/movie_prj/common/img/icon_${ mccs.searchOneGrade(movie.movieIdx)}.svg" alt="관람 등급 아이콘" class="rating-icon" />
            </div>
          </c:forEach>
    </div>
    </div>
    </div>
  </div>

</div>

<!-- 특별관 -->
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