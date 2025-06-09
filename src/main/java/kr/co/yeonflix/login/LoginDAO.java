package kr.co.yeonflix.login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;

import at.favre.lib.crypto.bcrypt.BCrypt;
import kr.co.yeonflix.dao.DbConnection;
import kr.co.yeonflix.member.MemberDTO;



/**
 * 로그인 관련 DB를 작업하는 DAO
 */
public class LoginDAO {
	
	private static LoginDAO lDAO;
	
	private LoginDAO() {
		
	}
	
	public static LoginDAO getInstance() {
		if(lDAO == null) {
			lDAO = new LoginDAO();
		}
		
		return lDAO;
	}//getInstance
	
	
	
	 /**
     * 로그인 정보를 기반으로 DB에서 회원 정보 조회
     * 
     * 사용자 ID로 회원 정보를 조회하고, 입력한 비밀번호와 DB에 저장된 해시된 비밀번호를 비교해
     * 일치하면 해당 회원 정보를 반환함.
     * 
     * DB에서 아이디가 일치하는 회원을 찾고, 입력한 비밀번호와 해시된 비밀번호를 비교
     * 
     * @param lDTO 사용자가 입력한 로그인 정보 (ID, Password)
     * @return 로그인 성공 시 MemberDTO 객체, 실패 시 null
     * @throws SQLException DB 처리 중 발생할 수 있는 예외
     */
	public MemberDTO selectLogin(LoginDTO lDTO) throws SQLException {
	    MemberDTO mDTO = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        con = DbConnection.getInstance().getDbConn();

	        String sql = "SELECT * FROM member WHERE member_id = ? AND is_active = 'Y'";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, lDTO.getId());

	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            String hashedPwd = rs.getString("member_pwd");

	            if (BCrypt.verifyer().verify(lDTO.getPass().toCharArray(), hashedPwd).verified) {
	                mDTO = new MemberDTO();
	                mDTO.setUserIdx(rs.getInt("user_idx"));
	                mDTO.setMemberId(rs.getString("member_id"));
	                mDTO.setMemberPwd(hashedPwd);
	                mDTO.setIsActive(rs.getString("is_active"));
	            }
	        }
	    } finally {
	        if (rs != null) rs.close();
	        if (pstmt != null) pstmt.close();
	        if (con != null) con.close();
	    }

	    return mDTO;
	}

	
	
	 /**
     * 회원 인덱스(userIdx)를 기준으로 회원 정보를 조회하는 메서드
     * 
     * 로그인 이후, 특정 사용자의 상세 정보를 userIdx로 조회
     * 
     * @param userIdx 회원 고유 번호 (user_idx)
     * @return 회원 정보가 담긴 MemberDTO 객체, 없으면 null
     * @throws SQLException DB 처리 중 발생할 수 있는 예외
     */
	public MemberDTO selectMemberById(int userIdx) throws SQLException {
	    MemberDTO mDTO = null;

	    DbConnection db = DbConnection.getInstance();

	    ResultSet rs = null;
	    PreparedStatement pstmt = null;
	    Connection con = null;

	    try {
	        con = db.getDbConn();

	        String sql = "SELECT * FROM member WHERE member_id = ? AND is_active = 'Y'";

	        pstmt = con.prepareStatement(sql);
	        pstmt.setInt(1, userIdx);

	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            mDTO = new MemberDTO();

	            mDTO.setUserIdx(rs.getInt("user_idx"));
	            mDTO.setMemberId(rs.getString("member_id"));
	            mDTO.setMemberId(rs.getString("member_pwd"));
	            mDTO.setNickName(rs.getString("nick_name"));
	            mDTO.setNickName(rs.getString("user_name"));
	            mDTO.setBirth(rs.getObject("birth", LocalDate.class));
	            mDTO.setTel(rs.getString("tel"));
	            mDTO.setIsSmsAgreed(rs.getString("is_sms_agreed"));
	            mDTO.setEmail(rs.getString("email"));
	            mDTO.setIsEmailAgreed(rs.getString("is_email_agreed"));
	            mDTO.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
	            mDTO.setIsActive(rs.getString("is_active"));
	            mDTO.setPicture(rs.getString("picture"));
	            mDTO.setMemberIp(rs.getString("member_ip"));
	        }
	    } finally {
	        db.dbClose(rs, pstmt, con);
	    }

	    return mDTO;
	}

	
	
}

