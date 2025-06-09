package kr.co.yeonflix.movie.people;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;

public class PeopleDAO {
	
	private static PeopleDAO pDAO;
	
	public static PeopleDAO getInstance() {
		
		if(pDAO == null) {
			pDAO = new PeopleDAO();
		}//end if
		
		return pDAO;
		
	}//getInstance
	
	public List<PeopleDTO> selectActor() throws SQLException{
		List<PeopleDTO> list = new ArrayList<PeopleDTO>();
		DbConnection db = DbConnection.getInstance();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getDbConn();
			
			StringBuilder selectDirector = new StringBuilder();
			selectDirector.append("	select people_code_idx, people_code_type, people_name	")
			.append("	from movie_people_common_table	")
			.append("	where people_code_type LIKE '%배우'	");
			pstmt = con.prepareStatement(selectDirector.toString());
			
			rs = pstmt.executeQuery();
			
			PeopleDTO pDTO = null;
			while(rs.next()) {
				pDTO = new PeopleDTO();
				
				pDTO.setPeopleCodeIdx(rs.getInt("people_code_idx"));
				pDTO.setPeopleCodeType(rs.getString("people_code_type"));
				pDTO.setPeopleName(rs.getString("people_name"));
				
				list.add(pDTO);
			}//end while
		
		}finally {
			db.dbClose(rs, pstmt, con);
		}//finally
		
		return list;
	}//selectOnePeople
	
	public List<PeopleDTO> selectDirector() throws SQLException{
		List<PeopleDTO> list = new ArrayList<PeopleDTO>();
		DbConnection db = DbConnection.getInstance();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getDbConn();
			
			StringBuilder selectDirector = new StringBuilder();
			selectDirector.append("	select people_code_idx, people_code_type, people_name	")
			.append("	from movie_people_common_table	")
			.append("	where people_code_type LIKE '%감독%'	");
			
			pstmt = con.prepareStatement(selectDirector.toString());
			
			rs = pstmt.executeQuery();
			
			PeopleDTO pDTO = null;
			while(rs.next()) {
				pDTO = new PeopleDTO();
				
				pDTO.setPeopleCodeIdx(rs.getInt("people_code_idx"));
				pDTO.setPeopleCodeType(rs.getString("people_code_type"));
				pDTO.setPeopleName(rs.getString("people_name"));
				list.add(pDTO);
			}//end while
		
		}finally {
			db.dbClose(rs, pstmt, con);
		}//finally
		
		
		
		return list;
	}//selectOnePeople
	
//	public void insertPeople(PeopleDTO pDTO) throws SQLException{   
//		
//		DbConnection db = DbConnection.getInstance();
//		
//		Connection con = null;
//		PreparedStatement pstmt = null;
//		
//		try {
//			con = db.getDbConn();
//			
//			StringBuilder insertPeople = new StringBuilder();
//			insertPeople.append("insert into movie_people_common_table(people_code_idx,	people_code_type, people_name)")
//			.append("values (people_code_idx_seq.nextval,?,?)");
//			
//			pstmt = con.prepareStatement(insertPeople.toString());
//			pstmt.setString(1, pDTO.getPeopleCodeType());
//			pstmt.setString(2, pDTO.getPeopleName());
//			
//			pstmt.executeQuery();
//			
//		}finally {
//			db.dbClose(null, pstmt, con);
//		}
		
		
//	}
	
	
	
}