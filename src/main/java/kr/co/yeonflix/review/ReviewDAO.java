package kr.co.yeonflix.review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;
import kr.co.yeonflix.movie.MovieDTO;

public class ReviewDAO {
    private static ReviewDAO rDAO;

    ReviewDAO() {}

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
        ResultSet rs = null;

        int movieIdx = -1;
        
        try {
            con = db.getDbConn();
            String sql = "INSERT INTO REVIEW_MOVIE (REVIEW_IDX, USER_IDX, MOVIE_IDX, MOVIE_NAME, REVIEW_CONTENTS, RATING, WRITE_DATE) "
                       + "VALUES (REVIEW_IDX_seq.NEXTVAL, ?, ?, ?, ?, ?, SYSDATE)";

            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, rDTO.getUserId());     // USER_IDX (작성자)
            pstmt.setInt(2, rDTO.getMovieId());    // MOVIE_IDX (영화 ID)
            pstmt.setString(3, rDTO.getMovieName()); //MOVIE_NAME (영화제목)
            pstmt.setString(4, rDTO.getContent()); // REVIEW_CONTENTS (내용)
            pstmt.setDouble(5, rDTO.getRating());  // RATING (평점)
            
            movieIdx = rDTO.getMovieId();
            
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
        ResultSet rs2 = null;

        try {
            con = db.getDbConn();
            String sql = "SELECT REVIEW_IDX, USER_IDX, MOVIE_IDX, REVIEW_CONTENTS, WRITE_DATE, RATING "
                    + "FROM REVIEW_MOVIE "
                    + "WHERE MOVIE_IDX = ? "
                    + "ORDER BY WRITE_DATE DESC";
            
            String getUserNameQuery = "	SELECT nick_name FROM member WHERE user_idx = ? 	";

            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(movieId));

            rs = pstmt.executeQuery();
            while (rs.next()) {
            	int userIdx = rs.getInt("USER_IDX");
            	
                ReviewDTO rDTO = new ReviewDTO();
                rDTO.setReviewId(rs.getInt("REVIEW_IDX"));
                rDTO.setUserId(rs.getInt("USER_IDX"));
                rDTO.setMovieId(rs.getInt("MOVIE_IDX"));
                rDTO.setContent(rs.getString("REVIEW_CONTENTS"));
                rDTO.setRating(rs.getDouble("RATING"));
                rDTO.setWriteDate(rs.getDate("WRITE_DATE"));
                
                
                try(PreparedStatement pstmt2 = con.prepareStatement(getUserNameQuery)){
                	pstmt2.setInt(1, userIdx);
                	
                	rs2 = pstmt2.executeQuery();
                	if(rs2.next()) {
                	 rDTO.setUserLoginId(rs2.getString("nick_name"));
                	}
                }
                
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
        	String sql = "SELECT \"REVIEW_IDX\", \"USER_IDX\", \"MOVIE_NAME\","
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
 // 리뷰 수정
    public int updateReview(ReviewDTO rDTO) throws SQLException {
        DbConnection db = DbConnection.getInstance();
        Connection con = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            con = db.getDbConn();
            String sql = "UPDATE REVIEW_MOVIE SET REVIEW_CONTENTS = ?, RATING = ?, WRITE_DATE = SYSDATE WHERE REVIEW_IDX = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, rDTO.getContent());
            pstmt.setDouble(2, rDTO.getRating());
            pstmt.setInt(3, rDTO.getReviewId());

            result = pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }

        return result;
    }
    public List<ReviewDTO> selectReviewsByUserId(int userId) throws SQLException {
        List<ReviewDTO> list = new ArrayList<>();
        DbConnection db = DbConnection.getInstance();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = db.getDbConn();
            String sql = "SELECT REVIEW_IDX, MOVIE_IDX, REVIEW_CONTENTS, RATING, WRITE_DATE,MOVIE_NAME "
                       + "FROM REVIEW_MOVIE WHERE USER_IDX = ? ORDER BY WRITE_DATE DESC";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                ReviewDTO dto = new ReviewDTO();
                dto.setReviewId(rs.getInt("REVIEW_IDX"));
                dto.setUserId(userId);
                dto.setMovieId(rs.getInt("MOVIE_IDX"));
                dto.setContent(rs.getString("REVIEW_CONTENTS"));
                dto.setRating(rs.getDouble("RATING"));
                dto.setWriteDate(rs.getDate("WRITE_DATE"));
                dto.setMovieName(rs.getString("MOVIE_NAME"));
                list.add(dto);
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }

        return list;
    }

    public boolean hasUserReviewedMovie(int userId, int movieId) throws SQLException {
        DbConnection db = DbConnection.getInstance();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean result = false;

        try {
            con = db.getDbConn();
            String sql = "SELECT COUNT(*) FROM REVIEW_MOVIE WHERE USER_IDX = ? AND MOVIE_IDX = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, movieId);

            rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                result = true;
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }

        return result;
    }
    
    public ReviewDTO selectReviewById(int reviewId) {
        ReviewDTO dto = null;
        String sql = "SELECT * FROM review WHERE review_id = ?";

        try (Connection con = DbConnection.getInstance().getDbConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, reviewId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dto = new ReviewDTO();
                    dto.setReviewId(rs.getInt("review_id"));
                    dto.setMovieId(rs.getInt("movie_id"));
                    dto.setUserLoginId(rs.getString("user_login_id"));
                    dto.setRating(rs.getDouble("rating"));
                    dto.setContent(rs.getString("content"));
                    dto.setWriteDate(rs.getDate("writeDate"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return dto;
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

    public List<ReviewDTO> selectMyReview(int userIdx) throws SQLException {
        DbConnection db = DbConnection.getInstance();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<ReviewDTO> reviewList = new ArrayList<>();
        
        try {
            con = db.getDbConn();
            
            // SQL 쿼리
            String sql = "SELECT m.MOVIE_NAME, m.POSTER_PATH, " +
                         "r.RATING, r.REVIEW_CONTENTS, r.WRITE_DATE " +
                         "FROM review_movie r " +
                         "JOIN movie m ON r.MOVIE_IDX = m.MOVIE_IDX " +
                         "WHERE r.USER_IDX = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userIdx);
            rs = pstmt.executeQuery();
            
            // 결과 처리
            while (rs.next()) {
                String movieName = rs.getString("MOVIE_NAME");
                String posterPath = rs.getString("POSTER_PATH");
                
                // MovieDTO 객체 생성 및 데이터 설정
                MovieDTO movieDTO = new MovieDTO();
                movieDTO.setMovieName(movieName);
                movieDTO.setPosterPath(posterPath);
                
                // ReviewDTO 객체 생성 및 데이터 설정
                ReviewDTO reviewDTO = new ReviewDTO();
                reviewDTO.setRating(rs.getDouble("RATING"));
                reviewDTO.setContent(rs.getString("REVIEW_CONTENTS"));
                reviewDTO.setWriteDate(rs.getDate("WRITE_DATE"));
                
                // MovieDTO 객체를 ReviewDTO에 설정
                reviewDTO.setMovieDTO(movieDTO);  // 여기에서 movieDTO를 ReviewDTO에 할당해주는 코드 확인
                
                
                // List에 추가
                reviewList.add(reviewDTO);
            }

        } finally {
            db.dbClose(rs, pstmt, con);
        }
        
        return reviewList;
    }

}