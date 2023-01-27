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
<script type="text/javascript">
	alert('<%=msg%>');
</script>