package org.zerock.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Log4j
@Controller
@RequestMapping("/sample/*")
public class SampleController {

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

    @PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
    @GetMapping("/annoMember")
    public String doMember2() {

        log.info("......................logined annotation member");
        return "all";
    }


    @Secured({"ROLE_ADMIN"})
    @GetMapping("/annoAdmin")
    public void doAdmin2() {

        log.info("......................admin annotaion only");
    }



}
