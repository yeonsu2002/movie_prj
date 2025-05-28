package kr.co.yeonflix.schedule;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;
import kr.co.yeonflix.movie.MovieDTO;

/**
 * 
 */
class ScheduleDAO {

	private static ScheduleDAO schDAO;

	private ScheduleDAO() {

	}// ScheduleDAO

	public static ScheduleDAO getInstance() {
		if (schDAO == null) {
			schDAO = new ScheduleDAO();
		}

		return schDAO;
	}// ScheduleDAO

	/**
	 * 모든 영화 가져오는 임시 쿼리(삭제 예정)
	 * 
	 * @return
	 * @throws SQLException
	 */
	public List<MovieDTO> selectAllMovie() throws SQLException {
		List<MovieDTO> list = new ArrayList<MovieDTO>();

		DbConnection dbCon = DbConnection.getInstance();

		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "select * from movie";

			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			MovieDTO mDTO = null;
			while (rs.next()) {
				mDTO = new MovieDTO();
				mDTO.setMovieIdx(rs.getInt("movie_idx"));
				mDTO.setRunningTime(rs.getInt("running_time"));
				mDTO.setMovieName(rs.getString("movie_name"));
				mDTO.setReleaseDate(rs.getDate("release_date"));
				mDTO.setEndDate(rs.getDate("end_date"));

				list.add(mDTO);
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return list;
	}// selectAllMovie

	/**
	 * 영화 하나 가져오는 method
	 * 
	 * @param movieIdx
	 * @return
	 * @throws SQLException
	 */
	public MovieDTO selectOneMovie(int movieIdx) throws SQLException {
		MovieDTO mDTO = null;

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "select * from movie where movie_idx=?";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, movieIdx);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				mDTO = new MovieDTO();
				mDTO.setMovieIdx(rs.getInt("movie_idx"));
				mDTO.setRunningTime(rs.getInt("running_time"));
				mDTO.setMovieName(rs.getString("movie_name"));
				mDTO.setReleaseDate(rs.getDate("release_date"));
				mDTO.setEndDate(rs.getDate("end_date"));
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return mDTO;
	}// selectOneMovie

	/**
	 * 상영스케줄을 추가하는 코드
	 * 
	 * @param schDTO
	 * @throws SQLException
	 */
	public void insertSchedule(ScheduleDTO schDTO) throws SQLException {

		DbConnection dbCon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = dbCon.getDbConn();
			String query = "insert into schedule(schedule_idx, movie_idx, theater_idx, screen_date, start_time, end_time)"
					+ "values(schedule_idx_seq.nextval,?,?,?,?,?)";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, schDTO.getMovieIdx());
			pstmt.setInt(2, schDTO.getTheaterIdx());
			pstmt.setDate(3, schDTO.getScreenDate());
			pstmt.setTimestamp(4, schDTO.getStartTime());
			pstmt.setTimestamp(5, schDTO.getEndTime());

