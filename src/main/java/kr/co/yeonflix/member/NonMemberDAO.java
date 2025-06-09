package kr.co.yeonflix.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.sql.Date;
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
	

	//비회원 생성
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








//이메일과 생일로 비회원 예매내역 조회
public List<NonMemTicketDTO> selectNonMemTicketList(LocalDate birthDate, String email, String password) throws SQLException {
  List<NonMemTicketDTO> selectNonMemTicketList = new ArrayList<NonMemTicketDTO>();
  DbConnection dbCon = DbConnection.getInstance();
  Connection con = null;
  ResultSet rs = null;
  ResultSet rs2 = null;
  ResultSet rs3 = null;

  String getTicketPwd = " SELECT user_idx ,ticket_pwd FROM non_member WHERE email = ? AND non_member_birth = ? ";
  
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
      + " WHERE nm.user_idx = ? ";

  String getTicketInfoSeats = " SELECT seat_number FROM seat s INNER JOIN reserved_seat rs ON s.seat_idx = rs.seat_idx WHERE rs.reservation_idx = ? ";

  try {
      con = dbCon.getDbConn();
 
      // 1. 패스워드 검증
      try (PreparedStatement pstmt = con.prepareStatement(getTicketPwd)) {
          boolean found = false;
          boolean passwordMatched = false;
          int validUserIdx = -1;
          
          pstmt.setString(1, email);
          pstmt.setDate(2, java.sql.Date.valueOf(birthDate));
          rs = pstmt.executeQuery();

          // 이메일과 생일이 일치하는 모든 데이터를 조회하여 비밀번호 검증
          while(rs.next()) {
              found = true;
              String dbEncodedPwd = rs.getString("ticket_pwd");
              System.out.println("DB에서 조회된 암호화된 비밀번호: " + dbEncodedPwd);

              if (dbEncodedPwd == null) {
                  continue; // null인 경우 다음 행으로 넘어감
              }

              BCrypt.Result result = BCrypt.verifyer().verify(password.toCharArray(), dbEncodedPwd);
              
              if (result.verified) {
                  passwordMatched = true;
                  validUserIdx = rs.getInt("user_idx");
                  System.out.println("비밀번호 일치! UserIdx: " + validUserIdx);
                  break; // 일치하는 비밀번호를 찾았으므로 반복 종료
              }
          }
          
          // 검증 결과 확인
          if (!found) {
              throw new SQLException("해당 이메일과 생년월일로 등록된 비회원 정보를 찾을 수 없습니다.");
          }
          
          if (!passwordMatched) {
              throw new SQLException("이메일과 생일은 일치하지만, 비밀번호가 일치하는 예매내역은 존재하지 않습니다.");
          }

          // rs 정리
          rs.close();
          rs = null;

          // 2. 예매 정보 조회 (비밀번호가 일치한 경우에만)
          try (PreparedStatement pstmt2 = con.prepareStatement(getTicketInfo)) {
              pstmt2.setInt(1, validUserIdx);
              rs2 = pstmt2.executeQuery();

              while (rs2.next()) {
                  NonMemTicketDTO nmtVo = new NonMemTicketDTO();
                  nmtVo.setMoviePoster(rs2.getString("poster_path"));
                  nmtVo.setMovieName(rs2.getString("movie_name"));
                  nmtVo.setDate(rs2.getDate("screen_date"));
                  nmtVo.setStartTime(rs2.getTimestamp("start_time").toLocalDateTime());
                  nmtVo.setEndTime(rs2.getTimestamp("end_time").toLocalDateTime());
                  nmtVo.setTheaterName(rs2.getString("theater_name"));
                  nmtVo.setTicketNumber(rs2.getString("reservation_number"));
                  nmtVo.setTotalPrice(rs2.getInt("total_price"));

                  int reservationIdx = rs2.getInt("reservation_idx");

                  // 3. 좌석 정보 조회
                  List<String> seatList = new ArrayList<String>();
                  try (PreparedStatement pstmt3 = con.prepareStatement(getTicketInfoSeats)) {
                      pstmt3.setInt(1, reservationIdx);
                      rs3 = pstmt3.executeQuery();

                      while (rs3.next()) { // rs2가 아니라 rs3여야 함!
                          String seat = rs3.getString("seat_number");
                          seatList.add(seat);
                      }
                  } finally {
                      if (rs3 != null) {
                          try { rs3.close(); } catch (SQLException e) { e.printStackTrace(); }
                          rs3 = null;
                      }
                  }

                  nmtVo.setSeats(seatList);
                  selectNonMemTicketList.add(nmtVo);
              }
          }
      }

  } catch (SQLException e) {
      throw e;
  } catch (Exception e) {
      e.printStackTrace();
      throw new SQLException("비회원 예매내역 조회 중 오류발생", e);
  } finally {
      if (rs3 != null) {
          try { rs3.close(); } catch (SQLException e) { e.printStackTrace(); }
      }
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

//전체 비회원 조회 (검색 및 페이징 포함)
public List<NonMemberDTO> selectAllNonMember(RangeDTO rDTO) throws SQLException {
	    List<NonMemberDTO> list = new ArrayList<>();
	    DbConnection dbCon = DbConnection.getInstance();
	    Connection con = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt = null;

	    try {
	        con = dbCon.getDbConn();

	        // 검색 조건 처리
	        String searchField = validateFieldName(rDTO.getFieldName());  // 필드명
	        String keyword = rDTO.getKeyword();  // 검색 키워드

	        // SQL 쿼리 준비
	        StringBuilder sql = new StringBuilder();
	        sql.append("SELECT * FROM ( ");
	        sql.append("  SELECT user_idx, email, non_member_birth, ticket_pwd, created_at, ");
	        sql.append("         ROW_NUMBER() OVER (ORDER BY created_at DESC) rnum ");
	        sql.append("  FROM non_member ");

	        // 검색 조건이 있을 경우 WHERE 절 추가
	        if (searchField != null && keyword != null && !keyword.trim().isEmpty()) {
	            sql.append(" WHERE ").append(searchField).append(" LIKE ? ");
	        }

	        sql.append(") WHERE rnum BETWEEN ? AND ?");

	        pstmt = con.prepareStatement(sql.toString());

	        int paramIndex = 1;

	        // 검색 조건 바인딩
	        if (searchField != null && keyword != null && !keyword.trim().isEmpty()) {
	            pstmt.setString(paramIndex++, "%" + keyword + "%");
	        }

	        // 시작과 끝 행 번호 설정
	        int startRow = rDTO.getStartIndex() + 1;  // 시작 행 번호
	        int endRow = startRow + rDTO.getPageSize();  // 끝 행 번호

	        pstmt.setInt(paramIndex++, startRow);
	        pstmt.setInt(paramIndex++, endRow);

	        rs = pstmt.executeQuery();

	        // 결과 처리
	        while (rs.next()) {
	            NonMemberDTO nmDTO = new NonMemberDTO();
	            nmDTO.setUserIdx(rs.getInt("user_idx"));
	            nmDTO.setEmail(rs.getString("email"));

	            // 생년월일 처리 (null 체크)
	            Date birthDate = rs.getDate("non_member_birth");
	            if (birthDate != null) {
	                nmDTO.setBirth(birthDate.toLocalDate());
	            }

	            nmDTO.setTicket_pwd(rs.getString("ticket_pwd"));

	            // 생성일 처리 (null 체크)
	            Timestamp created = rs.getTimestamp("created_at");
	            if (created != null) {
	                nmDTO.setCreatedAt(created.toLocalDateTime());
	            }

	            list.add(nmDTO);
	        }

	    } catch (SQLException e) {
	        // 로그 기록을 통해 예외 추적 (로그 사용 권장)
	        e.printStackTrace();
	    } finally {
	        dbCon.dbClose(rs, pstmt, con);  // 자원 해제 메서드 사용
	    }

	    return list;
	}


//허용된 컬럼명만 반환, 검증용 메서드
//허용된 컬럼명이 아니면 null 반환
private String validateFieldName(String fieldName) {
  // 비회원 테이블에서 검색 가능한 컬럼명들 (이메일만)
  String[] allowedFields = {"email"};
  for (String allowed : allowedFields) {
      if (allowed.equalsIgnoreCase(fieldName)) {
          return allowed;
      }
  }
  return null;  // 허용되지 않는 필드명
}

//비회원 전체 개수
public int selectTotalCount(RangeDTO rDTO) throws SQLException {
  int cnt = 0;
  DbConnection dbCon = DbConnection.getInstance();
  Connection con = null;
  ResultSet rs = null;
  PreparedStatement pstmt = null;

  try {
      con = dbCon.getDbConn();

      // 기본 쿼리
      StringBuilder countQuery = new StringBuilder("SELECT COUNT(user_idx) cnt FROM non_member");

      // 검색 조건이 있을 경우 WHERE절 추가
      String fieldName = validateFieldName(rDTO.getFieldName());
      String keyword = rDTO.getKeyword();

      if (fieldName != null && keyword != null && !keyword.trim().isEmpty()) {
          countQuery.append(" WHERE ").append(fieldName).append(" LIKE ?");
      }

      pstmt = con.prepareStatement(countQuery.toString());

      // 검색 조건 바인딩
      if (fieldName != null && keyword != null && !keyword.trim().isEmpty()) {
          pstmt.setString(1, "%" + keyword.trim() + "%");
      }

      rs = pstmt.executeQuery();

      if (rs.next()) {
          cnt = rs.getInt("cnt");
      }
 
  } catch (SQLException e) {
      // 예외 로깅 처리 (로그를 남기는 방법이 좋습니다)
      e.printStackTrace();
  } finally {
      // DbConnection dbClose() 메서드를 사용하여 자원 해제
      dbCon.dbClose(rs, pstmt, con);
  }

  return cnt;
}

	

}
			