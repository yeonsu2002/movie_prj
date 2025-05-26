<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: rgba(0, 0, 0, 0.4); /* 반투명 어두운 배경 */
  margin: 0;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.container {
  background-color: #fff;
  padding: 30px 40px;
  border-radius: 12px;
  box-shadow: 0 8px 20px rgba(0,0,0,0.3);
  max-width: 450px;
  width: 90%;
  text-align: center;
}

h2 {
  color: #333;
  margin-bottom: 20px;
  font-weight: 700;
  font-size: 1.6rem;
}

p {
  font-size: 1rem;
  color: #555;
  margin-bottom: 25px;
  line-height: 1.4;
}

.info-box {
  background-color: #fefefe;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 8px;
  color: #444;
  margin-bottom: 25px;
  font-size: 1rem;
}

input[type="button"] {
  background-color: #4a90e2;
  border: none;
  color: white;
  padding: 12px 28px;
  font-size: 1rem;
  border-radius: 8px;
  cursor: pointer;
  margin: 0 10px;
  box-shadow: 0 3px 8px rgba(74, 144, 226, 0.5);
  transition: background-color 0.3s ease, transform 0.2s ease;
  min-width: 140px;
}

input[type="button"]:hover {
  background-color: #357abd;
  transform: translateY(-2px);
  box-shadow: 0 6px 15px rgba(53, 122, 189, 0.7);
}

</style>
</head>
<body>
  <div class="container">
    <h2>작성하신 이메일 문의가 정상적으로 접수 완료 되었습니다</h2>
    <p>문의하신 내용은 MY CGV &gt; 나의 문의내역 &gt; 1:1문의에서 확인하실 수 있습니다</p>
    <div class="info-box">
      접수일시 ----년--월--일
    </div>
    <input type="button" id="list" value="문의내역 확인"/>
    <input type="button" id="main" value="고객센터 메인"/>
  </div>
 
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){
    $("#list").click(function(){
        location.href="http://localhost:8080/jsp_prj/notice/notice_add.jsp";
    });
    $("#main").click(function(){
    });
});
</script>
</body>
</html>