<%--
-	등록, 수정, 삭제 처리후 메시지 보여주기.
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="egovframework.common.util.MessageUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String message = null;
	
	String script = (String)request.getAttribute("script");										// 실행하고싶은 자바스크립트 문자열 (메시지 alert 이전 스크립트 작업).
	String next = (String)request.getAttribute("next");											// redirect URL.
	String redirect = (String)request.getAttribute("redirect"); 								// request 파라미터를 next에 보존할지 여부. true or false.
	if (redirect == null) {
		redirect = "false";																		// request 파라미터를 보존한다.
	}
	String target = (String)request.getAttribute("target");										// redirect target
	String messageId = (String)request.getAttribute("messageId");								// alert 메시지 아이디.
	String premessage = (String)request.getAttribute("premessage"); 							// alert 메시지 앞에 붙일 추가 메시지 (사람 이름 등).
	String onBefore = (String)request.getAttribute("onBefore");									// 메시지 alert 이전 자바스크립트 작업.	
	String onAfter = (String)request.getAttribute("onAfter");									// 메시지 alert 이후 자바스크립트 작업.	
	
	if (target == null) {
		target = "_self";
	}
	if (premessage == null) {
		premessage = "";
	}
	if (onAfter == null) {
		onAfter = "";
	}
%>
<script language="javascript">
<%
	if (script != null) {
		out.println(script);
	}

	if (onBefore != null) {
		out.println(onBefore);
	}
	
	if (messageId != null) {
		message = MessageUtil.getMessage(messageId);
		if (message != null) {
			message = message.replaceAll("\"", "'");
			out.println("alert(\"" + premessage + message + "\");");
		}
	}
	
	if (next != null && redirect.equals("true")) {
		out.println("window.location.href='" + next + "'");
	} else if (next == null) {
		// next가 없고 팝업창이면 자동으로 닫는다.
		out.println("if (opener) window.close();");
	}
	out.println(onAfter);
%>
</script>
<% 
	if (next != null && redirect.equals("false")) { 
%>
<body onload="myForm.submit();">
<form name="myForm" action="<%=next%>" method="post" target="<%=target%>">
<%
	String key = null;
	for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {	
		key = (String)e.nextElement();
%>
	<input type="hidden" name="<%=key%>" value="<%=request.getParameter(key)%>" />
<%			
	}
%>
</form>
</body>
<% 
	} 
%>