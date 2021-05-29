package org.zerock.controller;


import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.zerock.domain.Ticket;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration // Controller 테스트할 때
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/appServlet/dispatcher-servlet.xml"
        ,"file:src/main/webapp/WEB-INF/spring/applicationContext.xml"})
@Log4j
public class SampleControllerTests {
    @Setter(onMethod_ = {@Autowired})
    private WebApplicationContext ctx;

    private MockMvc mockMvc;

    @Before
    public void setup(){
        this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
    }

    @Test
    public void testConvert() throws Exception{
        Ticket ticket = new Ticket();
        ticket.setTno(123);
        ticket.setOwner("Admin");
        ticket.setGrade("AAA");

       /* String jsonStr = new Gson().toJson(ticket); // Java Obj ---> JSON문자열

        log.info(jsonStr);

        mockMvc.perform(post("/sample/ticket").contentType(MediaType.APPLICATION_JSON)
                .content(jsonStr)).andExpect(status().is(200));*/

    }
    /*
     * [ SampleController에 작성한 convert()핸들러 테스트 ]
     * SampleController의 convert() : JSON데이터를 받아서 ---> Ticket타입으로 변환한다.
     *                               (@RequestBody로 받은 Ticket)
     * ==> JSON을 넣어줘야함 : testConvert()에서 Gson이 [Java Obj ---> JSON문자열]
     * ===> convert()가 받는 데이터가 JSON이라고 명시해줘야함 : testConvert()에서 contentType(MediaType.APPLICATION_JSON)
     *
     * [결과]=> convert()는 APPLICATION_JSON타입이라는걸 알고 / JSON문자열을 받아서 / Ticket타입으로 변환해서 / return ticket

     INFO : org.zerock.controller.SampleControllerTests - {"tno":123,"owner":"Admin","grade":"AAA"}
     INFO : org.zerock.controller.SampleController - convert.................ticket:Ticket(tno=123, owner=Admin, grade=AAA)

     */

}
