<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE HTML>
<html>
<head>
<title><spring:message code="site.title" /></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="<c:url value='/js/jquery-3.4.1.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/global.js' />"></script>
</head>

<body>

<form id="fundFaxSendPopupForm" name="fundFaxSendPopupForm" method="get" onsubmit="return false;">
<input type="hidden" name="svrId"   id="svrId"  	value="<c:out value="${param.svrId}"/>" />
<input type="hidden" name="applyId" id="applyId" 	value="<c:out value="${param.applyId}"/>" />
<style>
h2 {margin:0; padding:0; -webkit-tap-highlight-color:rgba(0,0,0,0);box-sizing:border-box;-webkit-font-smoothing:antialiased;}
button{font-size:100%;vertical-align:middle; cursor:pointer; border:0 none; background-color:transparent; outline:none; text-align:left; font-family: 'Noto Sans KR', sans-serif;}
.btn{display:inline-flex; justify-content:center; align-items:center; width:200px; max-width:100%; padding:8px 10px; font-size:18px; font-weight:400; color:#fff; border-radius:2em; transition:all 0.2s ease;}
.btn_sm{display:inline-flex; padding:5px 15px; font-size:15px; font-weight:400; color:#fff; border-radius:6px; transition:all 0.2s ease;}
.btn_sm+.btn_sm{margin-left:5px;}
.btn:hover:not(.disabled),
.btn_sm:hover:not(.disabled){box-shadow:3px 3px 8px rgba(0,0,0,.3);}
.btn_primary{background-color:#2B5075;}
.btn_secondary{background-color:#9C9C9C;}
.ml-auto{margin-left:auto;}
.flex{display:flex;}
.popContinent{padding:30px;}
.popContinent h2,
.popup_title{margin-bottom:25px; font-size:20px; font-weight:700; color:#1A1915;}
@media print {
    html, body { -webkit-print-color-adjust:exact; width: 210mm; height: 297mm; }
    table { page-break-inside:auto; }
    tr    { page-break-inside:avoid; page-break-after:auto; }
    thead { display:table-header-group; }
    tfoot { display:table-footer-group; }
    .print_flex_tit{display:none;}
    .popup_body .tit_bar{display:none;}
}
</style>

<!-- 팝업 타이틀 -->
<div class="flex print_flex_tit">
	<h2 class="popup_title">KITA무역진흥자금 융자 상세 조회</h2>
	<div class="ml-auto">
		<c:if test='${faxChk eq ""}'>
			<button type="button" class="btn_sm btn_primary bnt_modify_auth" 	onclick="doSend()">FAX 발송</button>
		</c:if>
		<button type="button" class="btn_sm btn_primary" 		onclick="doFundFaxSendPopupPrint()">인쇄</button>
		<button type="button" class="btn_sm btn_secondary" 	onclick="doClear()">닫기</button>
	</div>
</div>
<div class="popup_body">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">무역기금 추천서 발송</h3>
	</div>
	<!-- 테그 영역 -->
	<%-- <c:out value="${faxinfo.faxfilestring}" escapeXml="false" /> --%>

	<c:if test="${formCnt eq '0' }">
		<c:out value="${faxinfo.faxfilestring}" escapeXml="false" />
	</c:if>

	<c:if test="${formCnt ne '0'}">
		<c:forEach var="item" items="${faxinfoList}" varStatus="status">

		<div id="add_<c:out value="${status.count}"/>">
			<c:out value="${item.faxfilestring}" escapeXml="false" />
		</div>

		</c:forEach>
	</c:if>



	<!-- //테그 영역 -->
</div>
</form>
</body>

<script>
$(document).ready(function() {
	  $(".modal").on("click", function(e){
		   if(!$(e.target).is($(".modal-content, .modal-content *"))){
		    closeLayerPopup();
		   }
		  });
});

	//FAX발송
	function doSend(){

		if(!confirm("팩스를 발송하시겠습니까?")){
			return;
		}

		//global.ajax({
		$.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/fundFaxSendProcess.do" />'
			, data : $('#fundFaxSendPopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				alert('전송 하였습니다.');
			}
		});
	}

	//인쇄
	function doFundFaxSendPopupPrint(){
		var initBody;

		window.onbeforeprint = function(){
			initBody = document.body.innerHTML;

	 		document.getElementsByClassName('tit_bar')[0].style.display = "none";
	 		document.getElementsByClassName('popup_title')[0].style.display = "none";
	 		document.getElementsByClassName('ml-auto')[0].style.display = "none";

		};
		window.onafterprint = function(){
			document.body.innerHTML = initBody;
		};
		window.print();
	}

	//닫기
	function doClear(){
		window.close();
// 		closeLayerPopup();
	}
</script>
</html>