<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지/뉴스 등록</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp" />
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">

<style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    font-family: 'Noto Sans KR', sans-serif;
}

body {
    background-color: #f5f5f5;
    height: 100vh;
    display: flex;
    flex-direction: column;
}

.main-wrapper {
    margin-left: 300px; /* 사이드바 너비 */
    margin-top: 80px;   /* 헤더 높이 */
    padding: 20px;
    min-height: calc(100vh - 80px);
    background-color: #f7f9fc;
}

form#notice_add {
    max-width: 1000px;
    margin: 0 auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    background-color: #fff;
    box-shadow: 0 0 1em rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    overflow: hidden;
}

th {
    background-color: #4a90e2;
    color: white;
    padding: 20px;
    font-size: 1.2em;
    text-align: left;
}

td {
    padding: 15px 20px;
    border-bottom: 1px solid #eee;
    vertical-align: top;
}

td:first-child {
    width: 20%;
    font-weight: bold;
    background-color: #f2f4f8;
}

input[type="text"],
select,
textarea {
    width: 100%;
    padding: 10px;
    font-size: 1em;
    border: 1px solid #ccc;
    border-radius: 4px;
}

textarea {
    height: 30vh;
    resize: both;
    overflow: auto;
}

.button-container {
    text-align: right;
    padding: 15px 20px;
    background-color: #f9f9f9;
}

input[type="button"] {
    padding: 10px 20px;
    font-size: 1em;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

#add {
    background-color: #4CAF50;
    color: white;
}

#list {
    background-color: #f44336;
    color: white;
    margin-left: 10px;
}

</style>
</head>
<body>
<div class="main-wrapper">
<form action="#" id="notice_add">
<table>
<tr>
    <th colspan="2">공지/뉴스 등록</th>
</tr>
<tr>
    <td>유형</td>
    <td>
        <select id="type">
            <option>type1</option>
            <option>type2</option>
            <option>type3</option>
        </select>
    </td>
</tr>
<tr>
    <td>제목</td>
    <td><input type="text" id="title" /></td>
</tr>
<tr>
    <td>내용</td>
    <td><textarea id="content"></textarea></td>
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
        $("#notice_add").submit();
    });
    $("#list").click(function(){
        location.href="http://localhost/movie_prj/admin/notice/notice_admin_main.jsp";
    });
});
   
</script>
</body>
</html>
