<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.StringWriter" %>
<%
	Throwable exceptions = null;
	exceptions = (Throwable)request.getAttribute("javax.servlet.error.exception");
	StringWriter stringWriter = new StringWriter();
	exceptions.printStackTrace(new PrintWriter(stringWriter));
	String msg = exceptions.getMessage();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>허용되지 않은 접근입니다.</title>
</head>
<body>
<section class="errorBox content clfix iframe">
	<article class="errorContent">
		<div class="flexBox">
			<img src="<c:url value='/images/common/alert.png' />" alt="" />
			<dl>
				<dt><%=msg%></dt>
				<dd class="detailComment">
					시스템 관리자에게 문의하시기 바랍니다.
				</dd>
			</dl>
		</div>
		<div id="divErrorMsg" style="display: none;"><%=stringWriter.toString()%></div>
	</article>
</section>
</body>
</html>