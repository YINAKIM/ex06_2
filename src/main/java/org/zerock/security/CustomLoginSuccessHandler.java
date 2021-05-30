package org.zerock.security;

import lombok.extern.log4j.Log4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {
//로그인 후에 바로 권한 별로 페이지 redirect해주는 로그인석세스핸들러

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication auth)
            throws IOException, ServletException {
        log.warn("-------Login Success 핸들러들어옴");

        List<String> roleNames = new ArrayList<>();

        auth.getAuthorities().forEach( authority -> {
            roleNames.add( authority.getAuthority() );
        });//forEach : 권한이름목록에 각각 권한 부여

        log.warn("ROLE NAMES : "+roleNames);

        // ROLE_ADMIN 이면 admin페이지로 redirect
        if(roleNames.contains("ROLE_ADMIN")){
            response.sendRedirect("/sample/admin");
            return;
        }

        // ROLE_MEMBER 면 member페이지로 redirect
        if(roleNames.contains("ROLE_MEMBER")){
            response.sendRedirect("/sample/member");
            return;
        }

        // 권한에 admin 이나 member 없으면 기본 redirect "/"
        response.sendRedirect("/");
    }
}
