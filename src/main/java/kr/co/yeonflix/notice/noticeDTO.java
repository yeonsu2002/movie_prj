package kr.co.yeonflix.notice;

import java.sql.Time;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class noticeDTO {
	private int notice_board_idx;
	private String board_code_name;
	private String admin_id;
	private String notice_title;
	private String notice_content;
	private String created_time;
	private int view_count;
}
