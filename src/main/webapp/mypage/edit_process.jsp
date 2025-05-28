<%@page import="org.json.simple.JSONObject"%>
<%@page import="kr.co.yeonflix.member.MyPageService"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@page import="netscape.javascript.JSObject"%>
<%
    JSONObject json = new JSONObject();

    boolean result = false;

    if (session != null && session.getAttribute("userData") != null) {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("userData");

        String memberId = request.getParameter("memberId");
        if (memberId != null && memberId.equals(loginUser.getMemberId())) {
            MemberDTO member = new MemberDTO();

            member.setMemberId(memberId);
            member.setNickName(request.getParameter("nickName"));
            member.setMemberPwd(request.getParameter("memberPwd"));

            String email1 = request.getParameter("email1");
            String email2 = request.getParameter("email2");
            member.setEmail((email1 != null && email2 != null) ? email1 + "@" + email2 : "");

            member.setTel(request.getParameter("tel"));
            member.setIsEmailAgreed(request.getParameter("isEmailAgreed"));
            member.setIsSmsAgreed(request.getParameter("isSmsAgreed"));
            member.setPicture(request.getParameter("imgName"));

            // 여기를 member로 바꿔야 함
            result = new MyPageService().modifyMember(member, session);
        } else {
            json.put("msg", "본인 계정으로만 수정 가능합니다.");
        }
    } else {
        json.put("msg", "로그인이 필요합니다.");
    }

    json.put("result", result);
    response.setContentType("application/json;charset=UTF-8");
    out.print(json.toJSONString());
%>
