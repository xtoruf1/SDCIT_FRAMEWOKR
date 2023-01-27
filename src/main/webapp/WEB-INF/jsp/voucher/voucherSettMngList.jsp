<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="ml-auto">
		<button type="button" id="btnAprv" class="btn_sm btn_primary btn_modify_auth" onclick="chgStatus();">승인</button>
		<button type="button" id="btnReturn" class="btn_sm btn_secondary btn_modify_auth" onclick="callReturnRsnPop();">반려</button>
	</div>
	<div class="ml-15">
		<button type="button" id="btnExcel" class="btn_sm btn_primary" onclick="DoExcelDownload();">엑셀 다운</button>
		<button type="button" id="btnSearchReset" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" id="btnSearch" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<form id="searchForm" method="post">
<div class="cont_block">
	<div class="search">
	<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
	<input type="hidden" id="vouSettSeq" name="vouSettSeq" value=""/>
	<input type="hidden" id="vmstSeq" name="vmstSeq" value=""/>
	<input type="hidden" id="tradeNo" name="tradeNo" value="${tradeNo}"/>
		<table class="formTable">
			<colgroup>
				<col style="width:10%">
				<col>
				<col style="width:10%">
				<col style="width:23%">
				<col style="width:10%">
				<col style="width:23%">
			</colgroup>
			<tbody>
				<tr>
					<th>사업명</th>
					<td>
						<select name="searchVmstSeq" id="searchVmstSeq" class="form_select wAuto" onchange="getServiceList();">
							<c:forEach items="${vouList}" var="resultInfo" varStatus="status">
								<option value="<c:out value="${ resultInfo.vmstSeq}" />" label="<c:out value="${ resultInfo.voucherTitle}" /> "/>
							</c:forEach>
						</select>
					</td>
					<th>회원등급</th>
					<td class="bRight">
						<select name="searchVoucherLev" id="searchVoucherLev" class="form_select w100p">
							<option value="" label="전체"  />
							<c:forEach items="${voucherLevList}" var="resultInfo" varStatus="status">
								<option value="<c:out value="${ resultInfo.code}" />" label="<c:out value="${ resultInfo.codeNm}" />" />
							</c:forEach>
						</select>
					</td>
					<th>상태</th>
					<td>
						<select name="searchAccStatusCd" id="searchAccStatusCd" class="form_select w100p">
							<option value="" label="전체" selected />
							<c:forEach items="${accStatusCdList}" var="resultInfo" varStatus="status">
								<c:if test="${ resultInfo.code gt 10 and resultInfo.code lt 80}">
									<option value="<c:out value="${ resultInfo.code}" />" label="<c:out value="${ resultInfo.codeNm}" />" />
								</c:if>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>서비스</th>
					<td class="bRight">
						<select name="searchVoucherCd" id="searchVoucherCd" class="form_select w100p">
						</select>
					</td>
					<th>업체명</th>
					<td class="bRight">
						<input type="text" class="form_text w100p" name="searchCorpNameKr" id="searchCorpNameKr" onkeydown="onEnter(doSearch);" value="<c:out value="${ param.searchCorpNameKr }" />" />
					</td>
					<th>사업자번호</th>
					<td>
						<input type="text" class="form_text w100p" name="searchCorpRegNo" id="searchCorpRegNo" onkeydown="onEnter(doSearch);" value="<c:out value="${ param.searchCorpRegNo }" />"  />
					</td>
				</tr>
				<tr>
					<th>승인요청일</th>
					<td colspan="5">
						<div class="group_datepicker">
						<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="searchStdt" id="searchStdt" value="${param.searchStartDate}" class="txt datepicker" title="조회시작일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('searchStdt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="searchEddt" id="searchEddt" value="${param.searchEndDate}" class="txt datepicker" title="조회종료일자입력" readonly="readonly" />
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
</div>

