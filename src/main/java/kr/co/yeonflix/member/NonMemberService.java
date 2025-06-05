package kr.co.yeonflix.member;

import java.sql.SQLException;

public class NonMemberService {
  
  private NonMemberDAO nmDAO;

  public NonMemberService() {
    this.nmDAO = NonMemberDAO.getInstance();
  }

//----------------------------------------------------------------- 
  
  //비회원 데이터 생성
  public boolean saveNonMem(String birth, String email, String pwd) throws SQLException {
    return nmDAO.insertNonMem(birth, email, pwd);
  }
  
  //비회원 데이터 호출 (userIdx, 생일, 이메일, 예매 비밀번호, 생성일 )
  public NonMemberDTO getNonMem(String email) throws SQLException {
    return nmDAO.selectNonMember(email);
  }
  
  
  
  
  
}