			pstmt.executeUpdate();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
	}// insertSchedule

	/**
	 * 상영스케줄을 업데이트 하는 코드
	 * 
	 * @param schDTO
	 * @throws SQLException
	 */
	public void updateSchedule(ScheduleDTO schDTO) throws SQLException {

		DbConnection dbCon = DbConnection.getInstance();

		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "update schedule set movie_idx=?, theater_idx=?, screen_date=?, start_time=?, end_time=?, schedule_status=?, remain_seats=? where schedule_idx=?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, schDTO.getMovieIdx());
			pstmt.setInt(2, schDTO.getTheaterIdx());
			pstmt.setDate(3, schDTO.getScreenDate());
			pstmt.setTimestamp(4, schDTO.getStartTime());
			pstmt.setTimestamp(5, schDTO.getEndTime());
			pstmt.setInt(6, schDTO.getScheduleStatus());
			pstmt.setInt(7, schDTO.getRemainSeats());
			pstmt.setInt(8, schDTO.getScheduleIdx());

			pstmt.executeUpdate();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
	}// updateSchedule

	/**
	 * 상영스케줄 삭제하는 코드
	 * 
	 * @param ScheduleIdx
	 * @throws SQLException
	 */
	public void deleteSchedule(int ScheduleIdx) throws SQLException {
		DbConnection dbCon = DbConnection.getInstance();

		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "delete from schedule where schedule_idx=?";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, ScheduleIdx);
			pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
	}// deleteSchedule

	/**
	 * 해당 날짜 해당 상영관의 상영스케줄을 검색하는 코드
	 * 
	 * @param scDTO
	 * @return
	 * @throws SQLException
	 */
	public List<ScheduleDTO> selectScheduleWithDateAndTheater(int theaterIdx, Date screenDate) throws SQLException {
		List<ScheduleDTO> list = new ArrayList<ScheduleDTO>();

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "SELECT SCHEDULE_IDX, MOVIE_IDX, START_TIME, END_TIME, SCHEDULE_STATUS, REMAIN_SEATS FROM SCHEDULE where THEATER_IDX=? and SCREEN_DATE=?";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, theaterIdx);
			pstmt.setDate(2, screenDate);

			rs = pstmt.executeQuery();

			ScheduleDTO scDTO = null;
			while (rs.next()) {
				scDTO = new ScheduleDTO();
				scDTO.setScheduleIdx(rs.getInt("schedule_idx"));
				scDTO.setMovieIdx(rs.getInt("movie_idx"));
				scDTO.setStartTime(rs.getTimestamp("start_time"));
				scDTO.setEndTime(rs.getTimestamp("end_time"));
				scDTO.setScheduleStatus(rs.getInt("schedule_status"));
				scDTO.setRemainSeats(rs.getInt("remain_seats"));

				list.add(scDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}// selectScheduleWithDate

	/**
	 * 상영스케줄IDX로 특정 상영스케줄을 찾는 코드
	 * 
	 * @param scheduleIdx
	 * @return
	 * @throws SQLException
	 */
	public ScheduleDTO selectOneSchedule(int scheduleIdx) throws SQLException {
		ScheduleDTO schDTO = null;

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "SELECT SCHEDULE_IDX, MOVIE_IDX, THEATER_IDX, SCREEN_DATE, START_TIME, END_TIME, REMAIN_SEATS FROM SCHEDULE WHERE SCHEDULE_IDX=?";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, scheduleIdx);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				schDTO = new ScheduleDTO();
				schDTO.setScheduleIdx(rs.getInt("schedule_idx"));
				schDTO.setMovieIdx(rs.getInt("movie_idx"));
				schDTO.setTheaterIdx(rs.getInt("theater_idx"));
				schDTO.setScreenDate(rs.getDate("screen_date"));
				schDTO.setStartTime(rs.getTimestamp("start_time"));
				schDTO.setEndTime(rs.getTimestamp("end_time"));
				schDTO.setRemainSeats(rs.getInt("remain_seats"));
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return schDTO;
	}// selectOneSchedule

	/**
	 * 모든 스케줄 가져오는 코드
	 * 
	 * @return
	 * @throws SQLException
	 */
	public List<ScheduleDTO> selectAllSchedule() throws SQLException {
		List<ScheduleDTO> list = new ArrayList<ScheduleDTO>();

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "select SCHEDULE_IDX, MOVIE_IDX, THEATER_IDX, SCREEN_DATE, START_TIME, END_TIME, SCHEDULE_STATUS, REMAIN_SEATS from schedule";

			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			ScheduleDTO schDTO = null;
			while (rs.next()) {
				schDTO = new ScheduleDTO();
				schDTO.setScheduleIdx(rs.getInt("schedule_idx"));
				schDTO.setMovieIdx(rs.getInt("movie_idx"));
				schDTO.setTheaterIdx(rs.getInt("theater_idx"));
				schDTO.setScreenDate(rs.getDate("screen_date"));
				schDTO.setStartTime(rs.getTimestamp("start_time"));
				schDTO.setEndTime(rs.getTimestamp("end_time"));
				schDTO.setScheduleStatus(rs.getInt("schedule_status"));
				schDTO.setRemainSeats(rs.getInt("remain_seats"));

				list.add(schDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}// selectAllSchedule

	/**
	 * 해당 날짜의 상영스케줄을 가져오는 코드
	 * 
	 * @return
	 * @throws SQLException
	 */
	public List<ScheduleDTO> selectAllScheduleWithDate(Date screenDate) throws SQLException {
		List<ScheduleDTO> list = new ArrayList<ScheduleDTO>();

		DbConnection dbCon = DbConnection.getInstance();

		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "SELECT SCHEDULE_IDX, MOVIE_IDX, THEATER_IDX, SCREEN_DATE, START_TIME, END_TIME, SCHEDULE_STATUS, REMAIN_SEATS FROM SCHEDULE WHERE SCREEN_DATE=?";

			pstmt = con.prepareStatement(query);
			pstmt.setDate(1, screenDate);
			rs = pstmt.executeQuery();

			ScheduleDTO schDTO = null;
			while (rs.next()) {
				schDTO = new ScheduleDTO();
				schDTO.setScheduleIdx(rs.getInt("schedule_idx"));
				schDTO.setMovieIdx(rs.getInt("movie_idx"));
				schDTO.setTheaterIdx(rs.getInt("theater_idx"));
				schDTO.setScreenDate(rs.getDate("screen_date"));
				schDTO.setStartTime(rs.getTimestamp("start_time"));
				schDTO.setEndTime(rs.getTimestamp("end_time"));
				schDTO.setScheduleStatus(rs.getInt("schedule_status"));
				schDTO.setRemainSeats(rs.getInt("remain_seats"));

				list.add(schDTO);
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}// selectAllScheduleWithDate

	/**
	 * 해당 날짜 해당 영화의 스케줄을 가져오는 코드
	 * 
	 * @param movieIdx
	 * @param screenDate
	 * @return
	 * @throws SQLException
	 */
	public List<ScheduleDTO> selectAllScheduleWithDateAndMovie(int movieIdx, Date screenDate) throws SQLException {
		List<ScheduleDTO> list = new ArrayList<ScheduleDTO>();

		DbConnection dbCon = DbConnection.getInstance();

		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "SELECT SCHEDULE_IDX, MOVIE_IDX, THEATER_IDX, SCREEN_DATE, START_TIME, END_TIME, SCHEDULE_STATUS, REMAIN_SEATS FROM SCHEDULE WHERE MOVIE_IDX=? AND SCREEN_DATE=?";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, movieIdx);
			pstmt.setDate(2, screenDate);
			rs = pstmt.executeQuery();

			ScheduleDTO schDTO = null;
			while (rs.next()) {
				schDTO = new ScheduleDTO();
				schDTO.setScheduleIdx(rs.getInt("schedule_idx"));
				schDTO.setMovieIdx(rs.getInt("movie_idx"));
				schDTO.setTheaterIdx(rs.getInt("theater_idx"));
				schDTO.setScreenDate(rs.getDate("screen_date"));
				schDTO.setStartTime(rs.getTimestamp("start_time"));
				schDTO.setEndTime(rs.getTimestamp("end_time"));
				schDTO.setScheduleStatus(rs.getInt("schedule_status"));
				schDTO.setRemainSeats(rs.getInt("remain_seats"));

				list.add(schDTO);
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}// selectAllScheduleWithDateAndMovie

	/**
	 * 해당 날짜 해당 영화의 상영관의 상영스케줄과 상영관 정보
	 * 
	 * @return
	 * @throws SQLException
	 */
	public List<ScheduleTheaterDTO> selectAllScheduleAndTheaterWithDate(int movieIdx, Date screenDate) throws SQLException {
		List<ScheduleTheaterDTO> list = new ArrayList<ScheduleTheaterDTO>();
		DbConnection dbCon = DbConnection.getInstance();

		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "SELECT t.theater_idx, t.theater_name, t.theater_type, t.movie_price, s.schedule_idx, s.movie_idx, s.screen_date, s.start_time, s.end_time, s.schedule_status, s.remain_seats FROM theater t JOIN schedule s ON t.theater_idx = s.theater_idx WHERE s.screen_date=? AND s.movie_idx=?";
			
			pstmt = con.prepareStatement(query);
			pstmt.setDate(1, screenDate);
			pstmt.setInt(2, movieIdx);
			rs = pstmt.executeQuery();
			
			ScheduleTheaterDTO scthDTO = null;
			while(rs.next()) {
				scthDTO = new ScheduleTheaterDTO();
				scthDTO.setScheduleIdx(rs.getInt("schedule_idx"));
				scthDTO.setMovieIdx(rs.getInt("movie_idx"));
				scthDTO.setTheaterIdx(rs.getInt("theater_idx"));
				scthDTO.setScreenDate(rs.getDate("screen_date"));
				scthDTO.setStartTime(rs.getTimestamp("start_time"));
				scthDTO.setEndTime(rs.getTimestamp("end_time"));
				scthDTO.setScheduleStatus(rs.getInt("schedule_status"));
				scthDTO.setTheaterName(rs.getString("theater_name"));
				scthDTO.setTheaterType(rs.getString("theater_type"));
				scthDTO.setMoviePrice(rs.getInt("movie_price"));
				scthDTO.setRemainSeats(rs.getInt("remain_seats"));
				
				list.add(scthDTO);
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;

	}//selectAllScheduleAndTheaterWithDate

}// class
