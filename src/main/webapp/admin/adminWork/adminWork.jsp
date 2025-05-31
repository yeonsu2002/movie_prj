<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- <c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" /> --%>
<jsp:include page="/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>매니저 관리</title>
<link rel="stylesheet" href="http://localhost/movie_prj/common/css/admin.css">
<link rel="stylesheet" href="http://localhost/movie_prj/common/css/adminWork.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/admin/adminWork/css/adminWork.css">
<style type="text/css">

</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script>
/* $(function() {}) 내부에는 초기 설정 코드, 초기 이벤트 바인딩, 이벤트 핸들러 등록만 넣는 것이 깔끔 */
$(function() { 
	
	<c:if test="${not empty errorMsg}">
		alert("${errorMsg}");
	</c:if>
	<c:if test="${not empty managerList}">
    alert("매니저 리스트가 로딩되었습니다. 총 ${fn:length(managerList)}명");
	</c:if>
	
	
    // 매니저 행 클릭 시 상세정보 표시
    $('.mgr-list-table tbody tr').click(function() {
        // 기존 선택 해제
        $('.mgr-list-table tbody tr').removeClass('mgr-selected');
        // 현재 행 선택
        $(this).addClass('mgr-selected');
        
        // 매니저 정보 가져오기 (data 속성에서)
        var managerId = $(this).data('manager-id');
        var managerName = $(this).find('.mgr-name').text();
        var managerEmail = $(this).find('.mgr-email').text();
        var managerPhone = $(this).find('.mgr-phone').text();
        var managerStatus = $(this).find('.mgr-status').text();
        var managerRole = $(this).find('.mgr-role').text();
        
        // 상세정보 영역 업데이트
        updateManagerDetail(managerId, managerName, managerEmail, managerPhone, managerStatus, managerRole);
    });
    
    // 검색 기능
    $('#mgrSearchBtn').click(function() {
        var searchText = $('#mgrSearchInput').val().toLowerCase();
        var searchType = $('#mgrSearchType').val();
        
        $('.mgr-list-table tbody tr').each(function() {
            var show = false;
            
            if (searchType === 'all' || searchType === 'name') {
                if ($(this).find('.mgr-name').text().toLowerCase().includes(searchText)) {
                    show = true;
                }
            }
            if (searchType === 'all' || searchType === 'email') {
                if ($(this).find('.mgr-email').text().toLowerCase().includes(searchText)) {
                    show = true;
                }
            }
            
            if (searchText === '' || show) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
    });
    
    // 엔터키로 검색
    $('#mgrSearchInput').keypress(function(e) {
        if (e.which === 13) {
            $('#mgrSearchBtn').click();
        }
    });
    
    // 매니저 추가 버튼 클릭시
    $("#addManagerBtn").on("click", function(){
    	addManager("insertAdminForm.jsp");
    });
    
});
/* $(function(){}); 바깥에 정의하는 함수 : 전역스코프, 직접 호출, 재사용 가능 함수 정의 */

// 매니저 상세정보 업데이트 함수
function updateManagerDetail(id, name, email, phone, status, role) {
    $('.mgr-profile-name').text(name);
    $('.mgr-profile-position').text(role);
    
    // 상세정보 테이블 업데이트
    $('#mgrDetailId').text(id);
    $('#mgrDetailName').text(name);
    $('#mgrDetailEmail').text(email);
    $('#mgrDetailPhone').text(phone);
    $('#mgrDetailStatus').text(status);
    $('#mgrDetailRole').text(role);
    
    // 빈 상태 숨기고 상세정보 표시
    $('.mgr-empty-state').hide();
    document.querySelector(".mgr-detail-content").style.display = "block";

    //$('.mgr-detail-content').show();
}

// 매니저 추가 함수
function addManager() {
    alert('매니저 추가 기능을 구현해주세요.');
    
    // 실제로는 모달창이나 새 페이지로 이동
}

// 매니저 수정 함수  
function editManager() {
    var selectedRow = $('.mgr-selected');
    if (selectedRow.length === 0) {
        alert('수정할 매니저를 선택해주세요.');
        return;
    }
    
    var managerId = selectedRow.data('manager-id');
    alert('매니저 ID ' + managerId + ' 수정 기능을 구현해주세요.');
    // 실제로는 수정 폼으로 이동하거나 모달 표시
}

// 매니저 삭제 함수
function deleteManager() {
    var selectedRow = $('.mgr-selected');
    if (selectedRow.length === 0) {
        alert('삭제할 매니저를 선택해주세요.');
        return;
    }
    
    var managerId = selectedRow.data('manager-id');
    var managerName = selectedRow.find('.mgr-name').text();
    
    if (confirm(managerName + ' 매니저를 정말 삭제하시겠습니까?')) {
        alert('매니저 ID ' + managerId + ' 삭제 기능을 구현해주세요.');
        // 실제로는 서버에 삭제 요청 전송
    }
}

// 비밀번호 초기화 함수
function resetPassword() {
    var selectedRow = $('.mgr-selected');
    if (selectedRow.length === 0) {
        alert('비밀번호를 초기화할 매니저를 선택해주세요.');
        return;
    }
    
    var managerId = selectedRow.data('manager-id');
    var managerName = selectedRow.find('.mgr-name').text();
    
    if (confirm(managerName + ' 매니저의 비밀번호를 초기화하시겠습니까?')) {
        alert('매니저 ID ' + managerId + ' 비밀번호 초기화 기능을 구현해주세요.');
        // 실제로는 서버에 비밀번호 초기화 요청
    }
}

/* modal 함수: fetch는 좀더 공부해봐야겠어  */
function addManager(url){
	console.log("addManger 버튼 클릭");
	fetch(url)
		.then(response => response.text())
		.then(html => {
			const modalOverlay = document.querySelector('.modal-overlay');
			const modalBody = document.querySelector('.modal-body');
			modalBody.innerHTML = html;
			modalOverlay.style.display = 'flex';
			
			// 모달이 로드된 후 이벤트 리스너 다시 등록
      setupModalEvents();
			
		});
}
function closeModal(){
	document.querySelector('.modal-overlay').style.display = 'none';
}

//이벤트리스너
document.addEventListener("DOMContentLoaded", () =>{
	
	document.getElementById("modalCloseBtn").addEventListener("click", closeModal);
	
	//배경클릭시 닫기
	document.querySelector('.modal-overlay').addEventListener("click", (e) => {
    if (e.target.classList.contains('modal-overlay')) closeModal();
  });
	
});


/* --------------------------------------모달창 js-------------------------------------- */
//모달 이벤트 설정 함수
function setupModalEvents() {
	console.log("모달 이벤트 설정");
	
	// 프로필 이미지 클릭 이벤트 (모달 내부)
	const profileImg = document.querySelector('.modal-body #mgrProfileImg');
	const fileInput = document.querySelector('.modal-body #profileImageBtn');
	
	if (profileImg && fileInput) {
		profileImg.addEventListener('click', function() {
	    fileInput.click();
		});
	    
		// 파일 변경 이벤트
		fileInput.addEventListener('change', function(e) {
    	const file = e.target.files[0];
		    
	    if (file && file.size > (1024 * 1024 * 10)) {
		    alert("파일첨부 사이즈는 10MB 이내로 가능합니다.");
		    fileInput.value = '';
		    profileImg.src = "http://localhost/movie_prj/common/img/default_img.png";
		    return;
	    }
		    
	    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
        	profileImg.src = e.target.result;
        };
        reader.readAsDataURL(file);
	    }
  	});
	} else {
  	console.log("모달 내 요소를 찾을 수 없습니다.");
	}
}

