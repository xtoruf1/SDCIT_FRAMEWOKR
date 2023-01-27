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
		<button type="button" onclick="doExcelIBSheetDownload();" class="btn_sm btn_primary">엑셀 다운</button>
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
				<th scope="row">주간</th>
				<td colspan="3">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchFromDate" name="searchFromDate" value="" class="txt datepickerWeek" style="width: 90px;cursor: pointer;" placeholder="시작일" title="시작일" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<!--
							꼭 날짜가 있어야 하기 때문에 초기화를 주석 처리한다.
							<button type="button" onclick="clearPickerValue('searchFromDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							-->
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchToDate" name="searchToDate" value="" class="txt datepickerWeek" style="width: 90px;cursor: pointer;" placeholder="종료일" title="종료일" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<!--
							<button type="button" onclick="clearPickerValue('searchToDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							-->
						</div>
					</div>
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
		<div id="scheduleList" class="sheet"></div>
	</div>
</div>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '전문가', Type: 'Text', SaveName: 'expertNm', Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '상담분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 150, Align: 'Left'});
	ibHeader.addHeader({Header: '등록 시간', Type: 'Text', SaveName: 'scheduleHours', Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '상담 시간', Type: 'Text', SaveName: 'rsrvHours', Width: 100, Align: 'Center'});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', MergeSheet: 2, Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	$(document).ready(function(){
		var container = $('#scheduleList')[0];
		createIBSheet2(container, 'scheduleListSheet', '100%', '550px');
		ibHeader.initSheet('scheduleListSheet');
		scheduleListSheet.SetSelectionMode(4);

		// 편집모드 OFF
		scheduleListSheet.SetEditable(0);

		$('.datepickerWeek').datepicker('destroy');
		$('.datepickerWeek').datepicker({
			dateFormat : 'yy-mm-dd'
			, showMonthAfterYear : true
			// , yearSuffix : '년'
			, dayNamesMin : ['일', '월', '화', '수', '목', '금', '토']
			, monthNamesShort : ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
			, monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
			, showOn : 'both'
			, changeYear : true
			, changeMonth : true
			, yearRange : 'c-90:c+20'
			, beforeShow : function(date){
				setTimeout(function(){
					$('#ui-datepicker-div').find('.ui-state-active').removeClass('ui-state-active');
					$('.ui-datepicker-calendar tr').each(function(){
						$(this).find('a').removeClass('ui-state-highlight');

						if ($(this).parent().get(0).tagName == 'TBODY') {
							$(this).mouseover(function(){
								$(this).find('a').css('background', '#ffffcc');
							});
							$(this).mouseout(function(){
								$(this).find('a').css('background', '');
							});
						}
					});
				}, 100);

				return [true, '', ''];
			}
			, onSelect : function(dateString) {
				$('label[for="all"]').css('background', '#fff');
				$('label[for="commCode_01"]').css('background', '#fff');
				$('label[for="commCode_02"]').css('background', '#fff');

				var selectDate = new Date(dateString);

				var year = '';
				var month = '';
				var day = '';

				selectDate.setDate(selectDate.getDate() - selectDate.getDay());

				year = selectDate.getFullYear();
		    	month = selectDate.getMonth() + 1;
		    	month = (month < 10) ? '0' + month : month;
		    	day = selectDate.getDate();
		    	day = (day < 10) ? '0' + day : day;

		    	var fromDate = '' + year + '-' +  month  + '-' + day;

		        $('#searchFromDate').val(fromDate);

				selectDate.setDate(selectDate.getDate() + 6);

				year = selectDate.getFullYear();
		    	month = selectDate.getMonth() + 1;
		    	month = (month < 10) ? '0' + month : month;
		    	day = selectDate.getDate();
		    	day = (day < 10) ? '0' + day : day;

		    	var toDate = '' + year + '-' +  month  + '-' + day;

		    	$('#searchToDate').val(toDate);
			}
			, onClose : function(dateText, dateObj){
				$(':focus').blur();
			}
		}).next('button').button({
			icons : {
				primary : 'ui-icon-calendar'
			}
			, text : false
		});

		var defaultDate = new Date();

		var year = '';
		var month = '';
		var day = '';

        defaultDate.setDate((defaultDate.getDate() - 7) - defaultDate.getDay());

        year = defaultDate.getFullYear();
    	month = defaultDate.getMonth() + 1;
    	month = (month < 10) ? '0' + month : month;
    	day = defaultDate.getDate();
    	day = (day < 10) ? '0' + day : day;

    	var fromDate = '' + year + '-' +  month  + '-' + day;

        $('#searchFromDate').val(fromDate);

        defaultDate.setDate(defaultDate.getDate() + 6);

        year = defaultDate.getFullYear();
    	month = defaultDate.getMonth() + 1;
    	month = (month < 10) ? '0' + month : month;
    	day = defaultDate.getDate();
    	day = (day < 10) ? '0' + day : day;

    	var toDate = '' + year + '-' +  month  + '-' + day;

		$('#searchToDate').val(toDate);

        getList();
	});

	function doSearch() {
		getList();
	}

	function getList() {
		if ($('#searchFromDate').val() == '' || $('#searchToDate').val() == '') {
			alert('주간 날짜를 선택해 주세요.');

			return;
		}

		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectExpertConsultScheduleReportList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				searchFromDate : $('#searchFromDate').val().replace(/-/g, '')
				, searchToDate : $('#searchToDate').val().replace(/-/g, '')
				, searchExpertId : $('#searchExpertId').val()
				, searchConsultTypeCd : $('#searchConsultTypeCd').val()
			}
			, async : true
			, spinner : true
			, success : function(data){
				scheduleListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function scheduleListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('scheduleListSheet', row);
	}

	function doExcelIBSheetDownload() {
		downloadIbSheetExcel(scheduleListSheet, '주간스케줄등록현황', '');
	}
</script>