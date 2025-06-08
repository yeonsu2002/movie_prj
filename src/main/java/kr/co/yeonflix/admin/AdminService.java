package kr.co.yeonflix.admin;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import at.favre.lib.crypto.bcrypt.BCrypt;

public class AdminService {

  private AdminDAO adDAO;
  
  public AdminService() {
    this.adDAO = AdminDAO.getInstance();
  }
  
  //매니저 가입  -> 나중에 try문은 컨트롤러 쪽으로 변경 
  public boolean joinAdmin(AdminDTO adminDTO) {
    boolean result = false;
    
    try {
      String orinPwd = adminDTO.getAdminPwd();
      String encodedPwd = BCrypt.withDefaults().hashToString(12, orinPwd.toCharArray());
      adminDTO.setAdminPwd(encodedPwd);
      result = adDAO.insertAdmin(adminDTO);
    } catch (Exception e) {
      e.printStackTrace();
    }
    
    return result;
  }
  
  //매니저 로그인 
  public AdminDTO adminLogin(String adminId, String adminPwd) {
	  return adDAO.selectAdminByLogin(adminId, adminPwd);
  }
  
  //관리자 목록 페이지에 매니저 불러오기
  public List<AdminDTO> getManagerList() throws Exception {
    return adDAO.selectManagerList(); // 내부에서 try-catch 안 함
  }
  
  //정보수정시 해당 매니저의 정보를 호출
  public AdminDTO getAdminInfo(String adminId) throws SQLException {
    return adDAO.selectAdminInfo(adminId);
  }
  
  //매니저 강제 탈퇴(삭제)
  public boolean deleteAdmin(String adminId) throws SQLException {
    return adDAO.deleteAdmin(adminId);
  }
  
  //매니저 수정 작업
  public boolean updateAdmin(AdminDTO adminDTO) throws SQLException {
  	//암호화
  	String encodedPwd = BCrypt.withDefaults().hashToString(12, adminDTO.getAdminPwd().toCharArray());
  	adminDTO.setAdminPwd(encodedPwd);
  	return adDAO.updateAdmin(adminDTO);
  }
  
  
  
  
}
