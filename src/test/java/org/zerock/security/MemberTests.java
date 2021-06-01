package org.zerock.security;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.sql.DataSource;

import com.zaxxer.hikari.HikariDataSource;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
        "file:src/main/webapp/WEB-INF/spring/applicationContext.xml",
        "file:src/main/webapp/WEB-INF/spring/security-context.xml"
})
@Log4j
public class MemberTests {

    @Setter(onMethod_ = @Autowired)
    private PasswordEncoder pwencoder;


    @Setter(onMethod_ = @Autowired)
    private DataSource ds;
  //  private HikariDataSource hikariDataSources;

    // 히카리 없애고 기본 dataSource로 테스트
    @Test
    public void testGetConnection() throws SQLException {


        // 히카리 없애고 기본 dataSource로 테스트
        /*
        INFO : org.zerock.security.MemberTests - 데이터소스 잘 가져옴
        INFO : jdbc.connection - 1. Connection opened
        INFO : jdbc.audit - 1. Connection.new Connection returned
        INFO : jdbc.audit - 1. PreparedStatement.new PreparedStatement returned
        INFO : jdbc.audit - 1. Connection.prepareStatement(insert into tbl_member(userid, userpw, username) values (?,?,?)) returned net.sf.log4jdbc.sql.jdbcapi.PreparedStatementSpy@45658133
        INFO : jdbc.audit - 1. PreparedStatement.setString(2, "$2a$10$2Is8/M2l8Fdjb9T0ATgD7uDZUuItZd5yJdFqjrAT4g1LzYNLLE6la") returned
        INFO : jdbc.audit - 1. PreparedStatement.setString(1, "test") returned
        INFO : jdbc.audit - 1. PreparedStatement.setString(3, "test사용자") returned
        INFO : jdbc.connection - 1. Connection closed
        INFO : jdbc.audit - 1. Connection.close() returned


        => 하도 안되서 DataSource를 단독으로 추가하고, 마이바티스에서 참조하는건 주석처리하고, 히카리도 살려놓고
        [결과적으로 둘다 넣어놨을 때]잘된다 .. 결국 dataSource가 두개여서 NoUniqueBeanDefinitionException이 나온건... 왜지?
        그냥 여기서 쓰려는 javax.sql.DataSource가 빈등록이 안되어있었던건데?
        근데 얘 이름도 javax꺼 아니고 org.springframework에 속하는 기본 드라이버매니저 데이터소스다

        ============================================================================================
        <bean id="hikariConfig" class="com.zaxxer.hikari.HikariDataSource">
        <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        ============================================================================================

        근데 이상한건
        org.springframework.jdbc.datasource.DriverManagerDataSource 이거 없을 때는 안됬었다..
        이 MemberTest에서 주입받는 DataSource는 클래스가 다른데?
        javax.sql public interface DataSource extends javax.sql.CommonDataSource, java.sql.Wrapper
        라고 되어있는걸 보니, org.springframework.jdbc.datasource.DriverManagerDataSource도 얘를 상속받거나 하는거같음..

        결론은 여기서 주입받으려는 javax.sql의 DataSource 인터페이스가 빈등록이 안되어있어서 그랬던건데,
        왜 NoUniqueBeanDefinitionException이 나왔는지는 모르겠다 ..
        NoUniqueBeanDefinitionException: No qualifying bean of type ‘javax.sql.DataSource’ available
        : expected single matching bean but found 2: hikariConfig,dataSource

        빈등록이 안되서 UnsatisfiedDependencyException 이 나왔었는데 그건 빈등록이 안되었었으니까 알겠음
        근데 NoUniqueBeanDefinitionException : expected single matching bean but found 2: hikariConfig,dataSource 이건 왜나옴...?

        ERROR: org.springframework.test.context.TestContextManager - Caught exception while allowing TestExecutionListener
        [org.springframework.test.context.support.DependencyInjectionTestExecutionListener@2e55dd0c]
        to prepare test instance [org.zerock.security.MemberTests@b3e86d5]
        org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name ‘org.zerock.security.MemberTests’
        : Unsatisfied dependency expressed through method ‘setDs’ parameter 0;
        nested exception is org.springframework.beans.factory.NoUniqueBeanDefinitionException
        : No qualifying bean of type ‘javax.sql.DataSource’ available
        : expected single matching bean but found 2: hikariConfig,dataSource

        암튼 앞으로 ConnectionPool안쓰고 테스트할 일이 생기면
        javax.sql.DataSource(인터페이스) 로 주입받을 수 있는 기본 데이터소스매니저인 DriverManagerDataSource를 등록해서 쓰자 ..
        ============================================================================================
        <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        ============================================================================================
        */


        String sql = "insert into tbl_member(userid, userpw, username) values (?,?,?)";
            Connection con = null;
            PreparedStatement pstmt = null;
        try {
            log.info("데이터소스 잘 가져옴");
            con = ds.getConnection();
            //con = hikariDataSources.getConnection();

            pstmt = con.prepareStatement(sql);

            pstmt.setString(2, pwencoder.encode("pw" + "test2"));//

            pstmt.setString(1, "test2");
            pstmt.setString(3,"test사용자2");

        }catch (Exception e){
            e.printStackTrace();
            log.info("데이터소스 못가져옴!!");

        }finally {
            con.close();
        }

    }

    @Test
    public void testInsertMember() {

        String sql = "insert into tbl_member(userid, userpw, username) values (?,?,?)";

        for(int i = 0; i < 100; i++) {

            Connection con = null;
            PreparedStatement pstmt = null;

            try {
                con=ds.getConnection();
                //con = hikariDataSources.getConnection();
                pstmt = con.prepareStatement(sql);

                pstmt.setString(2, pwencoder.encode("pw" + i));

                if(i <80) {

                    pstmt.setString(1, "user"+i);
                    pstmt.setString(3,"일반사용자"+i);

                }else if (i <90) {

                    pstmt.setString(1, "manager"+i);
                    pstmt.setString(3,"운영자"+i);

                }else {

                    pstmt.setString(1, "admin"+i);
                    pstmt.setString(3,"관리자"+i);

                }

                pstmt.executeUpdate();

            }catch(Exception e) {
                e.printStackTrace();
            }finally {
                if(pstmt != null) { try { pstmt.close();  } catch(Exception e) {} }
                if(con != null) { try { con.close();  } catch(Exception e) {} }

            }
        }//end for
    }

    @Test
    public void testInsertAuth() {


        String sql = "insert into tbl_member_auth (userid, auth) values (?,?)";

        for(int i = 0; i < 100; i++) {

            Connection con = null;
            PreparedStatement pstmt = null;

            try {
                con=ds.getConnection();
                //con = hikariDataSources.getConnection();
                pstmt = con.prepareStatement(sql);


                if(i <80) {

                    pstmt.setString(1, "user"+i);
                    pstmt.setString(2,"ROLE_USER");

                }else if (i <90) {

                    pstmt.setString(1, "manager"+i);
                    pstmt.setString(2,"ROLE_MEMBER");

                }else {

                    pstmt.setString(1, "admin"+i);
                    pstmt.setString(2,"ROLE_ADMIN");

                }

                pstmt.executeUpdate();

            }catch(Exception e) {
                e.printStackTrace();
            }finally {
                if(pstmt != null) { try { pstmt.close();  } catch(Exception e) {} }
                if(con != null) { try { con.close();  } catch(Exception e) {} }

            }
        }//end for
    }


}


