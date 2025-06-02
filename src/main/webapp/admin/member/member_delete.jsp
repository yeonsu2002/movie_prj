<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
    // POST로 전달된 회원 ID 받기
    String userIdxStr = request.getParameter("userIdx");
    int userIdx = 0;

    if (userIdxStr == null || userIdxStr.trim().isEmpty()) {
        out.println("회원 ID가 전달되지 않았습니다.");
        return;
    }

    try {
        userIdx = Integer.parseInt(userIdxStr);
    } catch (NumberFormatException e) {
        out.println("잘못된 회원 ID입니다.");
        return;
    }

    // 서비스 호출: is_active = 'N'으로 업데이트
    MemberService ms = new MemberService();
    boolean result = ms.modifyIsActive(userIdx, "N");

    // 성공 시 회원 테이블 페이지로 리디렉션
    if (result) {
        response.sendRedirect("member_table.jsp");
    } else {
        out.println("강제 탈퇴 실패. 다시 시도하세요.");
    }
%>