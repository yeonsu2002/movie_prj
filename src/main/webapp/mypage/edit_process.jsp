<%@page import="org.json.simple.JSONObject"%>
<%@page import="kr.co.yeonflix.member.MemberService"%>
<%@page import="java.nio.channels.MembershipKey"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="kr.co.yeonflix.member.MemberDTO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    response.setContentType("application/json; charset=UTF-8");
    JSONObject json = new JSONObject();
    MemberDTO memberVO = new MemberDTO();

    MultipartRequest multi = null;
    int fileMaxSize = 10 * 1024 * 1024;
    String savePath = "C:/dev/movie/userProfiles";
    File saveDir = new File(savePath);

    if (!saveDir.exists()) {
        saveDir.mkdirs();
    }

    if (ServletFileUpload.isMultipartContent(request)) {
        try {
            multi = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8");

            // 세션에서 유저 가져오기
            MemberDTO sessionDTO = (MemberDTO) session.getAttribute("loginUser");

            if (sessionDTO == null || sessionDTO.getUserIdx() == 0) {
                json.put("result", false);
                json.put("message", "로그인이 필요합니다.");
                out.print(json.toJSONString());
                return;
            }

            memberVO.setUserIdx(sessionDTO.getUserIdx());

            // 파라미터 설정
            String memberPwd = multi.getParameter("memberPwd");
            String nickName = multi.getParameter("nickName");
            String email1 = multi.getParameter("email1");
            String email2 = multi.getParameter("email2");
            String email = "";

            if (email1 != null && email2 != null && !email1.trim().isEmpty() && !email2.trim().isEmpty()) {
                email = email1 + "@" + email2;
            } else {
                email = sessionDTO.getEmail(); // 비어 있으면 기존 이메일 유지
            }

            memberVO.setMemberPwd(memberPwd);
            memberVO.setNickName(nickName);
            memberVO.setEmail(email);
            memberVO.setIsEmailAgreed(multi.getParameter("isEmailAgreed"));
            memberVO.setTel(multi.getParameter("tel"));
            memberVO.setIsSmsAgreed(multi.getParameter("isSmsAgreed"));

            // 파일 처리
            File profileFile = multi.getFile("profile");
            String originalFileName = multi.getOriginalFileName("profile");
            String savedFileName = multi.getFilesystemName("profile");
            String existingPicture = sessionDTO.getPicture();
            String picture = existingPicture;
            
            if (profileFile != null && profileFile.exists() && originalFileName != null && !originalFileName.trim().isEmpty()) {
                String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1).toUpperCase();
                if (ext.equals("PNG") || ext.equals("JPG") || ext.equals("GIF") || ext.equals("JPEG")) {
                    picture = (savedFileName != null ? savedFileName : existingPicture);
                } else {
                    picture = "default_img.png"; 
                }
            } else {
                System.out.println("이미지 업로드 없음, 기존 이미지 유지: " + existingPicture);
            }
            memberVO.setPicture(picture);
            
            // DB 업데이트
            MemberService memberService = new MemberService();
            boolean result = memberService.modifyMember(memberVO);

            if (result) {
                // DB에서 업데이트된 전체 정보를 다시 가져와서 세션에 저장
                MemberDTO updatedMember = memberService.searchOneMember(sessionDTO.getUserIdx());
                if (updatedMember != null) {
                    session.setAttribute("loginUser", updatedMember);
                    System.out.println("세션 갱신 완료 - 회원ID: " + updatedMember.getMemberId());
                } else {
                    // DB 조회 실패 시 기존 세션 정보에 수정된 내용만 업데이트
                    sessionDTO.setNickName(nickName);
                    sessionDTO.setEmail(email);
                    sessionDTO.setIsEmailAgreed(multi.getParameter("isEmailAgreed"));
                    sessionDTO.setIsSmsAgreed(multi.getParameter("isSmsAgreed"));
                    sessionDTO.setPicture(picture);
                    if (memberPwd != null && !memberPwd.trim().isEmpty()) {
                        sessionDTO.setMemberPwd(memberPwd);
                    }
                    session.setAttribute("loginUser", sessionDTO);
                    System.out.println("세션 부분 갱신 완료 - 회원ID: " + sessionDTO.getMemberId());
                }
                
                json.put("result", true);
                json.put("message", "회원 정보가 성공적으로 수정되었습니다.");
            } else {
                json.put("result", false);
                json.put("message", "회원 수정에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.put("result", false);
            json.put("message", "서버 오류 발생: " + e.getMessage());
        }
    } else {
        json.put("result", false);
        json.put("message", "유효하지 않은 요청입니다.");
    }
   
    out.print(json.toJSONString());
%>