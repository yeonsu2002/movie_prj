<%@page import="kr.co.yeonflix.movie.people.PeopleDTO"%>
<%@page import="kr.co.yeonflix.movie.people.PeopleService"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.movie.code.MovieCommonCodeDTO"%>
<%@page import="kr.co.yeonflix.movie.code.MovieCommonCodeService"%>
<%@page import="kr.co.yeonflix.movie.common.CommonDTO"%>
<%@page import="kr.co.yeonflix.movie.common.CommonService"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />
<%@ include file="/common/jsp/admin_header.jsp" %>
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
      flex-direction: column;
      align-items: center;
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
      width: 100%;
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
     
    .warning{
      color: #DB1C17;
    }
  </style>
 
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
  <script>
  <%
  String mode = request.getParameter("mode");
  %>
  
  $(function(){
    var mode = "<%= mode %>";
    console.log("현재 모드:", mode);
    
    // 폼 제출 전 유효성 검사 함수
    function validateForm() {
        var movieName = $("#movieName").val().trim();
        var genre = $("#genre").val();
        var grade = $("#grade").val();
        
        if (!movieName) {
            alert("영화제목을 입력해주세요.");
            $("#movieName").focus();
            return false;
        }
        
        if (!genre) {
            alert("장르를 선택해주세요.");
            $("#genre").focus();
            return false;
        }
        
        if (!grade) {
            alert("등급을 선택해주세요.");
            $("#grade").focus();
            return false;
        }
        
        return true;
    }
    
    $('#dAddBtn').click(function() {
        var left = window.screenX + 830;
        var top  = window.screenY + 150;
        window.open('people_list.jsp?people=director', 'id', 'width=250,height=600,left=' + left + ',top=' + top);
    });
    
    $('#aAddBtn').click(function() {
        var left = window.screenX + 830;
        var top  = window.screenY + 150;
        window.open('people_list.jsp?people=actor', 'id', 'width=250,height=600,left=' + left + ',top=' + top);
    });
    
    $("#btnImg").click(function(){
        $("#posterImg").click();
    });
    
    $("#posterImg").change(function(evt){
        $("#imgName").val($("#posterImg").val());
        var file = evt.target.files[0];
        var reader = new FileReader();
        reader.onload = function(evt){
            $("#img").prop("src", evt.target.result);
        }
        reader.readAsDataURL(file);
    });
    
    $('#dRemoveBtn').click(function() {
        var input = $('input[name="directors"]');
        var values = input.val().split(',').map(item => item.trim()).filter(item => item);
        values.pop();
        input.val(values.join(', '));
    });

    $('#aRemoveBtn').click(function() {
        var input = $('input[name="actors"]');
        var values = input.val().split(',').map(item => item.trim()).filter(item => item);
        values.pop();
        input.val(values.join(', '));
    });
    
    // 폼 제출 버튼 클릭 이벤트
    $("#positive").click(function(){
        if (!validateForm()) {
            return false;
        }
        
        // 액션 설정
        if (mode === "update") {
            $("#action").val("update");
        } else {
            $("#action").val("insert");
            // insert 모드일 때는 movieIdx를 0으로 설정하거나 제거
            $("#movieIdxField").val("0");
        }
        
        console.log("제출할 액션:", $("#action").val());
        console.log("movieIdx:", $("#movieIdxField").val());
        
        $("#frm").submit();
    });
    
    // 장르와 등급 hidden 필드 초기화
    $("#genreIdx").val($("#genre").val());
    $("#gradeIdx").val($("#grade").val());

    // 장르/등급 변경 이벤트
    $("#grade").change(function() {
        $("#gradeIdx").val($(this).val());
    });

    $("#genre").change(function() {
        $("#genreIdx").val($(this).val());
    });
    
    // 취소/삭제 버튼 클릭 이벤트
    $("#negation").click(function(){
        if (mode === "update") {
            if (confirm("정말 삭제하시겠습니까?")) {
                $("#action").val("delete");
                $("#frm").submit();
            }
        } else {
            history.back();
        }
    });
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
  String movieIdxStr = request.getParameter("movieIdx");
  int movieIdxInt = 0;
  if (movieIdxStr != null && !movieIdxStr.trim().isEmpty()) {
      try {
          movieIdxInt = Integer.parseInt(movieIdxStr);
      } catch (NumberFormatException e) {
          e.printStackTrace();
      }
  }
  
  MovieDTO mDTO = new MovieDTO();
  List<CommonDTO> gradeList = new ArrayList<CommonDTO>();	
  List<CommonDTO> genreList = new ArrayList<CommonDTO>();	
  
  MovieService ms = new MovieService();
  CommonService gs = new CommonService();
  
  genreList = gs.genreList();  
  gradeList = gs.gradeList();
  
  // update 모드일 때만 영화 정보 조회
  if ("update".equals(mode) && movieIdxInt > 0) {
      mDTO = ms.searchOneMovie(movieIdxInt);
  }
  
  MovieCommonCodeService mccs = new MovieCommonCodeService();
  List<MovieCommonCodeDTO> mccList = new ArrayList<MovieCommonCodeDTO>();
  
  int movieGenreCode = 0;
  int movieGradeCode = 0;
  
  if ("update".equals(mode) && movieIdxInt > 0) {
      mccList = mccs.searchCommon(movieIdxInt);
      
      for(MovieCommonCodeDTO code : mccList) {
          if("장르".equals(code.getCodeType())) {
              movieGenreCode = code.getCodeIdx();
          } else if("등급".equals(code.getCodeType())) {
              movieGradeCode = code.getCodeIdx();
          }
      }
  }
  
  request.setAttribute("movieGenreCode", movieGenreCode);
  request.setAttribute("movieGradeCode", movieGradeCode);
  request.setAttribute("genreList", genreList);
  request.setAttribute("gradeList", gradeList);
  request.setAttribute("movieIdx", movieIdxInt);
  

  %>

    <div class="content">
      <c:choose>
        <c:when test="${param.mode == 'insert'}">
          <h2>영화 등록
          <button type="button" class="tooltip-button" onclick="toggleTooltip()">?</button>
          </h2>
        </c:when>
        <c:when test="${param.mode == 'update'}">
            <h2>
              영화 수정/삭제
              <button type="button" class="tooltip-button" onclick="toggleTooltip()">?</button>
            </h2>
        </c:when>
      </c:choose>
      
      <div id="tooltip" class="tooltip">
        포스터, 영화제목, 영화설명, 트레일러URL, 감독, 주연배우(3명), 장르,<br />
        상영등급, 제작국가, 상영시간
        <ul>
          <c:forEach var="g" items="${genreList}">
            <li>${g.codeIdx} - ${g.movieCodeType}</li>
          </c:forEach>
        </ul>
      </div>

      <form action="movie_process.jsp" method="post" id="frm" enctype="multipart/form-data">
        <input type="hidden" name="action" id="action" value=""/>
        
        <!-- movieIdx 처리 개선 -->
        <c:choose>
          <c:when test="${param.mode == 'update'}">
            <input type="hidden" name="movieIdx" id="movieIdxField" value="<%= movieIdxInt %>" />
          </c:when>
          <c:otherwise>
            <input type="hidden" name="movieIdx" id="movieIdxField" value="0" />
          </c:otherwise>
        </c:choose>
       
        <div class="form-flex-container">
          <!-- 왼쪽 영역 -->
          <div class="form-left">
            <div class="form-row">
              <label for="movieName">영화제목 *</label>
              <input type="text" id="movieName" name="movieName" 
                     value="<%= "update".equals(mode) && mDTO != null ? (mDTO.getMovieName() != null ? mDTO.getMovieName() : "") : "" %>" />
            </div>

            <div class="form-row">
              <label for="country">제작국가</label>
              <input type="text" id="country" name="country" 
                     value="<%= "update".equals(mode) && mDTO != null ? (mDTO.getCountry() != null ? mDTO.getCountry() : "") : "" %>" />
            </div>

            <div class="form-row">
              <label for="genre">장르 *</label>
              <select id="genre" name="genre" class="warning">
                  <option value="">-- 장르를 선택하세요 --</option>
                  <c:forEach var="g" items="${genreList}">
                      <option value="${g.codeIdx}"
                          ${g.codeIdx == movieGenreCode ? 'selected="selected"' : ''}>
                          ${g.movieCodeType}
                      </option>
                  </c:forEach>
              </select>
              <input type="hidden" name="genreIdx" id="genreIdx"/>
            </div>

            <div class="form-row">
              <label for="grade">등급 *</label>
              <select id="grade" name="grade" class="warning">
                  <option value="">-- 등급을 선택하세요 --</option>
                  <c:forEach var="g" items="${gradeList}">
                      <option value="${g.codeIdx}" 
                          ${g.codeIdx == movieGradeCode ? 'selected="selected"' : ''}>
                          ${g.movieCodeType}
                      </option>
                  </c:forEach>
              </select>
              <input type="hidden" name="gradeIdx" id="gradeIdx"/>
            </div>

            <div class="form-row">
              <label for="duration">상영시간</label>
              <input type="text" id="duration" name="duration" 
                     value="<%= "update".equals(mode) && mDTO != null ? (mDTO.getRunningTime() != 0 ? String.valueOf(mDTO.getRunningTime()) : "") : "" %>" /> 분
            </div>
				 
            <div class="form-row">
              <label>감독</label>
              <input type="text" class="person-input" name="directors" 
                     value="<%= "update".equals(mode) && mDTO != null ? (mDTO.getDirectors() != null ? mDTO.getDirectors() : "") : ""%>" 
                     readonly="readonly" />
              <button type="button" class="btn" id="dAddBtn">감독리스트</button>
              <button type="button" class="btn" id="dRemoveBtn">삭제</button>
            </div>
	
            <div class="form-row">
              <label>배우</label>
              <input type="text" class="person-input" name="actors" 
                     value="<%= "update".equals(mode) && mDTO != null ? (mDTO.getActors() != null ? mDTO.getActors() : "") : ""%>" 
                     readonly="readonly" />
              <button type="button" class="btn" id="aAddBtn">배우리스트</button>
              <button type="button" class="btn" id="aRemoveBtn">삭제</button>
            </div>

            <div class="form-row">
              <label for="openDate">개봉일</label>
              <input type="date" id="openDate" name="openDate" 
                     value="<%= "update".equals(mode) && mDTO != null && mDTO.getReleaseDate() != null ? mDTO.getReleaseDate().toString() : ""%>" />
            </div>

            <div class="form-row">
              <label for="closeDate">상영종료일</label>
              <input type="date" id="closeDate" name="closeDate" 
                     value="<%= "update".equals(mode) && mDTO != null && mDTO.getEndDate() != null ? mDTO.getEndDate().toString() : ""%>" />
            </div>

            <div class="form-row">
              <label for="description">영화정보</label>
              <textarea id="description" name="description"><%= "update".equals(mode) && mDTO != null ? (mDTO.getMovieDescription() != null ? mDTO.getMovieDescription() : "") : ""%></textarea>
            </div>
          </div>

          <!-- 오른쪽 영역 -->
          <div class="form-right">
            <div class="form-row">
              <label>Media</label>
            </div>
            <div>
              <img src="<%= "update".equals(mode) && mDTO != null && mDTO.getPosterPath() != null ? 
                            ("../../common/img/" + mDTO.getPosterPath()) : 
                            "http://localhost/movie_prj/common/img/default_poster.png" %>" 
                   class="poster-image" id="img" />
              <input type="hidden" name="posterPath" 
                     value="<%= "update".equals(mode) && mDTO != null && mDTO.getPosterPath() != null ? 
                               ("http://localhost/movie_prj/common/img/" + mDTO.getPosterPath()) : 
                               "default_poster.png" %>" />
              
              <div style="display: flex; gap: 10px;">
                <input type="button" value="이미지선택" id="btnImg" class="btn btn-info btn-sm"/>
                <input type="hidden" name="imgName" id="imgName"/>
                <input type="file" style="display: none" name="posterImg" id="posterImg"/>
              </div>
            </div>

            <div class="form-row" style="margin-top: 20px;">
              <label for="trailerUrl">트레일러URL</label>
              <input type="text" id="trailerUrl" name="trailerUrl" 
                     value="<%= "update".equals(mode) && mDTO != null ? (mDTO.getTrailerUrl() != null ? mDTO.getTrailerUrl() : "") : "" %>" />
            </div>
          </div>
        </div>

        <div class="actions">
          <input type="button" name="positive" id="positive" 
                 value="<%= "update".equals(mode) ? "수정" : "등록" %>" class="btn"/>
          <input type="button" name="negation" id="negation" 
                 value="<%= "update".equals(mode) ? "삭제" : "취소" %>" class="btn">
        </div>
      </form>
    </div>
  </div>
</body>
</html>