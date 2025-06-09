package kr.co.yeonflix.schedule;

import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import kr.co.yeonflix.movie.MovieDTO;
import kr.co.yeonflix.theater.TheaterDTO;

public class ScheduleService {

	public List<MovieDTO> searchAllMovie() {
		List<MovieDTO> list = null;

		ScheduleDAO schDAO = ScheduleDAO.getInstance();
		try {
			list = schDAO.selectAllMovie();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}//searchAllMovie
	
	public List<MovieDTO> getAvailableMoviesByDate(Date screenDate){
		List<MovieDTO> list = new ArrayList<MovieDTO>();
		for(MovieDTO mDTO : searchAllMovie()) {
			if(!screenDate.before(mDTO.getReleaseDate()) && !screenDate.after(mDTO.getEndDate())) {
				list.add(mDTO);
			}
		}
		return list;
	}
	
	public MovieDTO searchOneMovie(int movieIdx) {
		MovieDTO mDTO = null;
		
		ScheduleDAO schDAO = ScheduleDAO.getInstance();
		try {
			mDTO = schDAO.selectOneMovie(movieIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return mDTO;
	}//searchOneMovie
	
	/**
	 * 해당 상영날짜의 상영하는 영화 리스트를 가져오는 코드
	 * @param schDTOList
	 * @return
	 */
	public List<MovieDTO> searchAllMovieWithSchedule(List<ScheduleDTO> schDTOList){
		List<MovieDTO> list = new ArrayList<MovieDTO>();
		Set<Integer> movieIdxSet = new HashSet<Integer>();
		
		for(ScheduleDTO schDTO : schDTOList) {
			movieIdxSet.add(schDTO.getMovieIdx());
		}
		
		MovieDTO mDTO = null;
		for(Integer movieIdx : movieIdxSet) {
			mDTO = searchOneMovie(movieIdx);
			list.add(mDTO);
		}
		return list;
	}//searchAllMovieWithSchedule
	
	/**
	 * 해당 날짜 해당 영화의 상영관의 상영스케줄과 상영관 정보
	 * @param movieIdx
	 * @param screenDate
	 * @return
	 */
	public List<ScheduleTheaterDTO> searchtAllScheduleAndTheaterWithDate(int movieIdx, Date screenDate) {
		List<ScheduleTheaterDTO> list = null;
		
		ScheduleDAO schDAO = ScheduleDAO.getInstance();
		try {
			list = schDAO.selectAllScheduleAndTheaterWithDate(movieIdx, screenDate);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}//searchtAllScheduleAndTheaterWithDate

	/**
	 * 상영스케줄을 db에 넣는 method
	 * @param schDTO
	 * @return
	 */
	public boolean addSchedule(ScheduleDTO schDTO) {
		boolean flag = false;

		ScheduleDAO schDAO = ScheduleDAO.getInstance();
		try {
			schDAO.insertSchedule(schDTO);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}// addSchedule
	
	/**
	 * 상영스케줄을 업데이트 하는 코드
	 * @param schDTO
	 * @return
	 */
	public boolean modifySchedule(ScheduleDTO schDTO) {
		boolean flag = false;
		
		ScheduleDAO schDAO = ScheduleDAO.getInstance();
		try {
			schDAO.updateSchedule(schDTO);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}//modifySchedule
	
	/**
	 * 상영스케줄 삭제하는 코드
	 * @param scheduleIdx
	 * @return
	 */
	public boolean removeSchedule(int scheduleIdx) {
		boolean flag = false;
		
		ScheduleDAO schDAO = ScheduleDAO.getInstance();
		try {
			schDAO.deleteSchedule(scheduleIdx);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return flag;
	}//removeSchedule

	/**
	 * 해당 날짜에 겹치는 시간대가 있는지 확인
	 * @param schDTO
	 * @return
	 */
	public boolean chkTime(ScheduleDTO schDTO) {
		boolean flag = true;
		Timestamp newStart = schDTO.getStartTime();
		Timestamp newEnd = schDTO.getEndTime();

		List<ScheduleDTO> list = searchScheduleWithDateAndTheater(schDTO.getTheaterIdx(), schDTO.getScreenDate());
		for (ScheduleDTO dto : list) {
			if(dto.getScheduleIdx() == schDTO.getScheduleIdx()) { //자기 자신은 제외(상영스케줄 수정시 필요)
				continue;
			}
			Timestamp existStart = dto.getStartTime();
			Timestamp existEnd = new Timestamp(dto.getEndTime().getTime() + 30 * 60 * 1000); // 청소시간 감안해서 30분 추가

			if (existStart.before(newEnd) && existEnd.after(newStart)) {
				flag = false; // 겹침
				break;
			}
		}

		return flag;
	}// chkTime

	/**
	 * 해당 날짜 해당 상영관의 상영스케줄을 검색하는 코드
	 * @param schDTO
	 * @return
	 */
	public List<ScheduleDTO> searchScheduleWithDateAndTheater(int theaterIdx, Date screenDate) {
		List<ScheduleDTO> list = null;

		ScheduleDAO scDAO = ScheduleDAO.getInstance();
		try {
			list = scDAO.selectScheduleWithDateAndTheater(theaterIdx, screenDate);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}// searchScheduleWithDate
	
	
	/**
	 * ScheduleDTO를 받아 사용자가 보기 편하게 가공해서 돌려주는 코드
	 * @param schDTOList
	 * @return
	 */
	public List<ShowScheduleDTO> createScheduleDTOs(List<ScheduleDTO> schDTOList){
		
		List<ShowScheduleDTO> list = new ArrayList<ShowScheduleDTO>();
		
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
		
		ShowScheduleDTO ssDTO = null;
		for(ScheduleDTO schDTO : schDTOList) {
			ssDTO = new ShowScheduleDTO();
			int scheduleIdx = schDTO.getScheduleIdx();
			String movieName = (searchOneMovie(schDTO.getMovieIdx())).getMovieName();
			String startClock = sdf.format(schDTO.getStartTime());
			String endClock = sdf.format(schDTO.getEndTime());
			
			int statusIdx = schDTO.getScheduleStatus();
			String scheduleStatus = "상영예정";
			if(statusIdx == 1) {
				scheduleStatus = "상영중";
			} else if(statusIdx == 2) {
				scheduleStatus = "상영종료";
			}
				
			
			ssDTO.setScheduleIdx(scheduleIdx);
			ssDTO.setMovieName(movieName);
			ssDTO.setStartClock(startClock);
			ssDTO.setEndClock(endClock);
			ssDTO.setScheduleStatus(scheduleStatus);
			
			list.add(ssDTO);
		}
		
		return list;
	}//createScheduleDTOs
	
	/**
	 * 스케줄Idx로 특정 상영스케줄을 찾는 코드
	 * @param scheduleIdx
	 * @return
	 */
	public ScheduleDTO searchOneSchedule(int scheduleIdx) {
		ScheduleDTO schDTO = null;
		
		ScheduleDAO schDAO = ScheduleDAO.getInstance();
		try {
			schDTO = schDAO.selectOneSchedule(scheduleIdx);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return schDTO;
	}//searchOneSchedule
	
	/**
	 * 모든 상영스케줄을 찾는 코드
	 * @return
	 */
	public List<ScheduleDTO> searchAllSchedule(){
		List<ScheduleDTO> list = null;
		
		ScheduleDAO schDAO = ScheduleDAO.getInstance();
		try {
			list = schDAO.selectAllSchedule();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}//searchAllSchedule
	
	/**
	 * 해당 날짜의 모든 상영스케줄을 찾는 코드
	 * @param screenDate
	 * @return
	 */
	public List<ScheduleDTO> searchAllScheduleWithDate(Date screenDate){
		List<ScheduleDTO> list = null;
		
		ScheduleDAO schDAO = ScheduleDAO.getInstance();
		try {
			list = schDAO.selectAllScheduleWithDate(screenDate);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}//searchAllSchedule
	
	/**
	 * 해당 날짜 해당 영화의 상영 스케줄을 찾는 코드
	 * @param movieIdx
	 * @param screenDate
	 * @return
	 */
	public List<ScheduleDTO> searchAllScheduleWithDateAndMovie(int movieIdx, Date screenDate){
		List<ScheduleDTO> list = null;
		
		ScheduleDAO schDAO = ScheduleDAO.getInstance();
		try {
			list = schDAO.selectAllScheduleWithDateAndMovie(movieIdx, screenDate);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}//searchAllSchedule
}// class
