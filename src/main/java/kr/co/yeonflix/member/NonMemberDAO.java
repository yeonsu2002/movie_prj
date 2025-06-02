package kr.co.yeonflix.member;

public class NonMemberDAO {

	public static NonMemberDAO nmDAO;
	
	private NonMemberDAO() {};
	
	public static NonMemberDAO getInstance() {
		if(nmDAO == null) {
			nmDAO = new NonMemberDAO();
		}
		return nmDAO;
	}//getInstance();
	
//--------------------------------------------------------------------------------------------------------------------	

	//비회원 생성
	public NonMemberDTO insertNonMem(String birth, String email, String pwd) {
	  NonMemberDTO nmDTO = new NonMemberDTO();
	  
	  
	  return nmDTO;
	}
	
	
	
}
