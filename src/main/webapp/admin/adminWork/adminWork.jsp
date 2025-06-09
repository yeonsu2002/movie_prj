<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/common/jsp/admin_header.jsp" />  
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>매니저 관리</title>  
<link rel="stylesheet" href="/movie_prj/common/css/admin.css">
<link rel="stylesheet" href="/movie_prj/common/css/adminWork.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/admin/adminWork/css/adminModal.css">
<style type="text/css">

</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script>

/* $(function() {}) 내부에는 초기 설정 코드, 초기 이벤트 바인딩, 이벤트 핸들러 등록만 넣는 것이 깔끔 */
$(function() { 
	
	<c:if test="${not empty errorMsg}">
		alert("${errorMsg}");
	</c:if>
	
	// 매니저 행 클릭 시 상세정보 표시
	$('.mgr-list-table tbody tr').click(function() {
		// 기존 선택 해제
		$('.mgr-list-table tbody tr').removeClass('mgr-selected');
		// 현재 행 선택
		$(this).addClass('mgr-selected');
		
		// 매니저 정보 가져오기 (data 속성에서)
		let managerId = $(this).data('manager-id');
		let managerName = $(this).find('.mgr-name').text().trim();
		let managerEmail = $(this).find('.mgr-email').text().trim();
		let managerPhone = $(this).find('.mgr-phone').text().trim();
		let managerStatus = $(this).find('.mgr-status').text().trim();
		let managerRole = $(this).find('.mgr-role').text().trim();
		let managerPicture = $(this).find('.mgr-picture img').attr('src');
		let managerIpList = $(this).find('.mgr-ipList').html();
		let managerLastLogin = $(this).find('.mgr-last-login').text().trim();
		let userIdx = $("#userIdx").val();
		
		// 상세정보 영역 업데이트
		updateManagerDetail(managerId, managerName, managerEmail, managerPhone, managerStatus, managerRole, managerPicture, managerIpList, managerLastLogin, userIdx);
	
	}); // end 매니저 행 클릭시 상세정보 표시 
	
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
	});// end 검색기능 
    
    // 검색input에서 엔터누르면 검색버튼 클릭됨 
    $('#mgrSearchInput').keypress(function(e) {
        if (e.which === 13) {
            $('#mgrSearchBtn').click();
        }
    });
    
    // 매니저 추가 버튼 클릭시 모달창 부름 
    $("#addManagerBtn").on("click", function(){
    	addManager("${pageContext.request.contextPath}/admin/adminWork/insertAdminForm.jsp");
    });
    
});
/*------------------------------- $(function(){}); 바깥에 정의하는 함수 : 전역스코프, 직접 호출, 재사용 가능 함수 정의------------------------------------------- */

// 매니저 상세정보 업데이트 함수
function updateManagerDetail(id, name, email, phone, status, role, picture, IpList, lastLoginDate, userIdx) {
    $('.mgr-profile-name').text(name + " 매니저");
    $('.mgr-profile-position').text("관리: " + role);
    
    // 상세정보 테이블 업데이트
    $('#mgrDetailId').text(id);
    $('#mgrDetailName').text(name);
    $('#mgrDetailEmail').text(email);
    $('#mgrDetailPhone').text(phone);
    $('#mgrDetailStatus').text(status);
    $('#mgrDetailArea').text(role);
    $('#mgrProfileImg').attr('src',  picture );
    $('#mgrDetailIp').html(IpList);
    $('#mgrDetailLastLogin').text(lastLoginDate);
    $("#userIdx").val(userIdx);
    
    // 빈 상태 숨기고 상세정보 표시
    $('.mgr-empty-state').hide();
    document.querySelector(".mgr-detail-content").style.display = "block";

    //$('.mgr-detail-content').show();
}

// 매니저 수정 버튼 함수  
function editManager() {
    let selectedRow = $('.mgr-selected');
    if (selectedRow.length === 0) {
        alert('수정할 매니저를 선택해주세요.');
        return;
    }
    let managerId = selectedRow.data('manager-id');
    
    // AJAX로 매니저 정보 조회
    $.ajax({
	    url: '${pageContext.request.contextPath}/admin/adminWork/controller/getUpdateAdminController.jsp',
	    type: 'GET',
	    data: { managerId: managerId },
	    dataType: 'json', // 서버에서 JSON을 받을 거라고 명시
	    success: function(data) {
				console.log( data); // JSON 객체 확인
				if (data.error) {
	      	alert(data.error);
		    }
        // 1. 모달창 매개변수 url초기화
        let getModalUrl = '${pageContext.request.contextPath}/admin/adminWork/updateAdminForm.jsp';
      	// 2. 모달jps 호출(매개변수: modal.jsp, modal에 넣을 data)
        updateManager(getModalUrl, data); //->udpateManager()에 모달창 데이터 채우기 함수가 들어있음 
	    },
	    error: function(xhr, status, error) {
	      console.error("에러 발생!");
	      console.log("status: ", status);
	      console.log("error: ", error);
	      console.log("xhr.status: ", xhr.status);
	      console.log("xhr.responseText: ", xhr.responseText);
	      alert("통신 오류가 발생했습니다.");
	    }
    });
}

