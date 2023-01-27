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
			<p>권한이 없습니다.</p>
		</div>
		<div class="cont">
			<p>해당 메뉴에 대한 접근 권한이 없습니다.</p>
			<p class="mt-40">메뉴 접근 권한은 KITA운영센터 혹은 DX추진실에 문의 바랍니다.</p>
		</div>
		<div class="btn_group mt-40 _center">
			<a href="javascript:history.back();" class="btn btn_primary">이전으로</a>
		</div>
	</div>
</div>
</body>
</html>