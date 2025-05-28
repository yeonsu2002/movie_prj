package kr.co.yeonflix.reservation;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class ReservationDTO {
	
	private int reservationIdx, scheduleIdx, userIdx, totalPrice;
	private Timestamp reservationDate, canceledDate;
	private String reservationNumber;
}

