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
		<button type="button" onclick="downloadIbSheetExcel(evaluateListSheet, '전문가 평가', '');" class="btn_sm btn_primary">엑셀 다운</button>
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
				<th scope="row">평가 기준 기간</th>
				<td>
					<select id="searchTerm" name="searchTerm" onchange="changeSearchTerm();" class="form_select" title="평가 기준 단위">
						<option value="month">월</option>
						<option value="quarter">분기</option>
						<option value="year">연도</option>
					</select>
					<div class="datepicker_box" style="display: inline-block;">
						<span class="form_datepicker">
							<input type="text" id="dateFrom" name="dateFrom" value="${lastMonth}" class="txt monthpicker" placeholder="검색월" title="검색월" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('dateFrom');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
						</span>
						<button type="button" onclick="setDefaultPickerValue('dateFrom');" class="dateClear" style="padding-bottom: 5px;"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>
					<c:set var="now" value="<%=new java.util.Date()%>" />
					<c:set var="year"><fmt:formatDate value="${now}" pattern="yyyy" /></c:set>
					<select id="searchDateYear" name="searchDateYear" class="form_select" style="display: none;">
						<c:forEach var="i" begin="0" end="5" step="1">
							<option value="${year - i}">${year - i}</option>
						</c:forEach>
					</select>
					<select id="searchQuarter" name="searchQuarter" class="form_select" style="display: none;">
						<option value="1">1분기</option>
						<option value="2">2분기</option>
						<option value="3">3분기</option>
						<option value="4">4분기</option>
					</select>
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
		<div id="evaluateList" class="sheet"></div>
	</div>
