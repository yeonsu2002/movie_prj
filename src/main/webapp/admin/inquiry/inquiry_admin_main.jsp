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
	href="http://localhost/movie_prj/admin/inquiry/css/admin_main.css">
</head>
<body>
	<%
	int first = 1;
	int size = 10;
	if (request.getParameter("page") != null) {
		first = Integer.parseInt(request.getParameter("page"));
	}
	inquiryDAO idao = new inquiryDAO();
	
	String type="all";
	String input="";
	int total = idao.getInquiryCount(type);
	int totalPages = (int) Math.ceil(total / (double) size);

	List<inquiryDTO> inquirys = idao.selectAllPaged(first, size);
	if (request.getParameter("type") != null && !request.getParameter("type").trim().equals("")) {
		type=request.getParameter("type");
		input=request.getParameter("input");
		inquirys=idao.Searchinquiry(type, input,first,size);
	}
	
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
			
		<form action="inquiry_admin_main.jsp" id="frm" name="frm">
		<select name="type" id="type">
			<option value="">------ 타입을 선택하세요 ------</option>
			<option value="member_id">유저 id</option>
			<option value="board_code_name">유형(문의,불만,칭찬,제안,분실물)</option>
			<option value="inquiry_title">제목</option>
			<option value="answer_status">답변상태 (0:미답변 1:답변완료)</option>
		</select>
		<input type="text" name="input"/>
		<input type="button" id="search" value="검색"/>
		</form>
			</tr>
			<tr>
				<td>
					<table id="mid">
						<tr>
							<th>선택</th>
							<th>유저id</th>
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
									<td>${inquiry.member_id}</td>
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
						</form>
					</table>
				</td>
			</tr>
		</table>
			<div class="inquiry-actions">
  <div class="page-wrapper">
    <div class="page-buttons">
      <c:if test="${currentPage > 1}">
        <a href="inquiry_admin_main.jsp?page=${currentPage - 1}">«</a>
      </c:if>

      <c:forEach begin="1" end="${totalPages}" var="i">
        <a href="inquiry_admin_main.jsp?page=${i}"
           style="font-weight: ${i == currentPage ? 'bold' : 'normal'}">
          ${i}
        </a>
      </c:forEach>

      <c:if test="${currentPage < totalPages}">
        <a href="inquiry_admin_main.jsp?page=${currentPage + 1}">»</a>
      </c:if>
    </div>
  </div>
  <div class="action-buttons">
    <input type="button" id="delete" value="삭제" />
  </div>
		
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		$(function() {
			$("#delete").click(function() {
				$("#inquiry_delete").submit();
			})
			$("#search").click(function(){
				$("#frm").submit();
			})
		});
	</script>
</body>
</html>