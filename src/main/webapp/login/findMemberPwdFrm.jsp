<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 비밀번호 찾기</title>
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

#email-error{
	display: flex;
	justify-content: center;
	font-size: 12px;
	color: red;
	width: 480px;
}
 
</style>
<!-- <link rel="stylesheet" href="http://localhost/movie_prj/login/css/findMemberPwdFrm.css"> 왜 안되냐-->
<script type="text/javascript">
//전역 변수로 타이머 인터벌 선언
let timerInterval;

$(function(){
	
	//인증번호검증 input 숨김
	$("#confirmDiv").hide();
	
	//이메일검증
	function validateEmail(email) {
		const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
		return regex.test(email);
	}

	/* 인증번호 받기 버튼 눌렀을 때 */
	$("#getCodeEmail").on("click", function(){
		const email = $("input[name='email']").val().trim();
		//잘못된 이메일 주소일 때 -> 오류표시
		if(!validateEmail(email)){
			$(".pw_field_row.wrongEmail").css("display", "block");
			return;
		}
		//옳바른 이메일 주소일 때 -> 작업진행
		let userId = $("#userId").val();
		let birth = $("#birth").val();
		
		$("#confirmNumberBtn").prop("disabled", false); //인증확인 버튼 재활성화 
		
		//1. 아이디,생일,이메일로 가입되어있는 멤버인지 확인
		$.ajax({
			url:"${pageContext.request.contextPath}/login/controller/getMemVerificationCode.jsp",
			type:"POST",
			data:{
				userId : userId,
				birth : birth,
				email : email
			},
			success:function(result){
				if(result.trim() === "haveUserdata"){
					//입력칸잠금(혹시 수정하면 오류 발생할거같아)
					$("#userId").prop("readonly", true);
					$("#birth").prop("readonly", true);
					$("#email").prop("readonly", true);

				  //2. 멤버로 확인된 후, 인증코드를 이메일 보내는 작업 호출
					sendVerificationCode(email);
					
				  //3. 메일 보냈다는 메시지 출력
				  $("#email-sent-success").show();
				  
				  //4. 인증번호 기입 input 출력
				  $("#confirmDiv").show();
				  
				  //5.타이머 시작
				  startTimer(300, $("#timer")); // join1의 방식으로 변경
				  
					//6. 인증번호 보내기 버튼 일시적 정지 (join1과 동일하게 추가)
	        $(this).prop('disabled', true);
	        setTimeout(() => {
	            $(this).prop('disabled', false);
	        }, 60000); // 60초 후에 재전송 가능
			
				} else if (result.trim() === "noUserdata"){
					alert("등록되지 않은 회원입니다. 개인정보를 다시 한번확인해주세요.");
					return;
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
	
	$("input[name='email']").on("input", function(){
		$(".pw_field_row.wrongEmail").css("display", "none");
	});
	
	/* 이메일로 인증코드 보내고, DB업데이트 작업 */  
	function sendVerificationCode(email){
		$.ajax({
			url:"${pageContext.request.contextPath}/login/controller/sendVerificationCode.jsp",
			type:"POST",
			data:{
				email : email,
				action : "findPwd"
			},
			dataType : "text",
			success:function(result){
				if(result.trim() === "success"){
					alert("인증번호 생성, DB 입력 성공");
					
				} else if(result.trim() === "fail") {
					alert("인증번호 생성, DB 입력 실패");
				}
			},
			error:function(xhr, status, error){
				console.error("에러 발생!");
    	  console.log("status: ", status);
    	  console.log("error: ", error);
    	  console.log("xhr.status: ", xhr.status);
    	  console.log("xhr.responseText: ", xhr.responseText);
			}
			
		});
	}
	
	//인증번호 확인버튼 
	$("#confirmNumberBtn").on("click", function(){
		let code = $("#verificationNumb").val();
		
		if(code.length === 6 ){
			$.ajax({
				url : "${pageContext.request.contextPath}/login/controller/checkVerificationCode.jsp",
				type : "POST",
				dataType : "JSON",
				data : {
					code : code
				},
				success : function(response){
	     		console.log("response.result:", response.result);
	     		if(response.result == "success"){
	     			//확인되었으니, 모든 버튼 비활성화
	     			$("#verification-error").hide(); //인증비매치 에러 메시지 숨김 
	          $("#verify-success-msg").show(); //인증이 확인되었습니다. 표시 
	          $("#getCodeEmail").css("background-color", "#BDBDBD");//인증번호 받기 버튼 색 변경
	          $("#getCodeEmail").prop("disabled", true);//인증번호 받기 버튼 비활성화
						$("#confirmNumberBtn").css("background-color", "#BDBDBD");//인증확인 버튼 색 변경
	          $("#confirmNumberBtn").prop("disabled", true); //인증확인 버튼 비활성화
						$("#findPwdBtn").css("background-color", "#f14d4d");//비밀번호 찾기 버튼 색 변경
	          $("#findPwdBtn").prop("disabled", false); //비밀번호 찾기 버튼 활성화
	          
	          // 타이머 중지
	          clearInterval(timerInterval);
	          
	     		}
	     		if(response.result === "fail"){
	     			$("#verification-error").css("display", "block");
	     		}
       	},
				error : function(xhr, status, error){
					console.log("AJAX 요청 실패");
     	    console.log("status: " + status);
     	    console.log("error: " + error);
     	    console.log("responseText: " + xhr.responseText);
				}
				
			}); //end ajax
			
		}//end if
		
	})//인증번호 확인버튼 끝
	
		
});//ready


//비밀번호 DB 난수로 수정후에, Email보내기 함수  
/* ajax안씀  */
/* function sendTempPwd(){
	let userId = $("#userId").val();
	let birth = $("#birth").val();
	let email = $("#email").val();
	let verifiedCode = $("#verifiedCode").val();
	
	$.ajax({
		url : "${pageContext.request.contextPath}/login/controller/findMemPwd.jsp",
		type :"POST",
		data : {
			userId : userId,
			birth : birth,
			email : email,
			verifiedCode : verifiedCode,
			action : "sendTempPwd"
		},
		success : function(){
		},
		error : function(xhr, status, error){
			onsole.error("에러 발생!");
   	  console.log("status: ", status);                			// 요청 상태 (예: "error")
   	  console.log("error: ", error);                  			// 예외 메시지 (예: "Internal Server Error")
   	  console.log("xhr.status: ", xhr.status);        			// HTTP 상태 코드 (예: 500, 404)
   	  console.log("xhr.responseText: ", xhr.responseText);  // 서버가 보낸 에러 메시지 (HTML, JSON 등)
		}
		
	}); 
	
	
}
*/

/* join1의 타이머 함수를 참고한 수정된 타이머 함수 */
function startTimer(duration, display) {
    let timer = duration;
    let minutes, seconds;
    
    // 기존 타이머가 있다면 정리
    clearInterval(timerInterval);
    
    timerInterval = setInterval(function() {
        minutes = parseInt(timer / 60, 10);
        seconds = parseInt(timer % 60, 10);
        
        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;
        
        display.text(minutes + ":" + seconds);
        
        if (--timer < 0) {
            clearInterval(timerInterval);
            display.text("00:00");
            $("#verification-error").show();
            $("#verification-error").text("인증 시간이 만료되었습니다. 다시 시도해주세요.");
            
            // 5분 지났으므로 세션의 인증코드 번호 삭제 
            $.ajax({
                url : "${pageContext.request.contextPath}/login/controller/deleteSessionVerificationCode.jsp",
                type : "POST"
            });
            
            // 버튼들 비활성화
            $("#confirmNumberBtn").prop("disabled", true);
        }
    }, 1000);
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
      <div class="pw_title">회원 비밀번호 찾기</div>
      <div class="pw_subtitle">
        회원 가입 시 입력한 개인정보 입력 후, [인증번호 받기]를 통해 이메일로 전송 받으신 인증번호를 입력해주세요.
      </div>

      <div class="pw_panel">
        <div class="pw_panel_header">개인정보입력</div>

        <form action="${pageContext.request.contextPath }/login/controller/findMemPwd.jsp" method="post" name="frm" id="frm">
          <div class="pw_panel_body">
            <div class="pw_border_line">
              <div style="margin-bottom: 15px;">모든 항목이 필수 입력사항입니다.</div>

              <div class="pw_field_row">
                <div class="pw_field_name">아이디</div>
                <div>
                  <input type="text" class="pw_field_input" id="userId" name="userId" value="${param.userId}" >
                </div>
              </div>

              <div class="pw_field_row">
                <div class="pw_field_name">법정생년월일<br>(8자리)</div>
                <div>
                  <input type="text" class="pw_field_input" id="birth" name="birth" required maxlength="8" placeholder="예: 20001225">
                </div>
              </div>

              <div class="pw_field_row">
							  <div class="pw_field_name">이메일주소</div>
							  
							  <!-- column : flex-direction: column으로 바꿔서 위→아래로 쌓이게 함 -->
							  <div style="display: flex; flex-direction: column; align-items: flex-start;">
							    <div style="display: flex; align-items: center; gap: 10px;">
							      <input type="email" class="pw_field_input" id="email" name="email" style="width: 200px;" required>
							      <button class="pw_verify_btn" type="button" id="getCodeEmail">인증번호받기</button>
							    </div>
							    <div id="email-sent-success" style="color: #f14d4d; font-size: 13px; margin-top: 5px; display: none;">
							      입력하신 이메일로 인증번호가 발송되었습니다.
							    </div>
							
							  </div>
							</div>
              
              <div id="confirmDiv" class="pw_field_row">
                <div class="pw_field_name">인증번호<br>(6자리)</div>
                
                <div>
                  <input style="width: 200px;" type="password" id="verificationNumb" class="pw_field_input" name="verifiedCode" maxlength="6" oninput="this.value = this.value.replace(/[^0-9]/g, '');"  required>
                 	<button class="pw_verify_btn" type="button" id="confirmNumberBtn">확인</button>
               	  <span id="timer" style="margin-left: 10px; font-size: 13px; color: #f14d4d;">5:00</span>
               	  <div id="verification-error" style="color: #f14d4d; font-size: 13px; margin-top: 5px; display: none;">
               	  	인증번호가 일치하지 않습니다.
               	  </div>
                 	<div id="verify-success-msg" style="color: #2ecc71; font-size: 13px; margin-top: 5px; display: none;">
							      이메일 인증이 완료되었습니다.
							    </div>
                </div>
                
              </div>
              
            </div>

            <div class="pw_btn_group">
              <button style="background-color: white; border: 1px solid #ddd; padding: 10px 20px;" type="reset">
                개인정보 다시입력
              </button>
              <input type="hidden" name="action" value="sendTempPwd" > <!-- form목적  -->
              <button style="background-color: #BDBDBD" id="findPwdBtn" class="pw_btn_red" type="submit" disabled>비밀번호 찾기</button>
            </div>
          </div>
        </form>
      </div>

      <div class="pw_info_box">
        <div class="pw_info_item">
          <div class="pw_info_label">이용안내</div>
          <div class="pw_info_content">
            <div>yeonflix 고객센터 : 1544-1122</div>
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