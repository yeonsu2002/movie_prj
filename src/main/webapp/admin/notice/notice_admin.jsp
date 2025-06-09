<%@page import="kr.co.yeonflix.notice.noticeDTO"%>
<%@page import="kr.co.yeonflix.notice.noticeDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지/뉴스</title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">
	
<link rel="stylesheet"
	href="http://localhost/movie_prj/admin/notice/css/admin.css">
</head>
<body>
	<%
	noticeDAO dao = new noticeDAO();
	noticeDTO nDTO= dao.selectNotice(request.getParameter("idx"));
	request.setAttribute("nDTO", nDTO);
	%>
	<div class="notice-detail-wrapper">
	<div class="container">
		<h2>공지/뉴스</h2>
		<div class="description">주요한 이슈 및 여러가지 소식들을 확인하실 수 있습니다</div>
		<strong>유형</strong>
		<label>${nDTO.board_code_name}</label><br>
		<form action="notice_modify.jsp" id="alter">
		<strong>제목</strong>
			<label>${nDTO.notice_title}</label><br>
			<input type="hidden" name="num" value="${nDTO.notice_board_idx }"/>
			<textarea id="content" name="content" placeholder="내용을 입력하세요">${nDTO.notice_content }</textarea>
			
			<div class="btn-area">
				<input type="button" id="modify" value="수정하기"/>
				<input type="button" id="list" value="목록으로" />
			</div>
		</form>
	</div>
</div>


	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		$(function() {
			$("#modify").click(function(){
				$("#alter").submit();
			})
			$("#list").click(
					function() {
						location.href = "http://localhost/movie_prj/admin/notice/notice_admin_main.jsp";
					});
		});
	</script>


</body>
</html>



