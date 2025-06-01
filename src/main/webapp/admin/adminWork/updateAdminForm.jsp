<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"
  info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:import url="/common/jsp/external_file.jsp"/>
<script>
  $(document).ready(function() {
    // 수정 버튼 클릭 이벤트
    $('#updateBtn').click(function() {
      if (validateForm()) {
        $('#adminForm').submit();
      }
    });

    // 취소 버튼 클릭 이벤트
    $('#cancelBtn').click(function() {
      $('#adminModal').modal('hide'); // 모달 닫기
    });

    // 폼 검증 함수
    function validateForm() {
      let isValid = true;

      // 필수 필드 검증
      if (!$('#adminName').val().trim()) {
        alert('이름을 입력해주세요.');
        $('#adminName').focus();
        return false;
      }

      if (!$('#adminEmail').val().trim()) {
        alert('이메일을 입력해주세요.');
        $('#adminEmail').focus();
        return false;
      }

      if (!$('#phone1').val() || !$('#phone2').val() || !$('#phone3').val()) {
        alert('연락처를 모두 입력해주세요.');
        return false;
      }

      if ($('#manageArea').val() === 'none') {
        alert('관리영역을 선택해주세요.');
        $('#manageArea').focus();
        return false;
      }

      return isValid;
    }
  });
</script>
<div id="container">
  <!-- 프로필 섹션 -->
  <form action="${pageContext.request.contextPath}/admin/adminWork/controller/updateAdminProcessController.jsp" 
    id="adminForm" method="post" enctype="multipart/form-data">
    
    <div class="mgr-profile-section" style="display:flex; justify-content: center; align-items: center; flex-direction: column;">
      <img src="http://localhost/movie_prj/common/img/default_img.png" alt="프로필 사진" class="mgr-profile-img" id="mgrProfileImg">
      <input type="file" id="profileImageBtn" class="profile-image" name="profileImage" accept="image/*" style="display: none">
      <div class="mgr-profile-name">매니저</div>
    </div>
    
    <table class="mgr-detail-table">
      <tr>
        <th>매니저 ID</th>
        <td id="mgrDetailId">
          <input id="adminId" name="adminId" class="input-info" type="text" readonly>
          <div class="error-message id" style="display:none;">중복된 ID입니다.</div>
        </td>
      </tr>
      <tr>
        <th>비밀번호</th>
        <td id="mgrDetailPwd">
          <input id="adminPwd" name="adminPwd" class="input-info" type="password" maxlength="12">
        </td>
      </tr>
      <tr>
        <th>이름</th>
        <td id="mgrDetailName">
          <input id="adminName" name="adminName" class="input-info" type="text">
        </td>
      </tr>
      <tr>
        <th>이메일</th>
        <td id="mgrDetailEmail">
          <input id="adminEmail" name="adminEmail" class="input-info" type="email">
          <div class="error-message email" style="display:none;">중복된 email입니다.</div>
        </td>
      </tr>
      <tr>
        <th>연락처</th>
        <td id="mgrDetailTel">
          <div class="phone-inputs">
            <input type="tel" id="phone1" class="join3_form-input" required maxlength="3" placeholder="010">
            <span>-</span>
            <input type="tel" id="phone2" class="join3_form-input" required maxlength="4" placeholder="1234">
            <span>-</span>
            <input type="tel" id="phone3" class="join3_form-input" required maxlength="4" placeholder="5678">
            <input type="hidden" id="phone" name="phone" value="">
          </div>
        </td>
      </tr>
      <tr>
        <th>관리영역</th>
        <td id="mgrDetailRole">
          <select id="manageArea" name="manageArea">
            <option value="none" disabled>선택</option>
            <option value="ManageMember">회원</option>
            <option value="ManageMovie">영화</option>
            <option value="ManageSchedule">상영스케줄</option>
            <option value="ManageInquiry">공지/문의</option>
          </select>
        </td>
      </tr>
      <tr>
        <th>계정 상태</th>
        <td id="mgrDetailStatus">
          <select name="accountStatus" class="input-info">
            <option value="active">활성</option>
            <option value="inactive">비활성</option>
            <option value="suspended">정지</option>
          </select>
        </td>
      </tr>
      <tr>
        <th>등록일</th>
        <fmt:formatDate var="today" value="<%=new Date() %>" pattern="yyyy-MM-dd"/>
        <td id="mgrDetailRegDate">
          <input class="input-info" type="text" value="${today}" style="text-align: center;" name="insertDate" readonly>
        </td>
      </tr>
    </table>
    
    <div class="btn-group-right">
      <button type="button" id="cancelBtn" class="btn btn-secondary">취소</button>
      <button type="button" id="updateBtn" class="btn btn-primary">수정</button>
    </div>
  </form>
</div>
