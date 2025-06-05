package kr.co.yeonflix.movie;

import java.sql.Date;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import kr.co.yeonflix.movie.people.PeopleService;



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
	
	public List<MovieDTO> searchNonMovieChart(){
		List<MovieDTO> list = new ArrayList<MovieDTO>();
		MovieDAO mDAO = MovieDAO.getInstance();
		LocalDate today = LocalDate.now();
		Date date = Date.valueOf(today);
		
		try {
			list = mDAO.selectNonMovieChart(date);
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
	
	public double reservationRate(int num) {
		int count = 0;
		int totalCount = 0;
		double result = 0;
		MovieDAO mDAO = MovieDAO.getInstance();
		try {
			count = mDAO.selectMovieReservation(num);
			totalCount = mDAO.selectMovieReservationCount();
			//예매율(%) = (특정 영화의 예매 건수 / 전체 영화의 예매 건수) × 100
			result = ((double)count / totalCount) * 100; 
			
			result = Math.round(result * 100) / 100.0; // 소수점 둘째자리까지 반올림
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return result;
		
	}
	
	public boolean addMovie(int genreCode, int gradeCode , MovieDTO mDTO) {
	    boolean flag = false;

	    PeopleService ps = new PeopleService();
	    MovieDAO mDAO = MovieDAO.getInstance();
	    
	    try {
	        // 1. 영화 테이블에 등록
	        int movieIdx = mDAO.insertMovie(mDTO);  // movie_seq.NEXTVAL
	        mDTO.setMovieIdx(movieIdx);  // movie_idx를 DTO에 저장
	        
	        
	        mDAO.insertMovieCommonCode(genreCode, movieIdx);  // 영화등급장르코드 테이블
	        
	        
	        mDAO.insertMovieCommonCode(gradeCode, movieIdx);  // 영화등급장르코드 테이블

	        flag = true;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return flag;
	}
	
	public boolean modifyMovie(int genreCode, int gradeCode , MovieDTO mDTO) {
		boolean flag = false;
		boolean flag2 = false;
		boolean flag3 = false;
		boolean flag4 = false;
		
		
		MovieDAO mDAO = MovieDAO.getInstance();
		try {
			
			
			flag2 = mDAO.updateMovie(mDTO) == 1;
			flag3 = mDAO.updateMovieCommonCode(genreCode, mDTO.getMovieIdx(), "장르") == 1;
			flag4 = mDAO.updateMovieCommonCode(gradeCode, mDTO.getMovieIdx(), "등급") == 1;
			
			
			System.out.println(flag2);
			System.out.println(flag3);
			System.out.println(flag4);
			flag = flag2 && flag3 && flag4;
		} catch (SQLException e) {
			e.printStackTrace();
		}//end catch
		
		return flag;
	}//modifyBoard
	
	
	
	public boolean removeMovie(int movieIdx) {
		
		boolean flag = false;
		
		MovieDAO mDAO = MovieDAO.getInstance();
		
		try {
			flag = mDAO.deleteMovie(movieIdx) == 1;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return flag;
	}
	
	
	
	

	
}
