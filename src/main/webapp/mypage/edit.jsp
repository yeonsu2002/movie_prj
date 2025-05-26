<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="kr.co.yeonflix.member.MyPageService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보수정</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
<style>
  #container{ min-height: 650px; margin-top: 30px; margin-left: 20px}

.title{
	font-size: 40px;
	margin: 40px auto;
	display: flex;
	justify-content: center;
	align-items: center;
	flex-direction: column;
}
.container {
    max-width: 800px;
    margin:20px auto;
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
.btn btn-light, .btn btn-secondary {
	border: none;
	background-color: #aaa;
    cursor: pointer;
}
.btn btn-danger {
    background-color: #ff6600;
    color: white;
    border: none;
    padding: 8px 20px;
    font-size: 16px;
    border-radius: 3px;
    cursor: pointer;
}
.radio-group label {
    margin-right: 15px;
}
.submit-delete {
    text-align: right;
    margin-top: 20px;
}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){
	
	$("#btnImg").click(function(){
		$("#profileImg").click(); 
	});
	
	$("#profileImg").change(function(evt){
		var file=evt.target.files[0];
		if(!file) return;
		var ext = file.name.split('.').pop().toLowerCase();
		if($.inArray(ext, ['jpg','gif','bmp','jpeg']) === -1){
			alert('JPG, GIF, BMP 파일만 등록 가능합니다.');
			$(this).val('');
			return;
		}
		
		$("#imgName").val(file.name);
		
		var reader=new FileReader();
		reader.onload=function(evt){
			$("#img").prop("src", evt.target.result);
		}
		reader.readAsDataURL(file);
	});
	
	
	$("#btnUpdate").click(function(e){
		  e.preventDefault();
		  
		  if(confirm("회원정보를 수정하시겠습니까?")){
		    var frm = $("#frm")[0];
		    var formData = new FormData(frm);
		    
		    $.ajax({
		    	  url: "edit_process.jsp", 
		    	  type: "POST",
		    	  data: formData,
		    	  contentType: false,
		    	  processData: false,
		    	  dataType: "json",
		    	  error: function(){
		    	    alert("회원 수정 실패");
		    	  },
		    	  success: function(res){
		    		  if(res.result){
		    		    alert("회원정보 수정 완료!");
		    		    window.location.href = "http://localhost/movie_prj/mypage/MainPage.jsp"; 
		    		  } else {
		    		    alert(res.message || "회원 수정 실패");
		    		  }
		    		}
		    	});
		  }
		});
	
	// 닉네임 중복확인 버튼 클릭 이벤트
	$("#checkNicknameBtn").click(function(){
		const nickname = $("#nickname").val().trim();
		if(nickname === ""){
			alert("닉네임을 입력하세요.");
			return;
		}
		// 중복확인 ajax 호출 필요 - 여기서는 간단 alert 처리
		alert("닉네임 중복확인 기능은 별도 구현 필요: " + nickname);
	});
	
	// 이메일 도메인 선택 시 자동 입력
	$("#emailDomainSelect").change(function(){
		$("#email2").val($(this).val());
	});
	
});
</script>
</head>
<body>
<header>
  <c:import url="http://localhost/movie_prj/common/jsp/header.jsp"/>
</header>

<main>
<br><br>
<div id="container">
<%
  kr.co.yeonflix.member.MemberDTO loginDTO = (kr.co.yeonflix.member.MemberDTO)session.getAttribute("userData");
  if(loginDTO == null) {
      response.sendRedirect("login.jsp");
      return;
  }

  String memberId = loginDTO.getMemberId();
  MyPageService mps = new MyPageService();
  kr.co.yeonflix.member.MemberDTO member = mps.searchMember(memberId);
  pageContext.setAttribute("member", member);
%>

<div class="title">
  <img src="http://localhost/movie_prj/common/img/logo.png"/>
  <h2 style="text-align: center; color: black;">회원정보수정</h2>
</div>

