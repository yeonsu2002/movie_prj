<%@page import="kr.co.yeonflix.member.NonMemberService"%>
<%@page import="kr.co.yeonflix.member.NonMemberDTO"%>
<%@page import="kr.co.yeonflix.member.BoardUtil"%>
<%@page import="kr.co.yeonflix.member.PageNationDTO"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<<<<<<< HEAD
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />
=======
<jsp:include page="/common/jsp/admin_header.jsp" />
>>>>>>> 7c53767ecaa3c0ae1d644b48a437658a4fe81110

<jsp:useBean id="rDTO" class="kr.co.yeonflix.member.RangeDTO" scope="page"/>
<jsp:setProperty name="rDTO" property="*" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>관리자 대시보드</title>
<link rel="stylesheet" href="http://localhost/movie_prj/admin/member/css/pageNation.css">
<link rel="stylesheet"
	href="http://localhost/movie_prj/common/css/admin.css">
<style type="text/css">
* {
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    margin: 0;
    padding: 0;
    min-height: 100vh;
}

.content-container {
    position: fixed;
    top: 80px;
    left: 300px;
    right: 0;
    bottom: 0;
    padding: 30px;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    overflow-y: auto;
}

/* 제목 스타일링 */
h2 {
    margin-bottom: 30px;
    text-align: center;
    color: #333;
    font-size: 28px;
    font-weight: 600;
    position: relative;
    padding: 20px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}



/* 검색 영역 스타일링 */
#searchDiv {
    background: white;
    padding: 25px;
    border-radius: 10px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    margin-bottom: 25px;
    border: 1px solid rgba(0, 0, 0, 0.05);
}

#searchDiv select,
#searchDiv input[type="text"] {
    padding: 12px 18px;
    border: 2px solid #e1e8ed;
    border-radius: 8px;
    font-size: 16px;
    transition: all 0.3s ease;
    margin: 0 8px;
}

#searchDiv select {
    min-width: 120px;
    cursor: pointer;
}

#searchDiv input[type="text"] {
    min-width: 200px;
}



/* 버튼 스타일링 */
.btn {
    padding: 12px 25px;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    margin: 0 5px;
    position: relative;
    overflow: hidden;
}



.btn-success {
    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
    color: white;
}



.btn-secondary {
    background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
    color: white;
}

/* 테이블 스타일링 */
table {
    width: 100%;
    border-collapse: collapse;
    margin: 0 auto;
    background: white;
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    border: 1px solid rgba(0, 0, 0, 0.05);
}

th {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 20px 15px;
    text-align: center;
    font-weight: 600;
    font-size: 16px;
    position: relative;
}


td {
    padding: 18px 15px;
    text-align: center;
    border-bottom: 1px solid #f0f0f0;
    vertical-align: middle;
    transition: all 0.3s ease;
}


/* 활동중/탈퇴 상태 스타일링 */
tr:has(td:last-child:contains("활동중")) td:last-child {
    color: #28a745;
    position: relative;
}

tr:has(td:last-child:contains("활동중")) td:last-child::before {
    content: '\f058';
    font-family: 'Font Awesome 6 Free';
    font-weight: 900;
    margin-right: 8px;
}

tr:has(td:last-child:contains("탈퇴")) td:last-child {
    color: #dc3545;
    position: relative;
}

tr:has(td:last-child:contains("탈퇴")) td:last-child::before {
    content: '\f057';
    font-family: 'Font Awesome 6 Free';
    font-weight: 900;
    margin-right: 8px;
}


