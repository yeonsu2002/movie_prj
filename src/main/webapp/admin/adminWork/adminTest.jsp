<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>매니저 관리</title>
<link rel="stylesheet" href="http://localhost/movie_prj/common/css/admin.css">
<link rel="stylesheet" href="http://localhost/movie_prj/common/css/adminWork.css">
<style type="text/css">

</style>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script>
$(function() {
    
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
});

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
</script>
</head>
<body>

	<!-- 매니저 관리 메인 컨테이너 -->
	<div class="mgr-container">

		<!-- 왼쪽: 매니저 리스트 영역 -->
		<div class="mgr-list-section">

			<!-- 리스트 헤더 -->
			<div class="mgr-list-header">
				<h2 class="mgr-list-title">매니저 목록</h2>
				<button class="mgr-add-btn" onclick="addManager()">+ 매니저 추가</button>
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
						<th>등록일</th>
					</tr>
				</thead>
				<tbody>
					<!-- 샘플 데이터 - 실제로는 서버에서 가져온 데이터를 JSTL로 출력 -->
					<tr data-manager-id="1">
						<td>1</td>
						<td class="mgr-name">김매니저</td>
						<td class="mgr-email">kim@movie.com</td>
						<td class="mgr-phone">010-1234-5678</td>
						<td class="mgr-role">시설관리팀장</td>
						<td class="mgr-status"><span
							class="mgr-status-badge mgr-status-active">활성</span></td>
						<td>2024-01-15</td>
					</tr>
					<tr data-manager-id="2">
						<td>2</td>
						<td class="mgr-name">이관리</td>
						<td class="mgr-email">lee@movie.com</td>
						<td class="mgr-phone">010-2345-6789</td>
						<td class="mgr-role">상영관리팀</td>
						<td class="mgr-status"><span
							class="mgr-status-badge mgr-status-active">활성</span></td>
						<td>2024-02-20</td>
					</tr>
					<tr data-manager-id="3">
						<td>3</td>
						<td class="mgr-name">박운영</td>
						<td class="mgr-email">park@movie.com</td>
						<td class="mgr-phone">010-3456-7890</td>
						<td class="mgr-role">고객서비스팀</td>
						<td class="mgr-status"><span
							class="mgr-status-badge mgr-status-inactive">비활성</span></td>
						<td>2024-03-10</td>
					</tr>
					<tr data-manager-id="4">
						<td>4</td>
						<td class="mgr-name">최시설</td>
						<td class="mgr-email">choi@movie.com</td>
						<td class="mgr-phone">010-4567-8901</td>
						<td class="mgr-role">시설관리팀</td>
						<td class="mgr-status"><span
							class="mgr-status-badge mgr-status-active">활성</span></td>
						<td>2024-04-05</td>
					</tr>
					<tr data-manager-id="5">
						<td>5</td>
						<td class="mgr-name">정보안</td>
						<td class="mgr-email">jung@movie.com</td>
						<td class="mgr-phone">010-5678-9012</td>
						<td class="mgr-role">보안관리팀</td>
						<td class="mgr-status"><span
							class="mgr-status-badge mgr-status-active">활성</span></td>
						<td>2024-05-01</td>
					</tr>

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