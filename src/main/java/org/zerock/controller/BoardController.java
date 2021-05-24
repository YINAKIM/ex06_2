package org.zerock.controller;


import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor // 이 클래스에 선언된 필드의 생성자를 만들고 자동으로 주입한다
public class BoardController {


    private BoardService service;
/*
    @GetMapping("/list")
    public void list(Model model){
        log.info("list");
        model.addAttribute("list",service.getList());
    }
*/

    @GetMapping("/list")
    public void list(Criteria cri, Model model){
        log.info(" /list 들어옴 ---> pageNum:"+cri.getPageNum()+", amount: "+cri.getAmount());



        model.addAttribute("list",service.getList(cri));
        //model.addAttribute("list",service.getList(cri));
        /*
        http://localhost:8000/board/list?pageNum=2&amount=10
        http://localhost:8000/board/list?pageNum=3&amount=10
        http://localhost:8000/board/list?pageNum=3&amount=20
        http://localhost:8000/board/list?pageNum=3&amount=5
        => 전부 출력됨
        */
        int total = service.getTotal(cri);
        log.info("getTotal-----> "+total);

        //PageDTO의 페이징처리 로직활용 -> 페이징용 필드들 넘김
        model.addAttribute("pageMaker",new PageDTO(cri, total)); //전체데이터 ROW 추가
       // model.addAttribute("pageMaker",new PageDTO(cri, 250));


    }

    //등록작업을 위해 입력받을 화면을 보여주는건 GET
    @GetMapping("/register")
    public void register(){

    }

    // 등록 작업은 POST
    @PostMapping("/register")
    public String register(BoardVO board, RedirectAttributes rttr){
        log.info("register : "+ board);
        service.register(board);
        rttr.addFlashAttribute("result",board.getBno());
        rttr.addFlashAttribute("result2",board.getBno());
        return "redirect:/board/list";
    }
        /*
            [ 등록작업 (수정작업 포함 POST작업 시) redirect ]

            Q. POST로 update작업을 처리할 때 redirect로 이동시키지 않으면 ?

            A. 브라우저의 새로고침을 통해 동일한 내용을 서버에 반복요청할 수 있고,
               반복 등록작업이 실행, 흔히 도배라고 표현하는 문제가 발생
               (브라우저에서 경고창보여주긴 하지만 근본적으로 차단하는 것은 X)

            SOL.  그러므로 등록/수정/삭제 작업을 처리가 완료된 후 다시 동일내용을 전송할 수 없도록 아예 브라우저의 URL을 이동
                  => 이 과정에서 작업의 결과를 바로 알 수 있도록 피드백을 줘야한다. => 경고참/모달창 등 이용

            [+] RedirectAttributes.addFlashAttribute  VS  org.springframework.ui.Model.addAttribute

                org.springframework.ui.Model 을 상속받는
                RedirectAttributes [I]의 addFlashAttribute  => 일회성으로만 데이터를 전달
                                                           => 내부적으로는 HttpSession을 이용해서 처리,
                                                              addFlashAttribute()에 보관된 데이터는 단 한번만 사용할 수 있게 보관됨

            [?] 그럼 새로고침할 때 그 값은 다시 쓸 수 없게 증발
                https://www.notion.so/Hash-e5069952773c471ea200dcacf1fe2f01

                [?] 근데 왜 블로그 찾아보면 2개이상 보내면 안된다고 하는거지? 2개이상 담아도  잘가는데 왜안된다고하는거지? -> 5.0에서 테스트했는데 파라미터 전달되고 값도 읽음

        */


    // 번호로 조회페이지
    @GetMapping({"/get","/modify"})
    public void get(@RequestParam("bno")Long bno, Model model,
                    @ModelAttribute("cri") Criteria cri){
        log.info("/get or /modify");
        model.addAttribute("board",service.get(bno));
    }

    //수정 처리 : 수정작업 시작화면은 GET, 실제 수정작업은 POST
    @PostMapping("/modify")
    public String modify(BoardVO board, RedirectAttributes rttr,@ModelAttribute("cri") Criteria cri){

        log.info("####### modify : "+board);

        //수정 성공하면 true리턴, int로 받을 수 있지만 정확히 하려고 bool로 리턴하도록 했음
        if (service.modify(board)){
            rttr.addFlashAttribute("result","success"); //
        }

        //왔던 페이지번호로 돌아가기 위해 받아온 Criteria 필드들
        rttr.addAttribute("pageNum",cri.getPageNum());
        rttr.addAttribute("amount",cri.getAmount());

        // 검색조건도 담아줘야됨 --> js에서도
        rttr.addAttribute("type",cri.getType());
        rttr.addAttribute("keyword",cri.getKeyword());
        return "redirect:/board/list"; //수정 성공 후 list로 redirect
    }


    // 삭제는 반드시 POST처리!
    @PostMapping("/remove")
    public String remove(@RequestParam("bno")Long bno, RedirectAttributes rttr,@ModelAttribute("cri") Criteria cri){
        log.info("remove............"+bno);
        if(service.remove(bno)){
            rttr.addFlashAttribute("result","success");

            //삭제 후 페이지 이동이 필요하므로 RedirectAttributes rttr 사용
        }


        //왔던 페이지번호로 돌아가기 위해 받아온 Criteria 필드들
        rttr.addAttribute("pageNum",cri.getPageNum());
        rttr.addAttribute("amount",cri.getAmount());

        // 검색조건도 담아줘야됨
        rttr.addAttribute("type",cri.getType());
        rttr.addAttribute("keyword",cri.getKeyword());

        return "redirect:/board/list";
    }

    /*
        addFlashAttribute
        redirect할 때 데이터를 전달할 수 있음, String, Object 다 올수있음

        addAttribute와 다른 점
        일회성 값 전달, URL에 붙지 않고 세션 후 재지정 요청이 들어오면 값은 사라진다.

        redirect시 RedirectAttributes 클래스를 이용해 효과적으로 alert창을 띄울수도 있다.
    */
}
