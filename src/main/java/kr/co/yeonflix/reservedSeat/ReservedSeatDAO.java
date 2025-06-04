package kr.co.yeonflix.reservedSeat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import at.favre.lib.crypto.bcrypt.BCrypt.Result;
import kr.co.yeonflix.dao.DbConnection;

public class ReservedSeatDAO {

	private static ReservedSeatDAO rsDAO;

	private ReservedSeatDAO() {

	}

	public static ReservedSeatDAO getInstance() {
		if (rsDAO == null) {
			rsDAO = new ReservedSeatDAO();
		}

		return rsDAO;
	}// getInstance

	/**
	 * 예매 좌석을 등록하는 코드
	 * 
	 * @param rsDTO
	 * @throws SQLException
	 */
	public void insertRservedSeat(ReservedSeatDTO rsDTO) throws SQLException {

		DbConnection dbCon = DbConnection.getInstance();

		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "insert into reserved_seat(RESERVATION_SEAT_IDX, SEAT_IDX, RESERVATION_IDX, SCHEDULE_IDX, RESERVED_SEAT_STATUS) values(reservation_seat_idx_seq.nextval,?,?,?,?)";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, rsDTO.getSeatIdx());
			pstmt.setInt(2, rsDTO.getReservationIdx());
			pstmt.setInt(3, rsDTO.getScheduleIdx());
			pstmt.setInt(4, rsDTO.getReservedSeatStatus());

			pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
	}// insertRservedSeat

	/**
	 * 예매 좌석을 업데이트 하는 코드
	 * 
	 * @param rsDTO
	 * @throws SQLException
	 */
	public void updateReservedSeat(ReservedSeatDTO rsDTO) throws SQLException {
		DbConnection dbCon = DbConnection.getInstance();
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "UPDATE reserved_seat SET RESERVED_SEAT_STATUS = ?, reservation_idx = ?   WHERE schedule_idx = ? and seat_idx=?";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, rsDTO.getReservedSeatStatus());
			pstmt.setInt(2, rsDTO.getReservationIdx());
			pstmt.setInt(3, rsDTO.getScheduleIdx());
			pstmt.setInt(4, rsDTO.getSeatIdx());
			pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		}

	}// updateReservedSeat

	/**
	 * 예매한 좌석들의 상태를 일괄적으로 0으로 update
	 * 
	 * @param reservationIdx
	 * @throws SQLException
	 */
	public int updateReservedSeatAll(int reservationIdx) throws SQLException {
		int cntSeats = 0;

		DbConnection dbCon = DbConnection.getInstance();
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "UPDATE reserved_seat SET RESERVED_SEAT_STATUS = 0 WHERE reservation_idx = ?";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, reservationIdx);
			cntSeats = pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		}

		return cntSeats;
	}// updateReservedSeatAll

	/**
	 * 좌석번호로 좌석IDX를 가져오는 코드
	 * 
	 * @param seatNumber
	 * @return
	 * @throws SQLException
	 */
	public int selectSeatIdx(String seatNumber) throws SQLException {
		int seatIdx = 0;

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "select SEAT_IDX from seat where SEAT_NUMBER=?";

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, seatNumber);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				seatIdx = rs.getInt("seat_idx");
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return seatIdx;
	}// selectSeatIdx

	/**
	 * reservationIdx로 좌석 이름들만 리스트로 빼오기
	 */
	public List<String> selectSeatNumberWithReservation(int reservationIdx) throws SQLException {
		List<String> list = new ArrayList<String>();

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "SELECT seat_number FROM seat s INNER JOIN reserved_seat r ON s.seat_idx = r.seat_idx WHERE reservation_idx=?";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, reservationIdx);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				list.add(rs.getString("seat_number"));
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}// selectSeatNumberWithReservation

	/**
	 * scheduleIdx로 예매된 좌석 이름들 빼오기
	 * 
	 * @param scheduleIdx
	 * @return
	 * @throws SQLException
	 */
	public List<String> selectSeatNumberWithSchedule(int scheduleIdx) throws SQLException {
		List<String> list = new ArrayList<String>();

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "SELECT seat_number FROM seat s INNER JOIN reserved_seat r ON s.seat_idx = r.seat_idx WHERE schedule_idx=? AND RESERVED_SEAT_STATUS=1";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, scheduleIdx);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				list.add(rs.getString("seat_number"));
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}// selectSeatNumberWithSchedule

	/**
	 * 해당 스케줄에 해당 좌석 가져오는 코드
	 * 
	 * @param seatIdx
	 * @param scheduleIdx
	 * @return
	 * @throws SQLException
	 */
	public ReservedSeatDTO selectSeatWithIdxAndSchedule(int seatIdx, int scheduleIdx) throws SQLException {
		ReservedSeatDTO rsDTO = null;

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "select RESERVATION_SEAT_IDX, SEAT_IDX, RESERVATION_IDX, SCHEDULE_IDX, RESERVED_SEAT_STATUS from RESERVED_SEAT where SEAT_IDX=? and schedule_idx=?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, seatIdx);
			pstmt.setInt(2, scheduleIdx);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				rsDTO = new ReservedSeatDTO();
				rsDTO.setReservedSeatIdx(rs.getInt("reservation_seat_idx"));
				rsDTO.setSeatIdx(rs.getInt("seat_idx"));
				rsDTO.setReservationIdx(rs.getInt("reservation_idx"));
				rsDTO.setScheduleIdx(rs.getInt("schedule_idx"));
				rsDTO.setReservedSeatStatus(rs.getInt("reserved_seat_status"));
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return rsDTO;
	}// selectSeatWithIdxAndSchedule

	/**
	 * 임시 좌석 생성하는 코드
	 * 
	 * @param tsDTO
	 * @throws SQLException
	 */
	public void insertTempSeat(int seatIdx, int scheduleIdx) throws SQLException {
		DbConnection dbCon = DbConnection.getInstance();
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "insert into temp_seat(seat_idx, schedule_idx) values(?,?)";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, seatIdx);
			pstmt.setInt(2, scheduleIdx);

			pstmt.executeUpdate();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
	}// insertTempSeat

	/**
	 * 시간 지난 임시 좌석 삭제하기 위한 코드
	 * 
	 * @param seatIdx
	 * @param scheduleIdx
	 * @throws SQLException
	 */
	public void deleteTempSeat(int seatIdx, int scheduleIdx) throws SQLException {

		DbConnection dbCon = DbConnection.getInstance();
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "delete from temp_seat where seat_idx=? and schedule_idx=?";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, seatIdx);
			pstmt.setInt(2, scheduleIdx);

			pstmt.executeUpdate();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
	}// deleteTempSeat

	/**
	 * 모든 임시좌석 가져오는 코드
	 * 
	 * @return
	 * @throws SQLException
	 */
	public List<TempSeatDTO> selectAllTempSeatBySchedule(int scheduleIdx) throws SQLException {
		List<TempSeatDTO> list = new ArrayList<TempSeatDTO>();

		DbConnection dbCon = DbConnection.getInstance();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "select seat_idx, schedule_idx, click_time from temp_seat where schedule_idx=?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, scheduleIdx);
			rs = pstmt.executeQuery();

			TempSeatDTO tsDTO = null;
			while (rs.next()) {
				tsDTO = new TempSeatDTO();
				tsDTO.setSeatIdx(rs.getInt("seat_idx"));
				tsDTO.setScheduleIdx(rs.getInt("schedule_idx"));
				tsDTO.setClickTime(rs.getTimestamp("click_time"));
				list.add(tsDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return list;
	}// selectAllTempSeat

	/**
	 * 임시 선점되 좌석들의 이름만 빼오기
	 * 
	 * @param scheduleIdx
	 * @return
	 * @throws SQLException
	 */
	public List<String> selectTempSeatNumberWithSchedule(int scheduleIdx) throws SQLException {
		List<String> list = new ArrayList<String>();

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "SELECT seat_number FROM seat s INNER JOIN temp_seat t ON s.seat_idx = t.seat_idx WHERE schedule_idx=?";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, scheduleIdx);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				list.add(rs.getString("seat_number"));
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}// selectSeatNumberWithSchedule

	/**
	 * tempSeat에 해당 칼럼이 존재하는지
	 * 
	 * @param seatIdx
	 * @param scheduleIdx
	 * @return
	 * @throws SQLException
	 */
	public Boolean selectCntTempSeat(int seatIdx, int scheduleIdx) throws SQLException {

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "select count(*) from temp_seat where seat_idx=? and schedule_idx=?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, seatIdx);
			pstmt.setInt(2, scheduleIdx);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				return rs.getInt(1) > 0;
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return false;
	}// selectOneTempSeat

	/**
	 * 모든 임시좌석 가져오는 코드
	 * @return
	 * @throws SQLException
	 */
	public List<TempSeatDTO> selectAllTempSeat() throws SQLException {
		List<TempSeatDTO> list = new ArrayList<TempSeatDTO>();

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "select seat_idx, schedule_idx, click_time from temp_seat";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			TempSeatDTO tsDTO = null;
			while (rs.next()) {
				tsDTO = new TempSeatDTO();
				tsDTO.setSeatIdx(rs.getInt("seat_idx"));
				tsDTO.setScheduleIdx(rs.getInt("schedule_idx"));
				tsDTO.setClickTime(rs.getTimestamp("click_time"));
				list.add(tsDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return list;
	}//selectAllTempSeat
}
