<%@page import="java.util.Random"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가입정보 조회</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
<style>
#container{ min-height: 650px; margin-top: 30px; margin-left: 20px}

body {
  font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
  margin: 0;
 
}

hr {
  border: 0;
  border-top: 1px solid #ddd;
  margin: 20px 0;
}

.container {
  max-width: 860px;
  margin: 0 auto;
  background-color: #f8f8f8;
  padding: 10px 0;
}

.join-header {
  font-size: 22px;
  font-weight: bold;
  margin-bottom: 20px;
}

.notice-section {
  display: flex;
  margin-bottom: 30px;
  flex-direction: row;
  align-items: flex-end;
}

.notice-content {
  flex: 1;
  padding-right: 20px;
}

.notice-content p {
  margin: 0 0 12px 0;
  line-height: 1.5;
  color: #333;
  font-size: 14px;
}

.notice-content ul {
  list-style-type: none;
  padding-left: 0;
  margin: 0;
}

.notice-content li {
  margin-bottom: 12px;
  position: relative;
  padding-left: 12px;
  color: #555;
  font-size: 13px;
  line-height: 1.5;
}

.notice-content li:before {
  content: "•";
  position: absolute;
  left: 0;
  color: #888;
}

.form-section {
  flex: 1;
}

.input-field {
  width: 100%;
  height: 40px;
  border: 1px solid #ddd;
  padding: 0 10px;
  margin-bottom: 10px;
  font-size: 14px;
  box-sizing: border-box;
}

.submit-btn {
  width: 100%;
  height: 50px;
  background-color: #333;
  color: white;
  border: none;
  font-size: 15px;
  font-weight: bold;
  cursor: pointer;
  margin-top: 5px;
}

.brand-logos {
  display: grid;
  gap: 10px;
  padding: 20px 0;
}

</style>
<script type="text/javascript">
$(function(){
	//가입여부확인 버튼 클릭 후, 기존회원이면 ??, 비회원이면 회원가입 페이지로 이동
	$(".submit-btn").on("click", function(){
 		//checkMyJoinSatatus(); ajax로 처리해서 페이지 이동시켜도 되고..
 		
 		let birth = $("input[name='birth']").val().trim();
 		if(!/^\d{8}$/.test(birth)) {
 			alert("생년월일은 8자리로 입력해주세요.");
 			return;
 		}
 		
 		$("#joinChkFrm").submit();
 		
	});
	
});
</script>
</head>
<body>
<header>
<jsp:include page="/common/jsp/header.jsp" />
</header>
<main>
	<div class="container">
	
				<div class="notice-section">
					<div class="notice-content">
						<h2 class="join-header">회원가입 여부 안내</h2>
	
						<ul>
							<li>기존 회원가입 정보와 일치하는 정보를 입력하셔야 회원가입 여부를 정확하게 확인하실 수 있습니다. <span
								class="orange">정확하신 정보로 회원가입 여부확인 사용하여 거쳐야라 주세요.</span></li>
							<li>롯데시넷, CJ티켓, CJ온스토팅, CJ트렌샵몰 예서는 견각상거래에 의거하여 만 14세 미만의
								어린이/학생의 회원가입은 제한됩니다.</li>
						</ul>
					</div>
	
					<div class="form-section">
						<form action="${pageContext.request.contextPath}/login/controller/joinChk.jsp" method="post" id="joinChkFrm">
							<input type="text" name="name" class="input-field" placeholder="이름을 입력해주세요." required>
							<input type="text" name="birth" class="input-field" placeholder="법정생년월일 8자리를 입력해주세요." maxlength="8" required oninput="this.value = this.value.replace(/[^0-9]/g, '')">
							<input type="email" name="email" class="input-field" placeholder="이메일을 입력해주세요." required> 
							<button type="button" class="submit-btn">가입여부 확인</button>
						</form>
					</div>
				</div>
	
				<div class="brand-logos">
					<img src="${pageContext.request.contextPath }/common/img/brandLogos.png" style="margin: 0px auto;">
		</div>
	</div>
</main>
<footer>
<c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
</footer>
</body>
</html>