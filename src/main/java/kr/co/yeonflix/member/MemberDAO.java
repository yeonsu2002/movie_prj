package kr.co.yeonflix.member;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import at.favre.lib.crypto.bcrypt.BCrypt;
import kr.co.yeonflix.dao.DbConnection;

public class MemberDAO {

  public static MemberDAO mDAO;

  private MemberDAO() {}

  public static MemberDAO getInstance() {
    if (mDAO == null) {
      mDAO = new MemberDAO();
    }
    return mDAO;
  }

  //--------------------------------------------------------------------------------------------------------------------
  // 로그인 
  public MemberDTO memberLogin(String memberId, String memberPwd) throws SQLException {

    MemberDTO memberVO = new MemberDTO();

    DbConnection dbCon = DbConnection.getInstance();
    Connection con = null;
    PreparedStatement getMemberPstmt = null;
    PreparedStatement getRolePstmt = null;
    PreparedStatement getRoleNamePstmt = null;
    ResultSet rsMember = null;
    ResultSet rsRole = null;
    ResultSet rsRoleName = null;

    int userIdx = -1;
    int roleIdx = -1;

    try {
      con = dbCon.getDbConn();

      String getMemberQuery = " SELECT user_idx, member_id, member_pwd, user_name, nick_name, birth, email, picture FROM member WHERE member_id = ? ";
      getMemberPstmt = con.prepareStatement(getMemberQuery);
      getMemberPstmt.setString(1, memberId);

      rsMember = getMemberPstmt.executeQuery();

      if (rsMember.next()) {

        BCrypt.Result result = BCrypt.verifyer().verify(memberPwd.toCharArray(), rsMember.getString("member_pwd"));

        if (result.verified) {
          memberVO.setUserIdx(rsMember.getInt("user_idx"));
          memberVO.setMemberId(rsMember.getString("member_id"));
          memberVO.setMemberPwd(rsMember.getString("member_pwd"));
          memberVO.setUserName(rsMember.getString("user_name"));
          memberVO.setNickName(rsMember.getString("nick_name"));
          memberVO.setBirth(rsMember.getDate("birth").toLocalDate());
          memberVO.setEmail(rsMember.getString("email"));
          memberVO.setPicture(rsMember.getString("picture"));

          userIdx = rsMember.getInt("user_idx");
        } 
      }

      if (userIdx > 0) {
        String getRoleQuery = " SELECT role_idx FROM user_role_table WHERE user_idx = ? ";
        getRolePstmt = con.prepareStatement(getRoleQuery);
        getRolePstmt.setInt(1, userIdx);

        rsRole = getRolePstmt.executeQuery();
        if (rsRole.next()) {
          roleIdx = rsRole.getInt("role_idx");
        }
      }

      if (roleIdx > 0) {
        String getRoleNameQuery = " SELECT role_name FROM role WHERE role_idx = ? ";
        getRoleNamePstmt = con.prepareStatement(getRoleNameQuery);
        getRoleNamePstmt.setInt(1, roleIdx);

        rsRoleName = getRoleNamePstmt.executeQuery();
        if (rsRoleName.next()) {
          memberVO.setRole(Role.valueOf(rsRoleName.getString("role_name")));
        }
      }

    } finally {
      if (rsMember != null) rsMember.close();
      if (rsRole != null) rsRole.close();
      if (rsRoleName != null) rsRoleName.close();
      if (getMemberPstmt != null) getMemberPstmt.close();
      if (getRolePstmt != null) getRolePstmt.close();
      if (getRoleNamePstmt != null) getRoleNamePstmt.close();
      if (con != null) con.close();
    }
    return memberVO;
  }

