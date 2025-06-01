<%@page import="kr.co.yeonflix.movie.people.PeopleDTO"%>
<%@page import="kr.co.yeonflix.movie.people.PeopleService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
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
  </style>
  <script>
$(function(){
		
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

%>
<%
  PeopleService ps = new PeopleService();
  List<PeopleDTO> actorList = ps.searchActor(); // 배우 목록 가져오기
  sortByChosung(actorList); // 초성 정렬 수행
  List<PeopleDTO> directorList = ps.searchDirector(); // 감독 목록 가져오기
  sortByChosung(directorList); // 초성 정렬 수행
  
  request.setAttribute("actorList", actorList); // 정렬된 리스트 JSP에 전달
  request.setAttribute("directorList", directorList); // 정렬된 리스트 JSP에 전달
%>


<table>
  <thead>
    <tr>
    <c:if test="${param.people == 'actor'}">
      <th>배우리스트</th>
    </c:if>
    <c:if test="${param.people == 'director'}">
      <th>감독리스트</th>
    </c:if>
    </tr>
  </thead>
  <tbody>
  <c:if test="${param.people == 'actor'}">
    <c:forEach var="actor" items="${ actorList }">
      <tr onclick="selectPerson('${ actor.peopleName }')">
        <td>${ actor.peopleName }</td>
      </tr>
    </c:forEach>
  </c:if>

  <c:if test="${param.people == 'director'}">
    <c:forEach var="director" items="${ directorList }">
      <tr onclick="selectPerson('${ director.peopleName }')">
        <td>${ director.peopleName }</td>
      </tr>
    </c:forEach>
  </c:if>
</tbody>

</table>
</body>
</html>
