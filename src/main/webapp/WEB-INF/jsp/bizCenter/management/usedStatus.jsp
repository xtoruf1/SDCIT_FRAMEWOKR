<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="btnGroup ml-auto">
		<button type="button" id="btnExcel" class="btn_sm btn_primary" onclick="doExcelDownload();">엑셀 다운</button>
		<button type="button" id="btnSearchReset" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" id="btnSave" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<div class="cont_block">
	<form id="frm" method="post">
		<input type="hidden" id="sStDate" name="sStDate" value="" />
		<input type="hidden" id="sEdDate" name="sEdDate" value="" />
		<div class="search">
			<table class="formTable">
				<colgroup>
					<col style="width:15%" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th>검색기준</th>
						<td>
							<div class="form_group">
								<label class="label_form">
									<input type="radio" class="form_radio" name="searchType" value="YEAR" checked />
									<span class="label">연간</span>
								</label>
								<label class="label_form">
									<input type="radio" class="form_radio" name="searchType" value="MONTH" />
									<span class="label">월간</span>
								</label>
								<label class="label_form">
									<input type="radio" class="form_radio" name="searchType" value="PERIOD" />
									<span class="label">기간</span>
								</label>
								<div id="sYearDiv" class="ml-30">
									<select id="sYear" name="sYear" class="form_select">
										<c:forEach var="list" items="${yearList}" varStatus="status">
										<option value="${list.searchYear}">${list.searchYear}</option>
										</c:forEach>
									</select>
								</div>
								<div id="sMonthDiv" class="datepicker_box ml-30 hidden">
									<span class="form_datepicker">
										<input type="text" id="sMonth" name="sMonth" value="${defaultVal.baseMonth}" class="txt monthpicker" title="월간검색" readonly="readonly" />
										<img src="/images/icon_calender.png" onclick="showMonthpicker('sMonth');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
									</span>
									<!-- clear 버튼 -->
									<button type="button" onclick="clearPickerValue('sMonth');" class="dateClear"><img src="/images/admin/btn_clear.png" alt="초기화" /></button>
								</div>
								<div id="sWeekDiv" class="group_datepicker ml-30 hidden">
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" id="sStWeek" name="sStWeek" value="${defaultVal.baseStWeek}" class="txt datepicker datepickerWeek" placeholder="시작일" title="시작일" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
									<div class="spacing">~</div>
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" id="sEdWeek" name="sEdWeek" value="${defaultVal.baseEdWeek}" class="txt datepicker datepickerWeek" placeholder="종료일" title="종료일" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
								</div>
								<div id="sPeriodDiv" class="group_datepicker ml-30 hidden">
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" id="sStPeriod" name="sStPeriod" value="${defaultVal.baseStPeriod}" class="txt datepicker" style="width: 110px;" placeholder="신청기간 시작" title="신청기간 시작" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
									<div class="spacing">~</div>
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" id="sEdPeriod" name="sEdPeriod" value="${defaultVal.baseEdPeriod}" class="txt datepicker" style="width: 110px;" placeholder="신청기간 종료" title="신청기간 종료" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
								</div>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
</div>

<div class="cont_block">
	<div class="tit_bar">
		<h3 class="tit_block">회의실 이용 현황</h3>
	</div>

	<div>
		<div id="sheetDiv1" class="sheet"></div>
	</div>
</div>


<div class="cont_block">
	<div class="tit_bar">
		<h3 class="tit_block">사무기기 이용 현황</h3>
	</div>
	<div>
		<div id="sheetDiv2" class="sheet"></div>
	</div>
</div>

