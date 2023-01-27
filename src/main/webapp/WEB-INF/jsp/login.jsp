<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<!DOCTYPE HTML>
<html>
<head>
	<title><spring:message code="site.title" /></title>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
	<link rel="shortcut icon" href="<c:url value='/images/favicon.png' />" />
	<link type="text/css" href="<c:url value='/css/body.css' />" rel="stylesheet" />
	<style type="text/css">
		.loading_wrapper {
			top: 0px;
			left: 0px;
			width: 100%;
			height: 100%;
			position: fixed;
			display: none;
			opacity: 0.7;
			background-color: #fff;
			text-align: center;
			z-index: 99;
		}

		.loading_image {
			top: 30%;
			left: 43%;
			position: absolute;
			z-index: 100;
		}
	</style>
	<script type="text/javascript" src="<c:url value='/js/jquery-1.12.4.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/global.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/common.js' />"></script>
	<script type="text/javascript">
		var f;
		$(document).ready(function(){
			f = document.loginForm;
			f.pwd.focus();
		});

		function isValid() {
			if (isStringEmpty(f.loginId.value)) {
				alert('아이디를 입력해 주세요.');
				return false;
			}
			if (isStringEmpty(f.pwd.value)) {
				alert('비밀번호를 입력해 주세요.');
				return false;
			}

			return true;
		}

		function doLogin() {
			if (isValid()) {
				$('#loading_wrapper').show();

				global.ajax({
					type : 'POST'
					, url : '<c:url value="/processLogin.do" />'
					, data : $('#loginForm').serialize()
					, dataType : 'json'
					, async : true
					, spinner : false
					, success : function(data){
						if (isStringEmpty(data.message)) {
							location.href = data.next;
						} else {
							alert(data.message);
						}

						$('#loading_wrapper').hide();
					}
				});
			}
		}
	</script>
</head>
<body>
<form id="loginForm" name="loginForm" method="post">
	<div id="loading_wrapper" class="loading_wrapper">
		<img src="<c:url value='/images/common/loading.gif' />" class="loading_image" />
	</div>
	<div id="main">
		<div class="logo">
			<img src="<c:url value='/images/common/logo_ci_01.png' />" title="SDCIT" />
		</div>
		<div class="log">
			<ul>
				<li>
					<img src="<c:url value='/images/admin/main_id.jpg' />" title="사용자계정" />
					<input type="text" id="loginId" name="loginId" value="admin" style="ime-mode:inactive" tabindex="1" title="아이디" />
				</li>
				<li>
					<img src="<c:url value='/images/admin/main_pw.jpg' />" title="비밀번호" />
					<input type="password" id="pwd" name="pwd" value="1111" onkeydown="onEnter(doLogin);" tabindex="2" title="비밀번호" />
				</li>
			</ul>
			<ul>
				<li>
					<a href="javascript:doLogin();">
						<img src="<c:url value='/images/admin/main_login.jpg' />" tabindex="3" title="로그인" />
					</a>
				</li>
			</ul>
		</div>
	</div>

	<%--(Profile : ${profile})--%>
</form>
</body>
</html>