package kr.co.yeonflix.theater;

import java.sql.SQLException;
import java.util.List;

public class TheaterService {

	/**
	 * 모든 상영관 가져오는 코드
	 * @return
	 */
	public List<TheaterDTO> searchAllTheater(){
		List<TheaterDTO> list = null;
		
		TheaterDAO thDAO = TheaterDAO.getInstance();
		try {
			list = thDAO.selectAllTheater();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}//searchAllTheater
	
	/**
	 * IDX값으로 특정 상영관 가져오는 코드
	 * @param theaterIdx
	 * @return
	 */
	public TheaterDTO searchTheaterWithIdx(int theaterIdx) {
		TheaterDTO thDTO = null;
		
		TheaterDAO thDAO = TheaterDAO.getInstance();
		try {
			thDTO = thDAO.selectTheaterWithIdx(theaterIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return thDTO;
	}//searchTheaterWithIdx
	
}
