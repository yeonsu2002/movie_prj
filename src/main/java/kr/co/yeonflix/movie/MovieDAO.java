package kr.co.yeonflix.movie;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
			selectMovieList.append("	select movie_idx,movie_name,poster_path,release_date,country,running_time,end_date,movie_description,screening_status,trailer_url, actors, directors	")
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
				mDTO.setActors(rs.getString("actors"));
				mDTO.setDirectors(rs.getString("directors"));
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
			selectMovie.append("	select movie_idx,movie_name,poster_path,release_date,country,running_time,end_date,movie_description,screening_status,trailer_url, actors, directors	")
			.append("	from movie	")
			.append("	where end_date >= ?	");
		
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
				mDTO.setActors(rs.getString("actors"));
				mDTO.setDirectors(rs.getString("directors"));
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
			selectMovie.append("	select movie_idx,movie_name,poster_path,release_date,country,running_time,end_date,movie_description,screening_status,trailer_url,actors,directors	")
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
				mDTO.setActors(rs.getString("actors"));
				mDTO.setDirectors(rs.getString("directors"));
				
				list.add(mDTO);
			}//end while
		} finally {
			db.dbClose(rs, pstmt, con);
		}//finally
		
		return mDTO;
	}//selectOneMovie
	
	public int insertMovie(MovieDTO mDTO) throws SQLException {
	    int movieIdx = 0;
	    DbConnection db =  DbConnection.getInstance();
	    String sql = "INSERT INTO movie (movie_idx, movie_name, poster_path, release_date, country, running_time, end_date, movie_description, screening_status, trailer_url, actors, directors) " +
	                 "VALUES (movie_idx_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)";

	    String[] generatedColumns = {"movie_idx"};

	    try (Connection conn = db.getDbConn();
	    		PreparedStatement pstmt = conn.prepareStatement(sql, generatedColumns)) {

	        pstmt.setString(1, mDTO.getMovieName());
	        pstmt.setString(2, mDTO.getPosterPath());
	        pstmt.setDate(3, mDTO.getReleaseDate());
	        pstmt.setString(4, mDTO.getCountry());
	        pstmt.setInt(5, mDTO.getRunningTime());
	        pstmt.setDate(6, mDTO.getEndDate());
	        pstmt.setString(7, mDTO.getMovieDescription());
	        pstmt.setInt(8, mDTO.getScreeningStatus());
	        pstmt.setString(9, mDTO.getTrailerUrl());
	        pstmt.setString(10, mDTO.getActors());
	        pstmt.setString(11, mDTO.getDirectors());

	        pstmt.executeUpdate();

	        // 생성된 movie_idx 반환
	        try (ResultSet rs = pstmt.getGeneratedKeys()) {
	            if (rs.next()) {
	                movieIdx = rs.getInt(1);
	            }
	        }
	    }

	    return movieIdx;
	}
	
	public void insertMovieCommonCode(int common, int num) throws SQLException {
	    DbConnection db = DbConnection.getInstance();

	    Connection con = null;
	    PreparedStatement pstmt = null;

	    try {
	        con = db.getDbConn();

	        String sql = "INSERT INTO MOVIE_COMMON_CODE_TABLE (MOVIE_IDX, CODE_IDX) SELECT ?, CODE_IDX FROM MOVIE_COMMON_TABLE WHERE CODE_IDX = ?"; 
	        
	        pstmt = con.prepareStatement(sql);
	        pstmt.setInt(1, num);
	        pstmt.setInt(2, common);

	        pstmt.executeUpdate();
	    } finally {
	        db.dbClose(null, pstmt, con);
	    }
	}

public int updateMovie(MovieDTO mDTO) throws SQLException{
		
		int rowCnt = 0;
		
		DbConnection db = DbConnection.getInstance();
		
		PreparedStatement pstmt = null;
		Connection con = null;
		
		try {
			//1. JNDI 사용객체 생성
			//2. DBCP에서 연결객체얻기(DataSource)
			//3. Connection 얻기
				con = db.getDbConn();
			//4. 쿼리문 생성객체 얻기
		StringBuilder updateBoard = new StringBuilder();
		updateBoard
		.append("	update movie	")
		.append("	set movie_name=?, poster_path=?, release_date=?, country=?, running_time=?, end_date=?, movie_description=?, screening_status=?, trailer_url=?, actors=?, directors=?")
		.append("	where movie_idx=? ");
		
		
		
		pstmt=con.prepareStatement(updateBoard.toString());
	//5. 바인드변수에 값 할당
	     pstmt.setString(1, mDTO.getMovieName());
	        pstmt.setString(2, mDTO.getPosterPath());
	        pstmt.setDate(3, mDTO.getReleaseDate());
	        pstmt.setString(4, mDTO.getCountry());
	        pstmt.setInt(5, mDTO.getRunningTime());
	        pstmt.setDate(6, mDTO.getEndDate());
	        pstmt.setString(7, mDTO.getMovieDescription());
	        pstmt.setInt(8, mDTO.getScreeningStatus());
	        pstmt.setString(9, mDTO.getTrailerUrl());
	        pstmt.setString(10, mDTO.getActors());
	        pstmt.setString(11, mDTO.getDirectors());
	        pstmt.setInt(12, mDTO.getMovieIdx());
	        
	        System.out.println(mDTO.getMovieIdx());
	//6. 쿼리문 수행 후 결과 얻기
		rowCnt = pstmt.executeUpdate();
		
	}finally{
	//7. 연결 끊기
		db.dbClose(null, pstmt, con);
	}//finally
		
		
		return rowCnt;
	}//updateBoard

public int updateMovieCommonCode(int code, int num, String common) throws SQLException {
    DbConnection db = DbConnection.getInstance();
    int rowCnt = 0;
    Connection con = null;
    PreparedStatement pstmt = null;
    
    System.out.println("code" +code);
    System.out.println("num" +num);
    System.out.println("common" +common);
    
    try {
        con = db.getDbConn();

        StringBuilder sql = new StringBuilder();
        sql.append("	UPDATE MOVIE_COMMON_CODE_TABLE	")
        .append("	SET CODE_IDX=?	")
        .append("	WHERE movie_idx=? and movie_code_name=?	");

        
        
            
            
        
        pstmt = con.prepareStatement(sql.toString());
        pstmt.setInt(1, code);
        pstmt.setInt(2, num);
        pstmt.setString(3, common);
        rowCnt = pstmt.executeUpdate();
    } finally {
        db.dbClose(null, pstmt, con);
    }
    return rowCnt;
}



	public int deleteMovie(int movieIdx) throws SQLException{
	int rowCnt = 0;
		
		DbConnection db = DbConnection.getInstance();
		
		PreparedStatement pstmt = null;
		Connection con = null;
		
		try {
			//1. JNDI 사용객체 생성
			//2. DBCP에서 연결객체얻기(DataSource)
			//3. Connection 얻기
				con = db.getDbConn();
			//4. 쿼리문 생성객체 얻기
		StringBuilder deleteBoard = new StringBuilder();
		deleteBoard
		.append("	delete from movie")
		.append("	where movie_idx=? ");
		
		
		
		pstmt=con.prepareStatement(deleteBoard.toString());
	//5. 바인드변수에 값 할당
		pstmt.setInt(1, movieIdx);
	//6. 쿼리문 수행 후 결과 얻기
		rowCnt = pstmt.executeUpdate();
		
	}finally{
	//7. 연결 끊기
		db.dbClose(null, pstmt, con);
	}//finally
		
		
		return rowCnt;
	}
	
}//class
