<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비회원 비밀번호 찾기</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
<style>
 #container{ min-height: 650px; margin-top: 30px; margin-left: 20px}
 
.pw-container {
    max-width: 950px;
    margin: 0 auto;
    padding: 20px;
} 
.pw_btn_red {
    background-color: #f14d4d;
    color: white;
    border: none;
    padding: 10px 20px;
    font-size: 14px;
    cursor: pointer;
    border-radius: 3px;
}
.pw_title {
    margin-bottom: 10px;
    font-size: 16px;
    font-weight: bold;
}
.pw_subtitle {
    color: #666;
    font-size: 14px;
    margin-bottom: 20px;
}
.pw_panel {
    background-color: #f9f9f9;
    padding: 20px;
    margin-bottom: 20px;
    border-radius: 3px;
}
.pw_panel_header {
    background-color: #eee;
    padding: 12px 20px;
    margin: -20px -20px 20px -20px;
    font-weight: bold;
}
.pw_panel_body {
    padding: 20px;
    background-color: white;
    border-radius: 3px;
}
.pw_field_row {
    margin-bottom: 20px;
    display: flex;
    align-items: center;
}
.pw_field_row:last-child {
    margin-bottom: 0;
}
.pw_field_name {
    width: 150px;
    font-size: 14px;
}
.pw_field_input {
    padding: 8px;
    border: 1px solid #ddd;
    width: 300px;
}
.pw_btn_group {
    display: flex;
    justify-content: center;
    margin-top: 20px;
    gap: 10px;
}
.pw_border_line {
    border-bottom: 1px solid #ddd;
    padding-bottom: 20px;
}
.pw_info_box {
    background-color: #f7f5e9;
    padding: 20px;
    font-size: 14px;
    margin-top: 30px;
}
.pw_info_item {
    display: flex;
    margin-bottom: 10px;
}
.pw_info_label {
    width: 100px;
    font-weight: bold;
}
.pw_info_content {
    flex: 1;
}
.pw_verify_btn {
    display: inline-block;
    padding: 6px 10px;
    background-color: #f14d4d;
    color: white;
    border: none;
    cursor: pointer;
    margin-left: 10px;
    border-radius: 3px;
}

.pw_border_line input{
	width: 220px;
}
</style>
<script type="text/javascript">
	let timerInterval; // 타이머 인터벌 변수 추가

	
$(function(){
	$(".pw_btn_red").on("click", function(){
		
	});
	
	//생년월일 입력 실시간 필터링
	$("#birth").on("input", function(){
		this.value = this.value.replace(/[^0-9]/g, "");
	});
	
	//인증번호 받기 버튼 클릭시 
	$("#authCodeBtn").on("click", function(){
		if(!emailCheck()){
			return;
		}
		//emailCheck(); //이메일양식 검증 함수 
		const email = $("#email").val();
		
	 	$.ajax({
			url : "${pageContext.request.contextPath}/login/controller/sendVerificationCode.jsp",
			method: "post",
			data :{
				email : email,
				action : "findPwd"
			},
			success : function(result){
				if(result.trim() === "success"){
					alert("인증번호 생성, DB 입력 성공");
					//타이머 표시
					$("#verification-error").hide();//경고창 숨김
					$("#verification-timer").show();
			    startTimer(300, document.getElementById("verification-timer"));
			    
			    
				} else {
					alert("인증번호 생성, DB 입력 실패");
				}
			},
			error: function(xhr, status, error){
				console.error("에러 발생!");
    	  console.log("status: ", status);
    	  console.log("error: ", error);
    	  console.log("xhr.status: ", xhr.status);
    	  console.log("xhr.responseText: ", xhr.responseText);
			} 
		});
	 	
	 	
	});
	
});

