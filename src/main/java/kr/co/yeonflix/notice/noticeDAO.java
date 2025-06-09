package kr.co.yeonflix.notice;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.security.auth.message.callback.PrivateKeyCallback.Request;
import javax.servlet.http.HttpServletRequest;

import kr.co.yeonflix.dao.DbConnection;
import kr.co.yeonflix.inquiry.inquiryDTO;


public class noticeDAO {
	private DbConnection dbCon;
	public noticeDAO() {
		dbCon = DbConnection.getInstance();
	}

	public List<noticeDTO> selectAllNotice() throws SQLException {
		List<noticeDTO> noticeList = new ArrayList<noticeDTO>();
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		String sql = "select notice_board_idx,board_code_name,notice_title,notice_content, TO_CHAR(created_time, 'YYYY-MM-DD')as created_time, view_count "
				+ "from notice_board "
				+ "order by view_count desc";
		try {
			conn = dbCon.getDbConn();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				noticeDTO nDTO = new noticeDTO();
				nDTO.setBoard_code_name(rs.getString("board_code_name"));
				nDTO.setNotice_board_idx(rs.getInt("notice_board_idx"));
				nDTO.setNotice_title(rs.getString("notice_title"));
				nDTO.setNotice_content(rs.getString("notice_content"));
				nDTO.setCreated_time(rs.getString("created_time"));
				nDTO.setView_count(rs.getInt("view_count"));
				
				noticeList.add(nDTO);
			}
		}finally {
			dbCon.dbClose(rs, pstmt, conn);
		}
		return noticeList;
	}
	
	public noticeDTO selectNotice(String num) throws SQLException {
		noticeDTO nDTO = null;
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		String sql = "select notice_board_idx,board_code_name,notice_title,notice_content, TO_CHAR(created_time, 'YYYY-MM-DD')as created_time, view_count "
				+ "from notice_board "
				+ "where notice_board_idx=? "
				+ "order by notice_board_idx";
		try {
			conn = dbCon.getDbConn();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, num);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				nDTO = new noticeDTO();
				nDTO.setBoard_code_name(rs.getString("board_code_name"));
				nDTO.setNotice_board_idx(rs.getInt("notice_board_idx"));
				nDTO.setNotice_title(rs.getString("notice_title"));
				nDTO.setNotice_content(rs.getString("notice_content"));
				nDTO.setCreated_time(rs.getString("created_time"));
				nDTO.setView_count(rs.getInt("view_count"));
			}
		}finally {
			dbCon.dbClose(rs, pstmt, conn);
		}
		return nDTO;
	}
	

	
	
	public List<noticeDTO> selectNoticeType(String type) throws SQLException {
		List<noticeDTO> noticeList = new ArrayList<noticeDTO>();
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		String 	sql = "select notice_board_idx,board_code_name,notice_title,notice_content, TO_CHAR(created_time, 'YYYY-MM-DD')as created_time "
				+ "from notice_board "
				+ "where board_code_name=? "
				+ "order by notice_board_idx";
		try {
			conn = dbCon.getDbConn();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, type);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				noticeDTO nDTO = new noticeDTO();
				nDTO.setBoard_code_name(rs.getString("board_code_name"));
				nDTO.setNotice_board_idx(rs.getInt("notice_board_idx"));
				nDTO.setNotice_title(rs.getString("notice_title"));
				nDTO.setNotice_content(rs.getString("notice_content"));
				nDTO.setCreated_time(rs.getString("created_time"));
				noticeList.add(nDTO);
			}
		}finally {
			dbCon.dbClose(rs, pstmt, conn);
		}
		return noticeList;
	}
	
	public void insertNotice(String type,String title,String content) throws SQLException {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = "INSERT INTO notice_board(notice_board_idx,board_code_name, notice_title, notice_content, created_time,view_count,admin_id) VALUES (notice_board_idx_seq.nextval,?, ?, ?,current_timestamp,0,'temp')";
	    try {
			conn = dbCon.getDbConn();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, type);  // 인덱스는 1부터 시작
	        pstmt.setString(2, title);
	        pstmt.setString(3, content);
	        pstmt.executeUpdate(); // INSERT는 executeUpdate()
	    } finally {
	        dbCon.dbClose(rs,pstmt, conn);
	    }
	}

	
	public void deleteNotice(String num) throws SQLException {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		String sql = "delete from notice_board where notice_board_idx=?";
		try {
			conn = dbCon.getDbConn();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, num);
			pstmt.executeUpdate();
		}finally {
			dbCon.dbClose(rs, pstmt, conn);
		}
	}
	
	public void alternotice(String num, String content) throws SQLException {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = "update notice_board set notice_content=? where notice_board_idx=? ";
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
	
	
	public void addcount(String idx) throws SQLException {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = "UPDATE notice_board SET view_count = NVL(view_count, 0) + 1 WHERE notice_board_idx = ?";
	    try {
			conn = dbCon.getDbConn();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, idx);
	        pstmt.executeUpdate();
	    } finally {
	        dbCon.dbClose(rs, pstmt, conn);
	    }
	}
	
	public List<noticeDTO> searchNotice(String keyword) throws SQLException {
	    List<noticeDTO> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = "SELECT notice_board_idx, board_code_name, notice_title, notice_content, TO_CHAR(created_time, 'YYYY-MM-DD') AS created_time, view_count "
	               + "FROM notice_board WHERE notice_title LIKE ? ORDER BY view_count desc";
	    try {
	    	conn = dbCon.getDbConn();
	        pstmt = conn.prepareStatement(sql); 
	        pstmt.setString(1, "%" + keyword + "%");
			rs = pstmt.executeQuery();
	        while (rs.next()) {
	            noticeDTO dto = new noticeDTO();
	            dto.setNotice_board_idx(rs.getInt("notice_board_idx"));
	            dto.setBoard_code_name(rs.getString("board_code_name"));
	            dto.setNotice_title(rs.getString("notice_title"));
	            dto.setNotice_content(rs.getString("notice_content"));
	            dto.setCreated_time(rs.getString("created_time"));
	            dto.setView_count(rs.getInt("view_count"));
	            list.add(dto);
	            }
	    }finally {
	        dbCon.dbClose(rs, pstmt, conn);
	    }
	    return list;
	}
	
	public int getNoticeCount(String type) throws SQLException {
	    int count = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = "SELECT COUNT(*) FROM notice_board ";
	    if(type != null && !type.equals("전체")) {
	    	sql+="where board_code_name=?";
	    }
	    try {
	    	conn = dbCon.getDbConn();
	        pstmt = conn.prepareStatement(sql);
	        if(type != null && !type.equals("전체")) {
		    	pstmt.setString(1, type);
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
	

	public List<noticeDTO> selectPaged( int page, int size) throws SQLException {
	    List<noticeDTO> list = new ArrayList<>();
	    int start = (page - 1) * size + 1; // 시작 row 번호
	    int end = page * size;            // 끝 row 번호

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql = 
	        "SELECT ROWNUM rnum, notice_board_idx,board_code_name,notice_title,notice_content, TO_CHAR(created_time, 'YYYY-MM-DD')as created_time, view_count FROM (" +
	        "    SELECT ROWNUM rnum, a.* FROM (" +
	        "        SELECT * FROM notice_board ORDER BY notice_board_idx DESC" +
	        "    ) a WHERE ROWNUM <= ?" +
	        ") WHERE rnum >= ?";

	    try {
	        conn = dbCon.getDbConn();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, end);   // 상위 N개까지
	        pstmt.setInt(2, start); // 시작 위치

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	noticeDTO nDTO = new noticeDTO();
				nDTO.setBoard_code_name(rs.getString("board_code_name"));
				nDTO.setNotice_board_idx(rs.getInt("notice_board_idx"));
				nDTO.setNotice_title(rs.getString("notice_title"));
				nDTO.setNotice_content(rs.getString("notice_content"));
				nDTO.setCreated_time(rs.getString("created_time"));
				nDTO.setView_count(rs.getInt("view_count"));
				
	            // 필요한 항목 추가
	            list.add(nDTO);
	        }
	    } finally {
	        dbCon.dbClose(rs, pstmt, conn);
	    }

	    return list;
	}
	
	public List<noticeDTO> selectPagedType(String type, int page, int size) throws SQLException {
	    List<noticeDTO> list = new ArrayList<>();
	    int start = (page - 1) * size + 1;
	    int end = page * size;

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    StringBuilder sql = new StringBuilder();
	    sql.append("SELECT ROWNUM rnum, notice_board_idx,board_code_name,notice_title,notice_content, TO_CHAR(created_time, 'YYYY-MM-DD')as created_time, view_count FROM ( ");
	    sql.append("    SELECT ROWNUM rnum, a.* FROM ( ");
	    sql.append("        SELECT * FROM notice_board ");

	    // 조건이 있을 때만 WHERE 절 추가
	    if (type != null && !type.equals("전체")) {
	        sql.append("WHERE board_code_name = ? ");
	    }

	    sql.append("        ORDER BY notice_board_idx DESC ");
	    sql.append("    ) a WHERE ROWNUM <= ? ");
	    sql.append(") WHERE rnum >= ? ");

	    try {
	        conn = dbCon.getDbConn();
	        pstmt = conn.prepareStatement(sql.toString());

	        int paramIndex = 1;

	        // 조건이 있을 경우 먼저 세팅
	        if (type != null && !type.equals("전체")) {
	            pstmt.setString(paramIndex++, type);
	        }

	        pstmt.setInt(paramIndex++, end);   // ROWNUM <= ?
	        pstmt.setInt(paramIndex, start);   // rnum >= ?

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            noticeDTO nDTO = new noticeDTO();
	            nDTO.setBoard_code_name(rs.getString("board_code_name"));
	            nDTO.setNotice_board_idx(rs.getInt("notice_board_idx"));
	            nDTO.setNotice_title(rs.getString("notice_title"));
	            nDTO.setNotice_content(rs.getString("notice_content"));
	            nDTO.setCreated_time(rs.getString("created_time"));
	            nDTO.setView_count(rs.getInt("view_count"));
	            list.add(nDTO);
	        }
	    } finally {
	        dbCon.dbClose(rs, pstmt, conn);
	    }

	    return list;
	}


	
}
