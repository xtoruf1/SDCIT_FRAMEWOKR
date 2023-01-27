<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
<title><spring:message code="site.title" /></title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<link rel="shortcut icon" href="<c:url value='/images/favicon.png' />" />
<link type="text/css" href="<c:url value='/css/body.css' />" rel="stylesheet" />
</head>
<body>
<div id="wrap" class="wrapper">
	<div class="error_page">
		<h1 class="logo">
			<a href="<c:url value='/' />"><img src="<c:url value='/images/common/logo01.png' />" style="width: 80%;height: 80%;" alt="한국무역지원서비스" /></a>
		</h1>
		<c:choose>
			<c:when test="${authMenuCnt eq 0}">
				<div class="top">
					<p>접근 가능한 시스템 권한이 없습니다.</p>
				</div>
			</c:when>
			<c:otherwise>
				<div class="top">
					<p>접속하고자 하는 관리시스템을 클릭해 주세요.</p>
				</div>
				<div class="system_list">
					<ul>
						<c:forEach var="menu" items="${systemMenuList}" varStatus="status">
						<li>
						    <a href="<c:url value='${menu.url}' />" target="${menu.linkTarget}">${menu.systemMenuName}</a>
						</li>
						</c:forEach>
					</ul>
				</div>
			</c:otherwise>
		</c:choose>
	</div>
</div>
</body>
</html>