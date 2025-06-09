package kr.co.yeonflix.movie.saved;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;

public class SavedMovieDAO {
	
	private static SavedMovieDAO sDAO;
	
	private SavedMovieDAO() {
		
	}
	
	public static SavedMovieDAO getInstance() {
		
		if(sDAO == null) {
			sDAO = new SavedMovieDAO();
		}
		
		return sDAO;
	}
	
	public void insertSavedMovie(int movieIdx, int userIdx) throws SQLException{
		
		DbConnection db = DbConnection.getInstance();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			
			con = db.getDbConn();
			
			StringBuilder insertSavedMovie = new StringBuilder();
			
			insertSavedMovie.append("	insert into saved_movie (MOVIE_IDX, USER_IDX)	")
			.append("	values(?, ?)	");
			
			pstmt = con.prepareStatement(insertSavedMovie.toString());
			
			pstmt.setInt(1, movieIdx);
			pstmt.setInt(2, userIdx);
			
			pstmt.executeUpdate();
			
			
		}finally {
			db.dbClose(null, pstmt, con);
		}
		
	}
	public int deleteSavedMovie(int movieIdx, int userIdx) throws SQLException{
		int rowCnt = 0;
		DbConnection db = DbConnection.getInstance();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			
			con = db.getDbConn();
			
			StringBuilder insertSavedMovie = new StringBuilder();
			
			insertSavedMovie.append("	delete from saved_movie	")
			.append("	where movie_idx = ? and user_idx = ?	");
			
			pstmt = con.prepareStatement(insertSavedMovie.toString());
			pstmt.setInt(1, movieIdx);
			pstmt.setInt(2, userIdx);
			
			rowCnt = pstmt.executeUpdate();
			
		}finally {
			db.dbClose(null, pstmt, con);
		}
		
		return rowCnt;
	}
	
	public boolean selectSavedMovie(int movieIdx, int userIdx) throws SQLException {
		boolean flag = false;
		DbConnection db = DbConnection.getInstance();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			con = db.getDbConn();
			
			StringBuilder checkSavedMovie = new StringBuilder();
			
			checkSavedMovie.append("	SELECT COUNT(*) 	")
			.append("	FROM saved_movie	")
			.append("	WHERE movie_idx = ? AND user_idx = ?	");
			
			pstmt = con.prepareStatement(checkSavedMovie.toString());
			pstmt.setInt(1, movieIdx);
			pstmt.setInt(2, userIdx);
			
			rs = pstmt.executeQuery();

			if (rs.next()) {
			    int count = rs.getInt(1);  // COUNT(*) 결과는 1번째 컬럼
			    flag = count > 0;
			}
			
		}finally {
			db.dbClose(null, pstmt, con);
		}
		
		return flag;
	}
	
	
	public List<SavedMovieDTO> selectSavedMoviesByUser(int userIdx) throws SQLException {
	    List<SavedMovieDTO> savedMovies = new ArrayList<>();
	    DbConnection db = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        con = db.getDbConn();
	        StringBuilder selectSavedMovies = new StringBuilder();
	        selectSavedMovies.append("SELECT movie_idx FROM saved_movie ")
	                         .append("WHERE user_idx = ?");

	        pstmt = con.prepareStatement(selectSavedMovies.toString());
	        pstmt.setInt(1, userIdx);

	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            SavedMovieDTO savedMovie = new SavedMovieDTO();
	            savedMovie.setMovieIdx(rs.getInt("movie_idx"));
	            savedMovies.add(savedMovie);
	        }
	    } finally {
	        db.dbClose(rs, pstmt, con);
	    }

	    return savedMovies;
	}
	
}