//타이머 함수 
function startTimer(duration, display) {
	
  let timer = duration;
  let minutes; 
  let seconds;
	// 기존 타이머가 있다면 정리
  clearInterval(timerInterval);
    
  timerInterval = setInterval(function() {
    minutes = parseInt(timer / 60, 10);
    seconds = parseInt(timer % 60, 10);
    
    minutes = minutes < 10 ? "0" + minutes : minutes;
    seconds = seconds < 10 ? "0" + seconds : seconds;
    
    display.textContent = minutes + ":" + seconds;
    
    if (--timer < 0) {
      clearInterval(timerInterval);
      display.textContent = "00:00";
      
      // 에러 메시지 표시
      $("#verification-timer").hide();
      $("#verification-error").show();
      $("#verification-error").text("인증 시간이 만료되었습니다. 다시 시도해주세요.");
      
      
      // 5분 지났으므로 세션의 인증코드 번호 삭제 
      $.ajax({
        url : "${pageContext.request.contextPath}/login/controller/deleteSessionVerificationCode.jsp",
        type : "POST"
      });
      
      // 인증확인 버튼 비활성화
      $("#verify-code").prop("disabled", true);
    }
  }, 1000);
}

function emailCheck() {
  // 이메일 형식 검증
  const email = $("#email").val();
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    alert("올바른 이메일 형식을 입력해주세요.");
    return false;
  }
  return true;
}

</script>
</head>
<body>
<header>
<jsp:include page="/common/jsp/header.jsp" />
</header>
<main>
<div id="container">
	<div class="pw-container">
	 <div class="pw_title">비회원 비밀번호 찾기</div>
	 <div class="pw_subtitle">비회원 예매 시 입력한 개인정보 입력 후, [인증번호 받기]를 통해 이메일로 전송 받으신 인증번호를 입력해주세요.</div>
	 
	 <div class="pw_panel">
	     <div class="pw_panel_header">개인정보입력</div>
	     
	     <div class="pw_panel_body">
	         <div class="pw_border_line">
	             <div style="margin-bottom: 15px;">모든 항목이 필수 입력사항입니다.</div>
	             
	             <form action="">
		             <div class="pw_field_row">
		                 <div class="pw_field_name">법정생년월일(8자리)</div>
		                 <div>
		                 	<input type="text" id="birth" name="birth" maxlength="8" placeholder="예) 19900101" />
		                 </div>
		             </div>
						             
		             <div class="pw_field_row">
		                 <div class="pw_field_name">이메일주소</div>
		                 <div style="display: flex; align-items: center;">
		                     <input type="email" id="email" name="email" class="pw_field_input" required>
		                     <button type="button" id="authCodeBtn" class="pw_verify_btn">인증번호받기</button>
		                     <span style="display:none; color: #f14d4d; font-size: 13px; margin-left: 10px;" id="verification-timer">05:00</span>
		                     <span style="display:none; color: #f14d4d; font-size: 13px; margin-left: 10px;" id="verification-error"></span>
		                 </div>
		             </div>
		             
		             <div class="pw_field_row">
		                 <div class="pw_field_name">인증번호<br>(6자리)</div>
		                 <div>
		                     <input type="password" class="pw_field_input" maxlength="6">
		                 </div>
		             </div>
		         </div>
		         
		         <div class="pw_btn_group">
		             <button style="background-color: white; border: 1px solid #ddd; padding: 10px 20px;">개인정보 다시입력</button>
	<%-- 	         <button class="pw_btn_red" type="button" data-url="${pageContext.request.contextPath }/member?action=getFindPwdFrm">비밀번호 찾기</button> --%>	             
								 <button class="pw_btn_red" type="button" >비밀번호 찾기</button>
		         </div>
	             </form>
	             
	     </div>
	 </div>
	 
	 <div class="pw_info_box">
	     <div class="pw_info_item">
	         <div class="pw_info_label">이용안내</div>
	         <div class="pw_info_content">
	             <div>CGV 고객센터 : 1544-1122</div>
	             <div>상담 가능 시간 : 월-금 09:00~18:00 (이 외 시간은 자동 응답 안내 가능)</div>
	         </div>
	     </div>
	 </div>
	</div>

</div>
</main>
<footer>
<c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
</footer>
</body>
</html>