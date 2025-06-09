<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Member Edit Page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보수정</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
<style>
#container { 
    min-height: 650px; 
    margin-top: 30px; 
    margin-left: 20px;
}

.title {
    font-size: 40px;
    margin: 40px auto;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
}

.container {
    max-width: 800px;
    margin: 20px auto;
    background-color: #fff;
    border: 1px solid #ddd;
    border-radius: 5px;
    padding: 20px;
}

.form-table {
    width: 45%;
    border-collapse: collapse;
    margin-left: auto;
    margin-right: auto;
}

.form-table th {
    width: 120px;
    background-color: #f8f9fa;
    padding: 12px 15px;
    text-align: left;
    border: 1px solid #ddd;
    font-weight: normal;
    font-size: 14px;
}

.form-table td {
    padding: 8px 15px;
    border: 1px solid #ddd;
}

.required:before {
    content: "* ";  
    color: #ff0000;
}

.inputBox {
    padding: 6px 8px;
    border: 1px solid #ccc;
    border-radius: 3px;
}

.search-button {
    background-color: #f0f0f0;
    border: 1px solid #ccc;
    padding: 5px 10px;
    font-size: 12px;
    cursor: pointer;
    border-radius: 3px;
}

.search-button:hover {
    background-color: #e0e0e0;
}

select {
    padding: 5px;
    border: 1px solid #ccc;
    border-radius: 3px;
}

.submit-section {
    text-align: center;
    margin-top: 20px;
}

.btn {
    border: none;
    padding: 8px 20px;
    font-size: 16px;
    border-radius: 3px;
    cursor: pointer;
    margin: 0 5px;
}

.btn-light, .btn-secondary {
    background-color: #aaa;
    color: white;
}

.btn-danger {
    background-color: #ff6600;
    color: white;
}

.btn:hover {
    opacity: 0.8;
}

.radio-group label {
    margin-right: 15px;
}

.submit-delete {
    text-align: right;
    margin-top: 20px;
}

.validation-message {
    font-size: 12px;
    margin-top: 5px;
    color: #ff0000;
    display: none;
}

.validation-message.show {
    display: block;
}

.validation-message.success {
    color: #28a745;
}

.input-error {
    border-color: #ff0000 !important;
}

.input-success {
    border-color: #28a745 !important;
}

.password-strength-meter {
    height: 4px;
    width: 100%;
    background-color: #ddd;
    border-radius: 2px;
    margin-top: 5px;
    transition: all 0.3s ease;
}

.password-strength-meter.weak {
    background-color: #ff4757;
    width: 33%;
}

.password-strength-meter.medium {
    background-color: #ffa726;
    width: 66%;
}

.password-strength-meter.strong {
    background-color: #26de81;
    width: 100%;
}

.profile-image-container {
    width: 180px;
    height: 180px;
    border: 1px solid #dedede;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
}

