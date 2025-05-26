<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지/뉴스 관리</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp" />
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">

<style>
.notice-table-wrapper {
    position: relative;
    margin-left: 300px;
    margin-top: 80px;
    width: calc(100% - 300px);
    height: calc(100vh - 80px);
    padding: 20px;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
}
.notice-table-wrapper #all {
    width: 100%;
    height: 100%;
    border-collapse: collapse;
    table-layout: fixed;
}

.notice-table-wrapper #all th, .notice-table-wrapper #all td {
	padding: 12px;
	text-align: center;
	border-bottom: 1px solid #e0e0e0;
	font-size: 14px;
}

.notice-table-wrapper #all th {
	background-color: #4a90e2;
	color: #ffffff;
	font-weight: bold;
}


.notice-table-wrapper input[type="checkbox"] {
	transform: scale(1.1);
}

.notice-table-wrapper input[type="button"] {
	padding: 8px 16px;
	font-size: 14px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	margin: 4px;
}

.notice-table-wrapper #add {
	background-color: #4CAF50;
	color: white;
}

.notice-table-wrapper #delete {
	background-color: #f44336;
	color: white;
}

.notice-table-wrapper .button-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 20px;
}

.notice-table-wrapper .page-buttons {
	flex: 1;
	text-align: center;
}

.notice-table-wrapper .action-buttons {
	text-align: right;
	white-space: nowrap;
}
.notice-table-wrapper #mid {
    width: 100%;
    height:100%;
}
</style>
</head>
<body>
	<div class="notice-table-wrapper">
		<table id="all">
			<tr>
				<th>공지/뉴스 관리</th>
			</tr>
			<tr>
				<td>
					<table id="mid">
						<tr>
							<th>선택</th>
							<th>번호</th>
							<th>구분</th>
							<th>제목</th>
							<th>조회수</th>
							<th>등록일</th>
						</tr>
						<%
						for (int i = 0; i < 5; i++) {
						%>
						<tr>
							<td><input type="checkbox" id="choose" /></td>
							<td>번호</td>
							<td>구분</td>
							<td><a href="http://localhost/movie_prj/admin/notice/notice_admin.jsp">제목</a></td>
							<td>조회수</td>
							<td>등록일</td>
						</tr>
						<%
						}
						%>
						<tr>
							<td colspan="6">
								<div class="button-row">
									<div class="page-buttons">
										<input type="button" class="nav-btn" value="«" />
										<%for (int i = 1; i <= 5; i++) {%>
										<input type="button" id="pageNum" value="<%=i%>" />
										<%}%>
										<input type="button" class="nav-btn" value="»" />
									</div>
									<div class="action-buttons">
										<input type="button" id="add" value="새 공지 작성" /> <input
											type="button" id="delete" value="삭제" />
									</div>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		$(function() {
			$("#add").click(
				function() {
					location.href = "http://localhost/movie_prj/admin/notice/notice_add.jsp";
				});
			$("#delete").click(function() {
			});
		});
	</script>
</body>
</html>
