<%@page import="kr.co.yeonflix.util.MovieListUtil"%>
<%@page import="kr.co.yeonflix.util.PaginationDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="rDTO" class="kr.co.yeonflix.util.RangeDTO" scope="page"/>
<jsp:setProperty name="rDTO" property="*"/>
<jsp:include page="/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>관리자 대시보드</title>
<link rel="stylesheet" href="http://localhost/movie_prj/common/css/admin.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<style type="text/css">
	/* 기존 배경과 레이아웃 유지 */
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
    flex: 1; 
    padding-left: 20px; 
}

.content h2 { 
    margin-bottom: 20px; 
}

/* 검색 영역 스타일링 - 개선된 버전 */
#searchDiv {
    text-align: center;
    margin-bottom: 30px;
    padding: 30px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 20px;
    box-shadow: 0 15px 35px rgba(102, 126, 234, 0.3);
}



#searchFrm {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 20px;
    flex-wrap: wrap;
}

.search-label {
    color: white;
    font-size: 18px;
    font-weight: 700;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
    margin-right: 10px;
    letter-spacing: 1px;
}

#keyword {
    padding: 15px 25px;
    border: 3px solid rgba(255,255,255,0.3);
    border-radius: 30px;
    font-size: 16px;
    width: 350px;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    background: rgba(255,255,255,0.95);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
    backdrop-filter: blur(10px);
}

#keyword:focus {
    outline: none;
    border-color: rgba(255,255,255,0.8);
    box-shadow: 0 12px 35px rgba(255, 255, 255, 0.3);
    transform: translateY(-3px) scale(1.02);
    background: white;
}

#btnSearch {
    padding: 15px 35px;
    background: linear-gradient(135deg, #ff6b6b 0%, #ff8e8e 100%);
    color: white;
    border: 3px solid rgba(255,255,255,0.3);
    border-radius: 30px;
    font-size: 16px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4);
    text-transform: uppercase;
    letter-spacing: 1px;
}

#btnSearch:hover {
    transform: translateY(-4px) scale(1.05);
    box-shadow: 0 15px 40px rgba(255, 107, 107, 0.6);
    border-color: rgba(255,255,255,0.8);
}

#btnSearch:active {
    transform: translateY(-2px) scale(1.02);
    transition: all 0.1s;
}

/* 테이블 스타일링 */
table.movie-list {
    width: 100%;
    border-collapse: collapse;
    background: white;
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
    margin-bottom: 30px;
}

table.movie-list th {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 20px 15px;
    text-align: center;
    font-size: 18px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 1px;
    border: none;
}

table.movie-list td {
    padding: 20px 15px;
    text-align: center;
    font-size: 16px;
    border-bottom: 1px solid #f8f9fa;
    vertical-align: middle;
    transition: all 0.3s ease;
}

table.movie-list tbody tr {
    transition: all 0.3s ease;
}

