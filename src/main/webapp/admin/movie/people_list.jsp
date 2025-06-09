<%@page import="kr.co.yeonflix.util.PeopleSearchDTO"%>
<%@page import="kr.co.yeonflix.util.PeopleListUtil"%>
<%@page import="kr.co.yeonflix.util.MovieListUtil"%>
<%@page import="kr.co.yeonflix.util.PaginationDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@page import="kr.co.yeonflix.movie.people.PeopleDTO"%>
<%@page import="kr.co.yeonflix.movie.people.PeopleService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rDTO" class="kr.co.yeonflix.util.RangeDTO" scope="page"/>
<jsp:setProperty name="rDTO" property="*"/>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <c:if test="${param.people == 'actor'}">
      <title>배우목록</title>
    </c:if>
    <c:if test="${param.people == 'director'}">
      <title>감독목록</title>
    </c:if>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 20px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
    }
    th, td {
      padding: 8px 12px;
      border: 1px solid #ddd;
      text-align: left;
    }
    tr:hover {
      background-color: #f5f5f5;
      cursor: pointer;
    }
    #searchDiv {
      margin-bottom: 20px;
    }
    .search-label {
      font-weight: bold;
      margin-right: 10px;
    }
    #keyword {
      padding: 5px;
      margin-right: 10px;
      width: 200px;
    }
    #btnSearch {
      padding: 5px 10px;
      cursor: pointer;
    }
  </style>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
