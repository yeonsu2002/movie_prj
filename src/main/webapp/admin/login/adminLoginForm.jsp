<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 로그인</title>
    <style>
        body {
            margin: 0;
            height: 100vh;
            background-color: #e0e0e0;;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.5);
            width: 350px;
        }

        .login-container h2 {
            margin-bottom: 25px;
            text-align: center;
            color: #333;
        }
        
        .logo {
		    display: block;
		    margin: 0 auto 20px auto;
		    max-width: 350px;
		    height: auto;
		}

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            color: #555;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            
        }

        .login-button {
            width: 100%;
            padding: 12px;
            background-color: #4b5563;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 15px;
            cursor: pointer;
        }

        .login-button:hover {
            background-color: #374151;
        }
    </style>
    
<script type="text/javascript">
$(function(){
	
	const loginBtn = document.getElementById('loginBtn');
	loginBtn.addEventListener("click", loginProcess);
	
});//end ready

function loginProcess(){
	
	let adminId = $("#adminId").val();
	let adminPwd = $("#adminPwd").val();
	console.log(adminId  + "/" + adminPwd);
	$.ajax({
		url:"${pageContext.request.contextPath}/admin/login/controller/adminLoginController.jsp",
		data:{
			adminId : adminId,
			adminPwd : adminPwd
		},   
		type: "POST",
		success: function(response){
			if(response.trim() === "success"){
				alert(adminId + " 관리자님, 좋은 하루입니다.");
				location.replace("${pageContext.request.contextPath}/admin/dashboard/dashboard.jsp");
			} else if(response.trim() === "fail"){
				alert("아이디와 비밀번호를 다시 한번 확인해 주세요.");
				return; 
			} else if(response.trim() === "isDeleted"){
				alert("활동이 정지된 계정입니다.");
				return;
			} else if(response.trim() === "deniedIP"){
				alert("등록되지 않은 IP 주소에서의 접속은 제한됩니다.");
				return;
			}
		},
		error:function(xhr, status, error){
	    console.log("에러 상태 코드:", xhr.status);
	    console.log("에러 응답:", xhr.responseText);
	    alert("서버 오류(" + xhr.status + "): " + error);
    }

	});
	
	
}





</script>    
</head>
<body>

    <div class="login-container">
	    <img src="${pageContext.request.contextPath }/common/img/logo.png" class="logo" />
        <h2>관리자 로그인</h2>
        
        <form action="#void" method="post">
            <div class="form-group">
                <label for="adminId">아이디</label>
                <input type="text" name="adminId" id="adminId" />
            </div>
            <div class="form-group">
                <label for="adminPw">비밀번호</label>
                <input type="password" name="adminPwd" id="adminPwd" />
            </div>
            <button type="button" class="login-button" id="loginBtn">로그인</button>
            <% String yourIP = request.getRemoteAddr(); 
			         if ("0:0:0:0:0:0:0:1".equals(yourIP)) {
			           yourIP = "127.0.0.1";  // IPv6 → IPv4 변환
			          }
            	 request.setAttribute("yourIP", yourIP); 
            %>
            접속 IP : <c:out value="${yourIP }"/>
            <c:if test="${yourIP == '127.0.0.1' }">
            	<button type="button" id="superLogin">총관리자 로그인</button> <!-- 이거 테스트 해봐야겠는데 다른데서 -->
            	<script type="text/javascript">
            		$("#superLogin").on("click", function(){
            			let password = prompt("총관리자 비밀번호 입력 (superpwd 입력하시오 )");
            			
            			$.ajax({
            				url : "${pageContext.request.contextPath}/admin/login/controller/superLoginController.jsp",
            				method : "post",
            				data:{
            					password : password
            				},
            				success: function(response){
            					if(response.trim() === "success"){
            						location.replace("http://localhost/movie_prj/admin/dashboard/dashboard.jsp");
            					} else {
	            					alert("비밀번호가 옳지 않습니다.");	
            					}
            				},
            				error : function(){
            					alert("알수 없는 오류 발생 ");
            				}
            			});
            			
            		})
            	</script>
            </c:if>
        </form>
    </div>
    
</body>
</html>
