<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.StringWriter" %>
<%
	Throwable exceptions = null;
	exceptions = (Throwable)request.getAttribute("javax.servlet.error.exception");
	StringWriter stringWriter = new StringWriter();
	exceptions.printStackTrace(new PrintWriter(stringWriter));
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />	
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>오류가 발생했습니다.</title>
</head>
<body>
<section class="errorBox content clfix iframe">
	<article class="errorContent">
		<div class="flexBox">
			<img src="<c:url value='/images/common/alert.png' />" alt="" />
			<dl>
				<dt>요청하신 페이지가 정상적으로 동작하지 않습니다.</dt>
				<dd class="detailComment">
					관리자에게 문의 하시기 바랍니다.
				</dd>
			</dl>
		</div>
		<div id="divErrorMsg" style="display: none;"><%=stringWriter.toString()%></div>
	</article>
</section>
</body>
</html>