package kr.co.yeonflix.member;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MyPageDTO {
    private String id;
    private String name;
    private String birth;
    private String tel;
    private String gender;
    private String profile_img;

}