<%@page import="kr.co.yeonflix.movie.common.CommonDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.yeonflix.movie.common.CommonService"%>
<%@page import="kr.co.yeonflix.movie.code.MovieCommonCodeService"%>
<%@page import="kr.co.yeonflix.movie.code.MovieCommonCodeDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"
info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>YEONFLIX 무비차트</title>

<jsp:include page="../common/jsp/external_file.jsp" />

<style type="text/css">

#container {
    min-height: 650px;
    background-color: #ffffff; /* 흰색 배경으로 변경 */
    padding: 40px 0;
}

/* 반응형 그리드 */
@media (max-width: 1200px) {
    .movie-chart {
        grid-template-columns: repeat(3, 1fr);
        max-width: 900px;
    }
}

@media (max-width: 768px) {
    .movie-chart {
        grid-template-columns: repeat(2, 1fr);
        max-width: 600px;
        gap: 20px;
        padding: 20px 10px;
    }
}

@media (max-width: 480px) {
    .movie-chart {
        grid-template-columns: 1fr;
        max-width: 300px;
    }
}

/* 무비차트 컨테이너 스타일 */
.movie-chart {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 30px;
    max-width: 1200px;
    margin: 0 auto;
    padding: 40px 20px;
}

.movie-item {
    width: 100%;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1); /* 연한 그림자 */
    background: #ffffff; /* 흰색 배경 */
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    border: 1px solid #e0e0e0; /* 연한 테두리 추가 */
}

.movie-item:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 16px rgba(0,0,0,0.15);
}

.box-image {
    position: relative;
    width: 100%;
    height: 300px;
}

.box-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}

.rank {
    position: absolute;
    top: 8px;
    left: 8px;
    width: 45px;
    height: 22px;
    background: #FB4357;
    color: white;
    font-weight: bold;
    text-align: center;
    border-radius: 4px;
    box-sizing: border-box;
    line-height: 22px;
    font-size: 11px;
    z-index: 2;
}

.box-contents {
    padding: 15px;
    background: #ffffff;
}

.box-contents .title {
    color: #333333; /* 어두운 회색 텍스트 */
    font-size: 16px;
    font-weight: bold;
    margin-bottom: 10px;
    display: block;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    line-height: 1.3;
}

.score {
    margin-bottom: 8px;
}

.score .percent {
    font-size: 13px;
    color: #666666; /* 회색 텍스트 */
    font-weight: normal;
    display: flex;
    align-items: center;
}

/* 별점 아이콘 스타일 */
.score .percent::before {
    content: "⭐";
    margin-right: 4px;
    font-size: 12px;
}

.txt-info {
    font-size: 12px;
    color: #888888;
    margin-bottom: 15px;
    display: block;
}

.link-reservation {
    display: block;
    background: #FB4357;
    color: white;
    padding: 10px 15px;
    border-radius: 6px;
    text-decoration: none;
    font-size: 13px;
    text-align: center;
    font-weight: bold;
    transition: background 0.3s ease;
}

.link-reservation:hover {
    background: #e03a4e;
    text-decoration: none;
    color: white;
}

/* 등급 아이콘 스타일 */
.rating-icon {
    display: inline-block;
    width: 20px;
    height: 20px;
/*     background: #FB4357;
    color: white;
    text-align: center;
    line-height: 20px;
    font-size: 10px;
    font-weight: bold;
    border-radius: 3px;
    margin-right: 8px;
    vertical-align: middle; */
}

/* 제목과 등급을 함께 표시하는 스타일 */
.title-with-rating {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
}

.title-with-rating .title {
    margin-bottom: 0;
    flex: 1;
}

/* 이미지 로딩 실패시 대체 스타일 */
.box-image img[alt]:after {
    content: attr(alt);
    display: block;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: #f5f5f5;
    color: #999;
    text-align: center;
    padding: 10px;
}
</style>
</head>
<body>
<%
MovieService ms = new MovieService();




int movieGenre = 0;
int movieGrade = 0;
List<MovieDTO> movieChart = ms.searchMovieChart();
List<MovieDTO> nonMovieChart = ms.searchNonMovieChart();




MovieCommonCodeService mccs = new MovieCommonCodeService();
 




request.setAttribute("movieChart", movieChart);
request.setAttribute("nonMovieChart", nonMovieChart);
request.setAttribute("ms", ms);
request.setAttribute("mccs", mccs);



%>
<header>
<jsp:include page="../common/jsp/header.jsp" />
</header>
<main>
<div id="container">
    <div class="movie-chart">
        <c:forEach var="m" items="${movieChart}" varStatus="status">
            <div class="movie-item">
                <div class="box-image">
                    <a href="sub_chart.jsp?movieIdx=${m.movieIdx}&reservationRate=${ms.reservationRate(m.movieIdx)}">
                        <img src="/movie_prj/common/img/${m.posterPath}" alt="${m.movieName}"/> 
                    </a>
                    <strong class="rank">No.${status.index + 1}</strong>
                    
                </div>
                <div class="box-contents">
                    <div class="title-with-rating">
                        <span class="rating-icon">
                        <img src="http://localhost/movie_prj/common/img/icon_${ mccs.searchOneGrade(m.movieIdx)}.svg" />
                        </span>
                        
                        <strong class="title">${m.movieName}</strong>
                    </div>

                    <div class="score">
                        <strong class="percent">${ms.reservationRate(m.movieIdx)}%</strong>
                    </div>

                    <span class="txt-info">
                        <fmt:formatDate value="${m.releaseDate}" pattern="yyyy.MM.dd"/> 개봉
                    </span>

                    <a href="../reservation/reservation.jsp" class="link-reservation">예매</a>
                </div>
            </div>
        </c:forEach> 
		<c:set var="movieChartSize" value="${fn:length(movieChart)}" />        
        <c:forEach var="nm" items="${nonMovieChart}" varStatus="status">
            <div class="movie-item">
                <div class="box-image">
                    <a href="sub_chart.jsp?movieIdx=${nm.movieIdx}&reservationRate=${ms.reservationRate(nm.movieIdx)}">
                        <img src="/movie_prj/common/img/${nm.posterPath}" alt="${nm.movieName}"/> 
                    </a>
                    <strong class="rank">No.${movieChartSize + status.index + 1}</strong>
                </div>
                <div class="box-contents">
                    <div class="title-with-rating">
                        <span class="rating-icon">
                        <img src="http://localhost/movie_prj/common/img/icon_${ mccs.searchOneGrade(nm.movieIdx)}.svg" />
                        </span>
                        <strong class="title">${nm.movieName}</strong>
                    </div>

                    <div class="score">
                        <strong class="percent">${ms.reservationRate(nm.movieIdx)}%</strong>
                    </div>

                    <span class="txt-info">
                        <fmt:formatDate value="${nm.releaseDate}" pattern="yyyy.MM.dd"/> 개봉
                    </span>

                    <a href="../reservation/reservation.jsp" class="link-reservation">예매</a>
                </div>
            </div>
        </c:forEach> 
    </div>
    
</div>

</main>
<footer>
<jsp:include page="../common/jsp/footer.jsp" />
</footer>
</body>
</html>