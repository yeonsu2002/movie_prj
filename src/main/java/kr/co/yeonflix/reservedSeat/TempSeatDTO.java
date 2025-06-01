package kr.co.yeonflix.reservedSeat;

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
public class TempSeatDTO {

	private int seatIdx, scheduleIdx;
	private Timestamp clickTime;
}
