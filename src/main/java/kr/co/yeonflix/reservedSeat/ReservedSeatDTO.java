package kr.co.yeonflix.reservedSeat;

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
public class ReservedSeatDTO {

	private int reservedSeatIdx, seatIdx, reservationIdx, scheduleIdx, reservedSeatStatus;
}
