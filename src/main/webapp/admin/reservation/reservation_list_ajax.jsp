<%@page import="kr.co.yeonflix.theater.TheaterDTO"%>
<%@page import="kr.co.yeonflix.theater.TheaterService"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.reservation.UserReservationDTO"%>
<%@page import="kr.co.yeonflix.reservation.ReservationService"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<%
int scheduleIdx = Integer.parseInt(request.getParameter("scheduleIdx"));
int currentPage = Integer.parseInt(request.getParameter("currentPage"));
int pageScale = Integer.parseInt(request.getParameter("pageScale"));

String col = request.getParameter("col");
String key = request.getParameter("key");

int startNum = currentPage * pageScale - pageScale + 1;
int endNum = startNum + pageScale - 1;

ReservationService rs = new ReservationService();
List<UserReservationDTO> urDTOList = rs.searchUserReservationListBySchedule(scheduleIdx, startNum, endNum, col, key);
int totalCnt = rs.totalCount(scheduleIdx, col, key);
int totalPage = (int)Math.ceil((double)totalCnt / pageScale); //총 페이지 수

pageContext.setAttribute("urDTOList", urDTOList);
pageContext.setAttribute("currentPage", currentPage);
pageContext.setAttribute("totalCnt", totalCnt);
pageContext.setAttribute("pageScale", pageScale);
pageContext.setAttribute("totalPage", totalPage);
pageContext.setAttribute("key", key);

%>

<!-- ↓ 여기에 테이블 <tbody>만 출력하세요 -->
<table id="booking-table">

<thead>
	<tr>
		<th>번호</th>
		<th>예매 번호</th>
		<th>예매 상태</th>
		<th>좌석 번호</th>
		<th>예매/취소 날짜</th>
		<th>회원 여부</th>
		<th>아이디</th>
		<th>전화번호</th>
		<th>결제금액</th>
	</tr>
</thead>
<tbody>
	<c:choose>
		<c:when test="${totalCnt == 0}">
			<tr>
				<td colspan="9" style="padding: 0; border: none;"><c:choose>
						<c:when test="${not empty key}">
							<div class="empty-state empty-state-search">
								<div class="empty-state-title">🔍검색 결과가 없습니다</div>
								<div class="empty-state-message">
									'<strong>${key}</strong>' 검색어에 해당하는 예매 정보를 찾을 수 없습니다.<br>
									다른 검색어로 시도해보시거나 검색 조건을 변경해보세요.
								</div>
							</div>
						</c:when>
						<c:otherwise>
							<div class="empty-state empty-state-no-data">
								<span class="empty-state-icon">🎫</span>
								<div class="empty-state-title">등록된 예매 정보가 없습니다</div>
								<div class="empty-state-message">
									이 상영 일정에 대한 예매가 아직 없습니다.<br> 예매가 등록되면 여기에 표시됩니다.
								</div>
							</div>
						</c:otherwise>
					</c:choose></td>
			</tr>
		</c:when>
		<c:otherwise>
			<c:forEach var="urDTO" items="${urDTOList}" varStatus="i">
				<tr data-reservation-idx="${urDTO.reservationIdx}">
					<td>${totalCnt - (currentPage-1)*pageScale - i.index}</td>
					<td>${urDTO.reservationNumber}</td>
					<c:choose>
						<c:when test="${urDTO.canceledDate == null}">
							<td class="cancelReservation">✅ 예매 완료</td>
						</c:when>
						<c:otherwise>
							<td class="canceled">❌ 취소 완료</td>
						</c:otherwise>
					</c:choose>
					<td>${urDTO.seatsInfo}</td>
					<c:choose>
						<c:when test="${urDTO.canceledDate == null}">
							<td><fmt:formatDate value="${urDTO.reservationDate}"
									pattern="yyyy-MM-dd HH:mm" /></td>
						</c:when>
						<c:otherwise>
							<td class="canceled"><fmt:formatDate
									value="${urDTO.canceledDate}" pattern="yyyy-MM-dd HH:mm" /></td>
						</c:otherwise>
					</c:choose>
					<td>👤 회원</td>
					<td>${urDTO.memberId}</td>
					<td>${urDTO.tel}</td>
					<td><fmt:formatNumber value="${urDTO.totalPrice}"
							type="number" groupingUsed="true" />원</td>
				</tr>
			</c:forEach>
		</c:otherwise>
	</c:choose>
</tbody>
</table>
<br>
<c:choose>
<c:when test="${totalCnt == 0}">
</c:when>
<c:otherwise>
<div class="pagination-container">
  <nav class="pagination-nav" aria-label="Page navigation">
    <ul class="pagination">
      <c:forEach var="pageNum" begin="1" end="${totalPage}">
        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
          <span>${pageNum}</span>
        </li>
      </c:forEach>
    </ul>
  </nav>
</div>
</c:otherwise>
</c:choose>