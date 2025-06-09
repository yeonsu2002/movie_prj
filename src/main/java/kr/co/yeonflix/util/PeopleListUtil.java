package kr.co.yeonflix.util;

public class PeopleListUtil {

	private PeopleListUtil() {
		
	}
	
	 /**
	    * pageNumber -생성한 인덱스 수 [1][2][3],
	    * currentPage -사용자가 보고있는 현재페이지,
	    * totalPage -게시글의 총페이지 수
	    * url - 이동할 URL, field-검색 필드(제목, 내용, 작성자), keyword-검색키워드를 pDTO로 입력받아서<br>
	    * 쪽 번호 [&lt;&lt;] ... [1][2][3] ... [&gt;&gt;]를 생성하는 method<br>
	    * @param pDTO
	    * @return
	    */
	   public static String search(PaginationDTO pDTO) {
	      
	      StringBuilder searchQueryString=new StringBuilder();
	      if( pDTO.getKeyword() !=null && !pDTO.getKeyword().isEmpty()){
	         searchQueryString.append("&field=").append(pDTO.getField())
	         .append("&keyword=").append(pDTO.getKeyword());
	      }//end if
	      
	      return searchQueryString.toString();
	   }//pagination
}
