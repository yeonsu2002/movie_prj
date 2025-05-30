<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />
<%
	int scheduleIdx = Integer.parseInt(request.getParameter("scheduleParam"));
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>예매 관리</title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">
<style type="text/css">

.content-container {
	position: fixed;
	top: 80px;
	left: 300px;
	right: 0;
	bottom: 0;
	padding: 20px;
	background-color: #f0f0f0;
}
.title {
  margin-bottom: 5px;
  font-size: 20px;
}

.time-info {
  font-weight: bold;
  margin-bottom: 20px;
}

.time-info .start-time {
  color: black;
}

.time-info .reserved {
  color: red;
}

.member-button {
  padding: 6px 12px;
  margin-bottom: 15px;
  border: 1px solid #ccc;
  background-color: white;
  cursor: pointer;
  border-radius: 4px;
}

#booking-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

#booking-table th,
#booking-table td {
  padding: 10px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

#booking-table thead {
  background-color: #f9f9f9;
  font-weight: bold;
}

#booking-table .nickname {
  color: #0066cc;
  text-decoration: none;
}

#booking-table .status.reserved {
  color: red;
}

#booking-table .status.canceled {
  color: gray;
}

</style>
</head>
<body>
<div class="content-container">
<h2 class="title">예매 리스트</h2>
<p class="time-info">
  IMAX 썬더 볼츠 시작 시간 <span class="start-time">08:00</span>
  (<span class="reserved">35</span> / 50)
</p>

<button class="member-button">회원 ▼</button>

<table id="booking-table">
  <thead>
    <tr>
      <th>이름</th>
      <th>닉네임</th>
      <th>이메일</th>
      <th>상태</th>
      <th>예매 날짜</th>
      <th>좌석</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>유지민</td>
      <td><a href="#" class="nickname">카리나</a></td>
      <td>karina@google.com</td>
      <td class="status reserved">예매완료</td>
      <td>2025.05.08 17:10</td>
      <td>A56</td>
    </tr>
    <tr>
      <td>신민기</td>
      <td><a href="#" class="nickname">개발자</a></td>
      <td>developerMingi@naver.com</td>
      <td class="status canceled">예매취소</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td>주현석</td>
      <td><a href="#" class="nickname">갓현석</a></td>
      <td>hyunsuk@google.com</td>
      <td class="status reserved">예매완료</td>
      <td></td>
      <td></td>
    </tr>
  </tbody>
</table>
</div>
</body>
</html>