$(function(){
    // 실시간 검색 (페이지 새로고침 없이)
    $("#keyword").on("keyup", function(){
        var keyword = $(this).val().toLowerCase();
        
        // 모든 테이블 행을 가져와서 필터링
        $("table tbody tr").each(function(){
            var personName = $(this).find("td").text().toLowerCase();
            
            if(keyword === "" || personName.includes(keyword)) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
        
        // 검색 결과 개수 업데이트
        updateResultCount(keyword);
    });
    
    
    
    // 검색 결과 개수 업데이트 함수
    function updateResultCount(keyword) {
        var visibleRows = $("table tbody tr:visible").length;
        var emptyRow = $("table tbody tr td[colspan]").length; // 빈 결과 행 체크
        
        if(emptyRow > 0) {
            visibleRows = 0;
        }
        
        if(keyword !== "") {
            $("#searchResult").html("'" + keyword + "' 검색 결과 (" + visibleRows + "명)");
        } else {
            $("#searchResult").html("");
        }
    }
});  
  
function selectPerson(name) {
  const people = "<%= request.getParameter("people") %>"; 
  var inputField;

  if (people === "actor") {
    inputField = window.opener.document.querySelector('input[name="actors"]');
  } else if (people === "director") {
    inputField = window.opener.document.querySelector('input[name="directors"]');
  }

  if (inputField) {
    // 여러 명 입력 가능하도록 ,로 구분
    if (inputField.value.trim() !== "") {
      inputField.value += ", " + name;
    } else {
      inputField.value = name;
    }
    window.close(); // 창 닫기
  }
}
</script>

</head>
<body>
<%!
  // 초성 추출
  public char getChosung(char c) {
    final char[] CHOSUNG = {
      'ㄱ','ㄲ','ㄴ','ㄷ','ㄸ','ㄹ','ㅁ','ㅂ','ㅃ','ㅅ',
      'ㅆ','ㅇ','ㅈ','ㅉ','ㅊ','ㅋ','ㅌ','ㅍ','ㅎ'
    };
    if (c >= 0xAC00 && c <= 0xD7A3) {
      int index = (c - 0xAC00) / (21 * 28);
      return CHOSUNG[index];
    }
    return c;
  }

  // 초성으로 정렬
  public void sortByChosung(List<PeopleDTO> list) {
    Collections.sort(list, new Comparator<PeopleDTO>() {
      public int compare(PeopleDTO a, PeopleDTO b) {
        return Character.compare(getChosung(a.getPeopleName().charAt(0)), getChosung(b.getPeopleName().charAt(0)));
      }
    });
  }

  // 키워드로 필터링 및 중복 제거
  public List<PeopleDTO> filterByKeyword(List<PeopleDTO> list, String keyword) {
    if (keyword == null || keyword.trim().isEmpty()) {
      return removeDuplicates(list);
    }
    
    List<PeopleDTO> filteredList = new ArrayList<PeopleDTO>();
    Set<String> nameSet = new HashSet<String>(); // 중복 체크용
    
    for (PeopleDTO person : list) {
      if (person.getPeopleName().contains(keyword.trim())) {
        // 중복되지 않은 이름만 추가
        if (!nameSet.contains(person.getPeopleName())) {
          filteredList.add(person);
          nameSet.add(person.getPeopleName());
        }
      }
    }
    return filteredList;
  }
  
  // 중복 제거 메서드
  public List<PeopleDTO> removeDuplicates(List<PeopleDTO> list) {
    List<PeopleDTO> uniqueList = new ArrayList<PeopleDTO>();
    Set<String> nameSet = new HashSet<String>();
    
    for (PeopleDTO person : list) {
      if (!nameSet.contains(person.getPeopleName())) {
        uniqueList.add(person);
        nameSet.add(person.getPeopleName());
      }
    }
    return uniqueList;
  }

%>
<%
  // 검색 키워드는 제거 (클라이언트 사이드에서 처리)
  PeopleService ps = new PeopleService();
  List<PeopleDTO> actorList = ps.searchActor(); // 배우 목록 가져오기
  List<PeopleDTO> directorList = ps.searchDirector(); // 감독 목록 가져오기
  
  // 중복 제거
  actorList = removeDuplicates(actorList);
  directorList = removeDuplicates(directorList);
  
  // 초성 정렬 수행
  sortByChosung(actorList);
  sortByChosung(directorList);
  
  request.setAttribute("actorList", actorList); // 정렬된 리스트 JSP에 전달
  request.setAttribute("directorList", directorList); // 정렬된 리스트 JSP에 전달
  
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

<h2>
<c:if test="${param.people == 'actor'}">
배우 목록
</c:if>
<c:if test="${param.people == 'director'}">
감독 목록
</c:if>
</h2>

<div id="searchDiv">
<c:if test="${param.people == 'actor'}">
		<label class="search-label">배우명</label>
		<input type="text" name="keyword" id="keyword" placeholder="검색할 배우명을 입력하세요..." autocomplete="off"/>
</c:if>		

<c:if test="${param.people == 'director'}">
		<label class="search-label">감독명</label>
		<input type="text" name="keyword" id="keyword" placeholder="검색할 감독명을 입력하세요..." autocomplete="off"/>
</c:if>
		
</div>

<!-- 검색 결과 표시 -->
<div id="searchResult" style="margin-bottom: 10px; color: #666;"></div>

<table>
  <thead>
    <tr>
      <th>
        <c:if test="${param.people == 'actor'}">배우명</c:if>
        <c:if test="${param.people == 'director'}">감독명</c:if>
      </th>
    </tr>
  </thead>
  <tbody>
  <c:if test="${param.people == 'actor'}">
    <c:if test="${not empty actorList}">
    <c:forEach var="actor" items="${actorList}">
      <tr onclick="selectPerson('${actor.peopleName}')">
        <td>${actor.peopleName}</td>
      </tr>
    </c:forEach>
    </c:if>
    <c:if test="${empty actorList}">
    <tr>
      <td style="text-align: center; padding: 20px;">
        <c:if test="${not empty keyword}">
          '${keyword}'에 해당하는 배우가 없습니다.
        </c:if>
        <c:if test="${empty keyword}">
          배우 목록에 배우가 없습니다.
        </c:if>
      </td>
    </tr>
    </c:if>
  </c:if>
  
  <c:if test="${param.people == 'director'}">
    <c:if test="${not empty directorList}">
    <c:forEach var="director" items="${directorList}">
      <tr onclick="selectPerson('${director.peopleName}')">
        <td>${director.peopleName}</td>
      </tr>
    </c:forEach>
    </c:if>
    <c:if test="${empty directorList}">
    <tr>
      <td style="text-align: center; padding: 20px;">
        <c:if test="${not empty keyword}">
          '${keyword}'에 해당하는 감독이 없습니다.
        </c:if>
        <c:if test="${empty keyword}">
          감독 목록에 감독이 없습니다.
        </c:if>
      </td>
    </tr>
    </c:if>
  </c:if>
</tbody>

</table>
<div id="paginationDiv">
<%
PeopleSearchDTO pDTO = new PeopleSearchDTO("people_list.jsp",rDTO.getField(), rDTO.getKeyword());
%>
</div>
</body>
</html>