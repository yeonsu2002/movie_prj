package kr.co.yeonflix.review;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReviewDTO {
    private int reviewId;
    private int movieId;
    private int userId;
    private String content;
    private Double rating;
    private Date writeDate;
    
    private String userLoginId; 
}