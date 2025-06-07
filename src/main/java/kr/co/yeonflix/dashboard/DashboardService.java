package kr.co.yeonflix.dashboard;
  
import java.util.List;
  
public class DashboardService {
  
	private DashboardDAO dashboardDAO;
  
	public DashboardService() { 
		dashboardDAO = DashboardDAO.getInstance(); 
		}
  
	 // 일별 매출 데이터 반환
    public List<DashboardDTO> getDailySales() {
        return dashboardDAO.getDailySales();
    }

    // 특별관 예매 건수 반환
    public List<DashboardDTO> getReservationByTheaterType() {
        return dashboardDAO.getReservationByTheaterType();
    }

    // 상영중 인기 영화 TOP 5 예매 건수 반환
    public List<DashboardDTO> getTop5Movies() {
        return dashboardDAO.getTop5Movies();
    }

    // 회원/비회원 예매 건수 반환
    public List<DashboardDTO> getMemberReservationCount() {
        return dashboardDAO.getMemberReservationCount();
    }
	
}//class



    
    
  

