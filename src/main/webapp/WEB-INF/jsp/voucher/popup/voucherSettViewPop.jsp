<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="flex">
	<h2 class="popup_title">바우처 정산 목록</h2>
	<div class="ml-auto">
		<c:if test="${ param.status eq 'U'}">
			<button type="button" id="btnSave" class="btn_sm btn_primary" onclick="doSave();">저장</button>
		</c:if>
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<div class="popup_body">
	<div class="cont_block" id="divSheet" style="width: 1000px;">
		<form name="frm" action ="" method="post">
			<input type="hidden" name="dasdsad" id="pStatus" value="${param.status}">
			<input type="hidden" name="vmstSeq" id="pVmstSeq" value="${params.vmstSeq}">
			<input type="hidden" name="tradeNo" id="pTradeNo" value="${params.tradeNo}">
			<input type="hidden" name="vouSettSeq" id="pVouSettSeq" value="${params.vouSettSeq}">

			<div style="width: 100%;height: 100%;">
				<div id="voucherSettListSheet" class="sheet"></div>
			</div>
		</form>
	</div>
</div>

<script type="text/javascript">

	var saveYn = 'N';

	$(document).ready(function(){
		setSheetHeader_voucherSettList();
		getVoucherSettList();
	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function setSheetHeader_voucherSettList() {

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '상태'				, Type: 'Status'		, SaveName: 'status'			, Hidden: true});
		ibHeader.addHeader({Header: '바우처 시퀀스'			, Type: 'Text'			, SaveName: 'vmstSeq'			, Hidden: true});
		ibHeader.addHeader({Header: '무역업번호'			, Type: 'Text'			, SaveName: 'tradeNo'			, Hidden: true});
		ibHeader.addHeader({Header: '바우처 서비스 코드'		, Type: 'Text'			, SaveName: 'voucherCd'			, Hidden: true});
		ibHeader.addHeader({Header: '정산순번'				, Type: 'Text'			, SaveName: 'accSeq'			, Hidden: true});
		ibHeader.addHeader({Header: '증빙 첨부파일 ID'		, Type: 'Text'			, SaveName: 'receiptFileId'		, Hidden: true});
		ibHeader.addHeader({Header: '결과물 첨부파일 ID'		, Type: 'Text'			, SaveName: 'resultFileId'		, Hidden: true});
		ibHeader.addHeader({Header: '서비스'				, Type: 'Text'			, SaveName: 'voucherName'		, Edit: false	, Width: 40		, Align: 'Left'});
		ibHeader.addHeader({Header: '지원금'				, Type: 'Int'			, SaveName: 'reqAmt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '기정산'				, Type: 'Int'			, SaveName: 'alreadyAccAmt'		, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '잔액'				, Type: 'Int'			, SaveName: 'balanceAmt'		, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '신청액'				, Type: 'Int'			, SaveName: 'aprvReqAmt'		, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '확정금액'				, Type: 'Int'			, SaveName: 'fixAmt'			, Edit: true	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '증빙'				, Type: 'Html'			, SaveName: 'receFileBtn'		, Edit: false	, Width: 15		, Align: 'Center'});
		ibHeader.addHeader({Header: '결과물'				, Type: 'Html'			, SaveName: 'resultFileBtn'		, Edit: false	, Width: 15		, Align: 'Center'});


		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            ToolTip: false});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#voucherSettListSheet')[0];
		if (typeof container !== 'undefined' && typeof voucherSettListSheet.Index !== 'undefined') {
			voucherSettListSheet.DisposeSheet();
		}
		createIBSheet2(container, 'voucherSettListSheet', '100%', '100%');
		ibHeader.initSheet('voucherSettListSheet');

		voucherSettListSheet.SetEllipsis(1); // 말줄임 표시여부
	}

	function voucherSettListSheet_OnRowSearchEnd(row) {
		voucherSettListSheet.SetCellValue(row, 'receFileBtn', '<button type="button"><img src="/images/icon/icon_file.gif" /></button>',0);
		voucherSettListSheet.SetCellValue(row, 'resultFileBtn', '<button type="button"><img src="/images/icon/icon_file.gif" /></button>',0);
	}

	function getVoucherSettList() {

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherSettListPop.do"
			, data : {'vmstSeq' : $('#pVmstSeq').val(),
					  'tradeNo' : $('#pTradeNo').val(),
					  'vouSettSeq' : $('#pVouSettSeq').val()
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				voucherSettListSheet.LoadSearchData({Data: (data.resultList || []) });
				if($('#pStatus').val() == 'R') {
					voucherSettListSheet.SetEditable(0);
				}

				if(saveYn == 'N') {

					if(data.returnRsn != null) {

						var html = '';
						html += '<div class="cont_block" id="divReturnRsn" style="width: 1000px;">';
						html += '	<div class="tit_bar">';
						html += '		<h3 class="tit_block">반려사유</h3>';
						html += '	</div>';
						html += '	<table class="formTable">';
						html += '	<colgroup>';
						html += '		<col style="width:15%";>';
						html += '	</colgroup>';
						html += '		<tr>';
						html += '			<th>반려사유</th>';
						html += '			<td>';
						html += '				<textarea id="return_rsn_dp" class="form_textarea" rows="4" readonly="readonly">'+data.returnRsn+'</textarea>';
						html += '			</td>';
						html += '		</tr>';
						html += '	</table>';
						html += '</div>';

						$('.popup_body').prepend(html);

					} else {
						$('#divSheet').css('width', '1000px');
					}
				}
			}
		});
	}

	function voucherSettListSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {

		var vmstSeq = voucherSettListSheet.GetCellValue(Row, 'vmstSeq');
		var tradeNo = voucherSettListSheet.GetCellValue(Row, 'tradeNo');
		var receiptFileId = voucherSettListSheet.GetCellValue(Row, 'receiptFileId');
		var resultFileId = voucherSettListSheet.GetCellValue(Row, 'resultFileId');

		if(voucherSettListSheet.ColSaveName(Col) == 'receFileBtn'){
			openAttachFilePop(vmstSeq, tradeNo, receiptFileId, '');
		}

		if(voucherSettListSheet.ColSaveName(Col) == 'resultFileBtn'){
			openAttachFilePop(vmstSeq, tradeNo, resultFileId, 'R');
		}
	}

	function openAttachFilePop(vmstSeq, tradeNo, paramFileId, fileType) {

		global.openLayerPopup({
			popupUrl : '/voucher/popup/voucherSettAttachFileViewPop.do'
			, params : {
				'vmstSeq' : vmstSeq,
				'tradeNo' : tradeNo,
				'paramFileId' : paramFileId,
				'paramFileType' : fileType
			}
		});
	}

	function saveValid(){

		var RowCnt = voucherSettListSheet.RowCount();

		for(var i = 1; i <= RowCnt; i++) {

			var fixAmt = voucherSettListSheet.GetCellValue(i, 'fixAmt');
			var balanceAmt = voucherSettListSheet.GetCellValue(i, 'balanceAmt');

			if(balanceAmt < fixAmt) {
				alert(i + '번째 확정금액은 잔액보다 많을 수 없습니다.');
				return false;
			}
		}

		return true;
	}

	function doSave() {

		if(!saveValid()){
			return false;
		}

		if(!confirm("저장 하시겠습니까?")){
			return false;
		}

		var pParamData = voucherSettListSheet.GetSaveJson();

		global.ajax({
			type : 'POST'
			, url : "/voucher/updateVouchrSettFixAmt.do"
			, contentType : 'application/json'
			, data : JSON.stringify(pParamData.data)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				saveYn = 'Y';
				getVoucherSettList();
			}
		});
	}

</script>
