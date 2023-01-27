<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doSave();">저장</button>
	</div>

	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="goList();">목록</button>
	</div>
</div>
<form id="frm" method="post">
	<div class="cont_block">
		<div class="search">
		<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
		<input type="hidden" id="scoreMstId" name="scoreMstId" value="${params.scoreMstId }"/>
			<table class="formTable">
				<colgroup>
					<col width="15%" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">개정일 <strong class="point">*</strong></th>
						<td>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="startBase" name="startBase" class="txt datepicker" title="시작일" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" onclick="clearPickerValue('startBase');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
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
					<td class="align_ctr">
						<span class="label">대표이사 재직기간 </span>
						<input type="text" class="form_text" style="width: 60px !important; text-align: center;" name="baseTenure" id="baseTenure" value="${ceoBase.baseTenure}" maxlength="2"/>
						<span class="label"> 년 이하 시</span>
					</td>
					<td class="align_ctr">
						<input type="text" class="form_text" style="text-align: center;" name="ceoScore" id="ceoScore" value="<c:out value="${ceoBase.score }"/>"  maxlength="2"/>
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
		ibHeader.addHeader({Header: '평균 증가율 (단위$) | 이상'	, Type: 'Int'			, SaveName: 'startRate'		, Edit: true	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '평균 증가율 (단위$) | 미만'	, Type: 'Int'			, SaveName: 'endRate'		, Edit: false	, Width: 40		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수|점수'				, Type: 'Int'			, SaveName: 'score'			, Edit: true	, Width: 40		, Align: 'Center'});
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

	}

	function setSheetHeader_threeYearRatetWeight() {	// 심사기준 최근 3년 평균 수출증가율 목록 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '가중치 | 3년 연속 수출증가'	, Type: 'Float'			, SaveName: 'threeRate'		, Edit: true	, Width: 20		, Align: 'Center'	, Format: '0.0'});
		ibHeader.addHeader({Header: '가중치 | 2년 연속 수출증가'	, Type: 'Float'			, SaveName: 'twoRate'		, Edit: true	, Width: 20		, Align: 'Center'	, Format: '0.0'});
		ibHeader.addHeader({Header: '가중치 | 1년 연속 수출증가'	, Type: 'Float'			, SaveName: 'oneRate'		, Edit: true	, Width: 20		, Align: 'Center'	, Format: '0.0'});
		ibHeader.addHeader({Header: '가중치 | 3년 연속 수출감소'	, Type: 'Float'			, SaveName: 'elseRate'		, Edit: true	, Width: 20		, Align: 'Center'	, Format: '0.0'});
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

	}

	function setSheetHeader_exportScaleList() {	// 심사기준 수출규모 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '최근 수출금액 (단위$) | 이상'	, Type: 'Int'			, SaveName: 'startExpscale'		, Edit: true	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '최근 수출금액 (단위$) | 미만'	, Type: 'Int'			, SaveName: 'endExpscale'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수|점수'				, Type: 'Int'			, SaveName: 'score'				, Edit: true	, Width: 20		, Align: 'Center'});
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

	}

	function setSheetHeader_overRateList() {	// 심사기준 해외매출비중 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '매출액 대비 수출비중 (단위%) | 이상'	, Type: 'Int'			, SaveName: 'overStartRate'		, Edit: true	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '매출액 대비 수출비중 (단위%) | 미만'	, Type: 'Int'			, SaveName: 'overEndRate'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수|점수'						, Type: 'Int'			, SaveName: 'score'				, Edit: true	, Width: 20		, Align: 'Center'});
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

	}

	function setSheetHeader_directRateList() {	// 심사기준 직수출 비중 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '총수출 대비 직수출 비중 (단위%) | 이상'	, Type: 'Int'			, SaveName: 'directStartRate'	, Edit: true	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '총수출 대비 직수출 비중 (단위%) | 미만'	, Type: 'Int'			, SaveName: 'directEndRate'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수|점수'						, Type: 'Int'			, SaveName: 'score'				, Edit: true	, Width: 20		, Align: 'Center'});
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

	}

	function setSheetHeader_techDevList() {	// 심시기준 기술개발 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '기술개발 항목'		, Type: 'Text'			, SaveName: 'certifiName'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수'			, Type: 'Int'			, SaveName: 'score'				, Edit: true	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'		, SaveName: 'status'			, Hidden: true});
		ibHeader.addHeader({Header: '구분'			, Type: 'Text'			, SaveName: 'gubun'				, Hidden: true});
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
	}

	function setSheetHeader_sinceList() {	// 심시기준 업력 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '최초 설립 후 현재까지의 업력 | 이상'		, Type: 'Int'			, SaveName: 'sinceStartYear'	, Edit: true	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '최초 설립 후 현재까지의 업력 | 미만'		, Type: 'Int'			, SaveName: 'sinecEndYear'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수|점수'						, Type: 'Int'			, SaveName: 'score'				, Edit: true	, Width: 20		, Align: 'Center'});
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
	}

	function setSheetHeader_stateList() {	// 심시기준 재무제표 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '3년간 영업이익 추이'		, Type: 'Text'			, SaveName: 'stateName'		, Edit: false	, Width: 20		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '점수'				, Type: 'Int'			, SaveName: 'score'			, Edit: true	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '구분'				, Type: 'Text'			, SaveName: 'gubun'			, Hidden: true});
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
	}

	function setSheetHeader_creditList() {	// 심시기준 크레탑 신용반영 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '이상'			, Type: 'Text'			, SaveName: 'startCredit'	, Edit: true	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '미만'			, Type: 'Text'			, SaveName: 'endCredit'		, Edit: true	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '점수'			, Type: 'Int'			, SaveName: 'score'			, Edit: true	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'		, SaveName: 'status'		, Hidden: true});
		ibHeader.addHeader({Header: '심사기준ID'		, Type: 'Text'			, SaveName: 'scoreMstId'	, Hidden: true});
		ibHeader.addHeader({Header: '크레탑기준ID'		, Type: 'Text'			, SaveName: 'creditId'		, Hidden: true});

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
	}

	function threeYearRateListSheet_OnChange(Row, Col, Value) {	// 최근 3년 평균 수출 증가율 값 수정시

		if(Col == 2) {
			if(Row != 5) {
				threeYearRateListSheet.SetCellValue(Row+1, 'endRate', Value);
			}
		}
	}

	function exportScaleListSheet_OnChange(Row, Col, Value) {	// 수출규모 심사기준 값 수정시

		if(Col == 0) {
			exportScaleListSheet.SetCellValue(Row+1, 'endExpscale', Value);
		}
	}

	function overRateListSheet_OnChange(Row, Col, Value) {	// 해외매출비중 값 변경시

		if(Col == 0) {
			overRateListSheet.SetCellValue(Row+1, 'overEndRate', Value);
		}
	}

	function directRateListSheet_OnChange(Row, Col, Value) {	// 직수출비중 값 변경시

		if(Col == 0) {
			directRateListSheet.SetCellValue(Row+1, 'directEndRate', Value);
		}

	}

	function sinceListSheet_OnChange(Row, Col, Value) {	// 업력 값 변경시

		if(Col == 0) {
			sinceListSheet.SetCellValue(Row+1, 'sinecEndYear', Value);
		}
	}

	function goList() {		// 목록으로 이동

		$('#frm').attr('action', '/hanbit/judgingMng/judgingCriteriaList.do');
		$('#frm').submit();
	}

	function getJudgingCriteria() {	// 심사기준 목록 조회

		var searchParam = $('#frm').serializeObject();

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

	function setSaveSheetData() {	// 저장할 시트 데이터 세팅

		var pParamData = $('#frm').serializeObject();

        //최근 3년 평균 수출증가율 저장 데이터 세팅
		var threeRate = threeYearRateListSheet.ExportData({
			'Type' : 'json'
		});

		if (threeRate.data.length) {
			var map = {};
			var list = [];
			$.each(threeRate, function(key1, value1) {
				map = {};
				$.each(value1, function(key2, value2) {
					map = value2;
					list.push(map);
				});

				pParamData['threeYearRateList'] = list;
			});
		}


		//최근 3년 평균 수출증가율 가중치 저장 데이터 세팅
		var threeWig = threeYearRateWeightSheet.ExportData({
			'Type' : 'json'
		});

		if (threeWig.data.length) {
			var map = {};
			var list = [];
			$.each(threeWig, function(key1, value1) {
				map = {};
				$.each(value1, function(key2, value2) {
					map = value2;
					list.push(map);
				});

				pParamData['threeYearRateWeight'] = list;
			});
		}


		//수출규모 저장 데이터 세팅
		var exp = exportScaleListSheet.ExportData({
			'Type' : 'json'
		});

		if (exp.data.length) {
			var map = {};
			var list = [];
			$.each(exp, function(key1, value1) {
				map = {};
				$.each(value1, function(key2, value2) {
					map = value2;
					list.push(map);
				});

				pParamData['exportScaleList'] = list;
			});
		}


		//해외매출비중 저장 데이터 세팅
		var over = overRateListSheet.ExportData({
			'Type' : 'json'
		});

		if (over.data.length) {
			var map = {};
			var list = [];
			$.each(over, function(key1, value1) {
				map = {};
				$.each(value1, function(key2, value2) {
					map = value2;
					list.push(map);
				});

				pParamData['overRateList'] = list;
			});
		}


		//직수출 비중 저장 데이터 세팅
		var directRate = directRateListSheet.ExportData({
			'Type' : 'json'
		});

		if (directRate.data.length) {
			var map = {};
			var list = [];
			$.each(directRate, function(key1, value1) {
				map = {};
				$.each(value1, function(key2, value2) {
					map = value2;
					list.push(map);
				});

				pParamData['directRateList'] = list;
			});
		}


		//기술개발 저장 데이터 세팅
		var techDev = techDevListSheet.ExportData({
			'Type' : 'json'
		});

		if (techDev.data.length) {
			var map = {};
			var list = [];
			$.each(techDev, function(key1, value1) {
				map = {};
				$.each(value1, function(key2, value2) {
					map = value2;
					list.push(map);
				});

				pParamData['techDevList'] = list;
			});
		}


		//업력 저장 데이터 세팅
		var since = sinceListSheet.ExportData({
			'Type' : 'json'
		});

		if (since.data.length) {
			var map = {};
			var list = [];
			$.each(since, function(key1, value1) {
				map = {};
				$.each(value1, function(key2, value2) {
					map = value2;
					list.push(map);
				});

				pParamData['sinceList'] = list;
			});
		}


		//재무제표 저장 데이터 세팅
		var state = stateListSheet.ExportData({
			'Type' : 'json'
		});

		if (state.data.length) {
			var map = {};
			var list = [];
			$.each(state, function(key1, value1) {
				map = {};
				$.each(value1, function(key2, value2) {
					map = value2;
					list.push(map);
				});

				pParamData['stateList'] = list;
			});
		}


		//크레탑 신용반영 저장 데이터 세팅
		var credit = creditListSheet.ExportData({
			'Type' : 'json'
		});

		if (credit.data.length) {
			var map = {};
			var list = [];
			$.each(credit, function(key1, value1) {
				map = {};
				$.each(value1, function(key2, value2) {
					map = value2;
					list.push(map);
				});

				pParamData['creditList'] = list;
			});
		}

		return pParamData;
	}

	function sheetsValidation() {	// 저장전 시트 validation

		// 최근 3년 평균 수출 증가율 공백체크
		var tyrFirstIdx = threeYearRateListSheet.GetDataFirstRow();
		var tyrRowCnt = threeYearRateListSheet.RowCount();

		for(var i = tyrFirstIdx; i < tyrRowCnt + tyrFirstIdx; i++) {

			var startRate = threeYearRateListSheet.GetCellValue(i,'startRate');
			var underStartRate = threeYearRateListSheet.GetCellValue(i+1,'startRate');
			var score = threeYearRateListSheet.GetCellValue(i,'score');

			if(''+startRate == '') {
				alert(i+'번째 평균 증가율 이상을 입력해 주세요.');
				return false;
			}

			if(i != tyrFirstIdx-1+4) {
				if(startRate <= underStartRate) {
					alert(i+'번째 평균 증가율 이상은 이전 증가율보다 크거나 같을 수 없습니다.');
					return false;
				}
			}

			if(''+score == '') {
				alert(i-1+'번째 점수를 입력해 주세요.');
				return false;
			}

		}


		// 최근 3년 평균 수출 증가율 가중치 공백체크
		var tyrwFirstIdx = threeYearRateWeightSheet.GetDataFirstRow();
		var tyrwRowCnt = threeYearRateWeightSheet.RowCount();

		for(var i = tyrwFirstIdx; i < tyrwRowCnt + tyrwFirstIdx; i++) {

			var threeRate = threeYearRateWeightSheet.GetCellValue(i,'threeRate');
			var twoRate = threeYearRateWeightSheet.GetCellValue(i,'twoRate');
			var oneRate = threeYearRateWeightSheet.GetCellValue(i,'oneRate');
			var elseRate = threeYearRateWeightSheet.GetCellValue(i,'elseRate');

			if(threeRate == 0) {
				alert('3년 연속 수출증가 평가 점수를 입력해 주세요.');
				return false;
			}

			if(twoRate == 0) {
				alert('2년 연속 수출증가 평가 점수를 입력해 주세요.');
				return false;
			}

			if(oneRate == 0) {
				alert('1년 연속 수출증가 평가 점수를 입력해 주세요.');
				return false;
			}

			if(elseRate == 0) {
				alert('3년 연속 수출감소 평가 점수를 입력해 주세요.');
				return false;
			}
		}


		// 수출규모 공백체크
		var expsFirstIdx = exportScaleListSheet.GetDataFirstRow();
		var expsRowCnt = exportScaleListSheet.RowCount();

		for(var i = expsFirstIdx; i < expsRowCnt + expsFirstIdx; i++) {

			var startExpscale = exportScaleListSheet.GetCellValue(i,'startExpscale');
			var underStartExpscale = exportScaleListSheet.GetCellValue(i+1,'startExpscale');
			var score = exportScaleListSheet.GetCellValue(i,'score');

			if(''+startExpscale == '') {
				alert(i+'번째 최근 수출금액 이상을 입력해 주세요.');
				return false;
			}

			if(startExpscale <= underStartExpscale) {
				alert(i+'번째 최근 수출금액 이상은 이전 최근 수출금액 이상보다 크거나 같을 수 없습니다.');
				return false;
			}

			if(''+score == '') {
				alert(1+'번째 점수를 입력해 주세요.');
				return false;
			}
		}


		// 해외매출비중 공백체크
		var orlFirstIdx = overRateListSheet.GetDataFirstRow();
		var orlRowCnt = overRateListSheet.RowCount();

		for(var i = orlFirstIdx; i < orlRowCnt + orlFirstIdx; i++) {

			var startOverRate = overRateListSheet.GetCellValue(i,'overStartRate');
			var underStartOverRate = overRateListSheet.GetCellValue(i+1,'overStartRate');
			var score = overRateListSheet.GetCellValue(i,'score');

			if(''+startOverRate == '' ) {
				alert(i-1+'번째 최근 수출금액 이상을 입력해 주세요.');
				return false;
			}

			if(startOverRate <= underStartOverRate) {
				alert(i+'번째 매출액 대비 수출비중 이상은 이전 수출비중보다 크거나 같을 수 없습니다.');
				return false;
			}

			if(''+score == '' ) {
				alert(i-1+'번째 점수를 입력해 주세요.');
				return false;
			}
		}


		// 직수출 비중 공백체크
		var dirFirstIdx = directRateListSheet.GetDataFirstRow();
		var dirRowCnt = directRateListSheet.RowCount();

		for(var i = dirFirstIdx; i < dirRowCnt + dirFirstIdx; i++) {

			var directStartRate = directRateListSheet.GetCellValue(i,'directStartRate');
			var underDirectStartRate = directRateListSheet.GetCellValue(i+1,'directStartRate');
			var score = directRateListSheet.GetCellValue(i,'score');

			if(''+directStartRate == '' ) {
				alert(i-1+'번째 총수출 대비 직수출 비중 이상을 입력해 주세요.');
				return false;
			}

			if(directStartRate <= underDirectStartRate) {
				alert(i+'번째 총수출 대비 직수출 비중 이상은 이전 직수출 비중보다 크거나 같을 수 없습니다.');
				return false;
			}

			if(''+score == '' ) {
				alert(i-1+'번째 점수를 입력해 주세요.');
				return false;
			}
		}


		// 기술개발 공백체크
		var techFirstIdx = techDevListSheet.GetDataFirstRow();
		var techRowCnt = techDevListSheet.RowCount();

		for(var i = techFirstIdx; i < techRowCnt; i++) {

			var score = directRateListSheet.GetCellValue(i,'score');

			if(''+score == '' ) {
				alert(i+'번째 점수를 입력해 주세요.');
				return false;
			}
		}


		// 업력 공백체크
		var sinceFirstIdx = sinceListSheet.GetDataFirstRow();
		var sinceRowCnt = sinceListSheet.RowCount();

		for(var i = sinceFirstIdx; i < sinceRowCnt + sinceFirstIdx; i++) {

			var sinceStartYear = sinceListSheet.GetCellValue(i,'sinceStartYear');
			var underSinceStartYear = sinceListSheet.GetCellValue(i+1,'sinceStartYear');
			var score = sinceListSheet.GetCellValue(i,'score');

			if(''+sinceStartYear == '' ) {
				alert(i-1+'번째 최초 설립 후 현재까지의 업력 이상을 입력해 주세요.');
				return false;
			}

			if(sinceStartYear <= underSinceStartYear) {
				alert(i+'번째 최초 설립 후 현재까지의 업력 이상은 이전 업력보다 크거나 같을 수 없습니다.');
				return false;
			}

			if(''+score == '' ) {
				alert(i-1+'번째 점수를 입력해 주세요.');
				return false;
			}
		}


		// 재무제표 공백체크
		var statFirstIdx = stateListSheet.GetDataFirstRow();
		var statRowCnt = stateListSheet.RowCount();

		for(var i = statFirstIdx; i < statRowCnt; i++) {

			var score = stateListSheet.GetCellValue(i,'score');

			if(''+score == '' ) {
				alert(i+'번째 점수를 입력해 주세요.');
				return false;
			}
		}


		// 크레탑 신용반영 공백체크
		var credFirstIdx = creditListSheet.GetDataFirstRow();
		var credRowCnt = creditListSheet.RowCount();

		for(var i = credFirstIdx; i < credRowCnt; i++) {

			var startCredit = creditListSheet.GetCellValue(i,'startCredit');
			var endCredit = creditListSheet.GetCellValue(i,'endCredit');
			var score = creditListSheet.GetCellValue(i,'score');

			if(startCredit == '' ) {
				alert(i+'번째 이상 심사기준을 입력해 주세요.');
				return false;
			}

			if(endCredit == '' ) {
				alert(i+'번째 미만 심사기준을 입력해 주세요.');
				return false;
			}

			if(''+score == '' ) {
				alert(i+'번째 점수를 입력해 주세요.');
				return false;
			}
		}


		// 대표이사 재직기간 공백체크
		if($('#baseTenure').val() == '') {
			alert('대표이사 재직기간 기준을 입력해 주세요.');
			return false;
		}

		if($('#ceoScore').val() == '') {
			alert('대표이사 재직기간 평가점수 입력해 주세요.');
			return false;
		}


		return true;

	}

	function startDateValidation() {	// 개정일 날짜체크

		var returnYn = false;

		global.ajax({
			type : 'POST'
			, url : "/hanbit/judgingMng/selectStartDateCnt.do"
			, data : {'startBase' : $('#startBase').val()}
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				if(data.resultBoolean == true ) {
					returnYn = true;
				} else {
					returnYn = false;
				}
			}
		});

		return returnYn;
	}

	function doSave() {	// 저장

		if($('#startBase').val() == ''){
			alert('개정일을 선택해주세요.');
			$('#startBase').focus();
			return;
		}

		if(startDateValidation() != true) {
			alert("기존 개정일보다 같거나 빠를 수 없습니다.");
			return;
		}

		if(sheetsValidation() != true) {
			return;
		}

		var reData = setSaveSheetData();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/judgingMng/insertJudgingCriteria.do"
			, contentType : 'application/json'
			, data : JSON.stringify(reData)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				goList();
			}
		});
	}

</script>