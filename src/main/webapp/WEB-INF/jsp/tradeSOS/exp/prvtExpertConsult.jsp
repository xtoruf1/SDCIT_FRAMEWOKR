<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<link type="text/css" href="<c:url value='/lib/fullcalendar/main.css' />" rel="stylesheet" />
<style type="text/css">
	.btn_group_top {position: absolute;top: 0;right: 0;}
	.dateSelector {text-align: center;margin: 3px 0 15px;}
	.dateSelector span.date,
	.dateSelector input[type="text"][readonly] {background: #fff;}
	.dateSelector input[type="text"]:focus {outline: none;}
	.dateSelector .btn_standard {margin: 0 30px;min-width: 40px;height: 38px;background-color: #2c3e50;}
	.dateSelector .btn_standard > span {display: block;width: 100%; height: 100%;}
	.dateSelector .btn_standard .prev {background: url(../../images/icon/icon_progress_left.png) no-repeat center center;}
	.dateSelector .btn_standard .next {background: url(../../images/icon/icon_progress_right.png) no-repeat center center;}
	.timeSelector {display: flex;}
	.timeSelector > div {position: relative;width: 50px;height: 50px;padding: 10px;border: 1px solid #ddd;-ms-user-select: none;-moz-user-select: -moz-none;-khtml-user-select: none;-webkit-user-select: none;user-select: none;}
	.timeSelector > div + div {border-left: 0;} 
	.timeSelector + .timeSelector > div {border-top: 0;}
	.timeSelector > div span {position: absolute;top: 0;left: 0;width: 100%;height: 100%;font-size: 15px;line-height: 50px;text-align: center;}
	.timeSelector > div span {background-color: #e4e4e4;opacity: 0.4;}
	.timeSelector > div input[type="checkbox"] + span {background-color: #fff;opacity: 1;}
	.timeSelector > div input[type="checkbox"] + span:hover {background: rgba(255, 220, 40, 0.15);}
	.timeSelector > div input[type="checkbox"] {display: none;}
	.timeSelector > div input[type="checkbox"]:checked + span{background: #606080;color: #fff;}
	
	#selectDate {
		width: 200px;
		font-size: 27px;
		color: #666;
		font-weight: 700;
		text-align: center;
		vertical-align: middle;
		border: 0;
		letter-spacing: -0.5px;
		padding: 0;
		border: 0;
		cursor: pointer;
	}
	.circleList {display: flex;justify-content: flex-end;margin-bottom: 10px;}
	.circleList li {margin-left: 15px;}
	.ico_cir {display: block;text-align: center;color: #333;}
	.ico_cir:before {display: inline-block;width: 10px;height: 10px;margin-right: 5px;border-radius: 50%;content: '';box-sizing: border-box;}
	.ico_cir.color1:before {background-color: #1e4bf1;}
	.ico_cir.color2:before {background-color: #000;}
	.ico_cir.color3:before {background-color: #e41212;}
	.ico_cir.color4:before {background-color: #008000;}
	.ico_cir.color5:before {background-color: #fff;border: 1px solid #000;}
	.searchCalendar td > span {line-height: 36px;}
	.searchCalendar td.rBnone {border-right: 0;}

	.scheduleCalendar {display: flex;align-items: stretch;flex-wrap: wrap;}
	.scheduleCalendar > span {display: flex;flex: 1;justify-content: center;align-items: center;width: 50px;border-top: 2px solid #254F58;border-bottom: 1px solid #ddd;background-color: #eee;}
	.scheduleCalendar > .formTable {width: calc(100% - 50px);border-left: 1px solid #ddd;}
	.scheduleCalendar .formTable {margin: 0;}
	.scheduleCalendar .formTable td {vertical-align: top;height: 86px;}
	.scheduleCalendar .ico_cir {float: left;width: 50%;margin: 2px 0;cursor: pointer;}
	.scheduleCalendar .formTable td.bg {background: ivory;}
</style>
<script type="text/javascript" src="<c:url value='/lib/fullcalendar/main.js' />"></script>
<form id="scheduleForm" name="scheduleForm" method="post" onsubmit="return false;">
<!-- 페이지 위치 -->
<div class="location">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="resetPrvtConsult();" class="btn_sm btn_secondary">초기화</button>
	</div>
</div>
<div class="search">
	<div class="dateSelector" style="text-align: center;">
		<button type="button" onclick="setPrevDate();" class="btn_standard" style="border-radius: 3px;"><span class="prev"></span></button>
		<input type="text" id="selectDate" value="" onchange="changeSelectDate();" class="datepicker changeCalender" readonly="readonly" />
		<button type="button" onclick="setNextDate();" class="btn_standard" style="border-radius: 3px;"><span class="next"></span></button>
	</div>
	<div class="searchCalendar">
		<ul class="circleList">
			<li style="margin-left: 15px;"><span class="ico_cir color1">상담완료</span></li>
			<li style="margin-left: 15px;"><span class="ico_cir color2">No Show(고객)</span></li>
			<li style="margin-left: 15px;"><span class="ico_cir color3">No Show(전문가)</span></li>
			<li style="margin-left: 15px;"><span class="ico_cir color4">진행중</span></li>
			<li style="margin-left: 15px;"i><span class="ico_cir color5">대기중</span></li>
		</ul>
		<table class="formTable">
			<colgroup>
				<col style="width: 15%;" />
				<col />
				<col style="width: 15%;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">전문가</th>
					<td>
						<div class="field_set flex align_center">
							<span class="form_search w100p">
								<input type="text" id="searchExpertNm" value="전체" class="form_text" style="width: 10%;" readonly="readonly" />
								<button type="button" onclick="openExpertSelectListPopup();" class="btn_icon btn_search" title="검색"></button>
							</span>
							<button type="button" onclick="resetSelectExpert();" class="ml-8"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</td>
					<th scope="row">상담분야</th>
					<td>
						<div class="field_set flex align_center">
							<span class="form_search w100p">
								<input type="text" id="searchConsultTypeNm" value="전체" class="form_text" style="width: 10%;" readonly="readonly" />
								<button type="button" onclick="openConsultSelectListPopup();" class="btn_icon btn_search" title="검색"></button>
							</span>
							<button type="button" onclick="resetSelectConsultType();" class="ml-8"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<div class="cont_block mt-20">
	<div style="width: 100%;height: 100%;">
		<div class="scheduleCalendar">
			<span>AM</span>
			<table class="formTable">
				<colgroup>
					<col />
					<col style="width: 16%;" />
					<col style="width: 16%;" />
					<col style="width: 16%;" />
					<col style="width: 16%;" />
					<col style="width: 16%;" />
					<col style="width: 16%;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="col"></th>
						<th scope="col">06</th>
						<th scope="col">07</th>
						<th scope="col">08</th>
						<th scope="col">09</th>
						<th scope="col">10</th>
						<th scope="col">11</th>
					</tr>
					<tr>
						<th scope="col">00'</th>
						<td id="td0600"></td>
						<td id="td0700"></td>
						<td id="td0800"></td>
						<td id="td0900"></td>
						<td id="td1000"></td>
						<td id="td1100"></td>
					</tr>
					<tr>
						<th scope="col">20'</th>
						<td id="td0620"></td>
						<td id="td0720"></td>
						<td id="td0820"></td>
						<td id="td0920"></td>
						<td id="td1020"></td>
						<td id="td1120"></td>
					</tr>
					<tr>
						<th scope="col">40'</th>
						<td id="td0640"></td>
						<td id="td0740"></td>
						<td id="td0840"></td>
						<td id="td0940"></td>
						<td id="td1040"></td>
						<td id="td1140"></td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="scheduleCalendar">
			<span>PM</span>
			<table class="formTable">
				<colgroup>
					<col />
					<col style="width: 16%;" />
					<col style="width: 16%;" />
					<col style="width: 16%;" />
					<col style="width: 16%;" />
					<col style="width: 16%;" />
					<col style="width: 16%;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="col"></th>
						<th scope="col">12</th>
						<th scope="col">13</th>
						<th scope="col">14</th>
						<th scope="col">15</th>
						<th scope="col">16</th>
						<th scope="col">17</th>
					</tr>
					<tr>
						<th scope="col">00'</th>
						<td id="td1200"></td>
						<td id="td1300"></td>
						<td id="td1400"></td>
						<td id="td1500"></td>
						<td id="td1600"></td>
						<td id="td1700"></td>
					</tr>
					<tr>
						<th scope="col">20'</th>
						<td id="td1220"></td>
						<td id="td1320"></td>
						<td id="td1420"></td>
						<td id="td1520"></td>
						<td id="td1620"></td>
						<td id="td1720"></td>
					</tr>
					<tr>
						<th scope="col">40'</th>
						<td id="td1240"></td>
						<td id="td1340"></td>
						<td id="td1440"></td>
						<td id="td1540"></td>
						<td id="td1640"></td>
						<td id="td1740"></td>
					</tr>
					<tr>
						<th scope="col"></th>
						<th scope="col">18</th>
						<th scope="col">19</th>
						<th scope="col">20</th>
						<th scope="col">21</th>
						<th scope="col">22</th>
						<th scope="col">23</th>
					</tr>
					<tr>
						<th scope="col">00'</th>
						<td id="td1800"></td>
						<td id="td1900"></td>
						<td id="td2000"></td>
						<td id="td2100"></td>
						<td id="td2200"></td>
						<td id="td2300"></td>
					</tr>
					<tr>
						<th scope="col">20'</th>
						<td id="td1820"></td>
						<td id="td1920"></td>
						<td id="td2020"></td>
						<td id="td2120"></td>
						<td id="td2220"></td>
						<td id="td2320"></td>
					</tr>
					<tr>
						<th scope="col">40'</th>
						<td id="td1840"></td>
						<td id="td1940"></td>
						<td id="td2040"></td>
						<td id="td2140"></td>
						<td id="td2240"></td>
						<td id="td2340"></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
</form>
<form id="aiConsultForm" action="<c:url value="/tradeSOS/com/tradeSOSAiConsultServiceList.do" />" method="post" target="_blank">
<input type="hidden" name="apiCallYn" value="Y" />
<input type="hidden" id="reqContents" name="reqContents" />
</form>
<script type="text/javascript">
	var selectExpert = [];
	var selectConsultType = [];

	// 상담 분야 처리(분야 선택 팝업 사용)
	var consultTypeList = [];
	<c:forEach var="item" items="${consultType}" varStatus="status">
		consultTypeList.push({
			consultTypeCd : '${item.consultTypeCd}'
			, consultTypeNm : '${item.consultTypeNm}'
		});
	</c:forEach>

    $(document).ready(function() {
    	$('.datepicker').datepicker({
    		dateFormat : 'yy.mm.dd'
    		, showMonthAfterYear : true
    		// , yearSuffix : '년'
    		, dayNamesMin : ['일', '월', '화', '수', '목', '금', '토']
    		, monthNamesShort : ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
    		, monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
    		, showOn : 'both'
    		, changeYear : true
    		, changeMonth : true
    		, onSelect : function(dateString) {
    			var inputName = $(this).attr('name');
    			$('#' + inputName).val(dateString);

    			$('label[for="all"]').css('background', '#fff');
    			$('label[for="commCode_01"]').css('background', '#fff');
    			$('label[for="commCode_02"]').css('background', '#fff');
    			
    			changeSelectDate();
    		}
    	}).next('button').button({
    		icons : {
    			primary : 'ui-icon-calendar'
    		}
    		, text : false
    	});
    	
		setNowTime();
	});

	// 현재 시간 설정
	function setNowTime() {
		$('#selectDate').val(getFormatFromDate(new Date(), '.'));
		$('.scheduleCalendar td').each(function(index, item){
			if ($(item).hasClass('bg')) {
				$(item).removeClass('bg');
			}
 		});
		
		var nTime = new Date().getHours();
		var nMin = new Date().getMinutes();
		
		nMin = (nMin < 20) ? '00' : (nMin < 40) ? '20' : '40';
		
		$('#td' + ((nTime < 10) ? '0' + nTime : nTime) + nMin).addClass('bg');
		
		$('#selectDate').trigger('change');
	}

	// 1:1상담 내역 조회
	function getList() {
		$('.scheduleCalendar td').each(function(index, item){
			$(item).html('');
		});
		
		var arrExpert = [];
		var arrConsultType = [];
		
		if (selectExpert.length > 0) {
			selectExpert.forEach(function(item){
				arrExpert.push(item['expertId']);
			});
		}
		
		if (selectConsultType.length > 0) {
			selectConsultType.forEach(function(item){
				arrConsultType.push(item['consultTypeCd']);
			});
		}
		
		var jsonParam = {
			rsrvDate : getFormatFromDate(new Date($('#selectDate').val()), '')
			, expertIdList : arrExpert
			, consultTypeCdList : arrConsultType
			, statusCdList : ['02', '03', '04', '07', '08']
		};
		
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectExpertPrvtConsultForDayList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : jsonParam
			, async : true
			, spinner : true
			, success : function(data){
				if (data != null && Array.isArray(data['resultList']) && data['resultList'].length > 0) {
					data['resultList'].forEach(function(item){
						var rsrvTime = new Date(item['rsrvDate'].substring(0, 4), item['rsrvDate'].substring(4, 6)-1, item['rsrvDate'].substring(6, 8), item['rsrvTime'].substring(0, 2), item['rsrvTime'].substring(2, 4), 0);
						var completeTime = new Date(item['rsrvDate'].substring(0, 4), item['rsrvDate'].substring(4, 6)-1, item['rsrvDate'].substring(6, 8), item['rsrvTime'].substring(0, 2), item['rsrvTime'].substring(2, 4), 0);
						completeTime.setMinutes(completeTime.getMinutes() + 20);
						
						var statusColor = 'color1';
						var nTime = new Date();
						if (item['statusCd'] == '07') {
							statusColor = 'color2';
						} else if (item['statusCd'] == '08') {
							statusColor = 'color3';
						} else if (nTime < completeTime) {
							statusColor = 'color5';
						}
						
						var prvtConsultId = item['chatId'] != null ? item['chatId'] : item['roomId'] != null ? item['roomId'] : item['prvtConsultId'];
						$('#td' + item['rsrvTime']).append(
							'<span id="' + prvtConsultId + '_' + item['rsrvDate'] + item['rsrvTime'] + '" class="ico_cir ' + statusColor + '" onclick="openPrvtPopup(\'' + item['prvtConsultId'] + '\');">' + item['expertNm'] + '</span>'
						);
					});
				}
				
				callChatConsultApi(jsonParam);
				callVideoConsultApi(jsonParam);
			}
		});
	}

	// 채팅 상담 이력 조회 API
	function callChatConsultApi(jsonParam) {
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/callChatConsultApi.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : jsonParam
			, async : true
			, spinner : true
			, success : function(data){
				console.log('CHAT : ', data['result']);
				
				if (data && data['result']['data']['ticket_list'] && Array.isArray(data['result']['data']['ticket_list'])) {
					var nDate = new Date();
					var ticketList = data['result']['data']['ticket_list'];
					
					$('.formTable span').each(function(index, item){
						if ($(item).hasClass('ico_cir')) {
							var chatId = $(item).attr('id').split('_')[0];
							var rsrvDateTime = $(item).attr('id').split('_')[1];
							var rsrvDateFrom = new Date(rsrvDateTime.substring(0, 4), rsrvDateTime.substring(4, 6) - 1, rsrvDateTime.substring(6, 8), rsrvDateTime.substring(8, 10), rsrvDateTime.substring(10, 12), 0);
							var rsrvDateTo = new Date(rsrvDateTime.substring(0, 4), rsrvDateTime.substring(4, 6) - 1, rsrvDateTime.substring(6, 8), rsrvDateTime.substring(8, 10), rsrvDateTime.substring(10, 12), 0);
							rsrvDateTo.setMinutes(rsrvDateTo.getMinutes() + 20);
							ticketList.forEach(function (ticket) {
								// 채팅 상담은 로그 자체가 존재하면 시작한것으로 판단
								if (chatId == ticket['option04']) {
									if (nDate > rsrvDateTo) {
										$(item).attr('class', 'ico_cir color1');
									} else if (nDate > rsrvDateFrom) {
										$(item).attr('class', 'ico_cir color4');
									}
								}
							});
						}
					});
				}
			}
		});
	}

	// 화상 상담 이력 조회 API
	function callVideoConsultApi(jsonParam) {
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/callVideoConsultApi.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : jsonParam
			, async : true
			, spinner : true
			, success : function(data){
				console.log('VIDEO : ', data);
				
				if (data != null && Array.isArray(data['result']['result'])) {
					var nDate = new Date();
					var list = data['result']['result'];
					
					$('.formTable span').each(function(index, item) {
						if ($(item).hasClass('ico_cir')) {
							var roomId = $(item).attr('id').split('_')[0];
							var rsrvDateTime = $(item).attr('id').split('_')[1];
							var rsrvDateFrom = new Date(rsrvDateTime.substring(0, 4), rsrvDateTime.substring(4, 6) - 1, rsrvDateTime.substring(6, 8), rsrvDateTime.substring(8, 10), rsrvDateTime.substring(10, 12), 0);
							var rsrvDateTo = new Date(rsrvDateTime.substring(0, 4), rsrvDateTime.substring(4, 6) - 1, rsrvDateTime.substring(6, 8), rsrvDateTime.substring(8, 10), rsrvDateTime.substring(10, 12), 0);
							rsrvDateTo.setMinutes(rsrvDateTo.getMinutes() + 20);
							list.forEach(function (data){
								// 참석자가 2 이상인 경우
								if (roomId == data['roomId'] && data['participant'].length > 1) {
									if (nDate > rsrvDateTo) {
										$(item).attr('class', 'ico_cir color1');
									} else if (nDate > rsrvDateFrom) {
										$(item).attr('class', 'ico_cir color4');
									}
								}
							});
						}
					});
				}
			}
		});
	}

	function openPrvtPopup(prvtConsultId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPrvtConsultRatingPopup.do" />'
			, params : {
				prvtConsultId : prvtConsultId
			}
		});
    }
	
	function setPrevDate() {
		var selectDate = new Date($('#selectDate').val());
		selectDate.setDate(selectDate.getDate() - 1);
		$('#selectDate').val(getFormatFromDate(selectDate, '.'));
		
		$("#selectDate").trigger('change');
	}

	function setNextDate() {
		var selectDate = new Date($('#selectDate').val());
		selectDate.setDate(selectDate.getDate() + 1);
		$('#selectDate').val(getFormatFromDate(selectDate, '.'));
		
		$('#selectDate').trigger('change');
	}

	// 전문가 선택 팝업
    function openExpertSelectListPopup() {
    	var expertIds = (selectExpert || []).map(function(item){
			return item['expertId'];
		});
    	
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertSelectListPopup.do" />'
			, params : {
				expertIds : expertIds ? expertIds.join(',') : ''
			}
			, callbackFunction : function(resultObj){
				selectExpert = [];
				
				var selectExpertId = resultObj['selectExpertId'];
				var expertNm = resultObj['expertNm'];
				
				if (expertNm.length < 1) {
					$('#searchExpertNm').val('전체');
				} else {
					$('#searchExpertNm').val(expertNm.join(','));
				}
				
				selectExpert = selectExpertId;
				
				getList();
			}
		});
    }
	
	// 상담분야 선택 팝업
    function openConsultSelectListPopup() {
    	var consultTypeCds = (selectConsultType || []).map(function(item){
			return item['consultTypeCd'];
		});
		
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/consultSelectListPopup.do" />'
			, params : {
				consultTypeCds : consultTypeCds ? consultTypeCds.join(',') : ''
			}
			, callbackFunction : function(resultObj){
				selectConsultType = [];
				
				var selectConsultTypeCd = resultObj['selectConsultType'];
				var consultTypeNm = resultObj['consultTypeNm'];
				
				if (consultTypeNm.length < 1) {
					$('#searchConsultTypeNm').val('전체');
				} else {
					$('#searchConsultTypeNm').val(consultTypeNm.join(','));
				}
				
				selectConsultType = selectConsultTypeCd;
				
				getList();
			}
		});
    }
	
	// 초기화
	function resetPrvtConsult() {
		selectExpert = [];
		selectConsultType = [];
		
		$('#searchExpertNm').val('전체');
		$('#searchConsultTypeNm').val('전체');
		
		getList();
	}

	// 전문가 초기화
	function resetSelectExpert() {
		selectExpert = [];
		$('#searchExpertNm').val('전체');
		
		getList();
	}
	
	// 상담분야 초기화
	function resetSelectConsultType() {
		selectConsultType = [];
		$('#searchConsultTypeNm').val('전체');
		
		getList();
	}
	
	// 날짜 변경 시 처리
	function changeSelectDate() {
		$('.scheduleCalendar td').each(function(index, item){
			if ($(item).hasClass('bg')) {
				$(item).removeClass('bg');
			}
		});
		
		if ($('#selectDate').val() == getFormatFromDate(new Date(), '.')) {
			var nTime = new Date().getHours();
			var nMin = new Date().getMinutes();
			nMin = (nMin < 20) ? '00' : (nMin < 40) ? '20' : '40';
			
			$('#td' + ((nTime < 10) ? '0' + nTime : nTime) + nMin).addClass('bg');
		}
		
		getList();
	}
	
	function doSearchAiConsult(reqContents) {
		$('#reqContents').val(reqContents);
		$('#aiConsultForm').submit();
	}
</script>