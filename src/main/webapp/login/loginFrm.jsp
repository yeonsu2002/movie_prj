<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="loginPage"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인페이지</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
<link rel="stylesheet" href="http://localhost/movie_prj/login/css/cgv_login.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<script type="text/javascript">
	let loginFrmHtml = null;
	let timerInterval; // 타이머 인터벌 변수 추가
	
$(function(){
		loginFrmHtml = $(".box-login.login_1408").html(); //DOM이 모두 준비된 후에 백업
		
		$("#form2_capcha").on("submit", function(event){
			event.preventDefault(); //폼 기본전송 x 
		});
		
		$("#memberLoginBtn").on("click", function(event){
			event.preventDefault();
			$(".box-login.login_1408").empty().html(loginFrmHtml); //저장해놨던 원래html불러옴
			$(".sect-loginad").show(); //광고창 오픈
			$(".box-login.login_1408").css("width", "");
		});
		
		$("#nonMemberLoginBtn").on("click", function(event){
			event.preventDefault();
			nonMemberLoginFrm();
			$(".sect-loginad").hide(); //광고창 오픈
			$(".box-login.login_1408").css({width:"900px", height:"auto", display:"flex", flexDirection: "column"});  //사이즈조절
			$(".personal-info-section").css({maxWidth:"800px", marginLeft:"10px"});// 정보동의서 사이즈조절 
		});
		
		$("#nonMemberCheckReservationBtn").on("click", function(event){
			event.preventDefault();
			nonMemberCheckReservationFrm();
			$("#content2").hide();//초기에는 header1만 보이게 
			getHeader12(); //헤더2개 동적html 함수
			checkNonMemberTicket() //비회원 예매확인 함수 
			$(".sect-loginad").hide(); //광고숨김
			$(".box-login.login_1408").css({width:"900px", height:"680px"});  //사이즈조절
		});
		
		$(document).on("click", ".guest-btn.guest-btn-primary", function(){
			//alert("입력하신 정보와 일치하는 예매내역이 없습니다.");
			//이게 이벤트위임이라서 .on 이벤트리스너같은 거 보다 메모리누수 위험이 없는데..
		});
		

		
		liClassChangeToOn(); //뭐였는지 까먹었지만 css관련 함수 
		
		refreshCaptcha(); //자동입력방지문자 갱신 함수 
		
		login(); //로그인 관련 모음 함수 
		
		nonMembrEmailInsert(); //비회원 이메일 select 반응함수 
		
		$("#nextBtn").prop("disabled", true); //비회원 예매하기 처음에 비활성화 
		
		$(document).on("click", "#nextBtn", function(){ //비회원 예매하기 버튼 눌렀을 때
			//비밀번호 4자리 검증
			let pw = $("#pw").val().trim();
			let pwConfirm = $("#pw_confirm").val().trim();
			if (pw.length !== 4) {
			  alert("비밀번호는 숫자 4자리로 입력해 주세요.");
			  $("#pw").focus();
			  return;
			}
			if (pw !== pwConfirm) {
			  alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
			  $("#pw_confirm").focus();
			  return;
			}
			if (!/^\d{4}$/.test(pw)) { //이거 좀더 알아봐야겠다.
			  alert("비밀번호는 숫자 4자리여야 합니다.");
			  return;
			}
			//정보제공 체크 검증 
			if($("input[name='agreement']:checked").val() != "agree"){
				alert("예매를 진행하시려면 개인정보 수집 및 이용에 동의해 주셔야 합니다.");
				return;
			}
			//자 이제 예매하러 가볼까. 일단 비회원 정보 세션처리먼저 ㄱㄱ
			$("#nonMemRevFrm").submit();
			
			
		});
		
});//-------------------------------------------------------------ready--------------------

