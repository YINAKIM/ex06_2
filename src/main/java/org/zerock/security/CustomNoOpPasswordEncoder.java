package org.zerock.security;

import lombok.extern.log4j.Log4j;
import org.springframework.security.crypto.password.PasswordEncoder;

@Log4j
public class CustomNoOpPasswordEncoder implements PasswordEncoder {
/*
*
* 원래는
* <security:jdbc-user-service data-source-ref="dataSource"/>
* 이용하려면 PasswordEncoder 꼭있어야함, 인터페이스라서 얘 구현체가 이미 시큐리티 안에 내장되어있음 그거쓰면됨
* (BCryptPasswordEncoder도 구현체 중 하나)
*
* 평문pw 이용할 수 있게 처리하려면?
* 스프링 5 이전에는 PasswordEncoder의 구현체인
* NoOpPasswordEncoder가 기본내장되어있어서 그거쓰면 평문pw 이용할 수 있게 처리가능했는데
* 스프링5부터는 Deprecated 되버려서 이제 못쓰니까 직접 만들어서 써봄
*
WARN : org.zerock.security.CustomNoOpPasswordEncoder - pw매칭 ====> PW00 : PW00
WARN : org.zerock.security.CustomLoginSuccessHandler - -------Login Success 핸들러들어옴
WARN : org.zerock.security.CustomLoginSuccessHandler - ROLE NAMES : [ROLE_ADMIN, ROLE_MANAGER]
INFO : org.zerock.controller.SecurityController - //// admin only ////
*
 security-context.xml에서 bean등록 후
  <security:authentication-manager><security:jdbc-user-service data-source-ref="dataSource"/>
            <security:password-encoder ref="customPasswordEncoder"/>안에
             <security:jdbc-user-sevice data-source-ref="dataSource"/>
            <security:password-encoder ref="customPasswordEncoder"/>
 추가하면)
 WARN : org.zerock.security.CustomNoOpPasswordEncoder - pw매칭 ====> PW00 : PW00
 매칭해서 로그인핸들러로 넘김
* */
    @Override
    public String encode(CharSequence rawPassword) {
        log.warn("pw 인코딩 전, 원래 pw----> " +rawPassword);
        return rawPassword.toString();
    }

    @Override
    public boolean matches(CharSequence rawPassword, String enCodedPassword) {

        log.warn("pw매칭 ====> "+rawPassword+" : "+enCodedPassword);
        return rawPassword.toString().equals(enCodedPassword);
    }
}
