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

      <%--    row ~ panel panel-default       --%>
<%--          </div></div></div>--%>
<%--    </div></div></div>--%>
      <%--    panel-default  ~ col-lg-6  --%>
              <script type="text/javascript">
                $(document).ready(function(){

                  var formObj = $("form");

                  $("button").on("click",function(e){

                    e.preventDefault();                   // <form>태그 안의 button은 기본적으로 submit
                                                          // button의 기본이벤트를 막고
                    var operation = $(this).data("oper"); // data-oper에 따라 작업 지정 후
                    console.log(operation);

                    if(operation==='remove'){
                      // remove 페이지로
                      formObj.attr("action","/board/remove ");

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
                    }

                    formObj.submit();                    // 직접 submit()
                  });
                });

              </script>

          <%@include file="../includes/footer.jsp"%>

