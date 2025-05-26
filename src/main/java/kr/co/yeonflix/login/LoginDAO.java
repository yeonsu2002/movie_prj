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
		System.out.println("pwd ; " + lDTO.getPass());
	    MemberDTO mDTO = null;

	    DbConnection db = DbConnection.getInstance();

	    ResultSet rs = null;
	    PreparedStatement pstmt = null;
	    PreparedStatement pwdPstmt = null;
	    Connection con = null;

	    String pwd = null;
	    try {
	        con = db.getDbConn();

	        String getPwd = "	SELECT * FROM member WHERE member_id = ?	";
	        pwdPstmt = con.prepareStatement(getPwd);
	        pwdPstmt.setString(1, lDTO.getId());
	        
	        rs = pwdPstmt.executeQuery();
	        
	        if(rs.next()) {
	        	pwd = rs.getString("member_pwd");  //db의 비밀번호를 가져와서 pwd변수에 넣어.
	        	
	        	BCrypt.Result result = BCrypt.verifyer().verify(lDTO.getPass().toCharArray(), pwd);
	        	//lDTO.getPass().toCharArray() -> 내가 입력한 비밀번호를 Char배열로 만들어.
	        	//pwd는 이미 BCrypt로 인코딩된 비밀번호.
	        	//BCrypt.verifyer().verify() -> BCrypt 클래스 내부에 특수한 키가 있어(salt : 인코딩할때 쓰이는 키), pwd에서  slat로 복호화?시켜. 맞냐? = result
	        	
	        	if(result.verified) {
	        		mDTO = new MemberDTO();

		            mDTO.setUserIdx(rs.getInt("user_idx"));
		            mDTO.setMemberId(rs.getString("member_id"));
		            mDTO.setMemberPwd(rs.getString("member_pwd"));
		            mDTO.setNickName(rs.getString("nick_name"));
		            mDTO.setUserName(rs.getString("user_name"));
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
	        }
	        
	    } finally {
	        db.dbClose(rs, pstmt, con);
	    }

	    return mDTO;
	}
	
	
	public MemberDTO selectMemberById(String memberId) throws SQLException {
	    MemberDTO mDTO = null;

	    DbConnection db = DbConnection.getInstance();

	    ResultSet rs = null;
	    PreparedStatement pstmt = null;
	    Connection con = null;

	    try {
	        con = db.getDbConn();

	        String sql = "SELECT * FROM member WHERE member_id = ? AND is_active = 'Y'";

	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, memberId);

	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            mDTO = new MemberDTO();

	            mDTO.setUserIdx(rs.getInt("user_idx"));
	            mDTO.setMemberId(rs.getString("member_id"));
	            mDTO.setMemberPwd(rs.getString("member_pwd"));
	            mDTO.setNickName(rs.getString("nick_name"));
	            mDTO.setUserName(rs.getString("user_name"));
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

