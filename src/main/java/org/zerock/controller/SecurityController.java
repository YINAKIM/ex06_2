package org.zerock.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Log4j
@Controller
@RequestMapping("/sample/*")
public class SecurityController {

    /****************************** 시큐리티 ******************************/
    @GetMapping("/all")
    public void doAll(){
        log.info("do /////all///// can access everybody");

    }

    @GetMapping("/member")
    public String doMember(){
        log.info("//// logined member ////");
        return "sample/member";
    }

    @GetMapping("/admin")
    public void doAdmin(){
        log.info("//// admin only ////");

    }
    /****************************** 시큐리티 ******************************/


}