//비회원예매확인 (비회원예매확인 버튼 / 비회원 예매 비밀번호 찾기 버튼)
function getHeader12(){
	//상단의 비회원 예매확인 버튼 클릭시
	$("#header1").on("click", function(){
		$("#header1").css("backgroundColor", "#f2f2f2");
		$("#header2").css("backgroundColor", "#fff");
		$("#content1").show();
		$("#content2").hide();
	});
	//상단의 비회원 예매 비밀번호 찾기 버튼 클릭시
	$("#header2").on("click", function(){
		$("#header2").css("backgroundColor", "#f2f2f2");
		$("#header1").css("backgroundColor", "#fff");
		$("#content2").show();
		$("#content1").hide();
	});
}


function nonMembrEmailInsert(){
	$(document).on("change", "#emailDomain", function(){
		const selected = $(this).val();
		$("#emailDomainInput").val("");
		$("#emailDomainInput").val(selected);
		$("#emailDomainInput").prop("readonly", true);
		
		if(selected === "custom"){//직접입력
			$("#emailDomainInput").val("");
			$("#emailDomainInput").prop("readonly", false);
		}
	});
}

function getVerification(){
  // 이메일 validation 추가
  const emailId = $("#emailId").val().trim();
  const emailDomain = $("#emailDomainInput").val().trim();
  
  if(!emailId || !emailDomain) {
	  alert("이메일을 올바르게 입력해주세요.");
	  return;
  }
	//이메일 형식 검증
  const email = emailId + "@" + emailDomain;
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if(!emailRegex.test(email)) {
    alert("올바른 이메일 형식을 입력해주세요.");
    return;
  }
  
	console.log("email: " + email);
	// 1. 인증번호 이메일 전송 및 세션에 추가 ( = verificationCode)
	$.ajax({
 		url : "${pageContext.request.contextPath}/login/controller/sendVerificationCode.jsp",
		type : "POST",
		data : {
			email : email,
			action : "join"
		},
		success : function(result){
			if(result.trim() == "success"){
 				alert("이메일발송, 세션추가 성공");
 				
 			// 2. 인증번호 보내기 버튼 일시적 정지 
      $("#getVerificationBtn").prop("disabled", true);
      $("#getVerificationBtn").css("background-color", "#d6d6d6");
      setTimeout(() => {
        $("#getVerificationBtn").css("background-color", "");
        $("#getVerificationBtn").prop("disabled", false);
      }, 30000); // 30초 후에 재전송 가능 
      
      // 3. 타이머 표시 및 시작
      $("#verification-timer").show();
      startTimer(300, document.getElementById("verification-timer"));
 				
 			} else  if(result == "fail"){
 				alert("이메일발송, 세션추가 실패");
 			}
		},
		error : function(xhr, status, error){
			console.log("AJAX 요청 실패");
 	    console.log("status: " + status);
 	    console.log("error: " + error);
 	    console.log("responseText: " + xhr.responseText);
		}
	});
	
}// end  getVerification()


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
//확인버튼 눌렀을 때 
$(document).on('click', '#verify-code', function() {
  const code = $("#auth").val().trim();
  
  if(code.length !== 6) {
    alert("인증번호 6자리를 정확히 입력해주세요.");
    return;
  }
  
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
        // 에러 메시지 숨김
        $("#verification-error").hide();
        
        // 성공 메시지 표시
        $("#verify-success-msg").show();
        
        // 타이머 중지
        clearInterval(timerInterval);
        
        // 버튼들 비활성화 및 색상 변경
        $("#getVerificationBtn").css("background-color", "#BDBDBD");
        $("#getVerificationBtn").prop("disabled", true);
        $("#verify-code").css("background-color", "#BDBDBD");
        $("#verify-code").prop("disabled", true);
        $("#birth").prop("readonly", true);
        $("#emailId").prop("readonly", true);
        $("#emailDomain").css({
        	  "pointer-events": "none",
        	  "background-color": "#f5f5f5"
        	});
        
        //이제 이메일을 hidden 인풋창에 대입 
			  const emailId = $("#emailId").val().trim();
			  const emailDomain = $("#emailDomainInput").val().trim();
				const email = emailId + "@" + emailDomain;
        $("#hiddenEmail").val(email);
        
        // 비회원 예매하기 버튼 활성화 
        $("#nextBtn").css("background-color", "#FB4357");
        $("#nextBtn").prop("disabled", false);
        
     		// 인증 성공했으므로 세션의 인증코드 번호 삭제 
        $.ajax({
          url : "${pageContext.request.contextPath}/login/controller/deleteSessionVerificationCode.jsp",
          type : "POST"
        });
          
      } else if(response.result === "fail"){
        $("#verification-error").show();
        $("#verification-error").text("인증번호가 일치하지 않습니다.");
      }
    },
    error : function(xhr, status, error){
      console.log("AJAX 요청 실패");
      console.log("status: " + status);
      console.log("error: " + error);
      console.log("responseText: " + xhr.responseText);
      alert("서버 오류가 발생했습니다. 다시 시도해주세요.");
    }
  });
});

