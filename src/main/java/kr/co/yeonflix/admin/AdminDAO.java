package kr.co.yeonflix.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import at.favre.lib.crypto.bcrypt.BCrypt;
import kr.co.yeonflix.dao.DbConnection;
import kr.co.yeonflix.member.Role;

public class AdminDAO {

	public static AdminDAO aDAO;

	private AdminDAO() {
	}

	public static AdminDAO getInstance() {
		if (aDAO == null) {
			aDAO = new AdminDAO();
		}
		return aDAO;
	}

//--------------------------------------------------------------------------------------------------------------------
/** 
 * 끊는거 잊지마 
 * Connection = DB 커넥션 자원 점유
 * PreparedStatement = DB에 보내는 통신 자원
 * ResultSet = DB로부터 받은 결과 버퍼
 */
	//관리자 로그인 
	public AdminDTO selectAdminByLogin(String adminId, String adminPwd) {
	
		AdminDTO adminDTO = null;
		List<AllowedIPDTO> IPList = new ArrayList<AllowedIPDTO>();
		
		DbConnection dbCon = DbConnection.getInstance();
		Connection con = null;
		ResultSet rs = null;
		
		String getAdminInfoQuery = "	SELECT * FROM admin WHERE admin_id = ?	";
		String getRoleByuserIdxQuery = "	SELECT r.role_name FROM role r \n"
				+ "JOIN user_role_table urt On r.role_idx = urt.role_idx\n"
				+ "JOIN admin a ON a.user_idx = urt.user_idx\n"
				+ "WHERE a.user_idx = ? ";
		String getIpListQuery = "	SELECT * FROM allowed_ip WHERE admin_id = ? 	";
		
		try {
		    con = dbCon.getDbConn();

		    // 1. 아이디로 관리자 정보 조회
		    try (PreparedStatement ps = con.prepareStatement(getAdminInfoQuery)) {
		      ps.setString(1, adminId);
		      rs = ps.executeQuery();

		      if (rs.next()) {
		        String orinPwd = rs.getString("admin_pwd");
		        BCrypt.Result result = null;
		        boolean isSuperAdmin = false;
		        //슈퍼운영자는 isSupreAdmin으로만 판단. 왜? 쿼리추가하기 귀찮으니까 
		        if(rs.getInt("user_idx") == 1000000) {
		        	isSuperAdmin = true;
		        } else {
		        	result = BCrypt.verifyer().verify(adminPwd.toCharArray(), orinPwd);
		        }
		        //슈퍼운영자이거나, 비밀번호가 일치한다면 
		        if (isSuperAdmin || result.verified) {
		          adminDTO = new AdminDTO(); // 로그인 성공 시 객체 생성
		          adminDTO.setUserIdx(rs.getInt("user_idx"));
		          adminDTO.setAdminId(rs.getString("admin_id"));
		          adminDTO.setAdminPwd(orinPwd);
		          adminDTO.setAdminEmail(rs.getString("admin_email"));
		          adminDTO.setAdminName(rs.getString("admin_name"));
		          adminDTO.setAdminLevel(rs.getString("admin_level"));
		          adminDTO.setManageArea(rs.getString("manage_area"));
		          adminDTO.setLastLoginDate(rs.getTimestamp("last_login_date").toLocalDateTime());
		          adminDTO.setPicture(rs.getString("picture"));
		          adminDTO.setIsActive(rs.getString("is_active"));
		          adminDTO.setTel(rs.getString("tel"));

		          int userIdx = rs.getInt("user_idx");
		          String name = rs.getString("admin_name");

		          // 2. Role 조회
		          try (PreparedStatement psRole = con.prepareStatement(getRoleByuserIdxQuery)) {
		            psRole.setInt(1, userIdx);
		            ResultSet rsRole = psRole.executeQuery();
		            if (rsRole.next()) {
		              adminDTO.setRole(Role.valueOf(rsRole.getString("role_name")));
		            }
		          }

		          // 3. IP 목록 조회
		          try (PreparedStatement psIp = con.prepareStatement(getIpListQuery)) {
		            psIp.setString(1, adminId);
		            ResultSet rsIp = psIp.executeQuery();
		            while (rsIp.next()) {
		              AllowedIPDTO ip = new AllowedIPDTO();
		              ip.setAdminId(rsIp.getString("admin_id"));
		              ip.setAllowedIpIdx(rsIp.getInt("allowed_ip_idx"));
		              ip.setIpAddress(rsIp.getString("ip_address"));
		              ip.setCreatedAt(rsIp.getTimestamp("created_at").toLocalDateTime());
		              IPList.add(ip);
		            }
		            adminDTO.setIPList(IPList);
		          }

		        } else {
		          System.out.println("비밀번호가 틀렸습니다.");
		        }
		      } else {
		        System.out.println("해당 아이디의 관리자를 찾을 수 없습니다.");
		      }
		    }
		  } catch (Exception e) {
		    e.printStackTrace();
		  } finally {
			  try { if (rs != null) rs.close(); } catch (Exception e) {e.printStackTrace();}
			  try { if (con != null) con.close(); } catch (Exception e) {e.printStackTrace();}
		  }

		return adminDTO;
	}
	
	
	// 매니저 가입
	public boolean insertAdmin(AdminDTO adminDTO) throws SQLException {

		boolean result = false;

		DbConnection dbCon = DbConnection.getInstance();
		Connection con = null;

		String adminId = adminDTO.getAdminId();

		AllowedIPDTO ipDTO = new AllowedIPDTO();
		ipDTO = adminDTO.getIPList().get(0);
		String ipAddr = ipDTO.getIpAddress().toString();

		int userIdx = -1;
		int roleIdx = -1;

		String insertCommonUser = " INSERT INTO common_user (user_idx, user_type) VALUES (USER_IDX_SEQ.NEXTVAL, ?)  ";
		String getUserIdxQuery = " SELECT USER_IDX_SEQ.CURRVAL FROM dual  ";
		String getRoleIdxQuery = " SELECT role_idx FROM role WHERE role_name = 'ROLE_MANAGER'  ";
		String insertUserRoleTable = " INSERT INTO user_role_table (user_idx, role_idx) VALUES (?, ?)  ";
		String insertManager = " INSERT INTO admin ( user_idx, admin_id, admin_level, admin_pwd, admin_name, admin_email, manage_area, last_login_date, picture, is_active, tel) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )";
		String insertAllowedIP = " INSERT INTO allowed_ip (allowed_ip_idx, admin_id, ip_address, created_at)  "
				+ "VALUES (ALLOWED_IP_SEQ.NEXTVAL, ?, ?, ?)";

		try {
			con = dbCon.getDbConn();
			con.setAutoCommit(false); // 중간에 오류나면 다 빽해야

			// 1. common_user 데이터생성
			try (PreparedStatement ps = con.prepareStatement(insertCommonUser)) {
				ps.setString(1, "ADMIN");
				ps.executeUpdate();
			}

			// 2.user_idx 가져옴
			try (PreparedStatement ps = con.prepareStatement(getUserIdxQuery); ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					userIdx = rs.getInt(1);
				}
			}

			// 3.role_idx 가져오기
			try (PreparedStatement ps = con.prepareStatement(getRoleIdxQuery); ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					roleIdx = rs.getInt(1);
				}
			}

