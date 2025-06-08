package kr.co.yeonflix.movie.saved;

import java.sql.SQLException;

public class SavedMovieService {
	
	public boolean addSavedMovie(int movieIdx, int userIdx) {
		SavedMovieDAO smDAO = SavedMovieDAO.getInstance();
		boolean flag = false;
		try {
			smDAO.insertSavedMovie(movieIdx, userIdx);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return flag;
	}
	public boolean removeSavedMovie(int movieIdx, int userIdx) {
		SavedMovieDAO smDAO = SavedMovieDAO.getInstance();
		boolean flag = false;
		try {
			smDAO.deleteSavedMovie(movieIdx, userIdx);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return flag;
	}
	
	public boolean checkSavedMovieStatus(int movieIdx, int userIdx) {
		SavedMovieDAO smDAO = SavedMovieDAO.getInstance();
		
		boolean flag = false;
		
		try {
			flag = smDAO.selectSavedMovie(movieIdx, userIdx);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return flag;
	}
}
