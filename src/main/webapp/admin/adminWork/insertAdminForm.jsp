<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:import url="/common/jsp/external_file.jsp"/>

<div id="container">
	<!-- 프로필 섹션 -->
	<form action="" id="adminForm" method="post" enctype="multipart/form-data">
		<div class="mgr-profile-section" style="display:flex; justify-content: center; align-items: center; flex-direction: column;">
			<img src="http://localhost/movie_prj/common/img/default_img.png" alt="프로필 사진" class="mgr-profile-img" id="mgrProfileImg">
			<input type="file" id="profileImageBtn" class="profile-image" name="profileImage" accept="image/*" style="display: none">
			<div class="mgr-profile-name">매니저</div>
		</div>
		<table class="mgr-detail-table">
			<tr>
				<th>매니저 ID</th>
				<td id="mgrDetailId"><input class="input-info" type="text"><div class="error-message id">중복된 ID입니다.</div> </td>
			</tr>
			<tr>
			<tr>
				<th>비밀번호</th>
				<td id="mgrDetailPhone"><input class="input-info" type="text" maxlength="12"></td>
			</tr>
				<th>이름</th>
				<td id="mgrDetailName"><input class="input-info" type="text"></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td id="mgrDetailEmail"><input class="input-info" type="text"><div class="error-message email">중복된 email입니다.</div></td>
			</tr>
			<tr>
				<th>연락처</th>
				<td id="mgrDetailPhone"><input class="input-info" type="text"></td>
			</tr>
			<tr>
				<th>관리영역</th>
				<td id="mgrDetailRole">
					<select>
						<option value="none" selected disabled>선택</option>
						<option value="ManageMember">회원</option>
						<option value="ManageMovie">영화</option>
						<option value="ManageSchedule">상영스케줄</option>
						<option value="ManageInquiry">공지/문의</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>계정 상태</th>
				<td id="mgrDetailStatus"><input class="input-info" type="text" value="활성" readonly></td>
			</tr>
			<tr>
				<th>등록일</th>
				<fmt:formatDate var="today" value="<%=new Date() %>" pattern="yyyy-MM-dd"/>
				<td id="mgrDetailRegDate"><input class="input-info" type="text" value="${today}" readonly> </td>
			</tr>
		</table>
		<div class="btn-group-right">
			<button type="reset" id="resetBtn" class="btn btn-secondary ">초기화</button>
			<button type="button" id="submitBtn" class="btn btn-primary">등록</button>
		</div>
	</form>
</div>
