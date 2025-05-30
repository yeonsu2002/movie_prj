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
MultipartRequest multi = null;
int fileMaxSize = 10 * 1024 * 1024;

String savePath = "C:\\dev\\movie\\userProfiles"; //사진저장소. 

File saveDir = new File(savePath);

if (!saveDir.exists()) {
  boolean created = saveDir.mkdirs(); // 디렉토리 생성
  System.out.println("디렉토리 생성 결과: " + created + ", 경로: " + savePath);
}

if(ServletFileUpload.isMultipartContent(request)){ //multi라면?
		
	try{
		multi = new MultipartRequest(request, savePath, fileMaxSize,  "UTF-8", new DefaultFileRenamePolicy());
		System.out.println("MultipartRequest 생성 완료, 저장 경로: " + savePath);
	} catch (Exception e) {
		e.printStackTrace();
		out.println("<script>alert('form처리중 오류 발생'); history.back(); </script>");
		return; //에러발생 -> 처리중단
	}

//어드민 객체 생성 
AdminDTO adminDTO = new AdminDTO();

String adminId = multi.getParameter("adminId");
String adminLevel = "MANAGER"; //고정값 
String adminPwd = multi.getParameter("adminPwd");
String adminName = multi.getParameter("adminName");
String adminEmail = multi.getParameter("adminEmail");
String tel = multi.getParameter("phone");
String manageArea = multi.getParameter("manageArea");
LocalDateTime lastLoginDate = LocalDateTime.now();
String picture = multi.getParameter("");
String isActive = multi.getParameter("");

Enum<Role> role;

List<AllowedIPDTO> IPList;

	
	
}

//이미지 처리 
File profileFile = multi.getFile("profileImage");
String originalFileName = multi.getOriginalFileName("profileImage");
String savedFileName = multi.getFilesystemName("profileImage");

System.out.println("원본 파일명: " + originalFileName);
System.out.println("저장된 파일명: " + savedFileName);
System.out.println("프로필 파일 객체: " + profileFile);




%>