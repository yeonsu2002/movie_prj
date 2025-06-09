package kr.co.yeonflix.movie.code;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MovieCommonCodeDTO {
	private int movieIdx, codeIdx;
	private String codeType, codeName;
}