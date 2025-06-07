package kr.co.yeonflix.reservedSeat;

import java.sql.SQLException;
import java.util.List;

public class ReservedSeatService {

	/**
	 * 예매좌석을 등록하는 코드
	 * @param rsDTO
	 * @return
	 */
	public boolean addReservedSeat(ReservedSeatDTO rsDTO) {
		boolean flag = false;
		
		ReservedSeatDAO rsDAO = ReservedSeatDAO.getInstance();
		try {
			rsDAO.insertRservedSeat(rsDTO);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}//addReservedSeat
	
	/**
	 * 예매 좌석을 업데이트 하는 코드
	 * @param rsDTO
	 * @return
	 */
	public boolean modifyReservedSeat(ReservedSeatDTO rsDTO) {
		boolean flag = false;
		ReservedSeatDAO rsDAO = ReservedSeatDAO.getInstance();
		try {
			rsDAO.updateReservedSeat(rsDTO);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}//modifyReservedSeat
	
	/**
	 * 예매한 좌석들의 상태를 일괄적으로 0으로 update
	 * @param reservationIdx
	 * @return
	 */
	public int modifyReservedSeatAll(int reservationIdx) {
		int cntSeats = 0;
		ReservedSeatDAO rsDAO = ReservedSeatDAO.getInstance();
		try {
			cntSeats = rsDAO.updateReservedSeatAll(reservationIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return cntSeats;
	}//modifyReservedSeatAll
	
	/**
	 * 좌석번호로 좌석IDX를 가져오는 코드
	 * @param seatNumber
	 * @return
	 */
	public int searchSeatIdx(String seatNumber) {
		int seatIdx = 0;
		
		ReservedSeatDAO rsDAO = ReservedSeatDAO.getInstance();
		try {
			seatIdx = rsDAO.selectSeatIdx(seatNumber);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return seatIdx;
	}//searchSeatIdx
	
	/**
	 * reservationIdx로 좌석 이름들만 리스트로 빼오기
	 * @param reservationIdx
	 * @return
	 */
	public List<String> searchSeatNumberWithReservation(int reservationIdx){
		List<String> list = null;
		
		ReservedSeatDAO rsDAO = ReservedSeatDAO.getInstance();
		try {
			list = rsDAO.selectSeatNumberWithReservation(reservationIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}//searchSeatNumberWithReservation
	
	/**
	 * scheduleIdx로 예매된 좌석 이름들 빼오기
	 * @param scheduleIdx
	 * @return
	 */
	public List<String> searchSeatNumberWithSchedule(int scheduleIdx){
		List<String> list = null;
		
		ReservedSeatDAO rsDAO = ReservedSeatDAO.getInstance();
		try {
			list = rsDAO.selectSeatNumberWithSchedule(scheduleIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}//searchSeatNumberWithSchedule
	
	/**
	 * 해당 스케줄의 해당 좌석 가져오는 코드
	 * @param seatIdx
	 * @param scheduleIdx
	 * @return
	 */
	public ReservedSeatDTO searchSeatWithIdxAndSchedule(int seatIdx, int scheduleIdx) {
		ReservedSeatDTO rsDTO = null;
		ReservedSeatDAO rsDAO = ReservedSeatDAO.getInstance();
		try {
			rsDTO = rsDAO.selectSeatWithIdxAndSchedule(seatIdx, scheduleIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return rsDTO;
	}//searchSeatWithIdxAndSchedule
	
	/**
	 * 임시 좌석 추가하는 코드
	 * @param seatIdx
	 * @param scheduleIdx
	 * @return
	 */
	public boolean addTempSeat(int seatIdx, int scheduleIdx) {
		boolean flag = false;
		
		ReservedSeatDAO rsDAO = ReservedSeatDAO.getInstance();
		try {
			rsDAO.insertTempSeat(seatIdx, scheduleIdx);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return flag;
	}//addTempSeat
	
	/**
	 * 임시좌석 삭제하는 코드
	 * @param seatIdx
	 * @param scheduleIdx
	 * @return
	 */
	public boolean removeTempSeat(int seatIdx, int scheduleIdx) {
		boolean flag = false;
		
		ReservedSeatDAO rsDAO = ReservedSeatDAO.getInstance();
		try {
			rsDAO.deleteTempSeat(seatIdx, scheduleIdx);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return flag;
	}//removeTempSeat
	
	/**
	 * 임시좌석 모두 가져오는 코드
	 * @return
	 */
	public List<TempSeatDTO> searchAllTempSeatBySchedule(int scheduleIdx){
		List<TempSeatDTO> list = null;
		
		ReservedSeatDAO rsDAO = ReservedSeatDAO.getInstance();
		try {
			list = rsDAO.selectAllTempSeatBySchedule(scheduleIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return list;
	}//searchAllTempSeat
	
	/**
	 * 임시좌석 이름들만 빼오기
	 * @param scheduleIdx
	 * @return
	 */
	public List<String> searchTempSeatNumberWithSchedule(int scheduleIdx){
		List<String> list = null;
		
		ReservedSeatDAO rsDAO = ReservedSeatDAO.getInstance();
		try {
			list = rsDAO.selectTempSeatNumberWithSchedule(scheduleIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}//searchTempSeatNumberWithSchedule
	
	/**
	 * tempSeat에 해당 칼럼이 존재하는지
	 * @param seatIdx
	 * @param scheduleIdx
	 * @return
	 */
	public Boolean isTempSeatInTable(int seatIdx, int scheduleIdx) {
		boolean flag = false;
		ReservedSeatDAO rsDAO = ReservedSeatDAO.getInstance();
		try {
			flag = rsDAO.selectCntTempSeat(seatIdx, scheduleIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return flag;
	}//isTempSeatInTable
	
	/**
	 * 모든 임시좌석 가져오기
	 * @return
	 */
	public List<TempSeatDTO> searchAllTempSeat(){
		List<TempSeatDTO> list = null;
		ReservedSeatDAO rsDAO = ReservedSeatDAO.getInstance();
		try {
			list = rsDAO.selectAllTempSeat();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}//searchAllTempSeat
}