// 매니저 비활성화 함수
function deleteManager() {
    var selectedRow = $('.mgr-selected');
    if (selectedRow.length === 0) {
        alert('비활성화 할 매니저를 선택해주세요.');
        return;
    }

    var managerId = selectedRow.data('manager-id');
    var managerName = selectedRow.find('.mgr-name').text();
    
    const isActive = selectedRow.find(".mgr-status").data("is-active");
    if (isActive !== 'Y') {
        alert(managerId + " 매니저는 이미 비활성화 상태입니다.");
        return;
    }
    
    if (confirm(managerName + ' 매니저를 정말 비활성화 하시겠습니까?')) {
				
        $.ajax({
        	url : "${pageContext.request.contextPath}/admin/adminWork/controller/deleteManagerController.jsp",
        	method : "post",
        	data : {managerId : managerId},
        	dataType : "json",
        	success : function(response){
        		if(response.result === "success"){
        			alert("매니저 비활성화 성공");
        			location.replace("${pageContext.request.contextPath}/admin/adminWork/controller/getAdminWorkController.jsp");
        		} else if (response.result === "fail"){
        			alert("매니저 비활성화 실패 ");
        		}
        	},
        	error : function(xhr, status, error){
						console.log("AJAX 요청 실패");
			 	    console.log("status: " + status);
			 	    console.log("error: " + error);
			 	    console.log("responseText: " + xhr.responseText);
					}
        });
    }
}

// 매니저 추가 모달창, modal 함수: fetch는 좀더 공부해봐야겠어
function addManager(url){ //fetch(url)로 서버에서 HTML 조각(fragment) 을 받아와서
	fetch(url)
		.then(response => response.text())
		.then(html => {
			const modalOverlay = document.querySelector('.modal-overlay');
			const modalBody = document.querySelector('.modal-body');
			modalBody.innerHTML = html;
			modalOverlay.style.display = 'flex';
			
			// 이 부분을 추가!
      setTimeout(() => {
        modalOverlay.classList.add('active');
      }, 10);
			
			// 모달이 로드된 후 이벤트 리스너 다시 등록, 동적생성이므로?
      setupModalEvents();
			validateForm();
			/*	1.	모달창 HTML 조각을 동적으로 불러옴 (fetch + innerHTML)
					2.	그 안에는 버튼이나 input 등 여러 요소들이 있음
					3.	이 요소들에 이벤트 리스너를 걸어야 함
					4.	그런데 처음부터 있는 DOM이 아니라 나중에 삽입된 거라, 이벤트 리스너도 삽입된 후에 등록해야 함
					5.	그래서 그걸 전담하는 함수가 setupModalEvents()처럼 하나로 묶여 있음
					6.	모달을 띄운 후 setupModalEvents()를 호출하면 제대로 연결되는 구조  */
			
		});
		
} // end 매니저 추가 모달 

// 매니저 수정 모달창
function updateManager(url, adminData) {
  $.ajax({
    url: url,
    method: 'GET',
    dataType: 'html', // 서버에서 HTML 조각을 받으니까
    success: function(html) {
      const modalOverlay = document.querySelector('.modal-overlay');
      const modalBody = document.querySelector('.modal-body');
      modalBody.innerHTML = html; // 모달 내용 동적으로 변경
      modalOverlay.style.display = 'flex';
      setTimeout(() => {
    	    modalOverlay.classList.add('active');
    	  }, 10); // 약간의 지연이 필요함

      // 모달이 로드된 후 이벤트 리스너 다시 등록
      setupModalEvents();
   		// 모달이 로드된 후 데이터 채우기
      fillModalWithData(adminData);  
    },
    error: function(xhr, status, error) {
      console.error('모달 로드 실패:', error);
    }
  });
} // end 매니저 수정 모달 


