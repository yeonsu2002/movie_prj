package kr.co.yeonflix.member;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RangeDTO {

    private String field, keyword; // 검색 필드, 키워드
    private int currentPage = 1, pageSize = 10, startNum, endNum, totalCount;

    // 검색 항목 텍스트 (이름, 전화번호, 이메일만)
    private String[] fieldText = {"이름", "전화번호", "이메일"};

    // 검색 컬럼명 매핑
    public String getFieldName() {
        String fieldName = "user_name";  // 기본값 유지

        if ("1".equals(field)) {
            fieldName = "tel";
        } else if ("2".equals(field)) {
            fieldName = "email";
        }

        return fieldName;
    }
    
    
    
    // 시작 번호 (페이지 하단 번호 계산용)
    public int getStartNum() {
        return totalCount - (currentPage - 1) * pageSize;
    }

    // 끝 번호 (페이지 하단 번호 계산용)
    public int getEndNum() {
        return Math.max(totalCount - currentPage * pageSize + 1, 1);
    }

    public int getStartIndex() {
        return (currentPage - 1) * pageSize;
    }

    // 한 페이지에 보여줄 게시물 수
    public int getPageSize() {
        return pageSize;
    }
}
