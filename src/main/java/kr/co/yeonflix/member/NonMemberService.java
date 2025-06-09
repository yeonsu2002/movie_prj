package kr.co.yeonflix.member;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;

import javax.swing.text.DateFormatter;

import at.favre.lib.crypto.bcrypt.BCrypt;

public class NonMemberService {
  
  private NonMemberDAO nmDAO;

  public NonMemberService() {
    this.nmDAO = NonMemberDAO.getInstance();
  }

//----------------------------------------------------------------- 
  
  //비회원 데이터 생성
  public boolean saveNonMem(String birth, String email, String pwd) throws SQLException {
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyyMMdd"); //받아오는게 20010101 식임 
    LocalDate birthDate = LocalDate.parse(birth, dtf);
    String encodedPwd = BCrypt.withDefaults().hashToString(12, pwd.toCharArray());
    return nmDAO.insertNonMem(birthDate, email, encodedPwd);
  }
  
  //비회원 데이터 호출 (userIdx, 생일, 이메일, 예매 비밀번호, 생성일 )
  public NonMemberDTO getNonMem(String birth, String email) throws SQLException {
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyyMMdd");
    LocalDate birthDate = LocalDate.parse(birth, dtf);
    return nmDAO.selectNonMember(birthDate, email);
  }
  
  //비회원 예매내역 출력 (생일, 이메일)
  public List<NonMemTicketDTO> getNmtDTOlist(String birth, String email, String password) throws SQLException{
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyyMMdd");
    LocalDate birthDate = LocalDate.parse(birth, dtf);
    //String encodedPwd = BCrypt.withDefaults().hashToString(12, password.toCharArray());
    return nmDAO.selectNonMemTicketList(birthDate, email, password);
  }
  
  
  
  
  
}
