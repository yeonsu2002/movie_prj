package kr.co.yeonflix.member;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VerificationDTO {

  private int verificationIdx;
  private int userIdx;
  private String verificationCode;
  private LocalDateTime createdAt;
  private LocalDateTime expireAt;
  private String isVerified;
  private String email;
}