<form action="#" method="post" name="frm" id="frm" enctype="multipart/form-data">
  <input type="hidden" name="memberId" value="${member.memberId}">
  <table class="form-table">
    <!-- 프로필 이미지 -->
    <tr>
      <th class="required" scope="row" style="text-align: center; vertical-align: middle;">프로필</th>
      <td>
        <div style="display: flex; align-items: center;">
          <div>
            <img src="${empty member.picture ? '../common/userProfiles/default_img.png' : '../common/userProfiles/' + member.picture}" 
              style="width:130px; height:140px" id="img"/>
            <br>
            <input type="button" value="이미지선택" id="btnImg" class="btn btn-info btn-sm"/>
            <input type="file" name="profileImg" id="profileImg" accept=".jpg,.gif,.bmp,.jpeg" style="display:none"/>
            <input type="hidden" name="imgName" id="imgName" value="${member.picture}"/>
            <label style="margin-top: 10px;">JPG, GIF, BMP 파일만 등록 가능합니다.</label>
          </div>
        </div>
      </td>
    </tr>

    <!-- 닉네임 -->
    <tr>
      <th class="required">닉네임</th>
      <td>
        <input type="text" class="inputBox" style="width: 500px;" name="nickName" id="nickname" value="${member.nickName}">
        <button class="search-button" type="button" style="font-size: 17px" id="checkNicknameBtn">중복확인</button>
        <div style="font-size: 12px; color: #666; margin-top: 5px;">한글, 영문, 숫자 혼용 가능 (한글 기준 10자 이내)</div>
      </td>
    </tr>

    <!-- 아이디 -->
    <tr>
      <th class="required">아이디</th>
      <td>
        <c:out value="${member.memberId}" />
      </td>
    </tr>

    <!-- 비밀번호 -->
    <tr>
      <th class="required">비밀번호</th>
      <td>
        <input type="password" class="inputBox" style="width: 200px" name="memberPwd" id="memberPwd" value="">
        <span style="margin-left: 15px;">비밀번호 확인</span>
        <input type="password" class="inputBox" style="width: 200px" name="chkPass" id="chkPass" value="">
        <div style="font-size: 12px; color: #666; margin-top: 5px;">영문, 숫자, 특수문자 조합 8자 이상 입력하세요.</div>
      </td>
    </tr>

    <!-- 이름 -->
    <tr>
      <th class="required">이름</th>
      <td>
        <c:out value="${member.userName}" />
      </td>
    </tr>

    <!-- 생년월일 -->
    <tr>
      <th>생년월일</th>
      <td>
        <input type="date" name="birth" value="${member.birth}" readonly />
      </td>
    </tr>

    <!-- 이메일 -->
    <tr>
      <th class="required">이메일</th>
      <td>
        <%
          // 이메일 분리 (ex: abc@naver.com -> email1=abc, email2=naver.com)
          String email = member.getEmail();
          String email1 = "";
          String email2 = "";
          if(email != null && email.contains("@")) {
              String[] parts = email.split("@");
              email1 = parts[0];
              email2 = parts[1];
          }
        %>
        <input type="text" class="inputBox" style="width: 150px;" name="email1" id="email1" value="<%= email1 %>">
        <span>@</span>
        <input type="text" class="inputBox" style="width: 150px;" name="email2" id="email2" value="<%= email2 %>">
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
        <input type="text" name="tel" value="${member.tel}" class="inputBox" />
      </td>
    </tr>

    <!-- 이메일 수신 -->
    <tr>
      <th class="required">이메일 수신</th>
      <td>
        <input type="radio" id="email_yes" name="isEmailAgreed" value="Y" ${member.isEmailAgreed eq 'Y' ? 'checked' : ''}>
        <label for="email_yes">수신동의</label>
        <input type="radio" id="email_no" name="isEmailAgreed" value="N" ${member.isEmailAgreed eq 'N' ? 'checked' : ''}>
        <label for="email_no">수신거부</label>
      </td>
    </tr>

    <!-- SMS 수신 -->
    <tr>
      <th class="required">SMS 수신</th>
      <td>
        <input type="radio" id="sms_yes" name="isSmsAgreed" value="Y" ${member.isSmsAgreed eq 'Y' ? 'checked' : ''}>
        <label for="sms_yes">수신동의</label>
        <input type="radio" id="sms_no" name="isSmsAgreed" value="N" ${member.isSmsAgreed eq 'N' ? 'checked' : ''}>
        <label for="sms_no">수신거부</label>
      </td>
    </tr>
  </table>

  <!-- 버튼 -->
  <div class="submit-section">
    <button class="btn btn-danger" style="width:80px" type="submit" id="btnUpdate">수정</button>
    <button class="btn btn-secondary" style="width:80px" type="reset">취소</button>
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
