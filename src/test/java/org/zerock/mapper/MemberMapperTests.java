package org.zerock.mapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.zerock.domain.MemberVO;

@RunWith(SpringRunner.class)
@ContextConfiguration({
        "file:src/main/webapp/WEB-INF/spring/applicationContext.xml",
        "file:src/main/webapp/WEB-INF/spring/security-context.xml"
})
@Log4j
public class MemberMapperTests {
    @Setter(onMethod_ = @Autowired)
    private MemberMapper mapper;

    @Test
    public void testRead(){
        MemberVO vo = mapper.read("admin90");
        log.info("testRead===========");
        log.info(vo);

        vo.getAuthList().forEach(authVO -> log.info(authVO));

    }
/*

INFO : org.zerock.mapper.MemberMapperTests - testRead===========
INFO : org.zerock.mapper.MemberMapperTests - MemberVO(userid=admin90, userpw=$2a$10$1hX3MnLTP2GHHgX.Hwlr/u81S3AGLm61tVbTBHwUbJ/PMA2N9lk36, userName=관리자90, enabled=false, regDate=Tue Jun 01 11:29:08 KST 2021, updateDate=Tue Jun 01 11:29:08 KST 2021, authList=[AuthVO(userid=admin90, auth=ROLE_ADMIN)])
INFO : org.zerock.mapper.MemberMapperTests - AuthVO(userid=admin90, auth=ROLE_ADMIN)

.
.
INFO : jdbc.audit - 1. PreparedStatement.setString(1, "admin90") returned
INFO : jdbc.sqlonly - SELECT MEM.USERID ,USERPW ,USERNAME ,ENABLED ,REGDATE ,UPDATEDATE ,AUTH FROM TBL_MEMBER MEM
LEFT OUTER JOIN TBL_MEMBER_AUTH AUTH ON MEM.USERID = auth.USERID WHERE MEM.USERID = 'admin90'
.
.
INFO : jdbc.resultsettable -
|--------|-------------------------------------------------------------|---------|---------|----------------------|----------------------|-----------|
|userid  |userpw                                                       |username |enabled  |regdate               |updatedate            |auth       |
|--------|-------------------------------------------------------------|---------|---------|----------------------|----------------------|-----------|
|admin90 |$2a$10$1hX3MnLTP2GHHgX.Hwlr/u81S3AGLm61tVbTBHwUbJ/PMA2N9lk36 |관리자90    |[unread] |2021-06-01 11:29:08.0 |2021-06-01 11:29:08.0 |ROLE_ADMIN |
|--------|-------------------------------------------------------------|---------|---------|----------------------|----------------------|-----------|*/
}
