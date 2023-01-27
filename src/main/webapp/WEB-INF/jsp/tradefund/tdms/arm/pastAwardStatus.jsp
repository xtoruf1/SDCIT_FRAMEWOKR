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
<input type="hidden" id="listPage" name="listPage" value="/tdms/arm/pastAwardStatus.do"/>
<input type="hidden" id="priType" name="priType"/>
<input type="hidden" id="priTypeNm" name="priTypeNm" value=""/>
<input type="hidden" id="memberId" name="memberId" />
<input type="hidden" id="proxyYn" name="proxyYn" value="Y"/>

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
					<th>수출의 탑</th>
					<td colspan="2">
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchType" value="TA" checked>
							<span class="label">수출의 탑 전체</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchType" value="TT">
							<span class="label">수출의 탑 10년 단위</span>
						</label>
					</td>
					<th>성별</th>
					<td colspan="2">
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchSex" value="A" checked>
							<span class="label">전체</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchSex" value="M">
							<span class="label">남성</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchSex" value="F">
							<span class="label">여성</span>
						</label>
					</td>
				</tr>
				<tr>
					<th>개인포상</th>
					<td colspan="5">
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchType" value="PA">
							<span class="label">개인포상전체</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchType" value="HA">
							<span class="label">훈포장 전체</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchType" value="HT">
							<span class="label">훈포장 10년단위</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchType" value="PYA">
							<span class="label">표창 전체</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchType" value="PYT">
							<span class="label">표창 10년단위</span>
						</label>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
<div class="cont_block">
	<div id="tabDiv" style="width: 100%;">
		<div id="tabSheet" class="sheet"></div>
	</div>
	<div id="indiDiv" style="width: 100%; display:none;">
		<div id="indiSheet" class="sheet"></div>
	</div>
	<div id="hunDiv" style="width: 100%; display:none;">
		<div id="hunSheet" class="sheet"></div>
	</div>
	<div id="pyoDiv" style="width: 100%; display:none;">
		<div id="pyoSheet" class="sheet"></div>
	</div>