/* 모달 input 예외처리 검증  */


/* 모달이 동적으로 생성되기 때문에 이벤트 위임을 써야해 */
// form 등록 
$(document).on("click", "#submitBtn", function(){
	alert("adminForm 제출");
	$("#adminForm").submit();
	
});

 

</script>
</head>
<body>

	<!-- 모달 구조 -->
	<div class="modal-overlay">
	  <div class="admin-modal-content">
	    <span id="modalCloseBtn" class="modal-close">&times;</span>
	    <div class="modal-body"></div>
	  </div>
	</div>

	<!-- 매니저 관리 메인 컨테이너 -->
	<div class="mgr-container">

		<!-- 왼쪽: 매니저 리스트 영역 -->
		<div class="mgr-list-section">

			<!-- 리스트 헤더 -->
			<div class="mgr-list-header">
				<h2 class="mgr-list-title">매니저 목록</h2>
				<button class="mgr-add-btn" id="addManagerBtn">+ 매니저 추가</button>
			</div>

			<!-- 검색 필터 영역 -->
			<div class="mgr-search-section">
				<div class="mgr-search-form">
					<select id="mgrSearchType" class="mgr-search-select">
						<option value="all">전체</option>
						<option value="name">이름</option>
						<option value="email">이메일</option>
					</select> <input type="text" id="mgrSearchInput" class="mgr-search-input"
						placeholder="검색어를 입력하세요">
					<button id="mgrSearchBtn" class="mgr-search-btn">검색</button>
				</div>
			</div>

			<!-- 매니저 리스트 테이블 -->
			<table class="mgr-list-table">
				<thead>
					<tr>
						<th>ID</th>
						<th>이름</th>
						<th>이메일</th>
						<th>연락처</th>
						<th>역할</th>
						<th>상태</th>
						<th>최신접속일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="manager" items="${managerList }" varStatus="status">
						<tr data-manager-id="${manager.userIdx}">
							<td>${status.index +1 }</td>
							<td class="mgr-name"><c:out value="${manager.adminName }" /> </td>
							<td class="mgr-email"><c:out value="${manager.adminEmail }" /> </td>
							<td class="mgr-phone">미구현 </td>
							<td class="mgr-role"><c:out value="${manager.manageArea }" /> </td>
							<td class="mgr-status"><span class="mgr-status-badge mgr-status-active"><c:out value="${manager.isActive == 'Y' ? '활성' : '비활성'}" /> </span></td>
							<td>${manager.formattedLoginDate }</td>
							<!-- fmt:formatDate는 오직 java.util.Date타입만 포맷 가능.. -->
						</tr>
					</c:forEach>

					<!-- 실제 JSP에서는 다음과 같이 구현 -->
					<%-- 
                <c:forEach var="manager" items="${managerList}" varStatus="status">
                    <tr data-manager-id="${manager.managerId}">
                        <td>${manager.managerId}</td>
                        <td class="mgr-name">${manager.managerName}</td>
                        <td class="mgr-email">${manager.email}</td>
                        <td class="mgr-phone">${manager.phone}</td>
                        <td class="mgr-role">${manager.role}</td>
                        <td class="mgr-status">
                            <span class="mgr-status-badge ${manager.status == 'Y' ? 'mgr-status-active' : 'mgr-status-inactive'}">
                                ${manager.status == 'Y' ? '활성' : '비활성'}
                            </span>
                        </td>
                        <td><fmt:formatDate value="${manager.regDate}" pattern="yyyy-MM-dd"/></td>
                    </tr>
                </c:forEach>
                --%>
				</tbody>
			</table>

		</div>

		<!-- 오른쪽: 매니저 상세정보 영역 -->
		<div class="mgr-detail-section">

			<!-- 상세정보 헤더 -->
			<div class="mgr-detail-header">
				<h2 class="mgr-detail-title">매니저 상세정보</h2>
				<div class="mgr-action-buttons">
					<button class="mgr-btn mgr-btn-edit" onclick="editManager()">수정</button>
					<button class="mgr-btn mgr-btn-reset" onclick="resetPassword()">
						비밀번호 초기화</button>
					<button class="mgr-btn mgr-btn-delete" onclick="deleteManager()">삭제</button>
				</div>
			</div>

			<!-- 매니저 선택 전 빈 상태 표시 -->
			<div class="mgr-empty-state">
				<div class="mgr-empty-icon">👤</div>
				<h3>매니저를 선택해주세요</h3>
				<p>왼쪽 목록에서 매니저를 클릭하면 상세정보가 표시됩니다.</p>
			</div>

			<!-- 상세정보 내용 (처음에는 숨김) -->
			<div class="mgr-detail-content" style="display: none;">

				<!-- 프로필 섹션 -->
				<div class="mgr-profile-section">
					<img src="http://localhost/movie_prj/common/images/default_profile.png" alt="프로필 사진" class="mgr-profile-img" id="mgrProfileImg">
					<div class="mgr-profile-name">매니저명</div>
					<div class="mgr-profile-position">직책</div>
				</div>

				<!-- 상세정보 테이블 -->
				<table class="mgr-detail-table">
					<tr>
						<th>매니저 ID</th>
						<td id="mgrDetailId">-</td>
					</tr>
					<tr>
						<th>이름</th>
						<td id="mgrDetailName">-</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td id="mgrDetailEmail">-</td>
					</tr>
					<tr>
						<th>연락처</th>
						<td id="mgrDetailPhone">-</td>
					</tr>
					<tr>
						<th>역할/직책</th>
						<td id="mgrDetailRole">-</td>
					</tr>
					<tr>
						<th>계정 상태</th>
						<td id="mgrDetailStatus">-</td>
					</tr>
					<tr>
						<th>등록일</th>
						<td id="mgrDetailRegDate">-</td>
					</tr>
					<tr>
						<th>최종 로그인</th>
						<td id="mgrDetailLastLogin">2024-05-28 14:30:25</td>
					</tr>
					<tr>
						<th>권한 레벨</th>
						<td id="mgrDetailAuthLevel">레벨 2 (일반관리자)</td>
					</tr>
					<tr>
						<th>관리 영역</th>
						<td id="mgrDetailArea">1관, 2관, 3관</td>
					</tr>
				</table>

			</div>

		</div>

	</div>

</body>
</html>