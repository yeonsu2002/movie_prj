<%@page import="kr.co.yeonflix.member.Role"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="kr.co.yeonflix.admin.AdminService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.yeonflix.admin.AllowedIPDTO"%>
<%@page import="java.util.List"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="kr.co.yeonflix.admin.AdminDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<% 
AdminDTO adminDTO = new AdminDTO();

MultipartRequest multi = null;
int fileMaxSize = 10 * 1024 * 1024;

//플랫폼에 따른 savePath 설정 (내 맥북에서 하려고)
String platform = request.getHeader("sec-ch-ua-platform");
if (platform != null) {
  platform = platform.replaceAll("\"", ""); // 큰따옴표 제거, 브라우저가 보여줄 때, 큰따음표 빼고 보여줘서 equals문에서 에러발생함  
}
String savePath = "";

if("Windows".equals(platform)){
	savePath = "C:/dev/movie/userProfiles";
} else if ("macOS".equals(platform)){
	savePath = "/Users/smk/Downloads/학원프로젝트/2차프로젝트/profiles";
}

File saveDir = new File(savePath);

if (!saveDir.exists()) {
  boolean created = saveDir.mkdirs(); // 디렉토리 생성
}

if(ServletFileUpload.isMultipartContent(request)){ //multi라면?
	
	try{
		multi = new MultipartRequest(request, savePath, fileMaxSize,  "UTF-8", new DefaultFileRenamePolicy());
	} catch (Exception e) {
		e.printStackTrace();
		out.println("<script>alert('form처리중 오류 발생'); history.back(); </script>");
		return; //에러발생 -> 처리중단
	}

//수정시 DB에 던질값: idx, id, level, pwd, name, email, phone, manageArea, isActive, ipList 
	int userIdx = Integer.parseInt( multi.getParameter("userIdx"));
	String adminId = multi.getParameter("adminId");
	String adminLevel = "MANAGER"; //고정값 
	String adminPwd = multi.getParameter("adminPwd");
	String adminName = multi.getParameter("adminName");
	String adminEmail = multi.getParameter("adminEmail");
	String tel = multi.getParameter("phone");
	String manageArea = multi.getParameter("manageArea");
	String isActive = multi.getParameter("accountStatus");
	//ip list
	List<AllowedIPDTO> list = new ArrayList<AllowedIPDTO>();
	
	for(int i = 0; i < 3; i++){
	  String ip = multi.getParameter("ipOption"+i);
	  if(!ip.isBlank() && ip != null){
	    AllowedIPDTO managerIpVO = new AllowedIPDTO();
	  	managerIpVO.setAdminId(adminId);
	  	managerIpVO.setIpAddress(ip);
	  	managerIpVO.setCreatedAt(LocalDateTime.now());
	  	
			list.add(managerIpVO);
			//System.out.println("추가된 ipDTO : " + managerIpVO);
	  } 
	}
	
	adminDTO.setIPList(list);
	
	adminDTO.setUserIdx(userIdx);
	adminDTO.setAdminId(adminId);
	adminDTO.setAdminLevel(adminLevel);
	adminDTO.setAdminPwd(adminPwd);
	adminDTO.setAdminName(adminName);
	adminDTO.setAdminEmail(adminEmail);
	adminDTO.setTel(tel);
	adminDTO.setManageArea(manageArea);
	adminDTO.setIsActive(isActive);
	
	adminDTO.setRole(Role.ROLE_MANAGER);
	
	//테스트 출력용 
	AllowedIPDTO ipDTO = new AllowedIPDTO();
	ipDTO = adminDTO.getIPList().get(0);
	String ipAddr = ipDTO.getIpAddress().toString();

}

//이미지 처리 
File profileFile = multi.getFile("profileImage");
String originalFileName = multi.getOriginalFileName("profileImage");
String savedFileName = multi.getFilesystemName("profileImage");

if(profileFile != null && profileFile.exists() && originalFileName != null && !originalFileName.trim().isEmpty()){ 
	
	String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1).toUpperCase();
	
	if(ext.equals("PNG") || ext.equals("JPG") || ext.equals("GIF") || ext.equals("JPEG")){
		// MultipartRequest가 이미 파일을 저장했으므로 savedFileName 사용
		if(savedFileName != null) {
			// URL 인코딩은 필요시에만 적용 (보통 DB 저장시에는 원본명 사용)
			adminDTO.setPicture(savedFileName);
		} else {
		  adminDTO.setPicture("default_img.png");
			System.out.println("파일 저장 실패, 기본 이미지 사용");
		}
	} else {
	  adminDTO.setPicture("default_img.png");
		System.out.println("지원하지 않는 파일 형식, 기본 이미지 사용");
	}
} else { 
  adminDTO.setPicture("default_img.png");
	System.out.println("업로드된 파일이 없음, 기본 이미지 사용");
}

// 최종 파일 확인
if(!adminDTO.getPicture().equals("default_img.png")) {
	File finalFile = new File(savePath + "/" + adminDTO.getPicture());
}
 
//서비스 호출
AdminService adminService = new AdminService();
boolean result = false;
try{
	result = adminService.updateAdmin(adminDTO);
}catch(Exception e){
  e.printStackTrace();
}

if(result){
	out.println("<script>alert('매니저 수정작업이 정상적으로 처리되었습니다.'); setTimeout(function(){ location.replace('" + request.getContextPath() + "/admin/adminWork/controller/getAdminWorkController.jsp'); }, 100);</script>");
} else {
	out.println("<script>alert('매니저 수정작업에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
}

%>
