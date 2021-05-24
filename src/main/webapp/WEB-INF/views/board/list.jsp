<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="../includes/header.jsp"%>
<%--     <div id="page-wrapper">태그 시작 까지 header.jsp  --%>

        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Tables</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        Board List Page
                            <button id='regBtn' type="button" class="btn btn-xs pull-right">Register New Board</button>
                    </div>
                    <!-- /.panel-heading -->
                    <div class="panel-body">
                        <table width="100%" class="table table-striped table-bordered table-hover">
                    <%-- 목록화면처리 / Part3 - 11.2 / p236  --%>
                            <thead>
                            <tr>
                                <th>#번호</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>작성일</th>
                                <th>수정일</th>
                            </tr>
                            </thead>

                        <c:forEach items="${list}" var="board">
                            <tbody>
                            <tr>
                        <%--p486 댓글수 추가--%>
                                <c:out value="${board.bno}"/>
                                
                                <td><c:out value="${board.bno}"/></td>
<%-- p314
     list > get?bno=x > list 이동시 초기페이지로 이동하는 문제를
     해결하기 위해 각 조회페이지로 이동 시 hidden 값을 담아서 보내고(js에서 추가),
     => 돌아올 때 그 값을 달고 돌아와서 list?pageNum=2&amount=10 이런식으로 보던페이지로 다시 돌아올 수 있게 처리
 <td><a class="move" href="/board/get?bno=<c:out value='${board.bno}'/>"><c:out value="${board.title}"/></a></td>
--%>
                                <td><a class="move" href="<c:out value='${board.bno}'/>">
                                    <c:out value="${board.title}"/></a>
                                <b>[<c:out value="${board.replyCnt}"/>]</b>
                                </td>
                                <td><c:out value="${board.writer}"/></td>
                                <td><fmt:formatDate value="${board.regdate}" pattern="yyyy-MM-dd"/></td>
                                <td><fmt:formatDate value="${board.updateDate}" pattern="yyyy-MM-dd"/></td>
                            </tr>

                            </tbody>
                        </c:forEach>
                        </table>
<%-- SEARCH --%>
                        <div class="row">
                            <div class="col-lg-12">
                                <form id="searchForm" action="/board/list" method="get">
                                    <select name="type">
                                        <option value=""
                                        <c:out value="${pageMaker.cri.type == null? 'selected':''}"/>
                                        >---</option>

                                        <option value="T"
                                        <c:out value="${pageMaker.cri.type eq 'T'? 'selected':''}"/>
                                        >제목</option>

                                        <option value="C"
                                        <c:out value="${pageMaker.cri.type eq 'C'? 'selected':''}"/>
                                        >내용</option>

                                        <option value="W"
                                        <c:out value="${pageMaker.cri.type eq 'W'? 'selected':''}"/>
                                        >작성자</option>

                                        <option value="TC"
                                                <c:out value="${pageMaker.cri.type eq 'TC'? 'selected':''}"/>
                                        >제목 or 내용</option>

                                        <option value="TW"
                                                <c:out value="${pageMaker.cri.type eq 'TW'? 'selected':''}"/>
                                        >제목 or 작성자</option>

                                        <option value="TWC"
                                                <c:out value="${pageMaker.cri.type eq 'TWC'? 'selected':''}"/>
                                        >제목 or 내용 or 작성자</option>
                                    </select>

                                    <input type="text" name="keyword">
                                    <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
                                    <input type="hidden" name="amount" value="${pageMaker.cri.amount}">

                                    <button class="btn btn-default">Search</button>
                                </form>
                            </div>

                        </div>
<%-- SEARCH / END --%>



        <%-- Pagenation --%>

                        <div class="pull-right">
                            <ul class="pagination">

                                <%-- prev --%>
                                <c:if test="${pageMaker.prev}">
                                    <li class="paginate_button previous">
                                        <a href="${pageMaker.startPage-1}">Prev</a>
                                    </li>
                                </c:if>
                                <%-- PageNum --%>
                                <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                                    <li class="paginate_button ${pageMaker.cri.pageNum == num ? "active" : ""}">
                                        <a href="${num}">${num}</a>
                                    </li>
                                </c:forEach>
                                <%-- Next --%>
                                    <c:if test="${pageMaker.next}">
                                        <li class="paginate_button next">
                                            <a href="${pageMaker.endPage+1}">Next</a>
                                        </li>
                                    </c:if>
                            </ul>
                        </div>
        <%-- Pagenation : END --%>

