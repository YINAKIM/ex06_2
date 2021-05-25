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
        top: 0%;
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

<%-- 첨부파일 등록 : 끝 --%>
<script type="text/javascript">
    $(document).ready(function(e){

        var formObj = $("form[role='form']");

        $("button[type='submit']").on("click",function (e) {
            e.preventDefault();
            console.log("submit clicked");
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
                     //showUploadResult(result); // 업로드 결과 처리 함수
                    }//succ
            });//ajax
        });//file 인풋에 change생기면
/*

*/
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
            </form>

          </div>

<%@include file="../includes/footer.jsp"%>
