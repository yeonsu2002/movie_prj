<%@page import="java.util.Set"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.admin.AdminDTO"%>
<%@page import="kr.co.yeonflix.admin.AdminService"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
    pageEncoding="UTF-8"
    info="관리자 로그인 프로세스"%>
<% 
	String adminId = request.getParameter("adminId");
	String adminPwd = request.getParameter("adminPwd");

	AdminService adService = new AdminService();
	
	AdminDTO loginAdmin = adService.adminLogin(adminId, adminPwd);
	
	//디버깅	
	//System.out.println("loginAdmin 정보 : " + loginAdmin);

	//관리자계정 조회는 되지만, 비활동 계정인 경우 
	if(loginAdmin != null && "N".equals(loginAdmin.getIsActive())){
		out.print("isDeleted");
		return;
	}
	
	//접속한 IP주소가 해당 관리자의 허용된 IP리스트에 속하지 않을 때
	String connectedIP = request.getRemoteAddr();
	Set<String> superAdminIPs = Set.of("127.0.0.1", "0:0:0:0:0:0:0:1", "::1" ); // "::1" -> IPv6 주소를 축약 표기, 이건몰랐네 
	int addrCount = loginAdmin.getIPList().size();
	List<String> addrList = new ArrayList<String>();
	for(int i = 0; i < addrCount; i++){
	  String addr = (String) loginAdmin.getIPList().get(i).getIpAddress();
	  addrList.add(addr);
	}
	if(!addrList.contains(connectedIP) && !superAdminIPs.contains(connectedIP)){
	  out.print("deniedIP");
	  return;
	}
	
	
	
	//정상적인 관리자 계정일 때 
	if(loginAdmin != null && loginAdmin.getUserIdx() > 0){
		//세션 초기화
		session.invalidate();
		//새 세션 받아, 위에서 초기화 했잔하 
		session = request.getSession(true);
		//세션에 관리자 계정 저장
		session.setAttribute("loginAdmin", loginAdmin);
		//세션객체 무응답 대기시간 30분 제한
		session.setMaxInactiveInterval(1800);
		out.print("success");
	} else {
		out.print("fail"); //관리자 로그인 실패 
	}
	

%>