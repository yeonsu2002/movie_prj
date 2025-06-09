<%@page import="java.time.LocalDate"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="kr.co.yeonflix.inquiry.inquiryDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/common/jsp/external_file.jsp" />
<jsp:include page="/common/jsp/header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
  body {
    margin: 0;
    padding: 0;
    font-family: 'Noto Sans KR', sans-serif;
    background-color: #f4f4f4;
    color: #333;
    font-size: 18px; /* 전체 폰트 약간 키움 */
  }

  .container {
    max-width: 720px; /* 600px → 720px */
    margin: 100px auto;
    padding: 50px; /* 40px → 50px */
    background-color: #fff;
    border-radius: 14px;
    box-shadow: 0 6px 24px rgba(0, 0, 0, 0.1);
    text-align: center;
  }

  .container h2 {
    margin-bottom: 24px;
    font-size: 26px; /* 22px → 26px */
    color: #e50914;
  }

  .container p {
    font-size: 19px; /* 16px → 19px */
    margin-bottom: 36px;
  }

  .info-box {
    margin-bottom: 36px;
    font-size: 18px; /* 15px → 18px */
    font-weight: bold;
    background: #f9f9f9;
    padding: 16px; /* 여백 증가 */
    border-radius: 10px;
    border: 1px solid #ddd;
  }

  input[type="button"] {
    margin: 12px 10px;
    padding: 14px 28px; /* 크기 증가 */
    border: none;
    border-radius: 10px;
    font-weight: bold;
    cursor: pointer;
    font-size: 18px; /* 15px → 18px */
    background-color: #e50914;
    color: white;
    transition: background-color 0.3s ease;
  }

  input[type="button"]:hover {
    background-color: #c40812;
  }
</style>

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
		
		 LocalDate today = LocalDate.now();
		 int year = today.getYear();
		 int month = today.getMonthValue();
		 int day = today.getDayOfMonth();
	%>


  <div class="container">
    <h2>작성하신 이메일 문의가 정상적으로 접수 완료 되었습니다</h2>
    <p>문의하신 내용은 &gt; 나의 문의내역 &gt; 1:1문의에서 확인하실 수 있습니다</p>
    <div class="info-box">
      접수일시 <%=year %>년 <%=month %>월 <%=day %>일
    </div>
    <input type="button" id="list" value="문의내역 확인"/>
    <input type="button" id="main" value="고객센터 메인"/>
  </div>
 
	<footer>
<jsp:include page="/common/jsp/footer.jsp"/>
	</footer>
 
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){
    $("#list").click(function(){
        location.href="http://localhost/movie_prj/inquiry/inquiry_user_main.jsp";
    });
    $("#main").click(function(){
    	location.href="http://localhost/movie_prj/customer_service/customer_service_center.jsp";
    });
});
</script>
</body>
</html>