package kr.co.yeonflix.dashboard;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import kr.co.yeonflix.dao.DbConnection;

public class DashboardDAO {

	private static DashboardDAO dao;

	private DashboardDAO() {
	}

	public static DashboardDAO getInstance() {
		if (dao == null) {
			dao = new DashboardDAO();
		}
		return dao;
	}

	/**
	 * 일별 총 매출 데이터를 가져오는 메서드 (취소되지 않은 예매만 포함)
	 */
	public List<DashboardDTO> getDailySales() {
		List<DashboardDTO> salesList = new ArrayList<>();
		DbConnection dbCon = DbConnection.getInstance();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "WITH date_range AS (" + "  SELECT TO_CHAR(SYSDATE - LEVEL + 1, 'YYYY-MM-DD') AS RES_DATE "
				+ "  FROM dual " + "  CONNECT BY LEVEL <= 7" + ") " + "SELECT dr.RES_DATE, "
				+ "       COALESCE(SUM(r.TOTAL_PRICE), 0) AS TOTAL_SALES " + "FROM date_range dr "
				+ "LEFT JOIN reservation r ON TO_CHAR(r.RESERVATION_DATE, 'YYYY-MM-DD') = dr.RES_DATE "
				+ "AND r.CANCELED_DATE IS NULL " + "GROUP BY dr.RES_DATE " + "ORDER BY dr.RES_DATE";

		try {
			con = dbCon.getDbConn();
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				String date = rs.getString("res_date");
				int totalSales = rs.getInt("total_sales");
				salesList.add(DashboardDTO.ofDailySales(date, totalSales));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				dbCon.dbClose(rs, pstmt, con);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return salesList;
	}


    /**
     * 예매된 극장 종류 조회
     */
	public List<DashboardDTO> getReservationByTheaterType() {
		List<DashboardDTO> theaterList = new ArrayList<>();
		DbConnection dbCon = DbConnection.getInstance();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT t.theater_type, COUNT(*) AS reservation_count " + "FROM reservation r "
				+ "JOIN schedule s ON r.schedule_idx = s.schedule_idx "
				+ "JOIN theater t ON s.theater_idx = t.theater_idx " + "WHERE r.canceled_date IS NULL "
				+ "AND r.reservation_date >= TRUNC(SYSDATE) - 6 " + "AND r.reservation_date < TRUNC(SYSDATE) + 1 "
				+ "GROUP BY t.theater_type";

		try {
			con = dbCon.getDbConn();
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				String theaterType = rs.getString("theater_type");
				int count = rs.getInt("reservation_count");
				theaterList.add(DashboardDTO.ofTheaterReservation(theaterType, count));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				dbCon.dbClose(rs, pstmt, con);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return theaterList;
	}

	/**
	 * 상영중인 인기 영화 TOP 5 예매 건수 조회 (취소되지 않은 예약만)
	 */
	public List<DashboardDTO> getTop5Movies() {
		List<DashboardDTO> topMoviesList = new ArrayList<>();
		DbConnection dbCon = DbConnection.getInstance();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "SELECT m.movie_name, COUNT(*) AS reservation_count " + "FROM reservation r "
				+ "JOIN schedule s ON r.schedule_idx = s.schedule_idx " + "JOIN movie m ON s.movie_idx = m.movie_idx "
				+ "WHERE r.canceled_date IS NULL " + "  AND m.screening_status = 0 "
				+ "  AND r.reservation_date >= TRUNC(SYSDATE) - 6 " + "  AND r.reservation_date < TRUNC(SYSDATE) + 1 "
				+ "GROUP BY m.movie_name " + "ORDER BY reservation_count DESC " + "FETCH FIRST 5 ROWS ONLY";

		try {
			con = dbCon.getDbConn();
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				String title = rs.getString("movie_name");
				int count = rs.getInt("reservation_count");
				topMoviesList.add(DashboardDTO.ofTopMovie(title, count));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				dbCon.dbClose(rs, pstmt, con);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return topMoviesList;
	}
	/**
	 * 회원/비회원 예매 건수 조회 (취소되지 않은 예약만, 최근 7일)
	 */
	public List<DashboardDTO> getMemberReservationCount() {
		List<DashboardDTO> memberDailyList = new ArrayList<>();
	    DbConnection dbCon = DbConnection.getInstance();

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql =
	    	    "WITH dates AS ( " +
	    	    "    SELECT TO_CHAR(SYSDATE - LEVEL + 1, 'YYYY-MM-DD') res_date FROM dual CONNECT BY LEVEL <= 7 " +
	    	    "), types AS ( " +
	    	    "    SELECT '회원' type FROM dual UNION ALL SELECT '비회원' FROM dual " +
	    	    "), combo AS ( " +
	    	    "    SELECT d.res_date, t.type FROM dates d CROSS JOIN types t " +
	    	    ") " +
	    	    "SELECT c.res_date, c.type AS member_type, " +
	    	    "       COUNT(r.reservation_idx) AS reservation_count " +
	    	    "FROM combo c " +
	    	    "LEFT JOIN reservation r ON TO_CHAR(r.reservation_date, 'YYYY-MM-DD') = c.res_date " +
	    	    "  AND r.canceled_date IS NULL " +
	    	    "  AND ( (c.type = '회원' AND r.user_idx IS NOT NULL) OR (c.type = '비회원' AND r.user_idx IS NULL) ) " +
	    	    "GROUP BY c.res_date, c.type " +
	    	    "ORDER BY c.res_date, c.type";

	    try {
	        con = dbCon.getDbConn();
	        pstmt = con.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            String date = rs.getString("res_date");
	            String memberType = rs.getString("member_type");
	            int count = rs.getInt("reservation_count");
	            memberDailyList.add(DashboardDTO.ofMemberReservationByDate(date, memberType, count));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            dbCon.dbClose(rs, pstmt, con);
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    return memberDailyList;
	}
	
}// class
