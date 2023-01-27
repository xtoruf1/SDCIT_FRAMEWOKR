<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">신청의뢰 등록 - 신청구분 선택</h2>
	<div class="ml-auto">
		<button type="button" onclick="doSet();" class="btn_sm btn_primary">작성</button>
		<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
	</div>
</div>
<div id="coSearchPop" class="layerPopUpWrap popup_body">
	<div class="layerPopUp">
		<div class="layerWrap" style="width: 700px;">
			<div class="box">
				<form id="dlgSearchCorpForm" name="dlgSearchCorpForm">
				<input type="hidden" id="searchYn" name="searchYn" value="N" />
				<input type="hidden" id="svrId" name="svrId" value="<c:out value="${awd0000t.svrId}" />" />
					<table class="boardwrite formTable">
						<colgroup>
							<col style="width: 20%;" />
							<col style="width: 40%;" />
							<col style="width: 20%;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">포상명</th>
								<td colspan="3">
									<c:out value="${awd0000t.bsnNm}" />
								</td>
							</tr>
							<tr>
								<th scope="row">신청접수기간</th>
								<td colspan="3">
									<c:out value="${awd0000t.bsnAplDt}" />
								</td>
							</tr>
							<tr>
								<th scope="row" rowspan="4">신청구분</th>
								<td colspan="3">
									<label class="label_form">
										<input type="radio" name="priType" value="A" class="form_radio" checked="checked" />
										<span class="label">수출의 탑 + 일반유공</span>
									</label>
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<label class="label_form">
										<input type="radio" name="priType" value="T" class="form_radio" />
										<span class="label">수출의 탑</span>
									</label>
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<label class="label_form">
										<input type="radio" name="priType" value="P" class="form_radio" />
										<span class="label">일반유공(수출업체 대표자 및 종업원)</span>
									</label>
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<label class="label_form">
										<input type="radio" name="priType" value="S" class="form_radio" />
										<span class="label">특수유공</span>
									</label>
								</td>
							</tr>
							<tr>
								<th scope="row">사업자등록번호</th>
								<td colspan="2">
									<span class="form_search w100p">
										<input type="text" id="searchBsNo" name="searchBsNo" value="" onkeydown="onEnter(getDlgSearchCorpInfo);return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="10" class="form_text w100p" />
									</span>
								</td>
								<td rowspan="3">
									<div class="ml-auto" style="text-align: center;">
										<button type="button" onclick="getDlgSearchCorpInfo();" class="btn_sm btn_primary">검색</button>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">무역업번호</th>
								<td colspan="2">
									<span class="form_search w100p">
										<input type="text" id="searchMemberId" name="searchMemberId" value="" onkeydown="onEnter(getDlgSearchCorpInfo);return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="8" class="form_text w100p" />
									</span>
								</td>
							</tr>
							<tr>
								<th scope="row">회사명</th>
								<td colspan="2">
									<span class="form_search w100p">
										<input type="text" id="searchCoNmKr" name="searchCoNmKr" value="" onkeydown="onEnter(getDlgSearchCorpInfo);" class="form_text w100p" />
									</span>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				<div class="cont_block mt-20">
					<div class="tbl_opt">
						<div id="totalCnt" class="total_count"></div>
					</div>
					<div style="width: 100%;height: 100%;">
						<div id="dlgSearchCorpSheet" class="sheet"></div>
					</div>
					<div id="tradePaging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function () {
		setSheetHeader_dlgSearchCorpPopupSheet();
	});

	function setSheetHeader_dlgSearchCorpPopupSheet() {
		// 세팅
		var	ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		/*
		ibHeader.addHeader({Type: "Text", Header: "포상코드"	    , SaveName: "svrId"		    , Align: "Center"	, Width: 50    	,Edit : false, Hidden: true});
		ibHeader.addHeader({Type: "Text", Header: "번호"	        , SaveName: "rnum"		, Align: "Center"	, Width: 50	    ,Edit : false});
		ibHeader.addHeader({Type: "Text", Header: "포상명"		, SaveName: "searchBsnNm"	        , Align: "Left"		, Width: 200	,Edit : false	, Ellipsis:1, Cursor:"Pointer"});
		*/

		ibHeader.addHeader({Header:"선택",           Type:"Radio",     Hidden:0, Width:50,   Align:"Center",  SaveName:"chk" });
        ibHeader.addHeader({Header:"Status",       Type:"Status",    Hidden:1, Width:80,   Align:"Center",  SaveName:"status" });
        ibHeader.addHeader({Header:"무역업번호",        Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"memberId",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"회사명",          Type:"Text",      Hidden:0,  Width:180,  Align:"Left",    SaveName:"companyKor",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자",          Type:"Text",      Hidden:0,  Width:120,  Align:"Center",  SaveName:"presidentKor",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"사업자등록번호",      Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"enterRegNo",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"신청여부",         Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"corpChk",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });

		if (typeof dlgSearchCorpSheet !== "undefined" && typeof dlgSearchCorpSheet.Index !== "undefined") {
			dlgSearchCorpSheet.DisposeSheet();
		}

		var sheetId = "dlgSearchCorpSheet";
		var container = $("#" + sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "313px");
		ibHeader.initSheet(sheetId);

		dlgSearchCorpSheet.SetVisible(1);
	}

	function dlgSearchCorpSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('dlgSearchCorpSheet_OnSearchEnd : ', msg);
		} else {
			// 제목에 볼드 처리
			dlgSearchCorpSheet.SetColFontBold('bsnNm', 1);
		}
	}

	// 검색
	function getDlgSearchCorpInfo() {
		var params = {}

		var searchBsNo = $('#dlgSearchCorpForm #searchBsNo').val();
		var searchMemberId = $('#dlgSearchCorpForm #searchMemberId').val();
		var searchCoNmKr = $('#dlgSearchCorpForm #searchCoNmKr').val();

		if (svrId == '') {
			alert('정상적인 접근이 아닙니다.');
			return false;
		}

		if (searchBsNo == '' && searchMemberId == '' && searchCoNmKr == '') {
			alert('검색 조건이 없습니다. 확인 바랍니다.');
			return false;
		}

		$('#dlgSearchCorpForm #searchYn').val('Y');

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tdms/popup/selectDlgSearchCorpList.do" />'
			, data : $('#dlgSearchCorpForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#dlgSearchCorpForm #totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				dlgSearchCorpSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	// 상세 페이지 & 팝업
	function dlgSearchCorpSheet_OnDblClick(Row, Col, Value) {
		if (Row > 0) {
			if (dlgSearchCorpSheet.ColSaveName(Col) == 'bsnNm')  {
				var rowData = dlgSearchCorpSheet.GetRowData(Row);

				layerPopupCallback(rowData);
				closeLayerPopup();
			}
		}
	}

	function doSet() {
		var priType = $('input[name="priType"]:checked').val();
		var selectedRow = dlgSearchCorpSheet.FindCheckedRow(0).split("|")[0];
		var msgText = $('input[name="priType"]:checked').next().text();
		var priTypeNm = $('input[name="priType"]:checked').next().text();
		var memberId = '';

        if (dlgSearchCorpSheet.GetCellValue(dlgSearchCorpSheet.CheckedRows(0), "corpChk") == 'N') {
			alert("이미 신청한 업체 입니다. 확인후 진행바랍니다.");
			return false;
		}

		if (dlgSearchCorpSheet.RowCount() <=  0) {
			msgText += "를 선택된 업체 없이 작성 하시겠습니까?";
			if(!confirm(msgText)) return;
		} else {
			msgText += "를 작성 하시겠습니까?\n";
            msgText += "   회사명 : " + dlgSearchCorpSheet.GetCellValue(selectedRow, "companyKor") + "\n";
            msgText += "   대표자 : " + dlgSearchCorpSheet.GetCellValue(selectedRow, "presidentKor") + "\n";
            if(!confirm(msgText)) return;
            memberId += dlgSearchCorpSheet.GetCellValue(selectedRow, "memberId");
		}

		var rowData = {
			priType : priType,
			priTypeNm : priTypeNm,
			memberId : memberId
		}

		layerPopupCallback(rowData);
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>