package kr.co.yeonflix.theater;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;

public class TheaterDAO {

	private static TheaterDAO thDAO;

	private TheaterDAO() {

	}// TheaterDAO

	public static TheaterDAO getInstance() {
		if (thDAO == null) {
			thDAO = new TheaterDAO();
		}

		return thDAO;
	}// getInstance

	/**
	 * 모든 상영관을 가져오는 코드
	 * 
	 * @return
	 * @throws SQLException
	 */
	public List<TheaterDTO> selectAllTheater() throws SQLException {

		List<TheaterDTO> list = new ArrayList<TheaterDTO>();

		DbConnection dbCon = DbConnection.getInstance();

		Connection con = null;
		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {
			con = dbCon.getDbConn();
			String query = "select theater_idx, movie_price, theater_type, theater_name from theater";

			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			TheaterDTO thDTO = null;
			while (rs.next()) {
				thDTO = new TheaterDTO();
				thDTO.setTheaterIdx(rs.getInt("theater_idx"));
				thDTO.setMoviePrice(rs.getInt("movie_price"));
				thDTO.setTheaterType(rs.getString("theater_type"));
				thDTO.setTheaterName(rs.getString("theater_name"));

				list.add(thDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}// selectAllTheater

	/**
	 * 특정 IDX로 상영관을 찾는 코드
	 * @param theaterIdx
	 * @return
	 * @throws SQLException
	 */
	public TheaterDTO selectTheaterWithIdx(int theaterIdx) throws SQLException {
		TheaterDTO thDTO = null;
		DbConnection dbCon = DbConnection.getInstance();

		Connection con = null;
		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try {
			con = dbCon.getDbConn();
			String query = "select theater_idx, movie_price, theater_type, theater_name from theater where theater_idx=?";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, theaterIdx);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				thDTO = new TheaterDTO();
				thDTO.setTheaterIdx(rs.getInt("theater_idx"));
				thDTO.setMoviePrice(rs.getInt("movie_price"));
				thDTO.setTheaterType(rs.getString("theater_type"));
				thDTO.setTheaterName(rs.getString("theater_name"));

			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return thDTO;
	}// selectAllTheater

}