			// 4.user_role_table 입력
			try (PreparedStatement ps = con.prepareStatement(insertUserRoleTable)) {
				ps.setInt(1, userIdx);
				ps.setInt(2, roleIdx);
				ps.executeUpdate();
			}

			// 5.관리자(admin) 입력
			try (PreparedStatement ps = con.prepareStatement(insertManager)) {
				ps.setInt(1, userIdx);
				ps.setString(2, adminDTO.getAdminId());
				ps.setString(3, adminDTO.getAdminLevel());
				ps.setString(4, adminDTO.getAdminPwd());
				ps.setString(5, adminDTO.getAdminName());
				ps.setString(6, adminDTO.getAdminEmail());
				ps.setString(7, adminDTO.getManageArea());
				ps.setTimestamp(8, Timestamp.valueOf(adminDTO.getLastLoginDate()));
				ps.setString(9, adminDTO.getPicture());
				ps.setString(10, adminDTO.getIsActive());
				ps.setString(11, adminDTO.getTel());
				ps.executeUpdate();
			}

			// 6. allowed_ip 입력
			try (PreparedStatement ps = con.prepareStatement(insertAllowedIP)) {
				ps.setString(1, adminId);
				ps.setString(2, ipAddr);
				ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
				ps.executeUpdate();
			}

			con.commit();
			result = true;

		} catch (SQLException e) {
			if (con != null) {
				try {
					con.rollback();
				} catch (SQLException rollbackEx) {
					rollbackEx.printStackTrace();
				}
			}
			throw e;

		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return result;
	}
