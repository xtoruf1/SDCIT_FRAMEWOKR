<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">회원사 선택</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<!-- 팝업 내용 -->
<form id="inaccCompanyForm" method="post">
	<div class="popup_body">
		<div class="cont_block">
			<input type="hidden" id="corpRegNo" name="corpRegNo" value="${param.corpRegNo}">
			<input type="hidden" id="pIssueDate" name="issueDate" value="${param.issueDate }" />
			<input type="hidden" id="pCardStatus" name="cardStatus" value="${param.cardStatus }"/>
			<input type="hidden" id="pCardCode" name="cardCode" value="${param.cardCode }"/>
			<input type="hidden" id="pTradeNo" name="tradeNo" value="">
			<input type="hidden" id="pCorpNameKr" name="corpNameKr" value=""/>
			<input type="hidden" id="pCorpNameEn" name="corpNameEn" value=""/>
			<input type="hidden" id="pRepreNameKr" name="repreNameKr" value=""/>
			<input type="hidden" id="pRepreNameEn" name="repreNameEn" value=""/>
			<input type="hidden" id="pCorpoNo" name="corpoNo" value=""/>
			<div>
				<div id="inaccCompanySheet" class="sheet"></div>
			</div>
		</div>
	</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_inaccCompanyList();
		getInaccCompanyList();
	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function setSheetHeader_inaccCompanyList() {	// 부정확 업체정보 목록 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '업체명'			, Type: 'Text'			, SaveName: 'corpNameKr'	, Edit: false	, Width: 35		, Align: 'Left' , Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '대표자명'			, Type: 'Text'			, SaveName: 'repreNameKr'	, Edit: false	, Width: 25		, Align: 'Center' , Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '무역업번호'		, Type: 'Text'			, SaveName: 'tradeNo'		, Edit: false	, Width: 20		, Align: 'Center' , Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '사업자등록번호'		, Type: 'Text'			, SaveName: 'corpRegNo'		, Edit: false	, Width: 20		, Align: 'Center' , Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '법인번호'			, Type: 'Text'			, SaveName: 'corpNo'		, Hidden: true});
		ibHeader.addHeader({Header: '업체명영문'		, Type: 'Text'			, SaveName: 'corpNameEn'	, Hidden: true});
		ibHeader.addHeader({Header: '대표자명영문'		, Type: 'Text'			, SaveName: 'repreNameEn'	, Hidden: true});


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

		var container = $('#inaccCompanySheet')[0];
		if (typeof container !== 'undefined' && typeof inaccCompanySheet.Index !== 'undefined') {
			inaccCompanySheet.DisposeSheet();
		}

		var container = $('#inaccCompanySheet')[0];
		createIBSheet2(container, 'inaccCompanySheet', '1000px', '100%');
		ibHeader.initSheet('inaccCompanySheet');

		inaccCompanySheet.SetEllipsis(1); 			// 말줄임 표시여부
		inaccCompanySheet.SetSelectionMode(4);

	}

	function inaccCompanySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {

		if(rowType == 'HeaderRow'){
			return;
		}

		if(!confirm('선택한 업체정보로 저장됩니다. 저장하시겠습니까?')) {
			return;
		}

		var tradeNo = inaccCompanySheet.GetCellValue(Row, 'tradeNo');
		var corpRegNo = inaccCompanySheet.GetCellValue(Row, 'corpRegNo');
		var corpNameKr = inaccCompanySheet.GetCellValue(Row, 'corpNameKr');
		var corpNameEn = inaccCompanySheet.GetCellValue(Row, 'corpNameEn');
		var repreNameKr = inaccCompanySheet.GetCellValue(Row, 'repreNameKr');
		var repreNameEn = inaccCompanySheet.GetCellValue(Row, 'repreNameEn');
		var corpNo = inaccCompanySheet.GetCellValue(Row, 'corpNo');

		saveKitaCardInfo(tradeNo, corpRegNo, corpNameKr, corpNameEn, repreNameKr, repreNameEn, corpNo);
	}

	function inaccCompanySheet_OnSearchEnd() {
		// 볼드 처리
		inaccCompanySheet.SetColFontBold('corpNameKr', 1);
		inaccCompanySheet.SetColFontBold('tradeNo', 1);
		inaccCompanySheet.SetColFontBold('corpRegNo', 1);
		inaccCompanySheet.SetColFontBold('repreNameKr', 1);
	}

	function getInaccCompanyList() {	// 사업정보 조회

		global.ajax({
			type : 'POST'
			, url : "/kitaCard/selectInaccuracyMemberList.do"
			, data : {'corpRegNo' : $('#corpRegNo').val()}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				inaccCompanySheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function saveKitaCardInfo(tradeNo, corpRegNo, corpNameKr, corpNameEn, repreNameKr, repreNameEn, corpNo) {

		var config = sortFirstObject(popupConfig, 'desc', 'timestamp');

		$('#pTradeNo').val(tradeNo);
		$('#corpRegNo').val(corpRegNo);
		$('#pCorpNameKr').val(corpNameKr);
		$('#pCorpNameEn').val(corpNameEn);
		$('#pRepreNameKr').val(repreNameKr);
		$('#pRepreNameEn').val(repreNameEn);
		$('#pCorpNo').val(corpNo);

		var inaccCompanyForm = $('#inaccCompanyForm').serializeObject();


		global.ajax({
			type : 'POST'
			, url : "/kitaCard/saveInaccuracyKitaCardInfo.do"
			, contentType : 'application/json'
			, data : JSON.stringify(inaccCompanyForm)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				closeLayerPopup();
				config.callbackFunction(data.flag);
			}
		});
	}

</script>