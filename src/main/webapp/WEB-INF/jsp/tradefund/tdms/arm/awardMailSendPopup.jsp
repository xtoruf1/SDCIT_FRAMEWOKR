<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
<!--
	/* button */
	button {
	    font-size: 100%;
	    vertical-align: middle;
	    cursor: pointer;
	    border: 0 none;
	    background-color: transparent;
	    outline: none;
	    text-align: left;
	    font-family: 'Noto Sans KR', sans-serif;
	}

	.btn {display:inline-flex; justify-content:center; align-items:center; width:200px; max-width:100%; padding:8px 10px; font-size:18px; font-weight:400; color:#fff; border-radius:2em; transition:all 0.2s ease;}
	.btn_sm {display:inline-flex; padding:5px 15px; font-size:15px; font-weight:400; color:#fff; border-radius:6px; transition:all 0.2s ease;}
	.btn_sm+.btn_sm {margin-left:5px;}
	.btn:hover:not(.disabled),
	.btn_sm:hover:not(.disabled) {box-shadow:3px 3px 8px rgba(0,0,0,.3);}
	.btn_primary {background-color:#2B5075;}
	.btn_secondary {background-color:#9C9C9C;}
	.btn.disabled,
	.btn_tbl.disabled,
	.btn_sm.disabled {color:#5C5F68; border:1px solid #ccc; background-color:#ddd; cursor:default;}
	.btn_tbl {display:inline-flex; justify-content:center; align-items:center; margin:0 2px; padding:5px 15px; font-size:14px; font-weight:400; color:#fff; border-radius:6px; background-color:#1A1915;}
	.btn_tbl_border {display:inline-flex; justify-content:center; align-items:center; margin:0 2px; padding:4px 14px; font-size:14px; font-weight:400; color:#1A1915; border:1px solid #1A1915; border-radius:6px; background-color:#fff;}
	.btn_tbl_primary {display:inline-flex; justify-content:center; align-items:center; margin:0 2px; padding:4px 14px; font-size:14px; font-weight:400; color:#fff; border:1px solid #1A1915; border-radius:6px; background-color:#2B5075;}
	.btn_tbl_secondary {display:inline-flex; justify-content:center; align-items:center; margin:0 2px; padding:5px 15px; font-size:14px; font-weight:400; color:#fff; border-radius:6px; background-color:#9C9C9C;}
	.btn_tbl._full,
	.btn_tbl_primary._full,
	.btn_tbl_border._full {width:100%; margin:0;}
	.GridMain1 .GridMain2 .btn_tbl {display:inline-flex; justify-content:center; align-items:center; margin:0 2px; padding:5px 15px; font-size:14px; font-weight:400; color:#fff; border-radius:6px; background-color:#1A1915;}
-->
</style>
<div id="printId" style="text-align: right;padding-bottom: 10px;">
	<button type="button" onclick="printPage();" class="btn_sm btn_primary">인쇄하기</button>
	<button type="button" onclick="window.close();" class="btn_sm btn_secondary">닫기</button>
</div>
${mailfilestring}
<script type="text/javascript">
	function printPage() {
		document.getElementById('printId').style.display = 'none';

		window.print();

		document.getElementById('printId').style.display = '';
	}
</script>