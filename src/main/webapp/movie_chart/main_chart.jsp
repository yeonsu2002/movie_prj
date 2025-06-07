<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"
info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CGV 무비차트</title>

<jsp:include page="../common/jsp/external_file.jsp" />

<style type="text/css">

#container {
    min-height: 650px;
    background-image: url('/movie_prj/common/img/movie_chart_background.png');
    background-size: cover;
    background-repeat: no-repeat;
    background-position: center center;
    padding: 20px 0;
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
    grid-template-columns: repeat(4, 1fr); /* 가로 4개씩 배치 */
    gap: 30px; /* 카드 간 간격 */
    max-width: 1200px; /* 최대 너비 설정 */
    margin: 0 auto; /* 가운데 정렬 */
    padding: 40px 20px; /* 내부 여백 */
}

.movie-item {
    width: 100%; /* 그리드에 맞게 조정 */
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    background: #1a1a1a; /* 어두운 배경 */
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.movie-item:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.4);
}

/* 나머지 스타일은 원본과 동일하게 유지 */
.box-image {
    position: relative;
    width: 100%;
    height: 320px; /* 높이 증가 */
}

.box-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block; /* 이미지 하단 여백 제거 */
}

.rank {
    position: absolute;
    top: 10px;
    left: 10px;
    width: 50px;
    height: 25px;
    background: #FB4357;
    color: white;
    font-weight: bold;
    text-align: center;
    border-radius: 4px;
    box-sizing: border-box;
    line-height: 25px; /* 텍스트 수직 중앙 정렬 */
    font-size: 12px;
    z-index: 2;
}

.box-contents {
    padding: 20px 15px 15px;
    background: #1a1a1a;
}

.box-contents .title {
    color: white;
    font-size: 16px;
    font-weight: bold;
    margin-bottom: 8px;
    display: block;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.score {
    margin-bottom: 8px;
}

.score .percent {
    font-size: 13px;
    color: #FB4357;
    font-weight: bold;
}

.txt-info {
    font-size: 12px;
    color: #999; /* 회색으로 변경 */
    margin-bottom: 15px;
    display: block;
}

.link-reservation {
    display: block;
    background: #FB4357;
    color: white;
    padding: 8px 15px;
    border-radius: 4px;
    text-decoration: none;
    font-size: 13px;
    text-align: center;
    font-weight: bold;
    transition: background 0.3s ease;
}

.link-reservation:hover {
    background: #e03a4e;
}

/* 이미지 로딩 실패시 대체 스타일 */
.box-image img[alt]:after {
    content: attr(alt);
    display: block;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: #f0f0f0;
    color: #666;
    text-align: center;
    padding: 10px;
}
</style>
</head>
<body>
<%
MovieService ms = new MovieService();
List<MovieDTO> movieList = ms.searchMovieChart();
request.setAttribute("movieList", movieList);
%>
<header>
<jsp:include page="../common/jsp/header.jsp" />
</header>
<main>
<div id="container">
    <!-- movie-chart div를 forEach 밖으로 이동 -->
    <div class="movie-chart">
        <c:forEach var="m" items="${movieList}">
            <div class="movie-item">
                <div class="box-image">
                    <a href="sub_chart.jsp?movieIdx=${m.movieIdx}">
                        <!-- 이미지 경로 수정 - 여러 경로 시도 -->
                        <img src="/movie_prj/common/img/${m.posterPath}"/> 
                    </a>
                    <strong class="rank">NO.${m.movieIdx}</strong>
                </div>
                <div class="box-contents">
                    <strong class="title">${m.movieName}</strong>

                    <div class="score">
                        <strong class="percent">예매율: 67.8%</strong> <!-- 예매율은 현재 DTO에 없음 -->
                    </div>

                    <span class="txt-info">
                        <fmt:formatDate value="${m.releaseDate}" pattern="yyyy.MM.dd"/> 개봉
                    </span>

                    <a href="/ticket/?MOVIE_CD=${m.movieIdx}" class="link-reservation">예매하기</a>
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