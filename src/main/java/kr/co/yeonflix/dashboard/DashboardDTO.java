package kr.co.yeonflix.dashboard;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DashboardDTO {
    private String date; //일별 매출
    private int totalSales;

    private String theaterType;
    private int reservationCount;
    
    private String movie_name;
    private String memberType ;

    // 일별 매출용 객체 생성
    public static DashboardDTO ofDailySales(String date, int totalSales) {
        DashboardDTO dto = new DashboardDTO();
        dto.setDate(date);
        dto.setTotalSales(totalSales);
        return dto;
    }

    // 특별관 예매용 객체 생성
    public static DashboardDTO ofTheaterReservation(String theaterType, int reservationCount) {
        DashboardDTO dto = new DashboardDTO();
        dto.setTheaterType(theaterType);
        dto.setReservationCount(reservationCount);
        return dto;
    }
    
    // 인기 영화 생성자 & 팩토리도 movie_name 사용하도록 수정
    public static DashboardDTO ofTopMovie(String movie_name, int reservationCount) {
        DashboardDTO dto = new DashboardDTO();
        dto.setMovie_name(movie_name);
        dto.setReservationCount(reservationCount);
        return dto;
    }
	
	  // 회원/비회원 예매 생성자 & 팩토리 
    public static DashboardDTO ofMemberReservationByDate(String date, String memberType, int count) {
        DashboardDTO dto = new DashboardDTO();
        dto.setDate(date);
        dto.setMemberType(memberType);
        dto.setReservationCount(count);
        return dto;
    }

	

    
}
