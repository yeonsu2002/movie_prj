package kr.co.yeonflix.admin;

public class AdminDAO {

  public static AdminDAO aDAO;

  private AdminDAO() {}

  public static AdminDAO getInstance() {
    if (aDAO == null) {
      aDAO = new AdminDAO();
    }
    return aDAO;
  }

//--------------------------------------------------------------------------------------------------------------------
  
  
  
  
  
  
  
  
}