  // 일반 회원가입
  public boolean insertMember(MemberDTO memberDTO) throws SQLException {

    boolean isSuccess = false;

    DbConnection dbCon = DbConnection.getInstance();
    Connection con = null;
    ResultSet rs = null;

    PreparedStatement commonUserPstmt = null;
    PreparedStatement getUserIdxPstmt = null;
    PreparedStatement memberPstmt = null;
    PreparedStatement getRoleIdxPstmt = null;
    PreparedStatement memberRolePstmt = null;

    int generatedUserIdx = -1;
    int getRoleIdx = -1;

    try {
      con = dbCon.getDbConn();

      String insertCommonUser = " INSERT INTO common_user (user_idx, user_type) VALUES (USER_IDX_SEQ.NEXTVAL, ?) ";
      String getUserIdxQuery = " SELECT USER_IDX_SEQ.CURRVAL FROM dual ";
      String insertMember = " INSERT INTO member (USER_IDX, MEMBER_ID, MEMBER_PWD, NICK_NAME, USER_NAME, BIRTH, TEL, IS_SMS_AGREED, EMAIL, IS_EMAIL_AGREED, CREATED_AT, IS_ACTIVE, PICTURE, MEMBER_IP) "
          + "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
      String getRoleIdxQuery = " SELECT role_idx FROM role WHERE role_name = 'ROLE_MEMBER' ";
      String insertUserRoleTable = " INSERT INTO user_role_table (user_idx, role_idx) VALUES (?, ?) ";

      con.setAutoCommit(false);

      commonUserPstmt = con.prepareStatement(insertCommonUser);
      commonUserPstmt.setString(1, "MEMBER");
      commonUserPstmt.executeUpdate();

      getUserIdxPstmt = con.prepareStatement(getUserIdxQuery);
      rs = getUserIdxPstmt.executeQuery();
      if (rs.next()) {
        generatedUserIdx = rs.getInt(1);
      }

      memberPstmt = con.prepareStatement(insertMember);
      memberPstmt.setInt(1, generatedUserIdx);
      memberPstmt.setString(2, memberDTO.getMemberId());
      memberPstmt.setString(3, memberDTO.getMemberPwd());
      memberPstmt.setString(4, memberDTO.getNickName());
      memberPstmt.setString(5, memberDTO.getUserName());
      memberPstmt.setDate(6, Date.valueOf(memberDTO.getBirth()));
      memberPstmt.setString(7, memberDTO.getTel());
      memberPstmt.setString(8, memberDTO.getIsSmsAgreed());
      memberPstmt.setString(9, memberDTO.getEmail());
      memberPstmt.setString(10, memberDTO.getIsEmailAgreed());
      memberPstmt.setTimestamp(11, Timestamp.valueOf(memberDTO.getCreatedAt()));
      memberPstmt.setString(12, memberDTO.getIsActive());
      memberPstmt.setString(13, memberDTO.getPicture());
      memberPstmt.setString(14, memberDTO.getMemberIp());

      memberPstmt.executeUpdate();

      getRoleIdxPstmt = con.prepareStatement(getRoleIdxQuery);
      rs = getRoleIdxPstmt.executeQuery();
      if (rs.next()) {
        getRoleIdx = rs.getInt(1);
      }

      memberRolePstmt = con.prepareStatement(insertUserRoleTable);
      memberRolePstmt.setInt(1, generatedUserIdx);
      memberRolePstmt.setInt(2, getRoleIdx);
      memberRolePstmt.executeUpdate();

      con.commit();
      isSuccess = true;

    } catch (SQLException e) {
      if (con != null) {
        con.rollback();
      }
      e.printStackTrace();
      throw e;
    } finally {
      if (rs != null) try { rs.close(); } catch (SQLException e) {}
      if (commonUserPstmt != null) commonUserPstmt.close();
      if (getUserIdxPstmt != null) getUserIdxPstmt.close();
      if (memberPstmt != null) memberPstmt.close();
      if (getRoleIdxPstmt != null) getRoleIdxPstmt.close();
      if (memberRolePstmt != null) memberRolePstmt.close();
      if (con != null) con.setAutoCommit(true);
      if (con != null) con.close();
    }

    return isSuccess;
  }

  // 아이디 중복 검사
  public boolean selectMemberId(String memberId) throws SQLException {
    DbConnection dbCon = DbConnection.getInstance();
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean isDuplicate = false;

    try {
      con = dbCon.getDbConn();
      String selectQuery = " SELECT COUNT(*) FROM member WHERE member_id = ? ";
      pstmt = con.prepareStatement(selectQuery);
      pstmt.setString(1, memberId);
      rs = pstmt.executeQuery();

      if (rs.next()) {
        int count = rs.getInt(1);
        isDuplicate = (count > 0);
      }

    } finally {
      dbCon.dbClose(rs, pstmt, con);
    }

    return isDuplicate;
  }

  // 닉네임 중복 검사
  public boolean selectNickname(String nickName) throws SQLException {
    DbConnection dbCon = DbConnection.getInstance();
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean isDuplicate = false;

    try {
      con = dbCon.getDbConn();
      String selectQuery = " SELECT COUNT(*) FROM member WHERE nick_name = ? ";
      pstmt = con.prepareStatement(selectQuery);
      pstmt.setString(1, nickName);
      rs = pstmt.executeQuery();

      if (rs.next()) {
        int count = rs.getInt(1);
        isDuplicate = (count > 0);
      }

    } finally {
      dbCon.dbClose(rs, pstmt, con);
    }

    return isDuplicate;
  }