table.movie-list tbody tr:hover {
    background: linear-gradient(135deg, #f8f9ff 0%, #fff5f8 100%);
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

table.movie-list tbody tr:nth-child(even) {
    background: #fafbfc;
}

table.movie-list tbody tr:nth-child(even):hover {
    background: linear-gradient(135deg, #f8f9ff 0%, #fff5f8 100%);
}

/* 링크 스타일링 */
table.movie-list a {
    color: #667eea;
    text-decoration: none;
    font-weight: 600;
    transition: all 0.3s ease;
    padding: 8px 12px;
    border-radius: 8px;
    display: inline-block;
}

table.movie-list a:hover {
    color: #764ba2;
    background: rgba(102, 126, 234, 0.1);
    transform: translateY(-1px);
}

/* 페이지네이션 스타일링 - 대폭 개선 */
#paginationDiv {
    text-align: center;
    margin-top: 50px;
    padding: 30px;
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.pagination {
    display: inline-flex;
    gap: 12px;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    padding: 20px;
    background: white;
    border-radius: 20px;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.pagination a, 
.pagination span {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 18px 22px;
    margin: 0;
    border: 3px solid #e9ecef;
    color: #667eea;
    text-decoration: none;
    border-radius: 15px;
    font-weight: 700;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    min-width: 60px;
    height: 60px;
    background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
    font-size: 18px;
}

.pagination a:hover {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border-color: #667eea;
    transform: translateY(-5px) scale(1.1);
    box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
}

.pagination .active,
.pagination span.active {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border-color: #667eea;
    box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
    transform: translateY(-3px) scale(1.05);
}

/* 이전/다음 버튼 특별 스타일링 */
.pagination a:first-child,
.pagination a:last-child {
    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
    color: white;
    border-color: #28a745;
    font-weight: 800;
}

.pagination a:first-child:hover,
.pagination a:last-child:hover {
    background: linear-gradient(135deg, #20c997 0%, #17a2b8 100%);
    transform: translateY(-5px) scale(1.15);
    box-shadow: 0 20px 40px rgba(40, 167, 69, 0.5);
}

/* 상영 상태 표시 스타일링 */
table.movie-list td:last-child {
    font-weight: 600;
}

/* 반응형 디자인 */
@media (max-width: 768px) {
    #keyword {
        width: 100%;
        max-width: 280px;
    }
    
    .search-label {
        font-size: 16px;
        margin-bottom: 10px;
    }
    
    #searchFrm {
        flex-direction: column;
        gap: 15px;
    }
    
    table.movie-list th,
    table.movie-list td {
        padding: 12px 8px;
        font-size: 14px;
    }
    
    .pagination a, 
    .pagination span {
        padding: 12px 16px;
        min-width: 45px;
        height: 45px;
        font-size: 16px;
    }
    
    #paginationDiv {
        padding: 20px;
    }
    
    .pagination {
        gap: 8px;
        padding: 15px;
    }
}

/* 추가 스타일 */
  </style>
  
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
  <script>
$(function(){
/* 	$('#dAddBtn').click(function() {
	    var left = window.screenX + 200;
	    var top  = window.screenY + 150;
	    window.open('actor_list.jsp', 'id', 'width=512,height=313,left=' + left + ',top=' + top);
	  }); */
	
	
	function toggleTooltip() {
	      const tooltip = document.getElementById("tooltip");
	      tooltip.style.display = tooltip.style.display === "none" || tooltip.style.display === "" ? "block" : "none";
	    }
	

    $("#btnSearch").click(function(){
        var keyword = $("#keyword").val();
     
        if(keyword == ""){
           alert("검색 키워드는 필수 입력");
           return;
        }
        $("#searchFrm").submit();
    })
})    

	
  </script>
  
</head>
<body>
  <div class="content-container">
 <%
MovieService ms = new MovieService();
int totalCount = 0;
totalCount = ms.totalCount(rDTO);

int pageScale = 0;
pageScale = ms.pageScale();

int totalPage = 0;
totalPage = ms.totalPage(totalCount, pageScale);

int startNum = 1;
startNum = ms.startNum(pageScale, rDTO);

int endNum = 0;
endNum = ms.endNum(pageScale, rDTO);
 
 
List<MovieDTO> list = new ArrayList<MovieDTO>();
list = ms.searchMovieList(rDTO);

pageContext.setAttribute("totalCount", totalCount);
pageContext.setAttribute("pageScale", pageScale);
pageContext.setAttribute("totalPage", totalPage);
pageContext.setAttribute("startNum", rDTO.getStartNum());
pageContext.setAttribute("endNum", rDTO.getEndNum());
pageContext.setAttribute("fieldText", rDTO.getFieldText());
pageContext.setAttribute("movieList", list);
%>
    <!-- 컨텐츠 -->
    <div class="content">
      <h2>영화 리스트</h2>
      <div id="searchDiv">
		<form action="movie_list.jsp" method="get" id="searchFrm">
		<label class="search-label">🎬 영화 제목</label>
		<input type="text" name="keyword" id="keyword" placeholder="검색할 영화 제목을 입력하세요..."/>
		<input type="text" style="display: none"/>
		<input type="button" value="🔍 검색" id="btnSearch"/>
		</form>
	  </div>
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
    
    <div id="paginationDiv">
<%
PaginationDTO pDTO = new PaginationDTO(3, rDTO.getCurrentPage(), totalPage, "movie_list.jsp",rDTO.getField(), rDTO.getKeyword());
%>
<%= MovieListUtil.pagination(pDTO) %>
</div>
  </div>

</body>
</html>