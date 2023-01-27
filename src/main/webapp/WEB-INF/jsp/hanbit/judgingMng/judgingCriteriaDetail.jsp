<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="goList();">목록</button>
	</div>
</div>
<form id="searchForm" method="post">
	<div class="cont_block">
		<div class="search">
		<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
		<input type="hidden" id="scoreMstId" name="scoreMstId" value="${detailParams.scoreMstId }"/>
		<input type="hidden" id="searchStartBase" name="searchStartBase" value="${detailParams.searchStartBase }"/>
			<table class="formTable">
				<colgroup>
					<col width="15%" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">개정일 <strong class="point">*</strong></th>
						<td>
							<input type="text" id="startBase" name="startBase" value="${startBase }" class="form_text" disabled/>
						</td>
		            </tr>
				</tbody>
			</table>
		</div>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">최근 3년 평균 수출 증가율</h3>
		</div>

		<div>
			<div id="threeYearRateListSheet" class="sheet"></div>
		</div>
	</div>

	<div class="cont_block">
		<div>
			<div id="threeYearRateWeightSheet" class="sheet"></div>
		</div>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">수출규모</h3>
		</div>

		<div>
			<div id="exportScaleListSheet" class="sheet"></div>
		</div>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">해외매출비중</h3>
		</div>

		<div>
			<div id="overRateListSheet" class="sheet"></div>
		</div>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">직수출 비중</h3>
		</div>

		<div>
			<div id="directRateListSheet" class="sheet"></div>
		</div>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">기술개발</h3>
		</div>

		<div>
			<div id="techDevListSheet" class="sheet"></div>
		</div>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">업력</h3>
		</div>

		<div>
			<div id="sinceListSheet" class="sheet"></div>
		</div>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">재무제표</h3>
		</div>

		<div>
			<div id="stateListSheet" class="sheet"></div>
		</div>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">크레탑 신용반영</h3>
		</div>

		<div>
			<div id="creditListSheet" class="sheet"></div>
		</div>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">대표이사 재직기간(감점)</h3>
		</div>
		<table class="formTable">
			<colgroup>
				<col style="width:23%">
				<col style="width:15%">
			</colgroup>
			<thead>
				<th class="align_ctr">대표이사 재직기간</th>
				<th class="align_ctr">점수</th>
			</thead>
			<tbody>
				<tr>
					<td class="align_ctr" style="background-color: #f6f6f6;">
						<div class="form_row">
							<span class="prepend">대표이사 재직기간</span>
							<input type="text" class="form_text" style="width: 60px !important; text-align: center;" name="baseTenure" id="baseTenure" value="${ceoBase.baseTenure}" maxlength="2" disabled="disabled"/>
							<span class="append">년 이하 시</span>
						</div>
					</td>
					<td class="align_ctr" style="background-color: #f6f6f6;">
						<c:out value="${ceoBase.score }"></c:out>
					</td>
				</tr>
			</tbody>
		</table>

	</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_threeYearRateList();		// 심사기준 최근 3년 평균 수출증가율 목록 헤더
		setSheetHeader_threeYearRatetWeight();	// 심사기준 최근 3년 평균 수출증가율 가중치 헤더
		setSheetHeader_exportScaleList();		// 심사기준 수출규모 헤더
		setSheetHeader_overRateList();			// 심사기준 해외매출비중 헤더
		setSheetHeader_directRateList();		// 심사기준 직수출 비중 헤더
		setSheetHeader_techDevList();			// 심시기준 기술개발 헤더
		setSheetHeader_sinceList();				// 심사기준 업력 헤더
		setSheetHeader_stateList();				// 심시기준 재무제표 헤더
		setSheetHeader_creditList();			// 심사기준 크레탑 신용반영 헤더
		getJudgingCriteria();					// 심사기준 조회

	});

	function setSheetHeader_threeYearRateList() {	// 심사기준 목록 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '4년전 수출액 (단위$) | 이상'	, Type: 'Int'			, SaveName: 'startAmt'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '4년전 수출액 (단위$) | 미만'	, Type: 'Int'			, SaveName: 'endAmt'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '평균 증가율 (단위$) | 이상'	, Type: 'Text'			, SaveName: 'startRate'		, Edit: false	, Width: 40		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '평균 증가율 (단위$) | 미만'	, Type: 'Text'			, SaveName: 'endRate'		, Edit: false	, Width: 40		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수|점수'				, Type: 'Text'			, SaveName: 'score'			, Edit: false	, Width: 40		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '상태'					, Type: 'Status'		, SaveName: 'status'		, Hidden: true});
		ibHeader.addHeader({Header: '심사기준ID'				, Type: 'Text'			, SaveName: 'scoreMstId'	, Hidden: true});
		ibHeader.addHeader({Header: '증가율ID'				, Type: 'Text'			, SaveName: 'exprateId'		, Hidden: true});


		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly+msPrevColumnMerge});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#threeYearRateListSheet')[0];
		createIBSheet2(container, 'threeYearRateListSheet', '100%', '100%');
		ibHeader.initSheet('threeYearRateListSheet');

		threeYearRateListSheet.SetEllipsis(1); // 말줄임 표시여부
		threeYearRateListSheet.SetSelectionMode(4);


	}

	function setSheetHeader_threeYearRatetWeight() {	// 심사기준 최근 3년 평균 수출증가율 목록 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '가중치 | 3년 연속 수출증가'	, Type: 'Float'			, SaveName: 'threeRate'		, Edit: false	, Width: 20		, Align: 'Center'	, Format: '0.0'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '가중치 | 2년 연속 수출증가'	, Type: 'Float'			, SaveName: 'twoRate'		, Edit: false	, Width: 20		, Align: 'Center'	, Format: '0.0'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '가중치 | 1년 연속 수출증가'	, Type: 'Float'			, SaveName: 'oneRate'		, Edit: false	, Width: 20		, Align: 'Center'	, Format: '0.0'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '가중치 | 3년 연속 수출감소'	, Type: 'Float'			, SaveName: 'elseRate'		, Edit: false	, Width: 20		, Align: 'Center'	, Format: '0.0'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '상태'					, Type: 'Status'		, SaveName: 'status'		, Hidden: true});
		ibHeader.addHeader({Header: '심사기준ID'				, Type: 'Text'			, SaveName: 'scoreMstId'	, Hidden: true});


		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#threeYearRateWeightSheet')[0];
		createIBSheet2(container, 'threeYearRateWeightSheet', '100%', '100%');
		ibHeader.initSheet('threeYearRateWeightSheet');

		threeYearRateWeightSheet.SetEllipsis(1); 		// 말줄임 표시여부
		threeYearRateWeightSheet.SetSelectionMode(4);

	}

	function setSheetHeader_exportScaleList() {	// 심사기준 수출규모 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '최근 수출금액 (단위$) | 이상'	, Type: 'Int'			, SaveName: 'startExpscale'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '최근 수출금액 (단위$) | 미만'	, Type: 'Text'			, SaveName: 'endExpscale'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수|점수'				, Type: 'Text'			, SaveName: 'score'				, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '상태'					, Type: 'Status'		, SaveName: 'status'			, Hidden: true});
		ibHeader.addHeader({Header: '심사기준ID'				, Type: 'Text'			, SaveName: 'scoreMstId'		, Hidden: true});
		ibHeader.addHeader({Header: '규모ID'					, Type: 'Text'			, SaveName: 'expscaleId'		, Hidden: true});


		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#exportScaleListSheet')[0];
		createIBSheet2(container, 'exportScaleListSheet', '100%', '100%');
		ibHeader.initSheet('exportScaleListSheet');

		exportScaleListSheet.SetEllipsis(1); 		// 말줄임 표시여부
		exportScaleListSheet.SetSelectionMode(4);

	}

	function setSheetHeader_overRateList() {	// 심사기준 해외매출비중 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '매출액 대비 수출비중 (단위%) | 이상'	, Type: 'Int'			, SaveName: 'overStartRate'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '매출액 대비 수출비중 (단위%) | 미만'	, Type: 'Text'			, SaveName: 'overEndRate'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수|점수'						, Type: 'Text'			, SaveName: 'score'				, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '상태'							, Type: 'Status'		, SaveName: 'status'			, Hidden: true});
		ibHeader.addHeader({Header: '심사기준ID'						, Type: 'Text'			, SaveName: 'scoreMstId'		, Hidden: true});
		ibHeader.addHeader({Header: '해외매출ID'						, Type: 'Text'			, SaveName: 'overrateId'		, Hidden: true});


		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#overRateListSheet')[0];
		createIBSheet2(container, 'overRateListSheet', '100%', '100%');
		ibHeader.initSheet('overRateListSheet');

		overRateListSheet.SetEllipsis(1); 		// 말줄임 표시여부
		overRateListSheet.SetSelectionMode(4);

	}

	function setSheetHeader_directRateList() {	// 심사기준 직수출 비중 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '총수출 대비 직수출 비중 (단위%) | 이상'	, Type: 'Int'			, SaveName: 'directStartRate'	, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '총수출 대비 직수출 비중 (단위%) | 미만'	, Type: 'Text'			, SaveName: 'directEndRate'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수|점수'						, Type: 'Text'			, SaveName: 'score'				, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '상태'							, Type: 'Status'		, SaveName: 'status'			, Hidden: true});
		ibHeader.addHeader({Header: '심사기준ID'						, Type: 'Text'			, SaveName: 'scoreMstId'		, Hidden: true});
		ibHeader.addHeader({Header: '직수출ID'						, Type: 'Text'			, SaveName: 'directrateId'		, Hidden: true});


		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#directRateListSheet')[0];
		createIBSheet2(container, 'directRateListSheet', '100%', '100%');
		ibHeader.initSheet('directRateListSheet');

		directRateListSheet.SetEllipsis(1); 		// 말줄임 표시여부
		directRateListSheet.SetSelectionMode(4);

	}

	function setSheetHeader_techDevList() {	// 심시기준 기술개발 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '기술개발 항목'		, Type: 'Text'			, SaveName: 'certifiName'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수'			, Type: 'Text'			, SaveName: 'score'				, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'		, SaveName: 'status'			, Hidden: true});
		ibHeader.addHeader({Header: '심사기준ID'		, Type: 'Text'			, SaveName: 'scoreMstId'		, Hidden: true});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#techDevListSheet')[0];
		createIBSheet2(container, 'techDevListSheet', '100%', '100%');
		ibHeader.initSheet('techDevListSheet');

		techDevListSheet.SetEllipsis(1); 		// 말줄임 표시여부
		techDevListSheet.SetSelectionMode(4);
	}

	function setSheetHeader_sinceList() {	// 심시기준 업력 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '최초 설립 후 현재까지의 업력 | 이상'		, Type: 'Text'			, SaveName: 'sinceStartYear'	, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '최초 설립 후 현재까지의 업력 | 미만'		, Type: 'Text'			, SaveName: 'sinecEndYear'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수|점수'						, Type: 'Text'			, SaveName: 'score'				, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '상태'							, Type: 'Status'		, SaveName: 'status'			, Hidden: true});
		ibHeader.addHeader({Header: '심사기준ID'						, Type: 'Text'			, SaveName: 'scoreMstId'		, Hidden: true});
		ibHeader.addHeader({Header: '업력ID'							, Type: 'Text'			, SaveName: 'sinceId'			, Hidden: true});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#sinceListSheet')[0];
		createIBSheet2(container, 'sinceListSheet', '100%', '100%');
		ibHeader.initSheet('sinceListSheet');

		sinceListSheet.SetEllipsis(1); 		// 말줄임 표시여부
		sinceListSheet.SetSelectionMode(4);
	}

	function setSheetHeader_stateList() {	// 심시기준 재무제표 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '3년간 영업이익 추이'		, Type: 'Text'			, SaveName: 'stateName'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수'				, Type: 'Text'			, SaveName: 'score'			, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '상태'				, Type: 'Status'		, SaveName: 'status'		, Hidden: true});
		ibHeader.addHeader({Header: '심사기준ID'			, Type: 'Text'			, SaveName: 'scoreMstId'	, Hidden: true});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#stateListSheet')[0];
		createIBSheet2(container, 'stateListSheet', '100%', '100%');
		ibHeader.initSheet('stateListSheet');

		stateListSheet.SetEllipsis(1); 		// 말줄임 표시여부
		stateListSheet.SetSelectionMode(4);
	}

	function setSheetHeader_creditList() {	// 심시기준 크레탑 신용반영 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '이상'			, Type: 'Text'			, SaveName: 'startCredit'	, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '미만'			, Type: 'Text'			, SaveName: 'endCredit'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수'			, Type: 'Text'			, SaveName: 'score'			, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'		, SaveName: 'status'		, Edit: false   , Hidden: true});
		ibHeader.addHeader({Header: '심사기준ID'		, Type: 'Text'			, SaveName: 'scoreMstId'	, Edit: false	, Hidden: true});
		ibHeader.addHeader({Header: '크레탑기준ID'		, Type: 'Text'			, SaveName: 'creditId'		, Edit: false	, Hidden: true});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#creditListSheet')[0];
		createIBSheet2(container, 'creditListSheet', '100%', '100%');
		ibHeader.initSheet('creditListSheet');

		creditListSheet.SetEllipsis(1); 		// 말줄임 표시여부
		creditListSheet.SetSelectionMode(4);
	}

	function threeYearRateListSheet_OnRowSearchEnd(row) {

		if(threeYearRateListSheet.GetCellValue(row, 'endRate') == ''){
			threeYearRateListSheet.SetCellValue(row, 'endRate','-');
		}
	}

	function exportScaleListSheet_OnRowSearchEnd(row) {

		if(exportScaleListSheet.GetCellValue(row, 'endExpscale') == ''){
			exportScaleListSheet.SetCellValue(row, 'endExpscale','-');
		} else {
			var criteriaScore = global.formatCurrency(exportScaleListSheet.GetCellValue(row, 'endExpscale'));
			exportScaleListSheet.SetCellValue(row, 'endExpscale',criteriaScore);
		}


	}

	function overRateListSheet_OnRowSearchEnd(row) {

		if(overRateListSheet.GetCellValue(row, 'overEndRate') == ''){
			overRateListSheet.SetCellValue(row, 'overEndRate','-');
		} else {
			var criteriaScore = global.formatCurrency(overRateListSheet.GetCellValue(row, 'overEndRate'));
			overRateListSheet.SetCellValue(row, 'overEndRate',criteriaScore);
		}
	}

	function directRateListSheet_OnRowSearchEnd(row) {

		if(directRateListSheet.GetCellValue(row, 'directEndRate') == ''){
			directRateListSheet.SetCellValue(row, 'directEndRate','-');
		} else {
			var criteriaScore = global.formatCurrency(directRateListSheet.GetCellValue(row, 'directEndRate'));
			directRateListSheet.SetCellValue(row, 'directEndRate',criteriaScore);
		}
	}

	function sinceListSheet_OnRowSearchEnd(row) {

		if(sinceListSheet.GetCellValue(row, 'sinecEndYear') == ''){
			sinceListSheet.SetCellValue(row, 'sinecEndYear','-');
		} else {
			var criteriaScore = global.formatCurrency(sinceListSheet.GetCellValue(row, 'sinecEndYear'));
			sinceListSheet.SetCellValue(row, 'sinecEndYear',criteriaScore);
		}
	}

	function creditListSheet_OnRowSearchEnd(row) {

		if(creditListSheet.GetCellValue(row, 'endCredit') == ''){
			creditListSheet.SetCellValue(row, 'endCredit','-');
		}
	}

	function goList() {

		$('#searchForm').attr('action', '/hanbit/judgingMng/judgingCriteriaList.do');
		$('#searchForm').submit();
	}

	function getJudgingCriteria() {	// 심사기준 목록 조회

		var searchParam = $('#searchForm').serializeObject();


		global.ajax({
			type : 'POST'
			, url : "/hanbit/judgingMng/selectJudgingCriteriaDetails.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParam)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				threeYearRateListSheet.LoadSearchData({Data: (data.threeYearRateList || []) });		//최근 3년 평균 수출증가율
				threeYearRateWeightSheet.LoadSearchData({Data: (data.threeYearRateWeight || []) });	//최근 3년 평균 수출증가율 가중치
				exportScaleListSheet.LoadSearchData({Data: (data.exportScaleList || []) });			//수출규모
				overRateListSheet.LoadSearchData({Data: (data.overRateList || []) });               //해외매출비중
				directRateListSheet.LoadSearchData({Data: (data.directRateList || []) });           //직수출 비중
				techDevListSheet.LoadSearchData({Data: (data.techDevList || []) });                 //기술개발
				sinceListSheet.LoadSearchData({Data: (data.sinceList || []) });                     //업력
				stateListSheet.LoadSearchData({Data: (data.stateList || []) });                     //재무제표
				creditListSheet.LoadSearchData({Data: (data.creditList || []) });                   //크레탑 신용반영
			}
		});
	}

</script>