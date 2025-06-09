package kr.co.yeonflix.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import at.favre.lib.crypto.bcrypt.BCrypt;
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

  //이메일과 생일로 비회원 예매내역 조회
  public List<NonMemTicketDTO> selectNonMemTicketList(LocalDate birthDate, String email, String password) throws SQLException {
   List<NonMemTicketDTO> selectNonMemTicketList = new ArrayList<NonMemTicketDTO>();
   DbConnection dbCon = DbConnection.getInstance();
   Connection con = null;
   ResultSet rs = null;
   ResultSet rs2 = null;
  
   String getTicketPwd = " SELECT ticket_pwd FROM non_member WHERE email = ? AND non_member_birth = ? ";
  
   String getTicketInfo = " SELECT r.reservation_idx,\r\n"
     + " mv.poster_path,\r\n"
     + " r.reservation_number,\r\n"
     + " s.screen_date,\r\n"
     + " s.start_time,\r\n"
     + " s.end_time,\r\n"
     + " r.total_price,\r\n"
     + " t.theater_name,\r\n"
     + " mv.movie_name\r\n"
     + "FROM reservation r\r\n"
     + "JOIN common_user c ON c.user_idx = r.user_idx\r\n"
     + "JOIN non_member nm ON c.user_idx = nm.user_idx\r\n"
     + "JOIN schedule s ON r.schedule_idx = s.schedule_idx\r\n"
     + "JOIN theater t ON s.theater_idx = t.theater_idx\r\n"
     + "JOIN movie mv ON s.movie_idx = mv.movie_idx\r\n"
     + "WHERE nm.non_member_birth = ? \r\n"
     + " AND nm.email = ? ";
  
   String getTicketInfoSeats = " SELECT seat_number FROM seat s INNER JOIN reserved_seat rs ON s.seat_idx = rs.seat_idx WHERE rs.reservation_idx = ? ";
  
   try {
     con = dbCon.getDbConn();
  
     // 1. 패스워드 검증
     try (PreparedStatement pstmt = con.prepareStatement(getTicketPwd)) {
       pstmt.setString(1, email);
       pstmt.setDate(2, java.sql.Date.valueOf(birthDate));
       rs = pstmt.executeQuery();
  
       if (rs.next()) {
         String encodedPwd = rs.getString("ticket_pwd");
  
         if (encodedPwd == null) {
           throw new SQLException("저장된 패스워드가 없습니다.");
         }
  
         BCrypt.Result result = BCrypt.verifyer().verify(password.toCharArray(), encodedPwd);
  
         if (result.verified) {
           rs.close();
           rs = null;
  
           // 2. 예매 정보 조회
           try (PreparedStatement pstmt2 = con.prepareStatement(getTicketInfo)) {
             pstmt2.setDate(1, java.sql.Date.valueOf(birthDate));
             pstmt2.setString(2, email);
             rs = pstmt2.executeQuery();
  
             while (rs.next()) {
               NonMemTicketDTO nmtVo = new NonMemTicketDTO();
               nmtVo.setMoviePoster(rs.getString("poster_path"));
               nmtVo.setMovieName(rs.getString("movie_name"));
               nmtVo.setDate(rs.getDate("screen_date"));
               nmtVo.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
               nmtVo.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
               nmtVo.setTheaterName(rs.getString("theater_name"));
               nmtVo.setTicketNumber(rs.getString("reservation_number"));
               nmtVo.setTotalPrice(rs.getInt("total_price"));
  
               int reservationIdx = rs.getInt("reservation_idx");
  
               // 3. 좌석 정보 조회
               List<String> seatList = new ArrayList<String>();
               try (PreparedStatement pstmt3 = con.prepareStatement(getTicketInfoSeats)) {
                 pstmt3.setInt(1, reservationIdx);
                 rs2 = pstmt3.executeQuery();
  
                 while (rs2.next()) {
                   String seat = rs2.getString("seat_number");
                   seatList.add(seat);
                 }
               } finally {
                 if (rs2 != null) {
                   try { rs2.close(); } catch (SQLException e) { e.printStackTrace(); }
                   rs2 = null;
                 }
               }
  
               nmtVo.setSeats(seatList);
               selectNonMemTicketList.add(nmtVo);
             }
           }
         } else {
           throw new SQLException("패스워드가 일치하지 않습니다.");
         }
       } else {
         throw new SQLException("해당 이메일과 생년월일로 등록된 비회원 정보를 찾을 수 없습니다.");
       }
     }
  
   } catch (SQLException e) {
     throw e;
   } catch (Exception e) {
     e.printStackTrace();
     throw new SQLException("비회원 예매내역 조회 중 오류발생", e);
   } finally {
     if (rs2 != null) {
       try { rs2.close(); } catch (SQLException e) { e.printStackTrace(); }
     }
     if (rs != null) {
       try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
     }
     if (con != null) {
       try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
     }
   }
  
   return selectNonMemTicketList;
  }

	
}
