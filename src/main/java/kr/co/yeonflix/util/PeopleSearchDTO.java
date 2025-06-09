package kr.co.yeonflix.util;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@AllArgsConstructor
@ToString
public class PeopleSearchDTO {
	private String url, field, keyword;
}
