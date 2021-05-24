<%--
  Created by IntelliJ IDEA.
  User: kim-yina
  Date: 2021/05/24
  Time: 5:22 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
                                                    <%--꼭체크 enctype="multipart/form-data" --%>
    <form action="uploadFormAction" method="post" enctype="multipart/form-data">
        <input type="file" name="uploadFile" multiple>
                                        <%-- multiple속성 : 하나의 input태그로 한꺼번에 여러 개의 파일을 업로드  (IE는 10이상에서만 사용가능) --%>
        <button>업로드Submit</button>
    </form>
</body>
</html>
