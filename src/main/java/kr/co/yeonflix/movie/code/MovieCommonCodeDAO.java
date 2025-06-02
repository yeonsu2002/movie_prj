package kr.co.yeonflix.movie.code;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;
import kr.co.yeonflix.movie.MovieDTO;

public class MovieCommonCodeDAO {
	
	private static MovieCommonCodeDAO mccDAO;
	
	private MovieCommonCodeDAO() {
		
	}
	
	public static MovieCommonCodeDAO getInstance() {
		if(mccDAO == null) {
			mccDAO = new MovieCommonCodeDAO();
		}
		
		return mccDAO;
	}
	
//	public List<MovieCommonCodeDTO> selectCommon(int movieIdx) throws SQLException {
//		
//		MovieCommonCodeDTO mccDTO = null;
//		List<MovieCommonCodeDTO> list = new ArrayList<MovieCommonCodeDTO>();
//		DbConnection db = DbConnection.getInstance();
//		
//		ResultSet rs = null;
//		PreparedStatement pstmt = null;
//		Connection con = null;
//		try {
//			con = db.getDbConn();
//			
//			StringBuilder selectMovie = new StringBuilder();
//			selectMovie.append("	select  code_idx	")
//			.append("	from MOVIE_COMMON_CODE_TABLE	")
//			.append("	where movie_idx=?	");
//		
//			pstmt=con.prepareStatement(selectMovie.toString());
//			
//			
//			  
//			pstmt.setInt(1, movieIdx);
//			rs = pstmt.executeQuery();
//			
//			while(rs.next()) {
//				mccDTO = new MovieCommonCodeDTO();
//				mccDTO.setCodeIdx(rs.getInt("code_idx"));
//				list.add(mccDTO);
//			}//end while
//		} finally {
//			db.dbClose(rs, pstmt, con);
//		}//finally
//		System.out.println(movieIdx + "/" + list);
//		return list;
//	}//selectOneMovie
	
	public List<MovieCommonCodeDTO> selectCommon(int movieIdx) throws SQLException {
	    List<MovieCommonCodeDTO> list = new ArrayList<MovieCommonCodeDTO>();
	    DbConnection db = DbConnection.getInstance();
	    
	    ResultSet rs = null;
	    PreparedStatement pstmt = null;
	    Connection con = null;
	    try {
	        con = db.getDbConn();
	        
	        // MOVIE_COMMON_TABLE과 조인하여 movie_code_name 정보도 가져옴
	        StringBuilder selectMovie = new StringBuilder();
	        selectMovie.append("SELECT mcc.code_idx, mc.movie_code_name ")
	                  .append("FROM MOVIE_COMMON_CODE_TABLE mcc ")
	                  .append("JOIN MOVIE_COMMON_TABLE mc ON mcc.code_idx = mc.code_idx ")
	                  .append("WHERE mcc.movie_idx=? ")
	                  .append("ORDER BY mc.movie_code_name"); // 장르가 먼저 오도록 정렬
	        
	        pstmt = con.prepareStatement(selectMovie.toString());
	        pstmt.setInt(1, movieIdx);
	        rs = pstmt.executeQuery();
	        
	        while(rs.next()) {
	            MovieCommonCodeDTO dto = new MovieCommonCodeDTO();
	            dto.setCodeIdx(rs.getInt("code_idx"));
	            dto.setCodeType(rs.getString("movie_code_name")); // MOVIE_COMMON_TABLE의 movie_code_name
	            list.add(dto);
	        }
	    } finally {
	        db.dbClose(rs, pstmt, con);
	    }
	    return list;
	}
	
}
