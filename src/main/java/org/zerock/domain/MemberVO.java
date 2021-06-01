package org.zerock.domain;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class MemberVO {
    private String userid;
    private String userpw;
    private String userName;
    private boolean enabled;

    private Date regDate;
    private Date updateDate;
    private List<AuthVO> authList;
    //한 userid가 여러개의 사용자 권한을 가질 수 있는 구조로 설계
    // 예) admin은 admin, manager 권한 둘다 가진다.
}
