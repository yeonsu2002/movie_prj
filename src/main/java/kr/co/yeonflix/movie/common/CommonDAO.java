package kr.co.yeonflix.movie.common;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;

public class CommonDAO {
	
	private static CommonDAO gDAO;
	
	private CommonDAO() {
		
	}//GenreDAO
	
	public static CommonDAO getInstance() {
		
		if(gDAO == null) {
			gDAO = new CommonDAO();
		}//end if
		
		return gDAO;
	}//getInstance
	
	public List<CommonDTO> selectGenre() throws SQLException{
		List<CommonDTO> list = new ArrayList<CommonDTO>();
		DbConnection db = DbConnection.getInstance();
	
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getDbConn();
			
			
			StringBuilder selectGenre = new StringBuilder(); 
			
			selectGenre.append(	"select code_idx,movie_code_type,movie_code_name	")
			.append("	from movie_common_table	")
			.append("	where movie_code_name='장르'	"	);
			
			pstmt = con.prepareStatement(selectGenre.toString());
			rs = pstmt.executeQuery();
			CommonDTO gDTO = null;
			while(rs.next()) {
				gDTO = new CommonDTO();
				gDTO.setCodeIdx(rs.getInt("code_idx"));
				gDTO.setMovieCodeType(rs.getString("movie_code_type"));
				gDTO.setMovieCodeName(rs.getString("movie_code_name"));
				list.add(gDTO);
			}//end while
		}finally {
			db.dbClose(rs, pstmt, con);
		}//finally
		return list;
	}//selectGenre
	
	public List<CommonDTO> selectGrade() throws SQLException{
		List<CommonDTO> list = new ArrayList<CommonDTO>();
		DbConnection db = DbConnection.getInstance();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getDbConn();
			
			StringBuilder selectGrade = new StringBuilder(); 
			
			selectGrade.append(	"select code_idx,movie_code_type,movie_code_name	")
			.append("	from movie_common_table	")
			.append("	where movie_code_name='등급'	"	);
			
			pstmt = con.prepareStatement(selectGrade.toString());
			rs = pstmt.executeQuery();
			CommonDTO gDTO = null;
			while(rs.next()) {
				gDTO = new CommonDTO();
				gDTO.setCodeIdx(rs.getInt("code_idx"));
				gDTO.setMovieCodeType(rs.getString("movie_code_type"));
				gDTO.setMovieCodeName(rs.getString("movie_code_name"));
				list.add(gDTO);
			}//end while
		}finally {
			db.dbClose(rs, pstmt, con);
		}//finally
		return list;
	}//selectGenre
	
//	public void insertCommon(CommonDTO cDTO) throws SQLException{
//		
//		DbConnection db = DbConnection.getInstance();
//		
//		Connection con = null;
//		PreparedStatement pstmt = null;
//		try {
//		con = db.getDbConn();
//		
//		StringBuilder insertCommon = new StringBuilder();
//		insertCommon.append("insert into movie_common_table (code_idx, movie_code_type, movie_code_name)")
//		.append(" values (code_idx_seq.nextval,?,?)");
//		
//		pstmt = con.prepareStatement(insertCommon.toString());
//		pstmt.setString(1, cDTO.getMovieCodeType());
//		pstmt.setString(2, cDTO.getMovieCodeName());
//		
//		}finally {
//			db.dbClose(null, pstmt, con);
//		}//insertCommon
//		
//		
//	}//insertCommon
}