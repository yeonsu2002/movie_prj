<%@page import="kr.co.yeonflix.member.NonMemTicketDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.member.NonMemberService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String birth = request.getParameter("birth");
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	
	 
	//이메일과 생일로 좌석 가져오기
	if (birth != null && email != null && password != null){
		NonMemberService nmService = new NonMemberService();
		try{
		  List<NonMemTicketDTO> nmtDTOList = new ArrayList<NonMemTicketDTO>();
		  
		  nmtDTOList = nmService.getNmtDTOlist(birth, email, password);
		  
		  if(nmtDTOList == null || nmtDTOList.isEmpty()){
%>
        <script type="text/javascript">
          alert("예매내역이 존재하지 않습니다.");
          history.back();
        </script>
<%		    
		  } else {
		    
			  request.setAttribute("nmtDTOList", nmtDTOList);
				RequestDispatcher dispatcher = request.getRequestDispatcher("/login/getNonMemberTicket.jsp");
	    	dispatcher.forward(request, response);
		    return;
		  }
		} catch (Exception e){
		  e.printStackTrace();
%>
      <script type="text/javascript">
        alert("조회 중 오류가 발생했습니다.");
        history.back();
      </script>
<%
		}
  } else {
%>
    <script type="text/javascript">
      alert("입력값이 올바르지 않습니다.");
      history.back();
    </script>
<%
  }
%>