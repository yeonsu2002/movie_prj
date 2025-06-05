<%@page import="kr.co.yeonflix.notice.noticeDTO"%>
<%@page import="kr.co.yeonflix.notice.noticeDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지/뉴스 관리</title>
<jsp:include page="/common/jsp/admin_header.jsp" />
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">
	
<link rel="stylesheet"
	href="http://localhost/movie_prj/admin/notice/css/admin_main.css">
</head>
<body>
<%
	int first = 1;
	int size = 10;

	if (request.getParameter("page") != null) {
		first = Integer.parseInt(request.getParameter("page"));
	}
	noticeDAO ndao = new noticeDAO();
	int total = ndao.getNoticeCount("전체");
	int totalPages = (int) Math.ceil(total / (double) size);

	List<noticeDTO> notices = ndao.selectPaged(first, size);
	request.setAttribute("notices", notices);
	request.setAttribute("currentPage", first);
	request.setAttribute("totalPages", totalPages);
	%>
	<%--
				List<noticeDTO> notices = dao.selectAllNotice();
				request.setAttribute("notices", notices);
				--%>
	<div class="notice-list-container">
		<%!noticeDAO dao = new noticeDAO();%>
		<h1>공지/뉴스 관리</h1>
		<form action="notice_delete.jsp" id="notice_delete">
			<table class="notice-table">
				<thead>
					<tr>
						<th>선택</th>
						<th>번호</th>
						<th>구분</th>
						<th>제목</th>
						<th>조회수</th>
						<th>등록일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="notice" items="${notices}" varStatus="count">
						<tr>
							<td><input type="checkbox" name="choose"
								value="${notice.notice_board_idx }" /></td>
							<td>${notice.notice_board_idx}</td>
							<td>${notice.board_code_name}</td>
							<td><a
								href="http://localhost/movie_prj/admin/notice/notice_admin.jsp?idx=${notice.notice_board_idx}">${notice.notice_title}</a></td>
							<td>${notice.view_count }</td>
							<td>${notice.created_time }</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<div class="notice-actions">
			<div class="page-buttons">
										<c:if test="${currentPage > 1}">
											<a href="notice_admin_main.jsp?page=${currentPage - 1}">«</a>
										</c:if>

										<c:forEach begin="1" end="${totalPages}" var="i">
											<a href="notice_admin_main.jsp?page=${i}"
												style="font-weight: ${i == currentPage ? 'bold' : 'normal'}">
												${i} </a>
										</c:forEach>

										<c:if test="${currentPage < totalPages}">
											<a href="notice_admin_main.jsp?page=${currentPage + 1}">»</a>
										</c:if>
									</div>
				<div class="action-buttons">
					<input type="button" id="add" value="새 공지 작성" /> <input
						type="button" id="delete" value="삭제" />
				</div>
			</div>
		</form>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		$(function() {
			$("#add")
					.click(
							function() {
								location.href = "http://localhost/movie_prj/admin/notice/notice_add.jsp";
							});
			$("#delete").click(function() {
				$("#notice_delete").submit();
			});
		});
	</script>
</body>
</html>
