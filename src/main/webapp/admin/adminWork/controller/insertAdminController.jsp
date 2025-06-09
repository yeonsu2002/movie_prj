<%@page import="kr.co.yeonflix.admin.AdminService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.yeonflix.admin.AllowedIPDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.member.Role"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="kr.co.yeonflix.admin.AdminDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%

//어드민 객체 생성 
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
	savePath = "C:\\dev\\movie\\userProfiles";
} else if ("macOS".equals(platform)){
	savePath = "/Users/smk/Downloads/학원프로젝트/2차프로젝트/profiles";
	//	/Users/smk/Downloads/학원프로젝트/2차프로젝트/profiles
}


File saveDir = new File(savePath);

if (!saveDir.exists()) {
  boolean created = saveDir.mkdirs(); // 디렉토리 생성
  //System.out.println("디렉토리 생성 결과: " + created + ", 경로: " + savePath);
}

if(ServletFileUpload.isMultipartContent(request)){ //multi라면?
		
	try{
		multi = new MultipartRequest(request, savePath, fileMaxSize,  "UTF-8", new DefaultFileRenamePolicy());
	} catch (Exception e) {
		e.printStackTrace();
		out.println("<script>alert('form처리중 오류 발생'); history.back(); </script>");
		return; //에러발생 -> 처리중단
	}

	
	String adminId = multi.getParameter("adminId");
	String adminLevel = "MANAGER"; //고정값 
	String adminPwd = multi.getParameter("adminPwd");
	String adminName = multi.getParameter("adminName");
	String adminEmail = multi.getParameter("adminEmail");
	String tel = multi.getParameter("phone");
	String manageArea = multi.getParameter("manageArea");
	LocalDateTime lastLoginDate = LocalDateTime.now();
	String isActive = "Y";
	String managerIp = request.getRemoteAddr();
	
	
	adminDTO.setAdminId(adminId);
	adminDTO.setAdminLevel(adminLevel);
	adminDTO.setAdminPwd(adminPwd);
	adminDTO.setAdminName(adminName);
	adminDTO.setAdminEmail(adminEmail);
	adminDTO.setTel(tel);
	adminDTO.setManageArea(manageArea);
	adminDTO.setLastLoginDate(lastLoginDate);
	adminDTO.setIsActive(isActive);
	
	adminDTO.setRole(Role.ROLE_MANAGER);
	
	AllowedIPDTO managerIpVO = new AllowedIPDTO();
	managerIpVO.setAdminId(adminId);
	managerIpVO.setIpAddress(managerIp);
	managerIpVO.setCreatedAt(LocalDateTime.now());
	
	List<AllowedIPDTO> list = new ArrayList<AllowedIPDTO>();
	list.add(managerIpVO);
	adminDTO.setIPList(list);
	
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
	//System.out.println("업로드된 파일 경로: " + profileFile.getAbsolutePath());
	
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
boolean result = adminService.joinAdmin(adminDTO);

if(result){
	out.println("<script>alert('매니저 추가작업이 정상적으로 처리되었습니다.'); setTimeout(function(){ location.replace('" + request.getContextPath() + "/admin/adminWork/controller/getAdminWorkController.jsp'); }, 100);</script>");
} else {
	out.println("<script>alert('매니저 가입에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
}

%>