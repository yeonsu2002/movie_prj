package kr.co.yeonflix.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

import kr.co.yeonflix.dao.DbConnection;

public class VerificationDAO {

  public static VerificationDAO vDAO;
  
  private VerificationDAO() {};
  
  public static VerificationDAO getInstance() {
    if(vDAO == null) {
      vDAO = new VerificationDAO();
    }
    return vDAO;
  }//getInstance();
  
//--------------------------------------------------------------------
  
  public boolean insertVerifiCode(String email, String verificationCode, LocalDateTime createdAt, LocalDateTime expireAt) throws SQLException {
    boolean isSuccess = false;
    DbConnection dbCon = DbConnection.getInstance();
    Connection con = null;
    PreparedStatement getUserIdxpstmt = null;
    PreparedStatement insertVerifiCodePstmt = null;
    ResultSet rs = null;
    
    int userIdx = -1;
    
    try {
      con = dbCon.getDbConn();
      String getIdxQuery = " SELECT user_idx FROM member WHERE email = ? ";
      getUserIdxpstmt = con.prepareStatement(getIdxQuery);
      getUserIdxpstmt.setString(1, email);
      
      rs = getUserIdxpstmt.executeQuery();
      if(rs.next()) {
        userIdx = rs.getInt("user_idx");
      }
      
      if(userIdx > 0) {
        String insertVerifiCodeQuery = "  INSERT INTO user_verification (verification_idx, user_idx, verified_code, created_at, expire_at, email)\r\n"
            + "VALUES (VERIFICATION_IDX_SEQ.NEXTVAL, ?, ?, ?, ?, ?)   ";
        insertVerifiCodePstmt = con.prepareStatement(insertVerifiCodeQuery);
        
        insertVerifiCodePstmt.setInt(1, userIdx);
        insertVerifiCodePstmt.setString(2, verificationCode);
        insertVerifiCodePstmt.setTimestamp(3, Timestamp.valueOf(createdAt));
        insertVerifiCodePstmt.setTimestamp(4, Timestamp.valueOf(expireAt));
        insertVerifiCodePstmt.setString(5, email);
        
        insertVerifiCodePstmt.executeUpdate();
        
        isSuccess = true;
      }
      
    } finally {
      if (rs != null) try { rs.close(); } catch (SQLException e) {}
      if (getUserIdxpstmt != null) getUserIdxpstmt.close();
      if (insertVerifiCodePstmt != null) insertVerifiCodePstmt.close();
      if (con != null) con.close();
    }
    return isSuccess;
  }
  
}
