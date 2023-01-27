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
		<button type="button" onclick="downloadIbSheetExcel(calculateListSheet, '정산내역', '');" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
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
				<th scope="row">정산월</th>
				<td>
					<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="dateFrom" name="dateFrom" value="${lastMonth}" class="txt monthpicker" placeholder="검색월" title="검색월" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('dateFrom');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
						</span>
						<button type="button" onclick="clearPickerValue('dateFrom');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div style="width: 100%;height: 100%;">
		<div id="calculateList" class="sheet"></div>
	</div>
</div>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상담구분', Type: 'Text', SaveName: 'statType1Nm', Width: 155, Align: 'Center'});
	ibHeader.addHeader({Header: '상세구분', Type: 'Text', SaveName: 'statType2Nm', Width: 155, Align: 'Center'});
	ibHeader.addHeader({Header: '', Type: 'Int', SaveName: 'statVal', Width: 135, Align: 'Right', Format: '#,##0'});
	
	ibHeader.addHeader({Header: 'statType1Cd', Type: 'Text', SaveName: 'statType1Cd', Width: 0, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: 'statType2Cd', Type: 'Text', SaveName: 'statType2Cd', Width: 0, Align: 'Center', Hidden: true});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', MergeSheet: 2, Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	$(document).ready(function(){
		var container = $('#calculateList')[0];
		createIBSheet2(container, 'calculateListSheet', '100%', '100%');
		ibHeader.initSheet('calculateListSheet');
		calculateListSheet.SetSelectionMode(4);
		
		// 편집모드 OFF
		calculateListSheet.SetEditable(0);
		
		var ymd = new Date();
	    var curyear =  ymd.getFullYear();
	    var currentMonth = Number(ymd.getMonth() + 1);
	    var currentDay = ymd.getDate().toString();
	    
		$('#dateFrom').datepicker('destroy');
		$('#dateFrom').monthpicker({
			pattern : 'yyyy-mm'
			, monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
			, finalYear : curyear
		});
		
		var months = [];
		var m_seq = 0;
		
		for (var i = currentMonth; i <= 12; i++) {
			months[m_seq++] = i;
		}
		
		// 현년도 현재월부터 disable
		$('#dateFrom').monthpicker().monthpicker('disableMonths', months);
		
		// Year Change
		$('#dateFrom').monthpicker().bind('monthpicker-change-year', function(e, year){
			// 현재년도
			if (year == curyear) {
				$('#dateFrom').monthpicker().monthpicker('disableMonths', months);
			// 현재년도 이전년도	
            } else {
            	$('#dateFrom').monthpicker().monthpicker('disableMonths', []);
            }
		});
		
		getList();
	});

	function calculateListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('calculateListSheet_OnSearchEnd : ', msg);
    	} else {
    		calculateListSheet.SetRowBackColor(8, '#dcdcdc');
    		calculateListSheet.SetFrozenRows(8);
    		calculateListSheet.SetCellFontBold(8, 0, 1);
    		calculateListSheet.SetCellFontBold(8, 1, 1);
    		calculateListSheet.SetCellFontBold(8, 2, 1);
	    	
	    	// 정산여부 : 고정급
			if ('${calculateYn}' == 'N') {
				calculateListSheet.RowDelete(7);
				calculateListSheet.RowDelete(6);
				calculateListSheet.RowDelete(8);
			}
    	}
    }
	
	function doSearch() {
		getList();
	}
	
	function getList() {
		if ($('#dateFrom').val() == '') {
			alert('정산월을 선택해 주세요.');
			
			return;
		}
		
		var period = new Date($('#dateFrom').val().substring(0, 4), $('#dateFrom').val().substring(5, 7) - 1);
		var dateFrom = String(period.getFullYear()) + String(period.getMonth() + 1 < 10 ? '0' + String(period.getMonth() + 1) : String(period.getMonth() + 1)) + '01';
		var dateTo = String(period.getFullYear()) + String(period.getMonth() + 1 < 10 ? '0' + String(period.getMonth() + 1) : String(period.getMonth() + 1)) + '31';
		
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectPrvtCalculationList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				dateFrom : dateFrom
				, dateTo : dateTo
			}
			, async : true
			, spinner : true
			, success : function(data){
				calculateListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}
	
	function calculateListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('calculateListSheet', row);
	}
</script>