<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<link type="text/css" href="<c:url value='/lib/fullcalendar/main.css' />" rel="stylesheet" />
<style type="text/css">
	.fc .fc-button-group .fc-button-primary {
		color: #fff;
		color: var(--fc-button-text-color, #fff);
		background-color: #76828e;
		background-color: var(--fc-button-active-bg-color, #76828e);
		border-color: #76828e;
		border-color: var(--fc-button-active-border-color, #76828e);
	}
	.fc .fc-daygrid-event {cursor: pointer;}
	.fc .fc-daygrid-event .fc-event-main {
		padding-left: 5px !important;
	}
	.fc .fc-timegrid-event {cursor: pointer;}
	.fc .fc-timegrid-event .fc-event-main {
		padding: 1px 5px 0 !important;
	}
</style>
<script type="text/javascript" src="<c:url value='/lib/fullcalendar/main.js' />"></script>
<!-- 화상상담 전송 데이터 값 처리(encode64)  -->
<script src="https://asp.4nb.co.kr/kita/_api/js/util.js"></script>
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="enterTestVideoOffice();" class="btn_sm btn_primary">화상상담 테스트 연결</button>
	</div>
</div>
<div class="cont_block mt-20" style="height:calc(100% - 65px);">
	<div style="width: 100%;height: 100%;">
		<div id="calendar"></div>
	</div>
</div>
<form id="aiConsultForm" action="<c:url value="/tradeSOS/com/aiConsultServiceList.do" />" method="post" target="_blank">
<input type="hidden" name="apiCallYn" value="Y" />
<input type="hidden" id="reqContents" name="reqContents" />
</form>
<form id="videoOfficeForm" name="videoOfficeForm" action="${linkUrl}" method="post">
<input type="hidden" id="apiAuthCode" name="apiAuthCode" />
<input type="hidden" id="companyCode" name="companyCode" />
<input type="hidden" id="roomId" name="roomId" />
<input type="hidden" id="userId" name="userId" />
<input type="hidden" id="userName" name="userName" />
<!-- 1 = 진행자 / 0 = 참여자 -->
<input type="hidden" id="userLevel" name="userLevel" value="1" />
<input type="hidden" id="userDeptName" name="userDeptName" />
<input type="hidden" id="userPosName" name="userPosName" />
</form>
<form id="videoOfficeTestForm" name="videoOfficeTestForm" action="https://asp.4nb.co.kr/kita/_api/self_test.php" method="post">
<input type="hidden" id="apiAuthCodeTest" name="apiAuthCode" />
<input type="hidden" id="companyCodeTest" name="companyCode" />
</form>
<script type="text/javascript">
	var calendar = null;
	var timeIntervalId = '';
	var timeIntervalDetailId = '';
	$(document).ready(function(){
		/*
		timeIntervalId = setInterval(function(){
			getList();
		}, 60000);
		*/
		
        var calendarEl = document.getElementById('calendar');
        calendar = new FullCalendar.Calendar(calendarEl, {
        	height:'100%',
			initialView : 'dayGridMonth'
			, allDaySlot : false
			// for all non-TimeGrid views
			, dayMaxEventRows : true
			, views : {
				timeGrid : {
					// adjust to 6 only for timeGridWeek/timeGridDay
					dayMaxEventRows : 6
				}
			}
        	, headerToolbar : {
				start : 'dayGridMonth,timeGridWeek'
				, center : 'prev,title,next'
				, end : 'today'
            }
        	, locale : 'ko'
        	, slotMinTime : '${slotMinTime}:00:00'
        	, slotMaxTime : '${slotMaxTime}:59:00'
        	, slotDuration : '00:20:00'
        	, titleFormat : {
				year : 'numeric'
				, month : '2-digit'
				, day : '2-digit'
			}
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
        	, selectable : false
        	, displayEventTime : false
        	, customButtons : {
				dayGridMonth : {
					text : '월간'
					, click : function(){
						calendar.changeView('dayGridMonth');
						getList();
						changeCalender();
					}
				}
        		, timeGridWeek : {
					text : '주간'
					, click: function(){
						calendar.changeView('timeGridWeek');
						getList();
						changeCalenderWeek();
					}
				}
        		, prev : {
					text : 'prev'
					, click : function(){
						calendar.prev();
						getList();
					}
				}
        		, next : {
					text : 'next'
					, click : function(){
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
        	, eventContent : function(info){
				var title = info.event.title;
				
				if (title.indexOf('/') > -1) {
					return {
						html : title.split('/')[0] + '<br />' + title.split('/')[1]
					};
				}
			}
        	, dateClick : function(info){
				openPrvtConsultForDayPopup(getFormatFromDate(info['date'], ''));
				
				/*
				timeIntervalDetailId = setInterval(function(){
					openPrvtConsultForDayPopup(getFormatFromDate(info['date'], ''));
				}, 60000);
				*/
			}
        	, eventClick : function(info){
        		// 월간, 주간 구분
				if ($('.fc-dayGridMonth-button').hasClass('fc-button-active')) {
					openPrvtConsultForDayPopup(getFormatFromDate(info['event']['start'], ''));
					
					/*
					timeIntervalDetailId = setInterval(function(){
						openPrvtConsultForDayPopup(getFormatFromDate(info['event']['start'], ''));
					}, 60000);
					*/
				} else {
					openPrvtConsultRequestPopup(info['event']['id']);
				}
			}
        	, viewDidMount : function(){
				if ($('.fc-toolbar-title').find('.changeCalender').length == 0) {
					$('.fc-toolbar-title').append(
						'<div class="dateSelector" style="text-align: center;margin-top: -40px;">'
						+ '	<input type="text" class="dates changeCalender" style="background: transparent !important;color: transparent !important;border: 0;cursor: pointer;" />'
						+ '</div>'
					);
				}
				
				changeCalender();
			}
		});

		calendar.render();

		getList();

		function changeCalender() {
			$('.changeCalender').datepicker('destroy');
			$('.changeCalender').monthpicker({
				pattern : 'yyyy-mm'
				, monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
			});
		};

		function changeCalenderWeek() {
			$('.changeCalender').monthpicker('destroy');
			$('.changeCalender').datepicker({
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
				, showButtonPanel : true
				// DATEPICKER 셋팅 추가
				, beforeShow : function(date){
					setTimeout(function () {
						$('#ui-datepicker-div').find('.ui-state-active').removeClass('ui-state-active');
						$('.ui-datepicker-calendar tr').each(function(){
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
			});
		};

		// 첨부파일
		$(document).on('change', 'input:file[name^="param_file"]', function(e){
			var $this = $(e.target);
			$this.parents('div.inputFile').find('input:text[name^="fileName"]').val(
				$this.val().substring($this.val().lastIndexOf('\\') + 1)
			);
		});

		$(document).on('change', '.changeCalender', function(e, a){
			var changeDate = $(this).val();
			
			if (changeDate.length < 7) {
				changeDate = changeDate + '-01'
			}
			
			calendar.gotoDate(changeDate);
			getList();
			
			$(':focus').blur();
		});
	});

	/**
	 * 선택 날짜별 event 수
	 * (외 ..명 을 처리하기 위함)
	 * @param consultRequestList
	 * @param rsrvDate
	 * @returns {number}
	 */
	function getConsultRequestCountByDate(consultRequestList, rsrvDate) {
		var targets = [];
		consultRequestList.forEach(function(item){
			if (item['rsrvDate'] != null) {
				if (rsrvDate == item['rsrvDate']) {
					targets.push(item['rsrvDate']);
				}
			}
		});
		
		return targets.length;
	}

	// 상담 신청 현황 목록
	function getList() {
		// DATEPICKER 날짜 변경
		var setDate = new Date(calendar.getDate().getFullYear(), calendar.getDate().getMonth());
		$('.changeCalender').datepicker('setDate', setDate);

		var fromDate;
		var toDate;
		// 월간, 주간 구분
		if ($('.fc-dayGridMonth-button').hasClass('fc-button-active')) {
			fromDate = getFormatFromDate(new Date(calendar.getDate().getFullYear(), calendar.getDate().getMonth(), 1), '');
			toDate = getFormatFromDate(new Date(calendar.getDate().getFullYear(), calendar.getDate().getMonth() + 1, 0), '');
		} else {
			fromDate = getFormatFromDate(new Date($('.fc-col-header-cell:first').attr('data-date')), '');
			toDate = new Date($('.fc-col-header-cell:first').attr('data-date'));
			toDate.setDate(toDate.getDate() + 6);
			toDate = getFormatFromDate(toDate, '');
		}
		
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectExpertPrvtConsultList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				scheduleDateFrom : fromDate
				, scheduleDateTo : toDate
			}
			, async : true
			, spinner : true
			, success : function(data){
				calendar.removeAllEvents();
				
				if (data != null && data['result'].length > 0) {
					// 월간, 주간 구분
					if ($('.fc-dayGridMonth-button').hasClass('fc-button-active')) {
						var resultList = data['result'];
						var scheduleDate = '';
						var events = [];
						for (var i = 0; i < resultList.length; i++) {
							if (resultList[i]['rsrvDate'] != null) {
								if (scheduleDate != resultList[i]['scheduleDate']) {
									var anotherEventCnt = getConsultRequestCountByDate(resultList, resultList[i]['rsrvDate']) - 1;
									var title = resultList[i]['rsrvTime'].substring(0, 2) + ':' + resultList[i]['rsrvTime'].substring(2, 4) + '/' + resultList[i]['reqNm'];
									
									if (anotherEventCnt > 0) {
										title = title + ' 외 ' + (getConsultRequestCountByDate(resultList, resultList[i]['rsrvDate']) - 1) + '명'
									}
									
									events.push({
										id : resultList[i]['prvtConsultId']
										, title : title
										, start : resultList[i]['scheduleDate'].substring(0, 4) + '-' + resultList[i]['scheduleDate'].substring(4, 6) + '-' + resultList[i]['scheduleDate'].substring(6, 8)
									});
								}
								
								scheduleDate = resultList[i]['scheduleDate'];
							} else {
								events.push({
									title : '예약 없음'
									, start : resultList[i]['scheduleDate'].substring(0, 4) + '-' + resultList[i]['scheduleDate'].substring(4, 6) + '-' + resultList[i]['scheduleDate'].substring(6, 8)
									// 배경컬러 변경
									, color : '#76828e'
								});								
							}
						}
						
						calendar.addEventSource({
							events : events
						});
					} else {
						var events = [];
						data['result'].forEach(function(item){
							if (item['rsrvDate'] != null) {
								var rsrvTime = new Date(item['rsrvDate'].substring(0, 4), item['rsrvDate'].substring(4, 6)-1, item['rsrvDate'].substring(6, 8), item['rsrvTime'].substring(0, 2), item['rsrvTime'].substring(2, 4));
								var completeTime = new Date(item['rsrvDate'].substring(0, 4), item['rsrvDate'].substring(4, 6)-1, item['rsrvDate'].substring(6, 8), item['rsrvTime'].substring(0, 2), item['rsrvTime'].substring(2, 4));
								completeTime.setMinutes(completeTime.getMinutes() + 20);
								
								events.push({
									id : item['prvtConsultId']
									, title : item['reqNm'] + ' (' + item['consultChannelNm'] + ') ' + ' (' + item['statusNm'] + ') '
									, start : rsrvTime
									, end : completeTime
								});
							}
						});
						
						calendar.addEventSource({
							events : events
						});
					}
				}
			}
		});
	}

	function encode64Han(str) {
		if (str != '') {
			return encode64(escape(str));
		} else {
			return '';
		}
	}

	function openPrvtConsultForDayPopup(rsrvDate) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPrvtConsultForDayPopup.do" />'
			, params : {
				rsrvDate : rsrvDate
			}
			, callbackFunction : function(resultObj){
				closeLayerPopup();
				
				openPrvtConsultForDayPopup(rsrvDate);
			}
		});
    }
	
	function openPrvtConsultRequestPopup(prvtConsultId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPrvtConsultRequestPopup.do" />'
			, params : {
				prvtConsultId : prvtConsultId
			}
			, callbackFunction : function(resultObj){
				closeLayerPopup();
				
				openPrvtConsultRequestPopup(prvtConsultId);
			}
		});
    }

	// 채팅 상담 시스템 접속
	function enterChatConsult() {
		window.open('${siteUrl}');
	}

	function doSearchAiConsult(reqContents) {
		$('#reqContents').val(reqContents);
		$('#aiConsultForm').submit();
	}
	
	// 화상 상담 접속(상담자)
	function enterVideoOffice(roomId) {
		$('#roomId').val(roomId);
		$('#apiAuthCode').val(encode64Han('${apiAuthCode}'));
		$('#companyCode').val(encode64Han('${companyCode}'));
		$('#userId').val(encode64Han('${user.id}'));
		$('#userName').val(encode64Han('${user.memberNm}'));
		$('#videoOfficeForm').attr('target', '_blank');
		$('#videoOfficeForm').submit();
	}
	
	function enterTestVideoOffice() {
		$('#apiAuthCodeTest').val(encode64Han('${apiAuthCode}'));
		$('#companyCodeTest').val(encode64Han('${companyCode}'));
		$('#videoOfficeTestForm').attr('target', '_blank');
		$('#videoOfficeTestForm').submit();
	}
	
	function openPrvtCancelPopup(consultId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPrvtCancelPopup.do" />'
			, params : {
				prvtConsultId : consultId
			}
			, callbackFunction : function(resultObj){
				closeLayerPopup();
				closeLayerPopup();
				
				var rsrvDate = resultObj.rsrvDate;
				rsrvDate = rsrvDate ? rsrvDate.replace(/-/g, '') : '';
				
				openPrvtConsultForDayPopup(rsrvDate);
			}
		});
    }
	
	function openPrvtConsultLogPopup(consultId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPrvtConsultLogPopup.do" />'
			, params : {
				prvtConsultId : consultId
			}
			, callbackFunction : function(resultObj){
				closeLayerPopup();
				closeLayerPopup();
				
				openPrvtConsultRequestPopup(consultId);
			}
		});
    }
</script>