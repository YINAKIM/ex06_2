<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--
  Created by IntelliJ IDEA.
  User: kim-yina
  Date: 2021/05/30
  Time: 9:31 오전
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
    <title>all</title>
</head>
<body>
<%-- all / member / admin --%>
<h1>/sample/all page</h1>

<sec:authorize access="isAnonymous()">
    <a href="/customLogin">로그인</a>
</sec:authorize>

<sec:authorize access="isAuthenticated()">
    <a href="/springLogout">로그OUT</a>
</sec:authorize>


</body>
</html>
