package kr.co.yeonflix.inquiry;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import kr.co.yeonflix.dao.DbConnection;


public class inquiryDAO {
	private DbConnection dbCon;
	public inquiryDAO() {
		dbCon = DbConnection.getInstance();
	}

	public List<inquiryDTO> selectAllinquiry(String user) throws SQLException {
		List<inquiryDTO> inquiryList = new ArrayList<inquiryDTO>();
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		String sql = "select inquiry_board_idx,board_code_name,inquiry_title,inquiry_content, TO_CHAR(created_time, 'YYYY-MM-DD')as created_time,answer_status,answer_content,answered_time,admin_id "
				+ "from inquiry_board ";
		if(!user.equals("all")) {
			sql+="where user_idx=? ";
		}
		sql+="order by inquiry_board_idx";
		try { 
			conn = dbCon.getDbConn();
			pstmt = conn.prepareStatement(sql);
			if(!user.equals("all")) {
			pstmt.setString(1, user);
			}
			rs = pstmt.executeQuery();
			while(rs.next()) {
				inquiryDTO iDTO = new inquiryDTO();
				iDTO.setBoard_code_name(rs.getString("board_code_name"));
				iDTO.setInquiry_board_idx(rs.getInt("inquiry_board_idx"));
				iDTO.setInquiry_title(rs.getString("inquiry_title"));
				iDTO.setInquiry_content(rs.getString("inquiry_content"));
				iDTO.setCreated_time(rs.getString("created_time"));
				iDTO.setAnswer_status(rs.getInt("answer_status"));
				
				inquiryList.add(iDTO);
			}
		}finally {
			dbCon.dbClose(rs, pstmt, conn);
		}
		return inquiryList;
	}
	
