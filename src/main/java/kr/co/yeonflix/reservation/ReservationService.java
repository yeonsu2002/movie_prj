package kr.co.yeonflix.reservation;

import java.sql.SQLException;
import java.util.List;

public class ReservationService {

	/**
	 * 예매 추가하는 코드
	 * @param resDTO
	 * @return
	 */
	public boolean addReservation(ReservationDTO resDTO) {
		boolean flag = false;
		
		ReservationDAO resDAO = ReservationDAO.getInstance();
		try {
			resDAO.insertReservation(resDTO);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}//addReservation
	
	/**
	 * 예매내역 업데이트 하는 코드(예매취소할 때 사용)
	 * @param resDTO
	 * @return
	 */
	public boolean modifyReservation(ReservationDTO resDTO) {
		boolean flag = false;
		
		ReservationDAO resDAO = ReservationDAO.getInstance();
		try {
			resDAO.updateReservation(resDTO);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}//modifyReservation
	
	/**
	 * 방금 생성한 예매 idx 얻기
	 * @return
	 */
	public int getCurrentReservationIdx() {
		int reservationIdx = 0;
		
		ReservationDAO resDAO = ReservationDAO.getInstance();
		try {
			reservationIdx = resDAO.getCurrentIdx();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return reservationIdx;
	}//getCurrentReservationIdx
	
	/**
	 * 예매 내역 한개 가져오기
	 * @param reservationIdx
	 * @return
	 */
	public ReservationDTO searchOneSchedule(int reservationIdx) {
		ReservationDTO resDTO = null;
		
		ReservationDAO resDAO = ReservationDAO.getInstance();
		try {
			resDTO = resDAO.selectOneReservation(reservationIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return resDTO;
	}//searchOneSchedule
	
	/**
	 * 유저가 예매한 예매 내역 전부 가져오기
	 * @param userIdx
	 * @return
	 */
	public List<ReservationDTO> searchAllScheduleWithUser(int userIdx) {
		List<ReservationDTO> list = null;
		
		ReservationDAO resDAO = ReservationDAO.getInstance();
		
		try {
			list = resDAO.selectAllReservationWithUser(userIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
		
	}//searchAllScheduleWithUser
	
	/**
	 * 해당 상영스케줄의 예매 내역 전부 가져오기
	 * @param scheduleIdx
	 * @return
	 */
	public List<ReservationDTO> searchAllScheduleWithSchedule(int scheduleIdx) {
		List<ReservationDTO> list = null;
		
		ReservationDAO resDAO = ReservationDAO.getInstance();
		
		try {
			list = resDAO.selectAllReservationWithUser(scheduleIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
		
	}//searchAllScheduleWithSchedule
	
	
}
