<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="kr.co.yeonflix.inquiry.inquiryDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
		int userIdx = loginUser.getUserIdx();
		inquiryDAO iDAO = new inquiryDAO();
		String type= request.getParameter("type");
		String title= request.getParameter("title");
		String content= request.getParameter("content");
		iDAO.insertinquiry(type, title, content,userIdx);
	%>


  <div class="container">
    <h2>작성하신 이메일 문의가 정상적으로 접수 완료 되었습니다</h2>
    <p>문의하신 내용은 MY CGV &gt; 나의 문의내역 &gt; 1:1문의에서 확인하실 수 있습니다</p>
    <div class="info-box">
      접수일시 ----년--월--일
    </div>
    <input type="button" id="list" value="문의내역 확인"/>
    <input type="button" id="main" value="고객센터 메인"/>
  </div>
 
 
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){
    $("#list").click(function(){
        location.href="http://localhost/movie_prj/inquiry/inquiry_user_main.jsp";
    });
    $("#main").click(function(){
    	location.href="";
    });
});
</script>
</body>
</html>