package org.zerock.aop;

import lombok.extern.log4j.Log4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;

import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import java.util.Arrays;

@Aspect // 이클래스의 객체가 Aspect를 구현할 것이다 알림
@Log4j
@Component  // AOP와는 노상관, 스프링에서 Bean으로 인식하기 위해 사용
public class LogAdvice {

    //     pointcut설정 (여기*은 접근제한자라서 하나띄어야함)
    @Before("execution(* org.zerock.service.SampleService*.*(..))")
    public void logBefore(){
        log.info("================================================");
    }


                                                                                //파라미터타입에 맞는 변수 지정
    @Before("execution(* org.zerock.service.SampleService*.doAdd(String, String)) && args(str1,str2)")
    public void logBeforeWithParam(String str1, String str2){
        log.info("str1 : "+str1);
        log.info("str2 : "+str2);
    }

    @AfterThrowing(pointcut="execution(* org.zerock.service.SampleService*.*(..))"
            ,throwing = "exception")
    public void logException(Exception exception){
        log.info("Exception.........!!!");
        log.info("Exception : "+exception);
    }

    @Around("execution(* org.zerock.service.SampleService*.*(..))")
    public Object logTime(ProceedingJoinPoint pjp){
        long start = System.currentTimeMillis();

        log.info("Target : "+pjp.getTarget());
        log.info("Param : "+ Arrays.toString(pjp.getArgs()));

        //invoke Method
        Object result = null;
        try{
            result = pjp.proceed();
        }catch(Throwable e){
            e.printStackTrace();
        }

        long end = System.currentTimeMillis();
        log.info("TIME : "+(end-start));

        return result;

    }
}

