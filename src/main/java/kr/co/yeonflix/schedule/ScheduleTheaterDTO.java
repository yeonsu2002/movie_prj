package kr.co.yeonflix.schedule;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ScheduleTheaterDTO {
	    private int theaterIdx;
	    private String theaterName;
	    private String theaterType;
	    private int moviePrice;
	    
	    private int scheduleIdx;
	    private int movieIdx;
	    private Date screenDate;
	    private Timestamp startTime;
	    private Timestamp endTime;
	    private int scheduleStatus;
	    private int remainSeats;
}
