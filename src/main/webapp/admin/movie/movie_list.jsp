<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>관리자 대시보드</title>
<link rel="stylesheet" href="http://localhost/movie_prj/common/css/admin.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<style type="text/css">
	.content-container {
		position: fixed;
		top: 80px;
		left: 300px;
		right: 0;
		bottom: 0;
		padding: 20px;
		background-color: #f0f0f0;
	}
    .content { flex: 1; padding-left: 20px; }
    .content h2 { margin-bottom: 20px; }
    table.movie-list { width: 100%; border-collapse: collapse; }
    table.movie-list th, table.movie-list td {
      border: 1px solid #ddd; padding: 8px; text-align: left;
    }
    table.movie-list th { background: #f5f5f5; }
    .pagination { margin-top: 20px; text-align: center; }
    .pagination a, .pagination span {
      display: inline-block; padding: 6px 12px; margin: 0 2px; border: 1px solid #ccc; color: #333;
    }
    .pagination .active { background: #555; color: #fff; }
  </style>
  
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
  <script>
    

	$('#dAddBtn').click(function() {
	    var left = window.screenX + 200;
	    var top  = window.screenY + 150;
	    window.open('actor_list.jsp', 'id', 'width=512,height=313,left=' + left + ',top=' + top);
	  });
	
	
	function toggleTooltip() {
	      const tooltip = document.getElementById("tooltip");
	      tooltip.style.display = tooltip.style.display === "none" || tooltip.style.display === "" ? "block" : "none";
	    }
  </script>
  
</head>
<body>
  <div class="content-container">
 <%
MovieService ms = new MovieService();
List<MovieDTO> list = new ArrayList<MovieDTO>();
list = ms.searchMovieList();
request.setAttribute("movieList", list);

%>
    <!-- 컨텐츠 -->
    <div class="content">
      <h2>영화 리스트</h2>
      <table class="movie-list">
        <thead>
          <tr>
            <th>영화제목</th>
            <th>개봉일</th>
            <th>상영종료일</th>
            <th>상영 상태</th>
          </tr>
        </thead>
        <tbody>
          <!-- 실제 데이터 바인딩 -->
          <c:forEach var="m" items="${movieList}">
            <tr>
              <td><a href="movie_edit.jsp?movieIdx=${m.movieIdx}&mode=update">${m.movieName}</a></td>
              <td>${m.releaseDate}</td>
              <td>${m.endDate}</td>
              <td>${m.screeningStatusStr}</td>
              
            </tr>
          </c:forEach>
        </tbody>
      </table>

      <div class="pagination">
        <c:forEach var="i" begin="1" end="${totalPages}">
          <c:choose>
            <c:when test="${i == currentPage}">
              <span class="active">${i}</span>
            </c:when>
            <c:otherwise>
              <a href="movie_list.jsp?page=${i}">${i}</a>
            </c:otherwise>
          </c:choose>
        </c:forEach>
      </div>
    </div>
  </div>

</body>
</html>
