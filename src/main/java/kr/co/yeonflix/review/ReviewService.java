package kr.co.yeonflix.review;

import java.sql.SQLException;
import java.util.List;

public class ReviewService {

    public boolean addReview(ReviewDTO rDTO) {
        boolean flag = false;
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

}
