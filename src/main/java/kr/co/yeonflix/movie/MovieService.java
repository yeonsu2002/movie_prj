package kr.co.yeonflix.movie;

import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class MovieService {
	
	public List<MovieDTO> searchMovieChart(){
		List<MovieDTO> list = new ArrayList<MovieDTO>();
		MovieDAO mDAO = MovieDAO.getInstance();
		LocalDate today = LocalDate.now();
		Date date = Date.valueOf(today);
		
		try {
			list = mDAO.selectMovieChart(date);
		} catch (SQLException e) {
			e.printStackTrace();
		}//catch
		
		return list;
	}//searchMovieChart
	
	public List<MovieDTO> searchMovieList(){
		List<MovieDTO> list = new ArrayList<MovieDTO>();
		MovieDAO mDAO = MovieDAO.getInstance();
		
		try {
			list = mDAO.selectMovieList();
		} catch (SQLException e) {
			e.printStackTrace();
		}//catch
		
		return list;
	}//searchMovieList
	
	public MovieDTO searchOneMovie(int num) {
		MovieDTO mDTO = null;
		MovieDAO mDAO = MovieDAO.getInstance();
		
		try {
			mDTO = mDAO.selectOneMovie(num);
		} catch (SQLException e) {
			e.printStackTrace();
		}//catch
		
		return mDTO;
	}//searchOneMovie
}
