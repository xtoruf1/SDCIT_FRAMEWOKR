<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<style type="text/css">
table {
	text-align: center;
}
</style>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value=""/>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doExcel();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="clearForm('foldingTable_inner');" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="getList();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="cont_block">
	<div class="foldingTable fold">
		<div class="foldingTable_inner">
			<table class="formTable">
				<colgroup>
					<col style="width:15%;" />
					<col />
					<col style="width:15%;" />
					<col />
					<col style="width:15%;" />
					<col />
				</colgroup>
				<tr>
					<th>포상명</th>
					<td>
						<span class="form_search">
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>"/>
							<input type="text" id="searchBsnNm" name="searchBsnNm" class="form_text" value="<c:out value="${searchBsnNm}"/>" style="font-size:14px;" readonly>
							<button type="button" class="btn_icon btn_search" title="포상검색" onclick="openLayerDlgSearchAwardPop();"></button>
						</span>
					</td>
					<th>조회일자</th>
					<td colspan="3">
						<div class="group_datepicker">
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="searchStartDate" name="searchStartDate" value="<c:out value="${searchStartDate}"/>" class="txt datepicker" placeholder="시작일" title="시작일" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyStartDate" value="" />
								</span>
								<button type="button" onclick="clearPickerValue('searchStartDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
							<div class="spacing">~</div>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="searchEndDate" name="searchEndDate" value="<c:out value="${searchEndDate}"/>" class="txt datepicker" placeholder="종료일" title="종료일" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyEndDate" value="" />
								</span>
								<button type="button" onclick="clearPickerValue('searchEndDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>

<div class="cont_block" id="dataTable">
	<table style="word-break: break-all;">
		<tr>
			<td>
				<table class="formTable" id="twoTable"></table>
			</td>
		</tr>
		<tr>
			<td style="height:15px;"></td>
		</tr>
		<tr>
			<td>
				<table>
					<colgroup>
						<col style="width:35%;">
						<col>
						<col style="width:60%;">
					</colgroup>
					<tr>
						<td rowspan="2" style="vertical-align: top;">
							<table class="formTable" id="oneTable"></table>
						</td>
						<td rowspan="2" style="width:50px;"></td>
						<td style="vertical-align: top;">
							<table class="formTable" id="threeTable"></table>
						</td>
					</tr>
					<tr>
						<td style="vertical-align:top;">
							<table class="formTable" id="fourAndFiveTable"></table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</form>

