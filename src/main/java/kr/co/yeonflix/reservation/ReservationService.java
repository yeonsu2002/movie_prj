package kr.co.yeonflix.reservation;

import java.sql.Date;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;

import kr.co.yeonflix.reservedSeat.ReservedSeatService;

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
	
	/**
	 * 특정 유저의 예매내역을 보여주기 편하게 가공하는 코드
	 * @param userIdx
	 * @return
	 */
	public List<ShowReservationDTO> searchDetailReservationWithUser(int userIdx){
		List<ShowReservationDTO> list = null;
		ReservationDAO resDAO = ReservationDAO.getInstance();
		
		try {
			list = resDAO.selectDetailReservationWithUser(userIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}//searchDetailReservationWithUser
	
	/**
	 * 예매리스트에 보여주기 위한 스케줄별 예매내역
	 * @param scheduleIdx
	 * @return
	 */
	public List<UserReservationDTO> searchUserReservationListBySchedule(int scheduleIdx, int startNum, int endNum, String col, String key){
		List<UserReservationDTO> list = null;
		ReservationDAO resDAO = ReservationDAO.getInstance();
		ReservedSeatService rss = new ReservedSeatService();
		try {
			list = resDAO.selectUserReservationListBySchedule(scheduleIdx, startNum, endNum, col, key);
			for(UserReservationDTO urDTO : list) {
				List<String> seatList = rss.searchSeatNumberWithReservation(urDTO.getReservationIdx());
				String seatsInfo = String.join(", ", seatList);
				urDTO.setSeatsInfo(seatsInfo);
				urDTO.setSeatsCnt(seatList.size());
				String tel = urDTO.getTel();
				urDTO.setTel(tel.substring(tel.length() - 4));
				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return list;
		
	}//searchUserReservationListBySchedule
	
	/**
	 * 총 레코드의 수
	 * @param scheduleIdx
	 * @return
	 */
	public int totalCount(int scheduleIdx, String col, String key) {
		int cnt = 0;
		ReservationDAO resDAO = ReservationDAO.getInstance();
		try {
			cnt = resDAO.selectTotalCount(scheduleIdx, col, key);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return cnt;
	}//totalCount
	
	/**
	 * 해당 스케줄 비회원의 총 레코드 수
	 * @param scheduleIdx
	 * @param col
	 * @param key
	 * @return
	 */
	public int totalGuestCount(int scheduleIdx, String col, String key) {
		int cnt = 0;
		ReservationDAO resDAO = ReservationDAO.getInstance();
		try {
			cnt = resDAO.selectGuestTotalCount(scheduleIdx, col, key);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return cnt;
	}//totalGuestCount
	
	/**
	 * 예매리스트에 보여주기 위한 비회원의 스케줄별 예매내역
	 * @param scheduleIdx
	 * @param startNum
	 * @param endNum
	 * @param col
	 * @param key
	 * @return
	 */
	public List<GuestReservationDTO> searchGuestReservationListBySchedule(int scheduleIdx, int startNum, int endNum, String col, String key){
		List<GuestReservationDTO> list = null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
		ReservationDAO resDAO = ReservationDAO.getInstance();
		ReservedSeatService rss = new ReservedSeatService();
		try {
			list = resDAO.selectGuestReservationListBySchedule(scheduleIdx, startNum, endNum, col, key);
			for(GuestReservationDTO urDTO : list) {
				List<String> seatList = rss.searchSeatNumberWithReservation(urDTO.getReservationIdx());
				String seatsInfo = String.join(", ", seatList);
				urDTO.setSeatsInfo(seatsInfo);
				urDTO.setSeatsCnt(seatList.size());
				Date birth = urDTO.getNonMemberBirth();
			    urDTO.setBirthFormatted(sdf.format(birth));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return list;
		
	}//searchGuestReservationListBySchedule
	
	
}
