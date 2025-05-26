<%@ page language="java" contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지/뉴스</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp" />
<style><style>
/* 전체 notice 영역 */
.notice-container {
    position: absolute;
    top: 80px;
    left: 240px;
    right: 0;
    bottom: 0;
    padding: 30px 40px;
    background: #f4f6f9;
    border-radius: 12px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    color: #333;
    box-shadow: 0 6px 18px rgba(0, 0, 0, 0.08);
    display: flex;
    flex-direction: column;
    overflow: auto;
}

/* 제목 및 설명 */
.notice-container h2 {
    font-size: 1.8rem;
    font-weight: 700;
    margin-bottom: 10px;
    color: #222;
}

.notice-container .description {
    font-size: 0.95rem;
    color: #666;
    margin-bottom: 20px;
}

/* 검색 폼 */
.notice-container .notice-form {
    display: flex;
    max-width: 400px;
    margin-bottom: 24px;
}

.notice-container .notice-form input[type="search"] {
    flex: 1;
    padding: 10px 14px;
    font-size: 1rem;
    border: 1.5px solid #ccc;
    border-radius: 8px 0 0 8px;
    transition: border-color 0.3s ease;
}

.notice-container .notice-form input[type="search"]:focus {
    outline: none;
    border-color: #4a90e2;
    box-shadow: 0 0 6px rgba(74, 144, 226, 0.4);
}

.notice-container .notice-form button[type="submit"] {
    padding: 10px 18px;
    font-size: 1rem;
    border: none;
    border-radius: 0 8px 8px 0;
    background-color: #4a90e2;
    color: white;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.notice-container .notice-form button[type="submit"]:hover {
    background-color: #357abd;
}

/* 필터 탭 */
.notice-container .filter-tabs {
    display: flex;
    gap: 10px;
    justify-content: flex-start;
    margin-bottom: 20px;
}

.notice-container .filter-tabs div {
    padding: 8px 16px;
    background-color: rgba(74, 144, 226, 0.1);
    border-radius: 8px;
    color: #4a90e2;
    font-weight: 600;
    cursor: pointer;
    transition: background-color 0.2s ease;
}

.notice-container .filter-tabs div:hover {
    background-color: rgba(74, 144, 226, 0.2);
    text-decoration: underline;
}

/* 공지 테이블 */
.notice-container .notice-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
    font-size: 0.95rem;
    background-color: white;
    border: 1px solid #ddd;
}

.notice-container .notice-table thead {
    background-color: #4a90e2;
    color: white;
}

.notice-container .notice-table th,
.notice-container .notice-table td {
    padding: 12px 10px;
    text-align: center;
    border: 1px solid #ddd;
}

.notice-container .notice-table tbody tr:hover {
    background-color: #f1f6ff;
}

/* 페이지네이션 */
.notice-container .page-buttons {
    display: flex;
    justify-content: center;
    gap: 10px;
    margin-top: 10px;
}

.notice-container .page-buttons input[type="button"] {
    min-width: 36px;
    padding: 6px 12px;
    font-size: 0.95rem;
    border-radius: 8px;
    border: 1px solid #4a90e2;
    background-color: white;
    color: #4a90e2;
    cursor: pointer;
    transition: background-color 0.2s ease, color 0.2s ease;
}

.notice-container .page-buttons input[type="button"]:hover {
    background-color: #4a90e2;
    color: white;
}

.notice-container .page-buttons .nav-btn {
    font-weight: bold;
}
</style>

</style>


</head>
<body>

<header>
<c:import url="http://localhost/movie_prj/common/jsp/header.jsp"/>
</header>
<div class="notice-container">
	
    <h2>공지/뉴스</h2>
    <div class="description">주요한 이슈 및 여러가지 소식들을 확인하실 수 있습니다</div>

<form method="get" action="#" role="search" class="notice-form">

        <input type="search" id="user-search" placeholder="검색어를 입력하세요">
        <button type="submit">검색</button>
    </form>

    <div class="filter-tabs">
        <div>전체</div>
        <div>타입1</div>
        <div>타입2</div>
        <div>타입3</div>
    </div>

    <table class="notice-table">
        <thead>
            <tr>
                <th>번호</th>
                <th>구분</th>
                <th>제목</th>
                <th>등록일</th>
                <th>조회수</th>
            </tr>
        </thead>
        <tbody>
        <% for(int i=0; i<5; i++) { %>
            <tr>
                <td>번호</td>
                <td>구분</td>
                <td><a href="http://localhost/movie_prj/admin/notice/notice_user.jsp">제목</a></td>
                <td>등록일</td>
                <td>조회수</td>
            </tr>
        <% } %>
        </tbody>
    </table>

    <div class="page-buttons">
        <input type="button" class="nav-btn" value="«" />
        <% for(int i=1; i<=5; i++) { %>
            <input type="button" id="pageNum" value="<%=i%>" />
        <% } %>
        <input type="button" class="nav-btn" value="»" />
    </div>
    
</div>


<footer>
<c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){
});
</script>
</body>
</html>
