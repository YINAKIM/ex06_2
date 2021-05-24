package org.zerock.service;


import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.mapper.TimeMapper;

@RunWith(SpringJUnit4ClassRunner.class)

@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/applicationContext.xml")
@Log4j
public class TimeMapperTests {

    @Setter(onMethod_ = @Autowired)
    private TimeMapper timeMapper;

    //mapper.java 작성해서 테스트
    @Test
    public void testGetTime(){
        log.info(timeMapper.getClass().getName()); // 실제 동작하는 클래스 이름 : com.sun.proxy.$Proxy20
        log.info(timeMapper.getTime());  //2021-04-29 12:28:33.0
        System.out.println("-----testGetTime-----");
    }


    //mapper.xml 작성해서 테스트
    @Test
    public void testGetTime2(){
        System.out.println("-----testGetTime2-----");
      log.info("getTime2");
      log.info(timeMapper.getTime2());
    }
}
