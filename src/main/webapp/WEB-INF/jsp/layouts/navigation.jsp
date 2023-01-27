<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<ol>
	<c:choose>
		<c:when test="${empty selectMenu.upperPgmName}">
			<li><img src="<c:url value='/images/admin/ico_home.png' />" alt="home" /> ${selectMenu.pgmName}</li>
		</c:when>
		<c:otherwise>
			<li><img src="<c:url value='/images/admin/ico_home.png' />" alt="home" /> ${selectMenu.upperPgmName}</li>
			<li>${selectMenu.pgmName}</li>
		</c:otherwise>
	</c:choose>
	<c:if test="${not empty selectMenu.detPgmName}">
		<li>${selectMenu.detPgmName}</li>
	</c:if>
</ol>