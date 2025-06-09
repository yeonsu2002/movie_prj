<%@page import="kr.co.yeonflix.member.MemberDTO"%>
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
<link rel="stylesheet"
	href="http://localhost/movie_prj/inquiry/css/user_main.css">
<c:import url="http://localhost/movie_prj/customer_service/side_menu.jsp" />
</head>
<body>

	<%
	MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
	String user = null;
	if (loginUser != null) {
		int userIdx = loginUser.getUserIdx();
		user = Integer.toString(userIdx);
	} else {
		response.sendRedirect("http://localhost/movie_prj/login/loginFrm.jsp");//로그인 안되있으면 로그인 사이트로
		return;
	}
	%>
	<%
	int first = 1;
	int size = 10;

	if (request.getParameter("page") != null) {
		first = Integer.parseInt(request.getParameter("page"));
	}
	//int userIdx = loginUser != null ? loginUser.getUserIdx() : 0;
	inquiryDAO idao = new inquiryDAO();
	int total = idao.getInquiryCount(user);
	int totalPages = (int) Math.ceil(total / (double) size);

	List<inquiryDTO> inquirys = idao.selectPaged(user, first, size);
	request.setAttribute("inquirys", inquirys);
	request.setAttribute("currentPage", first);
	request.setAttribute("totalPages", totalPages);
	%>
	<%--
	inquiryDAO idao = new inquiryDAO();
	List<inquiryDTO> inquirys = idao.selectAllinquiry(user);//현재 로그인한 유저의 1:1문의
	request.setAttribute("inquirys", inquirys);
	--%>

	<div class="inquiry-wrapper">
	<table>
		<tr>
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
									href="http://localhost/movie_prj/inquiry/inquiry_user.jsp?idx=${inquiry.inquiry_board_idx}">${inquiry.inquiry_title}</a></td>
								<td>${inquiry.created_time }</td>
								<td><c:choose>
										<c:when test="${inquiry.answer_status == 1}">답변 완료</c:when>
										<c:otherwise>미답변</c:otherwise>
									</c:choose></td>
							</tr>
						</c:forEach>
						<tr>
							<td colspan="6">
								<div class="page-buttons">
									<c:if test="${currentPage > 1}">
										<a href="inquiry_user_main.jsp?page=${currentPage - 1}">«</a>
									</c:if>

									<c:forEach begin="1" end="${totalPages}" var="i">
										<a href="inquiry_user_main.jsp?page=${i}"
											style="font-weight: ${i == currentPage ? 'bold' : 'normal'}">
											${i} </a>
									</c:forEach>

									<c:if test="${currentPage < totalPages}">
										<a href="inquiry_user_main.jsp?page=${currentPage + 1}">»</a>
									</c:if>
								</div>
								<div class="bottom-buttons">
									<input type="button" id="delete" value="삭제" /> <input
										type="button" id="add" value="문의하기" />
								</div>
							</td>
						</tr>
					</form>
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
			$("#delete").click(function() {
				$("#inquiry_delete").submit();
			})
			$("#add")
					.click(
							function() {
								location.href = "http://localhost/movie_prj/inquiry/inquiry_add.jsp";
							})
		});
	</script>
</body>
</html>
