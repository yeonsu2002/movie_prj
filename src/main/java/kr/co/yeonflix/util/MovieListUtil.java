package kr.co.yeonflix.util;

public class MovieListUtil {

	private MovieListUtil() {
		
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
	   public static String pagination(PaginationDTO pDTO) {
	      
	      StringBuilder searchQueryString=new StringBuilder();
	      if( pDTO.getKeyword() !=null && !pDTO.getKeyword().isEmpty()){
	         searchQueryString.append("&field=").append(pDTO.getField())
	         .append("&keyword=").append(pDTO.getKeyword());
	      }//end if
	      
	      //1.한화면에 보여줄 페이지 인덱스의 수
	      //int pageNumber=3;
	      //2.화면에 보여줄 시작페이지 번호
	      int startPage=((pDTO.getCurrentPage()-1)/pDTO.getPageNumber())*pDTO.getPageNumber()+1;//1,2,3=>1
	      //3.화면에 보여줄 마지막 페이지 번호
	      int endPage=((startPage-1)+pDTO.getPageNumber())/pDTO.getPageNumber()*pDTO.getPageNumber();
	      //4.총 페이지 수가 연산된 마지막 페이지 수보다 작다면 총 페이지수가 마지막 페이지수로 설정
	      if(pDTO.getTotalPage() <= endPage){
	         endPage=pDTO.getTotalPage();
	      }//end if

	      //5.첫 페이지가 인덱스 화면이 아닌 경우
	      int movePage=0;
	      StringBuilder prevMark=new StringBuilder("[<span class='pagiPrevMark'>&lt&lt;]</span>");
	      if( pDTO.getCurrentPage() > pDTO.getPageNumber()){//시작페이지보다 1적은 페이지로 이동
	            prevMark.delete(0,prevMark.length());
	           movePage=startPage-1;
	           prevMark.append("[<a href='").append(pDTO.getUrl()).append("?currentPage=")
	           .append(movePage).append(searchQueryString.toString())
	           .append("' class='prevMark'>&lt;&lt;</a>]");
	      }//end if
	      
	      
	      //6.시작페이지 번호부터 끝 페이지 번호까지 화면에 출력
	      movePage=startPage;
	      StringBuilder pageLink=new StringBuilder();
	      while(movePage <= endPage){//
	         if(movePage == pDTO.getCurrentPage()){//현재 페이지는 링크를 설정하지 않음.
	            pageLink.append("[ <span class='pagiCurrent'>").append(pDTO.getCurrentPage()).append("]");
	         }else{
	            pageLink.append("[<a href='movie_list.jsp?currentPage=")
	            .append(movePage).append(searchQueryString.toString())
	              .append("' class='pagiNotCurrent'>").append(movePage).append("</a> ]");
	         }//end else
	            movePage++;
	      }//end while
	      
	      
	         
	      //7.뒤에 페이지가 더 있는 경우
	      StringBuilder nextMark=new StringBuilder("[<span class='pagiPrevMark'>&gt;&gt;</span>]");
	      if(pDTO.getTotalPage() > endPage){
	         nextMark.delete(0,nextMark.length());
	         movePage=endPage+1;
	         nextMark.append("[<a href='").append(pDTO.getUrl()).append("?currentPage=")
	         .append(movePage).append(searchQueryString.toString())
	           .append("'  class='pagiNextMark'>&gt;&gt;</a>]");
	         
	         
	      }//end if
	      
	      return prevMark.toString()+pageLink.toString()+nextMark.toString();
	   }//pagination
}
