package kr.co.yeonflix.purchaseHistory;

import java.sql.SQLException;

public class PurchaseHistoryService {

	/**
	 * 구매내역 추가하는 코드
	 * @param phDTO
	 * @return
	 */
	public boolean addPurchaseHistory(PurchaseHistoryDTO phDTO) {
		boolean flag = false;
		
		PurchaseHistoryDAO phDAO = PurchaseHistoryDAO.getInstance();
		try {
			phDAO.insertPurchaseHistory(phDTO);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}//addPurchaseHistory
	
	/**
	 * 구매 내역 업데이트 하는 코드 (구매완료 -> 구매취소)
	 * @param phDTO
	 * @return
	 */
	public boolean modifyPurchaseHistory(PurchaseHistoryDTO phDTO) {
		boolean flag = false;
		
		PurchaseHistoryDAO phDAO = PurchaseHistoryDAO.getInstance();
		try {
			phDAO.updatePurchaseHistory(phDTO);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}//modifyPurchaseHistory
	
	/**
	 * 해당 유저가 해당 영화를 관람한적이 있는지
	 * @param userIdx
	 * @param movieIdx
	 * @return
	 */
	public boolean hasPurchasedMovie(int userIdx, int movieIdx) {
		boolean flag = false;
		
		PurchaseHistoryDAO phDAO = PurchaseHistoryDAO.getInstance();
		try {
			flag = phDAO.hasPurchased(userIdx, movieIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}//hasPurchasedMovie
}
