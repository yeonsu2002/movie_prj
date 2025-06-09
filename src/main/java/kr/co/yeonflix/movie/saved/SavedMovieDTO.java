package kr.co.yeonflix.movie.saved;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SavedMovieDTO {
	
	private int savedMovieIdx;
	private int userIdx;
	private int movieIdx;
	private String movieName;
	private String posterPath;  
	private Date releaseDate;
	private int runningTime;
}
