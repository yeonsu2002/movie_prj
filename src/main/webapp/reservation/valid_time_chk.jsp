<%@page import="kr.co.yeonflix.schedule.ScheduleDTO"%>
<%@page import="kr.co.yeonflix.schedule.ScheduleService"%>
<%@page import="java.time.Duration"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.reservedSeat.TempSeatDTO"%>
<%@page import="kr.co.yeonflix.reservedSeat.ReservedSeatService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%
	int scheduleIdx = Integer.parseInt(request.getParameter("scheduleIdx"));
	String seatsInfo = request.getParameter("seatsInfo");
	String[] seats = seatsInfo.split(" ");
	
	ScheduleService ss = new ScheduleService();
	ScheduleDTO schDTO = ss.searchOneSchedule(scheduleIdx);
	
	//선점된 좌석들 5분이 지났으면 없애기
	//현재 스케줄의 선점된 좌석들만 5분이 지났으면 없애기
	ReservedSeatService rss = new ReservedSeatService();
	// 수정: 현재 스케줄의 임시좌석만 조회
	List<TempSeatDTO> tempSeatsList = rss.searchAllTempSeatBySchedule(scheduleIdx);
	int removedCount = 0; // 실제로 삭제된 좌석 수를 카운트

	for(TempSeatDTO tempSeat : tempSeatsList){
    	LocalDateTime holdTime = tempSeat.getClickTime().toLocalDateTime();
    	int seatIdx = tempSeat.getSeatIdx();
    	Duration d = Duration.between(holdTime, LocalDateTime.now());
    
    //현재는 테스트용으로 1분 해놨으나 나중에 5분으로 변경
    if(d.toMinutes() >= 1){
        // 수정: 해당 스케줄의 해당 좌석만 삭제
        boolean removed = rss.removeTempSeat(seatIdx, scheduleIdx);
        if(removed) {
            removedCount++; // 실제 삭제된 경우에만 카운트
        }
    }
}

// 수정: 실제로 삭제된 좌석 수만큼만 잔여좌석 증가
if(removedCount > 0) {
    schDTO.setRemainSeats(schDTO.getRemainSeats() + removedCount);
    ss.modifySchedule(schDTO);
}
	
	String isValid = "valid";
	
	//결제할 때 유효시간이 지났는지 확인
	for(String seat : seats){
		int seatIdx = rss.searchSeatIdx(seat);
		if(!rss.isTempSeatInTable(seatIdx, scheduleIdx)){
			isValid ="invalid";
			break;
		}
	}
	
	out.print(isValid);
%>