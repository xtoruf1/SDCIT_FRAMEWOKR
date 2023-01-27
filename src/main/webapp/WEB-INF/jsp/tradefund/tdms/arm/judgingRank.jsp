<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value=""/>
<input type="hidden" id="statusChk" name="statusChk" value=""/>
<input type="text" id="displayNone" name="displayNone" style="display:none;"/>
<input type="hidden" id="sumCnt" name="sumCnt"/>
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doRank();" class="btn_sm btn_primary btn_modify_auth">랭크반영</button>
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doExcel();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="doCorpExcel();" class="btn_sm btn_primary">업체엑셀 다운</button>
		<button type="button" onclick="clearForm('foldingTable_inner');" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="getMainList();" class="btn_sm btn_primary">검색</button>
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
						<span class="form_search" style="width: 230px;">
							<input type="text" id="searchBsnNm" name="searchBsnNm" value="<c:out value="${searchBsnNm}" />" class="form_text" style="font-size: 14px;" readonly="readonly" />
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}" />" />
							<button type="button" class="btn_icon btn_search" onclick="openLayerDlgSearchAwardPop();" title="포상검색"></button>
						</span>
						<select class="form_select" id="searchScale" name="searchScale">
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
<div class="cont_block mt-20">
	<div style="width: 100%;height: 100%;display: flex;justify-content: space-between;">
		<div id="mainSheet" class="sheet"></div>
		<div id="subSheet" class="sheet"></div>
	</div>
	<div style="width: 100%;display: none;">
		<div id="excelRankSheet" class="sheet"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function() {
		setSheetHeader_judgingRankMainSheet();
		setSheetHeader_judgingRankSubSheet();
		setSheetHeader_judgingRankExcelRankSheet();

		getMainList();
	});

	function setSheetHeader_judgingRankMainSheet() {
		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",			Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"",				Type:"Status",    Hidden:1, Width:60,   Align:"Center",  SaveName:"status" });
        ibHeader.addHeader({Header:"SVR_ID",		Type:"Text",      Hidden:1, Width:60,   Align:"Center",  ColMerge:1,   SaveName:"svrId",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"SCALE",			Type:"Text",      Hidden:1, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"scale",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"업체구분",			Type:"Text",      Hidden:0, Width:150,  Align:"Center",  ColMerge:1,   SaveName:"scaleNm",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"RANK_GB",		Type:"Text",      Hidden:1, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"rankGb",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"등급",			Type:"Text",      Hidden:0, Width:150,  Align:"Center",  ColMerge:1,   SaveName:"rankGbNm",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"업체수",			Type:"AutoSum",   Hidden:0, Width:150,  Align:"Right",   ColMerge:1,   SaveName:"beforeCnt",  CalcLogic:"",   Format:"Number",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"업체수 수정",		Type:"AutoSum",   Hidden:0, Width:150,  Align:"Right",   ColMerge:1,   SaveName:"cnt",        CalcLogic:"",   Format:"Number",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:300 });

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction|resize",
			DeferredVScroll: 1,
			Ellipsis: 1,
			SelectionRowsMode: 1,
			SearchMode: 4,
			NoFocusMode : 0,
			Alternate : 0,
			Page: 10,
			SizeMode: 4,
			MergeSheet: msHeaderOnly
		});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 1});

		var container = $('#mainSheet')[0];
		createIBSheet2(container, 'mainSheet', '43%', '580px');
		ibHeader.initSheet('mainSheet');

		mainSheet.SetEllipsis(1); 				// 말줄임 표시여부
		mainSheet.SetEditable(1);
		mainSheet.SetVisible(1);
	}

	function setSheetHeader_judgingRankSubSheet() {
		var	ibHeader = new IBHeader();
		var initSheet = {};

		ibHeader.addHeader({Header:"No",		Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"no" });
		ibHeader.addHeader({Header:"",			Type:"Status",    Hidden:1, Width:60,   Align:"Center",  SaveName:"status" });
        ibHeader.addHeader({Header:"등급",		Type:"Text",      Hidden:1, Width:60,   Align:"Center",  ColMerge:1,   SaveName:"rankGb",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"랭크",		Type:"Text",      Hidden:0, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"rankNo",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"업체구분",		Type:"Text",      Hidden:1, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"scale",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
        ibHeader.addHeader({Header:"무역업번호",	Type:"Text",      Hidden:0, Width:190,  Align:"Left",    ColMerge:1,   SaveName:"memberId",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"업체명",		Type:"Text",      Hidden:0, Width:320,  Align:"Left",    ColMerge:1,   SaveName:"coNmKr",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300, BackColor: '#F6F6F6' });

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction|resize",
			DeferredVScroll: 1,
			Ellipsis: 1,
			SelectionRowsMode: 1,
			SearchMode: 4,
			NoFocusMode : 0,
			Alternate : 0,
			Page: 10,
			SizeMode: 4,
			MergeSheet: msHeaderOnly
		});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 1});

		var container = $('#subSheet')[0];
		createIBSheet2(container, 'subSheet', '56%', '580px');
		ibHeader.initSheet('subSheet');

		subSheet.SetEllipsis(1); 				// 말줄임 표시여부
		subSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		subSheet.SetEditable(1);
		subSheet.SetVisible(1);
	}

	function setSheetHeader_judgingRankExcelRankSheet() {
		var	ibHeader = new IBHeader();
		var initSheet = {};

		ibHeader.addHeader({Header:"No",		Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"no" });
		ibHeader.addHeader({Header:"",			Type:"checkBox",      Hidden:1, Width:60,   Align:"Center",  SaveName:"chk" });
	    ibHeader.addHeader({Header:"등급",		Type:"Text",      Hidden:1, Width:60,   Align:"Center",  ColMerge:1,   SaveName:"rankGb",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
	    ibHeader.addHeader({Header:"랭크",		Type:"Text",      Hidden:0, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"rankNo",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
	    ibHeader.addHeader({Header:"업체구분",		Type:"Text",      Hidden:1, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"scale",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
	    ibHeader.addHeader({Header:"무역업번호",	Type:"Text",      Hidden:0, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"memberId",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });
	    ibHeader.addHeader({Header:"업체명",		Type:"Text",      Hidden:0, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"coNmKr",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:300 });

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction",
			DeferredVScroll: 1,
			Ellipsis: 1,
			SelectionRowsMode: 1,
			SearchMode: 4,
			NoFocusMode : 0,
			Alternate : 0,
			Page: 10,
			SizeMode: 4,
			MergeSheet: msHeaderOnly
		});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 1});

		var container = $('#excelRankSheet')[0];
		createIBSheet2(container, 'excelRankSheet', '53%', '300px');
		ibHeader.initSheet('excelRankSheet');

		excelRankSheet.SetEllipsis(1); 				// 말줄임 표시여부
		excelRankSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		excelRankSheet.SetEditable(1);
		excelRankSheet.SetVisible(1);
	}

	function mainSheet_OnSearchEnd() {
		if(mainSheet.RowCount() > 0) {
			var rankGb = mainSheet.GetCellValue(1, 'rankGb');
			mainSheet.SetSelectRow(1);
			getSubList(rankGb);
		} else {
			subSheet.LoadSearchData(null);
		}
	}

	// 목록 가져오기
	function getMainList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/arm/selectJudgingRankMainList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data) {
				mainSheet.LoadSearchData({Data: (data.resultList || [])});
			}
		});
	}

	// 목록 가져오기
	function getSubList(rankGb) {
		var searchParams = $('#searchForm').serializeObject();
		searchParams.searchRankGb = rankGb;

		global.ajax({
			type : 'POST'
			, url : "/tdms/arm/selectJudgingRankSubList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data) {
				subSheet.LoadSearchData({Data: (data.resultList || [])});
				getExcelRankList();
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
				getMainList();
			}
		});
	}

	// 상세 페이지 & 팝업
	function mainSheet_OnClick(Row, Col, Value) {
		if(Row > 0) {
			var rankGb = mainSheet.GetCellValue(Row, 'rankGb');
			getSubList(rankGb);
		}
	}

	function doSave() {
		var pCnt = 0;
		for (var i = 1 ; i <= mainSheet.RowCount(); i++) {
			if(mainSheet.GetCellValue(i, 'rankGbNm') != 'K') {
				pCnt += Number(mainSheet.GetCellValue(i, 'cnt'));
			}
		}

		$('#sumCnt').val(pCnt);
		var jsonParam = $('#searchForm').serializeObject();
		var saveJson = mainSheet.GetSaveJson();
		if(saveJson.data == '') {
			alert("수정할 내용이 없습니다. ");
			return false;
		}
		jsonParam.judgingRankMainList = saveJson.data;

		if(confirm('수정하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tdms/arm/saveCompJudgingRank.do'
				, data : JSON.stringify(jsonParam)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data) {
					console.log(data);
					if(data.result.chkYn == 'Y') {
						getMainList();
					}else {
						alert('업체수의 합이 다릅니다.\nA~J등급 까지의 업체수의 합이 ' + data.result.sumCnt + ' 이어야 합니다.');
					}
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}
	}

	function doExcel() {
        downloadIbSheetExcel(mainSheet, '수출부가가치창출조회_리스트', '');
	}

	function doCorpExcel() {
        downloadIbSheetExcel(excelRankSheet, '수출부가가치창출조회(업체)_리스트', '');
	}

	function getExcelRankList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			// , url : "/tdms/arm/selectJudgingRankExcelRankList.do"
			, url : "/tdms/arm/selectJudgingRankSubList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data) {
				excelRankSheet.LoadSearchData({Data: (data.resultList || [])});
			}
		});
	}

	function doRank() {
		var jsonParam = $('#searchForm').serializeObject();

		if(confirm('랭크 반영하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tdms/arm/saveRankJudgingRank.do'
				, data : JSON.stringify(jsonParam)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data) {
					getMainList();
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}
	}
</script>