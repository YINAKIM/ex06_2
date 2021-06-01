package org.zerock.domain;

import lombok.Data;

@Data
public class AuthVO {
    //TBL_MEMBER_AUTH 테이블 반영
    private String userid;
    private String auth;

}
