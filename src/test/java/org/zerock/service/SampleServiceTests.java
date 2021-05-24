package org.zerock.service;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@Log4j
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/applicationContext.xml"})
public class SampleServiceTests {

    @Setter(onMethod_ = {@Autowired})
    private SampleService service;

    @Test
    public void testClass(){
        log.info(service);
        log.info(service.getClass().getName());

        /*
        [testClass에서 확인할 것]
        AOP설정을 한 Target에 대해 Proxy객체가 정상적으로 만들어지는지 확인!
        1) <aop:aspectj-autoproxy></aop:aspectj-autoproxy> 가 정상적으로 동작하고
        2) LogAdvice에 문제가 없다면
        =>
        private SampleService service; 변수의 클래스는
        (단순히 org.zerock.service.SampleServiceImpl의 인스턴스가 아닌) 생성된 Proxy클래스의 인스턴스가 된다.

            정상적으로 aop설정 되었다면 proxy 객체를 만든다
            INFO : org.zerock.service.SampleServiceTests - org.zerock.service.SampleServcieImpl@7ce69770
            INFO : org.zerock.service.SampleServiceTests - com.sun.proxy.$Proxy22
        */
    }

    @Test
    public void testAdd() throws Exception{
        log.info(service.doAdd("123","456"));
       /*
       @Before 테스트 결과
        ## logBefore로 찍힘
        INFO : org.zerock.aop.LogAdvice - ================================================

        ## logBeforeWithParam로 찍힘
        INFO : org.zerock.aop.LogAdvice - str1 : 123
        INFO : org.zerock.aop.LogAdvice - str2 : 456
        INFO : org.zerock.service.SampleServiceTests - 579
       */


        /*
        @Around 테스트 결과
        INFO : org.zerock.aop.LogAdvice - Target : org.zerock.service.SampleServcieImpl@304bb45b
        INFO : org.zerock.aop.LogAdvice - Param : [123, 456]
        INFO : org.zerock.aop.LogAdvice - ================================================
        INFO : org.zerock.aop.LogAdvice - str1 : 123
        INFO : org.zerock.aop.LogAdvice - str2 : 456
        INFO : org.zerock.aop.LogAdvice - TIME : 4
        INFO : org.zerock.service.SampleServiceTests - 579

        */
    }

    @Test
    public void testAddError()throws Exception{

        log.info(service.doAdd("123","ABC")); // 고의로 에러발생할 로그 찍음 <- @AfterThrowing 테스트위해
/*
    INFO : org.zerock.aop.LogAdvice - str1 : 123
    INFO : org.zerock.aop.LogAdvice - str2 : ABC
    INFO : org.zerock.aop.LogAdvice - Exception.........!!!
    INFO : org.zerock.aop.LogAdvice - Exception : java.lang.NumberFormatException: For input string: "ABC"

    java.lang.NumberFormatException: For input string: "ABC"
*/
    }
}