	public inquiryDTO selectinquiry(String num) throws SQLException {
		inquiryDTO iDTO = null;
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		String sql = "select inquiry_board_idx,board_code_name,inquiry_title,inquiry_content, TO_CHAR(created_time, 'YYYY-MM-DD')as created_time,answer_status,answer_content,answered_time,admin_id "
				+ "from inquiry_board "
				+ "where inquiry_board_idx=? "
				+ "order by inquiry_board_idx";
		try {
			conn = dbCon.getDbConn();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, num);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				iDTO = new inquiryDTO();
				iDTO.setBoard_code_name(rs.getString("board_code_name"));
				iDTO.setInquiry_board_idx(rs.getInt("inquiry_board_idx"));
				iDTO.setInquiry_title(rs.getString("inquiry_title"));
				iDTO.setInquiry_content(rs.getString("inquiry_content"));
				iDTO.setCreated_time(rs.getString("created_time"));
				iDTO.setAnswer_status(rs.getInt("answer_status"));
				iDTO.setAnswer_content(rs.getString("answer_content"));
				iDTO.setAnswered_time(rs.getString("answered_time"));
				iDTO.setAdmin_id(rs.getString("admin_id"));
			}
		}finally {
			dbCon.dbClose(rs, pstmt, conn);
		}
		return iDTO;
	}
	
	public void insertinquiry(String type,String title,String content,int user) throws SQLException {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = "INSERT INTO inquiry_board(inquiry_board_idx,board_code_name, inquiry_title, inquiry_content, created_time,answer_status,user_idx) "
	    		+ "VALUES (inquiry_board_idx_seq.nextval,?, ?, ?,current_timestamp,0,?)";
	    try {
	    	conn = dbCon.getDbConn();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, type);  // 인덱스는 1부터 시작
	        pstmt.setString(2, title);
	        pstmt.setString(3, content);
	        pstmt.setInt(4, user);
	        pstmt.executeUpdate(); // INSERT는 executeUpdate()
	    } finally {
	        dbCon.dbClose(rs,pstmt, conn);
	    }
	}

	
	public void deleteinquiry(String num) throws SQLException {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		String sql = "delete from inquiry_board where inquiry_board_idx=?";
		try {
			conn = dbCon.getDbConn();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, num);
			pstmt.executeUpdate();
		}finally {
			dbCon.dbClose(rs, pstmt, conn);
		}
	}
	
	public void alterinquiry(String num, String content) throws SQLException {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = "update inquiry_board set answer_content=?, answer_status=1, answered_time=current_timestamp where inquiry_board_idx=? ";
	    try {
	    	conn = dbCon.getDbConn();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, content);  // 인덱스는 1부터 시작
	        pstmt.setString(2, num);
	        pstmt.executeUpdate(); // INSERT는 executeUpdate()
	    } finally {
	        dbCon.dbClose(rs,pstmt, conn);
	    }
	}
	
	public int getInquiryCount(String user) throws SQLException {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = "SELECT COUNT(*) FROM inquiry_board ";
	    if(!user.equals("all")) {
	    	sql+="WHERE user_idx=?";
	    }
	    try {
	    	conn = dbCon.getDbConn();
	        pstmt = conn.prepareStatement(sql);
	        if(!user.equals("all")) {
	        pstmt.setString(1, user);
	        }
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
	        }
	    } finally {
	      dbCon.dbClose(rs, pstmt, conn);
	    }
	    return count;
	}
	
	public List<inquiryDTO> selectPaged(String user, int page, int size) throws SQLException {
	    List<inquiryDTO> list = new ArrayList<>();
	    int start = (page - 1) * size + 1; // 시작 row 번호
	    int end = page * size;            // 끝 row 번호

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql = 
	        "SELECT * FROM (" +
	        "    SELECT ROWNUM rnum, a.* FROM (" +
	        "        SELECT * FROM inquiry_board WHERE user_idx = ? ORDER BY inquiry_board_idx DESC" +
	        "    ) a WHERE ROWNUM <= ?" +
	        ") WHERE rnum >= ?";

	    try {
	        conn = dbCon.getDbConn();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, user);
	        pstmt.setInt(2, end);   // 상위 N개까지
	        pstmt.setInt(3, start); // 시작 위치

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            inquiryDTO iDTO = new inquiryDTO();
				iDTO.setBoard_code_name(rs.getString("board_code_name"));
				iDTO.setInquiry_board_idx(rs.getInt("inquiry_board_idx"));
				iDTO.setInquiry_title(rs.getString("inquiry_title"));
				iDTO.setInquiry_content(rs.getString("inquiry_content"));
				iDTO.setCreated_time(rs.getString("created_time"));
				iDTO.setAnswer_status(rs.getInt("answer_status"));
				
	            // 필요한 항목 추가
	            list.add(iDTO);
	        }
	    } finally {
	        dbCon.dbClose(rs, pstmt, conn);
	    }

	    return list;
	}

	public List<inquiryDTO> selectAllPaged( int page, int size) throws SQLException {
	    List<inquiryDTO> list = new ArrayList<>();
	    int start = (page - 1) * size + 1; // 시작 row 번호
	    int end = page * size;            // 끝 row 번호

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql = 
	        "SELECT * FROM (" +
	        "    SELECT ROWNUM rnum, a.* FROM (" +
	        "        SELECT * FROM inquiry_board ORDER BY inquiry_board_idx DESC" +
	        "    ) a WHERE ROWNUM <= ?" +
	        ") WHERE rnum >= ?";

	    try {
	        conn = dbCon.getDbConn();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, end);   // 상위 N개까지
	        pstmt.setInt(2, start); // 시작 위치

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            inquiryDTO iDTO = new inquiryDTO();
				iDTO.setBoard_code_name(rs.getString("board_code_name"));
				iDTO.setInquiry_board_idx(rs.getInt("inquiry_board_idx"));
				iDTO.setInquiry_title(rs.getString("inquiry_title"));
				iDTO.setInquiry_content(rs.getString("inquiry_content"));
				iDTO.setCreated_time(rs.getString("created_time"));
				iDTO.setAnswer_status(rs.getInt("answer_status"));
				
	            // 필요한 항목 추가
	            list.add(iDTO);
	        }
	    } finally {
	        dbCon.dbClose(rs, pstmt, conn);
	    }

	    return list;
	}

}
