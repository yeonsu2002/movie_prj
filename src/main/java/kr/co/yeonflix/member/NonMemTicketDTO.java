package kr.co.yeonflix.member;

import java.sql.Date;
import java.time.LocalDateTime;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@NoArgsConstructor
@AllArgsConstructor
@Data
public class NonMemTicketDTO {

  private String ticketNumber;
  private List<String> seats;
  private Date date;
  private int totalPrice;
  private String moviePoster;
  private String movieName;
  private String theaterName;
  private LocalDateTime startTime;
  private LocalDateTime endTime;
  
  
}
