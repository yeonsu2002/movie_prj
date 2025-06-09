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
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public String searchOneGrade(int movieIdx) {
	    MovieCommonCodeDTO mccDTO = new MovieCommonCodeDTO();
	    MovieCommonCodeDAO mccDAO = MovieCommonCodeDAO.getInstance();
	    String grade = "";
	    
	    try {
	    	mccDTO = mccDAO.selectOneCommon("등급",movieIdx);
	    	grade = mccDTO.getCodeName();
	       
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return grade;
	}
	public String searchOneGenre(int movieIdx) {
		MovieCommonCodeDTO mccDTO = new MovieCommonCodeDTO();
		MovieCommonCodeDAO mccDAO = MovieCommonCodeDAO.getInstance();
		String grade = "";
		
		try {
			mccDTO = mccDAO.selectOneCommon("장르",movieIdx);
			grade = mccDTO.getCodeName();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return grade;
	}
	
	public int searchOneGradeIdx(int movieIdx) {
	    MovieCommonCodeDTO mccDTO = new MovieCommonCodeDTO();
	    MovieCommonCodeDAO mccDAO = MovieCommonCodeDAO.getInstance();
	    int gradeIdx = 0;;
	    
	    try {
	    	mccDTO = mccDAO.selectOneCommon("등급",movieIdx);
	    	gradeIdx = mccDTO.getCodeIdx();
	       
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return gradeIdx;
	}
	public int searchOneGenreIdx(int movieIdx) {
		MovieCommonCodeDTO mccDTO = new MovieCommonCodeDTO();
		MovieCommonCodeDAO mccDAO = MovieCommonCodeDAO.getInstance();
		int genreIdx = 0;
		
		try {
			mccDTO = mccDAO.selectOneCommon("장르",movieIdx);
			genreIdx = mccDTO.getCodeIdx();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return genreIdx;
	}
}