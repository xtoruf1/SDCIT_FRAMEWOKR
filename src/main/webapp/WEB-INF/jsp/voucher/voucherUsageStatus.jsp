<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="btnGroup ml-auto">
		<button type="button" id="btnExcel" class="btn_sm btn_primary" onclick="DoexcelDownload();">엑셀 다운</button>
		<button type="button" id="btnSearchReset" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" id="btnSave" class="btn_sm btn_primary" onclick="getVoucherUsing();">검색</button>
	</div>
</div>

<div class="cont_block">
	<form id="searchForm" method="post">
		<div class="search">
		<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
		<input type="hidden" id="vmstSeq" name="vmstSeq" value="0"/>
		<input type="hidden" id="tradeNo" name="tradeNo" value="${tradeNo}"/>
			<table class="formTable">
				<colgroup>
					<col style="width:17%" />
					<col style="width:25%" />
					<col style="width:17%" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th>대상년도</th>
						<td>
							<select name="searchBaseYear" id="searchBaseYear" class="form_select">
								<c:forEach items="${baseYearList}" var="resultInfo" varStatus="status">
									<option value="<c:out value="${ resultInfo.baseYear}" />" label="<c:out value="${ resultInfo.baseYear}" /> "/>
								</c:forEach>
							</select>
						</td>
						<th>신청일자</th>
						<td>
							<div class="group_datepicker">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchStdt" name="searchStdt" class="txt datepicker" title="시작일" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									</span>

									<!-- clear 버튼 -->
									<button type="button" class="dateClear" onclick="clearPickerValue('searchStdt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
								</div>

								<div class="spacing">~</div>

								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchEddt" name="searchEddt" class="txt datepicker" title="종료일" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									</span>

									<!-- clear 버튼 -->
									<button type="button" class="dateClear" onclick="clearPickerValue('searchEddt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
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
	<div class="tit_bar align_center">
		<h3 class="tit_block">바우처 사용 신청 현황</h3>

		<div class="ml-15">
			예산액(전체) : <span id="sapnBudgetAmt" class="ml-8"></span>
		</div>
	</div>


	<div style="width: 100%;height: 100%;">
		<div id="voucherUsingSheet" class="sheet"></div>
	</div>
</div>


<div class="cont_block">
	<div class="tit_bar">
		<h3 class="tit_block">서비스별 승인 현황</h3>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="voucherServiecUsingSheet" class="sheet"></div>
	</div>
</div>



<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_voucherUsing();				// 바우처 사용 현황 헤더
		setSheetHeader_voucherServiecUsing();		// 바우처 사용 서비스별 현황 헤더
		getVoucherUsing();							// 바우처 사용 현황 조회

		// 시작일 선택 이벤트
		datepickerById('searchStdt', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('searchEddt', toDateSelectEvent);
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchStdt').val());

		if ($('#searchEddt').val() != '') {
			if (startymd > Date.parse($('#searchEddt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchStdt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchEddt').val());

		if ($('#searchStdt').val() != '') {
			if (endymd < Date.parse($('#searchStdt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchEddt').val('');

				return;
			}
		}
	}

	function setSheetHeader_voucherUsing() {	// 바우처 사용 현황 헤더

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '등급|등급'			, Type: 'Text'				, SaveName: 'voucherLevNm'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '신청|업체수'			, Type: 'AutoSum'			, SaveName: 'reqCnt'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '신청|지원금 신청액'		, Type: 'AutoSum'			, SaveName: 'reqAmt'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '승인|업체수'			, Type: 'AutoSum'			, SaveName: 'aprvCnt'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '승인|지원금 승인액'		, Type: 'AutoSum'			, SaveName: 'aprvAmt'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '거절/반려/포기|업체수'	, Type: 'AutoSum'			, SaveName: 'notAprvedCnt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#voucherUsingSheet')[0];
		createIBSheet2(container, 'voucherUsingSheet', '100%', '10%');
		ibHeader.initSheet('voucherUsingSheet');

		voucherUsingSheet.SetEllipsis(1); 				// 말줄임 표시여부
		voucherUsingSheet.SetSelectionMode(4);

	}

	function setSheetHeader_voucherServiecUsing() {	// 서비스별 사용 현황 헤더

		var	ibHeader = new IBHeader();


		ibHeader.addHeader({Header: '서비스|서비스'		, Type: 'Text'			, SaveName: 'voucherName'		, Edit: false	, Width: 60		, Align: 'Left'});
		ibHeader.addHeader({Header: '실버|업체수'		, Type: 'Int'		, SaveName: 'silverCnt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '실버|금액'		, Type: 'Int'		, SaveName: 'silverAmt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '골드|업체수'		, Type: 'Int'		, SaveName: 'goldCnt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '골드|금액'		, Type: 'Int'		, SaveName: 'goldAmt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '로얄|업체수'		, Type: 'Int'		, SaveName: 'royalCnt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '로얄|금액'		, Type: 'Int'		, SaveName: 'royalAmt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '점프업|업체수'		, Type: 'Int'		, SaveName: 'jumpupCnt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '점프업|금액'		, Type: 'Int'		, SaveName: 'jumpupAmt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '소계|업체수'		, Type: 'Int'		, SaveName: 'sumCnt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '소계|금액'		, Type: 'Int'		, SaveName: 'sumAmt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});


		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#voucherServiecUsingSheet')[0];
		createIBSheet2(container, 'voucherServiecUsingSheet', '100%', '10%');
		ibHeader.initSheet('voucherServiecUsingSheet');

		voucherServiecUsingSheet.SetEllipsis(1); 				// 말줄임 표시여부
		voucherServiecUsingSheet.SetSelectionMode(4);

	}

	function getVoucherUsing() {	// 현황 조회

		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherUsing.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				voucherUsingSheet.LoadSearchData({Data: (data.resultList || []) });
				voucherServiecUsingSheet.LoadSearchData({Data: (data.resultServiceList || []) });

				voucherUsingSheet.SetSumText(0, '합계');
				voucherServiecUsingSheet.SetSumText(0, '합계');

				if(data.totalCnt == ''){
					$('#sapnBudgetAmt').text(0);
				} else {
					$('#sapnBudgetAmt').text(global.formatCurrency(data.totalCnt));
				}
			}
		});
	}

	function DoexcelDownload() {	// 엑셀다운로드

		$('#searchForm').attr('action', '/voucher/voucherUsageStatusExcelDown.do');
		$('#searchForm').submit();

	}

	function doClear() {	// 초기화
		location.reload();
	}

</script>