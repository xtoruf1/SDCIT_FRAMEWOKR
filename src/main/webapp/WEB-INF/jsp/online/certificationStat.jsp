<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="btnGroup ml-auto">
		<button type="button" id="btnExcel" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(certStatSheet, '증명서_통계', '');">엑셀 다운</button>
		<button type="button" id="btnSearchReset" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" id="btnSave" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<div class="cont_block">
	<form id="frm" method="post">
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
									<input type="radio" class="form_radio" name="searchType" value="DAY" />
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
											<input type="text" id="sWeekFrom" name="sWeekFrom" value="${defaultVal.baseStWeek}" class="txt datepicker datepickerWeek" placeholder="시작일" title="시작일" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
									<div class="spacing">~</div>
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" id="sWeekTo" name="sWeekTo" value="${defaultVal.baseEdWeek}" class="txt datepicker datepickerWeek" placeholder="종료일" title="종료일" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
								</div>
								<div id="sPeriodDiv" class="group_datepicker ml-30 hidden">
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" id="sDayFrom" name="sDayFrom" value="${defaultVal.baseStPeriod}" class="txt datepicker" style="width: 110px;" placeholder="신청기간 시작" title="신청기간 시작" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
									<div class="spacing">~</div>
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" id="sDayTo" name="sDayTo" value="${defaultVal.baseEdPeriod}" class="txt datepicker" style="width: 110px;" placeholder="신청기간 종료" title="신청기간 종료" readonly="readonly" />
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

<!--검색 끝 -->
<div class="cont_block mt-20">
	<div style="width: 100%;height: 100%;">
		<div id="sheetDiv" class="sheet"></div>
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
			}else if( this.value == 'DAY' ){
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

		        $('#sWeekFrom').val(fromDate);

				selectDate.setDate(selectDate.getDate() + 6);

				year = selectDate.getFullYear();
		    	month = selectDate.getMonth() + 1;
		    	month = (month < 10) ? '0' + month : month;
		    	day = selectDate.getDate();
		    	day = (day < 10) ? '0' + day : day;

		    	var toDate = '' + year + '-' +  month  + '-' + day;

		    	$('#sWeekTo').val(toDate);
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

		// 시작일 선택 이벤트
		datepickerById('sDayFrom', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('sDayTo', toDateSelectEvent);

		setSheetHeader_certStatSheet();
		doSearch();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#sDayFrom').val());
		if ($('#sDayTo').val() != '') {
			if (startymd > Date.parse($('#sDayTo').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#sDayFrom').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#sDayTo').val());

		if ($('#sDayFrom').val() != '') {
			if (endymd < Date.parse($('#sDayFrom').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#sDayTo').val('');

				return;
			}
		}
	}

	function setSheetHeader_certStatSheet() {
		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '기간|기간'						, Type: 'Text'		, SaveName: 'reqDate'	, Edit: false	, Width: 110		, Align: 'Center'});
		ibHeader.addHeader({Header: '수출입증명서|수출실적'				, Type: 'AutoSum'	, SaveName: 'data01'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '수출입증명서|수입실적'				, Type: 'AutoSum'	, SaveName: 'data02'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '수출입증명서|용역/전자적\n무체물'		, Type: 'AutoSum'	, SaveName: 'data03'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '수출입증명서|선용품'					, Type: 'AutoSum'	, SaveName: 'data04'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '수출입증명서|외화영수부'				, Type: 'AutoSum'	, SaveName: 'data05'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '수출입증명서|소계'					, Type: 'AutoSum'	, SaveName: 'sum01'		, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer', 'CalcLogic': '|data01|+|data02|+|data03|+|data04|+|data05|'});
		ibHeader.addHeader({Header: '무역관련증명서|수출의탑'				, Type: 'AutoSum'	, SaveName: 'data06'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '무역관련증명서|수출의탑\n(폐업)'		, Type: 'AutoSum'	, SaveName: 'data07'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '무역관련증명서|외환수수료\n우대확인서'	, Type: 'AutoSum'	, SaveName: 'data08'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '무역관련증명서|회원증'				, Type: 'AutoSum'	, SaveName: 'data09'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '무역관련증명서|회비영수증'			, Type: 'AutoSum'	, SaveName: 'data10'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '무역관련증명서|무역업고유번호\n부여증'	, Type: 'AutoSum'	, SaveName: 'data11'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '무역관련증명서|해외지사/사무소\n추천서'	, Type: 'AutoSum'	, SaveName: 'data12'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '무역관련증명서|외국인비자\n추천서'		, Type: 'AutoSum'	, SaveName: 'data13'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '무역관련증명서|바이어사증\n추천서'		, Type: 'AutoSum'	, SaveName: 'data14'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '무역관련증명서|소계'					, Type: 'AutoSum'	, SaveName: 'sum02'		, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer', 'CalcLogic': '|data06|+|data07|+|data08|+|data09|+|data10|+|data11|+|data12|+|data13|+|data14|'});
		ibHeader.addHeader({Header: '무역아카데미 증명서|수료증'			, Type: 'AutoSum'	, SaveName: 'data15'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '무역아카데미 증명서|온라인CTC'		, Type: 'AutoSum'	, SaveName: 'data16'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '무역아카데미 증명서|자격증'			, Type: 'AutoSum'	, SaveName: 'data17'	, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '무역아카데미 증명서|소계'				, Type: 'AutoSum'	, SaveName: 'sum03'		, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer', 'CalcLogic': '|data15|+|data16|+|data17|'});
		ibHeader.addHeader({Header: '합계|합계'						, Type: 'AutoSum'	, SaveName: 'total'		, Edit: false	, Width: 110		, Align: 'Right'	, Format: 'Integer', 'CalcLogic': '|data01|+|data02|+|data03|+|data04|+|data05|+|data06|+|data07|+|data08|+|data09|+|data10|+|data11|+|data12|+|data13|+|data14|+|data15|+|data16|+|data17|'});
		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction',
			FrozenCol:1,
	        DeferredVScroll: 1,
	        colresize: false,
	        SelectionRowsMode: 4,
	        SearchMode: 2,
	        NoFocusMode : 0,
	        Alternate : 0,
	        Page: 10,
	        SizeMode: 1,
	        MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: false, ColMove: true});

		var container = $('#sheetDiv')[0];
		createIBSheet2(container, 'certStatSheet', '100%', '100%');
		ibHeader.initSheet('certStatSheet');

	}

	function doSearch() {
		var searchParams = $('#frm').serializeObject();

		if( $('#sDayFrom').val() == '' ){
			alert('검색 시작일을 입력하세요.');
			$('#sDayFrom').focus();
			return false;
		}else if( $('#sDayTo').val() == '' ){
			alert('검색 종료일을 입력하세요.');
			$('#sDayTo').focus();
			return false;
		}

		global.ajax({
			type : 'POST'
			, url : "/online/selectCertificationStatList.do"
			, data : $('#frm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				certStatSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function certStatSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('certStatSheet_OnSearchEnd : ', msg);
    	} else {
    	}
    }

	function doClear() {	// 초기화
		location.reload();
	}

	function doExcelDownload() {	// 엑셀다운
	}

</script>