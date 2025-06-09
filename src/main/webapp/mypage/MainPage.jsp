<%@page import="kr.co.yeonflix.inquiry.inquiryDTO"%>
<%@page import="kr.co.yeonflix.inquiry.inquiryDAO"%>
<%@page import="kr.co.yeonflix.member.MemberDAO"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@page import="kr.co.yeonflix.reservation.ShowReservationDTO"%>
<%@page import="kr.co.yeonflix.reservation.ReservationDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.reservation.ReservationService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // 로그인한 사용자 userIdx 가져오기
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

	if (loginUser == null) {
    // 로그인 안된 상태 -> 로그인 페이지로 이동
   	 	response.sendRedirect(request.getContextPath() + "/login/loginFrm.jsp");
   		 return;
	}

	int loginUserIdx = loginUser.getUserIdx();

    // 회원 정보 조회
    MemberService ms = new MemberService();
    MemberDAO mm=MemberDAO.getInstance();
    MemberDTO mDTO=mm.selectOneMember(loginUserIdx);

    // JSP에 member 객체 넘기기
    request.setAttribute("member", mDTO);

// 예약 리스트 조회
ReservationService rs = new ReservationService();
List<ShowReservationDTO> reservationList = rs.searchDetailReservationWithUser(loginUserIdx);

//에매내역 최신순으로
reservationList.sort((r1, r2) -> r2.getReservationDate().compareTo(r1.getReservationDate()));


request.setAttribute("reservationList", reservationList);

//문의내역
String inquiryParam=request.getParameter("inquiry_board_idx");

inquiryDAO iDAO = new inquiryDAO();
List<inquiryDTO> inquiryList = iDAO.selectAllinquiry(String.valueOf(loginUserIdx));
request.setAttribute("inquiryList", inquiryList);

inquiryDTO iDTO = iDAO.selectinquiry(inquiryParam);
request.setAttribute("iDTO", iDTO);
%>

 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<c:import url="http://localhost/movie_prj/common/jsp/external_file.jsp"/>
<style>
 .profile-container {
	max-width: 800px;
	margin: 40px auto;
	font-family: 'Arial', sans-serif;
	color: #333;
}

.profile-header {
	display: flex;
	align-items: center;
	border-bottom: 1px solid #eee;
	gap: 40px;
	padding-bottom: 20px;
	margin-bottom: 20px;
}

.profile-img {
	width: 120px;
	height: 120px;
	border-radius: 100%;
	background-color: #ddd;
	margin-right: 40px;
}

.profile-info h2 {
	margin: 10;
	font-size: 24px;
	color: #222;
}

.user-id {
	font-size: 14px;
	color: #888;
	margin-left: 15px;
}

.user-nick {
	font-size: 14px;
	color: #888;
	margin-left: 15px;
}

.edit-btn {
	margin-left: 15px;
	font-size: 12px;
	padding: 5px 8px;
	cursor: pointer;
	background-color: transparent;
	border: 1px solid #aaa;
	border-radius: 4px;
}



.button-row {
  display: flex;
  justify-content: center;
  gap: 40px;
  margin-top: 30px;
}

.button-row > div {
  width: 250px;
  height: 120px;
  background-color: #F8F8F8;
  border: 1px solid #333;
  border-radius: 1px;
  text-align: center;
  padding: 20px 10px;
  transition: all 0.3s ease;
  box-shadow: 2px 2px 10px rgba(0,0,0,0.05);
  cursor: pointer;
}

.button-row > div:hover {
  background-color: #DC201A;
  color: white;
  transform: translateY(-5px);
  box-shadow: 4px 4px 15px rgba(0,0,0,0.15);
}

.button-row a {
  display: block;
  text-decoration: none;
  color: inherit;
  font-weight: bold;
  font-size: 16px;
}

.button-row .wish label {
  font-weight: normal;
  font-size: 12px;
  color: #666;
  display: block;
  margin-top: 10px;
}
.button-row .watch label {
  font-weight: normal;
  font-size: 12px;
  color: #666;
  display: block;
  margin-top: 10px;
}
.button-row .review label {
  font-weight: normal;
  font-size: 12px;
  color: #666;
  display: block;
  margin-top: 10px;
}

.button-row > div:hover label {
  color: #ccc;
}

 
 
  
.content-container {
	background-color: white;
	border-radius: 10px;
	box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
	padding: 25px;
	margin-bottom: 30px;
}

.delete {
	display: flex;
	justify-content: right;
	margin-top: 15px;
	gap: 10px; /* 버튼 사이 간격 설정 */
}

delete-r{

	display: flex;
	justify-content: right;
	margin-top: px;

}

.header-container {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 5px;
}



#container {
	min-height: 650px;
	margin-top: 30px;
	margin-left: 20px
}

