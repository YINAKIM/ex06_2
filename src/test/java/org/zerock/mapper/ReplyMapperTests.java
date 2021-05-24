package org.zerock.mapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

import java.util.List;
import java.util.stream.IntStream;

@RunWith(SpringRunner.class)
@Log4j
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/applicationContext.xml")
public class ReplyMapperTests {

    @Setter(onMethod_ = {@Autowired})
    private ReplyMapper mapper;

    /*
     존재하는 게시물 번호 확인 OK
        425999
        425997
        425996
        425992
        425991
    */
    private Long[] bnoArr = {425999L, 425997L, 425996L, 425992L, 425991L};

    // 1. mapper가 연결되는지 테스트
    @Test
    public void testMapper(){
        log.info(mapper);
        // 일단 mapper가 연결되는지 테스트하는것 : 연결된다면 ---> MapperProxy@fc258b1 라는 빈이 생성되어 binding됨
        // INFO : org.zerock.mapper.ReplyMapperTests - org.apache.ibatis.binding.MapperProxy@fc258b1
    }


    // 2. insert테스트
    @Test
    public void testCreate(){
        IntStream.rangeClosed(1,10).forEach(i->{  // rangeClosed(1,10)는 1~10까지포함
                                                  // range(1,10)는 1~9까지만 포함

            ReplyVO vo = new ReplyVO();

            // 존재하는 게시물 번호로 테스트 : 425999, 425997, 425996, 425992, 425991...확인완료
            vo.setBno(bnoArr[i%5]);
            vo.setReply("댓글테스트"+i);
            vo.setReplyer("댓글replyer"+i);

            mapper.insert(vo);

            /*
                1,425997,댓글테스트1,댓글replyer1,2021-05-17 02:38:02,2021-05-17 02:38:02
                2,425996,댓글테스트2,댓글replyer2,2021-05-17 02:38:02,2021-05-17 02:38:02
                3,425992,댓글테스트3,댓글replyer3,2021-05-17 02:38:02,2021-05-17 02:38:02
                4,425991,댓글테스트4,댓글replyer4,2021-05-17 02:38:02,2021-05-17 02:38:02
                5,425999,댓글테스트5,댓글replyer5,2021-05-17 02:38:02,2021-05-17 02:38:02
                6,425997,댓글테스트6,댓글replyer6,2021-05-17 02:38:02,2021-05-17 02:38:02
                7,425996,댓글테스트7,댓글replyer7,2021-05-17 02:38:02,2021-05-17 02:38:02
                8,425992,댓글테스트8,댓글replyer8,2021-05-17 02:38:02,2021-05-17 02:38:02
                9,425991,댓글테스트9,댓글replyer9,2021-05-17 02:38:02,2021-05-17 02:38:02
                10,425999,댓글테스트10,댓글replyer10,2021-05-17 02:38:02,2021-05-17 02:38:02
            */
        });


    }
        
    //조회테스트
    @Test
    public void testRead(){
        Long targetRno = 1L; // 5번 댓글이 정상조회되는지 검색
//        Long targetRno = 5L; // 5번 댓글이 정상조회되는지 검색
        ReplyVO vo = mapper.read(targetRno);
        log.info(vo);
    }

    // 삭제테스트
    @Test
    public void testDelete(){
        Long targetRno = 17L;
        log.info(mapper.read(17L));
        mapper.delete(targetRno);
    }


    // 수정테스트
    @Test
    public void testUpdate(){
        Long targetRno = 1L;

        ReplyVO vo = mapper.read(targetRno);
        vo.setReply("update Reply");

        int count = mapper.update(vo);
        log.info("UPDATE COUNT : "+ count);
    }

    // [mapper.java]에서 @Param으로 선언한 @Param("bno") ---> [mapper.xml]에서 파라미터 받는 #{bno} : 매칭된다는 것에 주목
    @Test
    public void testList(){
        Criteria cri = new Criteria();

        List<ReplyVO> replies = mapper.getListWithPaging(cri, bnoArr[0]); //425999L
        replies.forEach(reply -> log.info(reply));
    }

    @Test
    public void tsetList2(){
        Criteria cri = new Criteria(2,10);

        // bno=425999L 로 2페이지에 해당되는 댓글 나오나 확인
        List<ReplyVO> replies = mapper.getListWithPaging(cri, 425999L);
        replies.forEach(reply->log.info(reply));
    }

}
