<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="downloadIbSheetExcel(calculateListSheet, '전문가 정산', '');" class="btn_sm btn_primary">엑셀 다운</button>
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
						<button type="button" onclick="setDefaultPickerValue('dateFrom');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>
				</td>
				<th scope="row">기간비교</th>
				<td>
					<label class="label_form">
						<input type="radio" name="compareYn" value="N" class="form_radio" title="미포함" checked />
						<span class="label">미포함</span>
					</label>
					<label class="label_form">
						<input type="radio" name="compareYn" value="Y" class="form_radio" title="이전기간 포함" />
						<span class="label">이전기간 포함</span>
					</label>
				</td>
            </tr>
            <tr>
				<th scope="row">전문가</th>
				<td>
					<select id="searchExpertId" name="searchExpertId" class="form_select" title="전문가">
						<option value="">전체</option>
						<c:forEach var="list" items="${expertList}" varStatus="status">
							<option value="${list.expertId}">${list.expertNm}</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">상담분야</th>
				<td>
					<select id="searchConsultTypeCd" name="searchConsultTypeCd" class="form_select" title="상담분야">
						<option value="">전체</option>
						<c:forEach var="list" items="${consultTypeList}" varStatus="status">
							<option value="${list.consultTypeCd}">${list.consultTypeNm}</option>
						</c:forEach>
					</select>
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
	ibHeader.addHeader({Header: '전문가|전문가|전문가', Type: 'Text', SaveName: 'expertNm', Width: 100, Align: 'Center', Edit: false});
	ibHeader.addHeader({Header: '상담분야|상담분야|상담분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 150, Align: 'Left', Edit: false});
	ibHeader.addHeader({Header: '기본수당|기본수당|기본수당', Type: 'Int', SaveName: 'baseSalary', Width: 100, Align: 'Right', Format: '#,##0', Edit: false});

	var colHidden = false;

	for (var i = 1 ; i <= 3 ; i++){
		if( i > 1){	colHidden = true; }
		ibHeader.addHeader({Header: 'resultDate' + i + '|1:1상담|상담건수', 	Type: 'AutoSum', 	SaveName: 'consultTypeCntAllPer' + i, 	Width: 100, Align: 'Right', Format: '#,##0', 	Edit: false, Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|1:1상담|일지등록',		Type: 'AutoSum', 	SaveName: 'consultTypeCntPer' + i, 		Width: 100, Align: 'Right', Format: '#,##0', 	Edit: false, Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|1:1상담|금액', 		Type: 'AutoSum', 	SaveName: 'salaryPer' + i, 				Width: 100, Align: 'Right', Format: '#,##0', 	Edit: false, Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|1:1상담|평점', 		Type: 'Text', 		SaveName: 'ratingScorePer' + i, 		Width: 100, Align: 'Right', 					Edit: false, Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|1:1상담|계수', 		Type: 'Float', 		SaveName: 'ratingScoreFactorPer' + i, 	Width: 100, Align: 'Right', Format: '##0.00', 	Edit: false, Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|1:1상담|보정금액', 	Type: 'AutoSum', 	SaveName: 'adjustSalaryPer' + i, 		Width: 100, Align: 'Right', Format: '#,##0', 	Edit: false, Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|오픈상담|답변건수', 	Type: 'AutoSum', 	SaveName: 'openCntPer' + i, 			Width: 100, Align: 'Right', Format: '#,##0', 	Edit: false, Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|오픈상담|금액', 		Type: 'AutoSum', 	SaveName: 'openSalaryPer' + i, 			Width: 100, Align: 'Right', Format: '#,##0', 	Edit: false, Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|총금액|총금액', 		Type: 'AutoSum', 	SaveName: 'totalSalaryPer' + i, 		Width: 100, Align: 'Right', Format: '#,##0', 	Edit: false, Hidden: colHidden});
	}

	ibHeader.setConfig({AutoFitColWidth: 'init', SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, MergeSheet: 5, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, ColMove: true});

	var gridPeriod1 = '';
	var gridPeriod2 = '';
	var gridPeriod3 = '';

	$(document).ready(function(){
		$('#dateFrom').datepicker('destroy');
		$('#dateFrom').monthpicker({
			pattern : 'yyyy-mm'
			, monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
		});

		var container = $('#calculateList')[0];
		createIBSheet2(container, 'calculateListSheet', '100%', '610px');
		ibHeader.initSheet('calculateListSheet');
		calculateListSheet.SetSelectionMode(4);
		
		// 편집모드 OFF
		calculateListSheet.SetEditable(0);

		getList();
	});

	function doSearch() {
		getList();
	}

	function getList() {
		var period1;
		var period2;
		var period3;
		var dateFrom;
		var dateTo;
		var jsonParam = {};

		if ($('#dateFrom').val() == '') {
			alert('정산월을 선택해 주세요.');

			return;
		}

		period1 = new Date($('#dateFrom').val().substring(0, 4), $('#dateFrom').val().substring(5, 7) - 1);

		period2 = new Date($('#dateFrom').val().substring(0, 4), $('#dateFrom').val().substring(5, 7) - 1);
		period2.setMonth(period2.getMonth() - 1);

		period3 = new Date($('#dateFrom').val().substring(0, 4), $('#dateFrom').val().substring(5, 7) - 1);
		period3.setMonth(period1.getMonth() - 2);

		dateFrom = String(period3.getFullYear()) + String(period3.getMonth() + 1 < 10 ? '0' + String(period3.getMonth() + 1) : String(period3.getMonth() + 1)) + '01';
		dateTo = String(period1.getFullYear()) + String(period1.getMonth() + 1 < 10 ? '0' + String(period1.getMonth() + 1) : String(period1.getMonth() + 1)) + '31';

		jsonParam['period1'] = getFormatFromDate(period1, '').substring(0, 6);
		jsonParam['period2'] = getFormatFromDate(period2, '').substring(0, 6);
		jsonParam['period3'] = getFormatFromDate(period3, '').substring(0, 6);
		jsonParam['dateFrom'] = dateFrom;
		jsonParam['dateTo'] = dateTo;

		gridPeriod1 = jsonParam['period1'].substring(0, 4) + '-' + jsonParam['period1'].substring(4, 6);
		gridPeriod2 = jsonParam['period2'].substring(0, 4) + '-' + jsonParam['period2'].substring(4, 6);
		gridPeriod3 = jsonParam['period3'].substring(0, 4) + '-' + jsonParam['period3'].substring(4, 6);

		if ($('#searchExpertId').val() != '') {
			jsonParam['searchExpertId'] = $('#searchExpertId').val();
		}

		if ($('#searchConsultTypeCd').val() != '') {
			jsonParam['searchConsultTypeCd'] = $('#searchConsultTypeCd').val();
		}

		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectExpertConsultCalculateList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				period1 : jsonParam['period1']
				, period2 : jsonParam['period2']
				, period3 : jsonParam['period3']
				, dateFrom : jsonParam['dateFrom']
				, dateTo : jsonParam['dateTo']
				, searchExpertId : jsonParam['searchExpertId']
				, searchConsultTypeCd : jsonParam['searchConsultTypeCd']
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

	function calculateListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('calculateListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 컬럼 3개 고정
    		calculateListSheet.SetFrozenCol(3);
    		// 썸 첫번째 컬럼에 합계 글자 표시
    		calculateListSheet.SetSumText(0, '합계');

    		calculateListSheet.SetCellValue(0, 'consultTypeCntAllPer1', gridPeriod1);
    		calculateListSheet.SetCellValue(0, 'consultTypeCntPer1', gridPeriod1);
    		calculateListSheet.SetCellValue(0, 'salaryPer1', gridPeriod1);
    		calculateListSheet.SetCellValue(0, 'ratingScorePer1', gridPeriod1);
    		calculateListSheet.SetCellValue(0, 'ratingScoreFactorPer1', gridPeriod1);
    		calculateListSheet.SetCellValue(0, 'adjustSalaryPer1', gridPeriod1);
    		calculateListSheet.SetCellValue(0, 'openCntPer1', gridPeriod1);
    		calculateListSheet.SetCellValue(0, 'openSalaryPer1', gridPeriod1);
    		calculateListSheet.SetCellValue(0, 'totalSalaryPer1', gridPeriod1);

    		calculateListSheet.SetCellValue(0, 'consultTypeCntAllPer2', gridPeriod2);
    		calculateListSheet.SetCellValue(0, 'consultTypeCntPer2', gridPeriod2);
    		calculateListSheet.SetCellValue(0, 'salaryPer2', gridPeriod2);
    		calculateListSheet.SetCellValue(0, 'ratingScorePer2', gridPeriod2);
    		calculateListSheet.SetCellValue(0, 'ratingScoreFactorPer2', gridPeriod2);
    		calculateListSheet.SetCellValue(0, 'adjustSalaryPer2', gridPeriod2);
    		calculateListSheet.SetCellValue(0, 'openCntPer2', gridPeriod2);
    		calculateListSheet.SetCellValue(0, 'openSalaryPer2', gridPeriod2);
    		calculateListSheet.SetCellValue(0, 'totalSalaryPer2', gridPeriod2);

    		calculateListSheet.SetCellValue(0, 'consultTypeCntAllPer3', gridPeriod3);
    		calculateListSheet.SetCellValue(0, 'consultTypeCntPer3', gridPeriod3);
    		calculateListSheet.SetCellValue(0, 'salaryPer3', gridPeriod3);
    		calculateListSheet.SetCellValue(0, 'ratingScorePer3', gridPeriod3);
    		calculateListSheet.SetCellValue(0, 'ratingScoreFactorPer3', gridPeriod3);
    		calculateListSheet.SetCellValue(0, 'adjustSalaryPer3', gridPeriod3);
    		calculateListSheet.SetCellValue(0, 'openCntPer3', gridPeriod3);
    		calculateListSheet.SetCellValue(0, 'openSalaryPer3', gridPeriod3);
    		calculateListSheet.SetCellValue(0, 'totalSalaryPer3', gridPeriod3);

    		if( $('input:radio[name="compareYn"]:checked').val() == 'Y' ){
    			calculateListSheet.SetColHidden('consultTypeCntAllPer2', false);
        		calculateListSheet.SetColHidden('consultTypeCntPer2', false);
        		calculateListSheet.SetColHidden('salaryPer2', false);
        		calculateListSheet.SetColHidden('ratingScorePer2', false);
        		calculateListSheet.SetColHidden('ratingScoreFactorPer2', false);
        		calculateListSheet.SetColHidden('adjustSalaryPer2', false);
        		calculateListSheet.SetColHidden('openCntPer2', false);
        		calculateListSheet.SetColHidden('openSalaryPer2', false);
        		calculateListSheet.SetColHidden('totalSalaryPer2', false);

        		calculateListSheet.SetColHidden('consultTypeCntAllPer3', false);
        		calculateListSheet.SetColHidden('consultTypeCntPer3', false);
        		calculateListSheet.SetColHidden('salaryPer3', false);
        		calculateListSheet.SetColHidden('ratingScorePer3', false);
        		calculateListSheet.SetColHidden('ratingScoreFactorPer3', false);
        		calculateListSheet.SetColHidden('adjustSalaryPer3', false);
        		calculateListSheet.SetColHidden('openCntPer3', false);
        		calculateListSheet.SetColHidden('openSalaryPer3', false);
        		calculateListSheet.SetColHidden('totalSalaryPer3', false);

        		calculateListSheet.SetColWidth('consultTypeCntAllPer1', 100);
        		calculateListSheet.SetColWidth('consultTypeCntPer1', 100);
        		calculateListSheet.SetColWidth('salaryPer1', 100);
        		calculateListSheet.SetColWidth('ratingScorePer1', 100);
        		calculateListSheet.SetColWidth('ratingScoreFactorPer1', 100);
        		calculateListSheet.SetColWidth('adjustSalaryPer1', 100);
        		calculateListSheet.SetColWidth('openCntPer1', 100);
        		calculateListSheet.SetColWidth('openSalaryPer1', 100);
        		calculateListSheet.SetColWidth('totalSalaryPer1', 100);

        		calculateListSheet.SetColWidth('consultTypeCntAllPer2', 100);
        		calculateListSheet.SetColWidth('consultTypeCntPer2', 100);
        		calculateListSheet.SetColWidth('salaryPer2', 100);
        		calculateListSheet.SetColWidth('ratingScorePer2', 100);
        		calculateListSheet.SetColWidth('ratingScoreFactorPer2', 100);
        		calculateListSheet.SetColWidth('adjustSalaryPer2', 100);
        		calculateListSheet.SetColWidth('openCntPer2', 100);
        		calculateListSheet.SetColWidth('openSalaryPer2', 100);
        		calculateListSheet.SetColWidth('totalSalaryPer2', 100);

        		calculateListSheet.SetColWidth('consultTypeCntAllPer3', 100);
        		calculateListSheet.SetColWidth('consultTypeCntPer3', 100);
        		calculateListSheet.SetColWidth('salaryPer3', 100);
        		calculateListSheet.SetColWidth('ratingScorePer3', 100);
        		calculateListSheet.SetColWidth('ratingScoreFactorPer3', 100);
        		calculateListSheet.SetColWidth('adjustSalaryPer3', 100);
        		calculateListSheet.SetColWidth('openCntPer3', 100);
        		calculateListSheet.SetColWidth('openSalaryPer3', 100);
        		calculateListSheet.SetColWidth('totalSalaryPer3', 100);

    		}else {
    			calculateListSheet.SetColHidden('consultTypeCntAllPer2', true);
        		calculateListSheet.SetColHidden('consultTypeCntPer2', true);
        		calculateListSheet.SetColHidden('salaryPer2', true);
        		calculateListSheet.SetColHidden('ratingScorePer2', true);
        		calculateListSheet.SetColHidden('ratingScoreFactorPer2', true);
        		calculateListSheet.SetColHidden('adjustSalaryPer2', true);
        		calculateListSheet.SetColHidden('openCntPer2', true);
        		calculateListSheet.SetColHidden('openSalaryPer2', true);
        		calculateListSheet.SetColHidden('totalSalaryPer2', true);

        		calculateListSheet.SetColHidden('consultTypeCntAllPer3', true);
        		calculateListSheet.SetColHidden('consultTypeCntPer3', true);
        		calculateListSheet.SetColHidden('salaryPer3', true);
        		calculateListSheet.SetColHidden('ratingScorePer3', true);
        		calculateListSheet.SetColHidden('ratingScoreFactorPer3', true);
        		calculateListSheet.SetColHidden('adjustSalaryPer3', true);
        		calculateListSheet.SetColHidden('openCntPer3', true);
        		calculateListSheet.SetColHidden('openSalaryPer3', true);
        		calculateListSheet.SetColHidden('totalSalaryPer3', true);
        		calculateListSheet.FitColWidth();

    		}
    	}
    }

	function setDefaultPickerValue(objId) {
		$('#' + objId).val('${lastMonth}');
	}
</script>