package kr.co.yeonflix.review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;

public class ReviewDAO {
    private static ReviewDAO rDAO;

    private ReviewDAO() {}

    public static ReviewDAO getInstance() {
        if (rDAO == null) {
            rDAO = new ReviewDAO();
        }
        return rDAO;
    }

    // 리뷰 등록
    public void insertReview(ReviewDTO rDTO) throws SQLException {
        DbConnection db = DbConnection.getInstance();
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = db.getDbConn();
            String sql = "INSERT INTO REVIEW_MOVIE (REVIEW_IDX, USER_IDX, MOVIE_IDX, REVIEW_CONTENTS, RATING, WRITE_DATE) "
                       + "VALUES (REVIEW_IDX_seq.NEXTVAL, ?, ?, ?, ?, SYSDATE)";

            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, rDTO.getUserId());     // USER_IDX (작성자)
            pstmt.setInt(2, rDTO.getMovieId());    // MOVIE_IDX (영화 ID)
            pstmt.setString(3, rDTO.getContent()); // REVIEW_CONTENTS (내용)
            pstmt.setDouble(4, rDTO.getRating());  // RATING (평점)
            
            pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }
    }

    // 특정 영화에 대한 리뷰 조회
    public List<ReviewDTO> selectReviewsByMovieId(String movieId) throws SQLException {
        List<ReviewDTO> list = new ArrayList<>();

        if (movieId == null || movieId.trim().isEmpty()) {
            System.out.println("movieId가 null 또는 비어 있습니다.");
            return list; // 빈 리스트 반환
        }
        
        DbConnection db = DbConnection.getInstance();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = db.getDbConn();
            String sql = "SELECT REVIEW_IDX, USER_IDX, MOVIE_IDX, REVIEW_CONTENTS, WRITE_DATE, RATING "
                    + "FROM REVIEW_MOVIE "
                    + "WHERE MOVIE_IDX = ? "
                    + "ORDER BY WRITE_DATE DESC";

            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(movieId));

            rs = pstmt.executeQuery();
            while (rs.next()) {
                ReviewDTO rDTO = new ReviewDTO();
                rDTO.setReviewId(rs.getInt("REVIEW_IDX"));
                rDTO.setUserId(rs.getInt("USER_IDX"));
                rDTO.setMovieId(rs.getInt("MOVIE_IDX"));
                rDTO.setContent(rs.getString("REVIEW_CONTENTS"));
                rDTO.setRating(rs.getDouble("RATING"));
                rDTO.setWriteDate(rs.getDate("WRITE_DATE"));
                list.add(rDTO);
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }

        return list;
    }

    // 모든 리뷰 조회
    public List<ReviewDTO> selectAllReviews(Connection con) throws SQLException {
        List<ReviewDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
        	String sql = "SELECT \"REVIEW_IDX\", \"USER_IDX\", "
        			+ "\"MOVIE_IDX\", \"REVIEW_CONTENTS\", \"WRITE_DATE\", "
        			+ "\"RATING\" FROM \"REVIEW_MOVIE\" ORDER BY \"WRITE_DATE\" DESC";
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                ReviewDTO rDTO = new ReviewDTO();
                rDTO.setReviewId(rs.getInt("REVIEW_IDX"));
                rDTO.setUserId(rs.getInt("USER_IDX"));
                rDTO.setMovieId(rs.getInt("MOVIE_IDX"));
                rDTO.setContent(rs.getString("REVIEW_CONTENTS"));
                rDTO.setRating(rs.getDouble("RATING"));
                rDTO.setWriteDate(rs.getDate("WRITE_DATE"));
                list.add(rDTO);
            }
        } finally {
            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
        }

        return list;
    }

    // 리뷰 삭제
    public int deleteReview(int reviewId) throws SQLException {
        DbConnection db = DbConnection.getInstance();
        Connection con = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            con = db.getDbConn();
            String sql = "DELETE FROM REVIEW_MOVIE WHERE REVIEW_IDX = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, reviewId);

            result = pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }

        return result;
    }
    
    // 관리자 리뷰검색
    public List<ReviewDTO> searchReviewsByUserId(String userId) throws SQLException {
        List<ReviewDTO> list = new ArrayList<>();
        DbConnection db = DbConnection.getInstance();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = db.getDbConn();
            String sql = "SELECT \"REVIEW_IDX\", \"USER_IDX\", \"MOVIE_IDX\", "
                    + "\"REVIEW_CONTENTS\", \"WRITE_DATE\", \"RATING\" "
                    + "FROM \"REVIEW_MOVIE\" WHERE \"USER_IDX\" = ? ORDER BY \"WRITE_DATE\" DESC";

            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(userId));  // String을 int로 변환

            rs = pstmt.executeQuery();
            while (rs.next()) {
                ReviewDTO rDTO = new ReviewDTO();
                rDTO.setReviewId(rs.getInt("REVIEW_IDX"));
                rDTO.setUserId(rs.getInt("USER_IDX"));
                rDTO.setMovieId(rs.getInt("MOVIE_IDX"));
                rDTO.setContent(rs.getString("REVIEW_CONTENTS"));
                rDTO.setRating(rs.getDouble("RATING"));
                rDTO.setWriteDate(rs.getDate("WRITE_DATE"));
                // rDTO.setUserLoginId(rs.getString("USER_ID")); 이 줄 제거!
                list.add(rDTO);
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }

        return list;
    }

    // 관리자 리뷰 일괄삭제
    public int deleteReviews(List<Integer> reviewIds) throws SQLException {
        DbConnection db = DbConnection.getInstance();
        Connection con = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            con = db.getDbConn();
            String sql = "DELETE FROM REVIEW_MOVIE WHERE REVIEW_IDX = ?";
            pstmt = con.prepareStatement(sql);

            for (Integer reviewId : reviewIds) {
                pstmt.setInt(1, reviewId);
                pstmt.addBatch();
            }

            int[] batchResult = pstmt.executeBatch();
            for (int count : batchResult) {
                result += count;
            }
        } finally {
            db.dbClose(null, pstmt, con);
        }

        return result;
    }

    // 테스트용 메인 메서드
    public static void main(String[] args) {
        ReviewDAO dao = ReviewDAO.getInstance();
        DbConnection db = DbConnection.getInstance();

        Connection con = null;
        try {
            con = db.getTestConnection();
            if (con == null) {
                System.out.println("DB 연결 실패");
                return;
            }

            // 1. 연결 정보 확인
            System.out.println("=== 연결 정보 확인 ===");
            PreparedStatement pstmt1 = con.prepareStatement("SELECT USER FROM DUAL");
            ResultSet rs1 = pstmt1.executeQuery();
            if (rs1.next()) {
                System.out.println("현재 접속 계정: " + rs1.getString(1));
            }
            rs1.close();
            pstmt1.close();

            // 2. 테이블 소유자 확인
            System.out.println("\n=== 테이블 소유자 확인 ===");
            PreparedStatement pstmt2 = con.prepareStatement(
                "SELECT OWNER, TABLE_NAME FROM ALL_TABLES WHERE TABLE_NAME = 'REVIEW_MOVIE'"
            );
            ResultSet rs2 = pstmt2.executeQuery();
            while (rs2.next()) {
                System.out.println("소유자: " + rs2.getString("OWNER") + ", 테이블: " + rs2.getString("TABLE_NAME"));
            }
            rs2.close();
            pstmt2.close();

            // 3. 단순 조회 테스트
            System.out.println("\n=== 단순 조회 테스트 ===");
            try {
                PreparedStatement pstmt3 = con.prepareStatement("SELECT COUNT(*) FROM REVIEW_MOVIE");
                ResultSet rs3 = pstmt3.executeQuery();
                if (rs3.next()) {
                    System.out.println("테이블 행 개수: " + rs3.getInt(1));
                }
                rs3.close();
                pstmt3.close();
            } catch (SQLException e) {
                System.out.println("COUNT(*) 조회 실패: " + e.getMessage());
                
                // 4. 스키마 지정해서 시도
                System.out.println("\n=== 스키마 지정 조회 시도 ===");
                try {
                    PreparedStatement pstmt4 = con.prepareStatement("SELECT COUNT(*) FROM YEONFLIX.REVIEW_MOVIE");
                    ResultSet rs4 = pstmt4.executeQuery();
                    if (rs4.next()) {
                        System.out.println("YEONFLIX 스키마 테이블 행 개수: " + rs4.getInt(1));
                    }
                    rs4.close();
                    pstmt4.close();
                } catch (SQLException e2) {
                    System.out.println("YEONFLIX 스키마 조회도 실패: " + e2.getMessage());
                }
            }

            // 5. 실제 컬럼명으로 조회 시도
            System.out.println("\n=== 컬럼별 조회 테스트 ===");
            String[] columns = {"REVIEW_IDX", "USER_IDX", "MOVIE_IDX", "REVIEW_CONTENTS", "WRITE_DATE", "RATING"};
            
            for (String col : columns) {
                try {
                    PreparedStatement pstmt = con.prepareStatement("SELECT " + col + " FROM REVIEW_MOVIE WHERE ROWNUM <= 1");
                    ResultSet rs = pstmt.executeQuery();
                    System.out.println(col + ": 조회 성공");
                    rs.close();
                    pstmt.close();
                } catch (SQLException e) {
                    System.out.println(col + ": 조회 실패 - " + e.getMessage());
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }
}