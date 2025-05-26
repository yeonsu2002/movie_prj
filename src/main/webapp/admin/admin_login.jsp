<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
</head>
<body>

    <div class="login-container">
	    <img src="http://localhost/movie_prj/common/img/logo.png" class="logo" />
        <h2>관리자 로그인</h2>
        
        <form action="" method="post">
            <div class="form-group">
                <label for="adminId">아이디</label>
                <input type="text" name="adminId" id="adminId" />
            </div>
            <div class="form-group">
                <label for="adminPw">비밀번호</label>
                <input type="password" name="adminPw" id="adminPw" />
            </div>
            <button type="submit" class="login-button">로그인</button>
            
        </form>
    </div>
    
</body>
</html>
