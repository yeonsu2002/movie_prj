<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/common/jsp/external_file.jsp" />
<jsp:include page="/common/jsp/header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 작성</title>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 작성</title>
<link rel="stylesheet" href="http://localhost/movie_prj/inquiry/css/add.css">
</head>
<body>
<%
	MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
	if (loginUser == null) {
		response.sendRedirect("http://localhost/movie_prj/login/loginFrm.jsp");//로그인 안되있으면 로그인 사이트로
		return;
	}
	%>
<div class="inquiry-wrapper">
<form action="inquiry_accept.jsp" id="inquiry_add">
<table>
  <tr class="radio-group">
    <td><strong>문의 유형</strong></td>
    <td><label><input type="radio" name="type" value="문의" />문의</label></td>
    <td><label><input type="radio" name="type" value="불만" />불만</label></td>
    <td><label><input type="radio" name="type" value="칭찬" />칭찬</label></td>
    <td><label><input type="radio" name="type" value="제안" />제안</label></td>
    <td><label><input type="radio" name="type" value="분실물" />분실물</label></td>
  </tr>
  <tr>
    <td><strong>제목</strong></td>
    <td colspan="4"><input type="text" id="title" name="title" /></td>
  </tr>
  <tr style="height: 100%;">
    <td><strong>내용</strong></td>
    <td colspan="4"><textarea id="content" name="content" placeholder="내용을 입력하세요"></textarea></td>
  </tr>
  <tr>
    <td></td>
    <td colspan="4">
      <input type="button" id="list" value="취소" />
      <input type="button" id="add" value="등록하기" />
    </td>
  </tr>
</table>
</form>
</div>


<footer>
<jsp:include page="/common/jsp/footer.jsp"/>
</footer>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){
    $("#add").click(function(){
    	  const type = $("input[name='type']:checked").val();
          const title = $("#title").val().trim();
          const content = $("#content").val().trim();

          if(!type) {
              alert("문의 유형을 선택해주세요.");
              return;
          }
          if(title === "") {
              alert("제목을 입력해주세요.");
              return;
          }
          if(content === "") {
              alert("내용을 입력해주세요.");
              return;
          }

          $("#inquiry_add").submit();
    });
    $("#list").click(function(){
    	location.href="http://localhost/movie_prj/inquiry/inquiry_user_main.jsp";
    });
});
</script>
</body>
</html>
