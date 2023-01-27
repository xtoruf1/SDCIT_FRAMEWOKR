<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<title><spring:message code="site.title" /></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<link rel="shortcut icon" href="<c:url value='/images/favicon.png' />" />
<link type="text/css" href="<c:url value='/css/body.css' />" rel="stylesheet" />
<link type="text/css" href="<c:url value='/css/jquery-ui.css' />" rel="stylesheet" />
<link type="text/css" href="<c:url value='/css/jquery.mCustomScrollbar.min.css?ver=0.1' />" rel="stylesheet" />
<script type="text/javascript" src="<c:url value='/js/jquery-3.4.1.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.alphanumeric.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.blockUI.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/global.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/tradefundCommon.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/common.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/fileviewer.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/datepicker.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.mtz.monthpicker.js' />"></script>
<script src="<c:url value='/js/jquery.mCustomScrollbar.concat.min.js' />"></script>
<script src="<c:url value='/js/ui.js' />"></script>
<script src="<c:url value='/js/tradefundLib.js' />"></script>
<!-- IBSheet7 -->
<script type="text/javascript" src="<c:url value='/lib/ibsheet/${profile}/ibleaders.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheetinfo.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheet.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibexcel-min.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheetHeader.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheetcommon.js' />"></script>

<%-- TOASTUI GRID --%>
<%--<script type="text/javascript" src="<c:url value='/js/tui-grid.js' />"></script>
<link type="text/css" href="<c:url value='/css/tui-grid.css' />" rel="stylesheet" />--%>
<link rel="stylesheet" href="https://uicdn.toast.com/grid/latest/tui-grid.css" />
<script src="https://uicdn.toast.com/grid/latest/tui-grid.js"></script>

<!-- SmartEditor2 -->
<script type="text/javascript" src="<c:url value='/lib/smarteditor2/js/HuskyEZCreator.js' />" charset="utf-8"></script>
<!-- billboardChart -->
<script type="text/javascript" src="<c:url value='/lib/billboard/d3.v5.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/billboard/billboard.js' />"></script>
<link type="text/css" href="<c:url value='/lib/billboard/billboard.css' />" rel="stylesheet" />
<!-- 연도 picker -->
<link type="text/css" href="<c:url value='/css/yearpicker.css' />" rel="stylesheet">
<script type="text/javascript" src="<c:url value='/js/yearpicker.js' />"></script>
<!-- Tabulator -->
<%-- <script type="text/javascript" src="<c:url value='/lib/tabulator/tabulator.js' />"></script> --%>
<%-- <link type="text/css" href="<c:url value='/css/tabulator.css' />" rel="stylesheet"> --%>
<%-- <link type="text/css" href="<c:url value='/css/tabulator_modern.css' />" rel="stylesheet"> --%>
<!-- <link href="https://unpkg.com/tabulator-tables@5.4.3/dist/css/tabulator.min.css" rel="stylesheet"> -->
<!-- <script type="text/javascript" src="https://unpkg.com/tabulator-tables@5.4.3/dist/js/tabulator.min.js"></script> -->
<!-- JUI -->
<%-- <script type="text/javascript" src="<c:url value='/lib/jui/jui-core.js' />"></script> --%>

<%-- <link type="text/css" href="<c:url value='/css/jui-ui.classic.css'/>" rel="stylesheet"/> --%>
<%-- <script src="<c:url value='/lib/jui/jui-ui.js'/>"></script> --%>

<%-- <link type="text/css" href="<c:url value='/css/jui-grid.classic.css'/>" rel="stylesheet"/> --%>
<%-- <script src="<c:url value='/lib/jui/jui-grid.js'/>"></script> --%>

<script type="text/javascript">
	$(document).ready(function() {
		// 쓰기권한
		if ('${pageModifyYn}' == 'Y') {
			$('.btn_modify_auth').removeClass('hide');
		} else if ('${user.infoCheckYn}' == 'N') {
			$('.btn_modify_auth').removeClass('hide');
		} else if ('${pageModifyYn}' == 'N') {
			$('.btn_modify_auth').addClass('hide');
		}
	});

	// 로드되면 DATE PICKER 처리
	$(window).on('load', function(){
		// MONTH PICKER
		jqueryMonthpicker('monthpicker');

		// DATE PICKER
		jqueryDatepicker('datepicker');
		$('.ui-datepicker-trigger').on('click', function(){
			$(this).datepicker('show');
		});

		// DOM 중복 아이디 체크
		// checkDuplicateDomId();
	});

	// 검색날짜 변경
	function changeSearchDate(type) {
		var date = new Date();
		var startDt = $('#searchStartDate');
		var endDt = $('#searchEndDate');

		endDt.datepicker('setDate', 'today');

		if (type == '1') {
			date.setDate(date.getDate() - 7);
		} else if (type == '2') {
			date.setMonth(date.getMonth() - 1);
		} else if (type == '3') {
			date.setMonth(date.getMonth() - 3);
		}

		startDt.datepicker('setDate', date);
	}
</script>
</head>
<body>
	<div id="wrap" class="wrapper">
		<!-- 왼쪽 메뉴 시작 -->
		<tiles:insertAttribute name="leftMenu" />
		<!-- 왼쪽 메뉴 끝 -->
		<div id="container" class="container">
			<!-- 헤더 시작 -->
			<div>
				<tiles:insertAttribute name="header" />
			</div>
			<!-- 헤더 끝 -->
			<!-- 오른쪽 바디 시작 -->
			<div id="column_right" class="contents_body">
				<div class="contents_body_inner">
					<div class="body_inner_scroll">
						<tiles:insertAttribute name="body" />
					</div>
				</div>
			</div>
			<!-- 오른쪽 바디 끝 -->
		</div>
	</div>
	<div id="modalLayerPopup">
	</div>
	<!--
	<div id="loading_wrapper" class="loading_wrapper">
		<img src="<c:url value='/images/common/loading.gif' />" class="loading_image" />
	</div>
	-->
	<div id="loading_image" class="loading_wrapper">
		<img src="<c:url value='/images/common/loading.gif' />" class="loading_image" />
	</div>
	<!-- 페이지 수정권한(레이어 팝업용) -->
	<input type="hidden" id="popupModify" value="${pageModifyYn}" />
</body>
</html>