.profile-image-container img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){
	//닉네임 중복 검사를 했는지 여부를 추적하는 변수
    let isNicknameChecked = false;
	//페이지 로드 시 닉네임의 초기값을 저장
    let originalNickname = $("#nickname").val().trim();
    
    // 비밀번호 입력 이벤트
    $("#memberPwd").on("input", function(){
        validatePassword();
        validateForm();
    });
    
    // 비밀번호 확인 입력 이벤트
    $("#chkPass").on("input", function(){
        validatePasswordConfirmation();
        validateForm();
    });
    
    // 닉네임 변경 감지
    $("#nickname").on("input", function(){
        let currentNickname = $(this).val().trim();
        if(currentNickname !== originalNickname) {
            isNicknameChecked = false;
            $("#nicknameValidation").removeClass("show success");
            $(this).removeClass("input-success input-error");
        } else {
            isNicknameChecked = true;
        }
        validateForm();
    });
    
    // 닉네임 중복확인 버튼
    $("#checkNicknameBtn").on("click", function() {
        checkNicknameDuplicate();
    });
    
    
    
    ////////////////////////////////////// 전체 폼 유효성 검사//////////////////////////////////////////////////
    function validateForm() {
        let isValid = true;
        
        // 필수 필드 확인
        $("input[required], select[required]").each(function() {
            if ($(this).val().trim() === "") {
                isValid = false;
                return false;
            }
        });
        
        // 비밀번호가 입력된 경우에만 확인
        let password = $("#memberPwd").val();
        if (password.length > 0) {
            if (password.length < 8) {
                isValid = false;
            }
            if (password !== $("#chkPass").val()) {
                isValid = false;
            }
        }
        
        // 닉네임 중복확인 여부
        let currentNickname = $("#nickname").val().trim();
        if (currentNickname !== originalNickname && !isNicknameChecked) {
            isValid = false;
        }
        
        // 이메일 형식 확인
        let email1 = $("#email1").val().trim();
        let email2 = $("#email2").val().trim();
        if (email1 && email2) {
            let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email1 + "@" + email2)) {
                isValid = false;
            }
        }
        
        $("#btnUpdate").prop("disabled", !isValid);
        return isValid;
    }
    
    
    // 비밀번호 강도 검사
    function validatePassword() {
        let password = $("#memberPwd").val();
        let strength = 0;
        
        // 기존 메시지 초기화
        $("#passwordValidation").removeClass("show");
        $(".password-strength-meter").removeClass("weak medium strong").css("width", "0%");
        
        if (password.length === 0) {
            return;
        }
        
        // 비밀번호 길이 확인
        if (password.length < 8) {
            $("#passwordValidation").text("비밀번호는 8자 이상이어야 합니다.").addClass("show");
            $(".password-strength-meter").addClass("weak");
            return;
        }
        
        // 문자, 숫자, 특수문자 포함 여부 확인
        if (/[A-Za-z]/.test(password)) strength += 1;
        if (/[0-9]/.test(password)) strength += 1;
        if (/[^A-Za-z0-9]/.test(password)) strength += 1;
        
        // 강도에 따른 시각적 표시
        if (strength === 1) {
            $(".password-strength-meter").addClass("weak");
        } else if (strength === 2) {
            $(".password-strength-meter").addClass("medium");
        } else if (strength === 3) {
            $(".password-strength-meter").addClass("strong");
        }
        
        validatePasswordConfirmation();
    }
    
    // 비밀번호 확인 검사
    function validatePasswordConfirmation() {
        let password = $("#memberPwd").val();
        let confirmPassword = $("#chkPass").val();
        
        $("#confirmPasswordValidation").removeClass("show");
        
        if (confirmPassword.length > 0 && password !== confirmPassword) {
            $("#confirmPasswordValidation").text("비밀번호가 일치하지 않습니다.").addClass("show");
            return false;
        }
        
        return true;
    }
    
    // 닉네임 중복확인
    function checkNicknameDuplicate() {
        let nickname = $("#nickname").val().trim();
        
        if (nickname === "") {
            alert("닉네임을 입력해주세요.");
            return;
        }
        
        // 기존 닉네임과 같으면 중복확인 불필요
        if (nickname === originalNickname) {
            $("#nicknameValidation").text("현재 사용중인 닉네임입니다.")
                .addClass("show success").removeClass("validation-message");
            $("#nickname").addClass("input-success").removeClass("input-error");
            isNicknameChecked = true;
            validateForm();
            return;
        }
        
        // 닉네임 형식 검증
        let nicknameRegex = /^[가-힣a-zA-Z0-9]{2,20}$/;
        if (!nicknameRegex.test(nickname)) {
            $("#nicknameValidation").text("닉네임은 한글, 영문, 숫자 조합 2-20자여야 합니다.")
                .addClass("show").removeClass("success");
            $("#nickname").addClass("input-error").removeClass("input-success");
            return;
        }
        
        // Ajax 중복확인 요청
        $.ajax({
            url: "${pageContext.request.contextPath}/login/controller/checkNickname.jsp",
            type: "POST",
            data: { nickname: nickname },
            dataType: "json",
            success: function(response) {
                if (response.available) {
                    $("#nicknameValidation").text("사용 가능한 닉네임입니다.")
                        .addClass("show success").removeClass("validation-message");
                    $("#nickname").addClass("input-success").removeClass("input-error");
                    isNicknameChecked = true;
                } else {
                    $("#nicknameValidation").text("이미 사용중인 닉네임입니다.")
                        .addClass("show").removeClass("success");
                    $("#nickname").addClass("input-error").removeClass("input-success");  
                    isNicknameChecked = false;
                }
                validateForm();
            },
            error: function(xhr) {
                alert("중복확인 중 오류가 발생했습니다. 다시 시도해주세요.");
                console.error("Error:", xhr.status, xhr.responseText);
            }
        });
    }
    
    // 프로필 이미지 관련
    $("#btnImg").click(function(){
        $("#profile").click(); 
    });
    
    $("#profile").change(function(evt){
        let file = evt.target.files[0];
        if (!file) return;
        
        // 파일 크기 체크 (5MB)
        if (file.size > 5 * 1024 * 1024) {
            alert('파일 크기는 5MB 이하만 가능합니다.');
            $(this).val('');
            return;
        }
        
        let ext = file.name.split('.').pop().toLowerCase();
        if ($.inArray(ext, ['jpg', 'gif', 'bmp', 'jpeg', 'png']) === -1) {
            alert('JPG, GIF, BMP, PNG 파일만 등록 가능합니다.');
            $(this).val('');
            return;
        }
        
        $("#imgName").val(file.name);
        
      let reader = new FileReader();
        reader.onload = function(evt){
            $("#img").prop("src", evt.target.result);
        }
        reader.readAsDataURL(file); 
    });
    
    
    
    
    // 이메일 도메인 선택
    $("#emailDomainSelect").change(function(){
        $("#email2").val($(this).val());
        validateForm();
    });
    
    // 이메일 입력 이벤트
    $("#email1, #email2").on("input", function(){
        validateForm();
    });
    
    // 폼 제출
    $("#btnUpdate").click(function(e){
        e.preventDefault();
        
        if (!validateForm()) {
            alert("입력 정보를 확인해주세요.");
            return;
        }
        
        if (confirm("회원정보를 수정하시겠습니까?")) {
            let frm = $("#frm")[0];
            let formData = new FormData(frm);
            
            $.ajax({
                url: "edit_process.jsp", 
                type: "POST",
                data: formData,
                contentType: false,
                processData: false,
                dataType: "json",
                timeout: 30000,
                error: function(xhr, status, error) {
                    console.error("Ajax Error:", status, error);
                    alert("회원 수정 중 오류가 발생했습니다.");
                    $("#btnUpdate").prop("disabled", false).text("수정");
                },
                success: function(res) {
                    if (res.result) {
                        alert("회원정보 수정이 완료되었습니다!");
                        window.location.href = "http://localhost/movie_prj/mypage/MainPage.jsp"; 
                    } else {
                        alert(res.message || "회원 수정에 실패했습니다.");
                        $("#btnUpdate").prop("disabled", false).text("수정");
                    }
                }
            });
        }
    });
    
    // 취소 버튼
    $("#resetBtn").click(function(){
        if (confirm("입력한 내용을 취소하시겠습니까?")) {
            window.location.reload();
        }
    });
    
    // 초기 폼 검증
    validateForm();
});
</script>
</head>
<body>
<header>
    <jsp:include page="/common/jsp/header.jsp" />
