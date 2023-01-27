<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value=""/>
<input type="hidden" id="bsnAplDt" name="bsnAplDt" value="<c:out value="${bsnAplDt}"/>"/>
<input type="hidden" id="state" name="state" value="<c:out value="${state}"/>"/>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doExcel();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="clearForm('foldingTable_inner');" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="getList();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="cont_block">
	<div class="foldingTable fold">
		<div class="foldingTable_inner">
			<table class="formTable">
				<colgroup>
					<col style="width:15%;" />
					<col />
					<col style="width:15%;" />
					<col />
					<col style="width:15%;" />
					<col />
				</colgroup>
				<tr>
					<th>포상명</th>
					<td>
						<span class="form_search">
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>"/>
							<input type="text" id="searchBsnNm" name="searchBsnNm" class="form_text" value="<c:out value="${searchBsnNm}"/>" style="font-size:14px;" readonly>
							<button type="button" class="btn_icon btn_search" title="포상검색" onclick="openLayerDlgSearchAwardPop();"></button>
						</span>
					</td>
					<th>구분</th>
					<td>
						<select class="form_select" id="searchHanbitGb" name="searchHanbitGb">
							<option value="">전체</option>
							<c:forEach items="${awd031Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>신청구분</th>
					<td>
						<select class="form_select" id="searchPriType" name="searchPriType">
							<option value="">전체</option>
							<c:forEach items="${awd001Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>업체명</th>
					<td>
						<input type="text" class="form_text" id="searchCompanyKor" name="searchCompanyKor" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
					<th>회원명</th>
					<td>
						<input type="text" class="form_text" id="searchHanbitUsernm" name="searchHanbitUsernm" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
					<th>신청상태</th>
					<td>
						<select class="form_select" id="searchState" name="searchState">
							<option value="">전체</option>
							<c:forEach items="${awd003Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
<div class="cont_block">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div style="width: 100%;">
		<div id="listSheet" class="sheet"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		setSheetHeader_tradeDayHanbitSheet();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_tradeDayHanbitSheet() {
		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"무역업등록번호",	Type:"Text",      Hidden:0, Width:80,   Align:"Left",    ColMerge:1,   SaveName:"memberId",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"구분",			Type:"Text",      Hidden:0, Width:80,   Align:"Left",    ColMerge:1,   SaveName:"hanbitGb",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청상태",			Type:"Text",      Hidden:0, Width:40,   Align:"Center",  ColMerge:1,   SaveName:"state",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"업체명",			Type:"Text",      Hidden:0, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"coNmKr",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30, Cursor:"Pointer" });
        ibHeader.addHeader({Header:"신청구분",			Type:"Text",      Hidden:0, Width:70,   Align:"Left",                  SaveName:"priType",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"회원명",			Type:"Text",      Hidden:0, Width:40,   Align:"Center",  ColMerge:1,   SaveName:"hanbitUsernm",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"직위",			Type:"Text",      Hidden:0, Width:40,   Align:"Left",    ColMerge:1,   SaveName:"pos",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"한빛회직위",		Type:"Text",      Hidden:0, Width:60,   Align:"Center",  ColMerge:1,   SaveName:"hanbitPos",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"포상종류",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",                SaveName:"prvPriTypeNm",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"직위",			Type:"Text",      Hidden:0, Width:40,   Align:"Center",                SaveName:"pos",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"대상자",			Type:"Text",      Hidden:0, Width:60,   Align:"Center",                SaveName:"userNmKor",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30, Cursor:"Pointer" });
        ibHeader.addHeader({Header:"포상종류KEY",		Type:"Text",      Hidden:1, Width:40,   Align:"Center",                SaveName:"prvPriType",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"apply_seq",		Type:"Text",      Hidden:1, Width:40,   Align:"Center",                SaveName:"applySeq",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"seq",			Type:"Text",      Hidden:1, Width:80,   Align:"Center",                SaveName:"seqId" });

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction|resize",
			DeferredVScroll: 1,
			Ellipsis: 1,
			SelectionRowsMode: 1,
			SearchMode: 2,
			NoFocusMode : 0,
			Alternate : 0,
			Page: 10,
			SizeMode: 4,
			MergeSheet: msHeaderOnly,
			UseHeaderSortCancel: 1,
			MaxSort: 1
		});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true, HeaderCheck: 0});

		var container = $('#listSheet')[0];
		createIBSheet2(container, 'listSheet', '100%', '525px');
		ibHeader.initSheet('listSheet');

		listSheet.SetEllipsis(1); 				// 말줄임 표시여부
		listSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		listSheet.SetEditable(1);
		listSheet.SetVisible(1);

		getList();
	}

	function listSheet_OnSort(col, order) {
		listSheet.SetScrollTop(0);
	}

	function listSheet_OnSearchEnd() {
		listSheet.SetColFontBold('coNmKr', 1);
		listSheet.SetColFontBold('userNmKor', 1);
	}

	// 목록 가져오기
	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/agg/selectTradeDayHanbitList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				listSheet.LoadSearchData({Data: (data.resultList || [])});
			}
		});
	}

	// 포상 검색(팝업)
	function openLayerDlgSearchAwardPop() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/dlgSearchAwardPopup.do" />'
			, callbackFunction : function(resultObj) {
				$('#searchSvrId').val(resultObj.svrId);
				$('#searchBsnNm').val(resultObj.bsnNm);
				$('#bsnAplDt').val(resultObj.bsnAplDt);
				getList();
			}
		});
	}

	// 상세 페이지 & 팝업
	function listSheet_OnClick(Row, Col, Value) {
		if(Row > 0) {
			if(listSheet.ColSaveName(Col) == 'coNmKr') {
				doTradeDayView(Row);
			} else if(listSheet.ColSaveName(Col) == 'userNmKor') {
				if(Value != '') {
					var prvPriType = listSheet.GetCellValue(Row, "prvPriType")
					kongJukPopup(Row, prvPriType);
				}
			}
		}
	}

	function doTradeDayView(Row) {
		var searchSvrId = $('#searchSvrId').val();
		var applySeq = listSheet.GetCellValue(Row, "applySeq")

		// 로딩이미지 시작
		$('#loading_image').show();

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayViewPopup.do" />'
			, params : {
				svrId : searchSvrId
				, applySeq : applySeq
			}
			, callbackFunction : function(resultObj){
			}
		});
	}

	function kongJukPopup(Row, prvPriType) {
		var searchSvrId = $('#searchSvrId').val();
		var applySeq = listSheet.GetCellValue(Row, "applySeq")

		// 로딩이미지 시작
		$('#loading_image').show();

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayInquiryPopup.do" />'
			, params : {
				event : 'TradeDayInquiryPopupSearch'
				, svrId : searchSvrId
			    , applySeq : applySeq
			    , prvPriType : prvPriType
			}
			, callbackFunction : function(resultObj){
			}
		});
	}

	function doExcel() {
		downloadIbSheetExcel(listSheet, '한빛회이사회_신청현황_리스트', '');
	}
</script>