</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){
	
	$("#btnSearch").click(function(){
		var keyword = $("#keyword").val();
		
		if(keyword == ""){
			alert("검색 키워드는 필수 입력");
			//early return
			return;
		} //end if
		 $("#searchFrm").submit(); 
		
		 
		 
	}); //click
	
	$("#btnReset").click(function () {
	    // 검색 필드 초기화
	    $("#keyword").val("");
	    // 검색 조건 기본값 선택 (필요 시)
	    $("#field").prop("selectedIndex", 0);
	    // 폼 제출해서 초기 상태로 페이지 새로고침
	    $("#searchFrm").submit();
	  });
	
	 toggleTable();
}); // ready

	
	function toggleTable() {
	    const type = document.getElementById("typeSelect").value;
	    document.getElementById("memberTable").style.display = type === "member" ? "table" : "none";
	    document.getElementById("nonMemberTable").style.display = type === "nonmember" ? "table" : "none";
	}
	
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
String[] fieldText = {  "이름", "전화번호", "이메일"  };

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


<%--
/* NonMemberService nms=new NonMemberService();
List<NonMemberDTO> nonMemberList = nms.searchAllNonMember(rDTO); 
pageContext.setAttribute("nonMemberList", nonMemberList);
 */


--%>

 

	<br>
		<h2>회원 목록</h2>
	<br>
	  <div id="searchDiv" style="text-align: center;">
	
	<div style="text-align: left;" >
    <select id="typeSelect" name="userType" onchange="toggleTable()">
        <option value="member" <c:if test="${param.userType == 'member' || param.userType == null}">selected</c:if>>회원</option>
        <option value="nonmember" <c:if test="${param.userType == 'nonmember'}">selected</c:if>>비회원</option>
    </select>
	</div>
        <form action="member_table.jsp" id="searchFrm" method="get">
          <input type="hidden" name="currentPage" value="1" />
            <select name="field" id="field">
                <c:forEach var="field" items="${fieldText}" varStatus="i">
                    <option value="${i.index}" <c:if test="${i.index == rDTO.field}">selected</c:if>>
                        <c:out value="${field}" />
                    </option>
                </c:forEach>
            </select>
            <input type="text" name="keyword" id="keyword" value="${rDTO.keyword}" />
  		  <input type="button" value="검색" id="btnSearch" class="btn btn-success btn-sm" />
  		  <input type="button" value="초기화" id="btnReset" class="btn btn-secondary btn-sm" />
        </form>
	</div>
	<br><br>
	<h2 style="text-align: left;">회원 수: <span class="badge bg-secondary" style="font-weight: left;">${fn:length(memberList)}건</span></h2>
	<table id="memberTable">
    <thead>
      <tr>
        <th>아이디</th>
        <th>이름</th>
        <th>전화번호</th>
        <th>이메일</th>
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
				  <a href="member_detail.jsp?userIdx=${member_list.userIdx}&currentPage=${rDTO.currentPage != null ? rDTO.currentPage : 1}${queryStr != null ? queryStr : ''}">
    			<c:out value="${member_list.memberId}" />
				</a>
				</td>
				<td><c:out value="${member_list.userName}" /></td>
				<td><c:out value="${member_list.tel}" /></td>
				<td><c:out value="${member_list.email}" /></td>
				<td>
					<c:choose>
						<c:when test="${member_list.isActive eq 'Y'}">활동중</c:when>
						<c:otherwise>탈퇴</c:otherwise>
					</c:choose>
				</td> 
				
			
			</tr>
			
			</c:forEach>
	</tbody>
</table>
<table id="nonMemberTable" style="display: none;">
  <thead>
    <tr>
      <th>비회원 번호</th>
      <th>생년월일</th>
      <th>이메일</th>
      <th>생성일</th>
    </tr>
  </thead>
 <tbody>
  	<c:if test="${ empty nonMemberList }">
			<tr>
				<td colspan="5" style="text-align: center;">
					등록된 비회원이 없습니다.<br>
					
					<br>
				</td>
			</tr>
		</c:if>
  	
			<c:forEach var="NonMember_list" items="${nonMemberList}" varStatus="i">
			<tr>
				
				<td><c:out value="${NonMember_list.userIdx}" /></td>
				<td><c:out value="${NonMember_list.birth}" /></td>
				<td><c:out value="${NonMember_list.email}" /></td>
				<td><c:out value="${NonMember_list.createdAt}" /></td>
			</tr>
			
			</c:forEach>
	</tbody>
</table>
<br><br>

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
