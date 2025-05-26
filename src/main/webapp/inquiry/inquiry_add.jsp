<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 작성</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp" />
<style>
  html, body {
    height: 100%;
    margin: 0; padding: 2%;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: #f7f9fc;
  }
  body > form {
    height: 96%;
    width: 96%;
    max-width: 96%;
    margin: 0 auto;
    background: #fff;
    border-radius: 1%;
    box-shadow: 0 0 1.5% rgba(0,0,0,0.1);
    display: table; /* 테이블 스타일 유지 */
  }
  table {
    width: 100%;
    height: 100%;
    border-collapse: separate;
    border-spacing: 0 10px;
    table-layout: fixed; /* 열 너비 균등 */
  }
  tr {
    vertical-align: middle;
  }
  td {
    padding: 1% 1.5%;
    vertical-align: middle;
  }
  td:first-child {
    width: 20%;
    font-weight: 600;
    color: #333;
    white-space: nowrap;
  }
  .radio-group td {
    width: auto;
    padding-right: 2%;
    font-weight: normal;
  }
  input[type="radio"] {
    margin-right: 0.5%;
    vertical-align: middle;
  }
  input[type="text"], textarea {
    width: 100%;
    padding: 1.5% 2%;
    font-size: 1.3rem;
    border: 0.1em solid #ccc;
    border-radius: 6px;
    font-family: inherit;
    box-sizing: border-box;
    transition: border-color 0.3s ease;
    resize: vertical;
  }
  input[type="text"]:focus, textarea:focus {
    outline: none;
    border-color: #4a90e2;
    box-shadow: 0 0 5px rgba(74,144,226,0.5);
  }
  textarea {
    min-height: 250px; /* 기본 높이 크게 */
    max-height: 400px;
  }
  tr:last-child td {
    text-align: right;
  }
  
  input[type="reset"], input[type="button"] {
    background-color: #4a90e2;
    border: none;
    color: white;
    padding: 0.8em 2em;
    font-size: 1.3rem;
    border-radius: 6px;
    cursor: pointer;
    margin-left: 1em;
    transition: background-color 0.3s ease;
  }
  input[type="reset"]:hover, input[type="submit"]:hover {
    background-color: #357abd;
  }
</style>
</head>
<body>

<header>
<c:import url="http://localhost/movie_prj/common/jsp/header.jsp"/>
</header>
<form action="#">
<table>
  <tr class="radio-group">
    <td><strong>문의 유형</strong></td>
    <td><label><input type="radio" name="type" value="type1" />type1</label></td>
    <td><label><input type="radio" name="type" value="type2" />type2</label></td>
    <td><label><input type="radio" name="type" value="type3" />type3</label></td>
    <td><label><input type="radio" name="type" value="type4" />type4</label></td>
  </tr>
  <tr>
    <td><strong>제목</strong></td>
    <td colspan="4"><input type="text" id="title" name="title" /></td>
  </tr>
  <tr style="height: 100%;">
    <td><strong>내용</strong></td>
    <td colspan="4"><textarea id="content" name="content" placeholder="내용을 입력하세요"></textarea></td>
  </tr>
  <tr>
    <td></td>
    <td colspan="4">
      <input type="reset" value="취소" />
      <input type="button" id="add" value="등록하기" />
    </td>
  </tr>
</table>
</form>

<footer>
<c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
</footer>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){
    $("#add").click(function(){
        location.href="http://localhost:8080/jsp_prj/inquiry/inquiry_accept.jsp";
    });
    $("#delete").click(function(){
    });
});
</script>
</body>
</html>
