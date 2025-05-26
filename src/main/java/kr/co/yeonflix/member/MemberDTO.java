package kr.co.yeonflix.member;

import java.time.LocalDate;
import java.time.LocalDateTime;

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
 
  private Enum<Role> role;
  
  
  //로그인시 호출할 회원정보(생일: 성인영화 접근, 아이피: 
  public MemberDTO(int userIdx, String memberId, String memberPwd, String nickName, LocalDate birth, String email, String picture, Enum<Role> role) {
	  this.userIdx = userIdx;
	  this.memberId = memberId;
	  this.memberPwd = memberPwd;
	  this.nickName = nickName;
	  this.birth = birth;
	  this.email = email;
	  this.picture = picture;
	  this.role = role;
  }
  
}

