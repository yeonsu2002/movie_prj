<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
function logout(){
	location.href="${pageContext.request.contextPath}/admin/login/controller/logoutController.jsp";
}
</script>
<div class="sidebar">
	<c:if test="${empty loginAdmin }">
		<script type="text/javascript">
			alert("접근권한이 존재하지 않습니다.\n로그인 페이지로 이동합니다.");
			location.href="${pageContext.request.contextPath}/admin/login/adminLoginForm.jsp";
		</script>
	</c:if>
	<!-- 사이드바 -->
    <!-- 로고 영역 -->
    <div class="logo-container">
        <div class="logo-img">
            <img src="${pageContext.request.contextPath}/common/img/logo.png" alt="메인 로고" />
        </div>
        <div class="logo-text">관리자 페이지</div>
    </div>
    
    <!-- 프로필 영역 -->
    <div class="profile-container">
        <div class="profile-img">
        		<c:if test="${empty loginAdmin.picture }">
	            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
        		</c:if>
        		<c:if test="${not empty loginAdmin.picture }">
        			<img alt="관리자사진" src="/profile/${loginAdmin.picture }" style="width: 70px; height:70px; border-radius: 5em;" >
        		</c:if>
        </div>
        <div class="profile-info">
            <span class="profile-title">
            <c:choose>
            	<c:when test="${loginAdmin.manageArea == 'ManageMember' }"> 🧑‍💼회원 관리자</c:when>
            	<c:when test="${loginAdmin.manageArea == 'ManageMovie' }"> 🎬영화 관리자</c:when>
            	<c:when test="${loginAdmin.manageArea == 'ManageSchedule' }"> 🗓️상영 관리자</c:when>
            	<c:when test="${loginAdmin.manageArea == 'ManageInquiry' }"> 📝문의/답변 관리자</c:when>
            	<c:when test="${loginAdmin.manageArea == '전체' }"> 👑총관리자 </c:when>
            	<c:otherwise>관리영역 미지정 관리자</c:otherwise>
            </c:choose>
            </span>
            <span class="profile-name"><c:out value="${loginAdmin.adminName }" /></span>
        </div>
    </div>
    
    <!-- 메뉴 영역 -->
    <div class="menu-category">
			<div class="menu-title">관리자 관리</div>
			<c:choose>
				<c:when test="${loginAdmin.manageArea eq '전체'}">
					<div class="menu-item"><a href="${pageContext.request.contextPath }/admin/adminWork/controller/getAdminWorkController.jsp"> <span>▶</span>관리자 목록</a></div>
				</c:when>
				<c:otherwise>
					<div class="menu-item"><a href="javascript:void(0);" onclick="alert('접근 권한이 없습니다.');"> <span>▶</span>관리자 목록</a></div>
				</c:otherwise>
			</c:choose>
    </div>
    
    <div class="menu-category">
    	<div class="menu-title">회원 관리</div>
		 	<c:choose>
		 		<c:when test="${loginAdmin.manageArea eq 'ManageMember' or loginAdmin.manageArea eq '전체'}">
        	<div class="menu-item"><a href="${pageContext.request.contextPath}/admin/member/member_table.jsp"><span>▶</span>회원 목록</a></div>
		 		</c:when>
		 		<c:otherwise>
		      <div class="menu-item"><a href="javascript:void(0);" onclick="alert('접근 권한이 없습니다.');"> <span>▶</span>회원 목록</a></div>
		 		</c:otherwise>
		 	</c:choose>
    </div>
    
    <div class="menu-category">
	    <div class="menu-title">상영관 관리</div>
	    <div class="menu-item"><a href="${pageContext.request.contextPath}/admin/theater/theater_manage.jsp"><span>▶</span>상영관 목록</a></div>
    </div>
    
    <div class="menu-category">
    	<div class="menu-title">영화 관리</div>
  		<c:choose>
	  		<c:when test="${loginAdmin.manageArea eq 'ManageMovie' or loginAdmin.manageArea eq '전체'}">
	        <div class="menu-item"><span>▶</span><a href="${pageContext.request.contextPath}/admin/movie/movie_list.jsp">영화 리스트</a></div>
	        <div class="menu-item"><span>▶</span><a href="${pageContext.request.contextPath}/admin/movie/movie_edit.jsp?mode=insert">영화 등록</a></div>
	        <div class="menu-item"><span>▶</span><a href="${pageContext.request.contextPath}/review/admin_review.jsp">영화 리뷰 관리</a></div>
	  		</c:when>
	  		<c:otherwise>
	        <div class="menu-item"><a href="javascript:void(0);" onclick="alert('접근 권한이 없습니다.');"> <span>▶</span>영화 리스트</a></div>
	        <div class="menu-item"><a href="javascript:void(0);" onclick="alert('접근 권한이 없습니다.');"> <span>▶</span>영화 등록</a></div>
	        <div class="menu-item"><a href="javascript:void(0);" onclick="alert('접근 권한이 없습니다.');"> <span>▶</span>영화 리뷰 관리</a></div>
	  		</c:otherwise>
	  	</c:choose>
    </div>
    
	  	
	  	
    <div class="menu-category">
      <div class="menu-title">상영스케줄 관리</div>
  		<c:choose>
	  		<c:when test="${loginAdmin.manageArea eq 'ManageSchedule' or loginAdmin.manageArea eq '전체'}">
	        <div class="menu-item"><a href="${pageContext.request.contextPath}/admin/schedule/schedule_manage.jsp"><span>▶</span>상영스케줄 목록</a></div>
	        <div class="menu-item"><a href="${pageContext.request.contextPath}/admin/schedule/schedule_register.jsp"><span>▶</span>상영스케줄 등록</a></div>
	  		</c:when>
	  		<c:otherwise>
	        <div class="menu-item"><a href="javascript:void(0);" onclick="alert('접근 권한이 없습니다.');"> <span>▶</span>상영스케줄 목록 </a></div>
	        <div class="menu-item"><a href="javascript:void(0);" onclick="alert('접근 권한이 없습니다.');"> <span>▶</span>상영스케줄 등록</a></div>
	  		</c:otherwise>
	  	</c:choose>
    </div>
    
    <div class="menu-category">
      <div class="menu-title">문의 관리</div>
  		<c:choose>
	  		<c:when test="${loginAdmin.manageArea eq 'ManageInquiry' or loginAdmin.manageArea eq '전체'}">
	        <div class="menu-item"><a href="${pageContext.request.contextPath}/admin/notice/notice_admin_main.jsp"><span>▶</span>공지사항</a></div>
        	<div class="menu-item"><a href="${pageContext.request.contextPath}/admin/inquiry/inquiry_admin_main.jsp"><span>▶</span>1:1문의</a></div>
	  		</c:when>
	  		<c:otherwise>
	        <div class="menu-item"><a href="javascript:void(0);" onclick="alert('접근 권한이 없습니다.');"> <span>▶</span>공지사항</a></div>
	        <div class="menu-item"><a href="javascript:void(0);" onclick="alert('접근 권한이 없습니다.');"> <span>▶</span>1:1문의</a></div>
	  		</c:otherwise>
	  	</c:choose>
           
    </div>
</div>
 	<!-- 상단 버튼 영역  -->
<div class="header-container">
    <div class="header-buttons">
        <a href="${pageContext.request.contextPath}/admin/dashboard/dashboard.jsp" class="header-button">
            <img src="${pageContext.request.contextPath}/common/img/home_icon.png" alt="홈 아이콘" class="button-icon">
            메인으로
        </a>
        <a href="javascript:logout()" class="header-button">
            <img src="${pageContext.request.contextPath}/common/img/signOut_icon.png" alt="로그아웃 아이콘" class="button-icon">
            로그아웃
        </a>
    </div>
</div>
