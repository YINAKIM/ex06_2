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
