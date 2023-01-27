<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="ml-auto">
		<button type="button" id="btnAprv" class="btn_sm btn_primary btn_modify_auth" onclick="chgStatus('90');">승인</button>
		<button type="button" id="btnAprvCancel" class="btn_sm btn_secondary btn_modify_auth" onclick="chgStatus('10');">승인대기</button>
		<button type="button" id="btnReturn" class="btn_sm btn_secondary btn_modify_auth" onclick="callReturnRsnPop();">반려</button>
		<button type="button" id="btnReject" class="btn_sm btn_secondary btn_modify_auth" onclick="chgStatus('50');">포기</button>
	</div>

	<div class="ml-15">
		<button type="button" id="btnExcel" class="btn_sm btn_primary" onclick="doExcelDownload();">엑셀 다운</button>
		<button type="button" id="btnSearchReset" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<form id="searchForm" method="post">
<div class="cont_block">
	<div class="search">
		<input type="hidden" id="pageIndex" name="pageIndex"   value="<c:out value='${params.pageIndex}' default='1' />"/>
		<input type="hidden" id="vmstSeq" name="vmstSeq" value=""/>
		<input type="hidden" id="tradeNo" name="tradeNo" value=""/>
		<table class="formTable">
			<colgroup>
				<col style="width:15%">
				<col>
				<col style="width:15%">
				<col>
				<col style="width:15%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th>대상년도</th>
					<td>
						<input type="hidden" id="fBaseYear" value="${baseYearList[0].baseYear }">
						<select name="searchBaseYear" id="searchBaseYear" class="form_select w100p" onchange="getVoucherNmList(this.value);">
							<c:forEach items="${baseYearList}" var="resultInfo" varStatus="status">
								<option value="<c:out value="${ resultInfo.baseYear}" />" label="<c:out value="${ resultInfo.baseYear}" />" <c:out value="${ params.searchBaseYear eq resultInfo.baseYear ? 'selected' : '' }" /> />
							</c:forEach>
						</select>
					</td>
					<th>사업명</th>
					<td>
						<select name="searchVmstSeq" id="searchVmstSeq" class="form_select w100p">

						</select>
					</td>
					<th>상태 / 만료</th>
					<td>
						<select name="searchStatusCd" id="searchStatusCd" class="form_select w100p" onchange="dispPeriodExp(this.value);">
							<option value="" label="전체" selected />
							<c:forEach items="${statusCdList}" var="resultInfo" varStatus="status">
								<option value="<c:out value="${ resultInfo.code}" />" label="<c:out value="${ resultInfo.codeNm}" />" <c:out value="${ params.searchStatusCd eq resultInfo.code ? 'selected' : '' }" /> />
							</c:forEach>
						</select>
						<select name="searchPeriodExp" id="searchPeriodExp" class="form_select w100p" style="display: none;">
							<option value="" label="전체" selected />
							<option value="E" label="만료" <c:out value="${ params.searchPeriodExp eq 'E'? 'selected' : '' }" /> />
							<option value="U" label="이용중" <c:out value="${ params.searchPeriodExp eq 'U'? 'selected' : '' }" /> />
						</select>

					</td>
				</tr>
				<tr>
					<th>회원등급</th>
					<td class="bRight">
						<select name="searchVoucherLev" id="searchVoucherLev" class="form_select w100p">
							<option value="" label="전체"  />
							<c:forEach items="${voucherLevList}" var="resultInfo" varStatus="status">
								<option value="<c:out value="${ resultInfo.code}" />" label="<c:out value="${ resultInfo.codeNm}" />"  <c:out value="${ params.searchVoucherLev eq resultInfo.code ? 'selected' : '' }" /> />
							</c:forEach>
						</select>
					</td>
					<th>업체명</th>
					<td class="bRight">
						<input type="text" class="form_text w100p" name="searchCorpNameKr" id="searchCorpNameKr" onkeydown="onEnter(doSearch);" value="<c:out value="${ params.searchCorpNameKr }" />" />
					</td>
					<th>사업자번호</th>
					<td>
						<input type="text" class="form_text w100p" name="searchCorpRegNo" id="searchCorpRegNo" onkeydown="onEnter(doSearch);" value="<c:out value="${ params.searchCorpRegNo }" />"  />
					</td>
				</tr>
				<tr>
					<th>기간검색</th>
					<td colspan="5">
						<fieldset class="form_group">
							<select name="searchPeriodType" id="searchPeriodType" class="form_select group_item">
								<option value="R" label="신청일자" <c:out value="${ params.searchPeriodType eq 'R' ? 'selected' : '' }" /> />
								<option value="C" label="승인일자" <c:out value="${ params.searchPeriodType eq 'C' ? 'selected' : '' }" /> />
							</select>

							<div class="group_datepicker group_item">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" name="searchStdt" id="searchStdt" value="${params.searchStdt}" class="txt datepicker" title="조회시작일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									</span>

									<!-- clear 버튼 -->
									<button type="button" class="dateClear" onclick="clearPickerValue('searchStdt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
								</div>

								<div class="spacing">~</div>

								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" name="searchEddt" id="searchEddt" value="${params.searchEddt}" class="txt datepicker" title="조회종료일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									</span>

									<!-- clear 버튼 -->
									<button type="button" class="dateClear" onclick="clearPickerValue('searchEddt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
								</div>
							</div>
						</fieldset>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>


