package kr.co.yeonflix.reservation;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class ShowReservationDTO {

	private int scheduleIdx, reservationIdx;
	private String movieName, theaterName;
	private Date screenDate;
	private Timestamp reservationDate, canceledDate;
}
