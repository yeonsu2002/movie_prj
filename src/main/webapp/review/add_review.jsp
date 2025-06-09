<%@page import="kr.co.yeonflix.purchaseHistory.PurchaseHistoryService"%>
<%@ page import="kr.co.yeonflix.review.ReviewService" %>
<%@ page import="kr.co.yeonflix.review.ReviewDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // 한글 인코딩
    request.setCharacterEncoding("UTF-8");

    // 파라미터 수신
    String movieIdStr = request.getParameter("movieId");
    String content = request.getParameter("content");
    String ratingStr = request.getParameter("rating");
    String movieName = request.getParameter("movieName");

    // rating 파싱
    double rating = 0.0;
    if (ratingStr != null && !ratingStr.trim().isEmpty()) {
        try {
            rating = Double.parseDouble(ratingStr.trim());
        } catch (NumberFormatException e) {
            rating = 0.0;
        }
    }

    // movieId 파싱
    int movieId = 0;
    try {
        if (movieIdStr != null && !movieIdStr.trim().isEmpty()) {
            movieId = Integer.parseInt(movieIdStr.trim());
        }
    } catch (NumberFormatException e) {
        movieId = 0;
    }

    // 세션에서 userId 가져오기
    Integer userId = null;
    Object sessionUserId = session.getAttribute("userId");
    if (sessionUserId != null) {
        try {
            if (sessionUserId instanceof String) {
                userId = Integer.parseInt((String) sessionUserId);
            } else if (sessionUserId instanceof Integer) {
                userId = (Integer) sessionUserId;
            }
        } catch (NumberFormatException e) {
            userId = null;
        }
    }
    
    // 로그인 체크
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='" + request.getContextPath() + "/login/loginFrm.jsp';</script>");
        return;
    }
    
    // 구매 여부 체크
    PurchaseHistoryService phs = new PurchaseHistoryService();
    Boolean Purchased = false;
    try {
        Purchased = phs.hasPurchasedMovie(userId, movieId);
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('서버 오류가 발생했습니다.'); history.back();</script>");
        return;
    }

    if(!Purchased){
        out.println("<script>alert('영화 관람 후에만 리뷰 작성이 가능합니다'); history.back();</script>");
        return;
    }

    // 필수 값 체크
    if (movieId <= 0) {
        out.println("<script>alert('올바른 영화를 선택해주세요.'); history.back();</script>");
        return;
    }
    if (content == null || content.trim().isEmpty()) {
        out.println("<script>alert('리뷰 내용을 입력해주세요.'); history.back();</script>");
        return;
    }

    // 리뷰 내용 바이트 길이 제한 (예: 280 바이트)
    int byteLen = 0;
    for (int i = 0; i < content.length(); i++) {
        byteLen += (content.charAt(i) > 127) ? 2 : 1;
    }
    if (byteLen > 280) {
        out.println("<script>alert('리뷰 내용은 280바이트를 넘을 수 없습니다.'); history.back();</script>");
        return;
    }

    // 중복 리뷰 체크 - 한 아이디당 영화별 리뷰 1개만 허용
    ReviewService service = new ReviewService();
    try {
        if(service.hasUserReviewedMovie(userId, movieId)) {
            out.println("<script>alert('이미 이 영화에 대해 리뷰를 작성하셨습니다.'); history.back();</script>");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('서버 오류가 발생했습니다.'); history.back();</script>");
        return;
    }

    // DTO 생성 및 세팅
    ReviewDTO dto = new ReviewDTO();
    dto.setMovieId(movieId);
    dto.setMovieName(movieName);
    dto.setContent(content.trim());
    dto.setRating(rating);
    dto.setUserId(userId);

    // 리뷰 등록 시도
    boolean result = false;
    try {
        result = service.addReview(dto);
    } catch (Exception e) {
        e.printStackTrace();
    }

    // 결과 처리
    if (result) {
%>
    <script>
        alert('리뷰가 정상적으로 저장되었습니다.');
        location.href = document.referrer;
    </script>
<%
    } else {
%>
    <script>
        alert('리뷰 저장에 실패했습니다.');
        history.back();
    </script>
<%
    }
%>
