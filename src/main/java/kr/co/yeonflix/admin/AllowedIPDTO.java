package kr.co.yeonflix.admin;

import java.time.LocalDateTime;

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
	
}