//이벤트리스너에 쓰일 모달닫기 함수 
function closeModal(){
	const modalOverlay = document.querySelector('.modal-overlay');
  modalOverlay.classList.remove('active');

  // transition 끝난 뒤 완전히 숨기기
  setTimeout(() => {
    modalOverlay.style.display = 'none';
  }, 300); // transition 시간과 동일하게
}


//이벤트리스너
document.addEventListener("DOMContentLoaded", () =>{
	
	//배경클릭시 닫기
	document.querySelector('.modal-overlay').addEventListener("click", (e) => {
    if (e.target.classList.contains('modal-overlay')) closeModal();
  });
	
});//end 이벤트리스너 

/* --------------------------------------모달창 js 함수 : 상위이벤트에 거는거 말고, 함수zip을 만들어서 모달 호출때 같이 호출하는 방식으로 리팩토링 하자-------------------------------------- */
//모달 이벤트 설정 함수 (모달생성 ajax에서 호출하여 이벤트리스너 재설정중 )
function setupModalEvents() {
	// 프로필 이미지 클릭 이벤트 (모달 내부)
	const profileImg = document.querySelector('.modal-body #mgrProfileImg2');
	const fileInput = document.querySelector('.modal-body #profileImageBtn');
	console.log("모달창의 요소(profileImg) : " + profileImg);
	console.log("모달창의 요소(fileInput) : " + fileInput);
	
	if (profileImg && fileInput) {
		profileImg.addEventListener('click', function() {
	    fileInput.click(); //이미지클릭 => 파일버튼 클릭 
		});
	     
		// 파일 변경 이벤트
		fileInput.addEventListener('change', function(e) {
    	const file = e.target.files[0];
    	
    	const lastDotIndex = file.name.lastIndexOf(".");
    	const fileName = file.name.substring(0, lastDotIndex); //파일이름에서 확장자 뺴고
    	 
    	const validNameRegex = /^[a-zA-Z0-9가-힣\-_]{1,20}$/; //정규식: 숫자,한글,영어 10자제한
    	if(!validNameRegex.test(fileName)){
    		alert("파일 이름은 숫자, 영문, 한글, -, _로만 이루어져야 하며, 20자 이하만 가능합니다.");
    		$(this).val('');//파일입력 초기화
    		return false;
    	}
		    
	    if (file && file.size > (1024 * 1024 * 10)) {
		    alert("파일첨부 사이즈는 10MB 이내로 가능합니다.");
		    fileInput.value = ''; //선택한 파일값 다시 비우고 
		    profileImg.src = "/movie_prj/common/img/default_img.png"; //프로필 미리보기 주소를 기본값으로 변경 
		    return false;
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
	
	//수정폼에 입력IP 추가 버튼 클릭 이벤트 - 수정된 버전
	$("#saveIpBtn").on("click", function(event){
		event.preventDefault();

		let inputedIp = $("#ipInput").val().trim();
		if (!inputedIp) {
			alert("IP를 입력해주세요.");
			return;
		}

		// IP 형식 검증 (선택사항)
		const ipPattern = /^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
		if (!ipPattern.test(inputedIp)) {
			alert("올바른 IP 형식을 입력해주세요. (예: 192.168.1.1)");
			return;
		}

		// 중복 IP 체크
		let isDuplicate = false;
		$("#allowedIpSelect option").each(function() {
			if ($(this).val() === inputedIp && $(this).val() !== "") {
				isDuplicate = true;
				return false; // each문 중단
			}
		});

		if (isDuplicate) {
			alert("이미 등록된 IP입니다.");
			return;
		}

		// 현재 등록된 IP 개수 체크 (빈 값이 아닌 옵션들만 카운트)
		let optionCount = $("#allowedIpSelect option").filter(function() {
			return $(this).val() !== "" && !$(this).prop("disabled");
		}).length;

		console.log("현재 등록된 IP 개수:", optionCount);

		if (optionCount >= 3) {
			alert("접속가능한 IP는 계정당 3개까지 허용됩니다.");
			return;
		}

		// 빈 슬롯 찾아서 IP 추가
		let addedSuccessfully = false;
		for(let i = 0; i < 3; i++){
			let option = $("#ipOption"+i);
			let realIpTag = $("#ipHidden"+i);
			
			if (option.val() === "none" || option.prop("disabled")) { //비어있을때 
				option.val(inputedIp);
				option.text(inputedIp);
				realIpTag.val(inputedIp);//히든창에 넘기기 
				option.prop("disabled", false);
				addedSuccessfully = true;
				break;
			}
		}

		if (addedSuccessfully) {
			$("#ipInput").val(""); // 입력창 초기화
			console.log("IP 추가 완료:", inputedIp);
		} else {
			alert("IP 추가에 실패했습니다.");
		}
	});

	// 추가: IP 삭제 시 해당 옵션을 완전히 초기화하는 로직도 수정
	$("#removeIpBtn").on("click", function(event){
		event.preventDefault();
		let selectedOption = $("#allowedIpSelect option:selected");
		
		if(selectedOption.length > 0){
			selectedOption.each(function(){ 
				
				//ID에서 index추출 -> ipOption1 에서 1추출
				let optionId = $(this).attr("id");
				let index = optionId.replace("ipOption", ""); //빼낸 id에서ipOpion글자 삭제 
				
				// 옵션을 초기화 
				$(this).val("");
				$(this).text("");
				$(this).prop("disabled", true);
				$(this).prop("selected", false); // 선택 해제
				
				//input타입 hidden도  초기화
				$("#ipHidden" + index).val("");
				
			});
			console.log("선택된 IP들이 삭제되었습니다.");
		} else {
			alert("삭제하실 IP를 선택하여주십시오.");
			return;
		}
	});

	// 수정폼에 수정 버튼 클릭 이벤트
	$('#updateBtn').click(function() {
	  if (!validateForm()) {
		  return;
	  } else {
	    $('#adminForm').submit();
	  }
	});
	
	// 추가폼에 등록 버튼 클릭 이벤트
	$('#submitBtn').click(function() {
	  if (!validateForm()) {
		  return;
	  } else {
	    $('#insertAdminForm').submit();
	  }
	});
	
	
	
	// 수정폼에 취소 버튼 클릭 이벤트
	$('#cancelBtn').click(function() {
	  $('.modal-overlay').hide() ; // 모달 닫기
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
	  
	  if (!$('#adminPwd').val().trim()) {
	    alert('비밀번호를 입력해주세요.ㅋ');
	    $('#adminPwd').focus();
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
	  } else {
		  let phone1 = $('#phone1').val();
		  let phone2 = $('#phone2').val();
		  let phone3 = $('#phone3').val();
		  let fullPhone = phone1 + '-' + phone2 + '-' + phone3;
		  
	    let phoneRegex = /^[0-9\-]+$/;

	    if (!phoneRegex.test(fullPhone)) {
        alert('연락처에는 숫자만 입력할 수 있습니다.');
        return false;
      }
	    
	    $('#phone').val(fullPhone);
	  }
	
	  if ($('#manageArea').val() === 'none') {
	    alert('관리영역을 선택해주세요.');
	    $('#manageArea').focus();
	    return false;
	  }

	  
	  //이것도 체크해돠 
		let selectedOption = $("#allowedIpSelect option:selected");
	  //or
	 	const select = document.getElementById('allowedIpSelect');
		const options = select.options;
		let count = 0;
		for(let i = 0; i < options.length; i++){
			if(!options[i].disabled){
				count++;
			}
		}
	  if (count < 1) {
	    alert('접속IP를 하나 이상 입력해주세요.');
	    $('#ipInput').focus();
	    return false;
	  }
	
	  return isValid;
	}
	
}//setup modal evnet()

//매니저 정보 수정 모달 폼에 데이터 채우기 
function fillModalWithData(adminData) {
	console.log(adminData);
  // 기본 정보 채우기
  $('#adminId').val(adminData.adminId);
  //$('#adminPwd').val(adminData.adminPwd);
  $('#adminName').val(adminData.adminName);
  $('#adminEmail').val(adminData.adminEmail);
  
  // 연락처 분리해서 채우기
  if (adminData.tel) {
    let phoneParts = adminData.tel.split('-');
	  console.log( "phoneParts : "+ phoneParts);
    if (phoneParts.length === 3) {
      $('#phone1').val(phoneParts[0]);
      $('#phone2').val(phoneParts[1]);
      $('#phone3').val(phoneParts[2]);
    }
  }
  
  // 관리영역 선택
  $('#manageArea').val(adminData.manageArea);
  
  // 프로필 이미지 재설정 
  $('#mgrProfileImg2').attr('src', '${pageContext.request.contextPath}/common/img/default_img.png'); // 기본 이미지 등
  /* if (adminData.picture) {
	  //$('#mgrProfileImg2').attr('src', '/profile/' + adminData.picture); //input file값을 주는게 아님. 단순히 이미지출력임
	  //$("#profileImageBtn").val(adminData.picture); //input file에는 자바스크립트로 값을 줄 수 없음. 보안위반사항이래 
	  
	} */ 
  
  //유저 idx넘기기
  if(adminData.userIdx) {
	  $("#userIdx").val(adminData.userIdx);
  }
	
	//IP리스트 붙여넣기 
	if(adminData.iplist.length < 4) { //iplist가 3개까지만 제한  
		const ipList = adminData.iplist.map(item => item.ipAddress);
		for(let i = 0; i < ipList.length; i++){
			$("#ipOption"+i).text(ipList[i]);
			$("#ipOption"+i).val(ipList[i]);
			$("#ipHidden"+i).val(ipList[i]);
			$("#ipOption"+i).prop("disabled", false);
		}

	}
}// end fillModalWithData()
 

</script>
</head>
<body>

	<!-- 모달 구조 -->
	<div class="modal-overlay">
	  <div class="admin-modal-content">
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
						<th>관리영역</th>
						<th>상태</th>
						<th>최종로그인</th>
					</tr>
				</thead>
				<tbody>
				<c:choose>
					<c:when test="${empty managerList }">
						<tr>
							<td colspan="7" onclick="event.stopPropagation();">조회가능한 매니저가 존재하지 않습니다. </td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="manager" items="${managerList }" varStatus="status">
							<tr data-manager-id="${manager.adminId}">
								<td>${status.index +1 }</td>
								<td class="mgr-picture" style="display: none"><img src="/profile/${manager.picture }"> </td>
								<td class="mgr-name"><c:out value="${manager.adminName }" /> </td>
								<td class="mgr-email"><c:out value="${manager.adminEmail }" /> </td>
								<td class="mgr-phone"><c:out value="${manager.tel }" /> </td>
								<c:choose>
									<c:when test="${manager.manageArea == 'ManageMember' }"><td class="mgr-role">회원</td></c:when>
									<c:when test="${manager.manageArea == 'ManageMovie' }"><td class="mgr-role">영화</td></c:when>
									<c:when test="${manager.manageArea == 'ManageSchedule' }"><td class="mgr-role">상영스케줄</td></c:when>
									<c:when test="${manager.manageArea == 'ManageInquiry' }"><td class="mgr-role">공지/문의</td></c:when>
									<c:otherwise>현재 관리영역이 부여되지 않았습니다.</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${manager.isActive == 'N' }">
										<td class="mgr-status" data-is-active="${manager.isActive}" ><span class="mgr-status-badge mgr-status-active" style="background-color: #e03800; color: white;"><c:out value="${manager.isActive == 'Y' ? '활성' : '비활성'}" /> </span></td>
									</c:when>
									<c:otherwise>
										<td class="mgr-status" data-is-active="${manager.isActive}" ><span class="mgr-status-badge mgr-status-active"><c:out value="${manager.isActive == 'Y' ? '활성' : '비활성'}" /> </span></td>
									</c:otherwise>
								</c:choose>
								<td class="mgr-last-login">${manager.formattedLoginDate }</td>
								<!-- fmt:formatDate는 오직 java.util.Date타입만 포맷 가능.. -->
								<td class="mgr-ipList" style="display: none">
									<c:forEach var="ip" items="${manager.IPList}">
									  ${ip.ipAddress}<br>
									</c:forEach>
								</td>
								<td style="display: none" id="userIdx" class="mgr-userIdx">${manager.userIdx }</td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
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
<!-- 					<button class="mgr-btn mgr-btn-reset" onclick="resetPassword()">비밀번호 초기화</button> -->
					<button class="mgr-btn mgr-btn-delete" onclick="deleteManager()">비활성화</button>
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
					<img src="/profile/${manager.picture }" alt="프로필 사진" class="mgr-profile-img" id="mgrProfileImg">
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
						<th>계정 상태</th>
						<td id="mgrDetailStatus">-</td>
					</tr>
					<tr>
						<th>최종 로그인</th>
						<td id="mgrDetailLastLogin"></td>
					</tr>
					<tr>
						<th>권한 레벨</th>
						<td id="mgrDetailAuthLevel">레벨 2 (일반관리자)</td>
					</tr>
					<tr>
						<th>관리 영역</th>
						<td id="mgrDetailArea">1관, 2관, 3관</td>
					</tr>
					<tr>
						<th>접속 허용 IP</th>
						<td id="mgrDetailIp"></td>
					</tr>
				</table>

			</div>

		</div>

	</div>

</body>
</html>