package kr.co.yeonflix.member;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import kr.co.yeonflix.dao.DbConnection;

public class MyPageDAO {
    private static MyPageDAO mpDAO;

    private MyPageDAO() {
    }

    public static MyPageDAO getInstance() {
        if (mpDAO == null) {
            mpDAO = new MyPageDAO();
        }
        return mpDAO;
    }//getInstance
    

    // 회원정보 수정 메서드
    public int updateMember(MemberDTO dto) throws SQLException {
        DbConnection db = DbConnection.getInstance();

        Connection con = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            con = db.getDbConn();

            String sql = "UPDATE member SET MEMBER_PWD = ?, NICK_NAME = ?, TEL = ?, IS_SMS_AGREED = ?, EMAIL = ?, IS_EMAIL_AGREED = ? WHERE MEMBER_ID = ?";
            pstmt = con.prepareStatement(sql);

            pstmt.setString(1, dto.getMemberPwd());
            pstmt.setString(2, dto.getNickName());
            pstmt.setString(3, dto.getTel());
            pstmt.setString(4, dto.getIsSmsAgreed());
            pstmt.setString(5, dto.getEmail());
            pstmt.setString(6, dto.getIsEmailAgreed());
            pstmt.setString(7, dto.getMemberId());

            result = pstmt.executeUpdate();

        } finally {
            db.dbClose(null, pstmt, con);
        }

        return result;
    }


    public MemberDTO selectOne(String memberId) throws SQLException {
        DbConnection db = DbConnection.getInstance();

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        MemberDTO dto = null;

        try {
            con = db.getDbConn();

            String sql = "SELECT USER_IDX, MEMBER_ID, MEMBER_PWD, NICK_NAME, USER_NAME, BIRTH, TEL, IS_SMS_AGREED, EMAIL, IS_EMAIL_AGREED, CREATED_AT, IS_ACTIVE FROM member WHERE MEMBER_ID = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, memberId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new MemberDTO();
                dto.setUserIdx(rs.getInt("USER_IDX"));
                dto.setMemberId(rs.getString("MEMBER_ID"));
                dto.setMemberPwd(rs.getString("MEMBER_PWD"));
                dto.setNickName(rs.getString("NICK_NAME"));
                dto.setUserName(rs.getString("USER_NAME"));
                Date birthDate = rs.getDate("BIRTH");
                if (birthDate != null) {
                    dto.setBirth(birthDate.toLocalDate());
                }
                dto.setTel(rs.getString("TEL"));
                dto.setIsSmsAgreed(rs.getString("IS_SMS_AGREED"));
                dto.setEmail(rs.getString("EMAIL"));
                dto.setIsEmailAgreed(rs.getString("IS_EMAIL_AGREED"));
                Timestamp createdTimestamp = rs.getTimestamp("CREATED_AT");
                if (createdTimestamp != null) {
                    dto.setCreatedAt(createdTimestamp.toLocalDateTime());
                }
                dto.setIsActive(rs.getString("IS_ACTIVE"));
            }

        } finally {
            db.dbClose(rs, pstmt, con);
        }

        return dto;
    }

    
    
}
