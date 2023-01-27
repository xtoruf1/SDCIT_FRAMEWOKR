<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value=""/>
<input type="hidden" id="statusChk" name="statusChk" value=""/>
<input type="text" id="displayNone" name="displayNone" style="display:none;"/>
<input type="hidden" id="svrId" name="svrId" value=""/>
<input type="hidden" id="applySeq" name="applySeq" value=""/>
<input type="hidden" id="readYn" name="readYn" value="Y"/>
<input type="hidden" id="listPage" name="listPage" value="/tdms/arm/pastAwardWinners.do"/>
<input type="hidden" id="priType" name="priType" value=""/>
<input type="hidden" id="priTypeNm" name="priTypeNm" value=""/>
<input type="hidden" id="memberId" name="memberId" value=""/>
<input type="hidden" id="proxyYn" name="proxyYn" value="Y"/>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doReceiptReport();" class="btn_sm btn_primary">인수증출력</button>
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
					<th>포상년도</th>
					<td>
						<select class="form_select" id="searchSvrId" name="searchSvrId">
							<c:forEach items="${awd0050t}" var="list" varStatus="status">
								<c:choose>
									<c:when test="${status.index == 0}">
										<option value="${list.svrId}" selected>${list.svrYear}</option>
									</c:when>
									<c:otherwise>
										<option value="${list.svrId}">${list.svrYear}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>
					</td>
					<th>추천기관</th>
					<td>
						<input type="text" class="form_text" id="searchSpRecOrg" name="searchSpRecOrg" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
					<th>수상포상</th>
					<td>
						<select class="form_select" id="searchPrizeCd" name="searchPrizeCd">
							<option value="">전체</option>
							<c:forEach items="${awd0092t}" var="list" varStatus="status">
								<option value="${list.prizeCd}">${list.prizeName}</option>
							</c:forEach>
						</select>
					</td>
	            </tr>
	            <tr>
	            	<th>구분</th>
					<td>
						<select class="form_select" id="searchPriGbn" name="searchPriGbn">
							<option value="">전체</option>
							<c:forEach items="${awd002Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>특수유공 부문</th>
					<td>
						<select class="form_select" id="searchPriGbn2" name="searchPriGbn2">
							<option value="">전체</option>
							<c:forEach items="${spe000Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>수상번호</th>
					<td>
						<input type="text" class="form_text" id="searchPriNo" name=searchPriNo value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
	            </tr>
	            <tr>
	            	<th>업체명</th>
					<td>
						<input type="text" class="form_text" id="searchCoNmKr" name=searchCoNmKr value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
					<th>무역업번호</th>
					<td>
						<input type="text" class="form_text" id="searchMemberId" name="searchMemberId" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="8" />
					</td>
					<th>대상자</th>
					<td>
						<input type="text" class="form_text" id="searchUserNm" name="searchUserNm" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
	            </tr>
	            <tr>
	            	<th>주민번호</th>
					<td colspan="5">
						<input type="text" class="form_text" id="searchJuminNo" name="searchJuminNo" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
	            </tr>
			</table>
		</div>
		<button type="button" class="btn_folding" title="테이블접기"></button>
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
	$(document).ready(function() {
		setSheetHeader_pastAwardWinnersSheet();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_pastAwardWinnersSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",			Type:"Seq",       Hidden:0, Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"No",			Type:"Text",      Hidden:1, Width:60,   Align:"Center",  ColMerge:1,   SaveName:"chk" });
        ibHeader.addHeader({Header:"결과ID",			Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"resultId",    CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상ID",			Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"svrId",       CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"applySeq",    CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상년도",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"praYear",     CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상구분",			Type:"Combo",     Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"priGbn",      CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd002Sheet.detailcd}' , ComboText: '${awd002Sheet.detailnm}' });
        ibHeader.addHeader({Header:"무역업번호",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"memberId",    CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수상번호",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"priNo",       CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체명",			Type:"Text",      Hidden:0, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"coNmKr",      CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Cursor:"Pointer" });
        ibHeader.addHeader({Header:"주민번호",			Type:"Text",      Hidden:0, Width:140,  Align:"Center",  ColMerge:1,   SaveName:"juminNo",     CalcLogic:"",   Format:"IdNo",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대상자",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"priUserNm",   CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Cursor:"Pointer" });
        ibHeader.addHeader({Header:"상장코드",			Type:"Text",      Hidden:1, Width:80,   Align:"Center",  SaveName:"priCode",     CalcLogic:"", Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"상장명",			Type:"Text",      Hidden:0, Width:200,  Align:"Left",    SaveName:"prizeName",   CalcLogic:"", Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직위",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"pos",         CalcLogic:"", Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상일",			Type:"Date",      Hidden:0, Width:80,   Align:"Center",  SaveName:"priDt",       CalcLogic:"", Format:"yyyy-MM-dd",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"부상",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"addPrize",    CalcLogic:"", Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"특수유공부문",		Type:"Text",      Hidden:0, Width:120,  Align:"Left",    SaveName:"priGbn2",     CalcLogic:"", Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"추천기관",			Type:"Text",      Hidden:0, Width:120,  Align:"Left",    SaveName:"spRecOrg",    CalcLogic:"", Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

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
		createIBSheet2(container, 'listSheet', '100%', '412px');
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

	function listSheet_OnSearchEnd(row) {
		listSheet.ReNumberSeq('desc');
		listSheet.SetColFontBold('coNmKr', 1);
		listSheet.SetColFontBold('priUserNm', 1);
	}

	// 목록 가져오기
	function getList() {

		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/arm/selectPastAwardWinnersList.do"
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

	// 상세 페이지 & 팝업
	function listSheet_OnDblClick(Row, Col, Value) {
		if(Row > 0) {
			if(listSheet.ColSaveName(Col) == 'coNmKr') {
				doTradeDayView(Row);
			}else if(listSheet.ColSaveName(Col) == 'priUserNm') {
				var prvPriType = listSheet.GetCellValue(Row, "priGbn")
				kongJukPopup(Row, prvPriType);
			}
		}
	}

	function doTradeDayView(Row) {

		var searchSvrId = listSheet.GetCellValue(Row, "svrId");
		var applySeq = listSheet.GetCellValue(Row, "applySeq");

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

		var searchSvrId = listSheet.GetCellValue(Row, "svrId");
		var applySeq = listSheet.GetCellValue(Row, "applySeq");

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
		downloadIbSheetExcel(listSheet, '역대수상자명단_리스트', '');
	}

	function doReceiptReport() {
		var svrId = listSheet.GetCellValue(listSheet.GetSelectRow(), "svrId");
		var applySeq = listSheet.GetCellValue(listSheet.GetSelectRow(), "applySeq");

		if(svrId <= 0 || applySeq <= 0) {
			alert('인수증출력 할 대상자 정보를 선택해주세요.');
			return false;
		}

		var url = '<c:url value="/tdas/report/tradeDayReceiptPrint.do" />?svrId=' + svrId + '&applySeq=' + applySeq;

		var result = null;

		window.open(url, 'search', 'width=770px,height=690px,scrollbars=yes');

		if (result == null) {
			return;
		}

	}

</script>