package kr.co.yeonflix.movie;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class MovieDTO {

   private int movieIdx, runningTime,screeningStatus;
   private String movieName, posterPath, country, movieDescription, trailerUrl, screeningStatusStr, actors, directors;
   private Date releaseDate, endDate;
   
   	

}