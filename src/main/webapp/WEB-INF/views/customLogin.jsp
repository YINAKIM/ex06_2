<%--
  Created by IntelliJ IDEA.
  User: kim-yina
  Date: 2021/05/30
  Time: 8:12 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
    <title>Title</title>
</head>
<body>

<h1>Custom Login Page</h1>
<h2><c:out value="${error}"/></h2>
<h2><c:out value="${logout}"/></h2>

<form method='post' action="/login">
<%--
실제 로그인 작업은 /login에서 이루어지는데 반드시 POST방식으로 데이터를 전송해야 한다.
---> /login거쳐서 Controller에서는 @GetMapping으로 받을것

[주의1]
<input>의 name 속성은 기본적으노 username, password로 사용

[주의2]
hidden으로 ${_csrf.parameterName}으로 처리, 브라우저에서는 '_csrf'라는 이름으로 처리된다.
브라우저에서 페이지 소스보기하면

value값은 임의로 생성된 csrf토큰값 지정된다.
--%>
    <div>
        <input type='text' name='username' value='admin'>
    </div>
    <div>
        <input type='password' name='password' value='admin'>
    </div>
    <div>
        <div>
            <input type='checkbox' name='remember-me'> Remember Me
        </div>

        <div>
            <input type='submit'>
        </div>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </div>
</form>

</body>
</html>
