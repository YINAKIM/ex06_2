<%--
  Created by IntelliJ IDEA.
  User: kim-yina
  Date: 2021/05/30
  Time: 9:31 오전
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
    <title>admin</title>
</head>
<body>

<h1>/sample/admin page</h1>
<p>
    <b>principal(jsp에서 principal)</b> : <sec:authentication property="principal"/></p>
<p>
    <b>MemberVO(jsp에서 principal.member)</b> : <sec:authentication property="principal.member"/></p>
<p>
    <b>사용자 이름(jsp에서 principal.member.userName)</b> : <sec:authentication property="principal.member.userName"/></p>
<p>
    <b>사용자 ID(jsp에서 principal.username)</b> : <sec:authentication property="principal.username"/></p>
<p>
    <b>사용자가 가진 권한 리스트(jsp에서 principal.member.authList)</b> : <sec:authentication property="principal.member.authList"/></p>

<%--
실행결과
principal(jsp에서 principal) : org.zerock.security.domain.CustomUser@bc1272a6: Username: admin90; Password: [PROTECTED]; Enabled: true; AccountNonExpired: true; credentialsNonExpired: true; AccountNonLocked: true; Granted Authorities: ROLE_ADMIN
MemberVO(jsp에서 principal.member) : MemberVO(userid=admin90, userpw=$2a$10$1hX3MnLTP2GHHgX.Hwlr/u81S3AGLm61tVbTBHwUbJ/PMA2N9lk36, userName=관리자90, enabled=false, regDate=Tue Jun 01 11:29:08 KST 2021, updateDate=Tue Jun 01 11:29:08 KST 2021, authList=[AuthVO(userid=admin90, auth=ROLE_ADMIN)])
사용자 이름(jsp에서 principal.member.userName) : 관리자90
사용자 ID(jsp에서 principal.username) : admin90
사용자가 가진 권한 리스트(jsp에서 principal.member.authList) : [AuthVO(userid=admin90, auth=ROLE_ADMIN)]
--%>

<a href="/customLogout">커스텀로그아웃</a>
<%--얘는 내가 만든거 : Controller라고 되어있었음--%>
<br>
<a href="/springLogout">로그아웃(springSecurity가 처리하는거)</a>
<%--얘는  : (Spring Security)라고 되어있었음--%>

</body>
</html>
