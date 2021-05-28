<%--
  Created by IntelliJ IDEA.
  User: kim-yina
  Date: 2021/05/08
  Time: 10:46 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../includes/header.jsp"%>




<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Forms</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->


<%-- 게시물 보여지는 div --%>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">

            <div class="panel-heading">Board Read Page</div>

            <div class="panel-body">
                <div class="row">
                    <div class="col-lg-6">

            <%-- hidden값 보내기
                 1. modify작업을 위한  bno
                 2. list로 다시 이동 시) 1페이지가 아니라
                    내가 보고있던 그 페이지로 다시 이동하기 위해 받아왔던 Criteria에 들어가는
                    pageNum ,amount
            --%>
            <form id="operForm" action="/board/modify" method="get">
                <input type="hidden" id="bno" name="bno" value="<c:out value='${board.bno}'/>">
                <input type="hidden" id="pageNum" name="pageNum" value="<c:out value='${cri.pageNum}'/>">
                <input type="hidden" id="amount" name="amount" value="<c:out value='${cri.amount}'/>">

                <input type="hidden" id="type" name="type" value="<c:out value='${cri.type}'/>">
                <input type="hidden" id="keyword" name="keyword" value="<c:out value='${cri.keyword}'/>">

            </form>

<%--  모달창  --%>
                <!-- Modal -->
                <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <h4 class="modal-title" id="myModalLabel">Reply Modal</h4>
                            </div>
                    <%--모달바디--%>
                            <div class="modal-body">

                                <div class="form-group">
                                    <label>Reply</label>
                                    <input class="form-control" name="reply" value="New Reply!!">
                                </div>

                                <div class="form-group">
                                    <label>Replyer</label>
                                    <input class="form-control" name="replyer" value="replyer">
                                </div>

                                <div class="form-group">
                                    <label>Reply</label>
                                    <input class="form-control" name="replyDate" value="">
                                </div>
                            </div>
                    <%--모달바디:e--%>
                            <div class="modal-footer">
                                <%-- 댓글 수정 Btn --%>
                                <button id="modalModBtn" type="button" class="btn btn-warning">댓글수정</button>

                                <%-- 댓글 삭제 Btn --%>
                                <button id="modalRemoveBtn" type="button" class="btn btn-danger">댓글삭제</button>

                                <%-- 댓글 추가 Btn --%>
                                <button id="modalRegisterBtn" type="button" class="btn btn-default" data-dismiss="modal">댓글등록</button>

                                <%-- 댓글 모달닫기 Btn --%>
                                <button id="modalCloseBtn" type="button" class="btn tbn-warning" data-dismiss="modal">Close</button>

                                <%-- 댓글 ?? Btn --%>
                                <button id="modalClassBtn" type="button" class="btn tbn-warning" data-dismiss="modal">Close</button>

                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>
                <!-- /.modal -->

