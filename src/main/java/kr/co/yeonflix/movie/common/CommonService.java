package kr.co.yeonflix.movie.common;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CommonService {
	
	
	
	public List<CommonDTO> genreList(){
		CommonDAO gDAO = CommonDAO.getInstance();
		List<CommonDTO> list = new ArrayList<CommonDTO>();
		
		try {
			list = gDAO.selectGenre();
		} catch (SQLException e) {
			e.printStackTrace();
		}//end catch
		
		return list;
	}//genreList
	
	public List<CommonDTO> gradeList(){
		CommonDAO gDAO = CommonDAO.getInstance();
		List<CommonDTO> list = new ArrayList<CommonDTO>();
		
		try {
			list = gDAO.selectGrade();
		} catch (SQLException e) {
			e.printStackTrace();
		}//end catch
		
		return list;
	}//genreList
	
	
	
	
}