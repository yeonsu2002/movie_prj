<%@page import="kr.co.yeonflix.inquiry.inquiryDTO"%>
<%@page import="kr.co.yeonflix.inquiry.inquiryDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1문의</title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">

<link rel="stylesheet"
	href="http://localhost/movie_prj/admin/inquiry/css/admin.css">
	</head>
<body>
	<%
	inquiryDAO dao = new inquiryDAO();
	inquiryDTO iDTO= dao.selectinquiry(request.getParameter("idx"));
	request.setAttribute("iDTO", iDTO);
	%>
	<div class="inquiry-detail-wrapper">
	<form action="inquiry_answer.jsp" id="answer_add">
	<input type="hidden" name="num" value="${iDTO.inquiry_board_idx}" />
		<h2>1:1문의</h2>
		<strong>유저id</strong>
		<label>${iDTO.member_id}</label><br>
		<strong>유형</strong>
		<label>${iDTO.board_code_name}</label><br>
		<strong>제목</strong>
			<label>${iDTO.inquiry_title}</label><br>
			<strong>내용</strong>
			<textarea id="content" placeholder="내용을 입력하세요" readonly="readonly"><c:out value="${iDTO.inquiry_content}" /></textarea>
			<br>
			<strong>답변</strong>
			<textarea id="answer_content" name="answer_content" placeholder="답변을 입력하세요"><c:out value="${iDTO.answer_content}"/></textarea>

			<div class="btn-area">
				<input type="button" id="list" value="목록으로" />
				<input type="button" id="answer" value="답변하기"/>
			</div>
	</form>
	</div>


	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		$(function() {
			$("#list").click(function() {
				location.href = "http://localhost/movie_prj/admin/inquiry/inquiry_admin_main.jsp";
			});
			$("#answer").click(function(){
				$("#answer_add").submit();
			})
		});
	</script>


</body>
</html>