</div>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '전문가|전문가|전문가', Type: 'Text', SaveName: 'expertNm', Width: 100, Align: 'Center', Edit: false});
	ibHeader.addHeader({Header: '상담분야|상담분야|상담분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 150, Align: 'Left', Edit: false});

	var colHidden = false;

	for (var i = 1 ; i <= 3 ; i++){
		if( i > 1){	colHidden = true; }
		ibHeader.addHeader({Header: 'resultDate' + i + '|1:1상담|등록시간', 	Type: 'Int', 		SaveName: 'scheduleHoursPer' + i, 	Width: 100, Align: 'Right', Format: '#,##0', 	Edit: false, 	Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|1:1상담|상담건수', 	Type: 'AutoSum', 	SaveName: 'consultCntPer' + i, 		Width: 100, Align: 'Right', Format: '#,##0', 	Edit: false, 	Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|1:1상담|취소건수', 	Type: 'AutoSum', 	SaveName: 'cancelCntPer' + i, 		Width: 100, Align: 'Right', Format: '#,##0', 	Edit: false, 	Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|1:1상담|평점', 		Type: 'Float', 		SaveName: 'ratingScorePer' + i, 	Width: 100, Align: 'Right', Format: '#,##0.00', Edit: false, 	Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|오픈상담|답변건수', 	Type: 'AutoSum', 	SaveName: 'openCntPer' + i, 		Width: 100, Align: 'Right', Format: '#,##0', 	Edit: false, 	Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|오픈상담|추천건수', 	Type: 'AutoSum', 	SaveName: 'openRcmdCntPer' + i, 	Width: 100, Align: 'Right', Format: '#,##0', 	Edit: false, 	Hidden: colHidden});
		ibHeader.addHeader({Header: 'resultDate' + i + '|오픈상담|평점', 		Type: 'Float', 		SaveName: 'openRatingScorePer' + i, Width: 100, Align: 'Right', Format: '#,##0.00', Edit: false, 	Hidden: colHidden});
	}

	ibHeader.setConfig({AutoFitColWidth: 'init', SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, MergeSheet: 5, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, ColMove: true});

	var gridPeriod1 = '';
	var gridPeriod2 = '';
	var gridPeriod3 = '';

	$(document).ready(function() {
		$('#dateFrom').datepicker('destroy');
		$('#dateFrom').monthpicker({
			pattern : 'yyyy-mm'
			, monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
		});

		changeSearchTerm();

		var container = $('#evaluateList')[0];
		createIBSheet2(container, 'evaluateListSheet', '100%', '600px');
		ibHeader.initSheet('evaluateListSheet');
		evaluateListSheet.SetSelectionMode(4);
		
		// 편집모드 OFF
		evaluateListSheet.SetEditable(0);

		getList();
	});

	function changeSearchTerm() {
		if ($('#searchTerm').val() == 'month') {
			$('.datepicker_box').show();
			$('#searchDateYear').hide();
			$('#searchQuarter').hide();
		} else if ($('#searchTerm').val() == 'quarter') {
			$('.datepicker_box').hide();
			$('#searchDateYear').show();
			$('#searchQuarter').show();
		} else if ($('#searchTerm').val() == 'year') {
			$('.datepicker_box').hide();
			$('#searchDateYear').show();
			$('#searchQuarter').hide();
		}
	}

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

		if ($('#searchTerm').val() == 'month') {
			if ($('#dateFrom').val() == '') {
				alert('월을 선택해 주세요.');

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
			jsonParam['searchTerm'] = $('#searchTerm').val();

			gridPeriod1 = jsonParam['period1'].substring(0, 4) + '-' + jsonParam['period1'].substring(4, 6);
			gridPeriod2 = jsonParam['period2'].substring(0, 4) + '-' + jsonParam['period2'].substring(4, 6);
			gridPeriod3 = jsonParam['period3'].substring(0, 4) + '-' + jsonParam['period3'].substring(4, 6);
		} else if ($('#searchTerm').val() == 'year') {
			period1 = new Date($('#searchDateYear').val());

			period2 = new Date($('#searchDateYear').val());
			period2.setFullYear(period2.getFullYear() - 1);

			period3 = new Date($('#searchDateYear').val());
			period3.setFullYear(period1.getFullYear() - 2);

			dateFrom = String(period3.getFullYear()) + '0101';
			dateTo = String(period1.getFullYear()) + '1231';

			jsonParam['period1'] = getFormatFromDate(period1, '').substring(0, 4);
			jsonParam['period2'] = getFormatFromDate(period2, '').substring(0, 4);
			jsonParam['period3'] = getFormatFromDate(period3, '').substring(0, 4);
			jsonParam['dateFrom'] = dateFrom;
			jsonParam['dateTo'] = dateTo;
			jsonParam['searchTerm'] = $('#searchTerm').val();

			gridPeriod1 = jsonParam['period1'];
			gridPeriod2 = jsonParam['period2'];
			gridPeriod3 = jsonParam['period3'];
		} else if ($('#searchTerm').val() == 'quarter') {
			var selectedYear = $('#searchDateYear').val();
			var selectedPeriod = $('#searchQuarter').val();

			period1 = $('#searchDateYear').val() + String(selectedPeriod);

			if (selectedPeriod == 1) {
				selectedPeriod = 4;
				selectedYear--;
			} else {
				selectedPeriod--;
			}

			period2 = String(selectedYear) + String(selectedPeriod);

			if (selectedPeriod == 1) {
				selectedPeriod = 4;
				selectedYear--;
			} else {
				selectedPeriod--;
			}

			period3 = String(selectedYear) + String(selectedPeriod);

			dateFrom = period3.substring(0, 4) + (period3.substring(4, 5) < 4 ? '0' + String(period3.substring(4, 5) * 3 - 2) : String(period3.substring(4, 5) * 3 - 2)) + '01';
			dateTo = period1.substring(0, 4) + (period1.substring(4, 5) < 4 ? '0' + String(period1.substring(4, 5) * 3) : String(period1.substring(4, 5) * 3)) + '31';

			jsonParam['period1'] = period1;
			jsonParam['period2'] = period2;
			jsonParam['period3'] = period3;
			jsonParam['dateFrom'] = dateFrom;
			jsonParam['dateTo'] = dateTo;
			jsonParam['searchTerm'] = $('#searchTerm').val();

			gridPeriod1 = jsonParam['period1'].substring(0, 4) + '.' + jsonParam['period1'].substring(4, 5) + '분기';
			gridPeriod2 = jsonParam['period2'].substring(0, 4) + '.' + jsonParam['period2'].substring(4, 5) + '분기';
			gridPeriod3 = jsonParam['period3'].substring(0, 4) + '.' + jsonParam['period3'].substring(4, 5) + '분기';
		}

		if ($('#searchExpertId').val() != '') {
			jsonParam['searchExpertId'] = $('#searchExpertId').val();
		}

		if ($('#searchConsultTypeCd').val() != '') {
			jsonParam['searchConsultTypeCd'] = $('#searchConsultTypeCd').val();
		}

		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectExpertConsultRatingReportList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				period1 : jsonParam['period1']
				, period2 : jsonParam['period2']
				, period3 : jsonParam['period3']
				, dateFrom : jsonParam['dateFrom']
				, dateTo : jsonParam['dateTo']
				, searchTerm : jsonParam['searchTerm']
				, searchExpertId : jsonParam['searchExpertId']
				, searchConsultTypeCd : jsonParam['searchConsultTypeCd']
			}
			, async : true
			, spinner : true
			, success : function(data){
				evaluateListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function evaluateListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('evaluateListSheet', row);
	}

	function evaluateListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('evaluateListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 컬럼 2개 고정
    		evaluateListSheet.SetFrozenCol(2);
    		// 썸 첫번째 컬럼에 합계 글자 표시
    		evaluateListSheet.SetSumText(0, '합계');

    		evaluateListSheet.SetCellValue(0, 'scheduleHoursPer1', gridPeriod1);
    		evaluateListSheet.SetCellValue(0, 'consultCntPer1', gridPeriod1);
    		evaluateListSheet.SetCellValue(0, 'cancelCntPer1', gridPeriod1);
    		evaluateListSheet.SetCellValue(0, 'ratingScorePer1', gridPeriod1);
    		evaluateListSheet.SetCellValue(0, 'openCntPer1', gridPeriod1);
    		evaluateListSheet.SetCellValue(0, 'openRcmdCntPer1', gridPeriod1);
    		evaluateListSheet.SetCellValue(0, 'openRatingScorePer1', gridPeriod1);

    		evaluateListSheet.SetCellValue(0, 'scheduleHoursPer2', gridPeriod2);
    		evaluateListSheet.SetCellValue(0, 'consultCntPer2', gridPeriod2);
    		evaluateListSheet.SetCellValue(0, 'cancelCntPer2', gridPeriod2);
    		evaluateListSheet.SetCellValue(0, 'ratingScorePer2', gridPeriod2);
    		evaluateListSheet.SetCellValue(0, 'openCntPer2', gridPeriod2);
    		evaluateListSheet.SetCellValue(0, 'openRcmdCntPer2', gridPeriod2);
    		evaluateListSheet.SetCellValue(0, 'openRatingScorePer2', gridPeriod2);

    		evaluateListSheet.SetCellValue(0, 'scheduleHoursPer3', gridPeriod3);
    		evaluateListSheet.SetCellValue(0, 'consultCntPer3', gridPeriod3);
    		evaluateListSheet.SetCellValue(0, 'cancelCntPer3', gridPeriod3);
    		evaluateListSheet.SetCellValue(0, 'ratingScorePer3', gridPeriod3);
    		evaluateListSheet.SetCellValue(0, 'openCntPer3', gridPeriod3);
    		evaluateListSheet.SetCellValue(0, 'openRcmdCntPer3', gridPeriod3);
    		evaluateListSheet.SetCellValue(0, 'openRatingScorePer3', gridPeriod3);

    		if( $('input:radio[name="compareYn"]:checked').val() == 'Y' ){
    			evaluateListSheet.SetColHidden('scheduleHoursPer2', false);
        		evaluateListSheet.SetColHidden('consultCntPer2', false);
        		evaluateListSheet.SetColHidden('cancelCntPer2', false);
        		evaluateListSheet.SetColHidden('ratingScorePer2', false);
        		evaluateListSheet.SetColHidden('openCntPer2', false);
        		evaluateListSheet.SetColHidden('openRcmdCntPer2', false);
        		evaluateListSheet.SetColHidden('openRatingScorePer2', false);

        		evaluateListSheet.SetColHidden('scheduleHoursPer3', false);
        		evaluateListSheet.SetColHidden('consultCntPer3', false);
        		evaluateListSheet.SetColHidden('cancelCntPer3', false);
        		evaluateListSheet.SetColHidden('ratingScorePer3', false);
        		evaluateListSheet.SetColHidden('openCntPer3', false);
        		evaluateListSheet.SetColHidden('openRcmdCntPer3', false);
        		evaluateListSheet.SetColHidden('openRatingScorePer3', false);

        		evaluateListSheet.SetColWidth('scheduleHoursPer1',100);
        		evaluateListSheet.SetColWidth('consultCntPer1',100);
        		evaluateListSheet.SetColWidth('cancelCntPer1',100);
        		evaluateListSheet.SetColWidth('ratingScorePer1',100);
        		evaluateListSheet.SetColWidth('openCntPer1',100);
        		evaluateListSheet.SetColWidth('openRcmdCntPer1',100);
        		evaluateListSheet.SetColWidth('openRatingScorePer1',100);

        		evaluateListSheet.SetColWidth('scheduleHoursPer2',100);
        		evaluateListSheet.SetColWidth('consultCntPer2',100);
        		evaluateListSheet.SetColWidth('cancelCntPer2',100);
        		evaluateListSheet.SetColWidth('ratingScorePer2',100);
        		evaluateListSheet.SetColWidth('openCntPer2',100);
        		evaluateListSheet.SetColWidth('openRcmdCntPer2',100);
        		evaluateListSheet.SetColWidth('openRatingScorePer2',100);

        		evaluateListSheet.SetColWidth('scheduleHoursPer3',100);
        		evaluateListSheet.SetColWidth('consultCntPer3',100);
        		evaluateListSheet.SetColWidth('cancelCntPer3',100);
        		evaluateListSheet.SetColWidth('ratingScorePer3',100);
        		evaluateListSheet.SetColWidth('openCntPer3',100);
        		evaluateListSheet.SetColWidth('openRcmdCntPer3',100);
        		evaluateListSheet.SetColWidth('openRatingScorePer3',100);
    		}else {
    			evaluateListSheet.SetColHidden('scheduleHoursPer2', true);
        		evaluateListSheet.SetColHidden('consultCntPer2', true);
        		evaluateListSheet.SetColHidden('cancelCntPer2', true);
        		evaluateListSheet.SetColHidden('ratingScorePer2', true);
        		evaluateListSheet.SetColHidden('openCntPer2', true);
        		evaluateListSheet.SetColHidden('openRcmdCntPer2', true);
        		evaluateListSheet.SetColHidden('openRatingScorePer2', true);

        		evaluateListSheet.SetColHidden('scheduleHoursPer3', true);
        		evaluateListSheet.SetColHidden('consultCntPer3', true);
        		evaluateListSheet.SetColHidden('cancelCntPer3', true);
        		evaluateListSheet.SetColHidden('ratingScorePer3', true);
        		evaluateListSheet.SetColHidden('openCntPer3', true);
        		evaluateListSheet.SetColHidden('openRcmdCntPer3', true);
        		evaluateListSheet.SetColHidden('openRatingScorePer3', true);
    			evaluateListSheet.FitColWidth();
    		}

    	}
    }

	function setDefaultPickerValue(objId) {
		$('#' + objId).val('${lastMonth}');
	}
</script>