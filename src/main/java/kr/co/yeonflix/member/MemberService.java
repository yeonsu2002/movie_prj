package kr.co.yeonflix.member;

import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import at.favre.lib.crypto.bcrypt.BCrypt;

public class MemberService {

  private MemberDAO memberDAO;

  public MemberService() {
    this.memberDAO = MemberDAO.getInstance();
  }

  /**
   * 로그인
   */
  public MemberDTO loginMember(String memberId, String memberPwd) {
    MemberDTO memberDTO = new MemberDTO();

    try {
      memberDTO = memberDAO.memberLogin(memberId, memberPwd);
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return memberDTO;
  }

  /**
   * 회원가입 처리
   * 
   * @param memberDTO 회원 정보
   * @return 성공 여부
   */
  public boolean joinMember(MemberDTO memberDTO) {
    try {
      // 1. 데이터 유효성 검증
      if (!validateMemberData(memberDTO)) {
        return false;
      }

      // 2. 비밀번호 암호화 (BCrypt사용함)
      String encryptedPassword = encryptPassword(memberDTO.getMemberPwd());
      memberDTO.setMemberPwd(encryptedPassword);

      // 3. 중복 검사 (아이디, 닉네임, 이메일)
      if (memberDAO.selectMemberId(memberDTO.getMemberId())) {
        System.out.println("이미 존재하는 아이디입니다: " + memberDTO.getMemberId());
        return false;
      }

      if (memberDAO.selectNickname(memberDTO.getNickName())) {
        System.out.println("이미 존재하는 닉네임입니다: " + memberDTO.getNickName());
        return false;
      }

      if (memberDAO.selectEmail(memberDTO.getEmail())) {
        System.out.println("이미 존재하는 이메일입니다: " + memberDTO.getEmail());
        return false;
      }
      if (memberDAO.selectTel(memberDTO.getTel())) {
        System.out.println("이미 존재하는 핸드폰 번호입니다: " + memberDTO.getTel());
        return false;
      }

      // 4. 데이터베이스에 회원 정보 저장
      boolean result = memberDAO.insertMember(memberDTO);

      if (result) {
        System.out.println("회원가입 성공: " + memberDTO.getMemberId());

        // 5. 회원가입 완료 후 추가 작업 (이메일 발송 등)
        sendWelcomeEmail(memberDTO);

        return true;
      } else {
        System.out.println("회원가입 실패: 데이터베이스 저장 오류");
        return false;
      }

    } catch (Exception e) {
      System.out.println("회원가입 처리 중 오류 발생: " + e.getMessage());
      e.printStackTrace();
      return false;
    }
  }

  /**
   * 회원 데이터 유효성 검증
   * 
   * @param memberDTO 회원 정보
   * @return 유효성 검사 결과
   */
  private boolean validateMemberData(MemberDTO memberDTO) {
    // 필수 필드 검증
    if (memberDTO.getMemberId() == null || memberDTO.getMemberId().trim().isEmpty()) {
      System.out.println("아이디가 입력되지 않았습니다.");
      return false;
    }

    if (memberDTO.getMemberPwd() == null || memberDTO.getMemberPwd().trim().isEmpty()) {
      System.out.println("비밀번호가 입력되지 않았습니다.");
      return false;
    }

    // 아이디 형식 검증 (영문, 숫자 조합 6-20자)
    if (!memberDTO.getMemberId().matches("^[a-zA-Z0-9]{6,20}$")) {
      System.out.println("아이디 형식이 올바르지 않습니다.");
      return false;
    }

    // 비밀번호 형식 검증 (영문, 숫자, 특수문자 조합 8자 이상)
    if (!memberDTO.getMemberPwd().matches("^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$")) {
      System.out.println("비밀번호 형식이 올바르지 않습니다.");
      return false;
    }

    if (memberDTO.getNickName() == null || memberDTO.getNickName().trim().isEmpty()) {
      System.out.println("닉네임이 입력되지 않았습니다.");
      return false;
    }

    // 닉네임 형식 검증 (한글, 영문, 숫자 조합 2-20자)
    if (!memberDTO.getNickName().matches("^[가-힣a-zA-Z0-9]{2,20}$")) {
      System.out.println("닉네임 형식이 올바르지 않습니다.");
      return false;
    }

    if (memberDTO.getUserName() == null || memberDTO.getUserName().trim().isEmpty()) {
      System.out.println("이름이 입력되지 않았습니다.");
      return false;
    }

    if (memberDTO.getEmail() == null || memberDTO.getEmail().trim().isEmpty()) {
      System.out.println("이메일이 입력되지 않았습니다.");
      return false;
    }

    // 이메일 형식 검증
    if (!memberDTO.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
      System.out.println("이메일 형식이 올바르지 않습니다.");
      return false;
    }

    // 수신체크 안되어 있으면 "N" 대입
    if (memberDTO.getIsEmailAgreed() == null || memberDTO.getEmail().trim().isEmpty()) {
      memberDTO.setIsEmailAgreed("N");
    }
    if (memberDTO.getIsSmsAgreed() == null || memberDTO.getEmail().trim().isEmpty()) {
      memberDTO.setIsSmsAgreed("N");
    }

    if (memberDTO.getTel() == null || memberDTO.getTel().trim().isEmpty()) {
      System.out.println("전화번호가 입력되지 않았습니다.");
      return false;
    }

    return true;
  }

  /**
   * 비밀번호 암호화
   * 
   * @param password 원본 비밀번호
   * @return 암호화된 비밀번호
   */
  public String encryptPassword(String password) {
    String encryptedPwd = "";
    // 스프링 시큐리티에서 쓰이는 암호화 라이브러리, 단방향 해시 알고리즘 (at.favre.lib:bcrypt 버전)
    encryptedPwd = BCrypt.withDefaults().hashToString(12, password.toCharArray());
    return encryptedPwd;
  }

  // 가입 환영 이멜.. 보낼까?
  private void sendWelcomeEmail(MemberDTO memberDTO) {
    // 이메일 수신 허용한 경우에만
    if ("Y".equals(memberDTO.getEmail())) {
    }
  }

  /* 중복검사 버튼을 클릭시에는 이게 필요하겠지? */
  // 아이디 중복 확인
  public boolean checkUserIdDuplicate(String userId) throws SQLException {
    return memberDAO.selectMemberId(userId);
  }

  // 닉네임 중복 확인
  public boolean checkNickNameDuplicate(String nickName) throws SQLException {
    return memberDAO.selectNickname(nickName);
  }
  
  //이메일 중복 확인
  public boolean checkEmailDuplicate(String email) throws SQLException {
    return memberDAO.selectEmail(email);
  }
  
  /**
   * 회원가입 여부 확인(이름, 생일, 이메일)
   */
  public String isMember(String name, Date birth, String email) {
    String memberId = null;
    try {
      memberId = memberDAO.isMemberByNBE(name, birth, email);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return memberId;
  }
  
  /**
   * 인증번호 발급 받기전에 회원정보 존재하는지 체크 
   */
  public boolean isMemberVerification(String memberId, Date birth, String email) {
    boolean flag = false;
    
    try {
      flag = memberDAO.isMemberByIBE(memberId, birth, email);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return flag;
  }
  
  
  public boolean searchId(String id) {
		boolean flag=false;
		
		try {
			flag=memberDAO.selectId(id);
		} catch (SQLException e) {
			e.printStackTrace();
		}//end catch
		
		
		return flag;
		
	}//searchId
	
  /**
   * 이메일로 임시비밀번호 만들기
   */
  public boolean changePwd (String email,String tempPwd) {
    boolean flag = false;
    String encodedtempPwd = encryptPassword(tempPwd);
    try {
      flag = memberDAO.updatePwd(email, encodedtempPwd);
    } catch (SQLException e) {
      e.printStackTrace();
    }
    
    return flag;
  }
  

	
	
	/**
	 * 시작번호와 끝 번호 사이의 게시물 조회
	 * @param MemberDTO 
	 * @param rDTO
	 * @return list 조회한 게시물 리스트
	 */
	public List<MemberDTO> searchAllMember(RangeDTO rDTO){
		List<MemberDTO> list = null;
		
		MemberDAO pDAO = MemberDAO.getInstance();
		try {
			list = pDAO.selectAllMember(rDTO);
		} catch (SQLException se) {
			se.printStackTrace();
		} //end try catch
		
		return list;
	} //searchAllRestaurant
	
	
	
	
	
	/**
	 * 한 화면에 출력할 게시물의 수
	 * @return pageScale 출력할 게시물의 수
	 */
	public int pageScale() {
		int pageScale=10;
		
		return pageScale;
	} //pageScale
	
	/**
	 * 총 페이지 수
	 * @param totalCount 총 게시물의 수
	 * @param pageScale 한 화면에 출력할 게시물의 수
	 * @return totalPage 총 페이지 수
	 */
	public int totalPage(int totalCount, int pageScale) {
		int totalPage= 0;
		
		totalPage = (int)(Math.ceil((double)totalCount/pageScale));
		
		return totalPage;
	} //totalPage
	
	
	public int totalCount(RangeDTO rDTO) throws SQLException {
	    MemberDAO mDAO = MemberDAO.getInstance();
	    return mDAO.selectTotalCount(rDTO);
	}

	
	/**
	 * pagination 을 클릭했을 때 번호를 사용하여 해당 페이지 게시물 시작 번호
	 * 예) 1=1, 2=11, 3=21, 4=31, 5=41
	 * @param pageScale 한 화면에 출력할 게시물의 수
	 * @param rDTO
	 * @return startNum 해당 페이지 게시물 시작 번호
	 */
	public int startNum(int pageScale, RangeDTO rDTO) {
		int startNum = 1;
		
		startNum = rDTO.getCurrentPage()*pageScale-pageScale+1;
		rDTO.setStartNum(startNum);
		
		return startNum;
	} //startNum
	
	/**pagination 을 클릭했을 때 번호를 사용하여 해당 페이지 게시물 끝 번호
	 * @param pageScale 한 화면에 출력할 게시물의 수
	 * @param rDTO
	 * @return endNum 해당 페이지 게시물 끝 번호
	 */
	public int endNum(int pageScale, RangeDTO rDTO) {
		int endNum = 0;
		
		endNum = rDTO.getStartNum()+pageScale-1;
		rDTO.setEndNum(endNum);
		
		return endNum;
	} //endNum
	
	
	

	
	public MemberDTO searchOneMember(int userIdx) {
		MemberDTO member = null;
		try {
			member = memberDAO.selectOneMember(userIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return member;
	}
	
	/**
	 * 회원수정
	 * @param memberVO
	 * @return
	 */
	public boolean modifyMember(MemberDTO memberVO) {
	    boolean result = false;
	    
	    try {
	        // 비밀번호가 null이 아니고 빈 문자열이 아닐 때만 암호화 진행
	        if (memberVO.getMemberPwd() != null && !memberVO.getMemberPwd().trim().isEmpty()) {
	            String encryptedPwd = encryptPassword(memberVO.getMemberPwd());
	            memberVO.setMemberPwd(encryptedPwd);
	        } else {
	            // 비밀번호가 비어있으면 수정하지 않을 수도 있음
	            // 또는 DB에 평문 비밀번호가 들어가지 않도록 조치 필요
	            // 예: 수정 시 비밀번호 미입력 = 기존 비밀번호 유지
	            // 이 경우 별도 로직 필요 (DAO에서 처리하거나)
	        }

	        result = memberDAO.updateMember(memberVO);
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return result;
	}
	
	

	/**
	 * 회원탈퇴
	 * 
	 * @param userIdx
	 * @param isActive
	 * @return
	 */
	public boolean modifyIsActive(int userIdx, String isActive) {
		boolean result = false;
		
		
		  try {
	            if (!"Y".equals(isActive) && !"N".equals(isActive)) {
	                throw new IllegalArgumentException("isActive 값은 'Y' 또는 'N' 이어야 합니다.");
	            }
	            
	            result= memberDAO.updateIsActive(userIdx, isActive);
	        } catch (SQLException e) {
	            e.printStackTrace();
	            
	            
	        }
		  return result;
  }//modifyIsActive
	
	//기존회원 여부 검증 후 이메일로 회원정보 찾기
	public MemberDTO getOneMember(String email) throws SQLException {
	  MemberDTO memberDTO = new MemberDTO();
	  memberDTO = memberDAO.selectMemberByEmail(email);
	  return memberDTO;
	}
	
	
	
	}
	
  
