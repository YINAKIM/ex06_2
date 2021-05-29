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
<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-heading">Board 수정 Page</div>

      <div class="panel-body">
        <div class="row">
          <div class="col-lg-6">

            <%-- 번호로 수정 : bno / writer 만 readonly="readonly"로 속성지정 --%>
            <form role="form" action="/board/modify" method="post">
                <%-- 페이지위치 유지하기 위한 파라미터 hidden --%>
                <input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum}'/>">
                <input type="hidden" name="amount" value="<c:out value='${cri.amount}'/>">
                <input type="hidden" id="type" name="type" value="<c:out value='${cri.type}'/>">
                <input type="hidden" id="keyword" name="keyword" value="<c:out value='${cri.keyword}'/>">

                <%--파일삭제했던 정보 보관했다가 함께 보내는 hidden : script안에 --%>

            <%-- BNO --%>
            <div class="form-group">
              <label>Bno</label>
              <input class="form-control" name="bno" value="<c:out value='${board.bno}'/>"
                     readonly="readonly"/>
            </div>
            <%-- 제목 --%>
            <div class="form-group">
              <label>Title</label>
              <input class="form-control" name="title" value="<c:out value='${board.title}'/>"/>
            </div>

            <%-- 내용 --%>
            <div class="form-group">
              <label>Content</label>
              <textarea class="form-control" rows="3" name="content"><c:out value='${board.content}'/>
              </textarea>
            </div>

            <%-- 작성자 --%>
            <div class="form-group">
              <label>Writer</label>
              <input class="form-control" name="writer" value="<c:out value='${board.writer}'/>"
                     readonly="readonly"/>
            </div>

            <%-- 등록일 --%>
            <div class="form-group">
              <label>RegDate</label>
              <input class="form-control" name="regdate"
                     value="<fmt:formatDate value='${board.regdate}' pattern='yyyy/MM/dd'/>"
                     readonly="readonly">
            </div>
            <%-- 수정일 --%>
            <div class="form-group">
              <label>UpdateDate</label>
              <input class="form-control" name="updateDate"
                     value="<fmt:formatDate pattern='yyyy/MM/dd' value='${board.updateDate}'/>"
                     readonly="readonly">
            </div>


            <%-- 버튼 modify : 수정화면으로 이동 --%>
            <button data-oper="modify"
                    class="btn btn-default"

            >Modify</button>


            <%-- 버튼 remove : 삭제화면으로 이동 --%>
            <button data-oper="remove"
                    class="btn btn-danger"
            >Remove</button>

            <%-- 버튼 modify : 수정화면으로 이동 --%>
            <button data-oper="list"
                    class="btn btn-info"

            >List</button>



          </form>

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

                      <%-- 등록화면처럼 첨부파일 추가하는 input필요 --%>
                      <div class="form-group uploadDiv">
                        <input type="file" multiple="multiple" name="uploadFile">
                      </div>
<%--
[ modify.jsp - 수정화면에서 첨부파일 작업 ]
첨부파일은 수정의 개념이 아니라 기존목록확인 / 삭제 / 새로운파일첨부 작업으로 진행된다
기존에 있던걸 보여주는 : get.jsp
새로운 파일 추가하는 : register.jsp
첨부파일 삭제하는 : /remove 요청
--%>


                      <div class="uploadResult">
                        <ul>
                          <%--첨부파일 목록 li 보여줄곳 --%>
                        </ul>
                      </div>
                    </div><%--panel-body : e--%>
                  </div><%--panel-heading : e--%>
                </div><%--col-lg-12 : e--%>
              </div><%-- row : e--%>
              <%--  첨부파일 보여줄 div:e  --%>



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
                                  str += "<div>";

                                  str    +=   "<span>"+ attach.fileName +"</span>";
                                  /* 삭제처리를 위해 받아오는 (저장된경로+저장된파일명), data-file, data-type */
                                  str    +=   "<button type='button' data-file='"+ fileCallPath +"' data-type='image' class='btn btn-warning btn-circle'>";
                                  str    +=   "<i class='fa fa-times'></i>";
                                  str    +=   "</button><br>"

                                  str    +=  "<img src='/display?fileName="+ fileCallPath +"'></div></li>";


                                  //each2. 일반파일일 때 : attach.fileType이 false
                                }else{
                                  str += "<li data-path='"+ attach.uploadPath +"' data-uuid='"+ attach.uuid +"' data-filename='"+ attach.fileName +"' data-type='"+ attach.fileType +"'>";
                                  str += "<div><span>"+ attach.fileName +"</span>" ;

                                  str    +=   "<button type='button' data-file='"+fileCallPath+"' data-type='file' class='btn btn-warning btn-circle'>";
                                  str    +=   "<i class='fa fa-times'></i>";
                                  str    +=   "</button>";

                                  str += "<br><img src='/resources/img/attach.png'></div></li>";
                                }
                              });//each
                              $(".uploadResult ul").html(str);

                            });//end getJSON

                  })();//end function

