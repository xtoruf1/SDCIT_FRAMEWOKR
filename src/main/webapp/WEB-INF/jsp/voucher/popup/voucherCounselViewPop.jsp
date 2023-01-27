<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="flex">
	<h2 class="popup_title">바우처 위원 정보</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<form id="frm" name="frm" method="post">
	<input type="hidden" name="vmstSeq" id="pVmstSeq" value="${params.vmstSeq}">
	<input type="hidden" name="tradeNo" id="pTradeNo" value="${params.tradeNo}">
	<input type="hidden" name="vouSettSeq" id="vouSettSeq" value="${params.vouSettSeq}">
	<input type="hidden" name="expertName" id="expertName" value="${params.expertName}">
	<input type="hidden" name="expertAccount" id="expertAccount" value="${params.expertAccount}">
	<input type="hidden" name="taxFixAmt" id="taxFixAmt" value="${params.taxFixAmt}">
	<input type="hidden" name="localTax" id="localTax" value="${params.localTax}">
	<input type="hidden" name="incomeTax" id="incomeTax" value="${params.incomeTax}">
	<input type="hidden" name="fixAmt" id="fixAmt" value="${params.fixAmt}">
	<div>
		<div id="counselListSheet" class="sheet"></div>
	</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){
		setSheetHeader_counselList();
		getCounsel();
	});

	function setSheetHeader_counselList() {
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '바우처 시퀀스'		, Type: 'Text'			, SaveName: 'vmstSeq'			, Hidden: true});
		ibHeader.addHeader({Header: '서비스'			, Type: 'Text'			, SaveName: 'voucherName'		, Edit: false	, Width: 40		, Align: 'Left'});
		ibHeader.addHeader({Header: '계좌정보'			, Type: 'Text'			, SaveName: 'expertAccount'		, Edit: false	, Width: 40		, Align: 'Left'});
		ibHeader.addHeader({Header: '예금명'			, Type: 'Text'			, SaveName: 'expertName'		, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '정산승인액'		, Type: 'Int'			, SaveName: 'fixAmt'			, Edit: false	, Width: 25		, Align: 'Right'});
		ibHeader.addHeader({Header: '소득세'			, Type: 'Int'			, SaveName: 'localTax'			, Edit: false	, Width: 25		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '주민세'			, Type: 'Int'			, SaveName: 'incomeTax'			, Edit: false	, Width: 25		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '원천세 차감액'		, Type: 'Int'			, SaveName: 'taxFixAmt'			, Edit: false	, Width: 30		, Align: 'Right'	, Format: 'Integer'});


		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#counselListSheet')[0];
		if (typeof container !== 'undefined' && typeof counselListSheet.Index !== 'undefined') {
			counselListSheet.DisposeSheet();
		}
		createIBSheet2(container, 'counselListSheet', '1000px', '10%');
		ibHeader.initSheet('counselListSheet');

		counselListSheet.SetEllipsis(1); // 말줄임 표시여부

	}

	function getCounsel() {

		var frm = $('#frm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherCounsel.do"
			, contentType : 'application/json'
			, data : JSON.stringify(frm)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				counselListSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});

	}

</script>
