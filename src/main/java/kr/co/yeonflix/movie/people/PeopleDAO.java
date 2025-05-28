package kr.co.yeonflix.movie.people;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import kr.co.yeonflix.dao.DbConnection;

public class PeopleDAO {
	
	private static PeopleDAO pDAO;
	
	public static PeopleDAO getInstance() {
		
		if(pDAO == null) {
			pDAO = new PeopleDAO();
		}//end if
		
		return pDAO;
		
	}//getInstance
	
	public PeopleDTO selectOnePeople(int num) throws SQLException{
		PeopleDTO pDTO = null;
		DbConnection db = DbConnection.getInstance();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getDbConn();
			
			StringBuilder selectOnePeople = new StringBuilder();
			selectOnePeople.append("	select people_code_idx, people_code_type, people_name	")
			.append("	from movie_people_common_table	")
			.append("	where people_code_idx = ?");
			pstmt = con.prepareStatement(selectOnePeople.toString());
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			
			while(rs.next()) {
				pDTO = new PeopleDTO();
				pDTO.setPeople_code_type(rs.getString("people_code_type"));
				pDTO.setPeople_name(rs.getString("people_name"));
			}//end while
		
		}finally {
			db.dbClose(rs, pstmt, con);
		}//finally
		
		return pDTO;
	}//selectOnePeople
	
	public void insertPeople(PeopleDTO pDTO) throws SQLException{   
		
		DbConnection db = DbConnection.getInstance();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getDbConn();
			
			StringBuilder insertPeople = new StringBuilder();
			insertPeople.append("insert into movie_people_common_table()");
			
		}finally {
			db.dbClose(null, pstmt, con);
		}
		
		
	}
	
}
