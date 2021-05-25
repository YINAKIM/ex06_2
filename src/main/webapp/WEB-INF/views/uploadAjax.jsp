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

    <div class="bigPictureWrapper">
        <div class="bigPicture">
        <%--썸네일 클릭하면 원본이미지 보여줄 div--%>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"
            integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
            crossorigin="anonymous"></script>

    <%-- FormData객체로 Ajax를 이용, 파일데이터만 전송   --%>
    <script>

    //썸넬클릭하면 호출될 함수
    function showImage(fileCallPath){
        alert(fileCallPath);

        $(".bigPictureWrapper").css("display","flex").show(); //화면 가운데 배치

        $(".bigPicture")
        .html("<img src='/display?fileName="+encodeURIComponent(fileCallPath)+"'>")
        .animate({ width:'100%', height:'100%'},1000);  //  지정된 시간동안 animate


    }
    $(document).ready(function () {
        $(".bigPictureWrapper").on("click",function (e) {
            $(".bigPicture").animate({ width:'0%', height:'0%'},1000);
            setTimeout(()=>{
                $(this).hide();
            },1000);
        });



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

                    var fileCallPath = encodeURIComponent( obj.uploadPath +"/"+ obj.uuid +"_"+ obj.fileName);
                    console.log("일반파일 다운로드 경로+이름"+fileCallPath);
                    console.log("-------");

/******************************************
[ 첨부파일 삭제 시 고려사항 ]
--- 삭제버튼 있어야되고 ---
1. 이미지파일 -> 원본삭제시 썸넬도 삭제
2. 파일삭제 후 브라우저에서 : 아이콘or썸넬 도 삭제되도록
3. 비정상적인 브라우저 종료 시 업로드된 파일 처리 문제
*******************************************/
//     정규표현식 new RegExp(/\\/g)
//     /  /g ====>  new RegExp(/여기있는 문자를/g) 문자열 전체를 검색해라

/*
data() 함수 사용
jQuery에서도 HTML5 표준에 맞춰 data-xxx 속성을 쉽게 다룰 수 있도록 data(key, value) 함수를 지원
data() 함수는 key와 value 형식으로 파라미터를 넘겨 사용합니다.
--------------------------------
$('span').data('age', 13); //값 저장

<span data-age="13"/>  // 이렇게 쓴다
--------------------------------

JSON 객체를 통째로 저장하고 가져올 수 있습니다.
$('span').data('foo', {age:13, name: 'kim'}); //저장
$('span').data('foo'); //---> JSON 객체 리턴 {age:13, name: 'kim'}

다음과 같이 JSON 문자열이 저장됩니다.
<span data-foo='{"age":"13", "name":"kim"}' />
*/

                    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");

                    str += "<li><div><a href='/download?fileName="
                        + fileCallPath
                        + "'><img src='/resources/img/attach.png'>"
                        + obj.fileName+"</a>"
                        + "<span data-file=\'"+ fileCallPath +"\' data-type='file'> X </span>"
                        + "</div></li>";
                    //attach.png 파일 클릭하면 ----> 다운로드에 필요한 경로 + UUID 붙은 파일명 이용해서 다운로드 가능하도록 만들기
                }else{

                    var fileCallPath = encodeURIComponent( obj.uploadPath +"/s_"+ obj.uuid +"_"+ obj.fileName);

                    /**************** 썸넬클릭하면 원본보여주기 ***************/
                    var originPath = obj.uploadPath +"\\"+ obj.uuid +"_"+obj.fileName;
                    originPath = originPath.replace(new RegExp(/\\/g),"/");
                    /**************** 썸넬클릭하면 원본보여주기 ***************/

                    str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='/display?fileName="
                        + fileCallPath + "'></a>"
                        + "<span data-file=\'"+ fileCallPath +"\' data-type='image'> X </span>"
                        + "</li>";
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



        //첨부파일삭제 - X 에대한 이벤트처리
        $(".uploadResult").on("click","span",function(e){
            var targetFile = $(this).data("file");
            var type = $(this).data("type");
            console.log(targetFile);

            $.ajax({
                url : '/deleteFile'
                ,data : {
                    fileName: targetFile, type:type
                }
                ,dataType : 'text'
                ,type : 'POST'
                ,success : function (result) {
                    alert(result)
                }//success
            });// delete ajax

        });


    });//ready
    </script>

</body>
</html>
