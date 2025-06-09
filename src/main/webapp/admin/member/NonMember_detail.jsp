<%@page import="java.time.format.DateTimeParseException"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.member.NonMemberDTO"%>
<%@page import="kr.co.yeonflix.member.NonMemberDAO"%>
<%@page import="kr.co.yeonflix.member.MemberDAO"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
String email = request.getParameter("email");
String birth = request.getParameter("birth");

if (email == null || email.trim().isEmpty()) {
    out.println("비회원 이메일이 전달되지 않았습니다.");
    return;
}

//생일 값이 없거나 잘못된 형식이면 오류 처리
if (birth == null || birth.trim().isEmpty()) {
 out.println("비회원 생일이 전달되지 않았습니다.");
 return;
}

LocalDate birthDate = null;
try {
 // 생일이 "yyyy-MM-dd" 형식이면 LocalDate로 변환
 birthDate = LocalDate.parse(birth);  // 만약 형식이 다르면 DateTimeFormatter 사용 필요
} catch (DateTimeParseException e) {
 out.println("생일 형식이 잘못되었습니다. 올바른 형식으로 입력해주세요.");
 return;
}

// 이메일로 비회원 정보 조회
NonMemberDAO nDAO = NonMemberDAO.getInstance();
NonMemberDTO nDTO = nDAO.selectNonMember(birthDate, email);

if (nDTO == null) {
    out.println("해당 비회원 정보를 찾을 수 없습니다.");
    return;
}

pageContext.setAttribute("nonMember", nDTO);
%>





<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>관리자 대시보드</title>
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">
<style type="text/css">
.content-container {
    position: fixed;
    top: 80px;
    left: 300px;
    right: 0;
    bottom: 0;
    padding: 20px;
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
    backdrop-filter: blur(10px);
    overflow-y: auto;
    scrollbar-width: thin;
    scrollbar-color: #667eea #f0f0f0;
}





.info {
    width: 80%;
    margin: 20px auto;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(20px);
    padding: 40px;
    border-radius: 20px;
    box-shadow: 
        0 8px 32px rgba(0, 0, 0, 0.1),
        0 0 0 1px rgba(255, 255, 255, 0.2),
        inset 0 1px 0 rgba(255, 255, 255, 0.5);
    border: 1px solid rgba(255, 255, 255, 0.3);
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

.info::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, #667eea, #764ba2, #f093fb);
    border-radius: 20px 20px 0 0;
}

.info:hover {
    transform: translateY(-5px);
    box-shadow: 
        0 12px 40px rgba(0, 0, 0, 0.15),
        0 0 0 1px rgba(255, 255, 255, 0.3),
        inset 0 1px 0 rgba(255, 255, 255, 0.6);
}

input.list {
    background: linear-gradient(135deg, #667eea, #764ba2);
    background-clip: text;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    border: none;
    color: #667eea; /* fallback for non-webkit browsers */
    text-decoration: none;
    cursor: pointer;
    font-size: 14px;
    font-family: inherit;
    font-weight: 500;
    padding: 8px 16px;
    border-radius: 20px;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
    margin: 0 8px;
}

input.list::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, #667eea, #764ba2);
    opacity: 0;
    border-radius: 20px;
    transition: opacity 0.3s ease;
    z-index: -1;
}

input.list:hover::before {
    opacity: 0.1;
}

input.list:hover {
    transform: translateY(-2px);
    text-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
    -webkit-text-fill-color: #667eea;
}

input.list:active {
    transform: translateY(0);
    transition: transform 0.1s ease;
}

/* 추가: 반응형 개선 */
@media (max-width: 1024px) {
    .content-container {
        left: 250px;
    }
    
    .info {
        width: 90%;
        padding: 30px;
    }
}

@media (max-width: 768px) {
    .content-container {
        position: relative;
        top: 0;
        left: 0;
        right: auto;
        bottom: auto;
        padding: 15px;
    }
    
    .info {
        width: 95%;
        padding: 25px;
        margin: 10px auto;
    }
    
    input.list {
        font-size: 16px; /* 모바일에서 더 큰 터치 타겟 */
        padding: 10px 18px;
    }
}
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* 제목 스타일링 */
h3 {
    color: #2c3e50;
    font-size: 1.5em;
    font-weight: 400;
    margin-bottom: 30px;
    text-align: center;
    padding-bottom: 15px;
    border-bottom: 2px solid #667eea;
    position: relative;
}

