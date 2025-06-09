package kr.co.yeonflix.reservation;

import java.sql.Date;
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
public class GuestReservationDTO {

	private int reservationIdx, userIdx, seatsCnt, totalPrice;
	private String reservationNumber, seatsInfo, userType, email, birthFormatted;
	private Timestamp reservationDate, canceledDate;
	private Date nonMemberBirth;
}
