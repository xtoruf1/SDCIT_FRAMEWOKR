<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="btnGroup ml-auto">
		<button type="button" id="btnExcel" class="btn_sm btn_primary" onclick="doExcelDownload();">엑셀 다운</button>
		<button type="button" id="btnSearchReset" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" id="btnSave" class="btn_sm btn_primary" onclick="getVoucherSettle();">검색</button>
	</div>
</div>

<div class="cont_block">
	<form id="searchForm" method="post">
		<div class="search">
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
									<button type="button" class="dateClear" onclick="clearPickerValue('searchStdt');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
								</div>

								<div class="spacing">~</div>

								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchEddt" name="searchEddt" class="txt datepicker" title="종료일" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									</span>

									<!-- clear 버튼 -->
									<button type="button" class="dateClear" onclick="clearPickerValue('searchEddt');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
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
		<h3 class="tit_block">바우처 정산 / 지급 현황</h3>

		<div class="ml-15">
			예산액(전체) : <span id="sapnBudgetAmt" class="ml-8"></span>
		</div>
	</div>


	<div style="width: 100%;height: 100%;">
		<div id="voucherSettleSheet" class="sheet"></div>
	</div>
</div>

<div class="cont_block">
	<div class="tit_bar">
		<h3 class="tit_block">서비스별 지급 현황</h3>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="voucherServiecSettleSheet" class="sheet"></div>
	</div>
</div>


<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_voucherSettle();				// 바우처 사용 현황 헤더
		setSheetHeader_voucherServiecSettle();		// 바우처 사용 서비스별 현황 헤더
		getVoucherSettle();							// 바우처 사용 현황 조회

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

	function setSheetHeader_voucherSettle() {	// 바우처 사용 현황 헤더

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '등급|등급'			, Type: 'Text'			, SaveName: 'voucherLevNm'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '정산요청|업체수'		, Type: 'AutoSum'		, SaveName: 'reqCorpCnt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '정산요청|건수'			, Type: 'AutoSum'		, SaveName: 'reqCnt'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '정산요청|정산요청액'		, Type: 'AutoSum'		, SaveName: 'reqAmt'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '정상승인|업체수'		, Type: 'AutoSum'		, SaveName: 'aprvCorpCnt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '정상승인|건수'			, Type: 'AutoSum'		, SaveName: 'aprvCnt'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '정상승인|정산승인액'		, Type: 'AutoSum'		, SaveName: 'aprvAmt'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '지급|업체수'			, Type: 'AutoSum'		, SaveName: 'payCorpCnt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '지급|건수'			, Type: 'AutoSum'		, SaveName: 'payCnt'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '지급|지급액'			, Type: 'AutoSum'		, SaveName: 'payAmt'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});

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

		var container = $('#voucherSettleSheet')[0];
		createIBSheet2(container, 'voucherSettleSheet', '100%', '10%');
		ibHeader.initSheet('voucherSettleSheet');

		voucherSettleSheet.SetEllipsis(1); 				// 말줄임 표시여부
		voucherSettleSheet.SetSelectionMode(4);

	}

	function setSheetHeader_voucherServiecSettle() {	// 바우처 사용 현황 헤더

		var	ibHeader = new IBHeader();


		ibHeader.addHeader({Header: '서비스|서비스'		, Type: 'Text'			, SaveName: 'voucherName'		, Edit: false	, Width: 60		, Align: 'Left'});
		ibHeader.addHeader({Header: '실버|업체수'		, Type: 'Int'			, SaveName: 'silverCorpCnt'		, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '실버|건수'		, Type: 'Int'			, SaveName: 'silverCnt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '실버|금액'		, Type: 'Int'			, SaveName: 'silverAmt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '골드|업체수'		, Type: 'Int'			, SaveName: 'goldCorpCnt'		, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '골드|건수'		, Type: 'Int'			, SaveName: 'goldCnt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '골드|금액'		, Type: 'Int'			, SaveName: 'goldAmt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '로얄|업체수'		, Type: 'Int'			, SaveName: 'royalCorpCnt'		, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '로얄|건수'		, Type: 'Int'			, SaveName: 'royalCnt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '로얄|금액'		, Type: 'Int'			, SaveName: 'royalAmt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '점프업|업체수'		, Type: 'Int'			, SaveName: 'jumpupCorpCnt'		, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '점프업|건수'		, Type: 'Int'			, SaveName: 'jumpupCnt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '점프업|금액'		, Type: 'Int'			, SaveName: 'jumpupAmt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '계|업체수'		, Type: 'Int'			, SaveName: 'sumCorpCnt'		, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '계|건수'			, Type: 'Int'			, SaveName: 'sumCnt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '계|금액'			, Type: 'Int'			, SaveName: 'sumAmt'			, Edit: false	, Width: 35		, Align: 'Right'	, Format: 'Integer'});


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

		var container = $('#voucherServiecSettleSheet')[0];
		createIBSheet2(container, 'voucherServiecSettleSheet', '100%', '10%');
		ibHeader.initSheet('voucherServiecSettleSheet');

		voucherServiecSettleSheet.SetEllipsis(1); 				// 말줄임 표시여부
		voucherServiecSettleSheet.SetSelectionMode(4);


	}

	function getVoucherSettle() {	// 회사 조회

		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherSettle.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				voucherSettleSheet.LoadSearchData({Data: (data.resultList || []) });
				voucherServiecSettleSheet.LoadSearchData({Data: (data.resultServiceList || []) });

				voucherSettleSheet.SetSumText(0, '합계');

				if(data.totalCnt == ''){
					$('#sapnBudgetAmt').text(0);
				} else {
					$('#sapnBudgetAmt').text(global.formatCurrency(data.totalCnt));
				}
			}
		});
	}

	function doExcelDownload() {

		$('#searchForm').attr('action', '/voucher/voucherSettleExcelDown.do');
		$('#searchForm').submit();

	}

	function doClear() {	// 초기화
		location.reload();
	}


</script>