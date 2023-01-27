<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style type="text/css">
	.dateSelector {text-align: center;margin: 3px 0 15px;}
	.dateSelector span.date,
	.dateSelector input[type="text"][readonly] {background: #fff;}
	.dateSelector input[type="text"]:focus {outline: none;}
	.bizCalendar {display: flex;align-items: stretch;flex-wrap: wrap;}
	.bizCalendar .formTable {margin: 0;}
	.bizCalendar .formTable tr {border-bottom: 1px solid #ccc;}
	.bizCalendar .formTable tr:first-child {border-bottom: 2px solid #ccc;}
	.bizCalendar .formTable th {border: 0;}
	.bizCalendar .formTable th:first-child {border-right: 1px solid #ccc;}
	.bizCalendar .formTable td {text-align: center; height: 90px; border: 0; padding:0;}
	.bizCalendar .formTable td:hover{cursor: pointer; background: floralwhite; transition: all 0.2s;}
	.bizCalendar .formTable td .detail {cursor: default; background: #f7f7f7; width: 100%; height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #5C5F68; font-size: 14px; line-height: 20px; padding: 0 10px;}
	.bizCalendar .formTable td .detail p {font-size: 16px; font-weight: 700; padding-top: 10px;}
	.bizCalendar .formTable td .detail p span {margin-left: 10px; font-size: 12px; font-weight: 500; color: #fff; background-color: #2B5075; padding: 2px 10px; border-radius: 11px; vertical-align: top;}
	.bizCalendar .formTable td .detail p.color1{color: #64a4df;}
	.bizCalendar .formTable td .detail p.color2{color: #F54B4B;}
	.bizCalendar .formTable td .detail ul {margin: 10px 0;}
	.ui-datepicker-calendar > tbody td:first-child a {color: #f00; }
	.ui-datepicker-calendar > tbody td:last-child a {color: blue; }
	.editDiv { border: 3px solid transparent;  border-image: linear-gradient(to right, #ae4444 0%, #28749b 100%); border-image-slice: 1;}
	.noClass span{word-break: keep-all;}
</style>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="doList();">목록</button>
	</div>
</div>

<form id="form1" name="form1" method="post" onsubmit="return false;">
<input type="hidden" id="location" name="location" value="0">
<input type="hidden" id="selectYmd" name="selectYmd" >
<input type="hidden" id="bizAppSeq" name="bizAppSeq" >


	<div class="cont_block">
		<table class="formTable">
			<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th><strong class="point">*</strong>예약구분</th>
					<td>
					<fieldset class="widget">
						<select id="useGubun" name="useGubun" class="form_select" isrequired="true" desc="예약구분" >
							<option value="" >--선택--</option>
							<c:forEach var="item" items="${biz0011}" varStatus="status">
								<option value="<c:out value="${item.code}"/>"><c:out value="${item.codeNm}"/></option>
							</c:forEach>
						</select>
					</fieldset>
					</td>
					<th>회사주소</th>
					<td>
						<input id="corpAddr" name="corpAddr" type="text" class="form_text w100p" readonly="readonly" desc="회사주소"/>
					</td>
				</tr>
				<tr>
					<th><strong class="point">*</strong>회사명</th>
					<td>
						<div class="field_set">
							<span class="form_search">
			               		<input name="corpName" id="corpName" type="text" class="form_text" readonly="readonly" value="" desc="회사명" maxlength="30" isrequired="true">
			               		<button type="button" class="btn_icon btn_search" onclick="viewPopup()" title="회사 검색"></button>
			               	</span>
			               	<button type="button" class="btn_tbl" onclick="directWrite();" id="inputToggle">직접입력</button>
	               		</div>
					</td>
					<th>무역업고유번호</th>
					<td>
						<input id="tradeNo" name="tradeNo" type="text" class="form_text w100p" oninput="this.value = this.value.replace(/[^0-9]/g, '');"  maxlength="8" readonly="readonly" desc="무역업고유번호"/>
					</td>
				</tr>
				<tr>
					<th><strong class="point">*</strong>대표자명</th>
					<td ><input id="ceoName" name="ceoName" type="text" class="form_text w100p"  readonly="readonly" desc="대표자명" maxlength="25" isrequired="true" /></td>
					<th><strong class="point">*</strong>사업자 등록번호</th>
					<td ><input id="corpRegNo" name="corpRegNo" type="text" class="form_text w100p" oninput="this.value = this.value.replace(/[^0-9]/g, '');" maxlength="10" readonly="readonly" desc="사업자 등록번호" isrequired="true" /></td>
				</tr>
				<tr>
					<th><strong class="point">*</strong>신청자</th>
					<td ><input id="userNm" name="userNm" type="text" class="form_text w100p"  desc="신청자" maxlength="25" isrequired="true" /></td>
					<th><strong class="point">*</strong>휴대전화</th>
					<td>
						<div class="form_row" style="width:300px;">
							<select name="coHp1" id="coHp1" class="form_select" desc="휴대전화" isrequired="true">
								<c:forEach var="list" items="${com012}" varStatus="status">
									<option value="<c:out value="${list.detailcd}" />"> <c:out value="${list.detailnm}"/> </option>
								</c:forEach>
							</select>

							<input type="text" name="coHp2" id="coHp2" size="5" oninput="this.value = this.value.replace(/[^0-9]/g, '');" maxlength="4" class="form_text" value="" desc="휴대전화" isrequired="true">
							<input type="text" name="coHp3" id="coHp3" size="5" oninput="this.value = this.value.replace(/[^0-9]/g, '');" maxlength="4" class="form_text" value="" desc="휴대전화" isrequired="true">
						</div>
					</td>
				</tr>
				<tr>
					<th><strong class="point">*</strong>회의실</th>
					<td ><input type="text" name="roomNumber" id="roomNumber"  readonly="readonly" class="form_text" value="" desc="회의실" isrequired="true" >
						 <input type="hidden" name="calRoomNumber" id="calRoomNumber"  readonly="readonly" class="form_text" value="" >
					</td>
					<th><strong class="point">*</strong> 예약 상태</th>
					<td ><input type="text" name="useStatusStr" id="useStatusStr"  readonly="readonly" class="form_text" value="" desc="예약상태" >
						 <input type="hidden" name="useStatus" id="useStatus"  readonly="readonly" class="form_text" value="" desc="예약상대코드" >
					</td>
				</tr>
				<tr>
					<th>사무기기 이용</th>
					<td> <label for="useOa_pc"> <input type="checkbox" class="form_checkbox" name="useOa" id="useOa_pc" />PC </label>
						 <label for="useOa_print"> <input type="checkbox" class="form_checkbox" name="useOa" id="useOa_print" />인쇄 </label>
						 <label for="useOa_lounge"> <input type="checkbox" class="form_checkbox" name="useOa" id="useOa_lounge" />라운지 </label>
						 <label for="useOa_scanner"> <input type="checkbox" class="form_checkbox" name="useOa" id="useOa_scanner" />스캐너 </label>
						 <label for="useOa_fax"> <input type="checkbox" class="form_checkbox" name="useOa" id="useOa_fax" />팩스 </label>
						 <label for="useOa_vce"> <input type="checkbox" class="form_checkbox" name="useOa" id="useOa_vce" />화상 </label>
					</td>
					<th>예약취소 사유</th>
					<td ><input type="text" class="form_text w100p" id="rejectReason" name="rejectReason" readonly="readonly"  desc="예약취소 사유" /></td>
				</tr>
				<tr>
					<th><strong class="point">*</strong>예약일</th>
					<td ><input type="text" class="form_text w100p" id="useYmd" name="useYmd" readonly="readonly"  desc="예약일" isrequired="true" /></td>
					<th><strong class="point">*</strong>예약시간</th>
					<td ><input type="text" class="form_text w100p" id="useTime" name="useTime" readonly="readonly"  desc="예약시간" isrequired="true" />
						<input type="hidden" class="form_text w100p" id="useTimeArry" name="useTimeArry" readonly="readonly"  />
					</td>
				</tr>
				<tr>
					<th>참석인원</th>
					<td>
					<fieldset class="widget">
						<select id="usePersons" name="usePersons" class="form_select" >
							<option value="" >--선택--</option>
							<c:forEach var="item" items="${biz0008}" varStatus="status">
								<option value="<c:out value="${item.code}"/>" ><c:out value="${item.codeNm}"/></option>
							</c:forEach>
						</select>
					</fieldset>
					</td>
					<th>소재지</th>
					<td>
					<fieldset class="widget">
						<select id="addrLocatcion" name="addrLocatcion" class="form_select" >
							<option value="" >--선택--</option>
							<c:forEach var="item" items="${biz0006}" varStatus="status">
								<option value="<c:out value="${item.code}"/>" ><c:out value="${item.codeNm}"/></option>
							</c:forEach>
						</select>
					</fieldset>
					</td>
				</tr>

			</tbody>
		</table><!-- //formTable -->
	</div>
</form>

<div class="cont_block mt-10">
<div class="search">
	<div class="dateSelector" style="text-align: center;">
		<button type="button" onclick="setPrevDate();" class="btn_standard" style="border-radius: 3px;"><span class="prev"></span></button>
		<input type="text" id="selectDate"   class="datepicker changeCalender" readonly="readonly" />
		<button type="button" onclick="setNextDate();" class="btn_standard" style="border-radius: 3px;"><span class="next"></span></button>
		<input type="hidden" id="baseDay" name="baseDay" value="<c:out value="${today}"/>" />
	</div>
</div>

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
						<!-- 09:00 ~ 10:00 -->
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

<script type="text/javascript">
var f = document.form1;

var emptyTable ="";
var changeTable ="";
var selectDate = $("#selectDate"); 
var paramClickId ="";

<c:if test="${reserveVO.searchKeyword ne ''}">
paramClickId = "<c:out value="${reserveVO.searchKeyword}"/>";
var selectDay = "<c:out value="${reserveVO.useYmd}"/>";
$("#baseDay").val(selectDay);
</c:if>

// 휴일 달력 데이터
var disabledDays = new Array();
<c:if test ="${not empty  holidayList}" >
	<c:forEach items="${holidayList}" var="item">
		disabledDays.push("${item.hdayYmdStr}");
	</c:forEach>
</c:if>

//회사명, 신청자명 변경시
$(document).on('change', '#corpName, #userNm', function(){
	$(".editDiv ul").children("li:eq(0)").text($("#corpName").val());
	$(".editDiv ul").children("li:eq(1)").text($("#userNm").val());
});

// 사무기기이용 화상 체크박스 확인
$(document).on('change', '#useOa_vce', function(){
	var html ="<p >예약완료<span>화상</span></p>";
	if ( $("input:checkbox[id='useOa_vce']").is(":checked") == true ){
		$(".editDiv p").remove();
		$(".editDiv").prepend(html);
	}else{
		$(".editDiv p span").remove();
	}
});

// 스케쥴 등록후 재선택시 삭제 여부
$(document).on('click', '.editDiv', function(){
	if ( $(this).attr('data') != 'loadData' ){
		if(!confirm("삭제하시겠습니까?")){
			return;
		}else{
			$("#roomNumber").val("");
			$("#calRoomNumber").val("");
			$("#useStatusStr").val("");
			$("#useStatus").val("");
			$("#useYmd").val("");
			$("#useTime").val("");
			$(".bizCalendar tbody").html(changeTable);

		}
	}

});

// 스케쥴 등록 시작
$(document).on("click", "td[id^='biz_']", function(){
	var htmlStr ="";
	var clickTd =  $(this).attr("id");
	var useTime = clickTd.split("_");
	var roomNum = $("#"+clickTd).parent().find("th:first").text();
	var flag = true;

	var chk_arr = [];
	$("input[name=useOa]").each(function(){
		var chk = $(this).val();
	    chk_arr.push(chk);
	});

	// 신규 등록이 아닌경우
	if ( $(this).find("div").length > 0 ){
	}else{

		if ( $(".editDiv").length > 0  ){
			if ( useTime[2] != '09'){
				var prevEl = $("#"+clickTd).prev().closest("td").find('div').hasClass('detail editDiv');
				var prevId = $("#"+clickTd).prev().closest("td").attr("id");
				var prevColSpan = parseInt($("#"+prevId).prop("colspan"));
				var prevUseTime = prevId.split("_");
			}else{
				prevEl = false;
			}

			if ( useTime[2] != '17'){
				var nextEl = $("#"+clickTd).next().closest("td").find('div').hasClass('detail editDiv');
				var nextId = $("#"+clickTd).next().closest("td").attr("id");
				var nextColSpan = parseInt($("#"+nextId).prop("colspan"));
				var nexUseTime = nextId.split("_");
			}else{
				nextEl = false;
			}

			if ( prevEl == false && nextEl == false ){ // 이전 다음 예약이 없거나 수정불가
				$(".bizCalendar tbody").html(changeTable);
			}

			if ( prevEl == true ){ // 이전 예약 현재예약 합치기
	 	 		htmlStr = "<div class='detail editDiv' data='"+$("#tradeNo").val()+"'><p>예약완료";
	 	 		if( $("#useOa_vce").is(":checked") == true){
	 				htmlStr += "<span>화상</span></p>";
	 			}else{
	 				htmlStr += "</p>"
	 			}
	 			htmlStr += "<ul><li>"+ $("#corpName").val() +"</li><li>"+ $("#userNm").val()  +"</li></ul></div>"
	 			$("#"+prevId).attr("colspan", prevColSpan+1 );
	 			$("#"+clickTd).remove();
	 			$("#"+prevId).html(htmlStr);
	 			flag = false;

	 			$("#roomNumber").val(roomNum);
	 			$("#calRoomNumber").val(useTime[1]);
	 			$("#useTime").val( parseInt(parseInt(useTime[2])-prevColSpan) +":00 ~" + parseInt(parseInt(useTime[2]) + 1) +":00 / "+parseInt(parseInt(prevColSpan)+1)+"시간" );
			}
			if ( nextEl == true ){ // 현재 예약 다음 예약 합치기

	 	 		htmlStr = "<div class='detail editDiv' data='"+$("#tradeNo").val()+"'><p >예약완료";
	 	 		if( $("#useOa_vce").is(":checked") == true){
	 				htmlStr += "<span>화상</span></p>";
	 			}else{
	 				htmlStr += "</p>"
	 			}
	 			htmlStr += "<ul><li>"+ $("#corpName").val() +"</li><li>"+ $("#userNm").val()  +"</li></ul></div>"
	 			$("#"+nextId).attr("colspan", nextColSpan+1 );
	 			$("#"+clickTd).remove();
	 			$("#"+nextId).html(htmlStr);
	 			flag = false;

	 			$("#roomNumber").val(roomNum);
	 			$("#calRoomNumber").val(useTime[1]);
	 			$("#useTime").val( parseInt(useTime[2])  +":00 ~" + parseInt(parseInt(parseInt(useTime[2])+nextColSpan)+1) +":00 / "+parseInt(parseInt(nextColSpan)+1)+"시간" );
			}
		}
			if ( flag ){
				if ( $("#corpName").val().length > 0 && $("#userNm").val().length > 0 ) {

		 	 		htmlStr = "<div class='detail editDiv' data='"+$("#tradeNo").val()+"'><p >예약완료";
		 	 		if( $("#useOa_vce").is(":checked") == true){
		 				htmlStr += "<span>화상</span></p>";
		 			}else{
		 				htmlStr += "</p>"
		 			}
		 			htmlStr += "<ul><li>"+ $("#corpName").val() +"</li><li>"+ $("#userNm").val()  +"</li></ul></div>"
		 			$("#biz_"+useTime[1]+"_"+useTime[2]).html(htmlStr);

		 			$("#roomNumber").val(roomNum);
		 			$("#calRoomNumber").val(useTime[1]);
		 			$("#useStatusStr").val("예약완료");
		 			$("#useStatus").val("0");
		 			$("#useYmd").val( $("#baseDay").val() );
		 			$("#useTime").val( useTime[2] +":00 ~" + parseInt(parseInt(useTime[2]) + 1) +":00 / 1시간" );

				}else{
		 	 		htmlStr = "<div class='detail editDiv' data='noData'><p >예약완료";
		 	 		if( $("#useOa_vce").is(":checked") == true){
		 				htmlStr += "<span>화상</span></p>";
		 			}else{
		 				htmlStr += "</p>"
		 			}
		 			htmlStr += "<ul><li></li><li></li></ul></div>"
		 			$("#biz_"+useTime[1]+"_"+useTime[2]).html(htmlStr);

		 			$("#roomNumber").val(roomNum);
		 			$("#calRoomNumber").val(useTime[1]);
		 			$("#useStatusStr").val("예약완료");
		 			$("#useStatus").val("1");
		 			$("#useYmd").val( $("#baseDay").val() );
		 			$("#useTime").val( useTime[2] +":00 ~" + parseInt(parseInt(useTime[2]) + 1) +":00 / 1시간" );
				}
			}
	}

});

// datepicker 셋팅
$(document).ready(function(){
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

	if( disabledDays.length> 0){
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

// 달력 이전 버튼
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

	if( disabledDays.length > 0){
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

	if( disabledDays.length > 0){
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
	$(".bizCalendar tbody").html(emptyTable);

	global.ajax({
		type : 'POST'
		, url : '<c:url value="/bizCenter/reservation/searchCalendarDay.do" />'
		, data : $('#form1').serialize()
		, dataType : 'json'
		, async : true
		, spinner : true
		, success : function(data){
			fn_calendarShow(data.resultList);

			if ( paramClickId !="" && paramClickId != null && paramClickId != "undefined" ){
				$("#"+paramClickId).trigger("click");
			}
		}
	});
}

// 달력에 예약 내역 불러오기
function fn_calendarShow(list) {
	for (var i =0 ; list.length > i; i ++){
		var obj = list[i];
		var useTime = obj.useTime.split(",");
		var htmlStr ="";
		var useStatusStr ="";
		var useStatusClass ="";

		if( obj.useStatus == '0' ){
			useStatusStr = "예약대기";
			useStatusClass ="color1";
		}else if ( obj.useStatus =='1' ){
			useStatusStr = "예약완료";
			useStatusClass ="noClass";
		}else if ( obj.useStatus =='2' ){
			useStatusStr = "예약취소";
			useStatusClass ="color2";
		}else{
			useStatusStr = "예약대기";
			useStatusClass ="color1";
		}

		if(obj.useStatus != '2' ){
	 		if ( useTime.length > 1){
				for (var j=0; useTime.length > j; j++  ){

					htmlStr = "<div class='detail' data='loadData'><p class='"+useStatusClass+"'>"+ useStatusStr;
					if (obj.vce == 'Y'){
						htmlStr += "<span>화상</span></p>";
					}else{
						htmlStr += "</p>"
					}
					htmlStr += "<ul><li>"+obj.corpName+"</li><li>"+obj.userNm+"</li></ul></div>"

					if ( j > 0){
						$("#biz_"+obj.calBizCenterSeq+"_"+useTime[j]).remove();
					}
					$("#biz_"+obj.calBizCenterSeq+"_"+useTime[j]).attr("colspan",useTime.length);
					$("#biz_"+obj.calBizCenterSeq+"_"+useTime[j]).html(htmlStr);
				}
			}else{
				htmlStr = "<div class='detail' data='loadData'><p class='"+useStatusClass+"'>"+ useStatusStr;
				if (obj.vce == 'Y'){
					htmlStr += "<span>화상</span></p>";
				}else{
					htmlStr += "</p>"
				}
				htmlStr += "<ul><li>"+obj.corpName+"</li><li>"+obj.userNm+"</li></ul></div>"
				$("#biz_"+obj.calBizCenterSeq+"_"+useTime).html(htmlStr);
			}
		}
	}
	// 조회된 예약 리스트 tbody 저장
	changeTable = $(".bizCalendar tbody").html();
}

//직접입력
function directWrite() {
	$("#corpName").val("");
	$("#corpName").trigger("change");
	$("#tradeNo").val("");
	$("#ceoName").val("");
	$("#corpRegNo").val("");

	if ( $("#corpName").prop("readonly") == true ){
		$("#corpName").prop("readonly", false);
		$("#tradeNo").prop("readonly", false);
		$("#ceoName").prop("readonly", false);
		$("#corpRegNo").prop("readonly", false);
		$("#inputToggle").html("검색하기");
	}else{
		$("#corpName").prop("readonly", true);
		$("#tradeNo").prop("readonly", true);
		$("#ceoName").prop("readonly", true);
		$("#corpRegNo").prop("readonly", true);
		$("#inputToggle").html("직접입력");
	}
}

// 회사명 popup
function viewPopup() {
	var flag = false;
	if ( $("#corpName").prop("readonly") == true ){
		flag = true;
	}
	if (flag){
		global.openLayerPopup({
			popupUrl : '<c:url value="/bizCenter/reservation/companyPopup.do" />'
			, params : {
			}
			, callbackFunction : function(resultObj){
				f.corpName.value = resultObj.companyKor ;
				f.ceoName.value = resultObj.presidentKor ;
				f.tradeNo.value = resultObj.memberId ;
				f.corpRegNo.value = resultObj.enterRegNo ;
				f.corpAddr.value = resultObj.corpAddr ;
				$("#corpName").trigger("change");
			}
		});
	}
}

function isValid() {
	var result = true;

	$(".formTable").find("input, select").each(function(i) {
        var selectId = $(this).prop("id");
        var chkId = $("#"+selectId);

        if( chkId.attr("isrequired") ) {
            if(trim(chkId.val()) == "" ) {
                var desc = chkId.attr("desc");
                result = false;
                alert(desc +" 필수 입력입니다.");
                return false;
            }
        }
    });
    return result;
}
function isValidDate() {
	var result = true;

	var today = new Date();
	var year = today.getFullYear(); // 년도
	var month = today.getMonth() + 1;  // 월
	var day = today.getDate();  // 날짜
	if ( month < 10 ) month = "0" + month ;
	if ( day < 10 ) day = "0" + day ;
	var todayStr = year +"-"+ month +"-"+ day

	var date1 = new Date( year +"-"+ month +"-"+ day );
	var date2 = new Date(  $("#useYmd").val() );

	if (date2 < date1){
		result = false;
		alert("이전 일자는 예약 할수없습니다.");
		return false;
	}
	return result;
}

function doSave() {

	if( !isValidDate() ) {return;};
	if( !isValid() ) {return;};

	var useOaArr = [];
	$("input[name=useOa]").each(function(){
		 if(this.checked){
			 useOaArr.push("1");
		 }else{
			 useOaArr.push("0");
		 }
	});

	var useTimeArr =[];
	var tdId =  $(".editDiv").parents('td').attr('id');
	var timeSplit = tdId.split('_');
	var colspan =  parseInt( $(".editDiv").parents('td').prop('colspan'), 10 );

	for (var i=0;  colspan > i; i++ ){
		useTimeArr.push( parseInt(parseInt(timeSplit[2])+i) );
	}

	if (confirm('해당 내용을 예약하시겠습니까?')) {
		global.ajax({
			  type : 'POST'
			, url : '<c:url value="/bizCenter/reservation/viewForComplete.do" />'
			, data : {  location : $("#location").val()
						,useGubun : $("#useGubun").val()
						,corpName : $("#corpName").val()
						,tradeNo : $("#tradeNo").val()
						,ceoName : $("#ceoName").val()
						,corpRegNo : $("#corpRegNo").val()
						,userNm : $("#userNm").val()
						,mobileNo : $("#coHp1").val()+$("#coHp2").val()+$("#coHp3").val()
						,calBizCenterSeq : parseInt($("#calRoomNumber").val())
						,useStatus : "1"
						,useYmd : $("#useYmd").val()
						,useTime : useTimeArr
						,useOa : useOaArr
						,rejectReason : $("#rejectReason").val()
						,usePersons : $("#usePersons").val()
						,userGubun : $("#addrLocatcion").val()
					}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if (data.msg == "Success"){
					var url = "/bizCenter/reservation/view.do";
					f.location.value = $("#location").val();
					f.bizAppSeq.value = data.bizAppSeq;
					f.useYmd.value = $("#selectYmd").val();
					f.action = url;
					f.target = '_self';
					f.submit();
					}
				}
		});
	}
}

function doList() {
	var searchStartDt = "<c:out value="${reserveVO.searchStartDt}" />";
	var searchEndDt = "<c:out value="${reserveVO.searchEndDt}" />";

	var newForm = $('<form></form>');
	newForm.attr("name","newForm");
	newForm.attr("method","post");
	newForm.attr("action","/bizCenter/reservation/list.do");
	newForm.attr("target","_self");
	newForm.append($('<input/>', {type: 'hidden', name: 'searchStartDt', value: searchStartDt  }));
	newForm.append($('<input/>', {type: 'hidden', name: 'searchEndDt', value: searchEndDt }));
	newForm.appendTo('body');
	newForm.submit();

}

</script>