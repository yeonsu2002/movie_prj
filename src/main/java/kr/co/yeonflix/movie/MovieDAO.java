package kr.co.yeonflix.movie;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;



public class MovieDAO {
	
private static MovieDAO mDAO;
	
	private MovieDAO() {
		
	}
	
	public static MovieDAO getInstance() {
		if(mDAO == null) {
			mDAO = new MovieDAO();
		}
		return mDAO;
	}
	
	public List<MovieDTO> selectMovieList() throws SQLException{
		
		List<MovieDTO> list = new ArrayList<MovieDTO>();
		
		DbConnection db = DbConnection.getInstance();
		
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;
		try {
			con = db.getDbConn();
			
			StringBuilder selectMovieList = new StringBuilder();
			selectMovieList.append("	select movie_idx,movie_name,poster_path,release_date,country,running_time,end_date,movie_description,screening_status,trailer_url	")
			.append("	from movie	");
		
			pstmt=con.prepareStatement(selectMovieList.toString());
			
			rs = pstmt.executeQuery();
			
			MovieDTO mDTO = null;
			while(rs.next()) {
				mDTO = new MovieDTO();
				mDTO.setMovieIdx(rs.getInt("movie_idx"));
				mDTO.setMovieName(rs.getString("movie_name"));
				mDTO.setPosterPath(rs.getString("poster_path"));
				mDTO.setReleaseDate(rs.getDate("release_date"));
				mDTO.setCountry(rs.getString("country"));
				mDTO.setRunningTime(rs.getInt("running_time"));
				mDTO.setEndDate(rs.getDate("end_date"));
				mDTO.setMovieDescription(rs.getString("movie_description"));
				mDTO.setScreeningStatus(rs.getInt("screening_status"));
				if(mDTO.getScreeningStatus() == 0) {
					mDTO.setScreeningStatusStr("상영예정");
				}else if(mDTO.getScreeningStatus() == 1) {
					mDTO.setScreeningStatusStr("상영중");
				}else {
					mDTO.setScreeningStatusStr("상영종료");
				}
				mDTO.setTrailerUrl(rs.getString("trailer_url"));
				
				list.add(mDTO);
			}//end while
		} finally {
			db.dbClose(rs, pstmt, con);
		}//finally
		
		return list;
	}//selectMovie
	
	public List<MovieDTO> selectMovieChart(Date today) throws SQLException{
		
		List<MovieDTO> list = new ArrayList<MovieDTO>();
		
		DbConnection db = DbConnection.getInstance();
		
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;
		try {
			con = db.getDbConn();
			
			StringBuilder selectMovie = new StringBuilder();
			selectMovie.append("select movie_idx,movie_name,poster_path,release_date,country,running_time,end_date,movie_description,screening_status,trailer_url")
			.append("from movie")
			.append("where end_date >= ?");
		
			pstmt=con.prepareStatement(selectMovie.toString());
			
			
			  
			pstmt.setDate(1, today);
			rs = pstmt.executeQuery();
			
			MovieDTO mDTO = null;
			while(rs.next()) {
				mDTO = new MovieDTO();
				mDTO.setMovieIdx(rs.getInt("movie_idx"));
				mDTO.setMovieName(rs.getString("movie_name"));
				mDTO.setPosterPath(rs.getString("poster_path"));
				mDTO.setReleaseDate(rs.getDate("release_date"));
				mDTO.setCountry(rs.getString("country"));
				mDTO.setRunningTime(rs.getInt("running_time"));
				mDTO.setEndDate(rs.getDate("end_date"));
				mDTO.setMovieDescription(rs.getString("movie_description"));
				mDTO.setScreeningStatus(rs.getInt("screening_status"));
				mDTO.setTrailerUrl(rs.getString("trailer_url"));
				
				list.add(mDTO);
			}//end while
		} finally {
			db.dbClose(rs, pstmt, con);
		}//finally
		
		return list;
	}//selectMovie
	
	public MovieDTO selectOneMovie(int num) throws SQLException {

		List<MovieDTO> list = new ArrayList<MovieDTO>();
		MovieDTO mDTO = null;
		
		DbConnection db = DbConnection.getInstance();
		
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;
		try {
			con = db.getDbConn();
			
			StringBuilder selectMovie = new StringBuilder();
			selectMovie.append("	select movie_idx,movie_name,poster_path,release_date,country,running_time,end_date,movie_description,screening_status,trailer_url	")
			.append("	from movie	")
			.append("	where movie_idx=?	");
		
			pstmt=con.prepareStatement(selectMovie.toString());
			
			
			  
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				mDTO = new MovieDTO();
				mDTO.setMovieIdx(rs.getInt("movie_idx"));
				mDTO.setMovieName(rs.getString("movie_name"));
				mDTO.setPosterPath(rs.getString("poster_path"));
				mDTO.setReleaseDate(rs.getDate("release_date"));
				mDTO.setCountry(rs.getString("country"));
				mDTO.setRunningTime(rs.getInt("running_time"));
				mDTO.setEndDate(rs.getDate("end_date"));
				mDTO.setMovieDescription(rs.getString("movie_description"));
				mDTO.setScreeningStatus(rs.getInt("screening_status"));
				mDTO.setTrailerUrl(rs.getString("trailer_url"));
				
				list.add(mDTO);
			}//end while
		} finally {
			db.dbClose(rs, pstmt, con);
		}//finally
		
		return mDTO;
	}//selectOneMovie
	
	
	
	
	
}
