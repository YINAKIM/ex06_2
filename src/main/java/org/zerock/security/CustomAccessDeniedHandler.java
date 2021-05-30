package org.zerock.security;

import lombok.extern.log4j.Log4j;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Log4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler {

    //HttpServletRequest, HttpServletResponse를 파라미터로 받기때문에 직접적으로 서블릿 API를 이용하는 처리가 가능하다.
    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException e)
            throws IOException, ServletException {
        log.error("커스텀 Access Denied Handler");
        log.error("Redirect.........................");
        response.sendRedirect("/accessError");//접근제한 걸릴 경우 redirect


    }
}
