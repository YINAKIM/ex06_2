package org.zerock.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.zerock.domain.SampleVO;
import org.zerock.domain.Ticket;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;


@RestController
@RequestMapping("/sample")
@Log4j
public class SampleController {


    // produces = "MIME 타입(보내는 자원의 Content-Type) 지정"  ---> 생략가능
    @GetMapping(value = "/getText",produces = "text/plain; charset=UTF-8")
    public String getText(){
        log.info("MIME TYPE을 알려줘 : "+ MediaType.TEXT_PLAIN_VALUE);
        return "안녕하세요";
    }

    @GetMapping(value = "/getSample"
            ,produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
    public SampleVO getSample(){
        return new SampleVO(112,"스타","로드");

        //http://localhost:8000/sample/getSample -> {"mno":112,"firstName":"스타","lastName":"로드"}
        //
    }

    @GetMapping(value = "/getSample2")
    public SampleVO getSample2(){
        log.info("getSample2!!!!");
        return new SampleVO(113,"로켓","라쿤");

    }



    //컬렉션 타입의 객체 반환 - List<E>
    @GetMapping(value = "/getList")
    public List<SampleVO> getList(){
        return IntStream.range(1,10)
                .mapToObj(i->new SampleVO(i,i+"First",i+"Last")
        ).collect(Collectors.toList());
        /*

        IntStream
        .range(1,10) ---> 1~9로 범위 지정
        .mapToObj(   ---> int스트림(원시스트림)을 객체스트림으로, 누적시킨 최종값을 반환
           i->new SampleVO(i,i+"First",i+"Last")
        )
        .collect(
           Collectors.toList()  ---> list에 최종 결과를 누적시킴
        )

      내부적으로 1~9까지 루프를 처리하면서 SampleVO를 만들고, List<SampleVO>로 만들어냄
      ===> URI에 .json형태로 처리하면 JSON형태의 []로 보임 (JSON배열)

      http://localhost:8004/sample/getList.json 요청

      [   {"mno":1,"firstName":"1First","lastName":"1Last"}
         ,{"mno":2,"firstName":"2First","lastName":"2Last"}
         ,{"mno":3,"firstName":"3First","lastName":"3Last"}
         ,{"mno":4,"firstName":"4First","lastName":"4Last"}
         ,{"mno":5,"firstName":"5First","lastName":"5Last"}
         ,{"mno":6,"firstName":"6First","lastName":"6Last"}
         ,{"mno":7,"firstName":"7First","lastName":"7Last"}
         ,{"mno":8,"firstName":"8First","lastName":"8Last"}
         ,{"mno":9,"firstName":"9First","lastName":"9Last"}  ]

         */
    }

    //컬렉션 타입의 객체 반환 - Map
    @GetMapping(value = "getMap")
    public Map<String, SampleVO> getMap(){
        Map<String, SampleVO> map = new HashMap<>();
        map.put("First",new SampleVO(111,"그루트","주니어"));
        //      < 키값은 String, new SampleVO 가 value >
        return map;
        /*
        * 요청 : /sample/getMap.json
        * {"First":{"mno":111,"firstName":"그루트","lastName":"주니어"}}
        *
        *  요청 : /sample/getMap
        *   여기서 Key값은 XML로 변환되는 경우 태그의 이름이 된다. 반드시! String으로 지정할 것! ==> Map<String, Object>
        * <Map>
            <First>
            <mno>111</mno>
            <firstName>그루트</firstName>
            <lastName>주니어</lastName>
            </First>
          </Map>
        * */

    }




    /* REST방식 호출에서 화면자체가 아니라 데이터 자체를 전송하는 방식으로 처리된다.
       => 요청한 쪽에서는 정상적인 데이터인지 비정상데이터인지 구분할 수 잇는 확실한 방법을 제공해야한다.
       그 방법이 ===> HTTP헤더의 [상태코드 + 에러메시지]를 같이 전달 : ResponseEntity
    */
    @GetMapping(value = "/check",params = {"height","weight"})
    public ResponseEntity<SampleVO> check(Double height, Double weight){
        SampleVO vo = new SampleVO(0," "+height," "+weight);
        ResponseEntity<SampleVO> result =  null;

        if(height < 150){
            result = ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(vo);    // 상태메시지 "BAD_GATEWAY" 담아보냄
                                           // 502 에러 : 서버가 게이트웨이나 프록시 서버 역할을 하면서
                                          //            업스트림 서버로부터 유효하지 않은 응답을 받았다는 것
            /*
              General
              Request URL: http://localhost:8004/sample/check?height=140&weight=60
                           http://localhost:8004/sample/check.json?height=140&weight=60

              Request Method: GET
              Status Code: 502

              Response Header
              Content-Type: application/xhtml+xml;charset=UTF-8 --> xml로 요청
              Content-Type: application/json;charset=UTF-8 --> json으로 요청 했을 때
            */
        }else{
            result = ResponseEntity.status(HttpStatus.OK).body(vo);    // 상태메시지 "OK" 담아보냄
                                          // 200 OK
                                            // .body(vo) : 결과데이터를 body에 담아 리턴
            /*
            General
            Request URL: http://localhost:8004/sample/check.json?height=160&weight=60
            Request Method: GET
            Status Code: 200
            */
        }

        return result;
    }


    // @RestController의 파라미터
    @GetMapping("/product/{cat}/{pid}")     //  쿼리스트링 ?뒤에 변수들이 아니라 URL자체에 데이터를 식별할 수 있는 정보들을 표현
    public String[] getPath( @PathVariable("cat") String cat, @PathVariable("pid") String pid){
        //@PathVariable로 파라미터 지정 ==> {변수명}

        return new String[] {"category : "+cat, "productId : "+pid};
        /*
        요청 : /sample/product/coffee/123

        <Strings>
            <item>category : coffee</item>
            <item>productId : 123</item>
        </Strings>

        json 요청 : /sample/product/coffee/123.json
        ["category : coffee","productId : 123"]

        */
    }


    // @RequestBody : 전달된 요청 내용을 이용해서 해당 파라미터의 타입으로 변환 요구 / 대부분json형태를 서버에 보내서 원하는 타입의객체로 변환,
    @PostMapping("/ticket")
    public Ticket convert(@RequestBody Ticket ticket){
        log.info("convert.................ticket:"+ticket);
        return ticket;
    }// REST방식의 테스트로 진행 : SampleControllerTests.java 의 ---> testConvert() 에 테스트흐름,결과 정리해둠

}
