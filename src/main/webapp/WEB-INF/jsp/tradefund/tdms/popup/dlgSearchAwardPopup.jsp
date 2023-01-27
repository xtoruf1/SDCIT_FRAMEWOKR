<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">포상검색</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="dlgSearchAward();">검색</button>
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>
<div id="coSearchPop" class="layerPopUpWrap popup_body">
	<div class="layerPopUp">
		<div class="layerWrap" style="width:700px;">
			<div class="box">
				<form id="dlgSearchAwardForm" name="dlgSearchAwardForm">
					<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
					<table class="boardwrite formTable">
						<colgroup>
							<col style="width:20%">
							<col>
							<col style="width:20%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">포상코드</th>
								<td>
									<span class="form_search w100p">
										<input type="text" name="searchSvrId" class="form_text w100p" value="" onkeydown="onEnter(getDlgSearchAwardList);">
									</span>
								</td>
								<th scope="row">포상명</th>
								<td>
									<span class="form_search w100p">
										<input type="text" name="searchBsnNm" class="form_text w100p" value="" onkeydown="onEnter(getDlgSearchAwardList);">
									</span>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				<div class="cont_block mt-20">
					<div class="tbl_opt">
						<!-- 무역의 날 기념식 관리 -->
						<div id="totalCnt" class="total_count"></div>
					</div>
					<!-- 리스트 테이블 -->
					<div style="width: 100%;height: 100%;">
						<div id="dlgSearchAwardSheet"></div>
					</div>
				</div>
			</div>
			<button type="button" class="btn_pop_close" onclick="closeLayerPopup();"></button>
		</div>
		<div class="layerFilter"></div>
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		setSheetHeader_dlgSearchAwardPopupSheet();
	});

	function setSheetHeader_dlgSearchAwardPopupSheet() {
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

		ibHeader.addHeader({Header:"No.",          Type:"Seq",       Hidden:0, Width:50,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"Status",       Type:"Status",    Hidden:1, Width:80,   Align:"Center",  SaveName:"status" });
        ibHeader.addHeader({Header:"포상코드",         Type:"Text",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"svrId" });
        ibHeader.addHeader({Header:"포상명",          Type:"Text",     Hidden:0,  Width:300,  Align:"Left",    SaveName:"bsnNm" });
        ibHeader.addHeader({Header:"접수기간",         Type:"Text",      Hidden:1, Width:120,  Align:"Center",  SaveName:"bsnAplDt" });
        ibHeader.addHeader({Header:"상태",           Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"state" });
        ibHeader.addHeader({Header:"상태",           Type:"Text",     Hidden:0,  Width:60,   Align:"Center",  SaveName:"stateNm" });


		if (typeof dlgSearchAwardSheet !== "undefined" && typeof dlgSearchAwardSheet.Index !== "undefined") {
			dlgSearchAwardSheet.DisposeSheet();
		}

		var sheetId = "dlgSearchAwardSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "380px");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		dlgSearchAwardSheet.SetEditable(0);
		dlgSearchAwardSheet.SetVisible(1);
		dlgSearchAwardSheet.SetDataLinkMouse("svrId",1);
		dlgSearchAwardSheet.SetDataLinkMouse("bsnNm",1);
		dlgSearchAwardSheet.SetDataLinkMouse("stateNm",1);

		getDlgSearchAwardList();
	}

	function dlgSearchAwardSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('dlgSearchAwardSheet_OnSearchEnd : ', msg);
		} else {
			// 제목에 볼드 처리
			dlgSearchAwardSheet.SetColFontBold('bsnNm', 1);
		}
	}

	//포상변경
	function getDlgSearchAwardList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tdms/popup/selectDlgSearchAwardPopupList.do" />'
			, data : $('#dlgSearchAwardForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				dlgSearchAwardSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	// 상세 페이지 & 팝업
	function dlgSearchAwardSheet_OnDblClick(Row, Col, Value) {
		if (Row > 0) {
			var rowData = dlgSearchAwardSheet.GetRowData(Row);
			layerPopupCallback(rowData);
			closeLayerPopup();
		}
	};

	function dlgSearchAwardSheet_OnSearchEnd(row) {
		dlgSearchAwardSheet.ReNumberSeq('desc');
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>