<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<!DOCTYPE HTML>
<html>
<head>
<title><spring:message code="site.title" /></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="<c:url value='/js/jquery-3.4.1.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
</head>
<body style="margin: 10 10 10 10;border: 0 0 0 0;">
	<table class="screen_title_table">
		<tr height="2">
			<td colspan="2"></td>
		</tr>
		<tr height="25">
			<td width="16" valign="middle"><img src="<c:url value='/images/icon/bullet_03.gif' />" /></td>
			<td id="title" name="title" style="width: 100%;font-weight: bold;"></td>
		</tr>
	</table>
	<div id="content" name="content" style="widht: 100%;height: 100%;"></div>
</body>
<script type="text/javascript">
	$(document).ready(function(){
		$('#title').html(opener.document.getElementById('title').value);
		$('#content').html(opener.document.getElementById('content').value);
	});
</script>
</html>