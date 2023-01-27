<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<!DOCTYPE HTML>
<html>
<head>
<title><spring:message code="site.title" /></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<link rel="shortcut icon" href="<c:url value='/images/favicon.png' />" />
<link type="text/css" href="<c:url value='/css/body.css' />" rel="stylesheet" />
<link type="text/css" href="<c:url value='/css/jquery-ui.css' />" rel="stylesheet" />
<style type="text/css">
	.btns,.btns:visited {position:relative;.position:inherit;display:inline-block;margin-right:2px;margin-left:2px;font-family:"돋움", Dotum, Verdana, sans-serif;text-align:center;text-decoration: none;line-height:18px;.margin-top:1px;}
	.btns:active {top:1px;.top:auto;}
	
	.b_gray,.b_gray:visited,.b_gray:link {color:#676767 !important;background:url(<c:url value='/images/user/btn_overlay2.png' />) repeat-x 100%;_background:none;background-color:#efefef;border-left:1px solid #c3c3c3;border-top:1px solid #c3c3c3;border-right:1px solid #a4a4a4;border-bottom:1px solid #a4a4a4;box-shadow:inset 1px 1px 0px #fff;}
	.b_gray:hover {background-color:#dedede;text-decoration:none !important;}
	.b_grayn.on {color:#ff6c00;}
	
	.small.btns,.small.btns:visited {font-size:12px;padding:3px 8px 1px 8px;.padding:2px 8px 2px 8px;border-radius:2px !important;text-decoration: none;font-weight:normal;margin-left:1px !important;margin-right:1px !important;.margin-left:3px !important;}
	
	.down_s {background:url(<c:url value='/images/user/btn_small_down.png' />) no-repeat 2px 3px; padding-left:12px;}
	.up_s {background:url(<c:url value='/images/user/btn_small_up.png' />) no-repeat 2px 3px; padding-left:12px;}
	
	fieldset {border:0;}
    label {display:block;}
    label.radio_label {display:inline;}
    .overflow {height:200px;}
    
    /* content - Paging */
	.paging.ibs {display: flex; align-items: center; justify-content: center;}
	.paging ul{display: flex; align-items: center; justify-content: center; height: 80px; margin-bottom: 20px;}
	.paging li {float: left; padding: 0 5px;}
	.paging li a, .paging li button[type="button"] {display: flex; align-items: center; justify-content: center; height: 26px; min-width: 26px;}
	
	.mobile .paging li a,
	.mobile .paging li button[type="button"] {width: 20px; height: 20px; min-width: auto;}
	
	.paging li a {position: relative; top: -1px; color: #111 !important;}
	.paging li button[type="button"],
	.paging li.first a,
	.paging li.prev a,
	.paging li.next a,
	.paging li.last a {width: 26px; border: 1px solid #ddd; font-size: 0; background-size: cover;}
	.paging li .paging--first, .paging li.first {background-image: url(<c:url value='/images/common/arrow_first.png' />);background-position: center;}
	.paging li .paging--prev, .paging li.prev {background-image: url(<c:url value='/images/common/arrow_prev.png' />);background-position: center;}
	.paging li .paging--next, .paging li.next {background-image: url(<c:url value='/images/common/arrow_next.png' />);background-position: center;}
	.paging li .paging--last, .paging li.last {background-image: url(<c:url value='/images/common/arrow_last.png' />);background-position: center;}
	
	.pagination>li.page>a {border: none !important; color: #111 !important;}
	
	.pagination>li>a,
	.pagination>li>span,
	.pagination>.disabled>a,
	.pagination>.disabled>a:focus,
	.pagination>.disabled>a:hover,
	.pagination>.disabled>span,
	.pagination>.disabled>span:focus,
	.pagination>.disabled>span:hover,
	.pagination>.active>a,
	 /* .pagination>.active>a:focus, */
	.pagination>.active>a:hover,
	.pagination>.active>span,
	.pagination>.active>span:focus,
	.pagination>.active>span:hover{padding: 0 !important; background-color: transparent !important; color: #111 !important; border: 1px solid #ddd;}
	
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
		top: 20%;
		left: 43%;
		position: absolute;
		z-index: 100;
	}
</style>
<script type="text/javascript" src="<c:url value='/js/jquery-3.4.1.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.alphanumeric.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.blockUI.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/global.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/tradefundCommon.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/common.js' />"></script>
<!-- IBSheet7 -->
<script type="text/javascript" src="<c:url value='/lib/ibsheet/${profile}/ibleaders.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheetinfo.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheet.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibexcel-min.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheetHeader.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheetcommon.js' />"></script>
<!-- SmartEditor2 -->
<script type="text/javascript" src="<c:url value='/lib/smarteditor2/js/HuskyEZCreator.js' />" charset="utf-8"></script>
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
</script>
</head>
<body>
<div id="wrap">
	<div id="container">
		<div id="column_popup">
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