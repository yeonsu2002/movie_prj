package kr.co.yeonflix.review;

import java.sql.Date;

import kr.co.yeonflix.movie.MovieDTO;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReviewDTO {
    private int reviewId;
    private int movieId;
    private String movieName;
    private int userId;
    private String content;
    private Double rating;
    private Date writeDate;
    
    private String userLoginId;

	public MovieDTO movieDTO ;
		
	 private String posterPath;
}