<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
<c:import url="http://localhost/movie_prj/common/jsp/header.jsp"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 작성</title>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 작성</title>
<link rel="stylesheet" href="http://localhost/movie_prj/inquiry/css/add.css">
</head>
<body>
<div class="inquiry-wrapper">
<form action="inquiry_accept.jsp" id="inquiry_add">
<table>
  <tr class="radio-group">
    <td><strong>문의 유형</strong></td>
    <td><label><input type="radio" name="type" value="문의" />문의</label></td>
    <td><label><input type="radio" name="type" value="불만" />불만</label></td>
    <td><label><input type="radio" name="type" value="칭찬" />칭찬</label></td>
    <td><label><input type="radio" name="type" value="제안" />제안</label></td>
    <td><label><input type="radio" name="type" value="분실물" />분실물</label></td>
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
      <input type="button" id="list" value="취소" />
      <input type="button" id="add" value="등록하기" />
    </td>
  </tr>
</table>
</form>
</div>


<footer>
<c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
</footer>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){
    $("#add").click(function(){
        $("#inquiry_add").submit();
    });
    $("#list").click(function(){
    	location.href="http://localhost/movie_prj/inquiry/inquiry_user_main.jsp";
    });
});
</script>
</body>
</html>
