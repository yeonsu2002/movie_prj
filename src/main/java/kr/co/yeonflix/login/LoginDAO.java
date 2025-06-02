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


public class LoginDAO {
	
	private static LoginDAO lDAO;
	
	private LoginDAO() {
		
	}
	
	public static LoginDAO getInstance() {
		if(lDAO == null) {
			lDAO = new LoginDAO();
		}
		
		return lDAO;
	}
	
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

