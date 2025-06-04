<%@page import="kr.co.yeonflix.inquiry.inquiryDTO"%>
<%@page import="kr.co.yeonflix.inquiry.inquiryDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1문의</title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">

<link rel="stylesheet"
	href="http://localhost/movie_prj/admin/inquiry/css/admin_main.css">
</head>
<body>
	<%
	int first = 1;
	int size = 5;
	if (request.getParameter("page") != null) {
		first = Integer.parseInt(request.getParameter("page"));
	}
	inquiryDAO idao = new inquiryDAO();
	int total = idao.getInquiryCount("all");
	int totalPages = (int) Math.ceil(total / (double) size);

	List<inquiryDTO> inquirys = idao.selectAllPaged(first, size);
	request.setAttribute("inquirys", inquirys);
	request.setAttribute("currentPage", first);
	request.setAttribute("totalPages", totalPages);
	%>
	<%--
						inquiryDAO idao = new inquiryDAO();
						List<inquiryDTO> inquirys = idao.selectAllinquiry("all");
						request.setAttribute("inquirys", inquirys);
						--%>
	<div class="inquiry-wrapper">
		<table>
			<tr class="title-row">
				<th>1:1문의</th>
			</tr>
			<tr>
				<td>
					<table id="mid">
						<tr>
							<th>선택</th>
							<th>번호</th>
							<th>유형</th>
							<th>제목</th>
							<th>등록일</th>
							<th>상태</th>
						</tr>
						<form action="inquiry_delete.jsp" id="inquiry_delete">
							<c:forEach var="inquiry" items="${inquirys}" varStatus="count">
								<tr>
									<td><input type="checkbox" name="choose"
										value="${inquiry.inquiry_board_idx }" /></td>
									<td>${inquiry.inquiry_board_idx}</td>
									<td>${inquiry.board_code_name}</td>
									<td><a
										href="http://localhost/movie_prj/admin/inquiry/inquiry_admin.jsp?idx=${inquiry.inquiry_board_idx}">${inquiry.inquiry_title}</a></td>
									<td>${inquiry.created_time }</td>
									<td><c:choose>
											<c:when test="${inquiry.answer_status == 1}">답변 완료</c:when>
											<c:otherwise>미답변</c:otherwise>
										</c:choose></td>
								</tr>
							</c:forEach>
							<tr>
								<td colspan="5">
									<div class="page-buttons">
									<c:if test="${currentPage > 1}">
										<a href="inquiry_admin_main.jsp?page=${currentPage - 1}">«</a>
									</c:if>

									<c:forEach begin="1" end="${totalPages}" var="i">
										<a href="inquiry_admin_main.jsp?page=${i}"
											style="font-weight: ${i == currentPage ? 'bold' : 'normal'}">
											${i} </a>
									</c:forEach>

									<c:if test="${currentPage < totalPages}">
										<a href="inquiry_admin_main.jsp?page=${currentPage + 1}">»</a>
									</c:if>
								</div>
								<td><input type="button" id="delete" value="삭제" /></td>
								</td>
							</tr>
						</form>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		$(function() {
			$("#delete").click(function() {
				$("#inquiry_delete").submit();
			})
		});
	</script>
</body>
</html>
