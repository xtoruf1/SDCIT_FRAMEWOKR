<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">기준일자</th>
				<td>
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="stDate" name="stDate" value="${defaultDate.stDate}" class="txt datepicker" placeholder="시작일" title="시작일" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<input type="hidden" id="stDateHidden" value="${defaultDate.stDate}" />
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="edDate" name="edDate" value="${defaultDate.edDate}" class="txt datepicker" placeholder="종료일" title="종료일" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<input type="hidden" id="edDateHidden" value="${defaultDate.edDate}" />
						</div>
					</div>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div style="width: 100%;height: 100%;display: flex;justify-content: space-between;">
		<div id="consultList1" class="sheet"></div>
		<div id="consultList2" class="sheet"></div>
	</div>
</div>
<form id="openConsultForm" name="openConsultForm" method="post">
<input type="hidden" id="dateType" name="dateType" value="2" />
<input type="hidden" id="dateFrom" name="dateFrom" value="" />
<input type="hidden" id="dateTo" name="dateTo" value="" />
<input type="hidden" id="expertNm" name="expertNm" value="" />
<input type="hidden" id="consultChannel" name="consultChannel" value="" />
</form>
<script type="text/javascript">
	var	ibHeader1 = new IBHeader();
	ibHeader1.addHeader({Header: '상담구분', Type: 'Text', SaveName: 'statType1Nm', Width: 115, Align: 'Center', Cursor: 'Pointer'});
	ibHeader1.addHeader({Header: '상세구분', Type: 'Text', SaveName: 'statType2Nm', Width: 130, Align: 'Left', Cursor: 'Pointer'});
	ibHeader1.addHeader({Header: '상담건수', Type: 'Int', SaveName: 'cnt', Width: 90, Align: 'Right', Cursor: 'Pointer'});
	ibHeader1.addHeader({Header: '비중', Type: 'Float', SaveName: 'ratio', Width: 85, Align: 'Center', Format: '#,##0.00', Cursor: 'Pointer'});

	ibHeader1.addHeader({Header: 'statType1Cd', Type: 'Text', SaveName: 'statType1Cd', Width: 0, Align: 'Center', Hidden: true});
	ibHeader1.addHeader({Header: 'statType2Cd', Type: 'Text', SaveName: 'statType2Cd', Width: 0, Align: 'Center', Hidden: true});

	ibHeader1.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', MergeSheet: 2, Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader1.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	var	ibHeader2 = new IBHeader();
	ibHeader2.addHeader({Header: '전문가', Type: 'Text', SaveName: 'memberNm', Width: 150, Align: 'Center'});
	ibHeader2.addHeader({Header: '채팅상담', Type: 'Int', SaveName: 'chatCnt', Width: 100, Align: 'Right'});
	ibHeader2.addHeader({Header: '화상상담', Type: 'Int', SaveName: 'viewCnt', Width: 100, Align: 'Right'});
	ibHeader2.addHeader({Header: '전화상담', Type: 'Int', SaveName: 'callCnt', Width: 100, Align: 'Right'});
	ibHeader2.addHeader({Header: '오픈상담', Type: 'Int', SaveName: 'openCnt', Width: 100, Align: 'Right'});
	ibHeader2.addHeader({Header: '전체', Type: 'Int', SaveName: 'allCnt', Width: 100, Align: 'Right'});

	ibHeader2.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', MergeSheet: 2, Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader2.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	$(document).ready(function(){
		var container1 = $('#consultList1')[0];
		createIBSheet2(container1, 'consultList1Sheet', '43%', '600px');
		ibHeader1.initSheet('consultList1Sheet');
		consultList1Sheet.SetSelectionMode(4);

		// 편집모드 OFF
		consultList1Sheet.SetEditable(0);

		var container2 = $('#consultList2')[0];
		createIBSheet2(container2, 'consultList2Sheet', '53%', '600px');
		ibHeader2.initSheet('consultList2Sheet');
		consultList2Sheet.SetSelectionMode(4);

		// 편집모드 OFF
		consultList2Sheet.SetEditable(0);

		getList();
	});

	function doSearch() {
		var startymd = Date.parse($('#stDate').val());
		var endymd = Date.parse($('#edDate').val());

		if (startymd > endymd) {
			alert('시작일은 종료일 이전이어야 합니다.');

			$('#stDate').val($('#stDateHidden').val());
			$('#edDate').val($('#edDateHidden').val());

			return;
		}

		getList();
	}

	function getList() {
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectExptConsultStatList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				stDate : $('#stDate').val().replace(/-/gi, '')
				, edDate : $('#edDate').val().replace(/-/gi, '')
			}
			, async : true
			, spinner : true
			, success : function(data){
				consultList1Sheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function getDetailList(statType1Cd, statType2Cd) {
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectExptConsultStatDetailList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				stDate : $('#stDate').val().replace(/-/gi, '')
				, edDate : $('#edDate').val().replace(/-/gi, '')
				, statType1Cd : statType1Cd
				, statType2Cd : statType2Cd
			}
			, async : true
			, spinner : true
			, success : function(data){
				consultList2Sheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function consultList1Sheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('consultList1Sheet', row);
	}

	function consultList2Sheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('consultList2Sheet', row);
	}

	function consultList1Sheet_OnSearchEnd(code, msg) {
	    if (code == 0) {
	    	consultList1Sheet.SetRowBackColor(1, '#efdfcf');
	    	consultList1Sheet.SetFrozenRows(1);

	    	getDetailList();

	    	// 상담구분에 볼드 처리
			consultList1Sheet.SetColFontBold('statType1Nm', 1);
			// 상세구분에 볼드 처리
			consultList1Sheet.SetColFontBold('statType2Nm', 1);
			// 상담건수에 볼드 처리
			consultList1Sheet.SetColFontBold('cnt', 1);
			// 비중에 볼드 처리
			consultList1Sheet.SetColFontBold('ratio', 1);
	    } else {
			console.log('consultList1Sheet_OnSearchEnd : ', '조회 오류');
	    }
	}

	function consultList2Sheet_OnSearchEnd(code, msg) {
	    if (code == 0) {
	    	consultList2Sheet.SetRowBackColor(1, "#efdfcf");
	    	consultList2Sheet.SetFrozenRows(1);
	    } else {
	    	console.log('consultList2Sheet_OnSearchEnd : ', '조회 오류');
	    }
	}

	function consultList1Sheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row == 1) {
			consultList2Sheet.SetColHidden('chatCnt', false);
			consultList2Sheet.SetColHidden('viewCnt', false);
			consultList2Sheet.SetColHidden('callCnt', false);
			consultList2Sheet.SetColHidden('openCnt', false);
			consultList2Sheet.SetColHidden('allCnt', false);

			getDetailList();
		} else if (row > 1 && consultList1Sheet.ColSaveName(col) != 'statType1Nm') {
			if (consultList1Sheet.GetCellValue(row, 'statType1Cd') == '01') {
				if (consultList1Sheet.GetCellValue(row, 'statType2Cd') == '01') {
					consultList2Sheet.SetColHidden('chatCnt', false);
					consultList2Sheet.SetColHidden('viewCnt', true);
					consultList2Sheet.SetColHidden('callCnt', true);
					consultList2Sheet.SetColHidden('openCnt', true);
					consultList2Sheet.SetColHidden('allCnt', true);
				} else if (consultList1Sheet.GetCellValue(row, 'statType2Cd') == '02') {
					consultList2Sheet.SetColHidden('chatCnt', true);
					consultList2Sheet.SetColHidden('viewCnt', false);
					consultList2Sheet.SetColHidden('callCnt', true);
					consultList2Sheet.SetColHidden('openCnt', true);
					consultList2Sheet.SetColHidden('allCnt', true);
				} else if (consultList1Sheet.GetCellValue(row, 'statType2Cd') == '03') {
					consultList2Sheet.SetColHidden('chatCnt', true);
					consultList2Sheet.SetColHidden('viewCnt', true);
					consultList2Sheet.SetColHidden('callCnt', false);
					consultList2Sheet.SetColHidden('openCnt', true);
					consultList2Sheet.SetColHidden('allCnt', true);
				} else if (consultList1Sheet.GetCellValue(row, 'statType2Cd') == '04') {
					consultList2Sheet.SetColHidden('chatCnt', true);
					consultList2Sheet.SetColHidden('viewCnt', true);
					consultList2Sheet.SetColHidden('callCnt', true);
					consultList2Sheet.SetColHidden('openCnt', false);
					consultList2Sheet.SetColHidden('allCnt', true);
				}
			} else {
				consultList2Sheet.SetColHidden('chatCnt', false);
				consultList2Sheet.SetColHidden('viewCnt', false);
				consultList2Sheet.SetColHidden('callCnt', false);
				consultList2Sheet.SetColHidden('openCnt', false);
				consultList2Sheet.SetColHidden('allCnt', false);
			}

			if (consultList1Sheet.GetCellValue(row, 'statType1Cd') == '03') {
				consultList2Sheet.RemoveAll();
			} else {
				getDetailList(consultList1Sheet.GetCellValue(row, 'statType1Cd'), consultList1Sheet.GetCellValue(row, 'statType2Cd'));
			}
		}
	}

	function consultList2Sheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0 && value != '') {
			$('#dateFrom').val($('#stDate').val());
			$('#dateTo').val($('#edDate').val());

			if (row > 1) {
				$('#expertNm').val(consultList2Sheet.GetCellValue(row, 'memberNm'));
			} else {
				$('#expertNm').val('');
			}

			if (consultList2Sheet.ColSaveName(col) == 'chatCnt') {
				$('#consultChannel').val('01');
			} else if (consultList2Sheet.ColSaveName(col) == 'viewCnt') {
				$('#consultChannel').val('02');
			} else if (consultList2Sheet.ColSaveName(col) == 'callCnt') {
				$('#consultChannel').val('03');
			} else if (consultList2Sheet.ColSaveName(col) == 'openCnt') {
				$('#consultChannel').val('0');
			} else {
				$('#consultChannel').val('');
			}
		}
	}

	function setDefaultPickerValue(objId) {
		if (objId == 'stDate') {
			$('#stDate').val('${defaultDate.stDate}');
			$('#stDateHidden').val('${defaultDate.stDate}');
		} else if (objId == 'edDate') {
			$('#edDate').val('${defaultDate.edDate}');
			$('#edDateHidden').val('${defaultDate.edDate}');
		}
	}
</script>