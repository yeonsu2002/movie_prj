package kr.co.yeonflix.movie.people;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PeopleService {
	
	public List<PeopleDTO> searchActor() {
		PeopleDAO pDAO = PeopleDAO.getInstance();
		List<PeopleDTO> list = new ArrayList<PeopleDTO>();
		try {
			list = pDAO.selectActor();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return list;
	}//searchActor
	
	public List<PeopleDTO> searchDirector() {
		PeopleDAO pDAO = PeopleDAO.getInstance();
		List<PeopleDTO> list = new ArrayList<PeopleDTO>();
		try {
			list = pDAO.selectDirector();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return list;
	}//searchDirector
	
	
}//class