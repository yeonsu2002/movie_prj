<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="/common/jsp/external_file.jsp" />
<script>
	/* 해당 script에서 이벤트리스너 등록 비추천, 오류가능성 duo. 상위요소에서 재등록하길 추천  */
</script>

<div id="container">
	<!-- 프로필 섹션 -->
	<form
		action="${pageContext.request.contextPath}/admin/adminWork/controller/updateAdminController.jsp"
		id="adminForm" method="post" enctype="multipart/form-data">

		<div class="mgr-profile-section"
			style="display: flex; justify-content: center; align-items: center; flex-direction: column;">
			<img src="${pageContext.request.contextPath }/common/img/default_img.png"
				alt="프로필 사진" class="mgr-profile-img" id="mgrProfileImg2"> <input
				type="file" id="profileImageBtn" class="profile-image"
				name="profileImage" accept="image/*" style="display: none">
			<div class="mgr-profile-name">프로필 사진을 선택해주세요.</div>
		</div>

		<table class="mgr-detail-table">
			<tr>
				<th>매니저 ID</th>
				<td id="mgrDetailId"><input id="adminId" name="adminId"
					class="input-info" type="text" readonly></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td id="mgrDetailPwd"><input id="adminPwd" name="adminPwd"
					class="input-info" type="password" maxlength="12"></td>
			</tr>
			<tr>
				<th>이름</th>
				<td id="mgrDetailName"><input id="adminName" name="adminName"
					class="input-info" type="text"></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td id="mgrDetailEmail"><input id="adminEmail"
					name="adminEmail" class="input-info" type="email">
					<div class="error-message email" style="display: none;">중복된
						email입니다.</div></td>
			</tr>
			<tr>
				<th>연락처</th>
				<td id="mgrDetailTel">
					<div class="phone-inputs">
						<input type="tel" id="phone1" class="join3_form-input" required
							maxlength="3" placeholder="010"> <span>-</span> <input
							type="tel" id="phone2" class="join3_form-input" required
							maxlength="4" placeholder="1234"> <span>-</span> <input
							type="tel" id="phone3" class="join3_form-input" required
							maxlength="4" placeholder="5678"> <input type="hidden"
							id="phone" name="phone" value="">
					</div>
				</td>
			</tr>
			<tr>
				<th>관리영역</th>
				<td id="mgrDetailRole"><select id="manageArea"
					name="manageArea">
						<option value="none" disabled>선택</option>
						<option value="ManageMember">회원</option>
						<option value="ManageMovie">영화</option>
						<option value="ManageSchedule">상영스케줄</option>
						<option value="ManageInquiry">공지/문의</option>
				</select></td>
			</tr>
			<tr>
				<th>계정 상태</th>
				<td id="mgrDetailStatus"><select name="accountStatus"
					class="input-info">
						<option value="Y">활성</option>
						<option value="N">비활성</option>
				</select></td>
			</tr>
			<tr>
				<th>접속 IP관리</th>
				<td id="mgrDetailIP"><select id="allowedIpSelect"
					name="allowedIp" multiple size="3" style="height: 100px;">
						<option id="ipOption0" value="none" disabled></option>
						<option id="ipOption1" value="none" disabled></option>
						<option id="ipOption2" value="none" disabled></option>
				</select> <input type="hidden" name="ipOption0" id="ipHidden0"> <input
					type="hidden" name="ipOption1" id="ipHidden1"> <input
					type="hidden" name="ipOption2" id="ipHidden2"> <!-- 와,, option태그는 name을 무시하는지 몰랐네  -->
					<div class="ip-input" style="display: flex">
						<input id="ipInput" class="ipInput" placeholder="IP를 입력해주세요."
							style="height: 55.19px;">
						<button id="saveIpBtn" class="btn btn-primary btn-sm">입력
							IP 추가</button>
						<button id="removeIpBtn" class="btn btn-danger btn-sm">선택
							IP 삭제</button>
					</div></td>
			</tr>
		</table>
		<div class="btn-group-right">
			<button type="button" id="cancelBtn" class="btn btn-secondary">취소</button>
			<button type="button" id="updateBtn" class="btn btn-primary">수정</button>
			<input type="hidden" id="userIdx" name="userIdx" value="">
		</div>
	</form>
</div>
