package kr.co.yeonflix.reservation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;

public class ReservationDAO {

	private static ReservationDAO resDAO;

	private ReservationDAO() {

	}

	public static ReservationDAO getInstance() {
		if (resDAO == null) {
			resDAO = new ReservationDAO();
		}

		return resDAO;
	}// getInstance

	/**
	 * 예매 추가하는 코드
	 * 
	 * @param resDTO
	 * @throws SQLException
	 */
	public void insertReservation(ReservationDTO resDTO) throws SQLException {
		DbConnection dbCon = DbConnection.getInstance();
		PreparedStatement pstmt = null;

		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "insert into RESERVATION(RESERVATION_IDX, SCHEDULE_IDX, USER_IDX, TOTAL_PRICE, RESERVATION_NUMBER)"
					+ " values(reservation_idx_seq.nextval, ?, ?, ?, ?)";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, resDTO.getScheduleIdx());
			pstmt.setInt(2, resDTO.getUserIdx());
			pstmt.setInt(3, resDTO.getTotalPrice());
			pstmt.setString(4, resDTO.getReservationNumber());
			pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
	}// insertReservation
	
	/**
	 * 예매내역 업데이트 하는 코드(예매취소할 때 사용)
	 * @param resDTO
	 * @throws SQLException
	 */
	public void updateReservation(ReservationDTO resDTO) throws SQLException {
		DbConnection dbCon = DbConnection.getInstance();
		PreparedStatement pstmt = null;
		Connection con = null;
		
		try {
			con = dbCon.getDbConn();
			String query = "UPDATE reservation SET CANCELED_DATE = SYSDATE WHERE RESERVATION_IDX = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, resDTO.getReservationIdx());
			
			pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
		
	}//updateReservation
	

	/**
	 * 방금 생성한 예매idx 얻기
	 * 
	 * @return
	 * @throws SQLException
	 */
	public int getCurrentIdx() throws SQLException {
		int idx = 0;

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "SELECT reservation_idx_seq.CURRVAL FROM dual";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				idx = rs.getInt(1);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return idx;
	}// getCurrentReservationIdx

	/**
	 * 예매IDX로 예매 내역 하나 찾기
	 * 
	 * @param ReservationIdx
	 * @return
	 * @throws SQLException
	 */
	public ReservationDTO selectOneReservation(int reservationIdx) throws SQLException {
		ReservationDTO rsDTO = null;

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "select RESERVATION_IDX, SCHEDULE_IDX, USER_IDX, RESERVATION_DATE, CANCELED_DATE, TOTAL_PRICE, RESERVATION_NUMBER from reservation where RESERVATION_IDX=?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, reservationIdx);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				rsDTO = new ReservationDTO();
				rsDTO.setReservationIdx(rs.getInt("reservation_idx"));
				rsDTO.setScheduleIdx(rs.getInt("schedule_idx"));
				rsDTO.setUserIdx(rs.getInt("user_idx"));
				rsDTO.setReservationDate(rs.getTimestamp("reservation_date"));
				rsDTO.setCanceledDate(rs.getTimestamp("canceled_date"));
				rsDTO.setTotalPrice(rs.getInt("total_price"));
				rsDTO.setReservationNumber(rs.getString("reservation_number"));
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return rsDTO;
	}// selectOneReservation

	/**
	 * 특정 유저의 모든 예매내역 가져오는 코드
	 * @return
	 * @throws SQLException
	 */
	public List<ReservationDTO> selectAllReservationWithUser(int userIdx) throws SQLException {
		List<ReservationDTO> list = new ArrayList<ReservationDTO>();

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;
		
		try {
			con = dbCon.getDbConn();
			String query = "select RESERVATION_IDX, SCHEDULE_IDX, USER_IDX, RESERVATION_DATE, CANCELED_DATE, TOTAL_PRICE, RESERVATION_NUMBER from reservation where USER_IDX=?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, userIdx);
			rs = pstmt.executeQuery();

			ReservationDTO resDTO = null;
			while (rs.next()) {
				resDTO = new ReservationDTO();
				resDTO.setReservationIdx(rs.getInt("reservation_idx"));
				resDTO.setScheduleIdx(rs.getInt("schedule_idx"));
				resDTO.setUserIdx(rs.getInt("user_idx"));
				resDTO.setReservationDate(rs.getTimestamp("reservation_date"));
				resDTO.setCanceledDate(rs.getTimestamp("canceled_date"));
				resDTO.setTotalPrice(rs.getInt("total_price"));
				resDTO.setReservationNumber(rs.getString("reservation_number"));
				
				list.add(resDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return list;
	}//selectAllReservationWithUser
	
	public List<ReservationDTO> selectAllReservationWithSchedule(int scheduleIdx) throws SQLException {
		List<ReservationDTO> list = new ArrayList<ReservationDTO>();
		
		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;
		
		try {
			con = dbCon.getDbConn();
			String query = "select RESERVATION_IDX, SCHEDULE_IDX, USER_IDX, RESERVATION_DATE, CANCELED_DATE, TOTAL_PRICE, RESERVATION_NUMBER from reservation where SCHEDULE_IDX=?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, scheduleIdx);
			rs = pstmt.executeQuery();
			
			ReservationDTO resDTO = null;
			while (rs.next()) {
				resDTO = new ReservationDTO();
				resDTO.setReservationIdx(rs.getInt("reservation_idx"));
				resDTO.setScheduleIdx(rs.getInt("schedule_idx"));
				resDTO.setUserIdx(rs.getInt("user_idx"));
				resDTO.setReservationDate(rs.getTimestamp("reservation_date"));
				resDTO.setCanceledDate(rs.getTimestamp("canceled_date"));
				resDTO.setTotalPrice(rs.getInt("total_price"));
				resDTO.setReservationNumber(rs.getString("reservation_number"));
				
				list.add(resDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return list;
	}//selectAllReservationWithSchedule
	
	/**
	 * 특정 유저의 예매내역을 보여주기 편하게 가공하는 코드
	 * @param userIdx
	 * @return
	 * @throws SQLException
	 */
	public List<ShowReservationDTO> selectDetailReservationWithUser(int userIdx) throws SQLException {
		List<ShowReservationDTO> list = new ArrayList<ShowReservationDTO>();
		
		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;
		
		
		try {
			con = dbCon.getDbConn();
			StringBuilder sql = new StringBuilder();
			sql.append("SELECT s.schedule_idx, r.reservation_idx, m.movie_name, t.theater_name, s.screen_date, r.canceled_date ");
			sql.append("FROM reservation r ");
			sql.append("JOIN schedule s ON r.schedule_idx = s.schedule_idx ");
			sql.append("JOIN movie m ON s.movie_idx = m.movie_idx ");
			sql.append("JOIN theater t ON s.theater_idx = t.theater_idx ");
			sql.append("WHERE r.user_idx = ?");
			
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setInt(1, userIdx);
			rs = pstmt.executeQuery();
			
			ShowReservationDTO srDTO = null;
			while(rs.next()) {
				srDTO = new ShowReservationDTO();
				srDTO.setScheduleIdx(rs.getInt("schedule_idx"));
				srDTO.setReservationIdx(rs.getInt("reservation_idx"));
				srDTO.setMovieName(rs.getString("movie_name"));
				srDTO.setTheaterName(rs.getString("theater_name"));
				srDTO.setScreenDate(rs.getDate("screen_date"));
				srDTO.setCanceledDate(rs.getTimestamp("canceled_date"));
				
				list.add(srDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		
		return list;
	}//selectDetailReservationWithUser
	
	/**
	 * 예매리스트에 보여주기 위한 스케줄별 예매내역
	 * @param scheduleIdx
	 * @return
	 * @throws SQLException
	 */
	public List<UserReservationDTO> selectUserReservationListBySchedule(int scheduleIdx) throws SQLException {
		List<UserReservationDTO> list = new ArrayList<UserReservationDTO>();
		
		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;
		
		try {
			con = dbCon.getDbConn();
			StringBuilder query = new StringBuilder();
			query.append("SELECT reservation_idx, reservation_number, reservation_date, canceled_date, ");
			query.append("r.user_idx, user_type, member_id, tel ");
			query.append("FROM reservation r ");
			query.append("JOIN common_user c ON c.user_idx = r.user_idx ");
			query.append("JOIN member m ON c.user_idx = m.user_idx ");
			query.append("WHERE r.schedule_idx = ?");
			
			pstmt = con.prepareStatement(query.toString());
			pstmt.setInt(1, scheduleIdx);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				UserReservationDTO urDTO = new UserReservationDTO();
				urDTO.setReservationIdx(rs.getInt("reservation_idx"));
				urDTO.setReservationNumber(rs.getString("reservation_number"));
				urDTO.setReservationDate(rs.getTimestamp("reservation_date"));
				urDTO.setCanceledDate(rs.getTimestamp("canceled_date"));
				urDTO.setUserIdx(rs.getInt("user_idx"));
				urDTO.setUserType(rs.getString("user_type"));
				urDTO.setMemberId(rs.getString("member_id"));
				urDTO.setTel(rs.getString("tel"));
				
				list.add(urDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return list;
	}//selectUserReservationListBySchedule
}
