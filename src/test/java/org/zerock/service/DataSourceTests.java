package org.zerock.service;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.sql.DataSource;
import java.sql.Connection;

import static org.junit.Assert.fail;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/applicationContext.xml")
@Log4j
public class DataSourceTests {
    @Setter(onMethod_ = { @Autowired } )
    private DataSource dataSource;

    @Test
    public void testConnection(){
        //실행결과 : Bean으로 등록 된 DataSource를 이용해서 Connection을 제대로 처리할 수 있는지
        try(Connection con = dataSource.getConnection()){
            log.info(con);
        }catch (Exception e){
            fail(e.getMessage());
        }
    }

}
