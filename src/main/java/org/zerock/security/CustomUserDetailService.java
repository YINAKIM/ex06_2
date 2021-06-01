package org.zerock.security;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
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


        // ---> MemberVO를 UserDetails 타입으로 변환하여 return 하기

        return null;
    }
}
