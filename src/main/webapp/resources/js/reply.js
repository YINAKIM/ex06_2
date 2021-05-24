console.log("Reply Module...............!!!!");

//  즉시실행함수 : 함수 정의하자마자 즉시 실행하는 함수
// (function(){})(); ---> 첫번째 괄호 안에 익명함수 선언, 함수 내부에 선언되 변수는 외부에서 접근불가 /
//                          함수의 return값은 함수실행 결과값이고 밖에 선언한 변수에 바로 값을 담는다
//                        두번째 괄호(빈괄호) 보고 js엔진이 함수를 즉시 해석하고 실행시킨다


// ajax를 이용해서 POST방식으로 호출하는 add함수
var replyService = (function(){
    // replyService가 받을 함수들 : add, getList, remove,update

    //[1] 댓글추가
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

    //[2] 댓글 목록 조회
    function getList(param,callback,error){
        var bno = param.bno;
        var page = param.page || 1; // js에서 ||, &&는 bool타입이 아니고 값자체를 리턴한다.
                                    // ||는 하나라도 true면 true"값" 반환, &&는 하나라도 false면 false 값 반환
                /*
                   [ js의 falsey value : 이 값이면 전부 false --> 이 값이 아니면 전부 true로 간주]
                       false, 0, -0, 0n, ""(빈String), null, undefined, NaN

                       *NaN : 숫자가 아니라는 뜻인데, 연산결과가 잘못될 경우 NaN이라고 인식하기도 함
                       1. 숫자로서 읽을 수 없음 (parseInt("어쩌구"), Number(undefined))
                        2. 결과가 허수인 수학 계산식 (Math.sqrt(-1))
                        3. 피연산자가 NaN (7 ** NaN)
                        4. 정의할 수 없는 계산식 (0 * Infinity)
                        5. 문자열을 포함하면서 덧셈이 아닌 계산식 ("가" / 3)
                        [주의] NaN === NaN --> false
                        NaN은 다른 모든 값과 비교(==, !=, ===, !==)했을 때 같지 않으며, 다른 NaN과도 같지 않습니다.
                        NaN의 판별은 Number.isNaN() 또는 isNaN()을 사용하면 제일 분명하게 수행할 수 있습니다.
                        아니면, 오로지 NaN만이 자기자신과 비교했을 때 같지 않음을 이용할 수도 있습니다.
                 */
        $.getJSON(
            "/replies/pages/"+bno+"/"+page+".json"
            ,function(data){
                if(callback){
                    //callback(data); //=>  댓글목록만 가져오는 경우
                    callback(data.replyCnt, data.list);   //=> 댓글 숫자와 목록을 가져오는 경우
                }
        })
        .fail(function(xhr, status, err){
            if(error){
                error();
            }
        });//getJSON.fail
    }//getList

    //[3] 댓글 삭제
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


    //[4] 댓글수정
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

    //[5] 댓글조회
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

    //[6]시간처리
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


