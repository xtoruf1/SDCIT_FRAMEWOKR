<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">행사변경</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
		<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>

</div>

<div id="coSearchPop" class="layerPopUpWrap popup_body">
	<div class="layerPopUp">
		<div class="layerWrap" style="width:700px;">
			<div class="box">
				<form id="eventSearchForm" name="eventSearchForm">
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
										<input type="text" name="svrId" class="form_text w100p" value="" onkeydown="onEnter(doSearch);">
									</span>
								</td>
								<th scope="row">포상명</th>
								<td>
									<span class="form_search w100p">
										<input type="text" name="bsnNm" class="form_text w100p" value="" onkeydown="onEnter(doSearch);">
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
						<div id='tradeSearch' class="colPosi"></div>
					</div>
					<!-- .paging-->
					<div id="tradePaging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
					<!-- //.paging-->
				</div>
			</div>
			<button type="button" class="btn_pop_close" onclick="closeLayerPopup();"></button>
		</div>
		<div class="layerFilter"></div>
	</div>
</div>

<script type="text/javascript">

	$(document).ready(function () {
		f_Init_tradeSearch();		// 헤더  Sheet 셋팅

		getList();

	});

	function f_Init_tradeSearch() {

		// 세팅
		var	ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		ibHeader.addHeader({Type: "Text", Header: "포상코드"	    , SaveName: "svrId"		    , Align: "Center"	, Width: 50    	,Edit : false, Hidden: true});
		ibHeader.addHeader({Type: "Text", Header: "번호"	        , SaveName: "vnum"		    , Align: "Center"	, Width: 50	    ,Edit : false});
		ibHeader.addHeader({Type: "Text", Header: "포상명"		, SaveName: "bsnNm"	        , Align: "Left"		, Width: 200	,Edit : false	, Ellipsis:1, Cursor:"Pointer"});

		if (typeof tradeSearch !== "undefined" && typeof tradeSearch.Index !== "undefined") {
			tradeSearch.DisposeSheet();
		}

		var sheetId = "tradeSearch";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "200px");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tradeSearch.SetEditable(0);

	}

	function tradeSearch_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('tradeSearch_OnSearchEnd : ', msg);
		} else {
			// 제목에 볼드 처리
			tradeSearch.SetColFontBold('svrNm', 1);
		}
	}

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.eventSearchForm.pageIndex.value = pageIndex;
		getList();
	}

	//포상변경
	function getList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeDay/clbrt/tradeDayClbrtListAjax.do" />'
			, data : $('#eventSearchForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				$("#totalCount").val(data.resultCnt); // 총 갯수 저장
				setPaging(
					'tradePaging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				tradeSearch.LoadSearchData({Data: data.resultList});
			}
		});

	}

	// 상세 페이지 & 팝업
	function tradeSearch_OnClick(Row, Col, Value) {
		if(tradeSearch.ColSaveName(Col) == "bsnNm" && Row > 0) {
			var rowData = tradeSearch.GetRowData(Row);
			layerPopupCallback(rowData);
			closeLayerPopup();
		}

	};
</script>