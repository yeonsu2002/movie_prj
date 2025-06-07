package kr.co.yeonflix.admin;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AllowedIPDTO {

	private int allowedIpIdx;
	private String adminId;
	private String ipAddress;
	private LocalDateTime createdAt;
	
	//JSP에서 뽑을 때, 규격설정 
	public String getFormattedCreatedAt() {
	  if(createdAt == null) return"";
	  return createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	}
	
}