<div class="cont_block">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>

		<select id="pageUnit" name="pageUnit" title="목록수" class="form_select ml-auto" onchange="chgPageCnt();">
			<c:forEach var="item" items="${pageUnitList}" varStatus="status">
				<option value="${item.code}" <c:if test="${searchParam.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
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

		setSheetHeader_companyList();				// 사업 리스트 헤더
		getCompanyList();							// 사업 리스트 조회
		getVoucherNmList($('#fBaseYear').val());	// 초기년도 값으로 사업명 조회

	});

	function setSheetHeader_companyList() {	// 사업 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'		, SaveName: 'status'			, Hidden: true});
		ibHeader.addHeader({Header: '바우처 시퀀스'		, Type: 'Text'			, SaveName: 'vmstSeq'			, Hidden: true});
		ibHeader.addHeader({Header: '무역고유번호'		, Type: 'Text'			, SaveName: 'tradeNo'			, Hidden: true});
		ibHeader.addHeader({Header: '업체상태코드'		, Type: 'Text'			, SaveName: 'statusCd'			, Hidden: true});
		ibHeader.addHeader({Header: '선택'			, Type: 'CheckBox'		, SaveName: 'check'				, Width: 20		, HeaderCheck : 1});
		ibHeader.addHeader({Header: 'No'			, Type: 'Text'			, SaveName: 'no'				, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '업체명'			, Type: 'Text'			, SaveName: 'corpNameKr'		, Edit: false	, Width: 50		, Align: 'Left'	, Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '사업자등록번호'		, Type: 'Text'			, SaveName: 'corpRegNo'			, Edit: false	, Width: 40		, Align: 'Center'	, Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '대표자'			, Type: 'Text'			, SaveName: 'ceoName'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '담당자'			, Type: 'Text'			, SaveName: 'manName'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '연락처'			, Type: 'Text'			, SaveName: 'manTel'			, Edit: false	, Width: 30		, Align: 'Center'});
		ibHeader.addHeader({Header: '등급'			, Type: 'Text'			, SaveName: 'voucherLev'		, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '지원 총액'		, Type: 'Int'			, SaveName: 'levSumsuppAmt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '잔액'			, Type: 'Int'			, SaveName: 'balanceAmt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '연차'			, Type: 'Text'			, SaveName: 'duesYear'			, Edit: false	, Width: 20		, Align: 'Right'});
		ibHeader.addHeader({Header: '신청일'			, Type: 'Text'			, SaveName: 'regDt'				, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '첨부'			, Type: 'Html'			, SaveName: 'attFile'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '상태'			, Type: 'Text'			, SaveName: 'statusCdNm'		, Edit: false	, Width: 20		, Align: 'Center'});
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
            SizeMode: 1,
            ToolTip: false});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#companyListSheet')[0];
		createIBSheet2(container, 'companyListSheet', '100%', '10%');
		ibHeader.initSheet('companyListSheet');

		companyListSheet.SetEllipsis(1); // 말줄임 표시여부
		companyListSheet.SetSelectionMode(4);

		// 시작일 선택 이벤트
		datepickerById('searchStdt', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('searchEddt', toDateSelectEvent);
	}

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

	function dispPeriodExp(statusCd){

		if(statusCd == "90"){
			$("#searchPeriodExp").show();
		} else {

			$("#searchPeriodExp").hide();
			//숨길때는 값을 초기화
			$("#searchPeriodExp").val("");
		}
	}

	function getVoucherNmList(year) {

		global.ajax({
			type : 'POST'
			, url : '/voucher/getVoucherListByBaseYear.do'
			, data : {'searchBaseYear' : year}
			, async : true
			, success : function(data){

				$('#searchVmstSeq').empty();

				var vouList = data.voucherList;

				$('#searchVmstSeq').append('<option value="" label="전체" selected />');

				for(var i = 0; i < data.voucherList.length; i++){
					$('#searchVmstSeq').append('<option value="'+vouList[i].vmstSeq+'" label="'+vouList[i].voucherTitle+'" />')
				}
			}
		});
	}

	function companyListSheet_OnRowSearchEnd(row) {

		companyListSheet.SetCellValue(row, 'attFile', '<img src="/images/icon/icon_file.gif"  style="cursor: pointer;"/>');
		companyListSheet.SetCellValue(row, 'status', '');
		companyListSheet.SetColFontBold('corpNameKr', 1);
		companyListSheet.SetColFontBold('corpRegNo', 1);

	}

	function companyListSheet_OnChange(Row, col, value, oldValue, raiseFlag) {

		var statusCd = companyListSheet.GetCellValue(Row, 'statusCd');

		var checkedCnt = companyListSheet.CheckedRows("check");      //체크 건수를 갖고 와서
		if(checkedCnt <= 1){ //체크된 건수가 1이나 0인경우

			var nowStatusCd = companyListSheet.GetCellValue(Row, 'statusCd');

			var size = companyListSheet.RowCount();
			var firstIdx = companyListSheet.GetDataFirstRow();
			if(size > 0){
				for(var i = firstIdx; i <= size; i++){

				var rowStatusCd = companyListSheet.GetCellValue(i, 'statusCd');

					if(checkedCnt == 0){
						btnControl('');
						companyListSheet.SetCellEditable(i, "check", true);
					} else {
						if(rowStatusCd != nowStatusCd){
							companyListSheet.SetCellEditable(i,"check", false);
						} else {
							companyListSheet.SetCellEditable(i,"check", true);
						}
						btnControl(statusCd);
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
		var statusCd = companyListSheet.GetCellValue(Row, 'statusCd');

		if(companyListSheet.ColSaveName(Col) == 'attFile'){
			openAttachFilePop(vmstSeq, tradeNo);
		}

		if(companyListSheet.ColSaveName(Col) == 'check'){
			return;
		}

		if(companyListSheet.ColSaveName(Col) == 'corpNameKr' || companyListSheet.ColSaveName(Col) == 'corpRegNo'){
			goDetail(vmstSeq, tradeNo);
		}
	}

	function goDetail(vmstSeq, tradeNo){

		$('#tradeNo').val(tradeNo);
		$('#vmstSeq').val(vmstSeq);
		$('#searchForm').attr('action', '/voucher/voucherCompanyMngDetail.do');
		$('#searchForm').submit();
	}

	// 파일 팝업
	function openAttachFilePop(vmstSeq, tradeNo) {

		global.openLayerPopup({
			popupUrl : '/voucher/popup/voucherCompanyMngAttachFileViewPop.do'
			, params : {
				'vmstSeq' : vmstSeq,
				'tradeNo' : tradeNo
			}
		});
	}

	function getCompanyList() {	// 회사 조회

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherCompanyMngList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParam)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				setPaging(	// 페이징
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

	function callReturnRsnPop() {	//반려팝업 호출

		var chkRow = companyListSheet.FindCheckedRow('check');

		if(chkRow == '') {
			alert('선택한 항목이 없습니다.');
			return false;
		}

		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/voucher/popup/voucherReturnRsnPop.do'
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

	function updateReturnRsn(returnRsn) {	//반려상태로 변경

		var chkRow = companyListSheet.FindCheckedRow('check');

		for(var i = 0; i < chkRow.length; i++) {

			companyListSheet.SetCellValue(chkRow[i], 'returnRsn', returnRsn, 0);
			companyListSheet.SetCellValue(chkRow[i], 'statusCd', '40', 0);
		}

		var saveData = companyListSheet.GetSaveJson();

		global.ajax({
			type : 'POST'
			, url : "/voucher/voucherStatusChg.do"
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

	function btnControl(statusCd){	//버튼컨트롤

		switch (statusCd) {

		case "10":

			$("#btnSearch").show();
			$("#btnAprv").show();
			$("#btnAprvCancel").hide();
			$("#btnReturn").show();
			$("#btnReject").show();

			break;

		case "30":

			$("#btnSearch").show();
			$("#btnAprv").hide();
			$("#btnAprvCancel").hide();
			$("#btnReturn").hide();
			$("#btnReject").hide();

			break;


		case "40":
			$("#btnSearch").show();
			$("#btnAprv").hide();
			$("#btnAprvCancel").hide();
			$("#btnReturn").hide();
			$("#btnReject").hide();

			break;

		case "50":
			$("#btnSearch").show();
			$("#btnAprv").hide();
			$("#btnAprvCancel").hide();
			$("#btnReturn").hide();
			$("#btnReject").hide();

			break;


		case "90":

			$("#btnSearch").show();
			$("#btnAprv").hide();
			$("#btnAprvCancel").show();
			$("#btnReturn").hide();
			$("#btnReject").hide();

			break;
		default :

			$("#btnSearch").show();
			$("#btnAprv").show();
			$("#btnAprvCancel").show();
			$("#btnReturn").show();
			$("#btnReject").show();

			break;

		}

	}

	function chgStatus(statusCd){	//반려를 제외

		var statusNm = "";

		var chkRow = companyListSheet.FindCheckedRow('check', {ReturnArray:1});

		var preStatusCd = companyListSheet.GetCellValue(chkRow[0], 'statusCd');

		if(chkRow == '') {
			alert('선택한 항목이 없습니다.');
			return;
		}

		switch (statusCd) {

		case "10":	// 승인취소 시도
			statusNm = "승인대기";
			break;

		case "50":
			statusNm = "포기";
			break;

		case "90":
			statusNm = "승인";
			break;
		}

		if(!confirm(statusNm+" 하시겠습니까?")){
			return false;
		}

		for(var i = 0; i < chkRow.length; i++) {

			companyListSheet.SetCellValue(chkRow[i], 'statusCd', statusCd, 0);
		}

		var saveData = companyListSheet.GetSaveJson();

		global.ajax({
			type : 'POST'
			, url : "/voucher/voucherStatusChg.do"
			, contentType : 'application/json'
			, data : JSON.stringify(saveData.data)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if(data.result == false) {
					alert(data.message);

					for(var i = 0; i < chkRow.length; i++) {

						companyListSheet.SetCellValue(chkRow[i], 'statusCd', preStatusCd, 0);
					}

				} else {
					getCompanyList();
					btnControl('');
				}
			}
		});
	}

	function doExcelDownload() {	// 엑셀다운
		$('#searchForm').attr('action','/voucher/voucherCompanyMngExcelDown.do');
		$('#searchForm').submit();
	}

	function doClear() {	// 초기화
		location.reload();
	}

</script>