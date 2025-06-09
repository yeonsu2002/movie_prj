package kr.co.yeonflix.movie.saved;

import java.sql.SQLException;
import java.util.List;

import kr.co.yeonflix.movie.MovieDTO;
import kr.co.yeonflix.movie.MovieService;



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
	
	
	// 사용자가 찜한 영화 목록을 가져오는 메서드
	public List<SavedMovieDTO> savedAllMovie(int userIdx) throws SQLException {
	    SavedMovieDAO smDAO = SavedMovieDAO.getInstance();
	    List<SavedMovieDTO> savedMovies = smDAO.selectSavedMoviesByUser(userIdx);

	    // MovieService 객체를 사용하여 영화 정보를 채움
	    MovieService movieService = new MovieService();  // MovieService 객체 생성

	    for (SavedMovieDTO savedMovie : savedMovies) {
	        // movieIdx를 이용하여 MovieDTO 정보를 가져와서 savedMovie에 세팅
	        MovieDTO movie = movieService.searchOneMovie(savedMovie.getMovieIdx()); // 영화 정보 가져오기

	        // 영화 정보를 savedMovie에 설정
	        savedMovie.setMovieName(movie.getMovieName());
	        savedMovie.setPosterPath(movie.getPosterPath());  // 포스터 경로 설정
	        savedMovie.setReleaseDate(movie.getReleaseDate());
	        savedMovie.setRunningTime(movie.getRunningTime());
	    }

	    return savedMovies;  // 영화 정보가 채워진 SavedMovieDTO 리스트 반환
	}

}
