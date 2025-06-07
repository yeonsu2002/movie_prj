<%@page import="kr.co.yeonflix.movie.common.CommonService"%>
<%@page import="kr.co.yeonflix.movie.people.PeopleService"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
<%@page import="kr.co.yeonflix.movie.people.PeopleDTO"%>
<%@page import="kr.co.yeonflix.movie.common.CommonDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	
%>


<%
request.setCharacterEncoding("UTF-8");
//파일 업로드 수행
//File saveDir = new File("C:/dev/workspace/movie_prj/src/main/webapp/common/img");
File saveDir = new File("C:/dev/workspace/movie_prj/src/main/webapp/common/img");
int maxSize = 1024 * 1024 * 10;
	


MultipartRequest mr = new MultipartRequest(request,saveDir.getAbsolutePath(), maxSize, "UTF-8", new DefaultFileRenamePolicy());
String action = mr.getParameter("action");
String fileName = mr.getFilesystemName("posterImg");
System.out.println("fileName" + fileName);
MovieDTO mDTO = new MovieDTO();

// 파일 업로드 처리 부분
String posterPath = "default_poster.png"; // 기본값 설정

if(fileName != null) { 
    // 새로 업로드한 파일이 있는 경우
    posterPath = fileName;
} else if("update".equals(action)) {
    // 업데이트 모드이고 새 파일이 없으면 기존 값 유지
    String existingPath = mr.getParameter("posterPath");
    if(existingPath != null && !existingPath.trim().isEmpty()) {
        posterPath = existingPath.substring(existingPath.lastIndexOf("/") + 1);
    }
}

MovieService ms = new MovieService();
PeopleService ps = new PeopleService();
CommonService cs = new CommonService();
CommonDTO genre = new CommonDTO();
CommonDTO grade = new CommonDTO();
int movieIdx = Integer.parseInt(mr.getParameter("movieIdx"));

System.out.println("movieIdx : " + movieIdx);

mDTO.setMovieIdx(movieIdx);
mDTO.setMovieName(mr.getParameter("movieName"));
mDTO.setCountry(mr.getParameter("country"));
int runningTime = Integer.parseInt(mr.getParameter("duration"));
mDTO.setRunningTime(runningTime);
mDTO.setActors(mr.getParameter("actors"));
mDTO.setDirectors(mr.getParameter("directors"));

Date releaseDate = Date.valueOf(mr.getParameter("openDate"));
Date endDate = Date.valueOf(mr.getParameter("closeDate"));
mDTO.setReleaseDate(releaseDate);
mDTO.setEndDate(endDate);
mDTO.setMovieDescription(mr.getParameter("description"));
mDTO.setTrailerUrl(mr.getParameter("trailerUrl"));
mDTO.setPosterPath(posterPath); // 수정된 부분
int genreIDx = Integer.parseInt(mr.getParameter("genre"));  // 단일
int gradeIDx = Integer.parseInt(mr.getParameter("grade"));  // 단일
//movie_process.jsp에서 받은 값




//영화 정보와 함께 저장

if("insert".equals(action)){
	
   
	ms.addMovie(genreIDx, gradeIDx, mDTO);
    response.sendRedirect("movie_list.jsp");
    return;
}

if("update".equals(action)){
	ms.modifyMovie(genreIDx, gradeIDx, mDTO);
	response.sendRedirect("movie_list.jsp");
	
    return;
}
if("delete".equals(action)){
    
    ms.removeMovie(movieIdx);
    response.sendRedirect("movie_list.jsp");
    return;
}
%>