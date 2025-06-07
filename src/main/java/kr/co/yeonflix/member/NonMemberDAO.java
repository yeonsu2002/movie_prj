package kr.co.yeonflix.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;
import oracle.jdbc.driver.DBConversion;
 
public class NonMemberDAO {

	public static NonMemberDAO nmDAO;
	
	private NonMemberDAO() {};
	
	public static NonMemberDAO getInstance() {
		if(nmDAO == null) {
			nmDAO = new NonMemberDAO();
		}
		return nmDAO;
	}//getInstance();
	
//--------------------------------------------------------------------------------------------------------------------	

	//비회원 생성
	public boolean insertNonMem(LocalDate birthDate, String email, String pwd) throws SQLException {
	  boolean isSuccess = false;
	  
	  DbConnection dbCon = DbConnection.getInstance();
	  Connection con = null;
	  ResultSet rs = null;
	  
	  String insertCommonUserQuery = " INSERT INTO common_user (user_idx, user_type) VALUES (USER_IDX_SEQ.NEXTVAL, 'GUEST')  ";
	  String getUserIdxQuery = " SELECT USER_IDX_SEQ.CURRVAL FROM dual ";
	  String insertNonMemberQuery = "  INSERT INTO non_member (user_idx, non_member_birth, email, ticket_pwd, created_at) VALUES (?, ?, ?, ?, ?)  ";
	  String getRoleIdxQuery = " SELECT role_idx FROM role WHERE role_name = 'ROLE_GUEST' "; 
	  String insertUserRoleTable = " INSERT INTO user_role_table (user_idx, role_idx) VALUES (?, ?) ";
	  
	  NonMemberDTO nmDTO = new NonMemberDTO();
	  int userIdx = -1;
	  int roleIdx = -1;
	  
	  try {
	    con = dbCon.getDbConn();
	    con.setAutoCommit(false);

	    //common_user테이블 등록
	    try(PreparedStatement pstmt = con.prepareStatement(insertCommonUserQuery)){
	      pstmt.executeUpdate();
	    }
	    
	    //userIdx가져와
	    try(PreparedStatement pstmt = con.prepareStatement(getUserIdxQuery)){
	      rs = pstmt.executeQuery();
	      if(rs.next()) {
	        userIdx = rs.getInt(1);
	      }
	    }
	    
	    //roleIdx 가져와
	    try(PreparedStatement pstmt = con.prepareStatement(getRoleIdxQuery)){
	      rs = pstmt.executeQuery();
	      if(rs.next()) {
	        roleIdx = rs.getInt(1);
	      }
	    }
	    
	    //비회원등록 
	    try(PreparedStatement pstmt = con.prepareStatement(insertNonMemberQuery)){
	      pstmt.setInt(1, userIdx);
	      pstmt.setDate(2, java.sql.Date.valueOf(birthDate));
	      pstmt.setString(3, email);
	      pstmt.setString(4, pwd);
	      pstmt.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));
	      
	      pstmt.executeUpdate();
	    }
	    
	    //권한연결 
	    try(PreparedStatement pstmt = con.prepareStatement(insertUserRoleTable)){
	      pstmt.setInt(1, userIdx);
	      pstmt.setInt(2, roleIdx);
	      
	      pstmt.executeUpdate();
	    }
	    
	    //다 성공하면 커밋 
	    con.commit();
	    isSuccess = true;
	  
	  }catch (Exception e) {
	    e.printStackTrace();
	    if(con != null) {
	      try {
          con.rollback();
        } catch (SQLException  se) {
          se.printStackTrace();
        }
	    }
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (con != null) try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
	  
	  return isSuccess;
	}

	//이메일, 이름, 생일로 회원정보 뽑기(유저권한x, 타입x, 필요없을듯. 예매완료하고 버릴거니까)
  public NonMemberDTO selectNonMember(LocalDate birth, String email) throws SQLException {
    
    DbConnection dbCon = DbConnection.getInstance();
    Connection con = null;
    ResultSet rs = null;
    
    String getUserIdxQuery = " SELECT * FROM non_member WHERE email = ? AND non_member_birth = ?  ";
    
    NonMemberDTO nmDTO = null;
    
    try {
      con = dbCon.getDbConn();
      
      try(PreparedStatement pstmt = con.prepareStatement(getUserIdxQuery)){
        pstmt.setString(1, email);
        pstmt.setDate(2, java.sql.Date.valueOf(birth));
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
          nmDTO = new NonMemberDTO();
          nmDTO.setUserIdx(rs.getInt("user_idx"));
          nmDTO.setBirth(rs.getDate("non_member_birth").toLocalDate()); //DATE → LocalDate
          nmDTO.setEmail(rs.getString("email"));
          nmDTO.setTicket_pwd(rs.getString("ticket_pwd"));
          nmDTO.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime()); //TIMESTAMP → LocalDateTime
        }
      }
      
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
      if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }

    }
    
    return nmDTO;
  }
	
	//전체멤버 보기
  public List<NonMemberDTO> selectAllNonMember(){
  	List<NonMemberDTO> list = null;
  	
  	//번호, 생년월일, 이메ㅇㄹ, 생성일
  	DbConnection dbCon = DbConnection.getInstance();
  	Connection con = null;
  	ResultSet rs = null;
  	
  	String query = "	SELECT * FROM non_member ORDER BY created_at DESC	";
  	
  	try {
			con = dbCon.getDbConn();
  		
  		try(PreparedStatement pstmt = con.prepareStatement(query)) {
  			rs = pstmt.executeQuery();
  			
  			while (rs.next()) {
  				NonMemberDTO vo = new NonMemberDTO();
  				vo.setUserIdx(rs.getInt("user_idx"));
  				vo.setBirth(rs.getDate("non_member_birth").toLocalDate());
  				vo.setEmail(rs.getString("email"));
  				vo.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
  				
  				list.add(vo);
				}
  			
  		} catch (Exception e) {
  			e.printStackTrace();
  		} 
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
      if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
		}
  	
  	return list;
  }
	
}
