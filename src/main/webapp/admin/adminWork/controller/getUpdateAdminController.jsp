<%@ page import="java.time.LocalDateTime" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %> 
<%@ page import="com.fasterxml.jackson.datatype.jsr310.JavaTimeModule" %> 
<%@ page import="com.fasterxml.jackson.databind.SerializationFeature" %> 
<%@ page import="kr.co.yeonflix.admin.AdminDTO" %> 
<%@ page import="kr.co.yeonflix.admin.AdminService" %>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>

<%
	 // 응답 데이터를 JSON으로 보내기 위한 설정
	 response.setContentType("application/json;charset=UTF-8"); // JSON 응답 타입 설정
	 request.setCharacterEncoding("UTF-8"); // 요청 파라미터 한글 처리
	
	 String managerId = request.getParameter("managerId");
	
	 AdminService adService = new AdminService();
	 AdminDTO adminDTO = null; 
	 String jsonResponse = ""; // JSON 문자열 저장 변수
	
	 try {
	   adminDTO = adService.getAdminInfo(managerId);
	
	   // Jackson의 ObjectMapper 생성 (JSON 변환기) : ObjectMapper는 자바 객체를 JSON 문자열로 바꿔줍니다.
	   ObjectMapper objectMapper = new ObjectMapper();
	
	   // LocalDateTime 같은 자바 8 날짜/시간 클래스를 처리하려면 이 모듈 등록
	   objectMapper.registerModule(new JavaTimeModule());
	
	   // 날짜/시간을 숫자(timestamp)가 아닌 ISO 문자열("2024-06-01T15:30:00")로 출력되게 설정
	   objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
	
	   if (adminDTO != null) {
	       // AdminDTO 객체를 JSON 문자열로 변환
	       jsonResponse = objectMapper.writeValueAsString(adminDTO);
	   } else {
	       // 조회 결과가 없으면 에러 메시지를 JSON 형식으로 반환
	       jsonResponse = "{\"error\":\"관리자 정보를 찾을 수 없습니다.\"}";
	       /* 	{
				  	"error": "관리자 정보를 찾을 수 없습니다."
					} 
	       이러한 형태. 이스케이프때문에 귀찮네*/ 
	   }
	} catch (Exception e) {
	    // 예외 발생 시 로그 출력 및 에러 메시지 반환
	    e.printStackTrace();
	    jsonResponse = "{\"error\":\"서버 오류 발생\"}";
	}
	
	// 클라이언트에게 JSON 결과 전송
	response.getWriter().write(jsonResponse);

%>