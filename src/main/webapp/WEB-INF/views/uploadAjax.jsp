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

        var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)"); // 특정 확장자 지정해서 제한 : exe,sh,zip,alz 업로드막기
        var maxSize = 524880;   // 5MB이상 업로드막기

        // 업로드요청 들어오면 for안에서 확장자, 파일크기 검사하는 함수
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

        //업로드 버튼
        $("#uploadBtn").on("click",function(e){
            var formData = new FormData();
            var inputFile = $("input[name='uploadFile']");

            var files = inputFile[0].files;
            console.log("files",files); // 리스트 볼 수 있음
            //console.log("파일데이터"+files); --> 이렇게 하면 리스트 안찍힘 : 리스트 for 돌려야되니까


            // add filedate to formdate
            for (var i = 0; i < files.length; i++){

                //확장자, 파일사이즈 for안에서 각각 검사
                if(!checkExtension(files[i].name, files[i].size)){
                    console.log("업로드 막았다");
                    return false;
                }

                // if안걸리면 formData로 파일데이터 전송
                formData.append("uploadFile",files[i]);
            }//for

            /*
            테스트
            1. 일단 아무것도 안걸리는 파일 업로드 하는 경우 : 전부 업로드 / 경로에 저장 OK
            2. 확장자 걸리는 파일 하나 껴있는 경우 :  해당 파일목록 전부 업로드 막음 (return false)
            3. 사이즈 걸리는 파일 하나 껴있는 경우 :  해당 파일목록 전부 업로드 막음 (return false)
            4. 확장자, 사이즈 둘다 껴있는 경우 : 검사함수에 "먼저 선택된 파일 순서로 체크" 후
                                         나머지 if 안타고 업로드 막음 (return false)
            */



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
