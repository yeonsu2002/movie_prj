<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="kr.co.yeonflix.admin.AdminDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
//어드민 객체
AdminDTO adminDTO = new AdminDTO();

MultipartRequest multi = null;
int fileMaxSize = 10 * 1024 * 1024;

String savePath = "C:\\dev\\movie\\userProfiles"; //사진저장소. 
%>