//비회원 예매 상단탭 클릭시
function nonMemberLoginFrm() {
  $(".box-login.login_1408").empty();

  let nonMemberLoginFrm = `
    <div class="personal-info-section">
      <h2 class="section-title">STEP 1 개인정보 수집 및 이용동의</h2>
      <p class="section-description">
        비회원 예매 고객께서는 먼저 개인정보 수집 및 이용 동의 정책에 동의해 주셔야 합니다.
      </p>
      <table class="info-table">
        <thead class="table-header">
          <tr>
            <th>항목</th>
            <th>이용목적</th>
            <th>보유기간</th>
            <th>동의여부</th>
          </tr>
        </thead>
        <tbody>
          <tr class="table-row">
            <td class="category-cell">
              법정생년월일, 휴대폰번호, 비밀번호
            </td>
            <td class="purpose-cell">
              · 비회원 예매서비스 제공<br>
              · 이용자식별, 요금정산, 추심, 신고서비스 개발, 접속빈도 파악 등
            </td>
            <td class="period-cell">
              수집일로부터 5년
            </td>
            <td class="agreement-cell">
              <div class="radio-group">
                <div class="radio-item">
                  <input type="radio" id="agree" name="agreement" value="agree">
                  <label for="agree">동의함</label>
                </div>
                <div class="radio-item">
                  <input type="radio" id="disagree" name="agreement" value="disagree" checked>
                  <label for="disagree">동의안함</label>
                </div>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      <p class="notice-text">
        ※ YEONFLIX 비회원 예매서비스 제공을 위해 필요한 최소한의 개인정보이므로 입력(수집)에 동의하지 않을 경우 서비스를 이용하실 수 없습니다.
      </p>
      <button class="privacy-policy-btn">개인정보처리(취급)방침전문보기</button>
      <div class="separator-line"></div>
    </div>

    <div class="nonMember-insert-section">
      <form id="nonMemRevFrm" method="post" action="${pageContext.request.contextPath}/login/controller/nonMemReservation.jsp">
        <fieldset>
          <legend>개인정보 입력(이메일,법정생년월일,비밀번호)</legend>
          <br>
          <div class="info_notice">
            <p>개인정보를 잘못 입력하시면 예매내역 확인/취소 및 티켓 발권이 어려울 수 있으니, 입력하신 정보를 다시 한번 확인해주시기 바랍니다.</p>
          </div>

          <div class="form_row">
            <label for="birth">법정생년월일(8자리)</label>
            <input type="text" id="birth" name="birth" maxlength="8" placeholder="예) 19900101" />
          </div>

          <div class="form_row">
            <label for="email">이메일 주소</label>
            <div class="email_wrap">
              <input type="text" id="emailId" name="emailId" placeholder="아이디" />
              <span>@</span>
              <input type="text" id="emailDomainInput" name="emailDomainInput" readonly />
              <select id="emailDomain" name="emailDomain">
                <option value="none" selected disabled>이메일 선택</option>
                <option value="gmail.com">gmail.com</option>
                <option value="naver.com">naver.com</option>
                <option value="daum.net">daum.net</option>
                <option value="custom">직접 입력</option>
              </select>
              <input type="hidden" id="hiddenEmail" name="email" value="">
              <button type="button" class="btn_sub" style="width: 112px" id="getVerificationBtn" onclick="getVerification()">인증번호받기</button>
              <span style="display:none; color: #f14d4d; font-size: 13px; margin-left: 10px;" id="verification-timer">05:00</span>
            </div>
          </div>

          <div class="form_row">
            <label for="auth">인증번호 (6자리)</label>
            <div style="display: flex; align-items: center; gap: 10px;">
              <input type="text" id="auth" name="auth" maxlength="6" style="width: 200px;" oninput="this.value = this.value.replace(/[^0-9]/g, '');" />
              <button type="button" class="btn_sub" id="verify-code">인증확인</button>
            </div>
            <div id="verification-error" style="color: #f14d4d; font-size: 13px; margin-top: 5px; display: none;">
              인증번호가 일치하지 않습니다.
            </div>
            <div id="verify-success-msg" style="color: #2ecc71; font-size: 13px; margin-top: 5px; display: none;">
              이메일 인증이 완료되었습니다.
            </div>
          </div>

          <div class="form_row">
            <label for="pw">비밀번호(4자리)</label>
            <input type="password" id="pw" name="pw" maxlength="4" />
          </div>

          <div class="form_row">
            <label for="pw_confirm">비밀번호확인</label>
            <input type="password" id="pw_confirm" name="pw_confirm" maxlength="4" />
          </div>

          <div class="form_submit">
            <button type="button" class="btn_submit" id="nextBtn" style="background-color: #BDBDBD;" disabled>비회원 예매하기</button>
          </div>
        </fieldset>
      </form>
    </div>
  `;

  $(".box-login.login_1408").html(nonMemberLoginFrm);
}

	
function nonMemberCheckReservationFrm(){
	//비회원 예매확인 버튼 클릭시
	$(".box-login.login_1408").empty();
	let nonMemberCheckReservationFrm =`
		<div class="guest-reservation" style="height: 640px;">
	    <div class="guest-container">
	      <h2 class="guest-title">비회원 예매 확인</h2>
	      
	      <p class="guest-info-text">비회원으로 예매하신 고객님은 개인정보(법정생년월일, 이메일 주소, 비밀번호(4자리))를 입력해 주세요.</p>
	      
	      <div class="guest-tab-container">
	        <div class="guest-tab-header">
	          <div class="guest-active" id="header1" style="background-color:#f2f2f2;">비회원 예매확인</div>
	          <div id="header2" style="background-color:#FFF;">비회원 예매 비밀번호 찾기</div>
	        </div>
	        
	        <div class="guest-tab-content">
	          <div class="guest-tab-left" id="content1" >
	          
	          	<div class="guest-tab-left-container" style="width: 70%; margin:auto;">
	          	
		            <div class="guest-form-row">
		              <p style="color:red;">모든 항목은 필수 입력사항입니다.</p>
		            </div>
		            
		            <form id="chkTicketForm" action="${pageContext.request.contextPath}/login/controller/chkNonMemTicket.jsp" method="POST"> 
		            
			            <div class="guest-form-row">
			              <label>법정생년월일(8자리)</label>
			              <input type="text" id="nonMemTicketBirth" name="birth" maxlength="8" placeholder="예) 19900101" required>
			            </div>
			            
			            <div class="guest-form-row">
			              <label>이메일주소</label>
			              <div class="guest-email-wrap">
			                <input type="text" id="nonMemGetTicketEmail1" placeholder="아이디" style="width:200px;" required>
			                <span>@</span>
			                <input type="text" id="nonMemGetTicketEmail2" value="" /> 
			                <input type="hidden" id="nonMemGetTicketEmail" name="email" value="" /> 
			                <select id="selectMail">
			                  <option value="none" selected disabled>이메일 선택</option>
			                  <option value="gmail.com">gmail.com</option>
			                  <option value="naver.com">naver.com</option>
			                  <option value="daum.net">daum.net</option>
			                  <option value="custom">직접입력</option>
			                </select>
			              </div>
			            </div>
			            
			            <div class="guest-form-row">
			              <label>비밀번호(4자리)</label>
			              <input type="password" id="nonMemTicketPassword" name="password" maxlength="4" required>
			            </div>
			            
			            <div class="guest-form-row guest-text-center">
			              <button class="guest-btn guest-btn-primary" id="checkNonMemberTicket">비회원 예매확인</button>
			            </div>
			            
		            </form>
		            
	          	</div> <!--end left-container -->
	          
	          </div> <!--end guest-tab-left -->
	          
	          <div class="guest-tab-right" id="content2">
	            <p>비회원 예매 시, 입력한 이메일주소로 SMS인증을 하면 비회원 예매 비밀번호를 찾으실 수 있습니다.</p>
	            
	            <div class="guest-divider"></div>
	            
	            <div class="guest-text-center" style="margin-top: 30px;">
	              <!-- <button class="guest-btn guest-btn-outline"><a href="http://localhost/movie_prj/login/findNonMemberPwdFrm.jsp"> 이메일로 인증번호 받기</a></button> -->
	              <button class="guest-btn guest-btn-outline"><a href="javascript:alert('현재 유지보수 진행중입니다. 고객센터에 문의해주세요.')"> 이메일로 인증번호 받기</a></button>
	            </div>
	          </div>
	        </div>
	      </div>
	    </div>
	  </div>
	`;
	$(".box-login.login_1408").html(nonMemberCheckReservationFrm);
}