<form id="actionForm" action="/board/list" method="get">
    <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
    <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
    <input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
    <input type="hidden" name="type" value="${pageMaker.cri.type}">
</form>

                    <%-- MODAL  --%>

                        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">

                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
                                    </div>
                                    <div class="modal-body">처리가 완료되었습니다.</div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                        <button type="button" class="btn btn-primary">Save changes</button>
                                    </div>
                                </div>
                                <!-- /.modal-content -->
                            </div>
                            <!-- /.modal-dialog -->
                        </div>
                    <%-- MODAL : END --%>

                    </div>
                    <!-- /.panel-body -->
                </div>
                <!-- /.panel -->
            </div>
            <!-- /.col-lg-6 -->
        </div>
        <!-- /.row -->
<%-- checkModal                        --%>
<script type="text/javascript">
    $(document).ready(function(){
        // call checkModal()
        var result = '<c:out value="${result}"/>';
        checkModal(result);

        // *** 등록완료 후 이동된 상태에서 뒤로가기 했을 경우 모달창이 동작하는 것 방지
        //  ==> js 의 모든 처리가 끝나게 되면 history에 쌓이는 상태는 전부 모달창이 필요없다는 표시하는 것
        history.replaceState({},null,null);

        /*
            window.history객체 :
            stack구조로 동작 --> 페이지 이동에 대해 스택에 URL이동경로가 쌓이는 구조,

            [상황1] 등록 완료 후 > /board/list 호출(앞으로가기나 뒤로가기 아니고 redirect로 이동한 것) : 스택상단에 URL쌓임
            [상황2] 등록 직후 > /board/list 로 이동한 경우 : 모달창 동작

            =====> 등록 완료 후 list로 왔는데 거기서 뒤로가기 했을 때 모달창이 다시 뜨는 이유

            SOL. 스택 상단에 모달창이 필요하지 않다는 표시를 해주면 ===> 다시 돌아갈 때 모달창이 동작하지 않음
        */


        // checkModal()
        function checkModal(result) {

            if(result === '' || history.state ){
                                // history.state 체크 : *** 등록완료 후 이동된 상태에서 뒤로가기 했을 경우 모달창이 동작하는 것 방지
                return;
            }

            if (parseInt(result) > 0 ){
                $(".modal-body").html("게시글 "+parseInt(result)+"번이 등록되었습니다.");
            }
            $("#myModal").modal("show");//if안에 들어가있었음 => 등록완료일 때만 model 보임
        } // checkModal():e

        // regBtn : move to register page
        $("#regBtn").on("click",function(){
           self.location = "/board/register";
        });


        // pageNum, amount actionForm에 담아 넘기기
        var actionForm = $("#actionForm");
        $(".paginate_button a").on("click",function(e){
            e.preventDefault();
            console.log('click'); //form 태그에 값이 잘 들어가는지 submit()처리 하기 전에 브라우저 개발자도구에서 미리 확인부터 하기
            actionForm.find("input[name='pageNum']").val($(this).attr("href"));

            actionForm.submit(); //form 태그에 값이 잘 들어가는지 submit()처리 하기 전에 브라우저 개발자도구에서 미리 확인부터 하기
        }); //actionForm:e

    // list > get?bno=x > list 이동시 초기페이지로 이동하는 문제 해결 : 각 조회페이지로 이동 시 hidden 값을 담아서 보냄
        $(".move").on("click",function(e){
            e.preventDefault();

            actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");

            actionForm.attr("action","/board/get");
            actionForm.submit();
        });

        // 검색버튼 이벤트 처리
        var searchForm = $("#searchForm");

        $("#searchForm button").on("click",function(e){
            if(!searchForm.find("option:selected").val()){
                console.log("option값 없음")
                alert("검색조건을 선택하세요");
                return false;
            }

            if(!searchForm.find("input[name=keyword]").val()){
                console.log("keyword 없음")
                alert("검색어를 선택하세요");
                return false;
            }

            if(!searchForm.find("input[name=pageNum]").val("1")) ;
            e.preventDefault();

            searchForm.submit();

        }); //검색버튼 이벤트 처리 :e


    }); //e
</script>
<%@include file="../includes/footer.jsp"%>
