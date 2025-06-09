<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지/뉴스 등록</title>
<jsp:include page="/common/jsp/admin_header.jsp" />
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">

<link rel="stylesheet"
	href="http://localhost/movie_prj/admin/notice/css/add.css">
</head>
<body>
<div class="main-wrapper">

<form action="notice_insert.jsp" id="notice_add">
<table>
<tr>
    <th colspan="2">공지/뉴스 등록</th>
</tr>
<tr>
    <td>유형</td>
    <td>
        <select id="type" id="type" name="type">
            <option>극장</option>
            <option>이벤트</option>
            <option>시스템점검</option>
            <option>기타</option>
        </select>
    </td>
</tr>
<tr>
    <td>제목</td>
    <td><input type="text" id="title" name="title"/></td>
</tr>
<tr>
    <td>내용</td>
    <td><textarea id="content" name="content"></textarea></td>
</tr>
<tr>
    <td colspan="2" class="button-container">
        <input type="button" id="add" value="등록"/>
        <input type="button" id="list" value="목록으로"/>
    </td>
</tr>
</table>
</form>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){
    $("#add").click(function(){
        const title = $("#title").val().trim();
        const content = $("#content").val().trim();

        if(title === "" || content === "") {
            alert("제목과 내용을 모두 입력해주세요.");
            return; // 제출 막기
        }
        $("#notice_add").submit();
    });
    $("#list").click(function(){
        location.href="http://localhost/movie_prj/admin/notice/notice_admin_main.jsp";
    });
});
   
</script>
</body>
</html>
