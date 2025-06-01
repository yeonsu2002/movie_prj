<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%@ taglib prefix="c" uri= "http://java.sun.com/jsp/jstl/core"%>   
<%
Object obj = session.getAttribute("userData");
JSONObject jsonObj = new JSONObject();
boolean resultFlag = obj != null;
jsonObj.put("resultFlag", resultFlag);
if(resultFlag){//로그인이 되어있는 상태
	//파일 업로드 수행
	File saveDir = new File("C:/dev/workspace/movie_prj/src/main/webapp/common/");
	int maxSize = 1024 * 1024 * 10;
		
	MultipartRequest mr = new MultipartRequest(request,saveDir.getAbsolutePath(), maxSize, "UTF-8", new DefaultFileRenamePolicy());
	String fileName = mr.getFilesystemName("profileImg");
	jsonObj.put("fileName", fileName);
}//end if
out.print(jsonObj.toJSONString());//{ resultFlag: true, fileName: "파일명" }
%>