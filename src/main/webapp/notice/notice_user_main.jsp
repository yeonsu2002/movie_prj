<%@page import="kr.co.yeonflix.notice.noticeDTO"%>
<%@page import="kr.co.yeonflix.notice.noticeDAO"%>
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
<title>공지/뉴스 관리</title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/notice/css/user_main.css">
</head>
<body>
<c:import url="http://localhost/movie_prj/customer_service/side_menu.jsp" />
	<%
	int first = 1;
	int size = 10;

	if (request.getParameter("page") != null) {
		first = Integer.parseInt(request.getParameter("page"));
	}

	String type = request.getParameter("type");
	
	noticeDAO ndao = new noticeDAO();
	int total = ndao.getNoticeCount(type);
	int totalPages = (int) Math.ceil(total / (double) size);

	List<noticeDTO> notices = ndao.selectPagedType(type,first, size);
	if(request.getParameter("search")!=null){
		notices = ndao.searchNotice(request.getParameter("search"));
		total = 1;
		totalPages = 1;
	}
	request.setAttribute("notices", notices);
	request.setAttribute("currentPage", first);
	request.setAttribute("totalPages", totalPages);
	%>

	<%--
	String type = request.getParameter("type");
	noticeDAO ndao = new noticeDAO();
	List<noticeDTO> notices;

	if (type == null || type.equals("전체")) {
		notices = ndao.selectAllNotice();
	} else {
		notices = ndao.selectNoticeType(type);
	}
	request.setAttribute("notices", notices);
	--%>
	<div class="notice-wrapper">
		<table>
			<tr>
				<th>공지/뉴스 관리</th>
			</tr>
			<tr>
				<td><input type="button" id="all" value="전체"></td>
				<td><input type="button" id="theater" value="극장"></td>
				<td><input type="button" id="event" value="이벤트"></td>
				<td><input type="button" id="check" value="시스템점검"></td>
				<td><input type="button" id="others" value="기타"></td>
			</tr>
			<tr>
				<td colspan="5">
					<!-- 혹은 6 -->
					<div class="notice-table-wrapper">
						<table id="mid">
							<tr>
								<th>번호</th>
								<th>구분</th>
								<th>제목</th>
								<th>조회수</th>
								<th>등록일</th>
							</tr>
							<c:forEach var="notice" items="${notices}" varStatus="count">
								<tr>
									<td>${notice.notice_board_idx}</td>
									<td>${notice.board_code_name}</td>
									<td><a
										href="http://localhost/movie_prj/notice/notice_user.jsp?idx=${notice.notice_board_idx}">${notice.notice_title}</a></td>
									<td>${notice.view_count}</td>
									<td>${notice.created_time }</td>
								</tr>
							</c:forEach>
							<tr>
								<td colspan="6">
									<div class="page-buttons">
										<c:if test="${currentPage > 1}">
											<a href="notice_user_main.jsp?page=${currentPage - 1}">«</a>
										</c:if>

										<c:forEach begin="1" end="${totalPages}" var="i">
											<a href="notice_user_main.jsp?page=${i}"
												style="font-weight: ${i == currentPage ? 'bold' : 'normal'}">
												${i} </a>
										</c:forEach>

										<c:if test="${currentPage < totalPages}">
											<a href="notice_user_main.jsp?page=${currentPage + 1}">»</a>
										</c:if>
									</div>
								</td>
							</tr>
						</table>
				</td>
			</tr>
		</table>
	</div>

	<footer>
<jsp:include page="/common/jsp/footer.jsp"/>
	</footer>


	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		$(function() {
			$("#all")
					.click(
							function() {
								location.href = "http://localhost/movie_prj/notice/notice_user_main.jsp?type=전체";
							})
			$("#theater")
					.click(
							function() {
								location.href = "http://localhost/movie_prj/notice/notice_user_main.jsp?type=극장";
							})
			$("#event")
					.click(
							function() {
								location.href = "http://localhost/movie_prj/notice/notice_user_main.jsp?type=이벤트";
							})
			$("#check")
					.click(
							function() {
								location.href = "http://localhost/movie_prj/notice/notice_user_main.jsp?type=시스템점검";
							})
			$("#others")
					.click(
							function() {
								location.href = "http://localhost/movie_prj/notice/notice_user_main.jsp?type=기타";
							})

		});
	</script>
</body>
</html>