</div>
</form>
<script type="text/javascript">

	$(document).ready(function(){
		setSheetHeader_pastAwardStatusTabSheet();
		setSheetHeader_pastAwardStatusIndiSheet();
		setSheetHeader_pastAwardStatusHunSheet();
		setSheetHeader_pastAwardStatusPyoSheet();
		getTabList();
	});

	function setSheetHeader_pastAwardStatusTabSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",	Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"연도",	Type:"Text",      Hidden:0,  Width:60,   Align:"Center",  SaveName:"praYear",		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

        '<c:forEach var="item" items="${prize10}" varStatus="status">';
        var title = '${item.prizeShortNm}';
        var saveNameText = 'cnt' + '${status.index+1}';
        ibHeader.addHeader({Header:title,           Type:"AutoSum",   Hidden:0, Width:80,   Align:"Right",   SaveName:saveNameText,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		'</c:forEach>';

        ibHeader.addHeader({Header:"합계",           Type:"AutoSum",   Hidden:0, Width:80,   Align:"Right",   SaveName:"allCnt",     CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction",
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

		var container = $('#tabSheet')[0];
		createIBSheet2(container, 'tabSheet', '100%', '525px');
		ibHeader.initSheet('tabSheet');

		tabSheet.SetEllipsis(1); 				// 말줄임 표시여부
		tabSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		tabSheet.SetEditable(1);
		tabSheet.SetVisible(1);

	}

	function tabSheet_OnSort(col, order) {
		tabSheet.SetScrollTop(0);
	}

	function setSheetHeader_pastAwardStatusIndiSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

		ibHeader.addHeader({Header:"No",	Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"연도",	Type:"Text",      Hidden:0,  Width:80,   Align:"Center",  SaveName:"praYear",		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

        '<c:forEach var="item" items="${prize2_}" varStatus="status">';
        var title = '${item.prizeShortNm}';
        var saveNameText = 'cnt' + '${status.index+1}';
        ibHeader.addHeader({Header:title,           Type:"AutoSum",   Hidden:0, Width:90,   Align:"Right",   SaveName:saveNameText,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		'</c:forEach>';

        ibHeader.addHeader({Header:"합계",           Type:"AutoSum",   Hidden:0, Width:90,   Align:"Right",   SaveName:"allCnt",     CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction",
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

		var container = $('#indiSheet')[0];
		createIBSheet2(container, 'indiSheet', '100%', '525px');
		ibHeader.initSheet('indiSheet');

		indiSheet.SetEllipsis(1); 				// 말줄임 표시여부
		indiSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		indiSheet.SetEditable(1);
		indiSheet.SetVisible(1);

	}

	function indiSheet_OnSort(col, order) {
		indiSheet.SetScrollTop(0);
	}

	function setSheetHeader_pastAwardStatusHunSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

		ibHeader.addHeader({Header:"No",	Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"연도",	Type:"Text",      Hidden:0,  Width:60,   Align:"Center",  SaveName:"praYear",		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

        '<c:forEach var="item" items="${prize20}" varStatus="status">';
        var title = '${item.prizeShortNm}';
        var saveNameText = 'cnt' + '${status.index+1}';
        ibHeader.addHeader({Header:title,           Type:"AutoSum",   Hidden:0, Width:80,   Align:"Right",   SaveName:saveNameText,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		'</c:forEach>';

        ibHeader.addHeader({Header:"합계",           Type:"AutoSum",   Hidden:0, Width:80,   Align:"Right",   SaveName:"allCnt",     CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

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

		var container = $('#hunSheet')[0];
		createIBSheet2(container, 'hunSheet', '100%', '525px');
		ibHeader.initSheet('hunSheet');

		hunSheet.SetEllipsis(1); 				// 말줄임 표시여부
		hunSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		hunSheet.SetEditable(1);
		hunSheet.SetVisible(1);

	}

	function hunSheet_OnSort(col, order) {
		hunSheet.SetScrollTop(0);
	}

	function setSheetHeader_pastAwardStatusPyoSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

		ibHeader.addHeader({Header:"No",	Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"연도",	Type:"Text",      Hidden:0,  Width:60,   Align:"Center",  SaveName:"praYear",		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

        '<c:forEach var="item" items="${prize21}" varStatus="status">';
        var title = '${item.prizeShortNm}';
        var saveNameText = 'cnt' + '${status.index+1}';
        ibHeader.addHeader({Header:title,           Type:"AutoSum",   Hidden:0, Width:80,   Align:"Right",   SaveName:saveNameText,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		'</c:forEach>';

        ibHeader.addHeader({Header:"합계",           Type:"AutoSum",   Hidden:0, Width:80,   Align:"Right",   SaveName:"allCnt",     CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

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

		var container = $('#pyoSheet')[0];
		createIBSheet2(container, 'pyoSheet', '100%', '525px');
		ibHeader.initSheet('pyoSheet');

		pyoSheet.SetEllipsis(1); 				// 말줄임 표시여부
		pyoSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		pyoSheet.SetEditable(1);
		pyoSheet.SetVisible(1);

	}

	function pyoSheet_OnSort(col, order) {
		pyoSheet.SetScrollTop(0);
	}

	function tabSheet_OnSearchEnd() {
		tabSheet.SetSumText(0, 1, "합    계");
	}

	function indiSheet_OnSearchEnd() {
		indiSheet.SetSumText(0, 1, "합    계");
	}

	function hunSheet_OnSearchEnd() {
		hunSheet.SetSumText(0, 1, "합    계");
	}

	function pyoSheet_OnSearchEnd() {
		pyoSheet.SetSumText(0, 1, "합    계");
	}


	$('input[name="searchType"], input[name="searchSex"]').on('click', function() {
		getList();
	});

	function getList() {

		$('#tabDiv, #indiDiv, #hunDiv, #pyoDiv').css('display', 'none');

		var searchType = $('input[name="searchType"]:checked').val();

		if(searchType == 'TA' || searchType == 'TT') {
			getTabList();
			$('#tabDiv').css('display', 'block');
		}else if(searchType == 'PA') {
			getIndiList();
			$('#indiDiv').css('display', 'block');
		}else if(searchType == 'HA' || searchType == 'HT') {
			getHunList();
			$('#hunDiv').css('display', 'block');
		}else if(searchType == 'PYA' || searchType == 'PYT') {
			getPyoList();
			$('#pyoDiv').css('display', 'block');
		}

	}

	function getTabList() {
		tabSheet.ColumnSort('');
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/arm/selectPastAwardStatusTabList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data) {
				tabSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});

	}

	function getIndiList() {
		indiSheet.ColumnSort('');
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/arm/selectPastAwardStatusIndiList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data) {
				indiSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});

	}

	function getHunList() {
		hunSheet.ColumnSort('');
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/arm/selectPastAwardStatusHunList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data) {
				hunSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});

	}

	function getPyoList() {
		pyoSheet.ColumnSort('');
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/arm/selectPastAwardStatusPyoList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data) {
				pyoSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});

	}

	function doExcel() {

		var searchType = $('input[name="searchType"]:checked').val();

		if(searchType == 'TA' || searchType == 'TT') {
			if(searchType == 'TA') {
				downloadIbSheetExcel(tabSheet, '수출의탑(전체)_리스트', '');
			}else if(searchType == 'TT') {
				downloadIbSheetExcel(tabSheet, '수출의탑(10년단위)_리스트', '');
			}
		}else if(searchType == 'PA') {
			downloadIbSheetExcel(indiSheet, '개인포상(전체)_리스트', '');
		}else if(searchType == 'HA' || searchType == 'HT') {
			if(searchType == 'HA') {
				downloadIbSheetExcel(hunSheet, '훈포장(전체)_리스트', '');
			}else if(searchType == 'HT') {
				downloadIbSheetExcel(hunSheet, '훈포장(10년단위)_리스트', '');
			}
		}else if(searchType == 'PYA' || searchType == 'PYT') {
			if(searchType == 'PYA') {
				downloadIbSheetExcel(pyoSheet, '표창(전체)_리스트', '');
			}else if(searchType == 'PYT') {
				downloadIbSheetExcel(pyoSheet, '표창(10년단위)_리스트', '');
			}
		}

	}

</script>