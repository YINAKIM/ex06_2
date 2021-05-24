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
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/applicationContext.xml")
public class SampleTxServiceTests {
    @Setter(onMethod_ = {@Autowired})
    private  SampleTxService service;

    @Test
    public  void testLong(){
        String str = "Starry\r\n"+"Starry night\r\n"
                +"Paint your palette blue and prey\r\n"
                +"Look out on a summer's day";

        log.info(str.getBytes().length);
        service.addData(str);
        /*
        -----TBL_SAMPLE1-----> col1가 VARCHAR2(500)이라서 updateCount() : 1 반환
        INFO : jdbc.sqltiming - insert into tbl_sample1(col1) values('Starry Starry night Paint your palette blue and prey
        Look out on a summer''s day')
        {executed in 9 msec}
        INFO : jdbc.audit - 1. PreparedStatement.execute() returned false
        INFO : jdbc.audit - 1. PreparedStatement.getUpdateCount() returned 1


        -----TBL_SAMPLE1-----> col2가 VARCHAR2(50)이라서 UncategorizedSQLException,java.sql.SQLException: ORA-12899:  too large for column
        org.springframework.jdbc.UncategorizedSQLException:
        ### Error updating database.  Cause: java.sql.SQLException: ORA-12899: value too large for column "BOOK_EX"."TBL_SAMPLE2"."COL2" (actual: 82, maximum: 50)

        ### The error may exist in org/zerock/mapper/Sample2Mapper.java (best guess)
        ### The error may involve org.zerock.mapper.Sample2Mapper.insertCol2-Inline
        ### The error occurred while setting parameters
        ### SQL: insert into tbl_sample2(col2) values (?)
        ### Cause: java.sql.SQLException: ORA-12899: value too large for column "BOOK_EX"."TBL_SAMPLE2"."COL2" (actual: 82, maximum: 50)

        ; uncategorized SQLException; SQL state [72000]; error code [12899]; ORA-12899: value too large for column "BOOK_EX"."TBL_SAMPLE2"."COL2" (actual: 82, maximum: 50)
        ; nested exception is java.sql.SQLException: ORA-12899: value too large for column "BOOK_EX"."TBL_SAMPLE2"."COL2" (actual: 82, maximum: 50)


        => TBL_SAMPE1에만 insert완료됨
        => tx적용 전이라서 데이터길이 맞는 col1에는 insert 실행 후 Auto commit
        */

    }


    // @Transactional 사용한 결과
    /*
    INFO : jdbc.audit - 1. Connection.setAutoCommit(false) returned
    INFO : org.zerock.service.SampleTxServiceImpl - mapper1.........................
    INFO : jdbc.audit - 1. Connection.getAutoCommit() returned false ===================================================> AutoCommit false 해두고 쿼리실행


    ---------------------1실핼
    INFO : jdbc.sqltiming - insert into tbl_sample1(col1)
    values('Starry Starry night Paint your palette blue and prey
    Look out on a summer''s day')
     {executed in 6 msec}
    INFO : jdbc.audit - 1. PreparedStatement.execute() returned false
    INFO : jdbc.audit - 1. PreparedStatement.getUpdateCount() returned 1

    ---------------------2실행
    INFO : org.zerock.service.SampleTxServiceImpl - mapper2.........................
    .
    .
    .
    INFO : jdbc.audit - 1. PreparedStatement.close() returned
    INFO : jdbc.audit - 1. Connection.getMetaData() returned oracle.jdbc.driver.OracleDatabaseMetaData@3e587920
    INFO : jdbc.audit - 1. Connection.rollback() returned                ===============================================> rollback()함 !!!!
    INFO : jdbc.audit - 1. Connection.setAutoCommit(true) returned       ===============================================> rollback한걸 AutoCommit함
    INFO : jdbc.audit - 1. Connection.clearWarnings() returned

    */

    /*
    [ @Transactional 의 속성(전파, 격리, Read-Only, Rollback-for, No-rollback-for) ]

    [1] Propagation, 전파속성
    (기본) PROPAGATION_REQURED : 트랜잭션이 있으면 그 상황에서 실행, 없으면 새로운 트랜잭션 실행
    PROPAGATION_MADATORY : 작업은 받으시 특정트랜잭션이 존재한 상태에서만 가능하다
    PROPAGATION_NESTED : 기존에 트랜잭션이 있는 경우, 포함되어서 실행한다
    PROPAGATION_NEVER : 트랜잭션 상황하에 실행되면 예외발생
    PROPAGATION_SUPPORTED : 트랜잭션이 있는경우, 트랜잿견이 끝날 때 까지 부류 후 실행
    PROPAGATION_REQURED_NEW : 대상은 자신만의 고유한 트랜잭션으로 실행한다
    PROPAGATION_SUPPORTS : 트랜잭션을 필요로 하지는 않으나, 트랜잭션 상황 하에 있다면 포함되어서 실행한다

    [2] Isolation, 격리레벨
    (기본) DEFAULT : DB설정, 기본격리수준(기본설정)
    SERIALIZABLE : 가장 높은 격리, 성능 저하의 우려가 있음
    READ_UNCOMMITED : 커밋되지 않은 데이터에 대한 읽기를 허용
    READ_COMMITED : 커밋된 데이터에 대해 읽기를 허용
    REPEATABLE_READ : 동일 필드에 대해 다중 접근 시 모두 동일한 결과를 보장한다.

    [3] Read-Only 속성 : 기본설정은 false , true지정 시 insert, update, delete 실행 시 예외발생
    [4] Rollback-for-예외 : 특정 예외 발생시 강제 Rollback
    [5] No-rollback-for-예외 : 특정 예외 발생시에는 Rollback 처리되지 않음


    [ @Transactional 의 적용규칙 ]
    1-2 순서로 설정해서 사용할 수 있는데 규칙대로 적용된다

    1. applicationContext에
       트랜잭션매니저를 dataSource로 빈등록, tx어노테이션사용 설정, xml스키마 추가는 꼭 자동완성으로 할 것(~~/cache" 주의!!)
       ( xmlns:tx="http://www.springframework.org/schema/tx" )
    -------------------------------------------------------------
    <!--  트랜잭션 매니저  -->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"></property>
    </bean>

    <!--  어노테이션기반으로 트랜잭션을 설정할 수 있도록 하는 태그-->
    <tx:annotation-driven></tx:annotation-driven>
    -------------------------------------------------------------

    2. @Transactional 사용 : 메서드에 , 클래스, 인터페이스 에 선언가능하다
    [우선순위]
    no1) 메서드의 @Transactional (최상)
    no2) 클래스의 @Transactional
    no3) 인터페이스의 @Transactional (최하)
    => 인터페이스에 가장 기준이 되는 @T를 지정하소, 클래스나 메서드에 필요한 어노테이션을 처리하는 것이 이상적이다.
    */

}