/* 로그인, 비회원예매 버튼 클릭시 클래스값 on 제거/추가 */
function liClassChangeToOn(){
	$(".tab-menu-round li").on("click", function(e){
		e.preventDefault();
		$(".tab-menu-round li").removeClass('on');
		$(this).addClass('on');
	});
}
	 
/* 자동입력 방지문자 리프레쉬 버튼 클릭 */
function refreshCaptcha(){
	let refreshNumber = "";
	while(refreshNumber.length < 6){
		let randomNumb = Math.floor(Math.random() * 10);
		refreshNumber = refreshNumber + randomNumb;
	}
	$(".refresh-number").val(refreshNumber);
}

/* 로그인 함수 */
function login(){
	let loginBtn = document.getElementById("submit");
	
	//자동입력방지문자 확인 
	loginBtn.addEventListener("click", function(e){
		e.preventDefault(); //제출 기본동작 방지
		
		let txtCaptcha = $("#txtCaptcha").val();
		let refreshNumber = $(".refresh-number").val();
		
		if(txtCaptcha !== refreshNumber){
			alert("자동입력 방지 문자를 확인 후 입력해주세요");
			refreshCaptcha(); //갱신 
			return; //까먹지마라 
		} 
		
		//로그인 
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/login/controller/loginProcess.jsp",
			data:$("#form2_capcha").serialize(), /* memberId, memberPwd */
			success:function(response){
				if(response.trim() === "success"){
					alert("로그인 성공");
          location.href = "${pageContext.request.contextPath}/index.jsp"; 
				} else if (response.trim() === "fail"){
          alert("아이디 또는 패스워드가 맞지 않습니다. 확인 후 입력해주세요.");
          $("#txtUserId, #txtPwd1").val("");
          refreshCaptcha();
        } else if (response.trim() === "isDeleted"){
        	alert("탈퇴한 계정입니다. 복구관련 문의는 고객센터로 문의해 주세요.");
        	$("#txtUserId, #txtPwd1").val("");
        	refreshCaptcha();
        } else if (response.trim() === "success-butHasTempPwd"){
        	if(confirm("현재 임시비밀번호를 사용중입니다. 비밀번호를 변경하시겠습니까? ")){
        		location.href = "${pageContext.request.contextPath}/mypage/MainPage.jsp";  
        	} else {
        		location.href = "${pageContext.request.contextPath}/index.jsp";
        	}
        }
			},
			error:function(xhr, status, error){
		    console.log("에러 상태 코드:", xhr.status);
		    console.log("에러 응답:", xhr.responseText);
		    alert("서버 오류(" + xhr.status + "): " + error);
      }
			
		});
		
	});
	
	
}

