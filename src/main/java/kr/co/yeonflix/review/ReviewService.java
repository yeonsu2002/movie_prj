package kr.co.yeonflix.review;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import kr.co.yeonflix.dao.DbConnection;

public class ReviewService {

    public boolean addReview(ReviewDTO rDTO) {
        boolean flag = false;
        
        System.out.println("userId = " + rDTO.getUserId());
        System.out.println("movieId = " + rDTO.getMovieId());
        System.out.println("movieName = " + rDTO.getMovieName());
        System.out.println("rating = " + rDTO.getRating());
        System.out.println("content = " + rDTO.getContent());
        
        
        ReviewDAO rDAO = ReviewDAO.getInstance();

        try {
            rDAO.insertReview(rDTO);
            flag = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return flag;
    }

    public List<ReviewDTO> getReviewsByMovie(int movieId) {
        List<ReviewDTO> list = null;
        ReviewDAO rDAO = ReviewDAO.getInstance();

        try {
            list = rDAO.selectReviewsByMovieId(String.valueOf(movieId));
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    public boolean removeReview(int reviewId) {
        boolean flag = false;
        ReviewDAO rDAO = ReviewDAO.getInstance();

        try {
            int result = rDAO.deleteReview(reviewId);
            flag = result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return flag;
    }
    public int updateReview(ReviewDTO rDTO) throws SQLException {
        return ReviewDAO.getInstance().updateReview(rDTO);
    }
    public List<ReviewDTO> getReviewsByUserId(int userId) throws SQLException {
        return ReviewDAO.getInstance().selectReviewsByUserId(userId);
    }
    public boolean hasUserReviewedMovie(int userId, int movieId) throws SQLException {
        return ReviewDAO.getInstance().hasUserReviewedMovie(userId, movieId);
    }
    public ReviewDTO getReviewById(int reviewId) {
        ReviewDAO dao = new ReviewDAO();
        return dao.selectReviewById(reviewId);
    }

    
    //관리자 리뷰검색
    public List<ReviewDTO> searchReviewsByUserId(String keyword) {
        List<ReviewDTO> list = null;
        ReviewDAO rDAO = ReviewDAO.getInstance();

        try {
            list = rDAO.searchReviewsByUserId(keyword);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    //관리자 리뷰삭제
    public boolean removeMultipleReviews(List<Integer> reviewIds) {
        boolean flag = false;
        ReviewDAO rDAO = ReviewDAO.getInstance();

        try {
            int result = rDAO.deleteReviews(reviewIds);
            flag = result == reviewIds.size(); // 전부 삭제되었을 경우에만 true
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return flag;
    }
 // 전체 리뷰 조회 (관리자용)
    public List<ReviewDTO> getAllReviews() {
        List<ReviewDTO> list = null;
        ReviewDAO rDAO = ReviewDAO.getInstance();
        Connection con = null;

        try {
            con = DbConnection.getInstance().getDbConn(); // ✅ 연결 객체 가져오기
            list = rDAO.selectAllReviews(con);            // ✅ 연결 넘기기
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close(); // ✅ 자원 반환
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return list;
    }
    public List<ReviewDTO> getReviewsMyMovie(int userIdx) throws SQLException {
        // ReviewDAO의 selectMyReview 메서드를 호출
    	ReviewDAO rDAO = ReviewDAO.getInstance();
        return rDAO.selectMyReview(userIdx);
    }
}
