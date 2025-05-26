<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp" />
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">
<style>
/* 사이드바 + 헤더 레이아웃 반영 */
.main-content {
width:100%;
    margin-left: 300px;  /* 사이드바 너비 */
    margin-top: 80px;    /* 헤더 높이 */
    padding: 2rem;
    background-color: #f7f9fc;
    min-height: calc(100vh - 80px);
}

/* 테이블 스타일 */
.inquiry-table {
    width: 100%;
    height:100%;
    margin: 0 auto;
    border-collapse: collapse;
    background-color: #ffffff;
    box-shadow: 0 0 8px rgba(0, 0, 0, 0.05);
    border-radius: 8px;
    overflow: hidden;
    font-size: 0.9rem;
}

.inquiry-table th {
    background-color: #4a90e2;
    color: white;
    text-align: left;
    padding: 1rem 1.5rem;
    font-size: 1.1rem;
}

.inquiry-table td {
    padding: 1rem 1.5rem;
    vertical-align: middle;
}

.inquiry-table td:first-child {
    font-weight: bold;
    width: 25%;
    white-space: nowrap;
}

.inquiry-table input[type="text"],
.inquiry-table textarea {
    width: 100%;
    font-size: 0.95rem;
    padding: 0.75rem 1rem;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-family: inherit;
}

.inquiry-table textarea {
    height: 8rem;
    resize: vertical;
}

.inquiry-table .button-row {
    text-align: center;
    padding: 1.5rem 0;
}

.inquiry-table input[type="button"] {
    padding: 0.6rem 1.5rem;
    margin: 0 0.5rem;
    font-size: 0.95rem;
    border: none;
    border-radius: 5px;
    background-color: #4a90e2;
    color: white;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.inquiry-table input[type="button"]:hover {
    background-color: #357abd;
}
</style>
</head>
<body>
<div class="main-content">
    <table class="inquiry-table">
        <tr><th>1:1 문의</th><th></th></tr>
        <tr>
            <td>질문타입</td>
            <td><input type="text" id="title" value="제목"/></td>
        </tr>
        <tr>
            <td>질문</td>
            <td><textarea id="question">질문</textarea></td>
        </tr>
        <tr>
            <td>답변</td>
            <td><textarea id="answer">답변</textarea></td>
        </tr>
        <tr>
            <td colspan="2" class="button-row">
                <input type="button" id="add" value="등록"/>
                <input type="button" id="delete" value="삭제"/>
                <input type="button" id="list" value="목록으로"/>
            </td>
        </tr>
    </table>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){
    $("#list").click(function(){
        location.href="http://localhost:8080/jsp_prj/inquiry/inquiry_accept.jsp";
    });
    $("#delete").click(function(){
    });
});
</script>
</body>
</html>