//checkNonMemberTicket 비회원 예매확인 버튼 이벤트리스터, 이벤트위임을 하는게 메모리 누수 위험이 없다고 하는데,, 강사님께 여쭈어보자 
function checkNonMemberTicket(){

		//생일 -> 실시간으로 숫자만 입력되게 필터링(keyup)  
		$("#nonMemTicketBirth").on("input", function(){
			this.value = this.value.replace(/[^0-9]/g, "");
		}); 
		
		//이메일 -> 입력값 복사 
		$("#selectMail").on("change", function(){
	    let optionVal = $(this).val();  // 이벤트 발생 시점의 값 가져오기
	    console.log(optionVal);
	    if(optionVal && optionVal !== "none" && optionVal !== "custom"){
       	$("#nonMemGetTicketEmail2").val(optionVal); //input은 val() / div,span등은 text()
	    } else if(optionVal === "custom"){
	    	$("#nonMemGetTicketEmail2").val("");
        $("#nonMemGetTicketEmail2").focus();
	    }
		});
		
	//비회원예매확인 버튼 눌렀을 때 
	$("#checkNonMemberTicket").on("click", function(event){
		event.preventDefault();
		
		//이메일검증 
		let emailId = $("#nonMemGetTicketEmail1").val();
		let domain = $("#nonMemGetTicketEmail2").val();
		const fullEmail = emailId + "@" + domain;
		const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
		if(!emailRegex.test(fullEmail)){
	    alert("옳바른 이메일 형식을 입력해주세요.");
	    return;
		}
		
		//이메일검증 통과 후 대입 
		$("#nonMemGetTicketEmail").val(fullEmail);
		console.log("이메일 : " + fullEmail);
		
		//비밀번호 숫자 검증
		let password = $("#nonMemTicketPassword").val();
		const fourDigitNumber = /^[0-9]{4}$/;
		if(!fourDigitNumber.test(password)){
			alert("비밀번호는 숫자 4자리를 입력해주세요.");
			return;
		}
		
		$("#chkTicketForm").submit();
		
	});
	
	
}

	
</script>

