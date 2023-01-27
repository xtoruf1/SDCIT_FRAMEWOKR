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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
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
<script type="text/javascript" src="<c:url value='/js/datepicker.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.mtz.monthpicker.js' />"></script>
<script src="<c:url value='/js/jquery.mCustomScrollbar.concat.min.js' />"></script>
<script src="<c:url value='/js/ui.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jsQR.js' />"></script>
<!-- IBSheet7 -->
<script type="text/javascript" src="<c:url value='/lib/ibsheet/${profile}/ibleaders.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheetinfo.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheet.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibexcel-min.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheetHeader.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheetcommon.js' />"></script>

<%-- TOASTUI GRID --%>
<script type="text/javascript" src="<c:url value='/js/tui-grid.js' />"></script>
<link type="text/css" href="<c:url value='/css/tui-grid.css' />" rel="stylesheet" />

<!-- SmartEditor2 -->
<script type="text/javascript" src="<c:url value='/lib/smarteditor2/js/HuskyEZCreator.js' />" charset="utf-8"></script>
<script type="text/javascript">
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
<div id="wrap">
	<div id="container">
		<div id="column_popup">
			<tiles:insertAttribute name="header" />
			<tiles:insertAttribute name="body" />
		</div>
	</div>
</div>
<div id="modalLayerPopup">
</div>
<div id="loading_wrapper" class="loading_wrapper">
	<img src="<c:url value='/images/common/loading.gif' />" class="loading_image" />
</div>
</body>
</html>