<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link type="text/css" href="<c:url value='/lib/fullcalendar/main.css' />" rel="stylesheet" />
<style type="text/css">
	.btn_group_top {position: absolute;top: 0;right: 0;}
	.dateSelector {text-align: center;margin: 3px 0 15px;}
	.dateSelector span.date,
	.dateSelector input[type="text"][readonly] {background: #fff;}
	.dateSelector input[type="text"]:focus {outline: none;}
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

	.bizCalendar {display: flex;align-items: stretch;flex-wrap: wrap;}
	.bizCalendar .formTable {margin: 0;}
	.bizCalendar .formTable tr {border-bottom: 1px solid #ccc;}
	.bizCalendar .formTable tr:first-child {border-bottom: 2px solid #ccc;}
	.bizCalendar .formTable th {border: 0;}
	.bizCalendar .formTable th:first-child {border-right: 1px solid #ccc;}
	.bizCalendar .formTable td {text-align: center; height: 90px; border: 0; padding:0;}
	.bizCalendar .formTable td:hover{cursor: pointer; background: floralwhite; transition: all 0.2s;}
	.bizCalendar .formTable td .detail {background: #f7f7f7; width: 100%; height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #5C5F68; font-size: 14px; line-height: 20px; padding: 0 10px;}
	.bizCalendar .formTable td .detail p {font-size: 16px; font-weight: 700; padding-top: 10px;}
	.bizCalendar .formTable td .detail p span {margin-left: 10px; font-size: 12px; font-weight: 500; color: #fff; background-color: #2B5075; padding: 2px 10px; border-radius: 11px; vertical-align: top; }
	.bizCalendar .formTable td .detail p.color1{color: #64a4df;}
	.bizCalendar .formTable td .detail p.color2{color: #F54B4B;}
	.bizCalendar .formTable td .detail ul {margin: 10px 0;}
	.status{margin: 20px 0 10px;}
	.status ul li {width:calc((100% - 41px) / 3); display: inline-block;}
	.status ul li+li {margin-left: 10px;}
	.status .box {text-align: center; border: 1px solid #254C71; border-radius: 6px; overflow: hidden; padding: 8px 0;}
	.status .box span{padding: 10px 0; font-size: 16px; line-height: 20px;}
	.status .box span.num{font-size: 20px; font-weight: 900; margin-left: 10px;}
	.status .box span.cancel{color: #B8B8B8;}
	.status .box span.bg {background-color: #f4f4f4; border-top: 1px solid #D0D0D0;}
	#scroll_div tr{cursor: pointer;}
    #canvas { height: 100%;}
    .noClass span{word-break: keep-all;}
    .qrBtn {border-radius: 6px; font-size: 16px; line-height: 20px; font-weight: 700; }
    .ui-datepicker-calendar > tbody td:first-child a {color: #f00; }
	.ui-datepicker-calendar > tbody td:last-child a {color: blue; }
</style>
<script type="text/javascript" src="<c:url value='/lib/fullcalendar/main.js' />"></script>
<!-- 페이지 위치 -->
<div class="location compact dashboard_center">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="search">
		<div class="dateSelector" style="text-align: center;">
			<button type="button" onclick="setPrevDate();" class="btn_standard" style="border-radius: 3px;"><span class="prev"></span></button>
			<input type="text" id="selectDate"   class="datepicker changeCalender" readonly="readonly" />
			<button type="button" onclick="setNextDate();" class="btn_standard" style="border-radius: 3px;"><span class="next"></span></button>
			<input type="hidden" id="baseDay" name="baseDay" value="<c:out value="${today}" />" />
		</div>
	</div>

	<div class="mr-10" style="position: absolute; right: 0px;" >
		<button type="button" onclick="qrPopup();" class="btn_tbl_border btn_modify_auth qrBtn" >QR코드 확인</button>
	</div>

</div>

<div class="status">
	<ul>
		<c:forEach var="item_1" items="${biz0003}" varStatus="itemStatus">
		<c:if test="${item_1.codeKey ne '3'}" >
		<li>
			<div class="box">
				<span><c:out value="${item_1.codeText}" /></span>
				<c:if test="${item_1.codeKey eq '0'}" >
					<span class="num" id="status_code_0" ><c:out value="${statusList[0].status1}" /></span>
				</c:if>
				<c:if test="${item_1.codeKey eq '1'}" >
					<span class="num" id="status_code_1" ><c:out value="${statusList[0].status2}" /></span>
				</c:if>
				<c:if test="${item_1.codeKey eq '2'}" >
					<span class="num cancel" id="status_code_2" ><c:out value="${statusList[0].status3}" /></span>
				</c:if>
			</div>
		</li>
		</c:if>
		</c:forEach>
	</ul>
</div>

<div class="cont_block">
	<div style="width: 100%; height: 100%;">
		<div class="bizCalendar">
			<table class="formTable">
				<colgroup>
					<col style="width: 90px;"/>
					<col />
					<col />
					<col />
					<col />
					<col />
					<col />
					<col />
					<col />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="col">회의실</th>
						<c:forEach var="item1" items="${biz0001}" varStatus="status1">
							<th scope="col"><c:out value="${fn:substring(item1.codeText,0,2)}~${fn:substring(item1.codeText,8,10)} "/></th>
						</c:forEach>
					</tr>
						<c:forEach var="item2" items="${bizRoomList}" varStatus="status2">
					<tr>
						<c:if test="${item2.appYn eq 'Y' and item2.useYn eq 'Y'}" >
						<th scope="col"><c:out value="${item2.roomNumber}"/></th>
						</c:if>

						<c:forEach var="item3" items="${biz0001}" varStatus="status3">
						<td id="biz_<c:out value="${item2.bizCenterSeq}"/>_<c:out value="${item3.codeKey}"/>"></td>
						</c:forEach>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">현재 승인대기 중 예약건 ( <c:out value="${fn:length(waitList)}"/>건 )</h3>
	</div>

	<div id="scroll_div">
	<table class="formTable">
		<colgroup>
			<col style="width:3%" />
			<col style="width:8%" />
			<col style="width:10%" />
			<col style="width:8%" />
			<col style="width:5%" />
			<col style="width:8%" />
			<col />
			<col style="width:10%" />
			<col style="width:8%" />
			<col style="width:8%" />
			<col style="width:5%" />
		</colgroup>
		<thead>
			<tr>
				<th>No</th>
				<th>예약일</th>
				<th>이용시간</th>
				<th>회의실 위치</th>
				<th>회의실</th>
				<th>사무기기 이용</th>
				<th>업체명</th>
				<th>신청자</th>
				<th>휴대전화</th>
				<th>신청일</th>
				<th>상태</th>
			</tr>
		</thead>
		<tbody>

		<c:forEach var="waitItem" items="${waitList}" varStatus="waitStatus">
			<tr onclick="goViewPage('<c:out value="${waitItem.bizAppSeq}" />', '<c:out value="${waitItem.useYmd}" />' )">
				<td class="align_ctr"><c:out value="${fn:length(waitList) - waitStatus.index}"/></td>
				<td class="align_ctr">
					<fmt:parseDate value="${waitItem.useYmd}" var="dateValue" pattern="yyyyMMdd"/>
					<fmt:formatDate value="${dateValue}" pattern="yyyy-MM-dd"/>
				</td>
				<td><c:set var="useTimeSplit" value="${fn:split(fn:trim(waitItem.useTime),',') }"/>
					<c:forEach var="useTime" items="${useTimeSplit}" varStatus="t">
					<c:if test="${not empty useTime}">
					<p class="align_ctr">
						<c:if test="${not t.last}"><c:out value="${fn:trim(useTime)}:00 ~ ${fn:trim(useTime+1)}:00"/><br/></c:if>
						<c:if test="${t.last}"><c:out value="${fn:trim(useTime)}:00 ~ ${fn:trim(useTime+1)}:00"/></c:if>
					</p>
					</c:if>
					<c:if test="${empty useTime}"><p class="align_ctr">-</p></c:if>
					</c:forEach></td>
				<td class="align_ctr"> <c:out value="${waitItem.locationStr}" /></td>
				<td class="align_ctr">
					<c:if test="${not empty waitItem.roomNumber}"> <c:out value="${waitItem.roomNumber}" /> </c:if>
					<c:if test="${empty waitItem.roomNumber}"><p class="align_ctr">-</p></c:if>
				</td>
				<td class="align_ctr"> <c:out value="${waitItem.vce}" /> </td>
				<td class="align_ctr">
					<c:if test="${not empty waitItem.corpName}"> <c:out value="${waitItem.corpName}" /> </c:if>
					<c:if test="${empty waitItem.corpName}"><p class="align_ctr">-</p></c:if>
				</td>
				<td class="align_ctr"><c:out value="${waitItem.userNm}" />  </td>
				<td class="align_ctr">
					${fn:substring(waitItem.mobileNo,0,3) }-${fn:substring(waitItem.mobileNo,3,7) }-${fn:substring(waitItem.mobileNo,7,11) }
				</td>
				<td class="align_ctr"> ${fn:substring(waitItem.appYmdhms,0,10)}</td>
				<td class="align_ctr"> <c:out value="${waitItem.useStatusStr}" /></td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	</div>
</div>

<form id="form1" name="form1" method="post" onsubmit="return false;">
<input type="hidden" id="location" name="location" value="0">
<input type="hidden" id="useYmd" name="useYmd" >
<input type="hidden" id="selectYmd" name="selectYmd" >
<input type="hidden" id="bizAppSeq" name="bizAppSeq" >
</form>

<script type="text/javascript">
var f = document.form1;

var emptyTable ="";
var changeTable ="";
var selectDate = $("#selectDate"); 

// 휴일 달력 데이터
var disabledDays = new Array();
<c:if test ="${not empty  holidayList}" >
	<c:forEach items="${holidayList}" var="item">
		disabledDays.push("${item.hdayYmdStr}");
	</c:forEach>
</c:if>

$(document).on("click", "td[id^='biz_']", function(){
	if ( $(this).find("div").length > 0 ){
	}else{
		goWrite($(this).attr("id"));
	}
});


//datepicker 셋팅
$(document).ready(function(){

	$('table tr').mouseover(function(){
		$(this).css("backgroundColor","rgb(234, 238, 239)");
	});
	$('table tr').mouseout(function(){
		$(this).css("backgroundColor","#fff");
	});

	$('#selectDate').datepicker('destroy');
	$( "#selectDate" ).datepicker({
		  showOn: "both",
		  changeMonth: true,
		  changeYear: true,
		  nextText: '다음 달',
		  prevText: '이전 달',
		  dateFormat: "yy-mm-dd",
		  showMonthAfterYear: true ,
		  dayNamesMin: ['일','월', '화', '수', '목', '금', '토' ],
		  monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		  constrainInput: true,
		  beforeShowDay: holidayChk //휴일 데이터 확인

	});
	$('#selectDate').val( $("#baseDay").val() );
	$('#selectDate').attr("onchange", 'changeSelectDate()');

	// 처음 달력 테이블
	emptyTable = $(".bizCalendar tbody").html();
	changeSelectDate();
});

// 달력 휴일설정
function holidayChk(date) {
	var year = date.getFullYear();
	var month = date.getMonth() + 1;
	var day = date.getDate();

	if ( month < 10 ) month = "0" + month ;
	if ( day < 10 ) day = "0" + day ;

	if ( disabledDays.length > 0 ){
	    for (i = 0; i < disabledDays.length; i++) {
	        if($.inArray(year +"-"+ month +"-"+ day, disabledDays) != -1) {
	            return [false, "date-holiday"];
	        }else{
	        	return [true];
	        }
	    }
	}else{
		return [true];
	}
}

//달력 이전 버튼
function setPrevDate() {
	var prevFlag = true;
	$(".bizCalendar tbody").html(emptyTable);
	var selectDate = new Date($('#baseDay').val());
	selectDate.setDate(selectDate.getDate() - 1);
	var year = selectDate.getFullYear();
	var month = selectDate.getMonth() + 1;
	var day = selectDate.getDate();

	if ( month < 10 ) month = '0' + month;
	if ( day < 10 ) day = '0' + day;

	if ( disabledDays.length > 0 ){
		for (var i = 0; i < disabledDays.length; i++) {
			if($.inArray( year +'-' + month +'-'+ day, disabledDays) != -1 ) {
				prevFlag = false;
			}
		}
	}
	if (prevFlag ){
		$('#baseDay').val(year + '-' + month + '-' + day);
		$('#selectDate').val(year + '-' + month + '-' + day);
		changeSelectDate();
	}
}

//달력 다음 버튼
function setNextDate() {
	var nextFlag = true;
	$(".bizCalendar tbody").html(emptyTable);

	var selectDate = new Date($('#baseDay').val());
	selectDate.setDate(selectDate.getDate() + 1);
	var year = selectDate.getFullYear();
	var month = selectDate.getMonth() + 1;
	var day = selectDate.getDate();

	if (month < 10) month = '0' + month;
	if (day < 10) day = '0' + day;

	if ( disabledDays.length > 0) {
		for (var i = 0; i < disabledDays.length; i++) {
			if($.inArray( year +'-' + month +'-'+ day, disabledDays) != -1 ) {
				nextFlag = false;
			}
		}
	}

	if (nextFlag ){
		$('#baseDay').val(year + '-' + month + '-' + day);
		$('#selectDate').val(year + '-' + month + '-' + day);
		changeSelectDate();
	}
}
// 달력 날짜 변경 후
function changeSelectDate() {
	$('#baseDay').val($('#selectDate').val());
	$('#selectYmd').val($('#selectDate').val());
	$('#useYmd').val($('#selectDate').val());
	$(".bizCalendar tbody").html(emptyTable);

	global.ajax({
		type : 'POST'
		, url : '<c:url value="/bizCenter/management/dashboardSearchDay.do" />'
		, data : $('#form1').serialize()
		, dataType : 'json'
		, async : true
		, spinner : true
		, success : function(data){
			fn_statusCnt(data.statusList[0]);
			fn_calendarShow(data.resultList);
		}
	});
}

//달력에 예약 내역 불러오기
function fn_calendarShow(list) {
	// 예약 대기, 완료
	for (var i =0 ; list.length > i; i ++){
		var obj = list[i];
		var useTime = '';

		if ( obj.useTime.split(",").length > 1 ){
			useTime = obj.useTime.split(",");
		}

		var htmlStr ="";
		var useStatusStr ="";
		var useStatusClass ="";

		if( obj.useStatus == '0' ){
			useStatusStr = "예약대기";
			useStatusClass ="color1";
		}else if ( obj.useStatus =='1' ){
			useStatusStr = "예약완료";
			useStatusClass ="noClass";
		}else{
			useStatusStr = "예약대기";
			useStatusClass ="color1";
		}
		if ( obj.useStatus != '2'){
	 		if ( useTime.length > 1){
				for (var j=0; useTime.length > j; j++  ){
					htmlStr = "<div class='detail'  onclick='goViewPage("+obj.bizAppSeq+", "+obj.useYmd+")' ><p class='"+useStatusClass+"'>"+ useStatusStr;
					if (obj.vce == 'Y'){
						htmlStr += "<span>화상</span></p>";
					}else{
						htmlStr += "</p>"
					}
					if ( obj.corpName == null ){
						obj.corpName = "-";
					}
					htmlStr += "<ul><li>"+obj.corpName+"</li><li>"+obj.userNm+"</li></ul></div>"

					if ( j > 0){
						$("#biz_"+obj.calBizCenterSeq+"_"+useTime[j]).remove();
					}
					$("#biz_"+obj.calBizCenterSeq+"_"+useTime[j]).attr("colspan",useTime.length);
					$("#biz_"+obj.calBizCenterSeq+"_"+useTime[j]).html(htmlStr);
				}
			}else{
				htmlStr = "<div class='detail'  onclick='goViewPage("+obj.bizAppSeq+", "+obj.useYmd+")' ><p class='"+useStatusClass+"'>"+ useStatusStr;
				if (obj.vce == 'Y'){
					htmlStr += "<span>화상</span></p>";
				}else{
					htmlStr += "</p>"
				}
				if ( obj.corpName == null ){
					obj.corpName = "-";
				}
				htmlStr += "<ul><li>"+obj.corpName+"</li><li>"+obj.userNm+"</li></ul></div>"
				$("#biz_"+obj.calBizCenterSeq+"_"+obj.useTime).html(htmlStr);
			}
		}
	}

	// 예약 취소
	for (var k =0 ; list.length > k; k ++){
		var obj = list[k];
		var useTime = obj.useTime.split(",");
		var htmlStr ="";
		var useStatusStr ="";
		var useStatusClass ="";

		 if( obj.useStatus == '2' ){
			useStatusStr = "예약취소";
			useStatusClass ="color2";
		}else{
			useStatusStr = "예약대기";
			useStatusClass ="color1";
		}

		 if ( obj.useStatus == '2'){
	 		if ( useTime.length > 1){
	 			var trueCnt = 0;
				for (var l=0; useTime.length > l; l++  ){

					 if ( $("#biz_"+obj.calBizCenterSeq+"_"+useTime[l]).find('div').length > 0  ){
					 }else{
						 trueCnt ++;
					 }

					 if ( trueCnt == useTime.length ){
						htmlStr = "<div class='detail'  onclick='goViewPage("+obj.bizAppSeq+", "+obj.useYmd+")' ><p class='"+useStatusClass+"'>"+ useStatusStr;
						if (obj.vce == 'Y'){
							htmlStr += "<span>화상</span></p>";
						}else{
							htmlStr += "</p>"
						}
						if ( obj.corpName == null ){
							obj.corpName = "-";
						}
						htmlStr += "<ul><li>"+obj.corpName+"</li><li>"+obj.userNm+"</li></ul></div>"
						for ( var m=1;   useTime.length > m; m++ ){
							$("#biz_"+obj.calBizCenterSeq+"_"+useTime[m]).remove();
						}
						$("#biz_"+obj.calBizCenterSeq+"_"+useTime[l-useTime.length+1]).attr("colspan",useTime.length);
						$("#biz_"+obj.calBizCenterSeq+"_"+useTime[l-useTime.length+1]).html(htmlStr);
					 }
				}
	 		}else{
				htmlStr = "<div class='detail'  onclick='goViewPage("+obj.bizAppSeq+", "+obj.useYmd+")' ><p class='"+useStatusClass+"'>"+ useStatusStr;
				if (obj.vce == 'Y'){
					htmlStr += "<span>화상</span></p>";
				}else{
					htmlStr += "</p>"
				}
				if ( obj.corpName == null ){
					obj.corpName = "-";
				}
				htmlStr += "<ul><li>"+obj.corpName+"</li><li>"+obj.userNm+"</li></ul></div>"

				if ( $("#biz_"+obj.calBizCenterSeq+"_"+useTime).find('div').length > 0 ){
				}else{
					$("#biz_"+obj.calBizCenterSeq+"_"+useTime).html(htmlStr);
				}
	 		}
		 }
	}
	// 조회된 예약 리스트 tbody 저장
	changeTable = $(".bizCalendar tbody").html();
}

function fn_statusCnt(cntList) {
	$("#status_code_0").text(cntList.status1);
	$("#status_code_1").text(cntList.status2);
	$("#status_code_2").text(cntList.status3);
}


function goViewPage(seq, ymd) {
	var url = "/bizCenter/reservation/view.do";
	var bizAppSeq = seq
	var useYmd = $("#selectYmd").val();

	if ( ymd != "" &&  ymd.length > 6  ){
		f.useYmd.value = ymd;
	}else{
		f.useYmd.value = useYmd;
	}
	f.bizAppSeq.value = bizAppSeq;

	f.action = url;
	f.target = '_self';
	f.submit();
}

function goWrite(clickId) {

	var newForm = $('<form></form>');
	newForm.attr("name","newForm");
	newForm.attr("method","post");
	newForm.attr("action","/bizCenter/reservation/write.do");
	newForm.attr("target","_self");
	newForm.append($('<input/>', {type: 'hidden', name: 'useYmd', value: $("#useYmd").val()  }));
	newForm.append($('<input/>', {type: 'hidden', name: 'selectYmd', value: $("#selectYmd").val() }));
	newForm.append($('<input/>', {type: 'hidden', name: 'bizAppSeq', value: $("#bizAppSeq").val() }));
	newForm.append($('<input/>', {type: 'hidden', name: 'returnParam', value: clickId }));
	newForm.appendTo('body');
	newForm.submit();

}
function qrPopup() {
	global.openLayerPopup({
		popupUrl : '<c:url value="/bizCenter/reservation/qrPopup.do" />'
		, params : {
		}
		, callbackFunction : function(resultObj){
			var seq = resultObj.bizAppSeq;
			goView(seq);
		}
	});
}

function goView(seq) {

	var newForm = $('<form></form>');
	newForm.attr("name","newForm");
	newForm.attr("method","post");
	newForm.attr("action", "/bizCenter/reservation/view.do" );
	newForm.attr("target","_self");
	newForm.append($('<input/>', {type: 'hidden', name: 'bizAppSeq', value: seq }));
	newForm.append($('<input/>', {type: 'hidden', name: 'returnParam', value: "Y" }));
	newForm.appendTo('body');
	newForm.submit();

}

</script>

