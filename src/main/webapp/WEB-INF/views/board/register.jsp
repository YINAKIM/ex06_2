<%--
  Created by IntelliJ IDEA.
  User: kim-yina
  Date: 2021/05/08
  Time: 10:45 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="../includes/header.jsp"%>
<style type="text/css">

    /* 업로드된 파일들 목록, 일반파일은 파일아이콘, 이미지파일은 이미지아이콘 보여줄 css */
    .uploadResult {
        width:100%;
        background-color: gray;
    }

    .uploadResult ul {
        display: flex;
        flex-flow: row;
        justify-content: center;
        align-items: center;
    }


    .uploadResult ul li{
        list-style: none;
        padding: 10px;
    }

    .uploadResult ul li img{
        width: 100px;
        /*width: 20px;*/
    }

    .uploadResult ul li span{
        color : white;
    }

    /*  p542. 썸네일 클릭하면 원본이미지 출력 css  */
    .bigPictureWrapper{
        position: absolute;
        display: none;
        justify-content: center;
        align-items: center;
        topoperation: 0%;
        width: 100%;
        height: 100%;
        background-color: gray;
        z-index: 100;
        background: rgba(255,255,255,0.5);
    }

    .bigPicture{
        position: relative;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .bigPicture img{
        width: 600px;
    }
</style>

<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">Forms</h1>
  </div>
  <!-- /.col-lg-12 -->
</div>
<!-- /.row -->




<%-- 첨부파일 등록 : 끝 --%>
<script type="text/javascript">
    $(document).ready(function(e){

        var formObj = $("form[role='form']");

        $("button[type='submit']").on("click",function (e) {
            e.preventDefault();
            console.log("submit clicked******************************");


            var str = "";
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
            formObj.append(str).submit();


        });


        var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)"); // 특정 확장자 지정해서 제한 : exe,sh,zip,alz 업로드막기
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


        }// showUploadResult(result)

        /************* 첨부파일 변경처리 : X 누르면 삭제처리하는거 ***************/
        $(".uploadResult").on("click","button",function(e){
            console.log("delete file눌럿다!");// 일단 확인용

            var targetFile = $(this).data("file");
            var type = $(this).data("type");

            var targetLi = $(this).closest("li"); // closest 알아보기 : 위로거슬러가서 가장 가까운 요고 1개만 찾음 : 요소 0개 또는 1개 반환
                                        // closest() 과 parent()
                                        // -> https://www.notion.so/closet-parent-aa1ac08d0f7d402b9e70ecb48100720f

            $.ajax({
                 url : '/deleteFile'
                ,data : { fileName: targetFile, type:type }
                ,dataType : 'text'
                , type: 'POST'
                    ,success: function (result) {
                     console.log("삭제성공");
                        alert(result);
                        targetLi.remove();
                    }//succ
            }); //ajax


        });
        /************* 첨부파일 변경처리 : X 누르면 삭제처리하는거 ***************/


        /************* 첨부파일 DB작업 : hidden으로 첨부파일 정보 수집, BoardVO로 보낼거니까 name='attach[i]'로 보낸다(변수 선언된 순서대로?) ***************/



    });//ready
</script>





<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-heading"> Board Register </div>

      <div class="panel-body">
        <div class="row">
          <div class="col-lg-6">

<%--   form   --%>
            <form role="form" action="/board/register" method="post">


              <div class="form-group">
                <label>TITLE</label>
                <input class="form-control" name="title">
              </div>

<%--      TEXT AREA        --%>
              <div class="form-group">
                <label>TEXT AREA</label>
                <textarea class="form-control" rows="3" name="content"></textarea>
              </div>


              <div class="form-group">
                <label>WRITER</label>
                <input class="form-control" name="writer">
              </div>

              <button type="submit" class="btn btn-default">Submit</button>
              <button type="reset" class="btn btn-default">Reset</button>


                <%-- 첨부파일 등록 --%>
                <div class="row">
                    <div class = "col-lg-12">
                        <div class="panel panel-default">

                            <div class="panel-heading">파일Attach</div>
                            <div class="panel-body">

                                <%-- 폼 --%>
                                <div class="form-group uploadDiv">
                                    <input type="file" name="uploadFile" multiple>
                                </div>

                                <div class="uploadResult">
                                    <ul>
                                        <%-- 업로드 결과 자리 --%>
                                    </ul>
                                </div>
                            </div>
                            <%--    panel-body    --%>


                        </div><%-- panel-default --%>
                    </div><%--col-lg-12--%>


                </div>
                <%--row--%>


            </form>

          </div>

<%@include file="../includes/footer.jsp"%>
