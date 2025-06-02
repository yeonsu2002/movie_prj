package kr.co.yeonflix.member;

public class NonMemberService {
  
  private NonMemberDAO nmDAO;

  public NonMemberService() {
    this.nmDAO = NonMemberDAO.getInstance();
  }

//----------------------------------------------------------------- 
  
  public NonMemberDTO saveNonMem(String birth, String email, String pwd) {
    return nmDAO.insertNonMem(birth, email, pwd);
  }
  
  
  
  
}
