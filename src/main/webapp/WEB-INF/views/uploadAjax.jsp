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

    <style type="text/css">
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
            width: 20px;
        }
    </style>
</head>
<body>
    <h1>Upload with Ajax</h1>

    <div class="uploadDiv">
        <input type="file" name="uploadFile" multiple>
    </div>


<%--  업로드한 파일 이름 또는 썸넬출력  --%>
    <div class="uploadResult">
        <ul>
        <%-- 여기다 출력할꺼야
        multiple이니까 첨부파일 목록이 li로 들어갈 수 있게 ul에 넣는다--%>
        </ul>
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

        //chpter22. 업로드요청 들어오면 for안에서 확장자, 파일크기 검사하는 함수
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

        //chap23. 브라우저에서 섬네일 처리
        var cloneObj = $(".uploadDiv").clone();


        //[chap23] 업로드결과를 파일명 or 썸넬로 출력하는 함수
        //          : JSON데이터를 받아서 해당파일의 이름을 추가한다. <------이걸 하려면 JSON데이터가 들어가게 ajax에서 함수호출하면서 result넣어주기
        var uploadResult = $(".uploadResult ul");

        function showUploadedFile(uploadResultArr){

            var str = "";
            $(uploadResultArr).each(function(i, obj){
                if(!obj.image){

                    str += "<li><img src='/resources/img/attach.png'>"+obj.fileName+"</li>";
                }else{

                    var fileCallPath = encodeURIComponent( obj.uploadPath +"/s_"+ obj.uuid +"_"+ obj.fileName);
                    str += "<li><img src='/display?fileName=" + fileCallPath + "'>"+obj.fileName+"</li>";
                    /*
                    이미지파일을 업로드하면 해당 파일의 썸넬이 옆에 보임
                    */

                }// else


            }); //each

            uploadResult.append(str);

        }//showUploadedFile

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





                // ,processData : false ---> 꼭 false!!
                // ,contentType : false ---> 꼭 false!!
            $.ajax({
                 url : "/uploadAjaxAction"
                ,processData : false
                ,contentType : false
                ,data : formData
                    ,type : 'POST'
                    ,dataType : 'json'
                    ,success : function(result){
                        console.log("------ 업로드정보 : AttachFileDTO로 보낸 JSON -------");
                        console.log(result);

                        //JSON데이터를 받아서 파일명을 보여주는 함수, result를 넣어서 호출
                        showUploadedFile(result);

                        $(".uploadDiv").html(cloneObj.html()); //다시 업로드 할 수 있는 화면으로 보여줌

                    }//success
            });//ajax

        });//uploadBtn클릭




    });//ready
    </script>

</body>
</html>