<script type="text/javascript">

	var f;
	$(document).ready(function(){
		f = document.frm;
		$('input:radio[name="searchType"]').change( function() {
			$('#sMonthDiv').removeClass("hidden");
			$('#sWeekDiv').removeClass("hidden");
			$('#sPeriodDiv').removeClass("hidden");
			if( this.value == 'YEAR' ){
				$('#sYearDiv').show();
				$('#sMonthDiv').hide();
				$('#sWeekDiv').hide();
				$('#sPeriodDiv').hide();
			}else if( this.value == 'MONTH' ){
				$('#sYearDiv').hide();
				$('#sMonthDiv').show();
				$('#sWeekDiv').hide();
				$('#sPeriodDiv').hide();

			}else if( this.value == 'WEEK' ){
				$('#sYearDiv').hide();
				$('#sMonthDiv').hide();
				$('#sWeekDiv').show();
				$('#sPeriodDiv').hide();
			}else if( this.value == 'PERIOD' ){
				$('#sYearDiv').hide();
				$('#sMonthDiv').hide();
				$('#sWeekDiv').hide();
				$('#sPeriodDiv').show();
			}
		});


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

		        $('#sStWeek').val(fromDate);

				selectDate.setDate(selectDate.getDate() + 6);

				year = selectDate.getFullYear();
		    	month = selectDate.getMonth() + 1;
		    	month = (month < 10) ? '0' + month : month;
		    	day = selectDate.getDate();
		    	day = (day < 10) ? '0' + day : day;

		    	var toDate = '' + year + '-' +  month  + '-' + day;

		    	$('#sEdWeek').val(toDate);
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

		setSheetHeader_bizStatSheet1();
		setSheetHeader_bizStatSheet2();

		// 시작일 선택 이벤트
		datepickerById('sStPeriod', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('sEdPeriod', toDateSelectEvent);

		doSearch();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#sStPeriod').val());
		if ($('#sEdPeriod').val() != '') {
			if (startymd > Date.parse($('#sEdPeriod').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#sStPeriod').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#sEdPeriod').val());

		if ($('#sStPeriod').val() != '') {
			if (endymd < Date.parse($('#sStPeriod').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#sEdPeriod').val('');

				return;
			}
		}
	}

	function setSheetHeader_bizStatSheet1() {
		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '회의실규모|회의실규모'	, Type: 'Text'		, SaveName: 'roomType'		, Edit: false	, Width: 100	, Align: 'Center'});
		ibHeader.addHeader({Header: '이용건수|입주'			, Type: 'AutoSum'	, SaveName: 'rentalCnt'		, Edit: false	, Width: 80		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '이용건수|비입주'		, Type: 'AutoSum'	, SaveName: 'elseCnt'		, Edit: false	, Width: 80		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '이용건수|협회'			, Type: 'AutoSum'	, SaveName: 'kitaCnt'		, Edit: false	, Width: 80		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '이용건수|계'			, Type: 'AutoSum'	, SaveName: 'allCnt'		, Edit: false	, Width: 80		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '이용시간|입주'			, Type: 'AutoSum'	, SaveName: 'rentalTime'	, Edit: false	, Width: 80		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '이용시간|비입주'		, Type: 'AutoSum'	, SaveName: 'elseTime'		, Edit: false	, Width: 80		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '이용시간|협회'			, Type: 'AutoSum'	, SaveName: 'kitaTime'		, Edit: false	, Width: 80		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '이용시간|계'			, Type: 'AutoSum'	, SaveName: 'allTime'		, Edit: false	, Width: 80		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '업체|입주'			, Type: 'AutoSum'	, SaveName: 'rentalCorp'	, Edit: false	, Width: 80		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '업체|비입주'			, Type: 'AutoSum'	, SaveName: 'elseCorp'		, Edit: false	, Width: 80		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '업체|계'				, Type: 'AutoSum'	, SaveName: 'allCorp'		, Edit: false	, Width: 80		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '가용율|가용율'			, Type: 'Float'		, SaveName: 'useRate'		, Edit: false	, Width: 80		, Align: 'Right'	, Format: '#,##0.##\\%'});
		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
	        DeferredVScroll: 0,
	        colresize: true,
	        SelectionRowsMode: 4,
	        SearchMode: 2,
	        NoFocusMode : 0,
	        Alternate : 0,
	        Page: 10,
	        SizeMode: 1,
	        MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#sheetDiv1')[0];
		createIBSheet2(container, 'bizStatSheet1', '100%', '10%');
		ibHeader.initSheet('bizStatSheet1');
	}

	function setSheetHeader_bizStatSheet2() {	// 바우처 사용 현황 헤더
		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '회의실규모'	, Type: 'Text'			, SaveName: 'roomType'		, Edit: false	, Width: 100		, Align: 'Center'});
		ibHeader.addHeader({Header: '공용PC'		, Type: 'AutoSum'		, SaveName: 'pcCnt'			, Edit: false	, Width: 100		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '인쇄'		, Type: 'AutoSum'		, SaveName: 'printCnt'		, Edit: false	, Width: 100		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '라운지'		, Type: 'AutoSum'		, SaveName: 'loungeCnt'		, Edit: false	, Width: 100		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '스캔'		, Type: 'AutoSum'		, SaveName: 'scanCnt'		, Edit: false	, Width: 100		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '팩스'		, Type: 'AutoSum'		, SaveName: 'faxCnt'		, Edit: false	, Width: 100		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '화상'		, Type: 'AutoSum'		, SaveName: 'videoCnt'		, Edit: false	, Width: 100		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
	        DeferredVScroll: 0,
	        colresize: true,
	        SelectionRowsMode: 4,
	        SearchMode: 2,
	        NoFocusMode : 0,
	        Alternate : 0,
	        Page: 10,
	        SizeMode: 1,
	        MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#sheetDiv2')[0];
		createIBSheet2(container, 'bizStatSheet2', '100%', '10%');
		ibHeader.initSheet('bizStatSheet2');
	}

	var useRateAvg = '';

	function doSearch() {
		var searchParams = $('#frm').serializeObject();
		var stDate = '';
		var edDate = '';

		if( $('input:radio[name="searchType"]:checked').val() == 'YEAR' ){
			stDate = $('#sYear').val() + '0101';
			edDate = $('#sYear').val() + '1231';
		}else if( $('input:radio[name="searchType"]:checked').val() == 'MONTH' ){
			stDate = $('#sMonth').val().replace('-','') + '01';
			edDate = $('#sMonth').val().replace('-','') + new Date($('#sMonth').val().substr(0,4), $('#sMonth').val().substr(5,7), 0).getDate();
		}else if( $('input:radio[name="searchType"]:checked').val() == 'WEEK' ){
			stDate = $('#sStWeek').val().replace(/-/gi,'');
			edDate = $('#sEdWeek').val().replace(/-/gi,'');
		}else if( $('input:radio[name="searchType"]:checked').val() == 'PERIOD' ){
			stDate = $('#sStPeriod').val().replace(/-/gi,'');
			edDate = $('#sEdPeriod').val().replace(/-/gi,'');

			if( stDate == '' ){
				alert('검색 시작일을 입력하세요.');
				$('#sStPeriod').focus();
				return false;
			}else if( edDate == '' ){
				alert('검색 종료일을 입력하세요.');
				$('#sEdPeriod').focus();
				return false;
			}

			fromDateSelectEvent();
			toDateSelectEvent();
		}

		$('#sStDate').val(stDate);
		$('#sEdDate').val(edDate);

		global.ajax({
			type : 'POST'
			, url : "/bizCenter/management/selectUsedStatusList.do"
			, data : $('#frm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				bizStatSheet1.LoadSearchData({Data: (data.resultList || []) });
				useRateAvg = data.resultAvg+'%';
			}
		});
	}

	function doNextSearch() {

		global.ajax({
			type : 'POST'
			, url : "/bizCenter/management/selectUsedStatusRentalList.do"
			, data : $('#frm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				bizStatSheet2.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function bizStatSheet1_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('bizStatSheet1_OnSearchEnd : ', msg);
    	} else {
    		bizStatSheet1.SetCellValue(bizStatSheet1.LastRow(),'roomType','합계');
    		bizStatSheet1.SetCellValue(bizStatSheet1.LastRow(),'useRate',useRateAvg);
    	}
		doNextSearch();
    }

	function bizStatSheet2_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('bizStatSheet2_OnSearchEnd : ', msg);
    	} else {
    		bizStatSheet2.SetCellValue(bizStatSheet2.LastRow(),'roomType','합계');
    	}
    }


	function doClear() {	// 초기화
		location.reload();
	}

	function doExcelDownload() {	// 엑셀다운
		$('#frm').attr('action','/bizCenter/management/usedStatusExcelDown.do');
		$('#frm').submit();
	}

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#sStPeriod').val());

		if ($('#sEdPeriod').val() != '') {
			if (startymd > Date.parse($('#sEdPeriod').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#sStPeriod').val('');
				return false;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#sEdPeriod').val());

		if ($('#sStPeriod').val() != '') {
			if (endymd < Date.parse($('#sStPeriod').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#sEdPeriod').val('');

				return false;
			}
		}
	}

</script>