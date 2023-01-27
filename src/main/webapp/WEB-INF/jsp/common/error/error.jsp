<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE HTML>
<html>
<head>
<title>Error Page</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<link rel="shortcut icon" href="<c:url value='/images/favicon.png' />" />
<link type="text/css" href="<c:url value='/css/body.css' />" rel="stylesheet" />
</head>
<body>
<div id="wrap" class="wrapper">
	<div class="error_page">
		<div class="top">
			<p>죄송합니다.</p>
			<p>${msg}</p>
		</div>
		<c:if test="${errorType eq '404'}">
			<div class="cont">
				<p>
					방문하시려는 페이지의 주소가 잘못 입력되었거나,<br />
					페이지의 주소가 변경 혹은 삭제되어 요청하신 페이지를 찾을 수 없습니다.
				</p>
				<p class="mt-40">입력하신 주소가 정확한지 다시 한번 확인해 주시기 바랍니다.</p>
			</div>
		</c:if>
		<div class="btn_group mt-40 _center">
			<a href="javascript:void(0);" class="btn btn_primary">이전으로</a>
		</div>
	</div>
</div>
</body>
</html>