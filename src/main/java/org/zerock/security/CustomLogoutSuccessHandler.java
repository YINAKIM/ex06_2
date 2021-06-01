package org.zerock.security;

import lombok.extern.log4j.Log4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/*
* POST방식으로 처리하는 로그아웃은 원래 스프링시큐리티 내부에서 동작하는데,
* 만약 로그아웃 후에 추가적인 작업이 필요하다면
* implements LogoutSuccessHandler 로 구현체 만들어서 작업하면됨
* 이건그냥 내가 해볼라고 만든거 ===> 1. security-context.xml에 bean으로 등록함
*                            2. <security:http> 안에서 ref로 설정 : success-handler-ref="customLogoutSuccess"
 * */
@Log4j
public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {

    @Override
    public void onLogoutSuccess(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Authentication authentication) throws IOException, ServletException {
        log.info("-------onLogoutSuccess--------");
        log.info("CustomLogoutSuccessHandler돌아가는지 확인");
        log.info("-------onLogoutSuccess--------");
    }
}