</style>
<script type="text/javascript">
$(document).ready(function () {
	
	$(document).on('change', 'input[name="reservationIdx"]', function() {
	    // 다른 체크박스들 모두 해제 (하나만 선택 가능)
	    $('input[name="reservationIdx"]').not(this).prop('checked', false);
	    
	    // 사용자가 방금 클릭한 체크박스의 value를 저장
	    var selectedValue = $(this).val();
	    // 그 체크박스가 현재 체크됐는지 여부를 저장
	    var isChecked = $(this).is(':checked');
	    
	    if (isChecked) {
	    	
	        $.ajax({
	            url: '/movie_prj/reservation/booking_modal.jsp',
	            method: 'GET',
	            data: { reservationIdx: selectedValue },
	            success: function(response) {
	                // 기존 모달이 있다면 제거
	                $('#bookingModal').remove();
	                
	                // 새로운 모달을 body에 추가
	                $('body').append(response);
	                
	                console.log('예매내역 데이터 로드 완료:', selectedValue);
	            },
	            error: function() {
	                alert('예매내역을 불러오는데 실패했습니다.');
	                $(this).prop('checked', false);
	            }
	        });
	    } else {
	        // 체크박스가 해제된 경우 모달 제거
	        $('#bookingModal').remove();
	    }
	});

	// 예매내역 출력 버튼 클릭 시
	$("#btnShowDetail").click(function () {
    var selectedCheckbox = $("input[name='reservationIdx']:checked");

    if (selectedCheckbox.length === 0) {
        alert("출력할 예매내역을 선택하세요.");
        return;
    }

    var statusText = selectedCheckbox.closest("tr").find("td:eq(4)").text().trim();
    if (statusText === "예매취소") {
        alert("취소된 예매입니다. 출력할 수 없습니다.");
        return;
    }

    // 모달이 존재하는지 확인 후 표시
    if ($('#bookingModal').length > 0) {
        $('#bookingModal').fadeIn();
    } else {
        alert("예매내역을 먼저 선택해주세요.");
    }
});
	
   
	$(document).on('click', '#closeModalBtn', function() {
        $('#bookingModal').fadeOut();
    });
    
    $(document).on('click', '.close-btn', function() {
        $('#bookingModal').fadeOut();
    });


	$("#btnDeleteReservations").click(function() {
	    const selected = $("input[name='reservationIdx']:checked").val();

	    if (!selected) {
	        alert("취소할 예매를 선택하세요.");
	        return;
	    }

	    if (!confirm("정말 취소하시겠습니까?")) {
	        return;
	    }
	    
	    const statusText = $("input[name='reservationIdx']:checked").closest("tr").find("td:eq(4)").text().trim();
	    if (statusText === "예매취소") {
	        alert("이미 취소된 예매입니다.");
	        return;
	    }

	    $.ajax({
	        url: '/movie_prj/reservation/deleteReservation.jsp',
	        method: 'POST',
	        data: { reservationIdx: selected },
	        success: function(response) {
	            if (response.success) {
	                alert("취소 완료!");
	                location.reload();
	            } else {
	                alert("취소 실패했습니다.");
	            }
	        },
	        error: function() {
	            alert("서버 요청 중 오류 발생.");
	        }
	    });
	});
	
	$("#btnInquiry").click(function () {
	    const selected = $("input[name='choose']:checked")
	        .map(function () {
	            return $(this).val();
	        }).get();

	    if (selected.length === 0) {
	        alert("삭제할 문의내역을 선택하세요.");
	        return;
	    }

	    if (!confirm("정말 삭제하시겠습니까?")) {
	        return;
	    }

	    $.ajax({
	        url: '/movie_prj/inquiry/inquiry_delete.jsp',
	        method: 'POST',
	        traditional: true,
	        data: { choose: selected },
	        success: function () {
	            alert("삭제 완료!");
	            location.reload();
	        },
	        error: function () {
	            alert("삭제 실패했습니다.");
	        }
	    });
	});

	
});//ready



</script>
</head>
<body>
<header>
<jsp:include page="/common/jsp/header.jsp" />
</header>
<main>
<div id="container">
<div class="profile-container">
	<div class="profile-header">
	 <c:choose>
     <c:when test="${not empty member.picture}">
		<img src="/profile/${member.picture}" alt="프로필이미지"  style="width:130px; height:130px"/>
	 </c:when>
	<c:otherwise>
		 <img src="/movie_prj/common/img/default_img.png" style="width:130px; height:130px" id="img" alt="기본이미지"/>
	</c:otherwise>
	 </c:choose>
    <div class="profile-info">
   		 <h2>
         	<c:out value="${member.userName}" />
      		<span class="user-id">아이디:<c:out value="${member.memberId}" /></span>
      		<span class="user-nick">닉네임:<c:out value="${member.nickName}" /></span>
   		 </h2>
   		 <br>
    		<a href="http://localhost/movie_prj/mypage/loginFrm.jsp">✏️ 수정</a>
  </div>
  </div>

<div class="button-row">
 <div class="wish">
    <a href="http://localhost/movie_prj/mypage/wishMovie.jsp"  >
    ❤️ <br><br>기대되는 영화<br><label>보고싶은 영화들을 미리<br> 담아두고 싶다면?</label></a>
