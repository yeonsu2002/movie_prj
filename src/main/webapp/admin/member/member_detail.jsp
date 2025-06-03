<%@page import="kr.co.yeonflix.member.MemberDAO"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />



<%
    // URL 파라미터에서 member_id 값 받아오기 (String 타입)
    String userIdxStr = request.getParameter("userIdx");
	int userIdx=0;

    // memberId가 null이거나 빈 값이면 에러 처리하거나 기본값 설정 가능
    if (userIdxStr == null || userIdxStr.trim().isEmpty()) {
        // 예: 에러 페이지 이동 또는 기본 처리
        out.println("회원 아이디가 전달되지 않았습니다.");
        return; // 더 이상 진행하지 않음
    }
    
    
    try{
    	userIdx=Integer.parseInt(userIdxStr);
	    out.println("userIdx = " + userIdx);
    	
    }catch(NumberFormatException e){
    	out.println("유효하지 않은 회원입니다.");
    	return;
    	
    }

    // MemberService 또는 DAO 호출해서 해당 회원 정보 조회
    MemberService ms = new MemberService();
    MemberDTO mDTO =ms.searchOneMember(userIdx);

    // 조회한 회원 정보를 JSP에서 사용할 수 있도록 속성으로 저장
    pageContext.setAttribute("member", mDTO);
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
	background-color: #f0f0f0;
	
	}
	
.info {
	width: 80%;
	margin: 0 auto;
	background-color: white;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
	}
	
input.list {
    background: none;
    border: none;
    color: blue;
    text-decoration: underline;
    cursor: pointer;
    font-size: 14px;
    font-family: inherit;
}


</style>
<script type="text/javascript">

</script>



</head>
<body>
<div class="content-container" >

<div style="width: 40%; margin: 0px auto;" class= "info">
<h3><c:out value="${member.memberId}"/>님의 회원정보</h3>
    <%-- ${member} --%>
<div style="width: 180px; height: 180px; border: 1px solid #dedede;">
    <c:choose>
        <c:when test="${not empty member.picture}">
            <img src="/profile/${member.picture}"/>
        </c:when>
        <c:otherwise>
            <img src="/common/img/default_img.png" style="width:180px; height:180px" id="img"/>
        </c:otherwise>
    </c:choose>
</div>
<br><br><br>
			<table>
				<tbody>
					
					<tr>
						<td>이름</td>
						<td><strong><c:out value="${member.userName}"/></strong></td>
					</tr>
					<tr>
						<td>닉네임</td>
						<td><strong><c:out value="${member.nickName}"/></strong></td>
					</tr>
					<tr>
						<td>이메일</td>
						<td><strong><c:out value="${member.email}"/></strong></td>
					</tr>
					<tr>
						<td>전화번호</td>
						<td><strong><c:out value="${member.tel }"/></strong></td>
					</tr>
					<tr>
						<td>가입일</td>
						<td><strong><fmt:formatDate value="${member.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm:ss" /></strong></td>
					</tr>
					<tr>
						<td>생년월일</td>
						<td><strong><c:out value="${member.birth}"/></strong></td>
					</tr>
					
					<tr>
					    <td colspan="2" style="text-align: right;">
					        <br><br><br>
					        <a href="member_table.jsp" class="list">회원리스트</a>
					        
					        <form action="member_delete.jsp" method="post" style="display:inline;">
					            <input type="hidden" name="userIdx" value="${member.userIdx}"/>
					            <input type="submit" value="강제탈퇴" class="list"
					                   onclick="return confirm('정말 이 회원을 강제 탈퇴시키겠습니까?');"/>
					        </form>
					    </td>
					</tr>
				</tbody>
			</table>
	</div>
</div>
</body>
</html>
