package kr.co.yeonflix.schedule;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class ShowScheduleDTO {

	private int scheduleIdx;
	private String movieName, startClock, endClock, scheduleStatus ;
}
