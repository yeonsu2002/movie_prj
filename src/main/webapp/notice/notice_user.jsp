<%@page import="kr.co.yeonflix.notice.noticeDTO"%>
<%@page import="kr.co.yeonflix.notice.noticeDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/common/jsp/external_file.jsp"/>
<jsp:include page="/common/jsp/header.jsp"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지/뉴스 등록</title>

<link rel="stylesheet" href="http://localhost/movie_prj/notice/css/user.css">
</head>
<body>
<c:import url="http://localhost/movie_prj/customer_service/side_menu.jsp" />
	<%
	noticeDAO dao = new noticeDAO();
	noticeDTO nDTO= dao.selectNotice(request.getParameter("idx"));
	dao.addcount(request.getParameter("idx"));
	request.setAttribute("nDTO", nDTO);
	%>
<div class="notice-view-container">
  <h2>공지/뉴스</h2>
  <div class="description">주요한 이슈 및 여러가지 소식들을 확인하실 수 있습니다</div>

  <strong>유형</strong>
  <label>${nDTO.board_code_name}</label><br>

  <form>
    <strong>제목</strong>
    <label>${nDTO.notice_title}</label><br>

    <textarea id="content" placeholder="내용을 입력하세요" readonly="readonly">${nDTO.notice_content}</textarea>

    <div class="btn-area">
      <input type="button" id="list" value="목록으로" />
    </div>
  </form>
</div>

<footer>
<jsp:include page="/common/jsp/footer.jsp"/>
</footer>


	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		$(function() {
			$("#list").click(
					function() {
						location.href = "http://localhost/movie_prj/notice/notice_user_main.jsp";
					});
		});
	</script>


</body>
</html>



