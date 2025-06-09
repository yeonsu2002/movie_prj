package kr.co.yeonflix.movie;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;
import kr.co.yeonflix.util.RangeDTO;



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
	
	public int selectTotalCount(RangeDTO rDTO) throws SQLException{
		int cnt = 0;
		
		DbConnection db = DbConnection.getInstance();
		
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;
		try {
		//1. JNDI 사용객체 생성
		//2. DBCP에서 연결객체얻기(DataSource)
		//3. Connection 얻기
			con = db.getDbConn();
		//4. 쿼리문 생성객체 얻기
			StringBuilder selectIdQuery = new StringBuilder();
			selectIdQuery
			.append("	select	count(movie_idx) cnt			")
			.append("	from	movie	");
			//검색 키워드가 존재
			if(rDTO.getKeyword() != null && !"".equals(rDTO.getKeyword())){
				selectIdQuery.append("where	instr(").append(rDTO.getFieldName()).append(",?) != 0");
			}//end if
			
			pstmt=con.prepareStatement(selectIdQuery.toString());
		//5. 바인드변수에 값 할당
//			pstmt.setString(1, id);
			
			if(rDTO.getKeyword() != null && !"".equals(rDTO.getKeyword())){
				pstmt.setString(1, rDTO.getKeyword());
			}//end if
		//6. 쿼리문 수행 후 결과 얻기
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				cnt=rs.getInt("cnt");
			}//end if
			
		}finally{
		//7. 연결 끊기
			db.dbClose(rs, pstmt, con);
		}
		return cnt;
	}//selectId
	
	
	
	
	
	
	
	
	
	
	
	
	public List<MovieDTO> selectMovieList(RangeDTO rDTO) throws SQLException{
		
		List<MovieDTO> list = new ArrayList<MovieDTO>();
		
		DbConnection db = DbConnection.getInstance();
		
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;
		try {
			con = db.getDbConn();
			
			StringBuilder selectMovieList = new StringBuilder();
			selectMovieList.append(" SELECT movie_idx, movie_name, poster_path, release_date, country, running_time, ")
		    .append(" end_date, movie_description, trailer_url, actors, directors, ")
		    .append(" CASE screening_status ")
		    .append("     WHEN 0 THEN '상영예정' ")
		    .append("     WHEN 1 THEN '상영중' ")
		    .append("     WHEN 2 THEN '상영종료' ")
		    .append(" END AS status_name ")
		    .append(" FROM ( ")
		    .append("     SELECT movie_idx, movie_name, poster_path, release_date, country, running_time, ")
		    .append("            end_date, movie_description, trailer_url, actors, directors, ")
		    .append("            screening_status, ")
		    .append("            ROW_NUMBER() OVER ( ")
		    .append("                ORDER BY ")
		    .append("                    CASE screening_status ")
		    .append("                        WHEN 1 THEN 1 ") // 상영중
		    .append("                        WHEN 0 THEN 2 ") // 상영예정
		    .append("                        WHEN 2 THEN 3 ") // 상영종료
		    .append("                    END, ")
		    .append("                    release_date DESC, ")
		    .append("                    end_date DESC ")
		    .append("            ) AS rnum ")
		    .append("     FROM movie ");

		
			
			if(rDTO.getKeyword() != null && !"".equals(rDTO.getKeyword())){
				selectMovieList.append("where	instr(").append(rDTO.getFieldName()).append(",?) != 0");
			}//end if
			selectMovieList.append("	)where rnum between ? and ?");
			
			pstmt=con.prepareStatement(selectMovieList.toString());

			int bindInd = 1;
			if(rDTO.getKeyword() != null && !"".equals(rDTO.getKeyword())){
				pstmt.setString(bindInd++, rDTO.getKeyword());
			}
			pstmt.setInt(bindInd++, rDTO.getStartNum());
			pstmt.setInt(bindInd++, rDTO.getEndNum());
				

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
				mDTO.setScreeningStatusStr(rs.getString("status_name"));
				mDTO.setActors(rs.getString("actors"));
				mDTO.setDirectors(rs.getString("directors"));
				mDTO.setScreeningStatusStr(rs.getString("status_name"));
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

			
			selectMovie.append("	SELECT m.movie_idx ,COUNT(m.movie_idx) as rank_movie, m.movie_idx, m.movie_name, m.poster_path, m.release_date, m.country, m.running_time, m.end_date, m.movie_description, m.screening_status, m.trailer_url,  m.actors,  m.directors	")
			.append("	FROM MOVIE m	")
			.append("	INNER JOIN SCHEDULE s ON m.movie_idx = s.movie_idx	")
			.append("	INNER JOIN RESERVATION r ON s.schedule_idx = r.schedule_idx	")
			.append("	WHERE r.canceled_date is null and end_date >= ?	")
			.append("	group by m.movie_idx,m.movie_name, m.poster_path, m.release_date, m.country, m.running_time, m.end_date, m.movie_description, m.screening_status, m.trailer_url,  m.actors,  m.directors	")
			.append("	order by rank_movie desc	");
			
//			selectMovie.append("   SELECT m.movie_idx ,COUNT(m.movie_idx) as rank_movie, m.movie_idx, m.movie_name, m.poster_path, m.release_date, m.country, m.running_time, m.end_date, m.movie_description, m.screening_status, m.trailer_url,  m.actors,  m.directors   ")
//	         .append("   FROM MOVIE m   ")
//	         .append("   INNER JOIN SCHEDULE s ON m.movie_idx = s.movie_idx   ")
//	         //.append("   INNER JOIN RESERVATION r ON s.schedule_idx = r.schedule_idx   ")
//	         .append("   WHERE  end_date >= ? AND s.schedule_status = 0   ")
//	         .append("   group by m.movie_idx,m.movie_name, m.poster_path, m.release_date, m.country, m.running_time, m.end_date, m.movie_description, m.screening_status, m.trailer_url,  m.actors,  m.directors   ")
//	         .append("   order by rank_movie desc   ");
//			
			

			
			
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
	
	
public List<MovieDTO> selectNonMovieChart(Date today) throws SQLException{
		
		List<MovieDTO> list = new ArrayList<MovieDTO>();
		
		DbConnection db = DbConnection.getInstance();
		
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		Connection con = null;
		try {
			con = db.getDbConn();
			
			StringBuilder selectMovie = new StringBuilder();
			
			selectMovie.append(" SELECT m.movie_idx, COUNT(r.reservation_idx) as rank_movie, m.movie_name, m.poster_path, m.release_date, m.country, m.running_time, m.end_date, m.movie_description, m.screening_status, m.trailer_url, m.actors, m.directors ")
			.append(" FROM MOVIE m ")
			.append(" LEFT JOIN SCHEDULE s ON m.movie_idx = s.movie_idx ")
			.append(" LEFT JOIN RESERVATION r ON s.schedule_idx = r.schedule_idx AND r.canceled_date IS NULL ")
			.append(" WHERE m.end_date >= ? ")
			.append(" GROUP BY m.movie_idx, m.movie_name, m.poster_path, m.release_date, m.country, m.running_time, m.end_date, m.movie_description, m.screening_status, m.trailer_url, m.actors, m.directors ")
			.append(" HAVING COUNT(r.reservation_idx) = 0 ")
			.append(" ORDER BY COUNT(r.reservation_idx) DESC ");
			
			
			
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
	
	public int selectMovieReservation(int num) throws SQLException {
		
		DbConnection db = DbConnection.getInstance();
		int count = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			con = db.getDbConn();
			
			StringBuilder selectMovieReservation = new StringBuilder();
			selectMovieReservation.append("	SELECT COUNT(m.movie_idx)	")
			.append("	FROM MOVIE m	")
			.append("	INNER JOIN SCHEDULE s ON m.movie_idx = s.movie_idx	")
			.append("	INNER JOIN RESERVATION r ON s.schedule_idx = r.schedule_idx	")
			.append("	WHERE m.movie_idx = ? and r.canceled_date is null	 ");
			
			pstmt = con.prepareStatement(selectMovieReservation.toString());
			
			pstmt.setInt(1, num);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				count = rs.getInt(1);
			}
			
		}finally {
			db.dbClose(rs, pstmt, con);
		}
		
		return count;
	}
	
public int selectMovieReservationCount() throws SQLException {
		
		DbConnection db = DbConnection.getInstance();
		int count = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			con = db.getDbConn();
			
			StringBuilder selectMovieReservationCount = new StringBuilder();
			selectMovieReservationCount.append("	SELECT COUNT(*)	")
			.append("	FROM MOVIE m	")
			.append("	INNER JOIN SCHEDULE s ON m.movie_idx = s.movie_idx	")
			.append("	INNER JOIN RESERVATION r ON s.schedule_idx = r.schedule_idx	")
			.append("   WHERE r.canceled_date is null	");
			
			pstmt = con.prepareStatement(selectMovieReservationCount.toString());
					
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				count = rs.getInt(1);
			}
			
		}finally {
			db.dbClose(rs, pstmt, con);
		}
		
		return count;
	}


	
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
        sql.append(" UPDATE movie_common_code_table ")
           .append(" SET code_idx = ? ")
           .append(" WHERE movie_idx = ? ")
           .append(" AND code_idx IN (")
           .append("     SELECT code_idx ")
           .append("     FROM movie_common_table ")
           .append("     WHERE movie_code_name = ?")
           .append(" )");

        pstmt = con.prepareStatement(sql.toString());
        pstmt.setInt(1, code);        // 새로운 code_idx
        pstmt.setInt(2, num);         // movie_idx
        pstmt.setString(3, common);   // movie_code_type ("장르" 또는 "등급")
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