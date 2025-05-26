<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CGV 무비차트</title>

<jsp:include page="../common/jsp/external_file.jsp" />

<link rel="stylesheet" type="text/css" href="/movie_prj/common/css/main_chart.css">
<style type="text/css">

</style>
</head>
<body>
<header>
    <jsp:include page="../common/jsp/header.jsp" />
</header>
<main>
<div id="container">
    <!-- forEach로 추가예정 -->
    <h2>무비차트</h2>
    <div class="movie-chart">
        <div class="movie-item">
            <strong class="rank">No.1</strong>
            <div class="box-image">
                <a href="/movie_prj/movie_chart/sub_chart.jsp#main-info">
                    <img src="https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89629/89629_320.jpg" alt="미션 임파서블: 파이널 레코닝 포스터">
                </a>
            </div>
            <div class="box-contents">
                <strong class="title">미션 임파서블: 파이널 레코닝</strong>
                <div class="score">
                    <strong class="percent">예매율 <span>67.8%</span></strong>
                </div>
                <span class="txt-info">
                    2025.05.17 개봉
                </span>
                <a href="/ticket/?MOVIE_CD=20041356&MOVIE_CD_GROUP=20041192" class="link-reservation">예매</a>
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
