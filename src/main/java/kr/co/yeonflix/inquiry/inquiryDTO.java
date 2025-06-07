package kr.co.yeonflix.inquiry;

import java.sql.Time;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class inquiryDTO {
	private int inquiry_board_idx;
	private String board_code_name;
	private int user_idx;
	private String inquiry_title;
	private String inquiry_content;
	private String created_time;
	private String admin_id;
	private int answer_status; 
	private String answer_content; 
	private String answered_time; 
}