</head>
<body>
<header>
<jsp:include page="/common/jsp/header.jsp" />
</header>
<main>
<div id="container">
  <div class="wrap-login">
    <div class="sect-login">
      <ul class="tab-menu-round">
        <li class="on" id="memberLoginBtn">
          <a href="http://localhost/movie_prj/login/loginFrm.jsp">로그인</a>
        </li>
        <li id="nonMemberLoginBtn">
          <a href="#" >비회원 예매</a>
        </li>
        <li  id="nonMemberCheckReservationBtn">
          <a href="#">비회원 예매확인</a>
        </li>
      </ul>
      
      <!-- (회원)로그인 창 -->
      <div class="box-login login_1408">
        <h3 class="hidden">회원 로그인</h3>
        <div class="loginFormDiv">
	        <form id="form2_capcha" method="post" action="" novalidate="novalidate">
	          <fieldset>
	            <div class="txt_wrap">               
	              <h3></h3>
	              <p>정보보호를 위해 아이디, 비밀번호와 함께 <br>자동 입력 방지 문자를 입력하셔야 합니다.</p> 
	            </div>
	            
	            <div class="login">
	              <input type="text" title="아이디" id="txtUserId" name="memberId" value="" placeholder="아이디">
	              <input type="password" title="패스워드" id="txtPwd1" name="memberPwd" placeholder="비밀번호">
	            </div>
	            
<!-- 캡차 영역 시작-->
	            <div class="captcha">
	              <div class="captcha_box" id="image_captcha">
	                <span class="captcha_img">
	                  <div id="imageCatpcha">
	                    <!-- <img src="https://www.cgv.co.kr/user/login/find-account-captcha-random.aspx?result=7UP1lgj71DlzKGQbmEe1hw%3D%3D"> -->
	                   	<input type="text" style="border-color: white;" class="refresh-number" value="" readonly oncopy="return false;">
	                  </div>
	                </span>
	                <a href="javascript:refreshCaptcha();" id="captchaReLoad" class="btn_refresh"><span class="sp">새로고침</span></a>
	              </div>
	              
	              <div class="input_row" id="chptcha_area">
	                <span class="input_box">
	                  <label for="chptcha" class="lbl" id="label_chptcha_area">자동입력 방지문자</label>
	                  <input type="text" id="txtCaptcha" name="txtCaptcha" placeholder="자동입력 방지문자 (앵간하면 captcha쓰자)" class="int">
	                </span>
	              </div>
	            </div>
