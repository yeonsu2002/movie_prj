<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>관리자 대시보드</title>
  <link rel="stylesheet" href="http://localhost/movie_prj/common/css/admin.css" />
  <style type="text/css">
    .content-container {
      position: fixed;
      top: 80px;
      left: 300px;
      right: 0;
      bottom: 0;
      padding: 20px;
      background-color: #f0f0f0;
      overflow-y: auto;
    }

    .content {
      display: flex;
      flex-direction: column; /* 자식들이 세로로 배치되도록 */
      align-items: center; /* 가운데 정렬 */
    }
    .content h2 {
      margin-bottom: 20px;
      font-size: 24px;
      display: flex;
      align-items: center;
    }

    .tooltip {
      position: absolute;
      padding: 8px 12px;
      background: #fff;
      border: 1px solid #ccc;
      font-size: 12px;
      line-height: 1.4;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
      max-width: 200px;
      z-index: 10;
    }

    .form-flex-container {
      display: flex;
      gap: 20px;
      align-items: flex-start;
      flex-wrap: wrap;
      width: 1200px;
    }

    .form-left,
    .form-right {
      flex: 1;
      min-width: 500px;
    }

    .form-right {
      background: #fff;
      padding: 15px;
      border: 1px solid #ccc;
      border-radius: 8px;
      position: relative;
    }

    .poster-image {
      width: 100%;
      max-width: 60%;
      height: 400px;
      object-fit: cover;
      border: 1px solid #ccc;
      border-radius: 8px;
      margin-bottom: 12px;
    }

    .form-row {
      display: flex;
      align-items: center;
      margin-bottom: 12px;
      max-width: 700px;
    }

    .form-row label {
      width: 120px;
      font-size: 14px;
      color: #333;
    }

    .form-row input[type="text"],
    .form-row select,
    .form-row input[type="date"],
    .form-row textarea {
      flex: 1;
      padding: 6px 8px;
      border: 1px solid #ccc;
      border-radius: 4px;
      font-size: 14px;
    }

    textarea {
      height: 140px;
      resize: vertical;
    }

    .form-row .person-input {
      flex: 1;
    }

    .form-row .btn {
      margin-left: 8px;
      padding: 4px 10px;
      font-size: 13px;
    }

    .actions {
      display: flex;
      justify-content: center;
      gap: 20px;
      margin-top: 30px;
      width: 100%; /* 전체 너비 기준 중앙 정렬 */
    }

    .actions .btn {
      padding: 12px 32px;
      font-size: 14px;
    }

    .tooltip-button {
      margin-left: 10px;
      padding: 4px 8px;
      font-size: 12px;
      border: 1px solid #ccc;
      background-color: #fff;
      border-radius: 4px;
      cursor: pointer;
    }

    #tooltip {
      display: none;
    }
  </style>
</head>
<body>
  <div class="content-container">
  <%
  String movieIdxStr = request.getParameter("movieIdx");
  int movieIdxInt = 0;
  try {
      movieIdxInt = Integer.parseInt(movieIdxStr);
  } catch (NumberFormatException e) {
	  e.printStackTrace();
  }

	
  MovieService ms = new MovieService();
  MovieDTO mDTO = new MovieDTO();
  
  mDTO = ms.searchOneMovie(movieIdxInt);
  

  %>
    <div class="content">
      <h2>
        영화 수정/삭제
        <button type="button" class="tooltip-button" onclick="toggleTooltip()">?</button>
      </h2>

      <div id="tooltip" class="tooltip">
        포스터, 영화제목, 영화설명, 트레일러URL, 감독, 주연배우(3명), 장르,<br />
        상영등급, 제작국가, 상영시간
      </div>

      <form action="MovieController" method="post" enctype="multipart/form-data">
        <input type="hidden" name="movieIdx" value="<%=mDTO.getMovieIdx() %>" />
        <div class="form-flex-container">
          <!-- 왼쪽 영역 -->
          <div class="form-left">
            <div class="form-row">
              <label for="title">영화제목</label>
              <input type="text" id="movieName" name="movieName" value="<%=mDTO.getMovieName() %>" />
            </div>

            <div class="form-row">
              <label for="country">제작국가</label>
              <input type="text" id="country" name="country" value="<%=mDTO.getCountry() %>" />
            </div>

           <!--   <div class="form-row">
              <label for="genre">장르</label>
              <select id="genre" name="genre">
                
                  <option value="${g.id}" ${g.id == movie.genreId ? 'selected' : ''}>${g.name}</option>
              </select>
            </div>-->

           <!--  <div class="form-row">
              <label for="rating">상영등급</label>
              <select id="rating" name="rating">
                <c:forEach var="r" items="${ratingList}">
                  <option value="${r}" ${r == movie.rating ? 'selected' : ''}>${r}</option>
                </c:forEach>
              </select>
            </div> -->

            <div class="form-row">
              <label for="duration">상영시간</label>
              <input type="text" id="duration" name="duration" value="<%=mDTO.getRunningTime() %>" /> 분
            </div>
				 
            <!--<div class="form-row">
              <label>감독</label>
              <input type="text" class="person-input" name="directors" value="${movie.directors}" />
              <button type="button" class="btn" onclick="addPerson('directors')">추가</button>
              <button type="button" class="btn" onclick="removePerson('directors')">삭제</button>
            </div> -->
	
            <!--  <div class="form-row">
              <label>배우</label>
              <input type="text" class="person-input" name="actors" value="${movie.actors}" />
              <button type="button" class="btn" onclick="addPerson('actors')">추가</button>
              <button type="button" class="btn" onclick="removePerson('actors')">삭제</button>
            </div>-->

            <div class="form-row">
              <label for="openDate">개봉일</label>
              <input type="date" id="openDate" name="openDate" value="<%=mDTO.getReleaseDate() %>" />
            </div>

            <div class="form-row">
              <label for="closeDate">상영종료일</label>
              <input type="date" id="closeDate" name="closeDate" value="<%=mDTO.getEndDate() %>" />
            </div>

            <div class="form-row">
              <label for="description">영화정보</label>
              <textarea id="description" name="description"><%=mDTO.getMovieDescription() %></textarea>
            </div>
          </div>

          <!-- 오른쪽 영역 -->
          <div class="form-right">
            <div class="form-row">
              <label>Media</label>
            </div>
            <div>
              <%-- <img src="<%=mDTO.getPosterPath() %>" alt="Poster" class="poster-image" /> --%>
              <div style="display: flex; gap: 10px;">
                <button type="button" class="btn">Remove</button>
                <input type="file" name="posterFile" class="btn" />
              </div>
            </div>

            <div class="form-row" style="margin-top: 20px;">
              <label for="trailerUrl">트레일러URL</label>
              <input type="text" id="trailerUrl" name="trailerUrl" value="<%= mDTO.getTrailerUrl() %>" />
            </div>
          </div>
        </div>

        <div class="actions">
          <button type="submit" name="action" value="update" class="btn">수정</button>
          <button type="submit" name="action" value="delete" class="btn">삭제</button>
        </div>
      </form>
    </div>
  </div>

  <script>
    function toggleTooltip() {
      const tooltip = document.getElementById("tooltip");
      tooltip.style.display = tooltip.style.display === "none" || tooltip.style.display === "" ? "block" : "none";
    }

    function addPerson(field) {
      alert(field + " 항목 추가 로직을 구현하세요.");
    }

    function removePerson(field) {
      alert(field + " 항목 삭제 로직을 구현하세요.");
    }
  </script>
</body>
</html>
