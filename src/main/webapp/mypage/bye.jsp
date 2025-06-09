<%@page import="java.sql.SQLException"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

    if (loginUser != null) {
        MemberService ms = new MemberService();
        boolean result = ms.modifyIsActive(loginUser.getUserIdx(), "N");

        // 세션 종료 (로그아웃)
        session.invalidate();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>탈퇴</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
<style>
 #container{ min-height: 650px; margin-top: 30px; margin-left: 20px}
  .title{

	font-size: 50px;
	margin: 20px auto;
	}
 
 
 .container {
    max-width: 800px;
    margin:20px auto;
    background-color: #fff;
    border: 1px solid #ddd;
    border-radius: 5px;
    padding: 20px;
}
 

.delete-form {
    width: 120px;
    background-color: #f8f9fa;
    padding: 12px 15px;
    text-align: left;
    border: 1px solid #ddd;
    font-weight: normal;
    font-size: 14px;
}

.delete-form {
    padding: 8px 15px;
    border: 1px solid #ddd;
}

.card-title{
		font-size:20px;
		padding: 15px 15px;
	}
.card-sec{
		font-size:13px;
		padding: 35px 12px;
}
 
 


</style>
<script type="text/javascript">
</script>
</head>
<body>
<header>
<jsp:include page="/common/jsp/header.jsp" />
</header>
<main>
<div id="container">
	
    <div class="card text-center">
    
  <div class="card-body">
    <img src="http://localhost/movie_prj/common/img/byebye.jpg"/>
    <h5 class="card-title">안녕히 가세요</h5>
  
    <a href="http://localhost/movie_prj/index.jsp" type="button" class="btn btn-danger" style="width: 100px">메인화면</a>
    
    
  </div>
</div>

</div>


</main>
<footer>
<c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
</footer>
</body>
</html>