//------------------ 매니저 가입 완료 --------------------------------------------

	// 매니저 리스트 불러오기
	public List<AdminDTO> selectManagerList() {
		List<AdminDTO> managerList = new ArrayList<AdminDTO>();

		DbConnection dbCon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement adminPstmt = null;
		PreparedStatement ipPstmt = null;
		ResultSet rs = null;
		ResultSet rs2 = null;

		String adminId = null;

		String selectManagerAll = " SELECT * FROM admin WHERE admin_id <> 'superadmin' ";
		String selectIpList = " SELECT * FROM allowed_ip WHERE admin_id = ?  ";

		try {
			con = dbCon.getDbConn();
			adminPstmt = con.prepareStatement(selectManagerAll);
			rs = adminPstmt.executeQuery();

			while (rs.next()) {
				AdminDTO adminDTO = new AdminDTO();
				adminDTO.setAdminId(rs.getString("admin_id"));
				adminDTO.setUserIdx(rs.getInt("user_idx"));
				adminDTO.setAdminLevel(rs.getString("admin_level"));
				adminDTO.setAdminPwd(rs.getString("admin_pwd"));
				adminDTO.setAdminName(rs.getString("admin_name"));
				adminDTO.setAdminEmail(rs.getString("admin_email"));
				adminDTO.setManageArea(rs.getString("manage_area"));
				adminDTO.setIsActive(rs.getString("is_active"));
				adminDTO.setTel(rs.getString("tel"));
				adminDTO.setPicture(rs.getString("picture"));

				LocalDateTime loginDateTime = rs.getTimestamp("last_login_date").toLocalDateTime();
				adminDTO.setLastLoginDate(loginDateTime);
				DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
				String formattedDate = loginDateTime.format(dtf);
				adminDTO.setFormattedLoginDate(formattedDate);

				// IP주소 리스트 가져와서 담기
				List<AllowedIPDTO> ipList = new ArrayList<AllowedIPDTO>();
				adminId = rs.getString("admin_id");
				try {
					ipPstmt = con.prepareStatement(selectIpList);
					ipPstmt.setString(1, adminId);
					rs2 = ipPstmt.executeQuery();

					while (rs2.next()) {
						AllowedIPDTO ipDTO = new AllowedIPDTO();
						ipDTO.setAllowedIpIdx(rs2.getInt("allowed_ip_idx"));
						ipDTO.setAdminId(adminId);
						ipDTO.setIpAddress(rs2.getString("ip_address"));
						ipDTO.setCreatedAt(rs2.getTimestamp("created_at").toLocalDateTime());

						ipList.add(ipDTO);
					}

				} catch (SQLException e) {
					e.printStackTrace();
				}

				adminDTO.setIPList(ipList); // IP 주소 리스트 담기 끝

				managerList.add(adminDTO); // 반환
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				// 객체를 close()하기 전에 null상태를 학인 -> NullPointerException
				if (rs != null) {
					rs.close();
				}
				if (rs2 != null) {
					rs2.close();
				}
				if (adminPstmt != null) {
					adminPstmt.close();
				}
				if (ipPstmt != null) {
					ipPstmt.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return managerList;
	}

	// 매니저 아이디로 매니저 정보 호출
	public AdminDTO selectAdminInfo(String adminId) throws SQLException {
		DbConnection dbCon = DbConnection.getInstance();
		Connection con = null;

		String selectAdminQuery = " SELECT * FROM admin WHERE admin_id = ?  ";
		String selectIpListQuery = "  SELECT * FROM allowed_ip WHERE admin_id = ?  ";

		AdminDTO adminDTO = new AdminDTO();
		List<AllowedIPDTO> ipList = new ArrayList<AllowedIPDTO>();

		try {
			con = dbCon.getDbConn();

			try (PreparedStatement pstmt = con.prepareStatement(selectAdminQuery)) {
				pstmt.setString(1, adminId);
				ResultSet rs = pstmt.executeQuery();

				if (rs.next()) {
					adminDTO.setAdminId(rs.getString("admin_id"));
					adminDTO.setUserIdx(rs.getInt("user_idx"));
					adminDTO.setAdminLevel(rs.getString("admin_level"));
					adminDTO.setAdminPwd(rs.getString("admin_pwd"));
					adminDTO.setAdminName(rs.getString("admin_name"));
					adminDTO.setAdminEmail(rs.getString("admin_email"));
					adminDTO.setManageArea(rs.getString("manage_area"));
					adminDTO.setLastLoginDate(rs.getTimestamp("last_login_date").toLocalDateTime());
					adminDTO.setPicture(rs.getString("picture"));
					adminDTO.setIsActive(rs.getString("is_active"));
					adminDTO.setTel(rs.getString("tel"));
				} // if
			} // try

			try (PreparedStatement pstmt = con.prepareStatement(selectIpListQuery)) {
				pstmt.setString(1, adminId);
				ResultSet rs = pstmt.executeQuery();

				while (rs.next()) {
					AllowedIPDTO ipDTO = new AllowedIPDTO();
					ipDTO.setAdminId(rs.getString("admin_id"));
					ipDTO.setAllowedIpIdx(rs.getInt("allowed_ip_idx"));
					ipDTO.setIpAddress(rs.getString("ip_address"));
					ipDTO.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

					ipList.add(ipDTO);
				}
			} // try

			adminDTO.setIPList(ipList);

		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}

		return adminDTO;
	}

// 매니저 삭제 : 비활성화 
	public boolean deleteAdmin(String adminId) throws SQLException {

		DbConnection dbCon = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;

		String deleteAdminQuery = "	UPDATE admin SET is_active = 'N' WHERE admin_id = ?	";

		int result = -1;
		try {
			con = dbCon.getDbConn();

			pstmt = con.prepareStatement(deleteAdminQuery);
			pstmt.setString(1, adminId);

			result = pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);

		}
		return result > 0 ? true : false;
	}

//매니저 수정 
	public boolean updateAdmin(AdminDTO adminDTO) {
	  boolean result = false;

	  DbConnection dbCon = DbConnection.getInstance();
	  Connection con = null;

	  String adminId = adminDTO.getAdminId();
	  
	  String updateAdminBasicInfo = 
	    "UPDATE admin SET ADMIN_PWD = ?, ADMIN_NAME = ?, ADMIN_EMAIL = ?, MANAGE_AREA = ?, PICTURE = ?, IS_ACTIVE  = ?, TEL  = ? WHERE USER_IDX = ?  ";

	  String deleteOldIpList = 
	    "DELETE FROM allowed_ip WHERE ADMIN_ID = ? ";


	  String insertNewIpList = 
	    "INSERT INTO allowed_ip (ALLOWED_IP_IDX, ADMIN_ID, IP_ADDRESS, CREATED_AT) VALUES (ALLOWED_IP_SEQ.NEXTVAL, ?, ?, ? ) ";


	  try {
	    con = dbCon.getDbConn();
	    con.setAutoCommit(false); // 트랜잭션 시작

	    // 1. 운영자 기본 프로필 업뎃 
	    try (PreparedStatement ps = con.prepareStatement(updateAdminBasicInfo)) {
	      ps.setString(1, adminDTO.getAdminPwd());
	      ps.setString(2, adminDTO.getAdminName());
	      ps.setString(3, adminDTO.getAdminEmail());
	      ps.setString(4, adminDTO.getManageArea());
	      ps.setString(5, adminDTO.getPicture());
	      ps.setString(6, adminDTO.getIsActive());
	      ps.setString(7, adminDTO.getTel());
	      ps.setInt(8, adminDTO.getUserIdx());
	      
	      ps.executeUpdate();
	    }

	    // 2. 기존 IP리스트 삭제 
	    try (PreparedStatement ps = con.prepareStatement(deleteOldIpList)){
	      ps.setString(1, adminDTO.getAdminId());
	      
	      ps.executeUpdate();
	    }

	    int ipDTOCount = adminDTO.getIPList().size();
	    for(int i = 0; i < ipDTOCount; i++) {
	      // 3. 새로운 IP리스트 갱신 
	      try (PreparedStatement ps = con.prepareStatement(insertNewIpList)){
	        ps.setString(1, adminDTO.getAdminId());
	        ps.setString(2, adminDTO.getIPList().get(i).getIpAddress());
	        ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
	        
	        ps.executeUpdate();
	      }
	    }
	      
	    con.commit(); // 트랜잭션 커밋
	    result = true;

	  } catch (SQLException e) {
	    if (con != null) {
	      try {
	        con.rollback(); // 예외 발생 시 롤백
	      } catch (SQLException rollbackEx) {
	        rollbackEx.printStackTrace();
	      }
	    }
	    e.printStackTrace();
	  } finally {
	    if (con != null) {
	      try {
	        con.close();
	      } catch (SQLException e) {
	        e.printStackTrace();
	      }
	    }
	  }

	  return result;
	}


}
