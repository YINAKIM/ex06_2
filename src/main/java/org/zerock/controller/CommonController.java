package org.zerock.controller;


import lombok.extern.log4j.Log4j;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Log4j
@Controller
public class CommonController {

    @GetMapping("/accessError")
    public void accessDenied(Authentication auth, Model model){
                            // Authentication: 사용자 정보
        log.info("access denied : "+auth);
        model.addAttribute("msg","Access Denied");

    }


    @GetMapping("/customLogin")
    public void loginInput(String error, String logout, Model model){
        log.error("커스텀 로그인 중.......error메세지 : "+error);
        log.info("커스텀 로그인 중.......logout메세지 : "+logout);

        if(error != null){
            model.addAttribute("error","Login Error! 계정정보를 확인하세요.");
        }

        if(logout != null){
            model.addAttribute("logout","Logout!!");
        }

    }

    @GetMapping("/customLogout")
    public void logoutGET(){
        log.info("custom LOGOUT");
    }

    @GetMapping("/springLogout")
    public void springLogoutGET(){
        log.info("springLogout!!!");
    }

}
