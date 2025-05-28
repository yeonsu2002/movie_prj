<%@page import="kr.co.yeonflix.member.BoardUtil"%>
<%@page import="kr.co.yeonflix.member.PageNationDTO"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />


<jsp:useBean id="rDTO" class="kr.co.yeonflix.member.RangeDTO" scope="page"/>
<jsp:setProperty name="rDTO" property="*" />



  

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

body {
	font-family: sans-serif;
	padding: 40px;
}

h2 {
	margin-bottom: 20px;
	text-align: center;
}

table {
	width: 60%;
	border-collapse: collapse;
	margin: 0 auto;
}

th, td {
	padding: 12px;
	text-align: center;
	border-bottom: 1px solid #ddd;
}

th {
	background-color: #f5f5f5;
}


</style>
<script type="text/javascript">
$(function(){
	
	$("#btnSearch").click(function(){
		var keyword = $("#keyword").val();
		
		if(keyword == ""){
			alert("검색 키워드는 필수 입력");
			//early return
			return;
		} //end if
		 $("#searchFrm").submit(); // ✅ submit 추가
		
	}); //click
	
}); // ready
</script>

</head>
<body>

<div class="content-container">
<%
MemberService ms = new MemberService();

int totalCount = 0;
totalCount = ms.totalCount(rDTO);

// 한 화면에 출력할 게시물의 수
int pageScale = 0;
pageScale = ms.pageScale();

// 총 페이지의 수
int totalPage = 0;
totalPage = ms.totalPage(totalCount, pageScale);

// 페이지 게시물 시작 번호
int startNum;
startNum = ms.startNum(pageScale, rDTO);

// 페이지 게시물 끝 번호
int endNum;
endNum = ms.endNum(pageScale, rDTO);

// 게시물 리스트
List<MemberDTO> memberList = ms.searchAllMember(rDTO);

String queryStr = "&field=" + rDTO.getField() + "&keyword=" + rDTO.getKeyword();
pageContext.setAttribute("queryStr", queryStr);

// 검색 조건 항목 설정
String[] fieldText = { "아이디", "닉네임" };

pageContext.setAttribute("totalCount", totalCount);
pageContext.setAttribute("pageScale", pageScale);
pageContext.setAttribute("totalPage", totalPage);
pageContext.setAttribute("startNum", rDTO.getStartNum());
pageContext.setAttribute("endNum", rDTO.getEndNum());
pageContext.setAttribute("memberList", memberList);
pageContext.setAttribute("fieldText", rDTO.getFieldText());
// request 속성에 값 저장 (JSTL에서 사용)
pageContext.setAttribute("rDTO", rDTO);



%> 





	<br>
		<h2>회원 목록</h2>
	<br>
	  <div id="searchDiv" style="text-align: center;">
        <form action="member_table.jsp" id="searchFrm" method="get">
            <select name="field" id="field">
                <c:forEach var="field" items="${fieldText}" varStatus="i">
                    <option value="${i.index}" <c:if test="${i.index == rDTO.field}">selected</c:if>>
                        <c:out value="${field}" />
                    </option>
                </c:forEach>
            </select>
            <input type="text" name="keyword" id="keyword" value="${rDTO.keyword}" />
            <input type="button" value="검색" id="btnSearch" class="btn btn-success btn-sm" />
        </form>
	</div>
	<br><br>
	
	<table>
    <thead>
      <tr>
        <th>아이디</th>
        <th>닉네임</th>
        <th>탈퇴여부</th>
      </tr>
    </thead>
  	<tbody>
  	<c:if test="${ empty memberList }">
			<tr>
				<td colspan="5" style="text-align: center;">
					등록된 회원이 없습니다.<br>
					
					<br>
				</td>
			</tr>
		</c:if>
  	
			<c:forEach var="member_list" items="${memberList}" varStatus="i">
			<tr>
			<td>
				<a href="member_detail.jsp?member_id=${member_list.memberId}&currentPage=${rDTO.currentPage}${queryStr}">
    			<c:out value="${member_list.memberId}" />
				</a>
				</td>
				<td><c:out value="${member_list.nickName}" /></td>
				<td>
					<c:choose>
						<c:when test="${member_list.isActive eq 'Y'}">활동중</c:when>
						<c:otherwise>탈퇴</c:otherwise>
					</c:choose>
				</td> 
				
			
				<td></td>
			</tr>
			
			</c:forEach>
	</tbody>
</table>
<div id="pagenationDiv" style="text-align: center;">
<%
PageNationDTO pDTO = new PageNationDTO(3, rDTO.getCurrentPage(), totalPage, "member_table.jsp",
		rDTO.getField(), rDTO.getKeyword());
%>
<%= BoardUtil.pagination(pDTO) %>
</div>



</div>
</body>
</html>
