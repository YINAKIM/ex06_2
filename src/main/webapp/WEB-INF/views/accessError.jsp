<%--
  Created by IntelliJ IDEA.
  User: kim-yina
  Date: 2021/05/30
  Time: 7:53 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/tags" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <h1>Access Denied</h1>

    <h2><c:out value="${SPRING_SECURITY_403_EXCEPTION.getMessage()}"/></h2>
    <h2><c:out value="${msg}"/></h2>
</body>
</html>