<!-- 캡차 영역 끝-->
	            
	            <button type="button" id="submit" title="로그인"><span>로그인</span></button>
	            <div class="save-id"><input type="checkbox" id="save_id"><label for="save_id">아이디 저장</label></div>
	            <div class="login-option">
	              <a href="http://localhost/movie_prj/login/isMemberChk.jsp" >아이디 찾기</a>
	              <a href="http://localhost/movie_prj/login/findMemberPwdFrm.jsp" >비밀번호 찾기</a>
	            </div>
	            
		          <div class="naver-login">
		            <a href="javascript:goNaver();" class="btn_loginNaver">
		              <img src="https://img.cgv.co.kr/image_gt/login/btn_loginNaver.jpg" alt="네이버 로그인">
		            </a>
		            <script type="text/javascript">
		            	function goNaver(){
		            		if(confirm('좋은거 보여드릴까요?')){
			            		location.href="https://i.imgur.com/detH3kE.png";
		            		} else {
		            			alert("아쉽네요. 진짜 좋은건데");
		            			alert("그냥 가기 섭섭해요. 진짜 좋은건데..");
		            			alert("정말 싫어요?");
		            			alert("진짜 진짜 이거 후회할텐데..");
		            			if(confirm('마지막으로 한번 더 물어볼게요. 좋은거 보기 싫어요?')){
			            			location.href="https://i.imgur.com/l7uVLkn.jpeg";
		            			} else {
			            			location.href="https://i.imgur.com/l7uVLkn.jpeg";
		            			}
		            		} 
		            	}
		            </script>
		          </div>
	          </fieldset>
	        </form>
        </div><!-- loginFormDiv -->
      </div><!-- box-login login_1408 -->
      
    </div>
    
    <div class="sect-loginad" style="background:#d2cbbe; width: 350px;">
      <div>
      	<a href="https://sepay.org/spm/join?regSiteCode=OZ&ctgCode=1&subCode=1" target="_blank">
        	<img src="http://localhost/movie_prj/common/img/loginAd.png" width="350" height="300" title="" frameborder="0" scrolling="no" marginwidth="0" marginheight="0" name="Login_bigbanner" id="Login_bigbanner"></iframe>
        </a>
      </div>
    </div>
  </div>
</div>
</main>
<script type="text/javascript">
/* 비회원예매확인 js 참고하고, 수정하자. */
// 탭 전환 기능 
const guestTabHeaders = document.querySelectorAll('.guest-tab-header div');

guestTabHeaders.forEach(header => {
  header.addEventListener('click', () => {
    guestTabHeaders.forEach(h => h.classList.remove('guest-active'));
    header.classList.add('guest-active');
  });
});

// 이메일 직접 입력 기능
const guestEmailSelect = document.querySelector('.guest-email-wrap select');
const guestEmailInput = document.querySelector('.guest-email-wrap input:first-child');

guestEmailSelect.addEventListener('change', function() {
  if (this.value === 'custom') {
    const customInput = document.createElement('input');
    customInput.type = 'text';
    customInput.placeholder = '직접입력';
    
    if (document.querySelector('.guest-email-wrap input:nth-child(4)')) {
      document.querySelector('.guest-email-wrap input:nth-child(4)').remove();
    }
    
    this.parentNode.insertBefore(customInput, this.nextSibling);
  } else if (document.querySelector('.guest-email-wrap input:nth-child(4)')) {
    document.querySelector('.guest-email-wrap input:nth-child(4)').remove();
  }
});
</script>

<footer>
<c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
</footer>
</body>
</html>