<%--  모달창 :e  --%>




                <script type="text/javascript" src="/resources/js/reply.js"></script>
                <script type="text/javascript">
                    $(document).ready(function(){
                        console.log("==================");
                        console.log("JS TEST");

                        var bnoValue = '<c:out value="${board.bno}"/>';

                        /*************************************** 댓글 보여주기
                         * 브라우저에서 DOM처리가 끝나면 자동으로 showList()가 호출되면서
                         * <ul>태그 내에 내용으로 처리된다. 만일 1페이지가 아닌 경우, 기존의 <ul>에 <li>들이 추가되는 형태
                         *
                         *   [+] 모달 관련 객체들은 여러 함수에서 사용할 것 ------> 바깥쪽으로 빼두어 매번 jQuery를 호출하지 않도록 한다.
                         * */
                        var replyUL = $(".chat");

                        showList(1);

                        function showList(page){    // showList : 페이지번호를 받아서 리스트 보여줌
                            console.log("showList---->"+page);

                            replyService.getList(
                                {bno:bnoValue, page:page||1}    // 파라미터 없는 경우 페이지번호 1로 설정
                                ,function (replyCnt,list) {
                                    console.log("replyCnt : "+replyCnt);
                                    console.log("list : "+list);
                                    console.log(list);

                                    if(page == -1){     // 페이지번호가 -1이면 마지막페이지를 찾아서 다시 호출
                                                        // 사용자가 새로운 댓글을 추가하면 showList(-1)을 실행시키게함 (replyService.add()에서)
                                                        // => 우선 전체 댓글 숫자를 파악함 => 이후, 다시마지막페이지를 찾아서 이동시킴

                                        pageNum = Math.ceil(replyCnt/10.0);  // ceil() : 올림해서 int 반환
                                                                             // -> 총 댓글수가 10(지정한 amount)으로 나눠떨어지지 않을 경우 소수가 나오니까 올림해서 int 로
                                        showList(pageNum);
                                        return;
                                    }

                                    var str = "";
                                    if(list == null || list.length == 0){
                                        console.log("댓글리스트 null???");
                                        return;
                                    }

                                    for(var i=0, len = list.length || 0; i<len; i++){
                                        console.log("[i] 번 댓글 보여주기+++++++++++++++++++++++++++++++++++++++++++++++++");
                                        str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
                                        str += "<div><div class='header'><strong class='primary-font'>"+list[i].replyer+"</strong>";
                                        str += "<small class='pull-right text-muted'>"+list[i].replyDate+"</small></div>";
                                        str += "<p>"+list[i].reply+"<p></div></li>";
                                    }//for

                                    replyUL.html(str);
                                    showReplyPage(replyCnt);
                            });//getList
                        }//showList





                        /* [part17] 댓글페이징번호 출력 */

                        var pageNum = 1;
                        var replyPageFooter = $(".panel-footer");

                        function showReplyPage(replyCnt){

                            var endNum = Math.ceil(pageNum / 10.0) * 10;    //끝페이지번호
                            var startNum = endNum - 9;                      //  시작페이지번호 = 끝번호-9

                            var prev = startNum != 1;   //맨첫블록(startNum이 1임)이 아니면
                            var next = false;           //next 없음

                            /*
                                [1] 끝번호가 10의배수이면서 총 댓글 수보다 (같거나)많다? -> 맨 마지막 블록이 10개로 떨어지 않으니 올림해서 int로
                                [2] 끝번호가 10의배수이면서 총 댓글 수보다 적다? -> 맨 마지막일 때 까지 즉, [1]if를 탈 때 까지 next버튼은 나와야되니까 next = true;

                            */

                            //[1]
                            if(endNum * 10 >= replyCnt){
                                endNum = Math.ceil(replyCnt/10.0);
                            }

                            //[2]
                            if(endNum * 10 < replyCnt){
                                next = true;
                            }


                            var   str = "<ul class='pagination pull-right'>";

                            if(prev){
                                str+= "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
                            }

                            for(var i = startNum ; i <= endNum; i++){

                                var active = pageNum == i? "active":"";

                                str+= "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
                            }

                            if(next){
                                str+= "<li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
                            }

                            str += "</ul></div>";

                            console.log(str);

                            replyPageFooter.html(str);
                        }


                        // 페이지번호를 클릭했을 때 새로운 댓글리스트 가져오기
                        replyPageFooter.on("click","li a", function(e){
                            e.preventDefault();
                            console.log("-----page click");

                            var targetPageNum = $(this).attr("href");

                            console.log("-----targetPageNum: " + targetPageNum);

                            pageNum = targetPageNum;

                            showList(pageNum);
                        });


                        /* 1. 새로운댓글 추가 */
                        var modal = $(".modal");

                        var modalInputReply = modal.find("input[name='reply']");
                        var modalInputReplyer = modal.find("input[name='replyer']");
                        var modalInputReplyDate = modal.find("input[name='replyDate']");

                        var modalModBtn = $("#modalModBtn");
                        var modalRemoveBtn = $("#modalRemoveBtn");
                        var modalRegisterBtn = $("#modalRegisterBtn");

                        $("#addReplyBtn").on("click",function(e){

                            modal.find("input").val("");
                            modalInputReplyDate.closest("div").hide();
                            modal.find("button[id != 'modalCloseBtn']").hide();

                            modalRegisterBtn.show();

                            $(".modal").modal("show");

                            modalRegisterBtn.on("click",function (e){

                                // reply Obj
                                var reply = {
                                     reply : modalInputReply.val()
                                    ,replyer : modalInputReplyer.val()
                                    ,bno : bnoValue

                                };

                                // 이걸쓰면 왜좋은지? get.jsp내부에서는 Ajax 호출은 replyService라는 이름의 js객체에 감춰져있음 -> 필요한 파라미터만 전달하는 형태로 간결해짐
                                replyService.add(reply,function (result) {
                                    console.log("add들어옴");
                                    alert(result);

                                    modal.find("input").val();
                                    modal.modal("hide");

                                    //showList(1); //댓글 추가이후 1페이지로 새로 보내줘야 추가된 댓글이 출력됨
                                    showList(-1); //댓글 추가이후 1페이지로 새로 보내줘야 하는데, 페이징하면서 위에서 showList(-1)하면 전체 댓글 수 가져오게 했으므로
                                                    // 일단 -1호출로 전체 댓글 수 먼저 가져오게 지정

                                });//add
                            });//modalRegisterBtn클릭

                        }); //댓글추가Btn

                        /* 2. 댓글의 클릭이벤트 처리
                        * [댓글의 클릭이벤트 처리 : 이벤트 위임 ]
                        * DOM에서 이벤트리스너를 등록하는 것은 반드시 해당 DOM요소가 존재해야만 가능하다.
                        * 그런데! Ajax로 <li>태그들이 만들어지면
                        * ==> 이후에 이벤트를 등록해야하기 때문에 => 이벤트 위임의 형태로 작성 (위임:delegation)
                        *
                        * [이벤트 위임]
                        * 1. 이미 존재하는 요소에 이벤트를 걸어준다.
                        * 2. 나중에 이벤트의 대상을 변경해준다.
                        * -> on()을 이용, 동적으로 생기는 요소들에 대해 파라미터 형식으로 지정한다
                        *
                        * [결과]
                        * 처음 이벤트 걸었던 대상에 이벤트가 걸리지 않고 이벤트의 주인공은 on()에 파라미터로 들어간 실제이벤트 대상이 된다.
                        *  */

                        $(".chat").on("click","li",function(e){ // => 파라미터 형식으로 등러간 li가 실제 이벤트 걸리는 대상
                            var rno = $(this).data("rno");  //실제 이벤트 대상인 rno의 this -> li
                            console.log("###이벤트 실제 대상이 되는 li의 rno = "+rno);
                        /*
                        get?pageNum=1&amount=10&keyword=&type=&bno=425990:577 ###이벤트 실제 대상이 되는 li의 rno = 40
                        get?pageNum=1&amount=10&keyword=&type=&bno=425990:577 ###이벤트 실제 대상이 되는 li의 rno = 39
                        get?pageNum=1&amount=10&keyword=&type=&bno=425990:577 ###이벤트 실제 대상이 되는 li의 rno = 38
                        */


                            //get으로 댓글조회
                            replyService.get(rno,function (reply) {
                                modalInputReply.val(reply.reply);
                                modalInputReplyer.val(reply.replyer);
                                modalInputReplyDate.val( replyService.displayTime(reply.replyDate))  // 시간은 formatting된 것으로
                                    .attr("readonly","readonly");

                                modal.data("rno",reply.rno);

                                modal.find("button[id != 'modalCloseBtn']").hide();
                                modalModBtn.show();
                                modalRemoveBtn.show();

                                $(".modal").modal("show");

                            });//get



                        });//on() : 클릭한li에 이벤트 위임



                        /* 3. 댓글 등록 / 목록갱신 : 작업 완료 후 현재 댓글이 포함된 페이지로 이동하도록  */
                        modalModBtn.on("click",function(e){
                            // reply Obj
                            var reply = {
                                 rno : modal.data("rno")
                                ,reply : modalInputReply.val()
                            };

                            replyService.update(reply,function(result){
                                alert(result);
                                modal.modal("hide");
                                showList(pageNum);
                            }); //update
                        });//modalModBtn누르면

                        /* 4. 댓글삭제 : 삭제시에도 현재 댓글이 포함된 페이지로 이동하도록 */
                       modalRemoveBtn.on("click",function(result){
                            var rno = modal.data("rno");

                            replyService.remove(rno,function(result){
                                alert(result);
                                modal.modal("hide");

                                showList(pageNum);
                            });
                        }); //modalRemoveBtn


                        console.log("글번호 : "+bnoValue);




                    });

                </script>

                <script type="text/javascript">
                    $(document).ready(function(){
                        var operForm = $("#operForm");
                        console.log("operForm / hidden값 : ...."+operForm);

                        // modify 버튼 누르면 hidden값으로 bno 가지고 ----> submit()
                        $("button[data-oper='modify']").on("click",function(e){
                            operForm.attr("action","/board/modify").submit();
                        });

                        //list버튼 누르면 id="bno" 값 없애고 ----> submit() (list로 이동)
                        $("button[data-oper='list']").on("click",function(e){
                            operForm.find("#bno").remove();
                            operForm.attr("action","/board/list");
                            operForm.submit();
                        });

                    });
                </script>



                <%-- 첨부파일 script
                1. 일단 getJSON으로 첨부파일 목록 가져오는거 크롬에서 확인
                2. 1이 OK면 첨부파일 각각 이미지는 썸네일로,
                                     일반파일은 파일아이콘으로 화면에 보이게 처리
                3. 1,2 둘다OK면 파일 각각의 liObj를 클릭했을 때 이미지는 크게보이게하고 다운로드
                                                       일반파일은 다운로드

                --%>
                <script>
                    $(document).ready(function(){
                        (function () {
                            var bno = '<c:out value="${board.bno}"/>';

                            $.getJSON(
                                "/board/getAttachList", {bno : bno}, function(arr){ //1번 OK
                                    console.log(arr);

                                    var str = "";
                                    $(arr).each(function(i,attach){


                                        //each1. image파일일 때 : attach.fileType이 true
                                        if(attach.fileType){
                                            var fileCallPath = encodeURIComponent( attach.uploadPath +"/s_"+ attach.uuid +"_"+ attach.fileName); //이미지니까 썸넬가져옴

                                            str += "<li data-path='"+ attach.uploadPath +"' data-uuid='"+ attach.uuid +"' data-filename='"+ attach.fileName +"' data-type='"+ attach.fileType +"'>";
                                            str += "<div><img src='/display?fileName="+ fileCallPath +"'></div></li>";


                                        //each2. 일반파일일 때 : attach.fileType이 false
                                        }else{
                                            str += "<li data-path='"+ attach.uploadPath +"' data-uuid='"+ attach.uuid +"' data-filename='"+ attach.fileName +"' data-type='"+ attach.fileType +"'>";
                                            str += "<div><span>"+ attach.fileName +"</span><br><img src='/resources/img/attach.png'></div></li>";
                                        }
                                    });//each
                                    $(".uploadResult ul").html(str);

                            });//getJSON : 2번 OK


                        })(); //end function

                        //클릭하면 보여주기
                        $(".uploadResult").on("click","li",function(e){
                            console.log("첨부이미지 보여주기");

                            var liObj = $(this);

                            var path = encodeURIComponent( liObj.data("path") +"/"+ liObj.data("uuid") +"_"+ liObj.data("filename"));

                            if(liObj.data("type")){
                                console.log("이미지보여주기");
                                showImage(path.replace(new RegExp(/\\/g),"/")); ///-------> 이미지 크게보여주는거만 안됨
                            }else{
                                //다운로드
                                self.location = "/download?fileName="+path; // 경로 붙고 인코드된 URI컴포넌트
                            }//
                        });//li각각 클릭하면 : 3번

                        function showImage(fileCallPath){
                           // alert(fileCallPath+"*****");
                            $(".bigPictureWrapper").css("display","flex").show();

                            $(".bigPicture")
                                .html("<img src='/display?fileName="+fileCallPath+"'>")
                                .animate({width:'100%', height:'100%'},1000);

                            //클릭하면 닫기
                            $(".bigPictureWrapper").on("click",function(e){
                                $(".bigPicture").animate({width:'0%', height:'0%'},500);
                                setTimeout(function(){
                                   $(".bigPictureWrapper").hide();
                                },1000);
                            });
                        }



                    });//ready 첨부파일
                </script>
                <%-- 첨부파일 script : e --%>

                        <%-- 번호로 조회 : 반드시 모든 input을 readonly="readonly"로 속성지정 --%>

                        <%-- BNO --%>
                            <div class="form-group">
                                <label>Bno</label>
                                <input class="form-control" name="bno" value="<c:out value='${board.bno}'/>"
                                       readonly="readonly"/>
                            </div>
                        <%-- 제목 --%>
                            <div class="form-group">
                                <label>Title</label>
                                <input class="form-control" name="title" value="<c:out value='${board.title}'/>"
                                       readonly="readonly"/>
                            </div>

                        <%-- 내용 --%>
                            <div class="form-group">
                                <label>Content</label>
                                <textarea class="form-control" rows="3" name="content"
                                readonly="readonly"><c:out value='${board.content}'/>
                                </textarea>
                            </div>

                        <%-- 작성자 --%>
                            <div class="form-group">
                                <label>Writer</label>
                                <input class="form-control" name="writer" value="<c:out value='${board.writer}'/>"
                                       readonly="readonly"/>
                            </div>
