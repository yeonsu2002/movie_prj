package kr.co.yeonflix.member;

public class BoardUtil {
	private BoardUtil() {
		
	}
	
	
	public static String pagination(PageNationDTO pDTO) {
	    if (pDTO == null) return "";

	    StringBuilder searchQueryString = new StringBuilder();
	    boolean hasParam = false;

	    if (pDTO.getKeyword() != null && !pDTO.getKeyword().isEmpty()) {
	        hasParam = true;
	        searchQueryString.append("&field=").append(pDTO.getField())
	                         .append("&keyword=").append(pDTO.getKeyword());
	    }

	    // 페이지 파라미터 시작을 ?로 시작해야 하므로 URL 조립할 때 체크
	    String prefix = pDTO.getUrl().contains("?") ? "&" : "?";

	    int startPage = ((pDTO.getCurrentPage() - 1) / pDTO.getPageNumber()) * pDTO.getPageNumber() + 1;
	    int endPage = startPage + pDTO.getPageNumber() - 1;
	    if (pDTO.getTotalPage() <= endPage) {
	        endPage = pDTO.getTotalPage();
	    }

	    int movePage = 0;

	    // 이전 페이지로 이동할 경우
	    StringBuilder prevMark = new StringBuilder("  <span class='pagePrevMark '> &lt;&lt;</span> ");
	    if (pDTO.getCurrentPage() > 1) {
	        movePage = pDTO.getCurrentPage() - 1; // 현재 페이지 - 1
	        prevMark = new StringBuilder(" <a href='")
	                .append(pDTO.getUrl()).append(prefix).append("currentPage=").append(movePage)
	                .append(searchQueryString).append("' class='pagePrevMark '>&lt;&lt;</a> ");
	    }

	    // 페이지 링크
	    movePage = startPage;
	    StringBuilder pageLink = new StringBuilder();
	    while (movePage <= endPage) {
	        if (movePage == pDTO.getCurrentPage()) {
	            pageLink.append(" <span class='pageCurrent'>").append(movePage).append("</span> ");
	        } else {
	            pageLink.append(" <a href='").append(pDTO.getUrl()).append(prefix)
	                    .append("currentPage=").append(movePage).append(searchQueryString)
	                    .append("' class='pageNotCurrent'>").append(movePage).append("</a> ");
	        }
	        movePage++;
	    }

	    // 다음 페이지로 이동할 경우
	    StringBuilder nextMark = new StringBuilder(" <span class='pageNextMark '>&gt;&gt;</span> ");
	    if (pDTO.getCurrentPage() < pDTO.getTotalPage()) { // 현재 페이지가 마지막 페이지보다 작을 때
	        movePage = pDTO.getCurrentPage() + 1; // 현재 페이지 + 1
	        nextMark = new StringBuilder(" <a href='").append(pDTO.getUrl()).append(prefix)
	                .append("currentPage=").append(movePage).append(searchQueryString)
	                .append("' class='pageNextMark'>&gt;&gt;</a> ");
	    }

	    return prevMark.toString() + pageLink.toString() + nextMark.toString();
	}


}
