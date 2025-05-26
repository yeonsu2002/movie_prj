<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지/뉴스 등록</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp" />
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">
<style>
 <style>
  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f4f6f9;
    color: #333;
    padding: 4% 6%;
  }

  .container {
    width:90%;
    margin: 0 auto;
    background: #ffffff;
    border-radius: 16px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
    padding: 40px;
  }

  h2 {
    font-size: 1.75rem;
    font-weight: 700;
    color: #222;
    margin-bottom: 12px;
  }

  .description {
    font-size: 0.95rem;
    color: #666;
    margin-bottom: 24px;
    line-height: 1.5;
  }

  label {
    display: block;
    margin: 20px 0 10px;
    font-weight: 600;
    font-size: 1rem;
    color: #333;
  }

  textarea#content {
    width: 100%;
    min-height: 160px;
    padding: 14px 16px;
    font-size: 1rem;
    font-family: inherit;
    border: 1.5px solid #ccc;
    border-radius: 10px;
    resize: vertical;
    color: #333;
    box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
  }

  textarea#content:focus {
    outline: none;
    border-color: #4a90e2;
    box-shadow: 0 0 10px rgba(74, 144, 226, 0.4);
  }

  .btn-area {
    margin-top: 30px;
    text-align: right;
  }

  input[type="button"] {
    background-color: #4a90e2;
    border: none;
    color: white;
    padding: 12px 28px;
    font-size: 1rem;
    border-radius: 10px;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s ease;
    box-shadow: 0 4px 12px rgba(74, 144, 226, 0.4);
  }

  input[type="button"]:hover {
    background-color: #357abd;
    transform: translateY(-2px);
    box-shadow: 0 6px 15px rgba(53, 122, 189, 0.6);
  }

  .content-container {
    display: none;
  }

  footer {
    margin-top: 60px;
  }
</style>

</style>
</head>
<body>


	<div class="content-container">메인내용</div>
<div class="container">
  <h2>공지/뉴스</h2>  
  <div class="description">주요한 이슈 및 여러가지 소식들을 확인하실 수 있습니다</div>

  <form>
    <label for="content">제목</label>
    <textarea id="content" placeholder="내용을 입력하세요"></textarea>

    <div class="btn-area">
      <input type="button" id="list" value="목록으로" />
    </div>
  </form>
</div>



<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){
    $("#list").click(function(){
        location.href="http://localhost/movie_prj/admin/notice/notice_admin_main.jsp";
    });
});
</script>


</body>
</html>



