package kr.co.yeonflix.purchaseHistory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import kr.co.yeonflix.dao.DbConnection;

public class PurchaseHistoryDAO {

	private static PurchaseHistoryDAO phDAO = null;

	private PurchaseHistoryDAO() {

	}

	public static PurchaseHistoryDAO getInstance() {
		if (phDAO == null) {
			phDAO = new PurchaseHistoryDAO();
		}

		return phDAO;
	}// getInstance

	/**
	 * 구매내역 생성하는 코드(바로 구매상태 1로 생성)
	 * 
	 * @throws SQLException
	 */
	public void insertPurchaseHistory(PurchaseHistoryDTO phDTO) throws SQLException {
		DbConnection dbCon = DbConnection.getInstance();
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "insert into PURCHASE_HISTORY(PURCHASE_HISTORY_IDX, USER_IDX, RESERVATION_IDX) values(PURCHASE_HISTORY_IDX_SEQ.nextval, ?, ?)";

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, phDTO.getUserIdx());
			pstmt.setInt(2, phDTO.getReservationIdx());

			pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
	}// insertPurchaseHistory

	/**
	 * 구매 내역 업데이트 하는 코드 (구매완료 -> 구매취소)
	 * 
	 * @param phDTO
	 * @throws SQLException
	 */
	public void updatePurchaseHistory(PurchaseHistoryDTO phDTO) throws SQLException {
		DbConnection dbCon = DbConnection.getInstance();
		PreparedStatement pstmt = null;
		Connection con = null;

		try {
			con = dbCon.getDbConn();
			String query = "update PURCHASE_HISTORY set IS_PURCHASED=0 where PURCHASE_HISTORY_IDX=?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, phDTO.getPurchaseHistoryIdx());
			pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
	}// updatePurchaseHistory

	/**
	 * 해당 유저가 해당 영화를 관람한적이 있는지
	 * @param userIdx
	 * @param movieIdx
	 * @return
	 * @throws SQLException
	 */
	public boolean hasPurchased(int userIdx, int movieIdx) throws SQLException {
		boolean flag = false;

		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;

		 try {
		        con = dbCon.getDbConn();
		        String sql = 
		            "SELECT COUNT(*) " +
		            "FROM purchase_history ph " +
		            "JOIN reservation r ON ph.reservation_idx = r.reservation_idx " +
		            "JOIN schedule s ON r.schedule_idx = s.schedule_idx " +
		            "WHERE ph.is_purchased = 1 " +
		            "AND ph.user_idx = ? " +
		            "AND s.movie_idx = ?";

		        pstmt = con.prepareStatement(sql);
		        pstmt.setInt(1, userIdx);
		        pstmt.setInt(2, movieIdx);
		        rs = pstmt.executeQuery();

		        if (rs.next()) {
		            int count = rs.getInt(1);
		            flag = (count > 0);
		        }

		    } finally {
		        dbCon.dbClose(rs, pstmt, con);
		    }
		return flag;
	}
}
