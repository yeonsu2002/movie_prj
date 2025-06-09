package kr.co.yeonflix.util;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RangeDTO {
	
	private String field;//검색 필드
	private String keyword;//검색 키워드
	private int currentPage = 1; //현재 페이지
	private int startNum; //시작번호
	private int endNum; //끝번호
	
	private String fieldText = "제목";
	
	
	public String getFieldName() {
		String fieldName = "movie_name";
		
		return fieldName;
	}//getFieldName
}
