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
public class MemberDTO {
  private int userIdx;
  private String memberId; 
  private String memberPwd; 
  private String nickName; 
  private String userName; 
  private LocalDate birth; 
  private String tel; 
  private String isSmsAgreed;
  private String email; 
  private String isEmailAgreed; 
  private LocalDateTime createdAt; 
  private String isActive; 
  private String picture; 
  private String memberIp;
  private String hasTempPwd;
 
  private Enum<Role> role;
  
  
  public Date getCreatedAtAsDate() {
	    if (createdAt == null) return null;
	    return Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
	}
  
  
}

