package kr.co.yeonflix.member;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NonMemberDTO {
 
  private int userIdx;
  private LocalDate birth;
  private String email;
  private String ticket_pwd;
  private LocalDateTime createdAt;
   
  private String userType;
  
  public Date getCreatedAtAsDate() {
	    if (createdAt == null) return null;
	    return Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
	}

  
}
