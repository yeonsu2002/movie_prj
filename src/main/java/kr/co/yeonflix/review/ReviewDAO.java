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
            String sql = "INSERT INTO REVIEW_MOVIE (REVIEW_IDX, USER_IDX, MOVIE_IDX, REVIEW_CONTENTS) "
                       + "VALUES (REVIEW_IDX_seq.NEXTVAL, ?, ?, ? )";

            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, rDTO.getUserId());     // USER_IDX (작성자)
            pstmt.setInt(2, rDTO.getMovieId());    // MOVIE_IDX (영화 ID)
            pstmt.setString(3, rDTO.getContent());    // REVIEW_CONTENTS (내용)

            pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }
        
    }

    // 특정 영화에 대한 리뷰 조회
    public List<ReviewDTO> selectReviewsByMovieId(String movieId) throws SQLException {
        List<ReviewDTO> list = new ArrayList<>();
        DbConnection db = DbConnection.getInstance();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = db.getDbConn();
            String sql = "select review_idx, user_idx, movie_idx, review_contents, rating,  "
                       + "from review_movie "
                       + "where movie_idx = ? "
                       + "order by write_date desc";

            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(movieId));

            rs = pstmt.executeQuery();
            while (rs.next()) {
                ReviewDTO rDTO = new ReviewDTO();
                rDTO.setReviewId(rs.getInt("REVIEW_IDX"));
                rDTO.setUserId(rs.getInt("USER_IDX"));
                rDTO.setMovieId(rs.getInt("MOVIE_IDX"));
                rDTO.setContent(rs.getString("REVIEW_CONTENTS"));
                rDTO.setRating(rs.getInt("RATING"));
                list.add(rDTO);
                                
            }
        } finally {
            db.dbClose(rs, pstmt, con);
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
    
    
    //관리자 리뷰검색
    public List<ReviewDTO> searchReviewsByUserId(String keyword) throws SQLException {
        List<ReviewDTO> list = new ArrayList<>();
        DbConnection db = DbConnection.getInstance();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = db.getDbConn();
            String sql = "SELECT r.review_idx, r.user_idx, r.movie_idx, r.review_contents, r.rating " +
                         "FROM review_movie r JOIN users u ON r.user_idx = u.user_idx " +
                         "WHERE u.user_id LIKE ? " +
                         "ORDER BY r.write_date DESC";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");

            rs = pstmt.executeQuery();
            while (rs.next()) {
                ReviewDTO rDTO = new ReviewDTO();
                rDTO.setReviewId(rs.getInt("REVIEW_IDX"));
                rDTO.setUserId(rs.getInt("USER_IDX"));
                rDTO.setMovieId(rs.getInt("MOVIE_IDX"));
                rDTO.setContent(rs.getString("REVIEW_CONTENTS"));
                rDTO.setRating(rs.getInt("RATING"));
                list.add(rDTO);
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }

        return list;
    }
    //관리자 리뷰삭제
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

}