<form id="excelForm" name="excelForm" method="post">
<input type="hidden" id="htmlData" name="htmlData" value=""/>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		// 시작일 선택 이벤트
		datepickerById('searchStartDate', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('searchEndDate', toDateSelectEvent);
		getList();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchStartDate').val());
		if ($('#searchEndDate').val() != '') {
			if (startymd > Date.parse($('#searchEndDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchStartDate').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchEndDate').val());

		if ($('#searchStartDate').val() != '') {
			if (endymd < Date.parse($('#searchStartDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchEndDate').val('');

				return;
			}
		}
	}

	// 목록 가져오기
	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/agg/selectTradeDayAggregateList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				$('#oneTable').empty();
				var content = '';
				content += '<colgroup>';
				content += '	<col>';
				content += '	<col style="width:30%;">';
				content += '	<col style="width:30%;">';
				content += '</colgroup>';
				content += '<tr>';
				content += '	<td colspan="3">수출의 탑</td>';
				content += '</tr>';
				content += '<tr>';
				content += '	<th>종류</th>';
				content += '	<th>신청건수</th>';
				content += '	<th>임시저장</th>';
				content += '</tr>';

				if(data.oneList != '') {

					$(data.oneList).each(function() {
						content += '<tr>';
						content += '	<td>'+ this.prizeNm +'</td>';
						content += '	<td>'+ this.sucCnt +'</td>';
						content += '	<td>'+ this.tmpCnt +'</td>';
						content += '</tr>';
					});

				}else {
					content += '<td colspan="3">조회 결과가 없습니다.</td>';
				}

				$('#oneTable').append(content);

				$('#twoTable').empty();
				content = '';
				content += '<colgroup>';
				content += '	<col style="width:20%;">';
				content += '	<col style="width:17%;">';
				content += '	<col style="width:17%;">';
				content += '	<col style="width:17%;">';
				content += '	<col>';
				content += '</colgroup>';
				content += '<tr>';
				content += '	<th>TOTAL</th>';
				content += '	<th>신청</td>';
				content += '	<th>임시저장</th>';
				content += '	<th>합계</td>';
				content += '	<td rowspan="6" id="">';
				content += '		※ 최고 수출의탑 신청업체(신청 기준) <br/>';

				var coNmkr = '';
				var expTapPrizeNm = '';

				if(data.sixTwoList != '') {
					coNmkr = data.sixTwoList[0].coNmKr;
					expTapPrizeNm = data.sixTwoList[0].expTapPrizeNm;

				}
				content += '		- 업체명 : ' + coNmkr;
				content += '		<br/>';
				content += '		- 수출의 탑 : ' + expTapPrizeNm;
				content += '		<br/>';
				content += '		※ 최고 수출의탑 신청업체(임시저장 기준)';
				content += '		<br/>';

				coNmkr = '';
				expTapPrizeNm = '';

				if(data.sixOneList != '') {
					coNmkr = data.sixOneList[0].coNmKr;
					expTapPrizeNm = data.sixOneList[0].expTapPrizeNm;
				}
				content += '		- 업체명 : ' + coNmkr;
				content += '		<br/>';
				content += '		- 수출의 탑 : ' + expTapPrizeNm;
				content += '		<br/>';
				content += '	</td>';
				content += '</tr>';

				if(data.twoList != '') {

					$(data.twoList).each(function() {
						content += '<tr>';
						content += '	<td>'+ this.priTypeNm +'</td>';
						content += '	<td>'+ this.sucCnt +'</td>';
						content += '	<td>'+ this.tmpCnt +'</td>';
						content += '	<td>'+ this.sumCnt +'</td>';
						content += '</tr>';
					});

				}else {
					content += '<td colspan="5">조회 결과가 없습니다.</td>';
				}

				$('#twoTable').append(content);

				$('#threeTable').empty();
				content = '';
				content += '<colgroup>';
				content += '	<col style="width:25%;">';
				content += '	<col>';
				content += '	<col>';
				content += '	<col>';
				content += '	<col>';
				content += '</colgroup>';
				content += '<tr>';
				content += '	<td colspan="5">포상개수 기준 (내역)</td>';
				content += '</tr>';
				content += '<tr>';
				content += '	<th></th>';
				content += '	<th colspan="2">신청</th>';
				content += '	<th colspan="2">임시저장</th>';
				content += '</tr>';

				if(data.threeList != '') {

					$(data.threeList).each(function() {

						if(this.st == 'C') {
							content += '<tr>';
							content += '	<td>'+ this.priTypeNm +'</td>';
							content += '	<td colspan="2">'+ this.sucCnt +'</td>';
							content += '	<td colspan="2">'+ this.tmpCnt +'</td>';
							content += '</tr>';
						}else {

							content += '<tr>';
							content += '	<th></th>';
							content += '	<th>탑</th>';
							content += '	<th>포상</th>';
							content += '	<th>탑</th>';
							content += '	<th>포상</th>';
							content += '</tr>';

							content += '<tr>';
							content += '	<th>'+ this.priTypeNm +'</th>';
							content += '	<td>'+ this.sucCnt +'</td>';
							content += '	<td>'+ this.sucCntNull +'</td>';
							content += '	<td>'+ this.tmpCnt +'</td>';
							content += '	<td>'+ this.tmpCntNull +'</td>';
							content += '</tr>';
						}

					});

				}else {
					content += '<td colspan="5">조회 결과가 없습니다.</td>';
				}

				$('#threeTable').append(content);

				$('#fourAndFiveTable').empty();
				content = '';
				content += '<colgroup>';
				content += '	<col>';
				content += '	<col style="width:40%;">';
				content += '	<col style="width:40%;">';
				content += '</colgroup>';
				content += '<tr>';
				content += '	<td colspan="3">';
				content += '	기업개수 기준 (총괄)';
				content += '	</td>';
				content += '</tr>';
				content += '<tr height="25">';
				content += '	<th>&nbsp;</th>';
				content += '	<th style="text-align: center;">신청</th>';
				content += '	<th style="text-align: center;">임시저장</th>';
				content += '</tr>';

				if(data.fourList != '') {

					$(data.fourList).each(function() {
						content += '<tr>';
						content += '	<th>'+ this.detailnm +'</td>';
						content += '	<td>'+ this.sucCnt +'</td>';
						content += '	<td>'+ this.tmpCnt +'</td>';
						content += '</tr>';
					});

				}else {
					content += '<td colspan="3">조회 결과가 없습니다.</td>';
				}

				/* 같은 table tr td 이므로 four + five 한번에 */
				content += '<tr>';
				content += '<td colspan="3">&nbsp;</td>';
				content += '</tr>';

				content += '<tr>';
				content += '<th>TOTAL</th>';
				content += '<th>신청</th>';
				content += '<th>임시저장</th>';
				content += '</tr>';

				if(data.fiveList != '') {

					$(data.fiveList).each(function() {
						content += '<tr>';
						content += '	<th>'+ this.priTypeNm +'</td>';
						content += '	<td>'+ this.sucCnt +'</td>';
						content += '	<td>'+ this.tmpCnt +'</td>';
						content += '</tr>';
					});

				}else {
					content += '<td colspan="3">조회 결과가 없습니다.</td>';
				}

				content += '<tr height="25">';
				content += '<td class="td_agg" colspan="3">※ 수출의 탑 및 일반유공은 동시신청 포함</td>';
				content += '</tr>';

				$('#fourAndFiveTable').append(content);

			}
		});
	}

	/**
	 * 포상 검색(팝업)
	 */
	function openLayerDlgSearchAwardPop(){
		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/dlgSearchAwardPopup.do" />'
			, callbackFunction : function(resultObj) {
				$('#searchSvrId').val(resultObj.svrId);
				$('#searchBsnNm').val(resultObj.bsnNm);
				$('#bsnAplDt').val(resultObj.bsnAplDt);
				getList();
			}
		});
	}

	function doExcel() {
		var htmlData = $("#dataTable").html();
		$("#htmlData").val(htmlData);
		$("#excelForm").attr("action", "/tdms/agg/tradeDayAggregateExcel.do");
		$("#excelForm").submit();
	}

</script>