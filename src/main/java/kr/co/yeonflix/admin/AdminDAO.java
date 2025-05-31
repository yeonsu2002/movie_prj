package kr.co.yeonflix.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;

public class AdminDAO {

  public static AdminDAO aDAO;

  private AdminDAO() {}

  public static AdminDAO getInstance() {
    if (aDAO == null) {
      aDAO = new AdminDAO();
    }
    return aDAO;
  }

//--------------------------------------------------------------------------------------------------------------------

  //매니저 가입 
  public boolean insertAdmin(AdminDTO adminDTO) throws SQLException {
    
    boolean result = false;
    
    DbConnection dbCon = DbConnection.getInstance();
    Connection con = null;

    PreparedStatement insertCommonUserPstmt = null;
    PreparedStatement getUserIdxQueryPstmt = null;
    PreparedStatement getRoleIdxQueryPstmt = null;
    PreparedStatement insertUserRoleTablePstmt = null;
    PreparedStatement insertManagerPstmt = null;
    PreparedStatement getManagerNamePstmt = null;
    PreparedStatement insertAllowedIPPstmt = null;
    
    String adminId = adminDTO.getAdminId();
    
    AllowedIPDTO ipDTO = new AllowedIPDTO();
    ipDTO = adminDTO.getIPList().get(0);
    String ipAddr = ipDTO.getIpAddress().toString();
    
    int userIdx = -1;
    int roleIdx = -1;
    
    String insertCommonUser = " INSERT INTO common_user (user_idx, user_type) VALUES (USER_IDX_SEQ.NEXTVAL, ?)  ";
    String getUserIdxQuery = " SELECT USER_IDX_SEQ.CURRVAL FROM dual  ";
    String getRoleIdxQuery = " SELECT role_idx FROM role WHERE role_name = 'ROLE_MANAGER'  ";
    String insertUserRoleTable = " INSERT INTO user_role_table (user_idx, role_idx) VALUES (?, ?)  ";
    String insertManager = " INSERT INTO admin ( user_idx, admin_id, admin_level, admin_pwd, admin_name, admin_email, manage_area, last_login_date, picture, is_active) "
        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ? )";
    String insertAllowedIP = " INSERT INTO allowed_ip (allowed_ip_idx, admin_id, ip_address, created_at)  "
        + "VALUES (ALLOWED_IP_SEQ.NEXTVAL, ?, ?, ?)";
    
    try {
      con = dbCon.getDbConn();
      con.setAutoCommit(false); //중간에 오류나면 다 빽해야
      
      //1. common_user 데이터생성
      try(PreparedStatement ps = con.prepareStatement(insertCommonUser)){
        ps.setString(1, "ADMIN");
        ps.executeUpdate();
      }
      
      //2.user_idx 가져옴
      try(PreparedStatement ps = con.prepareStatement(getUserIdxQuery);
        ResultSet rs = ps.executeQuery()){
        if(rs.next()) {
          userIdx = rs.getInt(1);
        }
      }
      
      //3.role_idx 가져오기
      try (PreparedStatement ps = con.prepareStatement(getRoleIdxQuery);
        ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          roleIdx = rs.getInt(1);
        }
      }
      
      //4.user_role_table 입력
      try(PreparedStatement ps = con.prepareStatement(insertUserRoleTable)) {
        ps.setInt(1, userIdx);
        ps.setInt(2, roleIdx);
        ps.executeUpdate();
      }
      
      //5.관리자(admin) 입력
      try (PreparedStatement ps = con.prepareStatement(insertManager)) {
        ps.setInt(1, userIdx);
        ps.setString(2, adminDTO.getAdminId());
        ps.setString(3, adminDTO.getAdminLevel());
        ps.setString(4, adminDTO.getAdminPwd());
        ps.setString(5, adminDTO.getAdminName());
        ps.setString(6, adminDTO.getAdminEmail());
        ps.setString(7, adminDTO.getManageArea());
        ps.setTimestamp(8, Timestamp.valueOf(adminDTO.getLastLoginDate()));
        ps.setString(9, adminDTO.getPicture());
        ps.setString(10, adminDTO.getIsActive());
        ps.executeUpdate();
      }

      // 6. allowed_ip 입력
      try (PreparedStatement ps = con.prepareStatement(insertAllowedIP)) {
        ps.setString(1, adminId);
        ps.setString(2, ipAddr);
        ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
        ps.executeUpdate();
      }
      
      con.commit();
      result = true;
      
    } catch (SQLException  e) {
      if(con != null) {
        try {
          con.rollback();
        } catch (SQLException rollbackEx) {
          rollbackEx.printStackTrace();
        }
      }
      throw e;
      
    } finally {
      if (con != null) {
        try { 
          con.close(); 
        } catch (SQLException e) {
          e.printStackTrace();
        }
      }
    }
    return result;
  } 
//------------------ 매니저 가입 완료 --------------------------------------------
  
  //매니저 리스트 불러오기
  public List<AdminDTO> selectManagerList() {
    List<AdminDTO> managerList = new ArrayList<AdminDTO>();
    
    DbConnection dbCon = DbConnection.getInstance();
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    String selectManagerAll = " SELECT * FROM admin ";
    
    try {
      con = dbCon.getDbConn();
      pstmt = con.prepareStatement(selectManagerAll);
      rs = pstmt.executeQuery();
      
      while(rs.next()) {
        AdminDTO adminDTO = new AdminDTO();
        adminDTO.setAdminId(rs.getString("admin_id"));
        adminDTO.setUserIdx(rs.getInt("user_idx"));
        adminDTO.setAdminLevel(rs.getString("admin_level"));
        adminDTO.setAdminPwd(rs.getString("admin_pwd"));
        adminDTO.setAdminName(rs.getString("admin_name"));
        adminDTO.setAdminEmail(rs.getString("admin_email"));
        adminDTO.setManageArea(rs.getString("manage_area"));
        
        LocalDateTime loginDateTime = rs.getTimestamp("last_login_date").toLocalDateTime();
        adminDTO.setLastLoginDate(loginDateTime);
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formattedDate = loginDateTime.format(dtf);
        adminDTO.setFormattedLoginDate(formattedDate);
        
        adminDTO.setPicture(rs.getString("picture"));
        
        managerList.add(adminDTO);
      }
      
      
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        //객체를 close()하기 전에 null상태를 학인 -> NullPointerException
        if(rs != null) {rs.close();}
        if(pstmt != null) {pstmt.close();}
        if(con != null) {con.close();}
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
    
    return managerList;
  }
  
  
  
  
}
