package kr.co.yeonflix.member;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

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
	/* 로그인 */ 
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
      con = dbCon.getDbConn(); // 실제 DB연결 받아오는거

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

	/* 일반 회원가입 */
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
  
  //발급받은 임시비밀번호로 회원정보 수정 
  public boolean updatePwd(String email, String encodedTempPwd) throws SQLException {
	  
	  DbConnection dbCon = DbConnection.getInstance();
	  Connection con = null;
	  PreparedStatement pstmt = null;
	  int result = -1;
	  try {
		  con = dbCon.getDbConn();// 실제 DB연결 받아오는거
		  
		  String query = " UPDATE member SET member_pwd = ? WHERE email = ?  ";
		  pstmt = con.prepareStatement(query);
		  
		  pstmt.setString(1, encodedTempPwd);
		  pstmt.setString(2, email);
		  
		  System.out.println("executeUpdate 직전: email=" + email + ", tempPwd=" + encodedTempPwd);
		  result = pstmt.executeUpdate();
		  System.out.println("executeUpdate 결과: " + result);
		  
	  } finally {
		  dbCon.dbClose(null, pstmt, con);
	  }
	  return result > 0;
  }
  
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
	
	
	public List<MemberDTO> selectAllMember(RangeDTO rDTO) throws SQLException {
	    List<MemberDTO> list = new ArrayList<>();
	    DbConnection dbCon = DbConnection.getInstance();
	    Connection con = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt = null;

	    try {
	        con = dbCon.getDbConn();

	        String searchField = validateFieldName(rDTO.getFieldName());  // ex) user_name
	        String keyword = rDTO.getKeyword();

	        StringBuilder sql = new StringBuilder();
	        sql.append("SELECT * FROM ( ");
	        sql.append("  SELECT ROWNUM rnum, a.* FROM ( ");
	        sql.append("    SELECT * FROM member ");

	        // 검색 조건 추가
	        if (searchField != null && keyword != null && !keyword.trim().isEmpty()) {
	            sql.append(" WHERE ").append(searchField).append(" LIKE ? ");
	        }

	        sql.append(" ORDER BY created_at DESC ");
	        sql.append("  ) a WHERE ROWNUM <= ? "); // endRow
	        sql.append(") WHERE rnum > ?");         // startRow

	        pstmt = con.prepareStatement(sql.toString());

	        int paramIndex = 1;

	        // 검색 조건 바인딩
	        if (searchField != null && keyword != null && !keyword.trim().isEmpty()) {
	            pstmt.setString(paramIndex++, "%" + keyword + "%");
	        }

	        int startRow = rDTO.getStartIndex();
	        int endRow = startRow + rDTO.getPageSize();

	        pstmt.setInt(paramIndex++, endRow);
	        pstmt.setInt(paramIndex++, startRow);

	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            MemberDTO memberDTO = new MemberDTO();
	            memberDTO.setUserIdx(rs.getInt("user_idx"));
	            memberDTO.setMemberId(rs.getString("member_id"));
	            memberDTO.setNickName(rs.getString("nick_name"));
	            memberDTO.setUserName(rs.getString("user_name"));

	            java.sql.Date birthDate = rs.getDate("birth");
	            if (birthDate != null) {
	                memberDTO.setBirth(birthDate.toLocalDate());
	            }

	            memberDTO.setTel(rs.getString("tel"));
	            memberDTO.setEmail(rs.getString("email"));

	            java.sql.Timestamp createdAtTs = rs.getTimestamp("created_at");
	            if (createdAtTs != null) {
	                memberDTO.setCreatedAt(createdAtTs.toLocalDateTime());
	            }

	            memberDTO.setIsActive(rs.getString("is_active"));

	            list.add(memberDTO);
	        }

	    } finally {
	        dbCon.dbClose(rs, pstmt, con);
	    }

	    return list;
	}



	/**
	 * 허용된 컬럼명만 반환, 검증용 메서드
	 * 허용된 컬럼명이 아니면 null 반환
	 */
	private String validateFieldName(String fieldName) {
	    // 허용할 컬럼명 배열 예시
	    String[] allowedFields = {"member_id", "nick_name", "user_name", "email", "tel"};
	    for (String allowed : allowedFields) {
	        if (allowed.equalsIgnoreCase(fieldName)) {
	            return allowed;
	        }
	    }
	    return null;  // 허용되지 않는 필드명
	}

	

	
	
	/**
	 * 게시물 전체 개수
	 * @return cnt 게시물 전체 개수
	 * @throws SQLException 예외처리
	 */
	public int selectTotalCount(RangeDTO rDTO) throws SQLException {
	    int cnt = 0;
	    DbConnection dbCon = DbConnection.getInstance();

	    ResultSet rs = null;
	    PreparedStatement pstmt = null;
	    Connection con = null;

	    try {
	        con = dbCon.getDbConn();

	        StringBuilder countQuery = new StringBuilder("SELECT COUNT(member_id) cnt FROM member");

	        String fieldName = validateFieldName(rDTO.getFieldName());
	        String keyword = rDTO.getKeyword();

	        if (fieldName != null && keyword != null && !keyword.trim().isEmpty()) {
	            countQuery.append(" WHERE ").append(fieldName).append(" LIKE ?");
	        }

	        pstmt = con.prepareStatement(countQuery.toString());

	        if (fieldName != null && keyword != null && !keyword.trim().isEmpty()) {
	            pstmt.setString(1, "%" + keyword.trim() + "%");
	        }

	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            cnt = rs.getInt("cnt");
	        }
	    } finally {
	        dbCon.dbClose(rs, pstmt, con);
	    }

	    return cnt;
	}




  
	public MemberDTO selectOneMember(int user_idx) throws SQLException {
	    MemberDTO mDTO = null;

	    DbConnection db = DbConnection.getInstance();
	    ResultSet rs = null;
	    PreparedStatement pstmt = null;
	    Connection con = null;

	    try {
	        con = db.getDbConn();

	        StringBuilder sql = new StringBuilder();
	        sql.append("SELECT * FROM member ")
	           .append("WHERE user_idx = ?");

	        pstmt = con.prepareStatement(sql.toString());
	        pstmt.setInt(1, user_idx);

	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            mDTO = new MemberDTO();
	            mDTO.setUserIdx(rs.getInt("user_idx")); 
	            mDTO.setMemberId(rs.getString("member_id"));
	            mDTO.setNickName(rs.getString("nick_name"));
	            mDTO.setUserName(rs.getString("user_name"));
	            
	            Date birthDate = rs.getDate("birth");
	            if (birthDate != null) {
	                mDTO.setBirth(birthDate.toLocalDate());
	            }
	            
	            mDTO.setTel(rs.getString("tel"));
	            mDTO.setEmail(rs.getString("email"));
	            
	            java.sql.Timestamp createdTimestamp = rs.getTimestamp("created_at");
	            if (createdTimestamp != null) {
	                mDTO.setCreatedAt(createdTimestamp.toLocalDateTime());
	            }
	            mDTO.setPicture(rs.getString("picture"));
	        }
	    } finally {
	        db.dbClose(rs, pstmt, con);
	    }

	    return mDTO;
	}//selectOneMember
	
		
	public boolean updateMember(MemberDTO memberVO) throws SQLException {
	    DbConnection dbCon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    boolean result = false;

	    try {
	        con = dbCon.getDbConn();

	        // 1. 기존 회원 정보 가져오기
	        MemberDTO existing = getMemberByUserIdx(memberVO.getUserIdx());
	        
	        
	        // 2. 비밀번호가 null 또는 빈 값이면 기존 비밀번호 유지
	        String password = memberVO.getMemberPwd();
	        if (password == null || password.trim().isEmpty()) {
	            password = existing.getMemberPwd();
	        }

	        // 2. 닉네임이 변경되었을 경우 중복 검사
	        if (!memberVO.getNickName().equals(existing.getNickName())) {
	            if (isNicknameDuplicate(memberVO.getNickName(), con)) {
	                throw new IllegalArgumentException("이미 사용 중인 닉네임입니다.");
	            }
	        }

	        String email = memberVO.getEmail();
	        if (email == null || email.trim().isEmpty()) {
	            email = existing.getEmail();
	        }

	        // 4. UPDATE 수행
	        String query = "UPDATE member SET member_pwd = ?, nick_name = ?, tel = ?, is_sms_agreed = ?, email = ?, is_email_agreed = ?, picture = ? WHERE user_idx = ?";
	        pstmt = con.prepareStatement(query);
	        pstmt.setString(1, password);
	        pstmt.setString(2, memberVO.getNickName());
	        pstmt.setString(3, memberVO.getTel());
	        pstmt.setString(4, memberVO.getIsSmsAgreed());
	        pstmt.setString(5, email);
	        pstmt.setString(6, memberVO.getIsEmailAgreed());
	        pstmt.setString(7, memberVO.getPicture());
	        pstmt.setInt(8, memberVO.getUserIdx());

	        int cnt = pstmt.executeUpdate();
	        result = cnt > 0;

	    } finally {
	        dbCon.dbClose(null, pstmt, con);
	    }

	    return result;
	}

	
	public boolean updateIsActive(int userIdx, String isActive) throws SQLException{
		DbConnection dbCon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		boolean result=false;
		
		
		try {
			con = dbCon.getDbConn();

			String query = "UPDATE member SET is_active = ? WHERE user_idx = ?";
			
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, isActive);
		    pstmt.setInt(2, userIdx);
			
			int cnt = pstmt.executeUpdate();
			
			if (cnt > 0) {
				result = true;
			}
			
			
		}finally {
			dbCon.dbClose(null, pstmt, con);
		}
			
			
		if (!"Y".equals(isActive) && !"N".equals(isActive)) {
	        isActive = "N"; 
	    }
			
		
		return result;
		
	}
	
	private MemberDTO getMemberByUserIdx(int userIdx) throws SQLException {
	    DbConnection dbCon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        con = dbCon.getDbConn();

	        String sql = "SELECT member_pwd, nick_name, tel, is_sms_agreed, email, is_email_agreed, picture FROM member WHERE user_idx = ?";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setInt(1, userIdx);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            MemberDTO dto = new MemberDTO();
	            dto.setMemberPwd(rs.getString("member_pwd"));
	            dto.setNickName(rs.getString("nick_name"));
	            dto.setTel(rs.getString("tel"));
	            dto.setIsSmsAgreed(rs.getString("is_sms_agreed"));
	            dto.setEmail(rs.getString("email"));
	            dto.setIsEmailAgreed(rs.getString("is_email_agreed"));
	            dto.setPicture(rs.getString("picture"));
	            return dto;
	        }
	        return null;

	    } finally {
	        dbCon.dbClose(rs, pstmt, con);
	    }
	}

	// 닉네임 중복 확인
	private boolean isNicknameDuplicate(String nickName, Connection con) throws SQLException {
	    String sql = "SELECT COUNT(*) FROM member WHERE nick_name = ?";
	    try (PreparedStatement pstmt = con.prepareStatement(sql)) {
	        pstmt.setString(1, nickName);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            return rs.next() && rs.getInt(1) > 0;
	        }
	    }
	}


}
