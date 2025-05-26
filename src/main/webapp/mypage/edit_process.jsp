<%@page import="kr.co.yeonflix.member.MyPageService"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page contentType="application/json; charset=UTF-8" %>

<%
    JSONObject json = new JSONObject();
    HttpSession session2 = request.getSession(false);

    boolean result = false;

    if (session2 != null && session2.getAttribute("userData") != null) {
        MemberDTO member = new MemberDTO();

        // 필수 값만 간단하게 설정 (실제 서비스에서는 검증이 필요)
        member.setMemberId(request.getParameter("memberId"));
        member.setNickName(request.getParameter("nickName"));
        member.setMemberPwd(request.getParameter("memberPwd"));

        String email1 = request.getParameter("email1");
        String email2 = request.getParameter("email2");
        member.setEmail((email1 != null && email2 != null) ? email1 + "@" + email2 : "");

        member.setTel(request.getParameter("tel"));
        member.setIsEmailAgreed(request.getParameter("isEmailAgreed"));
        member.setIsSmsAgreed(request.getParameter("isSmsAgreed"));
        member.setPicture(request.getParameter("imgName"));

        result = new MyPageService().modifyMember(member, session2);
    }

    json.put("result", result);
    response.setContentType("application/json;charset=UTF-8");
    out.print(json.toJSONString());
%>
