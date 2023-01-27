<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value=""/>
<input type="hidden" id="statusChk" name="statusChk" value=""/>
<input type="text" id="displayNone" name="displayNone" style="display:none;"/>

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
					<td colspan="5">
						<span class="form_search">
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>"/>
							<input type="text" id="searchBsnNm" name="searchBsnNm" class="form_text" value="<c:out value="${searchBsnNm}"/>" style="font-size:14px;" readonly>
							<button type="button" class="btn_icon btn_search" title="포상검색" onclick="openLayerDlgSearchAwardPop();"></button>
						</span>
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
		setSheetHeader_applicationStatsStatusSheet();
		getList();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_applicationStatsStatusSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No|No",					Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"|",						Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"chk" });
        ibHeader.addHeader({Header:"NO|NO",					Type:"Text",      Hidden:0, Width:60,   Align:"Center",  ColMerge:1,   SaveName:"num",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"지역|지역",				Type:"Text",      Hidden:0, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"receiptNo",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"SRT|SRT",				Type:"Text",      Hidden:1, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"srt",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"수출의탑신청업체수|신청완료",	Type:"AutoSum",   Hidden:0, Width:100,  Align:"Right",   ColMerge:1,   SaveName:"t02",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"수출의탑신청업체수|임시저장",	Type:"AutoSum",   Hidden:0, Width:100,  Align:"Right",   ColMerge:1,   SaveName:"t01",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"수출의탑일반유공|신청완료",		Type:"AutoSum",   Hidden:0, Width:100,  Align:"Right",   ColMerge:1,   SaveName:"a02",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"수출의탑일반유공|임시저장",		Type:"AutoSum",   Hidden:0, Width:100,  Align:"Right",   ColMerge:1,   SaveName:"a01",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"일반유공|신청완료",			Type:"AutoSum",   Hidden:0, Width:100,  Align:"Right",   ColMerge:1,   SaveName:"p02",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"일반유공|임시저장",			Type:"AutoSum",   Hidden:0, Width:100,  Align:"Right",   ColMerge:1,   SaveName:"p01",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"특수유공|신청완료",			Type:"AutoSum",   Hidden:0, Width:100,  Align:"Right",   ColMerge:1,   SaveName:"s02",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"특수유공|임시저장",			Type:"AutoSum",   Hidden:0, Width:100,  Align:"Right",   ColMerge:1,   SaveName:"s01",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });

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

	}

	function listSheet_OnSort(col, order) {
		listSheet.SetScrollTop(0);
	}

	function listSheet_OnSearchEnd() {
		listSheet.SetSumText(0, 2, "합계");
	}

	// 목록 가져오기
	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/arm/selectApplicationStatsStatusList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				listSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	/**
	 * 포상 검색(팝업)
	 */
	function openLayerDlgSearchAwardPop(){

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

	function doExcel() {
		downloadIbSheetExcel(listSheet, '지역별신청통계_리스트', '');
	}

</script>