<div class="cont_block">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>

		<select id="pageUnit" name="pageUnit" title="목록수" class="form_select ml-auto" onchange="chgPageCnt();">
			<c:forEach var="item" items="${pageUnitList}" varStatus="status">
				<option value="${item.code}">${item.codeNm}</option>
			</c:forEach>
		</select>
	</div>

	<div>
		<div id="companyListSheet" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){

		var nowYear = global.formatToday('yyyy');	// 현재연도 구하기

		setSheetHeader_companyList();				// 업체 리스트 헤더
		getCompanyList();							// 업체 리스트 조회

		getServiceList();

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

	function setSheetHeader_companyList() {	// 업체 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'		, SaveName: 'status'			, Hidden: true});
		ibHeader.addHeader({Header: '바우처 시퀀스'		, Type: 'Text'			, SaveName: 'vmstSeq'			, Hidden: true});
		ibHeader.addHeader({Header: '무역고유번호'		, Type: 'Text'			, SaveName: 'tradeNo'			, Hidden: true});
		ibHeader.addHeader({Header: '정산상태코드'		, Type: 'Text'			, SaveName: 'accStatusCd'		, Hidden: true});
		ibHeader.addHeader({Header: '정산이력회차번호'	, Type: 'Text'			, SaveName: 'vouSettSeq'		, Hidden: true});
		ibHeader.addHeader({Header: '선택'			, Type: 'CheckBox'		, SaveName: 'check'				, Width: 20		, HeaderCheck : 1});
		ibHeader.addHeader({Header: 'No'			, Type: 'Text'			, SaveName: 'no'				, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '회사명'			, Type: 'Text'			, SaveName: 'corpNameKr'		, Edit: false	, Width: 40		, Align: 'Left'	, Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '사업자등록번호'		, Type: 'Text'			, SaveName: 'corpRegNo'			, Edit: false	, Width: 40		, Align: 'Center'	, Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '등급'			, Type: 'Text'			, SaveName: 'voucherLevNm'		, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '지원금총액'		, Type: 'Int'			, SaveName: 'sumSuppAmt'		, Edit: false	, Width: 30		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '기정산액'			, Type: 'Int'			, SaveName: 'alreadyAccAmt'		, Edit: false	, Width: 30		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '잔액'			, Type: 'Int'			, SaveName: 'balanceAmt'		, Edit: false	, Width: 30		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '정산신청액'		, Type: 'Int'			, SaveName: 'reqAmt'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'	, Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '정산승인액'		, Type: 'Int'			, SaveName: 'fixAmt'			, Edit: false	, Width: 30		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '정산신청일'		, Type: 'Text'			, SaveName: 'regDt'				, Edit: false	, Width: 30		, Align: 'Center'});
		ibHeader.addHeader({Header: '상태'			, Type: 'Text'			, SaveName: 'accStatusCdNm'		, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '가입년도'			, Type: 'Text'			, SaveName: 'addRegDt'			, Edit: false	, Width: 30		, Align: 'Center'});
		ibHeader.addHeader({Header: '반려메시지'		, Type: 'Text'			, SaveName: 'returnRsn'			, Hidden: true});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#companyListSheet')[0];
		createIBSheet2(container, 'companyListSheet', '100%', '10%');
		ibHeader.initSheet('companyListSheet');

		companyListSheet.SetEllipsis(1); 				// 말줄임 표시여부
		companyListSheet.SetSelectionMode(4);

	}

	function doSearch() {
		$('#pageIndex').val(1);
		getCompanyList();
	}

	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getCompanyList();
	}

	function chgPageCnt() {
		doSearch();
	}

	function companyListSheet_OnSearchEnd() {
		// 제목에 볼드 처리
		companyListSheet.SetColFontBold('corpNameKr', 1);
		companyListSheet.SetColFontBold('corpRegNo', 1);
		companyListSheet.SetColFontBold('reqAmt', 1);
	}

	function getServiceList() {
		global.ajax({
			type : 'POST'
			, url : '/voucher/getServiceList.do'
			, data : {'searchVmstSeq' : $('#searchVmstSeq').val()}
			, async : false
			, success : function(data){
				var vouList = data.voucherCdList;

				$('#searchVoucherCd').empty();
				$('#searchVoucherCd').append('<option value="" label="전체" />')

				for(var i = 0; i < vouList.length; i++){
					var selectVal = '';
					if('<c:out value="${param.searchVoucherCd}"/>'=='vouList[i].voucherCd'){
						selectVal = 'selected'
					}
					$('#searchVoucherCd').append('<option value="'+vouList[i].voucherCd+'" label="'+vouList[i].voucherName+'" '+selectVal+' />')
				}
			}
		});
	}

	function companyListSheet_OnChange(Row, col, value, oldValue, raiseFlag) {

		var accStatusCd = companyListSheet.GetCellValue(Row, 'accStatusCd');

		var checkedCnt = companyListSheet.CheckedRows("check");      //체크 건수를 갖고 와서
		if(checkedCnt <= 1){ //체크된 건수가 1이나 0인경우

			var nowAccStatusCd = companyListSheet.GetCellValue(Row, 'accStatusCd');

			var size = companyListSheet.RowCount();
			var firstIdx = companyListSheet.GetDataFirstRow();
			if(size > 0){
				for(var i = firstIdx; i <= size; i++){

				var rowAccStatusCd = companyListSheet.GetCellValue(i, 'accStatusCd');

					if(checkedCnt == 0){
						btnControl('');
						companyListSheet.SetCellEditable(i, "check", true);
					} else {
						if(rowAccStatusCd != nowAccStatusCd){
							companyListSheet.SetCellEditable(i,"check", false);
						} else {
							companyListSheet.SetCellEditable(i,"check", true);
						}
						btnControl(accStatusCd);
					}
				}
			}
		}
	}

	function companyListSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {

		if(rowType == 'HeaderRow'){
			return;
		}

		var vmstSeq = companyListSheet.GetCellValue(Row, 'vmstSeq');
		var tradeNo = companyListSheet.GetCellValue(Row, 'tradeNo');
		var vouSettSeq = companyListSheet.GetCellValue(Row, 'vouSettSeq');
		var statusCd = companyListSheet.GetCellValue(Row, 'statusCd');

		if(companyListSheet.ColSaveName(Col) == 'check'){
			return;
		}

		if(companyListSheet.ColSaveName(Col) == 'reqAmt'){
			openSettPop(vmstSeq, tradeNo, vouSettSeq);
		}

		if(companyListSheet.ColSaveName(Col) == 'corpNameKr' || companyListSheet.ColSaveName(Col) == 'corpRegNo'){
			$('#vmstSeq').val('');
			$('#tradeNo').val('');
			$('#vouSettSeq').val('');
			$('#vmstSeq').val(vmstSeq);
			$('#tradeNo').val(tradeNo);
			$('#vouSettSeq').val(vouSettSeq);
			openDetailPop(vmstSeq, tradeNo, vouSettSeq);
		}
	}


	function openDetailPop(vmstSeq, tradeNo, vouSettSeq) {	// 상세 팝업

		global.openLayerPopup({
			popupUrl : '/voucher/popup/voucherCompanyMngDetailViewPop.do'
			, params : {'vmstSeq' : vmstSeq,
				  	    'tradeNo' : tradeNo,
				  	    'vouSettSeq' : vouSettSeq}
		});
	}

	function openSettPop(vmstSeq, tradeNo, vouSettSeq) {	// 정산신청액 팝업

		global.openLayerPopup({
			popupUrl : '/voucher/popup/voucherSettViewPop.do'
			, params : {'vmstSeq' : vmstSeq,
				  	    'tradeNo' : tradeNo,
				  	    'vouSettSeq' : vouSettSeq,
				  	    'status' : 'U'}
		});
	}

	function getCompanyList() {	// 회사 조회

		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherSettMngList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				setPaging(	// 페이징
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
					);

				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				companyListSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function callReturnRsnPop() {

		var chkRow = companyListSheet.FindCheckedRow('check', {ReturnArray:1});

		if(chkRow == '') {
			//alert('선택한 항목이 없습니다.');
			alert('상태가 승인요청인 항목을 선택하세요.');
			return;
		}

		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/voucher/popup/voucherReturnRsnPop.do'
			// 레이어 팝업으로 넘기는 parameter 예시
			, callbackFunction : function(resultObj){
				if(resultObj == '') {
					alert('문제가 발생했습니다.');
				} else {
					var returnRsn = resultObj;
					updateReturnRsn(returnRsn);
				}
			}
		});
	}

	function updateReturnRsn(returnRsn) {

		var chkRow = companyListSheet.FindCheckedRow('check', {ReturnArray:1});

		for(var i = 0; i < chkRow.length; i++) {

			companyListSheet.SetCellValue(chkRow[i], 'accStatusCd', '40', 0);
			companyListSheet.SetCellValue(chkRow[i], 'returnRsn', returnRsn, 0);
		}

		var saveData = companyListSheet.GetSaveJson();

		global.ajax({
			type : 'POST'
			, url : "/voucher/updateVoucherSettStatus.do"
			, contentType : 'application/json'
			, data : JSON.stringify(saveData.data)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				getCompanyList();
				btnControl('');
			}
		});
	}

	function btnControl(accStatusCd){

		switch (accStatusCd) {

		case "20":

			$("#btnSearch").show();
			$("#btnAprv").show();
			$("#btnReturn").show();

			break;

		case "40":

			$("#btnSearch").show();
			$("#btnAprv").hide();
			$("#btnReturn").hide();

			break;

		default :

			$("#btnSearch").show();
			$("#btnAprv").show();
			$("#btnReturn").show();

			break;

		}

	}

	function chgStatus(){	//승인

		var chkRow = companyListSheet.FindCheckedRow('check', {ReturnArray:1});

		if(chkRow == '') {
			alert('선택한 항목이 없습니다.');
			return;
		}

		if(!confirm("승인 하시겠습니까?")){
			return false;
		}

		for(var i = 0; i < chkRow.length; i++) {

			companyListSheet.SetCellValue(chkRow[i], 'accStatusCd', '80', 0);
		}

		var saveData = companyListSheet.GetSaveJson();

		global.ajax({
			type : 'POST'
			, url : "/voucher/updateVoucherSettStatus.do"
			, contentType : 'application/json'
			, data : JSON.stringify(saveData.data)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				getCompanyList();
				btnControl('');
			}
		});
	}

	function DoExcelDownload() {

		$('#searchForm').attr('action', '/voucher/voucherSettMngExcelDown.do');
		$('#searchForm').submit();

	}

	function doClear() {	// 초기화
		location.reload();
	}


</script>