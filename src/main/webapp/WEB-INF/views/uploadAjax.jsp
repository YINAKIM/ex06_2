<%--
  Created by IntelliJ IDEA.
  User: kim-yina
  Date: 2021/05/24
  Time: 5:48 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <h1>Upload with Ajax</h1>

    <div class="uploadDiv">
        <input type="file" name="uploadFile" multiple>
    </div>

    <button id="uploadBtn">Upload</button>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"
            integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
            crossorigin="anonymous"></script>

    <%-- FormData객체로 Ajax를 이용, 파일데이터만 전송   --%>
    <script>
    $(document).ready(function () {

        //업로드 버튼
        $("#uploadBtn").on("click",function(e){
            var formData = new FormData();
            var inputFile = $("input[name='uploadFile']");

            var files = inputFile[0].files;
            console.log("files",files); // 리스트 볼 수 있음
            //console.log("파일데이터"+files); --> 이렇게 하면 리스트 안찍힘 : 리스트 for 돌려야되니까




            // add filedate to formdate
            for (var i = 0; i < files.length; i++){
                formData.append("uploadFile",files[i]);
            }//for

            $.ajax({
                 url : "/uploadAjaxAction"
                ,processData : false
                ,contentType : false
                ,data : formData
                ,type : 'POST'
                ,success : function(){
                     alert("Uploaded");
                }//success
            });//ajax

        });//uploadBtn클릭

    });//ready
    </script>

</body>
</html>
