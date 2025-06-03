package kr.co.yeonflix.movie.code;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MovieCommonCodeService {
	
//	public List<MovieCommonCodeDTO> searchCommon(int movieIdx) {
//		List<MovieCommonCodeDTO> list = new ArrayList<MovieCommonCodeDTO>();
//		MovieCommonCodeDAO mccDAO = MovieCommonCodeDAO.getInstance();
//		
//		try {
//			list= mccDAO.selectCommon(movieIdx);
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}
//		
//		
//		return list;
//	}
	
	public List<MovieCommonCodeDTO> searchCommon(int movieIdx) {
	    List<MovieCommonCodeDTO> list = new ArrayList<MovieCommonCodeDTO>();
	    MovieCommonCodeDAO mccDAO = MovieCommonCodeDAO.getInstance();
	    
	    try {
	        list = mccDAO.selectCommon(movieIdx);
	        // 디버깅 로그
	        System.out.println("검색된 코드 목록:");
	        for(MovieCommonCodeDTO dto : list) {
	            System.out.println("CodeIdx: " + dto.getCodeIdx() + 
	                             ", Type: " + dto.getCodeType());
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}
}
