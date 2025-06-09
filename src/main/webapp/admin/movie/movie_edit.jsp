<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
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
<jsp:include page="/common/jsp/admin_header.jsp" />
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
    
    /* 기존 .actions .btn 스타일 아래에 추가 */

/* 버튼 기본 스타일 */
.btn {
  border: 1px solid #ccc;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

/* 등록/수정 버튼 - 파란색 */
.btn-primary, 
input[value="등록"], 
input[value="수정"] {
  background-color: #007bff;
  color: white;
}

.btn-primary:hover, 
input[value="등록"]:hover, 
input[value="수정"]:hover {
  background-color: #0056b3;
}

/* 삭제 버튼 - 빨간색 */
.btn-danger, 
input[value="삭제"] {
  background-color: #dc3545;
  color: white;
}

.btn-danger:hover, 
input[value="삭제"]:hover {
  background-color: #c82333;
}

/* 취소 버튼 - 회색 */
.btn-secondary, 
input[value="취소"] {
  background-color: #6c757d;
  color: white;
}

.btn-secondary:hover, 
input[value="취소"]:hover {
  background-color: #545b62;
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
    
    .tooltip button {
  background: none;
  border: none;
  font-size: 14px;
  font-weight: bold;
  cursor: pointer;
  color: #999;
  float: right;
}

.tooltip button:hover {
  color: #333;
}
    
  </style>
 
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
  <script>
  <%
  String mode = request.getParameter("mode");
  %>
  
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
  
  ScheduleService ss = new ScheduleService();
  List<ScheduleDTO> scheduleList = ss.searchAllSchedule();
  
  // 스케줄 존재 여부 확인 (삭제 조건 검사용)
  boolean hasSchedule = false;
  for(ScheduleDTO sDTO : scheduleList){
      if(sDTO.getMovieIdx() == movieIdxInt){
          hasSchedule = true;
          System.out.println("sDTO.getMovieIdx()  : " + sDTO.getMovieIdx()  + "movieIdxInt : " + movieIdxInt);
          break;
      }
  }
  
  request.setAttribute("schedule", scheduleList);
  request.setAttribute("hasSchedule", hasSchedule);
  request.setAttribute("genre", mccs.searchOneGenreIdx(movieIdxInt));
  request.setAttribute("grade", mccs.searchOneGradeIdx(movieIdxInt));
  request.setAttribute("genreList", genreList);
  request.setAttribute("gradeList", gradeList);
  request.setAttribute("movieIdx", movieIdxInt);
  
  %>
  $(function(){
	    var mode = "<%= mode %>";
	    var hasSchedule = <%= hasSchedule ? "true" : "false" %>;

	    console.log("현재 모드:", mode);
	    console.log("스케줄 존재 여부:", hasSchedule);
	 // 제작국가 입력 실시간 검증
	    $("#country").on("input", function() {
	        // 한글, 영문, 공백만 허용하는 정규식
	        var regex = /[^ㄱ-ㅎ가-힣a-zA-Z\s]/g;
	        $(this).val($(this).val().replace(regex, ""));
	    });
	  

	 // 상영시간 입력 실시간 검증 (숫자만 허용)
	 $("#duration").on("input", function() {
	     // 숫자만 허용하는 정규식 (숫자가 아닌 모든 문자 제거)
	     var regex = /[^0-9]/g;
	     $(this).val($(this).val().replace(regex, ""));
	 });
	    
	    // 폼 제출 전 유효성 검사 함수
	    function validateForm() {
	    	 var movieName = $("#movieName").val().trim();
	    	    var genre = $("#genre").val().trim();
	    	    var grade = $("#grade").val();
	    	    var country = $("#country").val().trim();
	    	    var duration = $("#duration").val().trim();
	    	    var description = $("#description").val().trim();
	    	    var directorsValue = $("input[name='directors']").val();
	    	    var actorsValue = $("input[name='actors']").val();
	    	    var openDate = $("#openDate").val();
	    	    var closeDate = $("#closeDate").val();
	    	    
	    	    var country = $("#country").val().trim();
	    	    var countryRegex = /^[가-힣a-zA-Z\s]+$/; // 한글, 영문, 공백만 허용
	    	    // readonly 필드의 값을 hidden 필드에 넣기
	    	    $("#hiddenDirectors").val(directorsValue);
	    	    $("#hiddenActors").val(actorsValue);
	    	    
	    	    // 영화제목 검사
	    	    if (!movieName) {
	    	        alert("영화제목을 입력해주세요.");
	    	        $("#movieName").focus();
	    	        return false;
	    	    }
	    	    
	    	 // 제작국가 필드 검사 
	    	    if (!country) {
	    	        alert("제작국가를 입력해주세요.");
	    	        $("#country").focus();
	    	        return false;
	    	    }
	    	    
	    	    // 제작국가 유효성 검사 (한글, 영문만 허용)
	    	    if (!countryRegex.test(country)) {
	    	        alert("제작국가는 한글과 영문만 입력 가능합니다.");
	    	        $("#country").focus();
	    	        return false;
	    	    }
	    	    
	    	    // 장르 검사
	    	    if (!genre) {
	    	        alert("장르를 선택해주세요.");
	    	        $("#genre").focus();
	    	        return false;
	    	    }

	    	    // 등급 검사
	    	    if (!grade) {
	    	        alert("등급을 선택해주세요.");
	    	        $("#grade").focus();
	    	        return false;
	    	    }

	    	    // 상영시간 검사
	    	    if (!duration || isNaN(duration) || duration <= 0) {
	    	        alert("유효한 상영시간을 입력해주세요.");
	    	        $("#duration").focus();
	    	        return false;
	    	    }
	    	    

	    	    // 감독 입력 검사
	    	    if (!directorsValue) {
	    	        alert("감독을 입력해주세요.");
	    	        return false;
	    	    }
	    	    // 배우 입력 검사
	    	    if (!actorsValue) {
	    	        alert("배우를 입력해주세요.");
	    	        return false;
	    	    }

	    	 // 개봉일, 상영종료일 검사
	    	   if (!openDate || openDate.trim() === "") {
				    alert("개봉일을 입력해주세요.");
				    $("#openDate").focus();
				    return false;
				}
				
				if (!closeDate || closeDate.trim() === "") {
				    alert("상영종료일을 입력해주세요.");
				    $("#closeDate").focus();
				    return false;
				}
	    	    // 날짜 비교 
	    	       if (openDate && closeDate) {
        				var openDateObj = new Date(openDate);
        				var closeDateObj = new Date(closeDate);
        
			        if (closeDateObj < openDateObj) {
			            alert("상영종료일은 개봉일보다 이전일 수 없습니다.");
			            $("#closeDate").focus();
			            return false;
			        }
			    }
	    	    // 영화 정보 입력 검사
	    	    if (!description) {
	    	        alert("영화정보를 입력해주세요.");
	    	        $("#description").focus();
	    	        return false;
	    	    }
	    	    
	    	    return true;
	    }
	    
	 // 날짜 입력 시 실시간으로 검증
	    $("#openDate, #closeDate").change(function() {
	        var openDate = $("#openDate").val();
	        var closeDate = $("#closeDate").val();
	        
	        if (openDate && closeDate) {
	            var openDateObj = new Date(openDate);
	            var closeDateObj = new Date(closeDate);
	            
	            if (closeDateObj < openDateObj) {
	                alert("상영종료일은 개봉일보다 이전일 수 없습니다.");
	                $("#closeDate").val(""); // 잘못된 값 초기화
	            }
	        }
	    });
	    
	    // 스케줄 존재 여부 확인 함수
	    function checkScheduleExists() {
	        return hasSchedule;
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
	        if(file && !file.type.startsWith('image/')){
	            alert("이미지 파일만 업로드 가능합니다.");
	            $("#posterImg").val('');
	            return;
	        }
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
	            // 삭제 전 스케줄 존재 여부 확인
	            if (hasSchedule === true) {
	                alert("상영 스케줄에 있는 영화는 삭제할 수 없습니다.");
	                return false;
	            }
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
       <button type="button" onclick="toggleTooltip()" style="float: right; font-weight: bold; background: none; border: none; cursor: pointer; font-size: 14px; color: #999;">✕</button>
        모든 항목을 다 기입해주세요.<br>
        같은 시기에 영화 제목이 같을 시 구분할 수 있는 문자를 괄호를 사용해 기입해주세요.<br>
        ex) 극한직업(2019)
        
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
                          ${g.codeIdx == genre ? 'selected="selected"' : ''}>
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
                          ${g.codeIdx == grade ? 'selected="selected"' : ''}>
                          ${g.movieCodeType}
                      </option>
                  </c:forEach>
              </select>
              <input type="hidden" name="gradeIdx" id="gradeIdx"/>
            </div>

            <div class="form-row">
              <label for="runningTime">상영시간</label>
              <input type="text" id="duration" name="duration" 
                     value="<%= "update".equals(mode) && mDTO != null ? (mDTO.getRunningTime() != 0 ? String.valueOf(mDTO.getRunningTime()) : "") : "" %>" /> 분
            </div>
				 
            <div class="form-row">
              <label>감독</label>
              <input type="text" class="person-input" name="directors" 
                     value="<%= "update".equals(mode) && mDTO != null ? (mDTO.getDirectors() != null ? mDTO.getDirectors() : "") : ""%>" 
                     readonly="readonly" />
              <button type="button" class="btn" id="dAddBtn">감독리스트</button>
              <input type="hidden" name="hiddenDirectors" id="hiddenDirectors" />
              <button type="button" class="btn" id="dRemoveBtn">삭제</button>
              
            </div>
	
            <div class="form-row">
              <label>배우</label>
              <input type="text" class="person-input" name="actors" 
                     value="<%= "update".equals(mode) && mDTO != null ? (mDTO.getActors() != null ? mDTO.getActors() : "") : ""%>" 
                     readonly="readonly" />
                     <input type="hidden" name="hiddenActors" id="hiddenActors" />
                     
			                       
              <button type="button" class="btn" id="aAddBtn">배우리스트</button>
              <button type="button" class="btn" id="aRemoveBtn">삭제</button>
            </div>

            <div class="form-row">
              <label for="openDate">개봉일</label>
              <input type="date" id="openDate" name="openDate" required  
                     value="<%= "update".equals(mode) && mDTO != null && mDTO.getReleaseDate() != null ? mDTO.getReleaseDate().toString() : ""%>" />
            </div>

            <div class="form-row">
              <label for="closeDate">상영종료일</label>
              <input type="date" id="closeDate" name="closeDate" required 
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