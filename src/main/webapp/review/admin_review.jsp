<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" info="Admin review management page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="kr.co.yeonflix.review.*, java.util.*" %>

<%
ReviewService reviewService = new ReviewService();

// POST 요청 시 삭제 처리
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String[] reviewIds = request.getParameterValues("reviewIds");
    if (reviewIds != null && reviewIds.length > 0) {
        List<Integer> idsToDelete = new ArrayList<>();
        for (String idStr : reviewIds) {
            try {
                idsToDelete.add(Integer.parseInt(idStr));
            } catch (NumberFormatException e) {
                // 무시
            }
        }
        boolean success = reviewService.removeMultipleReviews(idsToDelete);
        if(success) {
            session.setAttribute("msg", "선택한 리뷰가 성공적으로 삭제되었습니다.");
        } else {
            session.setAttribute("msg", "리뷰 삭제 중 오류가 발생했습니다.");
        }
    } else {
        session.setAttribute("msg", "삭제할 리뷰를 선택해주세요.");
    }
    response.sendRedirect("admin_review.jsp");
    return;
}

// GET 요청 시 조회 및 검색 처리
String keyword = request.getParameter("keyword");
List<ReviewDTO> reviewList;

if (keyword != null && !keyword.trim().isEmpty()) {
    reviewList = reviewService.searchReviewsByUserId(keyword.trim());
} else {
    reviewList = reviewService.getAllReviews();
}
request.setAttribute("reviewList", reviewList);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 - 영화 리뷰 관리</title>
<link rel="stylesheet" href="http://localhost/movie_prj/common/css/admin.css">
<style>
  /* 스타일은 기존 코드와 동일 */
  body {
    font-family: 'Noto Sans KR', sans-serif;
    margin: 0;
    background-color: #f0f0f0;
  }
  .content-container {
    position: fixed;
    top: 80px;
    left: 300px;
    right: 0;
    bottom: 0;
    padding: 30px;
    background-color: #f9fafb;
    overflow-y: auto;
  }
  h2 {
    font-size: 24px;
    margin-bottom: 20px;
  }
  .search-form {
    margin-bottom: 20px;
    text-align: center;
  }
  .search-form input[type="text"] {
    padding: 8px;
    width: 220px;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 3px;
  }
  .search-form button {
    padding: 8px 14px;
    background-color: #3b82f6;
    color: #fff;
    border: none;
    border-radius: 3px;
    font-size: 14px;
    cursor: pointer;
  }
  table.review-table {
    width: 100%;
    border-collapse: collapse;
    background-color: white;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  }
  table.review-table th,
  table.review-table td {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: center;
    font-size: 16px;
  }
  table.review-table th {
    background-color: #f5f5f5;
    font-weight: bold;
    color: #333;
  }
  table.review-table td {
    background-color: #fff;
  }
  .no-result {
    text-align: center;
    padding: 30px;
    font-size: 16px;
    color: #999;
  }
</style>
</head>
<body>

<c:if test="${not empty sessionScope.msg}">
  <div style="padding:10px; background-color:#d1ffd1; margin-bottom:15px; border: 1px solid #4CAF50; color:#333;">
    ${sessionScope.msg}
  </div>
  <%
    session.removeAttribute("msg");
  %>
</c:if>

<%@ include file="/common/jsp/admin_header.jsp" %>

<div class="content-container">

  <h2>영화 리뷰 관리</h2>

  <!-- 검색 폼 -->
  <form class="search-form" method="get" action="admin_review.jsp">
    <input type="text" name="keyword" placeholder="회원 ID로 검색" value="<%= keyword != null ? keyword : "" %>">
    <button type="submit">검색</button>
  </form>

  <!-- 리뷰 테이블 및 삭제 폼 -->
  <form id="deleteForm" method="post" action="admin_review.jsp">
    <table class="review-table">
      <thead>
        <tr>
        
          <th>선택</th>
          <th>번호</th>
          <th>영화 제목</th>
          <th>작성자 ID</th>
          <th>리뷰 내용</th>
          <th>작성일</th>
          <th>평점</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="review" items="${reviewList}">
          <tr>
            <td><input type="checkbox" name="reviewIds" value="${review.reviewId}"></td>
            <td>${review.reviewId}</td>
            <td>${review.movieId}</td>
            <td>${review.userId}</td>
            <td>${review.content}</td>
            <td>${review.writeDate}</td>
            <td>${review.rating}</td>
          </tr>
        </c:forEach>

        <c:if test="${empty reviewList}">
          <tr>
            <td colspan="7" class="no-result">검색 결과가 없습니다.</td>
          </tr>
        </c:if>
      </tbody>
    </table>
    <button type="submit" style="float: right" onclick="return confirm('선택한 리뷰를 삭제하시겠습니까?')">삭제</button>
  </form>
</div>

<%@ include file="/common/jsp/footer.jsp" %>

</body>
</html>
