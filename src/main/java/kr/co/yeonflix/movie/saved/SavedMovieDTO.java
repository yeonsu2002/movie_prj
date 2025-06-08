package kr.co.yeonflix.movie.saved;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SavedMovieDTO {
	
	private int savedMovieIdx;
	private int userIdx;
	private int movieIdx;
}