</header>

<main>
<br><br>
<div id="container">
<%
    MemberDTO loginDTO = (MemberDTO)session.getAttribute("loginUser");
    if(loginDTO == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    
    int userIdx = loginDTO.getUserIdx();  
    MemberService ms=new MemberService();
    MemberDTO member = ms.searchOneMember(userIdx);
    pageContext.setAttribute("member", member);
    
    
%>

<div class="title">
    <h2 style="text-align: center; color: black;">회원정보수정</h2>
</div> 

<form  method="post" name="frm" id="frm" enctype="multipart/form-data">
    <input type="hidden" name="userIdx" value="${member.userIdx}">
    <table class="form-table">
        <!-- 프로필 이미지 -->
        <tr>
            <th scope="row" style="text-align: center; vertical-align: middle;">프로필</th>
            <td>
                <div class="profile-image-container">
                   <c:choose>
				        <c:when test="${not empty member.picture}">
				            <img src="/profile/${member.picture}" alt="프로필이미지" id="img"/>
				        </c:when>
				        <c:otherwise>
				            <img src="/movie_pfj/common/img/default_img.png" style="width:180px; height:180px" id="img" alt="기본이미지"/>
				        </c:otherwise>
				    </c:choose>
                </div>
                <br>
                <input type="button" value="이미지선택" id="btnImg" class="btn btn-light btn-sm"/>
                <input type="file" name="profile" id="profile" accept=".jpg,.gif,.bmp,.jpeg,.png" style="display:none"/>
                <input type="hidden" name="imgName" id="imgName" value="${member.picture}"/>
                <div style="font-size: 12px; color: #666; margin-top: 5px;">
                    JPG, GIF, BMP, PNG 파일만 등록 가능 (최대 5MB) 
                </div>
            </td>
        </tr>

        <!-- 닉네임 -->
        <tr>
            <th  class="required">닉네임</th>
            <td>
                <input type="text" class="inputBox" style="width: 300px;" name="nickName" id="nickname" 
                       value="${member.nickName}" required maxlength="20">
                <button class="search-button" type="button" id="checkNicknameBtn">중복확인</button>
                <div id="nicknameValidation" class="validation-message"></div>
                <div style="font-size: 12px; color: #666; margin-top: 5px;">
                    한글, 영문, 숫자 혼용 가능 (2-20자)
                </div>
            </td>
        </tr>

        <!-- 아이디 -->
        <tr>
            <th>아이디</th>
            <td>
                <c:out value="${member.memberId}" />
            </td>
        </tr>

        <!-- 비밀번호 -->
        <tr>
            <th>비밀번호</th>
            <td>
                <input type="password" class="inputBox" style="width: 200px" name="memberPwd" 
                       id="memberPwd" placeholder="변경시에만 입력" maxlength="50">
                <span style="margin-left: 15px;">비밀번호 확인</span>
                <input type="password" class="inputBox" style="width: 200px" name="chkPass" 
                       id="chkPass" placeholder="비밀번호 확인" maxlength="50">
                <div class="password-strength-meter"></div>
                <div id="passwordValidation" class="validation-message"></div>
                <div id="confirmPasswordValidation" class="validation-message"></div>
                <div style="font-size: 12px; color: #666; margin-top: 5px;">
                    영문, 숫자, 특수문자 조합 8자 이상 (변경시에만 입력)
                </div>
            </td>
        </tr>

        <!-- 이름 -->
        <tr>
            <th>이름</th>
            <td>
                <c:out value="${member.userName}" />
            </td>
        </tr>

        <!-- 생년월일 -->
        <tr>
            <th>생년월일</th>
            <td>
                <c:out value="${member.birth }"/>
            </td>
        </tr>

        <!-- 이메일 -->
        <tr>
            <th>이메일</th>
            <td>
                <%
                    String email = member.getEmail();
                    String email1 = "";
                    String email2 = "";
                    if(email != null && email.contains("@")) {
                        String[] parts = email.split("@");
                        email1 = parts[0];
                        email2 = parts[1];
                    }
                %>
                <input type="text" class="inputBox" style="width: 150px;" name="email1" 
                       id="email1" value="<%= email1 %>" required>
                <span>@</span>
                <input type="text" class="inputBox" style="width: 150px;" name="email2" 
                       id="email2" value="<%= email2 %>" required>
                <select style="width: 150px; margin-left: 8px;" id="emailDomainSelect">
                    <option value="">- 직접입력 -</option>
                    <option value="gmail.com" <%= "gmail.com".equals(email2) ? "selected" : "" %>>gmail.com</option>
                    <option value="naver.com" <%= "naver.com".equals(email2) ? "selected" : "" %>>naver.com</option>
                    <option value="daum.net" <%= "daum.net".equals(email2) ? "selected" : "" %>>daum.net</option>
                </select>
            </td>
        </tr>

        <!-- 휴대폰 -->
        <tr>
            <th>휴대폰</th>
            <td>
               <c:out value="${member.tel }"/>
            </td>
        </tr>

        <!-- 이메일 수신 -->
        <tr>
            <th>이메일 수신</th>
            <td class="radio-group">
                <input type="radio" id="email_yes" name="isEmailAgreed" value="Y" 
                       ${member.isEmailAgreed eq 'Y' ? 'checked' : ''} required>
                <label for="email_yes">수신동의</label>
                <input type="radio" id="email_no" name="isEmailAgreed" value="N" 
                       ${member.isEmailAgreed eq 'N' ? 'checked' : ''}>
                <label for="email_no">수신거부</label>
            </td>
        </tr>

        <!-- SMS 수신 -->
        <tr>
            <th>SMS 수신</th>
            <td class="radio-group">
                <input type="radio" id="sms_yes" name="isSmsAgreed" value="Y" 
                       ${member.isSmsAgreed eq 'Y' ? 'checked' : ''} required>
                <label for="sms_yes">수신동의</label>
                <input type="radio" id="sms_no" name="isSmsAgreed" value="N" 
                       ${member.isSmsAgreed eq 'N' ? 'checked' : ''}>
                <label for="sms_no">수신거부</label>
            </td>
        </tr>
    </table>

    <!-- 버튼 -->
    <div class="submit-section">
        <button class="btn btn-danger" type="submit" id="btnUpdate">수정</button>
        <button class="btn btn-secondary" type="button" id="resetBtn">취소</button>
    </div>

    <div class="submit-delete">
        <a href="http://localhost/movie_prj/mypage/remove.jsp" class="btn btn-light">탈퇴</a>
    </div>
</form>
</div>
<br><br>
</main>

<footer>
    <c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
</footer>
</body>
</html>