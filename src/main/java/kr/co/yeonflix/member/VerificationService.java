package kr.co.yeonflix.member;

import java.sql.SQLException;
import java.time.LocalDateTime;

public class VerificationService {

  private VerificationDAO vDAO;
  
  public VerificationService() {
    this.vDAO = VerificationDAO.getInstance();
  }
  
  //인증번호 받기 버튼 클릭 -> 인증번호 테이블 생성 
  public boolean makeVirifiCode(String email, String verificationCode) {
    boolean isSuccess = false;
    
    LocalDateTime createdAt = LocalDateTime.now();
    LocalDateTime expireAt = createdAt.plusMinutes(5); //5분추가 
    
    try {
      isSuccess = vDAO.insertVerifiCode(email, verificationCode, createdAt, expireAt);
    } catch (SQLException e) {
      e.printStackTrace();
    }
    
    return isSuccess;
  }
  
  
  
  
  
}