/*
 ▶︎ 수정화면에서 주의할 점 !! ◀
 수정화면에 들어오면 [기존 첨부파일 목록] 보이는데
 1. 일부 삭제하고 일부 추가할 수 있고
 2. 일부 삭제할 수 있고
 3. 전부 삭제할 수 있고
 4. 전부 삭제 후 새로운 파일 추가될 수 있고
 ...등등 많은데 제일 신경쓸 부분은

 현재 파일첨부,삭제 전뿌 Ajax로 바로바로 처리되고 있는데
 >>> 첨부파일을 Ajax로 삭제처리 후 수정submit 안하고 그냥 나가버리면 ?︎
 -----> 첨부파일 목록이 삭제되거나 변경된 상태로 남아버린다.
 -----> 그래서 일단 수정화면에서 일어나는 첨부파일 관련 작업을
 화면에서만 삭제처리(또는 등록?) 후
 최종적으로 [수정submit] 했을 경우에만 : 최종 목록상태가 반영되어야 한다

 수정1. [X]버튼 클릭하면 일단 화면에서만 안보이게하고
 수정2. <li>에 갖고있던 정보를 <input type="hidden">으로 보관했다가
 수정3. 실제 파일삭제는 [수정submit] 요청 들어가면 그때 처리되도록 한다
*/

                    // 수정1. 일단 화면에서만 삭제처리
                    $(".uploadResult").on("click","button",function(e){
                        console.log("파일삭제누름--> 화면에서만 삭제처리할꺼임");

                        if(confirm("파일을 삭제하시겠습니까?")){
                            var targetLi = $(this).closest("li");
                            targetLi.remove(); //화면에서만 remove
                        }
                    });//uploadResult :클릭


                    //  첨부파일 추가 : ~end showUploadResult(result)까지
                    var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)");
                    var maxSize = 524880;   // 5MB이상 업로드막기

                    function checkExtension(fileName, fileSize){

                        if(regex.test(fileName)){
                            alert("해당 종류의 파일은 업로드할 수 없습니다.");
                            return false;
                        }
                        if( fileSize >= maxSize ){
                            alert("5MB 이상인 파일은 업로드할 수 없습니다.");
                            return false;
                        }

                        return true; //검사 통과하면 업로드 꼭 시켜주기
                    }//checkExtension

                    $("input[type='file']").change(function(e){
                        var formData = new FormData();
                        var inputFile = $("input[name='uploadFile']");

                        var files = inputFile[0].files;

                        for(var i = 0; i<files.length; i++){
                            if(!checkExtension(files[i].name, files[i].size)){
                                return false;
                            }
                            formData.append("uploadFile",files[i]);
                        }//for

                        $.ajax({
                            url:'/uploadAjaxAction'
                            ,processData : false
                            ,contentType : false
                            ,data : formData
                            , type : 'POST'
                            ,dataType : 'json'
                            ,success : function(result){
                                console.log(result);
                                showUploadResult(result); // 업로드 결과 처리 함수
                            }//succ
                        });//ajax
                    });//file 인풋에 change생기면

                    //업로드 처리 결과 보여주는 함수
                    function showUploadResult(uploadResultArr) {
                        if(!uploadResultArr || uploadResultArr.length == 0 ){ return;} // 결과가 없으면 이 함수 들어왔어도 return으로 종료,
                        var uploadUL = $(".uploadResult ul");

                        var str = "";
                        $(uploadResultArr).each(function(i,obj){

                            if(obj.image){ // image파일일경우
                                console.log("이미지 파일이다");

                                var fileCallPath = encodeURIComponent( obj.uploadPath +"/s_"+ obj.uuid +"_"+ obj.fileName);

                                console.log("-------");

                                /* DB로 보낼 값들을 읽어가기 위한 data-속성들 (BoardAttachVO의 멤버필드로 들어갈 값들) ---> data-type은 obj.image : BoardAttachVO에서는 bool이고, DB에서 char(1) 로 들어갈 것*/
                                str    +=  "<li data-path='"+obj.uploadPath +"' data-uuid='"+ obj.uuid +"' data-type='"+ obj.image +"' data-filename='"+ obj.fileName +"' "
                                    +   "> <div>";
                                str    +=   "<span>"+ obj.fileName +"</span>";
                                /* 삭제처리를 위해 받아오는 (저장된경로+저장된파일명), data-file, data-type */
                                str    +=   "<button type='button' data-file='"+ fileCallPath +"' data-type='image'"
                                    + "class='btn btn-warning btn-circle'>";

                                str    +=   "<i class='fa fa-times'></i>";
                                str    +=   "</button><br>";
                                str    +=   "<img src='/display?fileName="+ fileCallPath +"'>";
                                str    +=   "</div></li>";
                                /*  p559. 근데 왜 +로 연결안하고 하나하나 다 str += 하지?  */

                                //console.log("showUploadResult의 image str ---> "+str);

                            }else{  //일반파일인 경우

                                console.log("일반 파일이다");

                                var fileCallPath = encodeURIComponent( obj.uploadPath +"/"+ obj.uuid +"_"+ obj.fileName);
                                var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");

                                /* DB로 보낼 값들을 읽어가기 위한 data-속성들 (BoardAttachVO의 멤버필드로 들어갈 값들) */
                                str    +=  "<li data-path='"+obj.uploadPath +"' data-uuid='"+ obj.uuid +"' data-type='"+ obj.image +"' data-filename='"+ obj.fileName +"' "
                                    +   "> <div>";
                                str    +=   "<span>"+ obj.fileName +"</span>";

                                /* 삭제처리를 위해 받아오는 (저장된경로+저장된파일명), data-file, data-type
                                   : HTML 태그에 사용하는 'data-' 속성 알아보기 -> p561*/
                                str    +=   "<button type='button' data-file='"+fileCallPath+"' data-type='file'"


                                    + "class='btn btn-warning btn-circle'>";

                                str    +=   "<i class='fa fa-times'></i>";
                                str    +=   "</button><br>";
                                str    +=   "<img src='/resources/img/attach.png' width='50px' height='50px'>";
                                str    +=   "</div></li>";
                                /* </a>가 여는게 없는데 그냥 img뒤에 붙이기도함? */

                                //console.log("showUploadResult의 file str ---> "+str);

                            }//else

                        }); // each : 업로드된 파일 각각

                        uploadUL.append(str); // 여기다 붙여야 보여주지
                    }// end showUploadResult(result)



                // 수정2. 실제 첨부파일목록이 변경되는 작업을 서버에서 처리하기 위해 data실어보내는 이벤트처리
                // ~ submit(); 까지
                  var formObj = $("form");

                  $("button").on("click",function(e){

                    e.preventDefault();                   // <form>태그 안의 button은 기본적으로 submit
                                                          // button의 기본이벤트를 막고
                    var operation = $(this).data("oper"); // data-oper에 따라 작업 지정 후
                    console.log(operation+"///////");

                    if(operation==='remove'){
                      // remove 페이지로
                      formObj.attr("action","/board/remove");

                    }else if (operation === 'list'){
                      // list 페이지로
                      /*
                      self.location="/board/list";
                      return;
                      */

                      // 11.5.4 수정페이지에서 링크처리 + 뒤로가기 : list로 이동할 때는 파라미터필요없기때문에 empty() ---> submit()
                      formObj.attr("action","/board/list").attr("method","get");

                      // 다시 목록으로 이동하는 경우, 필요한 파라미터만 전송하기 위해 <form>태그의 모든 내용을
                      // 지우고 다시 추가 : clone - empty - append
                      var pageNumTag = $("input[name='pageNum']").clone();
                      var amountTag = $("input[name='amount']").clone();
                      var typeTag = $("input[name='type']").clone();
                      var keywordTag = $("input[name='keyword']").clone();

                      formObj.empty();

                      formObj.append(pageNumTag);
                      formObj.append(amountTag);
                      formObj.append(typeTag);
                      formObj.append(keywordTag);

/*
    사용자가 수정(혹은 삭제) 하려고 왔다가 작업 안하고 [List] 을 눌러서 돌아갈 경우
    [ 작업 취소 상황 ]
    => 1. 필요한 부분만 잠시 복사해서 보관해두고 (clone),
       2. <form>태그 내의 모든 내용은 지워버림(empty)
       3. 다시 [List]페이지로 갈 때 필요한 태그들만 추가해서 '/board/list'호출하는 것


    들어올 때 : /board/modify?bno=425951&pageNum=5&amount=10
    취소 후
    돌아갈 때(O) : /board/list?pageNum=6&amount=10 -> 올바른 예
    돌아갈 때(X) : /board/list? -> 잘못된 예
*/
                    }else if(operation === 'modify'){
                        console.log("수정submit click");

                        var str="";
                        $(".uploadResult ul li").each(function(i, obj){
                            var jobj = $(obj);
                            console.dir(jobj); // log아니고 dir

                            //submit버튼 누르면 BoardVO에 List<BoardAttachVO>로 보낼 hidden값들
                            str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
                            str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
                            str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
                            str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
                            /*
                                      attach[i] 는 List에서 찾을 인덱스,
                                      attach[i].VO에있는 필드명 --->(대소문자 주의)

                                      jobj.data("uuid")
                                      jobj.data("path")
                                      jobj.data("filename")
                                      jobj.data("type") -----> 여기 들어가는건 태그안에 속성으로 지정된 data-type='속성값이름'
                            */

                        });//업로드된 파일 각각의 li

                       // formObj.append(str);
                        formObj.append(str).submit(); //modify할 때만의 submit
                    }//else if  끝

                    formObj.submit();
                      /*
                      버튼에 따라 직접 submit()
                      1. [remove 버튼] submit
                      2. [list 버튼] submit
                      3. [modify 버튼] submit
                      */

                  }); //button 클릭하면 끝

                });//ready

              </script>

          <%@include file="../includes/footer.jsp"%>