h3::after {
    content: '';
    position: absolute;
    bottom: -2px;
    left: 50%;
    transform: translateX(-50%);
    width: 50px;
    height: 2px;
    background: linear-gradient(90deg, #667eea, #764ba2);
    border-radius: 2px;
}

/* 프로필 이미지 컨테이너 개선 */
div[style*="width: 180px; height: 180px"] {
    width: 180px !important;
    height: 180px !important;
    border: 4px solid #e3f2fd !important;
    border-radius: 50% !important;
    overflow: hidden !important;
    margin: 0 auto 40px auto !important;
    box-shadow: 0 8px 25px rgba(0,0,0,0.1) !important;
    transition: all 0.3s ease !important;
    position: relative !important;
}

div[style*="width: 180px; height: 180px"]:hover {
    transform: scale(1.05) !important;
    box-shadow: 0 12px 35px rgba(102, 126, 234, 0.2) !important;
}

/* 프로필 이미지 스타일링 */
div[style*="width: 180px; height: 180px"] img {
    width: 100% !important;
    height: 100% !important;
    object-fit: cover !important;
    border-radius: 50% !important;
}

/* 테이블 전체 스타일링 */
table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    margin-top: 20px;
}

/* 테이블 행 스타일링 */
table tbody tr {
    transition: all 0.3s ease;
}

table tbody tr:hover {
    background-color: rgba(102, 126, 234, 0.05);
    transform: translateX(5px);
}

/* 테이블 셀 스타일링 */
table tbody td {
    padding: 15px 20px;
    border-bottom: 1px solid rgba(0,0,0,0.05);
    vertical-align: middle;
}

/* 첫 번째 열 (라벨) 스타일링 */
table tbody td:first-child {
    font-weight: 500;
    color: #666;
    width: 30%;
    font-size: 0.95em;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

/* 두 번째 열 (값) 스타일링 */
table tbody td:nth-child(2) {
    color: #2c3e50;
    font-weight: 600;
}

table tbody td:nth-child(2) strong {
    font-weight: 600;
    color: #2c3e50;
}

/* 마지막 행 (버튼 영역) 특별 스타일링 */
table tbody tr:last-child td {
    border-bottom: none;
    padding-top: 40px;
    background: none !important;
}

table tbody tr:last-child:hover {
    background: none !important;
    transform: none !important;
}

/* 링크 스타일 개선 */
a.list {
    display: inline-block;
    padding: 10px 20px;
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: white !important;
    text-decoration: none !important;
    border-radius: 25px;
    font-weight: 500;
    font-size: 14px;
    transition: all 0.3s ease;
    margin-right: 10px;
    box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
}

a.list:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
    background: linear-gradient(135deg, #5a6fd8, #6a4190);
}

/* 버튼 스타일 개선 (강제탈퇴) */
input.list[type="submit"] {
    background: linear-gradient(135deg, #ff6b6b, #ee5a24) !important;
    color: white !important;
    border: none !important;
    padding: 10px 20px !important;
    border-radius: 25px !important;
    font-weight: 500 !important;
    font-size: 14px !important;
    cursor: pointer !important;
    transition: all 0.3s ease !important;
    box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3) !important;
    text-decoration: none !important;
    -webkit-text-fill-color: white !important;
    background-clip: border-box !important;
    -webkit-background-clip: border-box !important;
}

input.list[type="submit"]:hover {
    transform: translateY(-2px) !important;
    box-shadow: 0 6px 20px rgba(255, 107, 107, 0.4) !important;
    background: linear-gradient(135deg, #ff5252, #d84315) !important;
}

/* 폼 인라인 스타일 조정 */
form[style*="display:inline"] {
    display: inline-block !important;
}

/* 브레이크 태그 제거 효과 */
br {
    display: none;
}

/* 간격 조정을 위한 마진 추가 */
.info h3 {
    margin-bottom: 30px;
}

.info table {
    margin-top: 30px;
}

/* 반응형 개선 */
@media (max-width: 768px) {
    table tbody td:first-child {
        width: 35%;
        font-size: 0.9em;
    }
    
    div[style*="width: 180px; height: 180px"] {
        width: 150px !important;
        height: 150px !important;
    }
    
    a.list, input.list[type="submit"] {
        display: block !important;
        margin: 5px 0 !important;
        text-align: center !important;
    }
}


.info {
    animation: fadeInUp 0.6s ease-out;
}

table tbody tr {
    animation: fadeInUp 0.6s ease-out;
}




</style>
<script type="text/javascript">

</script>


<jsp:include page="/common/jsp/admin_header.jsp" />
</head>
<body>
<div class="content-container" >

<div style="width: 40%; margin: 0px auto;" class= "info">
<h3><c:out value="${nonMember.userIdx}"/>님의 회원정보</h3>

<br><br><br>
			<table>
				<tbody>
					<tr>
						<td>생년월일</td>
						<td><strong><c:out value="${nonMember.birth}"/></strong></td>
					</tr>
					<tr>
						<td>이메일</td>
						<td><strong><c:out value="${nonMember.email}"/></strong></td>
					</tr>
					<tr>
						<td>생성일</td>
						<td><strong><fmt:formatDate value="${nonMember.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm:ss" /></strong></td>
					</tr>
					
					
					
					<tr>
					    <td colspan="2" style="text-align: right;">
					        <br><br><br>
					        <a href="member_table.jsp" class="list">회원리스트</a>
					    </td>
					</tr>
				</tbody>
			</table>
	</div>
</div>
</body>
</html>
