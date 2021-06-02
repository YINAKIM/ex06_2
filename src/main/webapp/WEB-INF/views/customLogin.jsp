<%--
  Created by IntelliJ IDEA.
  User: kim-yina
  Date: 2021/05/30
  Time: 8:12 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<input type="hidden" name="_csrf" value="1d33071e-79f5-4433-857f-1aa9fab27249" /> 이렇게 나오는데,
인터넷 사용기록 삭제 후 다시 /sample/admin으로 요청 > customLogin으로 이동하게 되어 페이지소스보기 하면
   <input type="hidden" name="_csrf" value="78ccf32a-f931-48bb-adbd-83124d3c9c28" /> =====> 이렇게 토큰값이 다르게 지정된다 : 그때그때 바뀌는 값을 보낸다는 의미

   CSRF공격 방지를 위해
   [1] 서버 ~~~> 브라우저에게 데이터를 전송할 때 CSRF토큰값을 같이 보내고
   [2] 사용자가 POST작업시, hidden으로 받은 value="${_csrf.token}" 으로
       서버가 보낸 CSRF토큰값(보관하고있었음) vs 브라우저가 갖고있는(hidden으로 들어옴) 토큰 값을 비교한다
   [3] 여기서 두 토큰 값이 다르다면? ---> CSRF공격으로 인지, 방어를 위해 POST작업을 처리하지 않는다.


   ( p.637 ---> 읿반적으로는 세션으로 보관 ? 브라우저 세션으로 보관한다는거 같은데 이게 세션에 보관되는게
   편한건 알겠는데 방어에 취약하지 않은거라는건지는 보안책 더 찾아볼 것)

   ==================== CSRF 방어 방법 ====================

    CSRF공격이 원래 사용자의 요청에 대한 출처(사용자를 신뢰)를 검사하지 않아서 생기는 약점으로 공격받게 되기때문에
    [방어1] 사용자의 요청에 대한 출처(referer) 헤더를 체크
    [방어2] 일반적으로 잘 사용하지 않는 REST방식의 PUT, DELETE 등의 방식으로 작업처리 (POST가 더 취향하니까) ---> 근데 이거 더 자세히 알아볼 것
   ==================== CSRF 방어 방법 ====================

value값은 임의로 생성된 csrf토큰값 지정된다.
--%>
    <div>
        <input type='text' name='username' value=''>
    </div>
    <div>
        <input type='password' name='password' value=''>
    </div>
    <div>
        <div>
                                   <%-- 자동로그인하기 위한 사용자정보를 DB에 저장하게 하는 name='remember-me' --%>
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
