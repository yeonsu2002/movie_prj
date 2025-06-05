<%@page import="java.util.Random"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="headerTop">
	<h1 class="logo"><a href="http://localhost/movie_prj/index.jsp"><img src="http://localhost/movie_prj/common/img/logo.png" alt=""></a></h1>
 	<div class="member">
		<ul class=login_menu>
			<!-- c:url 이랑 imgs src랑 다르다. 가져오는 주소가 다름에 주의!!! -->  
			<c:choose>
  	    <c:when test="${not empty loginUser}">
  	    <li><img alt="한글사진x" src="http:/profile/${loginUser.picture}" style="width: 70px; height: 70px; border-radius: 5em;"> </li>
  	    <li style="display: flex; align-items: center; justify-content: center;">[<c:out value="${sessionScope.loginUser.nickName }" />]님 방문을 환영합니다.</li>
        <li><a href="http://localhost/movie_prj/login/controller/logout.jsp"><img src="http://localhost/movie_prj/common/img/loginPassword.png" alt="">로그아웃</a></li>
        </c:when>
        <c:otherwise>
      	<li><a href="http://localhost/movie_prj/login/loginFrm.jsp"><img src="http://localhost/movie_prj/common/img/loginPassword.png" alt="">로그인</a></li>
      	<li><a href="${pageContext.request.contextPath }/login/isMemberChk.jsp"><img src="http://localhost/movie_prj/common/img/loginJoin.png" alt="">회원가입</a></li>
        </c:otherwise>
      </c:choose>
		<li><a href="http://localhost/movie_prj/mypage/MainPage.jsp"><img src="http://localhost/movie_prj/common/img/loginMember.png" alt="">마이페이지</a></li>
		<li><a href="http://localhost/movie_prj/customer_service/customer_service_center.jsp"><img src="http://localhost/movie_prj/common/img/loginCustomer.png" alt="">고객센터</a></li>
		</ul>
	 </div>
</div>
<nav>
<div class="nav_wrap">
	<ul class="nav_menu">
		<li><a href="http://localhost/movie_prj/movie_chart/main_chart.jsp">영화</a></li>
		<li><a href="http://localhost/movie_prj/theater/theater_main.jsp">극장</a></li>
		<li><a href="http://localhost/movie_prj/reservation/reservation.jsp"><strong>예매</strong></a></li>
	</ul>

	<div class="search_wrap">
	<form action="" name="searchtxt" id="searchtxt">
		<fieldset>
		<label for="text_search" class="xx">입력창</label> 
		<input type="text" id="text_search">
		<button class="fixedbtn_search">검색</button>
		</fieldset>
	</form>
 	</div>
</div>
</nav>  
