<%@page import="kr.co.yeonflix.inquiry.inquiryDTO"%>
<%@page import="kr.co.yeonflix.inquiry.inquiryDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/common/jsp/external_file.jsp" />
<jsp:include page="/common/jsp/header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1문의</title>
<link rel="stylesheet" href="http://localhost/movie_prj/inquiry/css/user.css">
</head>
<body>
<c:import url="http://localhost/movie_prj/customer_service/side_menu.jsp" />
<div class="container">
	<%
	inquiryDAO dao = new inquiryDAO();
	inquiryDTO iDTO= dao.selectinquiry(request.getParameter("idx"));
	request.setAttribute("iDTO", iDTO);
	%>
		<h2>1:1문의</h2>
		 <div class="field">
		<strong>유형</strong>
		<label>${iDTO.board_code_name}</label><br>
		</div>
		<form>
		 <div class="field">
		<strong>제목</strong>
		<label>${iDTO.inquiry_title}</label><br>
		</div>
		 <div class="field">
		<strong>내용</strong>
		<textarea id="content" class="${iDTO.answer_status == 1 ? 'has-answer' : 'no-answer'}" readonly="readonly">${iDTO.inquiry_content }</textarea>
		</div>
		<br>
		<%if(iDTO.getAnswer_status()==1){ %>
			<strong>답변</strong>
			<textarea id="answer" class="${iDTO.answer_status == 1 ? 'has-answer' : 'no-answer'}" readonly="readonly"><c:out value="${iDTO.answer_content}"/></textarea>
			<br>
		<%} %>
		<input type="button" id="list" value="목록으로" />
		</form>
</div>
	
<footer>
<jsp:include page="/common/jsp/footer.jsp"/>
</footer>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		$(function() {
			$("#list").click(
					function() {
						location.href = "http://localhost/movie_prj/inquiry/inquiry_user_main.jsp";
					});
		});
	</script>


</body>
</html>



