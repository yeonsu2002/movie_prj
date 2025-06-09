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
public class UserReservationDTO {

	private int reservationIdx, userIdx, seatsCnt, totalPrice;
	private String reservationNumber, memberId, seatsInfo, userType, tel;
	private Timestamp reservationDate, canceledDate;
}
