package org.zerock.controller;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;


@RestController
@Log4j
@RequestMapping("/replies/")
@AllArgsConstructor
public class ReplyController {
    private ReplyService service;


    /*
    * REST방식으로 등록처리할 때 주의점
    *
    * 요청시 받아올 데이터포맷 consumes = "application/json"
    * 응답시 보내줄 데이터타입 produces = {MediaType.TEXT_PLAIN_VALUE}
    *
    * MIME타입에 맞게 명확히 명시해야한다.
    * 그리고 RespnseEntity를 이용해서 처리결과를 담아보내서 ---> [HTTP 상태코드]로 알아볼 수 있게 한다.
    * */


    @PostMapping(value = "/new"
        ,consumes = "application/json"
        ,produces = {MediaType.TEXT_PLAIN_VALUE})
    public ResponseEntity<String> create(@RequestBody ReplyVO vo){  // ---> @ResponseBody로 json객체로 받아옴

        log.info("ReplyVO : "+vo);
        int insertCount = service.register(vo);

        log.info("Reply INSERT COUNT : "+insertCount);

        //삼항연산자처리
        return insertCount == 1 ?
                  new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    //create()는 POST방식으로만 처리되도록 & 실행결과를 문자열로(HttpStatus) 반환하도록 !
    // @PostMapping(value="주소",consumes="받아올데이터포맷",produces = {MediaType지정})


    //댓글조회
  /*  @GetMapping("/pages/{bno}/{page}")
    public ResponseEntity<List<ReplyVO>> getList(
            @PathVariable("page") int page, @PathVariable("bno") Long bno){
        log.info("getList..........");
        Criteria cri = new Criteria(page,10);


        log.info(cri);
        ResponseEntity<List<ReplyVO>> responseEntity = new ResponseEntity<>(service.getList(cri,bno),HttpStatus.OK);
        log.info(responseEntity);
        return responseEntity;

    }*/

    /********************************************************************************************/
    //{rno}받아서 댓글 삭제 --> 똑같이 "/{rno}"로 요청들어오는데 삭제할 수 있는 이유?
/*
    @GetMapping(value = "/{rno}",
            produces = {MediaType.APPLICATION_XML_VALUE
                    ,MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
        log.info("getMapping으로 들어옴 ---------- get: "+rno);

        return new ResponseEntity<>(service.get(rno),HttpStatus.OK);

    }*/

   @DeleteMapping(value = "/{rno}",produces = {MediaType.TEXT_PLAIN_VALUE})
    public ResponseEntity<String> remove(@PathVariable("rno")Long rno){
        log.info("DeleteMapping으로 들어옴 ------------ remove : "+rno);

        //삼항연산자 이용
        return service.remove(rno)==1
        ? new ResponseEntity<> ("success",HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

     /************************ @GetMapping 이랑 @DeleteMapping 다시보기 *******************************/

     @RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH}
             ,value = "/{rno}"
             ,consumes = "application/json",produces = {MediaType.TEXT_PLAIN_VALUE})
     public ResponseEntity<String> modify(
            @RequestBody ReplyVO vo, @PathVariable("rno") Long rno){
        vo.setRno(rno);
        log.info("rno : "+rno);
        log.info("modify : "+vo);

        return service.modify(vo) == 1
                ? new ResponseEntity<>("success",HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
     }


     //댓글 조회 + 페이징추가
    @GetMapping(value = "/pages/{bno}/{page}"
    ,produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<ReplyPageDTO> getList(@PathVariable("page") int page, @PathVariable("bno")Long bno){
         Criteria cri = new Criteria(page,10);
         log.info("get Reply List bno : "+bno);
         log.info("cri : "+cri);
         return new ResponseEntity<>(service.getListPage(cri,bno),HttpStatus.OK);

    }
}
