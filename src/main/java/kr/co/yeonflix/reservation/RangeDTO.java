package kr.co.yeonflix.reservation;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class RangeDTO {

	private String field, keyword;
	private int currentPage=1, startNum, endNum; //현재페이지, 시작번호, 끝번호
}
