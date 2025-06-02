<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="java.sql.SQLException"%>
<%@page import="kr.co.yeonflix.reservation.ReservationDAO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatService"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatDTO"%>
<%@page import="kr.co.yeonflix.purchaseHistory.PurchaseHistoryService"%>
<%@page import="kr.co.yeonflix.purchaseHistory.PurchaseHistoryDTO"%>
<%@page import="kr.co.yeonflix.reservation.ReservationDTO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ page import="kr.co.yeonflix.reservation.ReservationService" %>

<%
    request.setCharacterEncoding("UTF-8"); 

    String reservationIdxParam = request.getParameter("reservationIdx");
    boolean success = false;

    if (reservationIdxParam != null) {
        try {
            int reservationIdx = Integer.parseInt(reservationIdxParam);
            
            ReservationDTO rsDTO = new ReservationDTO();
            rsDTO.setReservationIdx(reservationIdx); 

            ReservationService rs = new ReservationService();
/* -------------------------------------------------------------------------------------- */


            PurchaseHistoryDTO phDTO = new PurchaseHistoryDTO();
            phDTO.setPurchaseHistoryIdx(reservationIdx);  // reservationIdx가 구매내역 번호라고 가정

            PurchaseHistoryService phs = new PurchaseHistoryService();
            boolean purchaseSuccess = phs.modifyPurchaseHistory(reservationIdx);  // 구매내역 변경 성공 여부
            
            
      /* 
		PurchaseHistoryService 여기에 추가해야함.      
      
      	public boolean modifyPurchaseHistory(int reservationIdx) {//여기도
		boolean flag = false;
		
		PurchaseHistoryDAO phDAO = PurchaseHistoryDAO.getInstance();
		ReservedSeatDAO resDAO=ReservedSeatDAO.getInstance(); ////////// 여기 추가
		try {
			phDAO.updatePurchaseHistory(reservationIdx);
			resDAO.updateReservedSeatAll(reservationIdx);////////여기 추가
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}//modifyPurchaseHistory */
            
            
/* ------------------------------------------------------------------------------------------ */  
          
          
            ReservedSeatDTO resSeatDTO=new ReservedSeatDTO();
            resSeatDTO.setReservedSeatStatus(0);
            
            ReservedSeatService rss = new ReservedSeatService();
           	int reservedSeatSuccess = rss.modifyReservedSeatAll(reservationIdx);
            
            
/* -------------------------------------------------------------------------------------------------- */           
		

			ReservationDTO resDTO = rs.searchOneSchedule(reservationIdx);  // DB에서 예약 정보 가져오기
			
			if (resDTO != null) {
			    int scheduleIdx = resDTO.getScheduleIdx();
			
			    int restoredSeatCount = rss.modifyReservedSeatAll(reservationIdx);
			
			    if (restoredSeatCount > 0) {
			        ScheduleService schService = new ScheduleService();
			
			        // 스케줄 정보 불러오기
			        ScheduleDTO schDTO = schService.searchOneSchedule(scheduleIdx);
			
			        if (schDTO != null) {
			            int updatedRemainSeats = schDTO.getRemainSeats() + restoredSeatCount;
			            schDTO.setRemainSeats(updatedRemainSeats);
			
			            schService.modifySchedule(schDTO);
			        }
			    }
			}

											
				            
            boolean reservationSuccess = rs.modifyReservation(resDTO);  // 예매 상태 변경 성공 여부

            success = purchaseSuccess && reservationSuccess && (reservedSeatSuccess > 0);
        } catch (NumberFormatException e) {
            success = false;
        }
        
    }

    response.getWriter().write("{\"success\": " + success + "}"); 
%>