</div>
 <div class="watch">
    <a href="http://localhost/movie_prj/mypage/WatchMovie.jsp"  >
    📹<br><br>내가 본 영화<br><label>관람한 영화들을 한번에<br>모아 보고 싶다면?</label></a>
 </div>
<div class="review">
    <a href="http://localhost/movie_prj/mypage/ReviewMovie.jsp"  >
    📄<br><br>내가 쓴 평점<br><label>관람 후 내 감상평을 적어<br> 추억하고 싶다면?</label></a>
</div>   
</div>
<br><br><br>

<div class="header-container">
 <h2>My 예매내역 <span class="badge bg-secondary">${fn:length(reservationList)}건</span></h2>

 <div class="delete-r">
 	<input type="button" data-idx="8" value="예매 취소" class="btn btn-secondary" id="btnDeleteReservations"/>
 	<input type="button" value="예매 내역 출력" class="btn btn-danger" id="btnShowDetail"/>
 </div>
 </div>
 <br>
 <div class="content-container">
        <div class="empty-message">
               <table class="table table-striped table-hover">
  <thead>
    <tr>
      <th scope="col" width="5%"></th>
      <th scope="col">제목</th>
      <th scope="col">상영관</th>
      <th scope="col">관람일시</th>
      <th scope="col">결과</th>
      <th scope="col">일시</th>
    </tr>
  </thead>
  <tbody>
  <c:if test="${empty reservationList}">
    <tr>
      <td colspan="5" style="text-align:center; color:gray;">예매내역이 없습니다.</td>
    </tr>
  </c:if>

  <c:forEach var="ticket" items="${reservationList}">
   <tr>
  <td>
    <input class="form-check-input" type="checkbox" name="reservationIdx"
           value="${ticket.reservationIdx}"
           <c:if test="${param.reservationIdx == ticket.reservationIdx}">checked</c:if>>
</td>
  <td>${ticket.movieName}</td>
  <td>${ticket.theaterName}</td>
  <td>${ticket.screenDate}</td>
  <td>
    <c:choose>
        <c:when test="${ticket.canceledDate == null}">
            <span style="color: blue;">결제완료</span>
        </c:when>
        <c:otherwise>
           <span style="color: red;">예매취소</span>
        </c:otherwise>
    </c:choose>
</td>
  <td>
    <c:choose>
        <c:when test="${ticket.canceledDate == null}">
      	  <fmt:formatDate value="${ticket.reservationDate}" pattern="yyyy-MM-dd HH:mm"/>
        </c:when>
        <c:otherwise>
           <fmt:formatDate value="${ticket.canceledDate}" pattern="yyyy-MM-dd HH:mm"/>
        </c:otherwise>
    </c:choose>
</td>
</tr>
  </c:forEach>
</tbody>
</table>
        </div>
    </div>
 <br><br><br>
 
 <!--  -------------------------------------------------------------------------------------------------------  -->
 
 <div class="header-container">
 <h2>My 문의내역 <span class="badge bg-secondary">${fn:length(inquiryList)}건</span></h2>
 <div class="delete">
 <input type="button" id="btnInquiry" value="선택삭제" class="btn btn-secondary"/>
 <a href="http://localhost/movie_prj/inquiry/inquiry_add.jsp" class="btn btn-danger">문의하기</a>
 </div>
 </div>
 <br>
 <div class="content-container">
      <table class="table table-striped table-hover">
  <thead>
    <tr>
      <th scope="col" width="5%"></th>
      <th scope="col">유형</th>
      <th scope="col">제목</th>
      <th scope="col">등록일</th>
      <th scope="col">상태</th>
    </tr>
  </thead>
 <tbody>
 <c:if test="${empty inquiryList}">
    <tr>
      <td colspan="5" style="text-align:center; color:gray;">문의내역이 없습니다.</td>
    </tr>
  </c:if>
 
  <c:forEach var="inquiry" items="${inquiryList}">
    <tr>
     <td>
    <input class="form-check-input" type="checkbox" name="choose"
       value="${inquiry.inquiry_board_idx}">
       
  </td>
      <td>${inquiry.board_code_name}</td>
      
      <td>
	  	<a href="${pageContext.request.contextPath}/inquiry/inquiry_user.jsp?idx=${inquiry.inquiry_board_idx}&userIdx=${member.userIdx}">
  <c:out value="${inquiry.inquiry_title}" />
</a>
	 </td>
      <td>${inquiry.created_time}</td>
      
  
      <td>
      
  <c:choose>
   		 <c:when test="${inquiry.answer_status == 1}">
     		 답변 완료
    	</c:when>
    	<c:otherwise>
      		답변중
    	</c:otherwise>
  </c:choose>
	</td>
    </tr>
</c:forEach>
</tbody>
</table>
    </div>
</div>
</div>

</main>

<c:if test="${not empty param.reservationIdx }">
 <c:import url="/reservation/booking_modal.jsp">
    <c:param name="reservationIdx" value="${param.reservationIdx}" />
  </c:import>
</c:if>
<footer>
<c:import url="http://localhost/movie_prj/common/jsp/footer.jsp"/>
</footer>

</body>
</html>  