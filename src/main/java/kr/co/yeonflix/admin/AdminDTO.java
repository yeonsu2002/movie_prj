package kr.co.yeonflix.admin;

import java.time.LocalDateTime;
import java.util.List;

import kr.co.yeonflix.member.Role;

public class AdminDTO {

	private String adminId;
	private int userIdx;
	private String adminLevel; //'MANAGER'
	private String adminPwd;
	private String adminName;
	private String adminEmail;
	private String manageArea;
	private LocalDateTime lastLoginDate;
	private String picture;
	private String isActive;
	private String tel;
	
	private Enum<Role> role;
	
	List<AllowedIPDTO> IPList;
	
	
}

/*	넣고 꺼내기 방법 
 * 
 * 	PreparedStatement pstmt = conn.prepareStatement("INSERT INTO table_name (created_at) VALUES (?)");
		pstmt.setObject(1, LocalDateTime.now());
		
		ResultSet rs = pstmt.executeQuery();
		LocalDateTime dateTime = rs.getObject("created_at", LocalDateTime.class);
 * */
