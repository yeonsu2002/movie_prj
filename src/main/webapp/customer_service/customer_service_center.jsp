<%@page import="kr.co.yeonflix.notice.noticeDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.notice.noticeDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/common/jsp/external_file.jsp" />
<jsp:include page="/common/jsp/header.jsp" /><!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객센터문의</title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/customer_service/customer_service.css">
</head>
<body>
	<div class="layout-wrapper">
<c:import url="http://localhost/movie_prj/customer_service/side_menu.jsp" />
		<!-- 중앙 메인 콘텐츠 -->
		<div class="customer-wrapper">
			<div class="button-grid">
				<div class="menu-card">
					<label>질문 빠른검색</label>
					<form action="http://localhost/movie_prj/notice/notice_user_main.jsp" id="frm">
					 <input type="text"  name="search" placeholder="Search" />	
					 <input type="button" id="search" value="검색"/>
					 </form>
				</div>
				<div class="menu-card">
					<label>이메일 문의</label><br>
					<input type="button" id="inquiry" value="문의하기"/>
				</div>
				<div class="menu-card">
					<label>내 상담 내역 확인</label><br>
					<input type="button" id="check" value="문의내역 조회"/>
				</div>
			</div>

			<div class="notice-section">
				<h2>
					공지/뉴스 
				</h2>
				<table class="notice-table">
					<%
					noticeDAO dao = new noticeDAO();
					List<noticeDTO> notices = dao.selectAllNotice();
					request.setAttribute("notices", notices);
					%>
					<c:forEach var="notice" items="${notices}" varStatus="status">
						<c:if test="${status.count <= 5}">
							<tr>
								<td><a href="http://localhost/movie_prj/notice/notice_user.jsp?idx=${notice.notice_board_idx }">${notice.notice_title}</a></td>
								<td>조회수${notice.view_count}</td>
							</tr>
						</c:if>
					</c:forEach>
				</table>
			</div>
		</div>
	</div>


	<footer>
<jsp:include page="/common/jsp/footer.jsp"/>
	</footer>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		$(function() {
			$("#inquiry")
					.click(
							function() {
								location.href = "http://localhost/movie_prj/inquiry/inquiry_add.jsp";
							})
			$("#check")
					.click(
							function() {
								location.href = "http://localhost/movie_prj/inquiry/inquiry_user_main.jsp";
							})
			$("#search").click(function(){
				$("#frm").submit();
			})
		});//ready
	</script>
</body>
</html>