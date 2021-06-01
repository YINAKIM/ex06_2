package org.zerock.security;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.zerock.domain.CustomUser;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberMapper;

@Log4j
public class CustomUserDetailService implements UserDetailsService {

    @Setter(onMethod_ = @Autowired)
    private MemberMapper mapper;

    @Override
    public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
        log.warn("커스텀 UserDetailsService ******** Load User By UserName : "+userName);
        //WARN : org.zerock.security.CustomUserDetailService
        // - 커스텀 UserDetailsService ******** Load User By UserName : admin91
        // 잘나옴 근데 UserDetails타입을 반환해야되는데 null반환해서 에러남


        // ---> MemberVO를 UserDetails 타입으로 변환(CustomUser 이용)하여 return 하기
        MemberVO vo = mapper.read(userName); //userName이 userid임 (스프링시큐리티한테 userName이 id)

        log.warn("********* queried by member mapper : "+vo);


        return vo == null ? null : new CustomUser(vo);
        // loadUserByUsername()은 내부적으로 MemberMapper를 이용해서 MemberVO를 조회하고,
        // 만약 MemberVO의 인스턴스를 얻을 수 있다면 CustomUser타입의 객체로 변환해서 반환한다.
    }
    /*

    WARN : org.zerock.security.CustomUserDetailService
    - 커스텀 UserDetailsService ******** Load User By UserName : admin92

    INFO : jdbc.resultsettable -
|--------|-------------------------------------------------------------|---------|---------|----------------------|----------------------|-----------|
|userid  |userpw                                                       |username |enabled  |regdate               |updatedate            |auth       |
|--------|-------------------------------------------------------------|---------|---------|----------------------|----------------------|-----------|
|admin92 |$2a$10$HjiDi9bXLvxUH0PGqB0l1OOf3f6NG.i29iX3jp8qlySgdEZPgf2T2 |관리자92    |[unread] |2021-06-01 11:29:08.0 |2021-06-01 11:29:08.0 |ROLE_ADMIN |
|--------|-------------------------------------------------------------|---------|---------|----------------------|----------------------|-----------|

    WARN : org.zerock.security.CustomUserDetailService - ********* queried by member mapper : MemberVO(userid=admin92, userpw=$2a$10$HjiDi9bXLvxUH0PGqB0l1OOf3f6NG.i29iX3jp8qlySgdEZPgf2T2, userName=관리자92, enabled=false, regDate=Tue Jun 01 11:29:08 KST 2021, updateDate=Tue Jun 01 11:29:08 KST 2021, authList=[AuthVO(userid=admin92, auth=ROLE_ADMIN)])
    WARN : org.zerock.security.CustomLoginSuccessHandler - -------Login Success 핸들러들어옴
    WARN : org.zerock.security.CustomLoginSuccessHandler - ROLE NAMES : [ROLE_ADMIN]
    INFO : org.zerock.controller.SecurityController - //// admin only ////
    */

}
