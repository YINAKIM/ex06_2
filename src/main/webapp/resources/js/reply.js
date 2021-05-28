console.log("Reply Module...............!!!!");

//  즉시실행함수 : 함수 정의하자마자 즉시 실행하는 함수
// (function(){})(); ---> 첫번째 괄호 안에 익명함수 선언, 함수 내부에 선언되 변수는 외부에서 접근불가 /
//                          함수의 return값은 함수실행 결과값이고 밖에 선언한 변수에 바로 값을 담는다
//                        두번째 괄호(빈괄호) 보고 js엔진이 함수를 즉시 해석하고 실행시킨다


// ajax를 이용해서 POST방식으로 호출하는 add함수
var replyService = (function(){
    // replyService가 받을 함수들 : add, getList, remove,update

    //[1] 댓글추가 : add
    function add(reply, callback, error){
        console.log("reply..................add");

        $.ajax({
            type:'post',
            url:'/replies/new',
            data:JSON.stringify(reply), // stringify() : js객체를 String으로 변환(서버로 전송할 데이터)
            contentType : "application/json; charset=utf-8",
            success:function(result,status,xhr){
                //요청 성공 시 콜백할 함수
                if(callback){
                    callback(result);
                }
            },  //success
            error:function(xhr,status,er){
                //에러발생시 콜백할 함슈
                if(error){
                    error(er);
                }

            }//error
        })//ajax

    }//add

    //[2] 댓글 목록 조회 : getList
    function getList(param,callback,error){
        var bno = param.bno;
        var page = param.page || 1; // js에서 ||, &&는 bool타입이 아니고 값자체를 리턴한다.
                                    // ||는 하나라도 true면 true"값" 반환, &&는 하나라도 false면 false 값 반환

        $.getJSON("/replies/pages/"+bno+"/"+page+".json"
            ,function(data){
                if(callback){
                    console.log("********"+data);
                    //callback(data); //=>  댓글목록만 가져오는 경우
                    callback(data.replyCnt, data.list);   //=> 댓글 숫자와 목록을 가져오는 경우
                }
        }).fail(function(xhr, status, err){
            if(error){
                console.log("getList의 getJSON에서 error");
                error();
            }
        });//getJSON.fail
    }//getList

    //[3] 댓글 삭제 : remove
    function remove(rno, callback, error){
        $.ajax({

            type: 'delete'
            , url: '/replies/' + rno
            , success: function (deleteResult, status, xhr) {
                if (callback) {callback(deleteResult)}
            }
            , error: function (xhr, status, er) {
                if (error) {error(er)}
            }
        });
    }//remove


    //[4] 댓글수정 : update
    function update(reply, callback, error){
        console.log("수정할 댓글 RNO : "+reply.rno);

        $.ajax({
             type : 'put'
            ,url : '/replies/'+reply.rno
            ,data : JSON.stringify(reply)
            ,contentType: "application/json; charset=utf-8"
            ,success : function(result, status, xhr){
                if(callback){callback(result)}
             }
            ,error : function(xhr, status, er){
                 if(error){error(er)}
             }
        });
    }//update

    //[5] 댓글조회 : get-> 한개 댓글 조회
    function get(rno, callback, error){

        //$.get().fail();
        $.get(
            "/replies/"+rno+".json",function(result){
                if(callback){callback(result)}
        })//get
        .fail(function(xhr, status, err){
            if(error){error()}
        });//fail

    }//get

    //[6]시간처리 : displayTime
    function displayTime(timeValue){
        var today = new Date();
        var gap = today.getTime() - timeValue;
        var dateObj = new Date(timeValue);
        var str = "";

        if( gap < (1000 * 60 * 60 * 24) ){ //24시간이 지난 댓글은 날짜만 표시, 24시간 이내의 글은 시간으로 표시/ milliSec니까 *1000
            var hh = dateObj.getHours();
            var mi = dateObj.getMinutes();
            var ss = dateObj.getSeconds();

            //return[].join('');
            return[
                (hh>9?'':'0')+hh,':',( mi > 9 ?'':'0')+mi,':',(ss > 9 ?'':'0')+ss
            ].join('');
        }else{
            var yy = dateObj.getFullYear();
            var mm = dateObj.getMonth()+1; //getMonth는 0부터
            var dd = dateObj.getDate();

            //return[].join('');
            return[
                yy,'/',( mm > 9 ? '':'0')+mm,'/',(dd > 9 ?'':'0')+dd
            ].join('');

        }

    }//displayTime


    // replyService 의 최종 리턴값 : 각 함수 실행 결과값을 담아서 리턴한다. ---> 함수가 아니라 값을 리턴하는게 [즉시실행함수]의 문법,
    //                       여기서는 add함수 자체를 객체로 리턴하는 것 ---> add()가 아니라 add, getList()가 아니라 getList
    return {
         add:add           //데이터전송타입이 application/json이고, 파라미터로 callback과 error를 함수로 받는 함수(를 Obj로 리턴, 즉시실행함수라서)
        ,getList : getList //param이라는 객체를 통해서 필요한 파라미터를 전달받아 JSON목록을 호출하는 함수(를 Obj로 리턴, 즉시실행함수라서)
        ,remove : remove
        ,update : update
        ,get : get
        ,displayTime : displayTime //ajax에서 데이터를 가져와서 HTML을 만들어주는 부분에
                                   // 'replyService.displyTime(list[i].replyDate)'의 형태로 적용하도록 한다.
    };
//최종 리턴값 : add, getList, remove, update, get

})();


