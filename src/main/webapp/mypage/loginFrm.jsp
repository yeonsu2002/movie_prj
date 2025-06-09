<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Login Form with ID and Password"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 확인</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
<style>ㅡ
  #container{ min-height: 950px; margin-top: 30px; margin-left: 20px}
  main {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    padding: 20px;
    box-sizing: border-box;
    background-color: #333;
  }
  .mb-5{ font-size:35px}
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script type="text/javascript">
window.onload = function() {
    document.loginFrm.addEventListener("submit", function(e) {
        e.preventDefault();  // 폼이 서버로 제출되지 않도록 막음
        chkNull();
    });
}


function enter(evt) {
    if (evt.which == 13) {  // 엔터키 입력 시
        chkNull();
    }
}

/* 유효성 검사 */

	function chkNull() {
    var obj = document.loginFrm;
    var id = obj.id.value.trim();
    var pass = obj.password.value;

    if (id == "") {
        alert("아이디는 필수 입력입니다.");
        obj.id.focus();
        return;
    } 

    if (pass == "") {
        alert("비밀번호는 필수 입력입니다.");
        obj.password.focus();
        return;
    }
    if (pass.length > 20) {
        alert("비밀번호는 최대 20자리까지만 입력 가능합니다.");
        obj.password.focus();
        return;
    }

    loginProcess(id, pass);
}

function loginProcess(id, pass) {
    $.ajax({
        url: "login_process.jsp",
        type: "POST",
        data: { id: id, pass: pass },
        dataType: "json",
        error: function(xhr) {
            alert("로그인 작업이 정상적으로 수행되지 않았습니다.\n잠시 다시 시도해주세요.");
            console.log(xhr.status);
        },
        success: function(jsonObj) {
            if (jsonObj.loginResult) {
                location.href = "http://localhost/movie_prj/mypage/edit.jsp";  // 로그인 성공 시 이동할 페이지
            } else {
                var output = "<br/>아이디 또는 비밀번호를 확인해주세요.";
                $("#loginFail").html(output);
            }
        }
    });
}
</script>

</head>

<body>
<header>
<jsp:include page="/common/jsp/header.jsp" />
</header>

<main>
<div class="container">
  <div class="row justify-content-center">
    <div class="col-12 col-md-9 col-lg-7 col-xl-6 col-xxl-5">
      <div class="card border-0 shadow-sm rounded-4">
        <div class="card-body p-3 p-md-4 p-xl-5 mt-5">
          <div class="row">
            <div class="col-12">
              <div class="mb-5">
                <h2 style="text-align: center;">개인정보변경</h2>
              </div>
            </div>
          </div>

          <form name="loginFrm" method="post" action="login_process.jsp">
            <div class="row gy-3 overflow-hidden">
             <div class="col-12">
                <div class="form-floating mb-3">
                  <input type="text" class="form-control" name="id" id="id" placeholder="아이디 입력" required>
                  <label for="id" class="form-label">ID</label>
                </div> 
              </div>
              <div class="col-12">
                <div class="form-floating mb-3">
                  <input type="password" class="form-control" name="password" id="password" placeholder="비밀번호 입력" required>
                  <label for="password" class="form-label">Password</label>
                </div>
              </div>

              <div class="col-12">
                <div class="d-grid">
                 <input type="submit" value="확인" class="btn btn-danger" id="btnLogin"/>
                </div>
              </div>
            </div>
          </form>
          <div id="loginFail" style="color: red; text-align:center; margin-top: 15px;"></div>
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
