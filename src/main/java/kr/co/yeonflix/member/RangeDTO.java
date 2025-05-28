package kr.co.yeonflix.member;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

public class RangeDTO {

	private String field, keyword;//검색 필드, 키워드
	private int currentPage=1,  pageSize = 10, startNum, endNum, totalCount;//현재 페이지, 시작번호, 끝번호
	
	
	private String[] fieldText= {"아이디","닉네임"};
	
	
	public String getFieldName() {
		String fieldName="subject";
		if("1".equals(field)) {
			fieldName="content";
			
		}
		if("2".equals(field)) {
			fieldName="id";
			
		}
		
		return fieldName;
	}//getFieldName
	
	public int getStartNum() {
		return totalCount - (currentPage - 1) * pageSize;
	}
	
	public int getEndNum() {
		return Math.max(totalCount - currentPage * pageSize + 1, 1);
	}
	
	
	   public int getStartIndex() {
	        return (currentPage - 1) * pageSize;
	    }

	    // DB 쿼리에 사용할 조회 개수 (limit)
	    public int getPageSize() {
	        return pageSize;
	    }
	
}//class
