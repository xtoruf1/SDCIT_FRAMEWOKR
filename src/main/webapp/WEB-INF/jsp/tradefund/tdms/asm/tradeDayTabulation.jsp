<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value=""/>
<input type="hidden" id="statusChk" name="statusChk" value=""/>
<input type="text" id="displayNone" name="displayNone" style="display:none;"/>
<input type="hidden" id="svrId" name="svrId"/>
<input type="hidden" id="applySeq" name="applySeq"/>
<input type="hidden" id="readYn" name="readYn" value="Y"/>
<input type="hidden" id="listPage" name="listPage" value="/tdms/asm/tradeDayTabulation.do"/>
<input type="hidden" id="bsnAplDt" name="bsnAplDt" value="<c:out value="${bsnAplDt}"/>"/>
<input type="hidden" id="priType" name="priType"/>
<input type="hidden" id="priTypeNm" name="priTypeNm" value=""/>
<input type="hidden" id="memberId" name="memberId"/>
<input type="hidden" id="proxyYn" name="proxyYn" value="Y"/>
<input type="hidden" id="tempFileId" name="tempFileId" value=""/>
<input type="hidden" id="appEditYn" name="appEditYn" value="Y"/>
<input type="hidden" id="editYn" name="editYn" value="N"/>

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
					<th scope="row">원장 구분</th>
					<td colspan="3">
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchPriType" value="CORP" checked>
							<span class="label">업체평가점수</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchPriType" value="EMP">
							<span class="label">종업원 점수</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchPriType" value="TOTAL">
							<span class="label">일반유공 종합</span>
						</label>
					</td>
				</tr>
				<tr>
					<th>신청구분</th>
					<td>
						<select class="form_select" id="searchPriTypeP" name="searchPriTypeP">
							<option value="">전체</option>
							<c:forEach items="${awd001Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>직위구분</th>
					<td>
						<select class="form_select" id="searchPrvPriType" name="searchPrvPriType">
							<option value="">전체</option>
							<c:forEach items="${awd002Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>기업구분</th>
					<td>
						<select class="form_select" id="searchScale" name="searchScale">
							<option value="">전체</option>
							<c:forEach items="${awd007Select}" var="list" varStatus="status">
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
	<div id="corpDiv" style="width: 100%;">
		<div id="corpSheet" class="sheet"></div>
	</div>
	<div id="empDiv" style="width: 100%; display:none;">
		<div id="empSheet" class="sheet"></div>
	</div>
	<div id="userTotalDiv" style="width: 100%; display:none;">
		<div id="userTotalSheet" class="sheet"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		setSheetHeader_tradeDayTabulationCorpSheet();
		setSheetHeader_tradeDayTabulationEmpSheet();
		setSheetHeader_tradeDayTabulationUserTotalSheet();
	});

	function setSheetHeader_tradeDayTabulationCorpSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",		Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"",			Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"chk" });
        ibHeader.addHeader({Header:"포상ID",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"svrId",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",	Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"applySeq",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"지역",		Type:"Combo",     Hidden:0, Width:100,  Align:"Center",  SaveName:"tradeDept",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${com001Sheet.chgCode03}' , ComboText: '${com001Sheet.detailsortnm}' });
        ibHeader.addHeader({Header:"무역업번호",	Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"memberId",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호",		Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"receiptNo",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상구분",		Type:"Combo",     Hidden:0, Width:120,  Align:"Left",    SaveName:"priType",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}' });
        ibHeader.addHeader({Header:"업체구분",		Type:"Combo",     Hidden:0, Width:100,  Align:"Center",  SaveName:"scale",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd007Sheet.detailcd}' , ComboText: '${awd007Sheet.detailnm}' });
        ibHeader.addHeader({Header:"업체명",		Type:"Text",      Hidden:0, Width:180,  Align:"Left",    SaveName:"coNmKr",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Cursor:"Pointer" });
        ibHeader.addHeader({Header:"대표자",		Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"ceoKr",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        '<c:forEach var="item" items="${corpTitleList}" varStatus="status">';
        var scoreType = '${item.scoreType}';
        var corpHeaderText = '${item.scoreTypeNm}(${item.maxScore})';
        var corpSaveNameText = 'gb' + scoreType.substring(2,6);
        ibHeader.addHeader({Header:corpHeaderText,	Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:corpSaveNameText,	CalcLogic:"",   Format:"Float",      PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		'</c:forEach>';
		ibHeader.addHeader({Header:"합계",		Type:"Float",     Hidden:0, Width:120,  Align:"Right",   SaveName:"gbtotal",     CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"신청상태",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"state",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

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

		var container = $('#corpSheet')[0];
		createIBSheet2(container, 'corpSheet', '100%', '535px');
		ibHeader.initSheet('corpSheet');

		corpSheet.SetEllipsis(1); 				// 말줄임 표시여부
		corpSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		corpSheet.SetEditable(1);
		corpSheet.SetVisible(1);

		getList();
	}

	function corpSheet_OnSort(col, order) {
		corpSheet.SetScrollTop(0);
	}

	function setSheetHeader_tradeDayTabulationEmpSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",			Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"",				Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"chk" });
        ibHeader.addHeader({Header:"포상ID",			Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"svrId",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"applySeq",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"본부코드",			Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"tradeDept",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업고유번호",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"memberId",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"receiptNo",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상종류",			Type:"Combo",     Hidden:0, Width:130,  Align:"Left",    SaveName:"priType",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}' });
        ibHeader.addHeader({Header:"업체명",			Type:"Text",      Hidden:0, Width:200,  Align:"Left",    SaveName:"coNmKr",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"ceoKr",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체구분",			Type:"Combo",     Hidden:0, Width:100,  Align:"Center",  SaveName:"scale",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd007Sheet.detailcd}' , ComboText: '${awd007Sheet.detailnm}' });
        ibHeader.addHeader({Header:"직위구분",			Type:"Combo",     Hidden:0, Width:100,  Align:"Center",  SaveName:"prvPriType",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd002Sheet.detailcd}' , ComboText: '${awd002Sheet.detailnm}' });
        ibHeader.addHeader({Header:"대상자",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"userNmKor",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"주민등록번호",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"juminNo",           CalcLogic:"",   Format:"IdNo",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"성별",			Type:"Combo",     Hidden:0, Width:100,  Align:"Center",  SaveName:"sex",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd021Sheet.detailcd}' , ComboText: '${awd021Sheet.detailnm}' });
        ibHeader.addHeader({Header:"직위",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"pos",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"근속년수",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"wrkTermYyMm",       CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"근무기간",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"curwrkTermYyMm",    CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        '<c:forEach var="item" items="${userTitleList}" varStatus="status">';
	    var scoreType = '${item.scoreType}';
	    var userHeaderText = '${item.scoreTypeNm}(${item.maxScore})';
	    var userSaveNameText = 'gb' + scoreType;
	    ibHeader.addHeader({Header:userHeaderText,	Type:"Float",     Hidden:0, Width:100,  Align:"Right",   ColMerge:1,   SaveName:userSaveNameText,  CalcLogic:"",   Format:"Float",      PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		'</c:forEach>';
        ibHeader.addHeader({Header:"합계",			Type:"Float",     Hidden:0, Width:100,  Align:"Right",   SaveName:"gb30total",         CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청상태",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"state",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

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

		var container = $('#empSheet')[0];
		createIBSheet2(container, 'empSheet', '100%', '480px');
		ibHeader.initSheet('empSheet');

		empSheet.SetEllipsis(1); 				// 말줄임 표시여부
		empSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		empSheet.SetEditable(1);
		empSheet.SetVisible(1);

	}

	function empSheet_OnSort(col, order) {
		empSheet.SetScrollTop(0);
	}

	function setSheetHeader_tradeDayTabulationUserTotalSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",			Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"",				Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"chk" });
        ibHeader.addHeader({Header:"포상ID",			Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"svrId",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"applySeq",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"주민번호",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"juminNo",      CalcLogic:"",   Format:"IdNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"memberId",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체명",			Type:"Text",      Hidden:0, Width:200,  Align:"Left",    SaveName:"coNmKr",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"ceoKr",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직위구분",			Type:"Combo",     Hidden:0, Width:100,  Align:"Center",  SaveName:"prvPriType",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd002Sheet.detailcd}' , ComboText: '${awd002Sheet.detailnm}' });
        ibHeader.addHeader({Header:"성명",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"userNmKor",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직위",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"pos",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"성별",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"sex",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"총계",			Type:"Float",     Hidden:0, Width:100,  Align:"Right",   SaveName:"gbtotal",      CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"종업원반영점수",		Type:"Float",     Hidden:0, Width:100,  Align:"Right",   SaveName:"gb0101",       CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"생산직근로자",		Type:"Float",     Hidden:0, Width:100,  Align:"Right",   SaveName:"gb0103",       CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"여성근로자",		Type:"Float",     Hidden:0, Width:100,  Align:"Right",   SaveName:"gb0104",       CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"기타",			Type:"Float",     Hidden:0, Width:100,  Align:"Right",   SaveName:"gb0105",       CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체구분",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"scaleNm",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청상태",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"state",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

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

		var container = $('#userTotalSheet')[0];
		createIBSheet2(container, 'userTotalSheet', '100%', '480px');
		ibHeader.initSheet('userTotalSheet');

		userTotalSheet.SetEllipsis(1); 				// 말줄임 표시여부
		userTotalSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		userTotalSheet.SetEditable(1);
		userTotalSheet.SetVisible(1);

	}

	function userTotalSheet_OnSort(col, order) {
		userTotalSheet.SetScrollTop(0);
	}

	function corpSheet_OnSearchEnd() {
		corpSheet.SetColFontBold('coNmKr', 1);
	}

	$('input[name="searchPriType"]').on('click', function() {
		getList();
	});

	function getList() {

		var searchPriType = $('input[name="searchPriType"]:checked').val();

		$('#corpDiv, #empDiv, #userTotalDiv').css('display', 'none');

		if(searchPriType == 'CORP') {
			getCorpList();
			$('#corpDiv').css('display', 'block');
		}else if(searchPriType == 'EMP') {
			getEmpList();
			$('#empDiv').css('display', 'block');
		}else if(searchPriType == 'TOTAL') {
			getUserTotalList();
			$('#userTotalDiv').css('display', 'block');
		}
	}

	function getCorpList() {
		corpSheet.ColumnSort('');	//sort 초기화
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDayTabulationCorpList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				corpSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function getEmpList() {
		empSheet.ColumnSort('');	//sort 초기화
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDayTabulationEmpList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				empSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function getUserTotalList() {
		userTotalSheet.ColumnSort('');	//sort 초기화
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDayTabulationUserTotalList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				userTotalSheet.LoadSearchData({Data: (data.resultList || []) });
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

	// 상세 페이지 & 팝업
	function corpSheet_OnDblClick(Row, Col, Value) {
		if(corpSheet.ColSaveName(Col) == 'coNmKr' && Row > 0) {
			var rowData = corpSheet.GetRowData(Row);
			goApplication(Row);
		}
	}

	function goApplication(Row) {
		$('#svrId').val(corpSheet.GetCellValue(Row, 'svrId'));
		$('#memberId').val(corpSheet.GetCellValue(Row, 'memberId'));
		$('#applySeq').val(corpSheet.GetCellValue(Row, 'applySeq'));

		// 로딩이미지 시작
		$('#loading_image').show();

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDaySelectionPopup.do"/>',
			params : $('#searchForm').serializeObject()
			, callbackFunction : function(resultObj) {
				var event = resultObj.event;

				// 평가 저장
				if (event == 'tradeDaySelectionSave') {
					// 레이어 닫기
					closeLayerPopup();

					// 레이어 다시 오픈
					goApplication(Row);
				}
			}
		});
	}

	function doExcel() {

		var searchPriType = $('input[name="searchPriType"]:checked').val();

		if(searchPriType == 'CORP') {
			downloadIbSheetExcel(corpSheet, '업체평가점수_리스트', '');

		}else if(searchPriType == 'EMP') {
			downloadIbSheetExcel(empSheet, '종업원점수_리스트', '');

		}else if(searchPriType == 'TOTAL') {
			downloadIbSheetExcel(userTotalSheet, '일반유공종합_리스트', '');

		}

	}

</script>