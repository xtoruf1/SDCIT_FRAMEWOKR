<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<link type="text/css" href="<c:url value='/lib/fullcalendar/main.css' />" rel="stylesheet" />
<style type="text/css">
	.hourInfo {position: relative;}
	.hourInfo > div.totalHour {top: 6px;right: 80px;}
	.hourInfo > div {position: absolute;font-size: 16px;}
	.hourInfo.week{position:absolute; bottom:0; right:0; height:calc(100% - 86px);}
	.hourInfo.week > div {display:flex; align-items:center; position:relative; height:16.6666%; right: 10px;color: #254F58; white-space:nowrap;}
</style>
<script type="text/javascript" src="<c:url value='/lib/fullcalendar/main.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.mtz.monthpicker.js' />"></script>
<form id="scheduleForm" name="scheduleForm" method="post" onsubmit="return false;" style="height:100%;">
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="resetSelectExpert();" class="btn_sm btn_secondary">초기화</button>
	</div>
</div>
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">전문가</th>
				<td>
					<div class="field_set flex align_center">
						<span class="form_search">
							<input type="text" id="searchMemberNm" class="form_text" style="width: 10%;" readonly="readonly" />
							<input type="hidden" id="expertId" name="expertId" value="" />
							<button type="button" onclick="openExpertListPopup();" class="btn_icon btn_search" title="검색"></button>
						</span>
						<button type="button" onclick="resetSelectExpert();" class="ml-8"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<div class="cont_block mt-20" style="height:calc(100% - 110px);">
	<div style="position:relative; height:calc(100% - 24px);">
		<!-- 월간달력 표시 -->
		<div id="weekTime" class="hourInfo week">
			<div id="weekHour1" class="weekHour1"></div>
			<div id="weekHour2" class="weekHour2"></div>
			<div id="weekHour3" class="weekHour3"></div>
			<div id="weekHour4" class="weekHour4"></div>
			<div id="weekHour5" class="weekHour5"></div>
		</div>	
		<div id="calendar" class="selectCalendar"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	var calendar = null;
	var nDate = new Date();
	
	if ('${nDate}'!= null) {
		// 서버 시간
		nDate = new Date('${nDate}');
	}
	
    $(document).ready(function() {
		var calendarEl = document.getElementById('calendar');
        calendar = new FullCalendar.Calendar(calendarEl, {
        	height:'100%',
            initialView : 'dayGridMonth'
            , allDaySlot : false
            , locale : 'ko'
			// for all non-TimeGrid views
            , dayMaxEventRows: true
            , views : {
				timeGrid : {
					// adjust to 6 only for timeGridWeek/timeGridDay
					dayMaxEventRows : 6
				}
			}
			, titleFormat : {
				year : 'numeric'
				, month : '2-digit'
            }
			, slotMinTime : '${slotMinTime}:00:00'
			, slotMaxTime : '${slotMaxTime}:59:00'
			, slotDuration : '00:20:00'
			, titleFormat : function(date){
				var startDateCalc = new Date(date['start']['year'], date['start']['month'], date['start']['day']);
				var startDate = new Date(date['start']['year'], date['start']['month'], date['start']['day']);
				var endDate = new Date(date['end']['year'], date['end']['month'], date['end']['day']);
				startDateCalc.setDate(startDateCalc.getDate() + 15);
				
				var result = getFormatFromDate(startDate, '.').substring(0, 7);
				
				if (startDateCalc > endDate) {
					result = getFormatFromDate(startDate, '.') + ' ~ ' + getFormatFromDate(endDate, '.');
				}
				
				return result;
			}
			, headerToolbar : {
				start : ''
				, center : 'prev,title,next'
				, end : 'today'
			}
			, buttonText : {
				dayGridMonth : '월간'
				, timeGridWeek : '주간'
            }
			, customButtons : {
				prev : {
					text : 'prev'
					, click : function(){
						if ($('#expertId').val() == '') {
							alert('전문가를 선택해 주세요.');
							
							return;
						}
						
						calendar.prev();
						getList();
					}
				}
				, next : {
					text : 'next'
					, click : function(){
						if ($('#expertId').val() == '') {
							alert('전문가를 선택해 주세요.');
							
							return;
						}
						
						calendar.next();
						getList();
					}
				}
				, today : {
					text : 'today'
					, click : function(){
						calendar.today();
						getList();
					}
				}
			}
			, displayEventTime : false
			, dateClick : function(info){
				openExpertSetTimePopup(info);
			}
			, eventClick : function(info){
				openExpertSetTimePopup(info['event']);
			}
			, viewDidMount : function(){
				if ($('.fc-toolbar-title').find('.changeCalender').length == 0) {
					$('.fc-toolbar-title').append(
						'<div class="dateSelector" style="text-align: center;margin-top: -40px;">'
						+ '	<input type="text" class="dates changeCalender" style="background: transparent !important;color: transparent !important;border: 0;cursor: pointer;">'
						+ '</div>'
					);
				}
				
				changeCalender();
			}
        });
        
        calendar.render();
		
		function changeCalender() {
			$('.changeCalender').datepicker('destroy');
			$('.changeCalender').monthpicker({
				pattern: 'yyyy-mm'
				, monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
			});
		};

		$(document).on('change', '.changeCalender', function(e){
			if ($('#expertId').val() == '') {
				alert('전문가를 선택해 주세요.');
				
				return;
			}
			
			var changeDate = $(this).val();
			changeDate = changeDate + '-01'
			calendar.gotoDate(changeDate);
			
			getList();
			
			$(':focus').blur();
		});
	});
	
    function getList() {
    	var setDate = new Date(calendar.getDate().getFullYear(), calendar.getDate().getMonth());
    	$('.changeCalender').datepicker('setDate', setDate);
    	
    	var fromDate;
    	var toDate;
    	
    	// 월간, 주간 구분
    	if ($('.fc-dayGridMonth-button').length == 0 || $('.fc-dayGridMonth-button').hasClass('fc-button-active')) {
    		fromDate = getFormatFromDate(new Date(calendar.getDate().getFullYear(), calendar.getDate().getMonth(), 1), '');
    		toDate = getFormatFromDate(new Date(calendar.getDate().getFullYear(), calendar.getDate().getMonth() + 1, 0), '');
    	} else {
    		var firstDate = calendar['currentData']['viewTitle'].substring(0, 10);
    		fromDate = firstDate.replace(/\./g,'');
    		toDate = new Date(fromDate.substring(0, 4), fromDate.substring(4, 6)-1, fromDate.substring(6, 8));
    		toDate.setDate(toDate.getDate() + 6);
    		toDate = getFormatFromDate(toDate, '');
    	}
    	
    	global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectExpertSchedule.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				scheduleDateFrom : fromDate
				, scheduleDateTo : toDate
				, expertId : $('#expertId').val()
			}
			, async : true
			, spinner : true
			, success : function(data){
				$('#dateTime div').html('일 0 시간');
    			$('#weekTime div').html('주 0 시간');
    			
    			calendar.removeAllEvents();
    			
    			if (data != null && data['result'].length > 0) {
    				if ($('.fc-dayGridMonth-button').length == 0 || $('.fc-dayGridMonth-button').hasClass('fc-button-active')) {
    					// 주간 합계 처리
    					$('.fc-scrollgrid-sync-table tr').each(function (index, item) {
    						var findDate = $(item).find('td:eq(6)').attr('data-date');
    						var dateSat = new Date(findDate);
    						var dateMon = new Date(findDate);
    						dateMon.setDate(dateMon.getDate() - 6);
    						var arrHour = [];
    						
                            data['result'].forEach(function(schedule){
    							var scheduleDate = new Date(schedule['scheduleDate'].substring(0, 4) + '-' + schedule['scheduleDate'].substring(4, 6) + '-' + schedule['scheduleDate'].substring(6, 8));
    							
    							if (dateMon <= scheduleDate && dateSat >= scheduleDate) {
    								arrHour.push(schedule['minutes'] / 60);
    							}
    						});
                            
    						var weekHours = 0;
    						for (var i = 0; i < arrHour.length; i++) {
    							weekHours = weekHours + arrHour[i];
    						}
    						
    						$('#weekHour' + (index + 1)).html('주 ' + weekHours.toFixed(1) + ' 시간');
    					});
    				} else {
    					$('.fc-col-header th:not(:first)').each(function (index, item) {
    						var arrHour = [];
    						data['result'].forEach(function(schedule){
    							var findDate = $(item).attr('data-date');
    							
    							if (findDate.replace(/-/g,'') == schedule['scheduleDate']) {
    								arrHour.push(schedule['minutes'] / 60);
    							}
    						});
    						
    						var dayHours = 0;
    						for (var i = 0; i < arrHour.length; i++) {
    							dayHours = dayHours + arrHour[i];
    						}
    						
    						$('#dateHour' + (index + 1)).html('일 ' + dayHours.toFixed(1) + ' 시간');
    					});
    				}

    				var eventList = [];
    				data['result'].forEach(function(item){
    					var fromHH = item['fromHhmm'].substring(0, 2) + ':' + item['fromHhmm'].substring(2, 4);
    					var endHH = item['endHhmm'].substring(0, 2) + ':' + item['endHhmm'].substring(2, 4);
    					var scheduleDate = item['scheduleDate'].substring(0, 4) + '-' + item['scheduleDate'].substring(4, 6) + '-' + item['scheduleDate'].substring(6, 8);
    					
    					eventList.push({
    						title : fromHH + ' ~ ' + endHH
    						, start : scheduleDate + 'T' + fromHH + ':00'
    						, end : scheduleDate + 'T' + endHH + ':00'
    					});
    				});
    				
    				calendar.addEventSource({
    					events : eventList
    				});
    			}
    			
    			if (data != null && typeof data['totalHour'] == 'number') {
    				var divHtml = '';
    				
    				if ($('.fc-dayGridMonth-button').length == 0 || $('.fc-dayGridMonth-button').hasClass('fc-button-active')) {
    					divHtml += '월간 : ';
    				} else {
    					divHtml += '주간 : ';
    				}
    				
    				divHtml += data['totalHour'];
    				divHtml += '시간';
    				
    				$('#divTotalHour').html(divHtml);
    			}
			}
		});
    }
    
    // 전문가 선택 팝업
    function openExpertListPopup() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertListPopup.do" />'
			, params : {
			}
			, callbackFunction : function(resultObj){
				$('#searchMemberNm').val(resultObj.expertNm);
				$('#expertId').val(resultObj.expertId);
				
				getList();
			}
		});
    }
    
    function resetSelectExpert() {
    	$('#searchMemberNm').val('');
		$('#expertId').val('');
		
		calendar.removeAllEvents();
	}
	
	function resetPopup() {
		$('#searchPop1').find('input,select').each(function(index, item){
			if ($(item).attr('name') != undefined) {
				$(item).val('');
			}
		});
		
		$('#schedulePop input[type="checkbox"]').each(function(index, item){
			$(item).prop('checked', false);
		});
		
		loadSearchDataGrid('expertList', []);
	}

	function openExpertSetTimePopup(info) {
		if ($('#expertId').val() == '') {
			alert('전문가를 선택해 주세요.');
			
			return;
		}
		
		var dateStr = '';
		if (info.hasOwnProperty('dateStr')) {
			dateStr = info['dateStr'];
		} else {
			dateStr = getFormatFromDate(info['start'], '-');
		}

		if (dateStr.length > 10) {
			dateStr = dateStr.substring(0, 10);
		}
		
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertSetTimePopup.do" />'
			, params : {
				dateStr : dateStr
				, setDate : dateStr.replace(/-/g, '')
				, expertId : $('#expertId').val()
				, viewGb : 'proAdmin'
			}
			, callbackFunction : function(resultObj){
			}
		});
    }
</script>