  // 핸드폰 중복 검사 
  public boolean selectTel(String tel) throws SQLException {
    DbConnection dbCon = DbConnection.getInstance();
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean isDuplicate = false;

    try {
      con = dbCon.getDbConn();
      String selectQuery = " SELECT COUNT(*) FROM member WHERE tel = ? ";
      pstmt = con.prepareStatement(selectQuery);
      pstmt.setString(1, tel);
      rs = pstmt.executeQuery();

      if (rs.next()) {
        int count = rs.getInt(1);
        isDuplicate = (count > 0);
      }

    } finally {
      dbCon.dbClose(rs, pstmt, con);
    }

    return isDuplicate;
  }

  // 이메일 중복 검사
  public boolean selectEmail(String email) throws SQLException {
    DbConnection dbCon = DbConnection.getInstance();
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean isDuplicate = false;

    try {
      con = dbCon.getDbConn();
      String selectQuery = " SELECT COUNT(*) FROM member WHERE email = ? ";
      pstmt = con.prepareStatement(selectQuery);
      pstmt.setString(1, email);
      rs = pstmt.executeQuery();

      if (rs.next()) {
        int count = rs.getInt(1);
        isDuplicate = (count > 0);
      }

    } finally {
      dbCon.dbClose(rs, pstmt, con);
    }

    return isDuplicate;
  }
  
  /**
   * 가입여부 확인 (이름, 생일, 이메일)
   * @throws SQLException 
   */
  public String isMemberByNBE(String name, Date birth, String email) throws SQLException {
    
    DbConnection dbCon = DbConnection.getInstance();
    Connection  con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    String memberId = null;
    
    try {
      con = dbCon.getDbConn();
      String isMember = " SELECT member_id FROM member WHERE user_name = ? AND birth = ? AND email = ? ";
      pstmt = con.prepareStatement(isMember);
      pstmt.setString(1, name);
      pstmt.setDate(2, birth);
      pstmt.setString(3, email);
      
      System.out.println(name +" - " + birth + " - " + email);
      
      rs = pstmt.executeQuery();
      
      if(rs.next()) {
        memberId = rs.getString("member_id");
      }
    } finally {
      dbCon.dbClose(rs, pstmt, con);
    }
    System.out.println(memberId);
    return memberId;
  }
  
  
  /**
   * 회원 비밀번호 찾기: 1.인증번호받기 누르면 아이디,생일,이메일주소로 회원이 실존하는지 체크
   * @throws SQLException 
   */
  public boolean isMemberByIBE(String memberId, Date birth, String email) throws SQLException {
    DbConnection dbCon = DbConnection.getInstance();
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    boolean flag = false;
    
    try {
      con = dbCon.getDbConn();
      String query = "  SELECT count(*) FROM member WHERE member_id = ? AND birth = ? AND email = ?   ";
      pstmt = con.prepareStatement(query);
      pstmt.setString(1, memberId);
      pstmt.setDate(2, birth);
      pstmt.setString(3, email);
      
      rs = pstmt.executeQuery();
      
      if(rs.next()) {
        int count = rs.getInt(1);
        if(count > 0) { //일치하는 회원이 존재 
          flag = true;
        } else {
          System.out.println("일치하는 회원이 없음 ");
        }
      }
      
    } finally {
      dbCon.dbClose(rs, pstmt, con);
    }
    return flag; 
  }
  
  //if(1 == true) -> 2.인증번호 이메일 보내고나면, 인증번호 테이블에 아이디, 생일, 이메일과 일치하는 객체의 인증번호 대조 
  
  
  /**
	 * 입력받은 아이디를 검색하는 
	 * @param id 검색할 아이디
	 * @return 검색된 아이디
	 * @throws SQLException 
	 */
	public boolean selectId(String id) throws SQLException{
		boolean flag=false;
		
		DbConnection db=DbConnection.getInstance();
		
		ResultSet rs=null;
		PreparedStatement pstmt=null;
		Connection con=null;
		
		try {
		//1.JDNI 사용객체 생성
		//2.DBCP에서 연결 객체 얻기(DataSource)
		//3.Connection얻기
			con=db.getDbConn();
		//4.쿼리문 생성객체 얻기
			StringBuilder selectIdQuery=new StringBuilder();
			selectIdQuery
			.append("  select  member_id          ")
			.append("  from    member  ")
			.append("  where   member_id=?        ");
			
			pstmt=con.prepareStatement(selectIdQuery.toString());
			
		//5.바인드변수에 값 할당
			pstmt.setString(1, id);
		//6.쿼리문 수행 후 결과 얻기
			rs=pstmt.executeQuery();
			
			flag= rs.next();
				
		}finally {
		//7.연결 끊기
			db.dbClose(rs, pstmt, con);
		}
		
		return flag;
			
	}//selectId

}
