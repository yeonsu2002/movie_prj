package kr.co.yeonflix.member;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.security.auth.message.callback.PrivateKeyCallback.Request;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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

      String getMemberQuery = " SELECT * FROM member WHERE member_id = ? ";
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
          memberVO.setIsActive(rsMember.getString("is_active"));
          memberVO.setHasTempPwd(rsMember.getString("has_temp_pwd"));

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
      String insertMember = " INSERT INTO member (USER_IDX, MEMBER_ID, MEMBER_PWD, NICK_NAME, USER_NAME, BIRTH, TEL, IS_SMS_AGREED, EMAIL, IS_EMAIL_AGREED, CREATED_AT, IS_ACTIVE, PICTURE, MEMBER_IP, HAS_TEMP_PWD) "
          + "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'N') ";
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
      
      rs = pstmt.executeQuery();
      
      if(rs.next()) {
        memberId = rs.getString("member_id");
      }
    } finally {
      dbCon.dbClose(rs, pstmt, con);
    }
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
	   PreparedStatement hasTempPwdPstmt = null;
	
	   int result = -1;
	
	   try {
	       con = dbCon.getDbConn();
	       con.setAutoCommit(false); // 트랜잭션 처리
	
	       // has_temp_pwd 값을 'Y'로 업데이트
	       String tempPwdQuery = "UPDATE member SET has_temp_pwd = 'Y' WHERE email = ?";
	       hasTempPwdPstmt = con.prepareStatement(tempPwdQuery);
	       hasTempPwdPstmt.setString(1, email);
	       hasTempPwdPstmt.executeUpdate();
	
	       // 실제 비밀번호 업데이트
	       String pwdUpdateQuery = "UPDATE member SET member_pwd = ? WHERE email = ?";
	       pstmt = con.prepareStatement(pwdUpdateQuery);
	       pstmt.setString(1, encodedTempPwd);
	       pstmt.setString(2, email);
	       result = pstmt.executeUpdate();
	
	       con.commit(); // 둘 다 성공해야  커밋함 
	       
	   } catch (Exception e) {
	       if (con != null) {
	           try {
	               con.rollback(); // 예외 발생 -> 롤백
	           } catch (SQLException se) {
	               se.printStackTrace();
	           }
	       }
	       e.printStackTrace();
	   } finally {
	       dbCon.dbClose(null, hasTempPwdPstmt, null);
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
	
	
	/**
	 * 회원 목록을 검색 조건과 페이지 범위에 따라 조회하는 메서드.
	 * 
	 * <p>검색 조건이 있는 경우 해당 필드명에 keyword가 포함된 회원을 검색하고, 
	 * Oracle의 ROW_NUMBER() 함수를 이용하여 페이징 처리된 결과를 반환한다.</p>
	 *
	 * @param rDTO 검색 필드명, 키워드, 시작 인덱스 및 페이지 크기를 담고 있는 RangeDTO 객체
	 * @return 조건에 맞는 회원 목록을 담은 List<MemberDTO>
	 * @throws SQLException DB 작업 중 발생할 수 있는 예외
	 */
	public List<MemberDTO> selectAllMember(RangeDTO rDTO) throws SQLException {
	    List<MemberDTO> list = new ArrayList<>();
	    DbConnection dbCon = DbConnection.getInstance();
	    Connection con = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt = null;

	    try {
	        con = dbCon.getDbConn();

	        String fieldName = validateFieldName(rDTO.getFieldName());
	        String keyword = rDTO.getKeyword();

	        StringBuilder sql = new StringBuilder();
	        sql.append("SELECT * FROM ( ");
	        sql.append("  SELECT user_idx, member_id, nick_name, user_name, birth, tel, email, created_at, is_active, ");
	        sql.append("         ROW_NUMBER() OVER (ORDER BY created_at DESC) rnum ");
	        sql.append("  FROM member ");

	        if (fieldName != null && keyword != null && !keyword.trim().isEmpty()) {
	            sql.append(" WHERE ").append(fieldName).append(" LIKE ? ");
	        }

	        sql.append(") WHERE rnum BETWEEN ? AND ?");

	        pstmt = con.prepareStatement(sql.toString());

	        int paramIndex = 1;
	        if (fieldName != null && keyword != null && !keyword.trim().isEmpty()) {
	            pstmt.setString(paramIndex++, "%" + keyword + "%");
	        }

	        int startRow = rDTO.getStartIndex() + 1;
	        int endRow = rDTO.getStartIndex() + rDTO.getPageSize();
	        pstmt.setInt(paramIndex++, startRow);
	        pstmt.setInt(paramIndex++, endRow);

	        rs = pstmt.executeQuery();
	        

	        while (rs.next()) {
	            MemberDTO memberDTO = new MemberDTO();
	            memberDTO.setUserIdx(rs.getInt("user_idx"));
	            memberDTO.setMemberId(rs.getString("member_id"));
	            memberDTO.setNickName(rs.getString("nick_name"));
	            memberDTO.setUserName(rs.getString("user_name"));

	            if (rs.getDate("birth") != null) {
	                memberDTO.setBirth(rs.getDate("birth").toLocalDate());
	            }

	            memberDTO.setTel(rs.getString("tel"));
	            memberDTO.setEmail(rs.getString("email"));

	            if (rs.getTimestamp("created_at") != null) {
	                memberDTO.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
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
		
		
	    String[] allowedFields = {"user_name", "email", "tel"};
	    for (String allowed : allowedFields) {
	        if (allowed.equalsIgnoreCase(fieldName)) {
	            return allowed;
	        }
	    }
	    return null; 
	}

	

	
	
	/**
	 * 회원 테이블에서 조건에 맞는 전체 회원 수를 조회하는 메서드
	 * 
	 * @param rDTO 검색 조건 및 페이징 정보를 담은 객체
	 * @return 조건에 맞는 회원 수 (int)
	 * @throws SQLException DB 처리 중 오류 발생 시 예외 던짐
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




  
	/**
	 * 특정 회원(user_idx)을 DB에서 조회하여 MemberDTO 객체로 반환하는 메서드
	 * 
	 * @param user_idx 조회할 회원의 고유 번호
	 * @return 조회된 회원 정보가 담긴 MemberDTO 객체, 없으면 null 반환
	 * @throws SQLException DB 접근 중 예외 발생 시 전달
	 */
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
	
		
	/**
	 * 회원 정보를 수정하는 메서드
	 * - user_idx로 기존 회원 정보 조회 후,
	 * - 입력된 값이 없거나 빈 값이면 기존 값 유지
	 * - 닉네임 변경 시 중복 체크 수행
	 * - 최종적으로 회원 정보 DB에 업데이트
	 * 
	 * @param memberVO 수정할 회원 정보가 담긴 MemberDTO 객체
	 * @return 수정 성공 시 true, 실패 시 false 반환
	 * @throws SQLException DB 처리 중 예외 발생 시 전달
	 * @throws IllegalArgumentException 닉네임 중복 시 발생
	 */
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

	        // 3. 닉네임이 변경되었을 경우 중복 검사
	        if (!memberVO.getNickName().equals(existing.getNickName())) {
	            if (isNicknameDuplicate(memberVO.getNickName())) {
	                throw new IllegalArgumentException("이미 사용 중인 닉네임입니다.");
	            }
	        }

	        // 4. 이메일 처리 (빈 값이면 기존 이메일 사용)
	        String email = memberVO.getEmail();
	        if (email == null || email.trim().isEmpty()) {
	            email = existing.getEmail();
	        }

	        // 5. 프로필 사진 처리 (빈 값이면 기존 사진 사용)
	        String picture = memberVO.getPicture();
	        if (picture == null || picture.trim().isEmpty()) {
	            picture = existing.getPicture();
	        }

	        // 6. 전화번호 처리 (빈 값이면 기존 전화번호 사용)
	        String tel = memberVO.getTel();
	        if (tel == null || tel.trim().isEmpty()) {
	            tel = existing.getTel();
	        }

	        // 7. 회원 ID 처리 (빈 값이면 기존 ID 사용)
	        String Id = memberVO.getMemberId();
	        if (Id == null || Id.trim().isEmpty()) {
	            Id = existing.getMemberId();
	        }
	        
	        String IsSmsAgreed = memberVO.getIsSmsAgreed();
	        if (IsSmsAgreed == null || IsSmsAgreed.trim().isEmpty()) {
	        	IsSmsAgreed = existing.getIsSmsAgreed();
	        }
	        
	        String IsEmailAgreed = memberVO.getIsEmailAgreed();
	        if (IsEmailAgreed == null || IsEmailAgreed.trim().isEmpty()) {
	        	IsEmailAgreed = existing.getIsEmailAgreed();
	        }
	        
	        

	        // 8. DB UPDATE 수행
	        String query = "UPDATE member SET member_pwd = ?, nick_name = ?, tel = ?, is_sms_agreed = ?, email = ?, is_email_agreed = ?, picture = ?, has_temp_pwd = 'N' WHERE user_idx = ?";
	        pstmt = con.prepareStatement(query);
	        pstmt.setString(1, password);
	        pstmt.setString(2, memberVO.getNickName());
	        pstmt.setString(3, tel);
	        pstmt.setString(4, IsSmsAgreed);
	        pstmt.setString(5, email);
	        pstmt.setString(6, IsEmailAgreed);
	        pstmt.setString(7, picture);
	        pstmt.setInt(8, memberVO.getUserIdx());

	        int cnt = pstmt.executeUpdate();
	        result = cnt > 0;

			/*
			 * // 9. 세션 갱신 (회원 정보 수정 후 세션에 최신 정보 반영) if (result) { HttpSession session =
			 * request.getSession(); session.setAttribute("loginUser", memberVO); // 수정된 정보로
			 * 세션 갱신 }
			 */

	    } catch (SQLException e) {
	        e.printStackTrace();
	        throw new SQLException("회원 정보 수정 중 오류가 발생했습니다.", e);
	    } finally {
	        dbCon.dbClose(null, pstmt, con);
	    }

	    return result;
	}

	
	
	
	/**
	 * 주어진 userIdx에 해당하는 회원 정보를 DB에서 조회하여 MemberDTO 객체로 반환하는 메서드
	 * 기존 회원 정보 가져오기
	 * 
	 * @param userIdx 조회할 회원의 고유번호(user_idx)
	 * @return 해당 회원 정보가 담긴 MemberDTO 객체, 회원이 없으면 null 반환
	 * @throws SQLException DB 처리 중 에러 발생 시 예외 던짐
	 */
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
	            dto.setUserIdx(userIdx);
	            return dto;
	        }
	        return null;

	    } finally {
	        dbCon.dbClose(rs, pstmt, con);
	    }
	}

	
	/**
	 * 회원의 활성 상태(is_active)를 업데이트하는 메서드
	 * 
	 * @param userIdx 활성 상태를 변경할 회원의 고유 번호
	 * @param isActive 변경할 활성 상태 값 (예: "Y" 또는 "N")
	 * @return 업데이트 성공 여부 (성공하면 true, 실패하면 false)
	 * @throws SQLException 데이터베이스 처리 중 오류 발생 시 예외 전달
	 */
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
	
	

	// 닉네임 중복 확인
	private boolean isNicknameDuplicate(String nickName) throws SQLException {
	    DbConnection dbCon = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;

	    try {
	        con = dbCon.getDbConn();
	        String sql = "SELECT COUNT(*) FROM member WHERE nick_name = ?";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, nickName);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            return rs.next() && rs.getInt(1) > 0;
	        }
	    } finally {
	        dbCon.dbClose(null, pstmt, con);
	    }
	}
	
	//이메일로 회원정보 조회
  public MemberDTO selectMemberByEmail(String email) throws SQLException {
    
    MemberDTO mDTO = null;

    DbConnection db = DbConnection.getInstance();
    ResultSet rs = null;
    PreparedStatement pstmt = null;
    Connection con = null;

    try {
        con = db.getDbConn();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM member ")
           .append("WHERE email = ?");

        pstmt = con.prepareStatement(sql.toString());
        pstmt.setString(1, email);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            mDTO = new MemberDTO();
            mDTO.setUserIdx(rs.getInt("user_idx")); 
            mDTO.setMemberId(rs.getString("member_id"));
            mDTO.setNickName(rs.getString("nick_name"));
            mDTO.setUserName(rs.getString("user_name"));
            mDTO.setIsActive(rs.getString("is_active"));
            
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
  }


}