<hr>
                        <%-- 버튼 modify : 수정화면으로 이동 --%>
                            <button data-oper='modify'
                                    class="btn btn-default"
                                    onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'"
                            >Modify</button>

                        <%-- 버튼 modify : 수정화면으로 이동 --%>
                            <button data-oper='list'
                                    class="btn btn-info"
                                    onclick="location.href='/board/list'"
                            >List</button>

                    </div>


                    <style>
                        .uploadResult {
                            width:100%;
                            background-color: gray;
                        }
                        .uploadResult ul{
                            display:flex;
                            flex-flow: row;
                            justify-content: center;
                            align-items: center;
                        }
                        .uploadResult ul li {
                            list-style: none;
                            padding: 10px;
                            align-content: center;
                            text-align: center;
                        }
                        .uploadResult ul li img{
                            width: 100px;
                        }
                        .uploadResult ul li span {
                            color:white;
                        }
                        .bigPictureWrapper {
                            position: absolute;
                            display: none;
                            justify-content: center;
                            align-items: center;
                            top:0%;
                            width:100%;
                            height:100%;
                            background-color: gray;
                            z-index: 100;
                            background:rgba(255,255,255,0.5);
                        }
                        .bigPicture {
                            position: relative;
                            display:flex;
                            justify-content: center;
                            align-items: center;
                        }

                        .bigPicture img {
                            width:600px;
                        }

                    </style>
                <%--  첨부 "image" 파일 보여줄 div  --%>
                    <div class="bigPictureWrapper">
                        <div class="bigPicture"></div>
                    </div>
                <%--  첨부 "image" 파일 보여줄 div :e --%>
                <%--  첨부파일 보여줄 div  --%>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="panel panel-default">

                            <div class="panel-heading">첨부 Files</div>
                            <%--panel 헤딩--%>

                            <div class="panel-body">
                                <div class="uploadResult">
                                    <ul>
                                    <%--첨부파일 목록 li 들어올 --%>
                                    </ul>
                                </div>
                            </div><%--panel-body : e--%>
                        </div><%--panel-heading : e--%>
                    </div><%--col-lg-12 : e--%>
                </div><%-- row : e--%>
                <%--  첨부파일 보여줄 div:e  --%>



                <%-- 댓글창 div --%>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="panel panel-default">

                            <%--heading--%>
                                <div class="panel-heading">
                                    <i class="fa fa-comments fa-fw"></i> Reply
                                <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">NEW REPLY</button>
                                </div>

                            <%--reply body--%>
                                <div class="panel-body">
                                    <ul class="chat">
                                        <p>///////////////////</p>
                                        <%-- 댓글 li자리 --%>
                                      <%--<li class="left clearfix" data-rno='22'>&lt;%&ndash; 22번 &ndash;%&gt;
                                        <div>
                                            <div class="header">
                                                <strong class="primary-font">user00</strong>
                                                <small class="pull-right text-muted">2018-01-01 13:13</small>

                                            </div>
                                                <p>Good job!</p>
                                        </div>
                                      </li>--%>
                                    </ul>
                                </div>
                           <%-- reply body :e --%>

                                <div class="panel-footer"><%--댓글 페이지번호 추가될 부분--%></div>
                                <script type="text/javascript">

                                </script>
                            </div>

                        </div>
                    </div>
<%@include file="../includes/footer.jsp"%>
