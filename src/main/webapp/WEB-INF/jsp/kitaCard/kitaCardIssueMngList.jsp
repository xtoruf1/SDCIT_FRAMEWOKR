<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="excelUpload();">엑셀 업로드</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_primary" onclick="doExcelDownload();">엑셀 다운</button>
		<button type="button" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<form id="searchForm" method="post">
<div class="cont_block">
	<div class="search">
	<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${params.pageIndex}' default='1' />"/>
	<input type="hidden" id="pCardReqId" name="cardReqId"  value=""/>
	<input type="hidden" id="pTradeNo" name="tradeNo"  value=""/>
		<table class="formTable">
			<colgroup>
				<col width="15%"/>
				<col width="18%" />
				<col width="15%"/>
				<col width="18%" />
				<col width="15%"/>
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>업체명</th>
					<td><input type="text" class="form_text w100p" name="searchCorpNameKr" id="searchCorpNameKr" onkeydown="onEnter(doSearch);" value="<c:out value="${ params.searchCorpNameKr}" />" /></td>
					<th>사업자번호</th>
					<td><input type="text" class="form_text w100p" name="searchCorpRegNo" id="searchCorpRegNo" onkeydown="onEnter(doSearch);" value="<c:out value="${ params.searchCorpRegNo}" />" /></td>
					<th>무역업번호</th>
					<td><input type="text" class="form_text w100p" name="searchTradeNo" id="searchTradeNo" onkeydown="onEnter(doSearch);" value="<c:out value="${ params.searchTradeNo}" />" /></td>
				</tr>
				<tr>
					<th>상태</th>
					<td>
						<select name="searchCardStatus" id="searchCardStatus" class="form_select w100p">
							<option value="">전체</option>
							<c:forEach items="${CARD01}" var="vo" varStatus="status">
							<option value="<c:out value="${vo.code}" />" label="<c:out value="${ vo.codeNm}" />" <c:out value="${ params.searchCardStatus eq vo.code ? 'selected' : '' }" /> />
							</c:forEach>
						</select>
					</td>
					<th>카드종류</th>
					<td colspan="3">
						<select name="searchCardCode" id="searchCardCode" class="form_select">
							<option value="">전체</option>
							<c:forEach items="${cardList}" var="vo" varStatus="status">
							<option value="<c:out value="${vo.cardCode}" />" label="<c:out value="${ vo.cardName}" />" <c:out value="${ params.searchCardCode eq vo.cardCode ? 'selected' : '' }" /> />
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>기간검색</th>
					<td colspan="5">
						<fieldset class="form_group">
							<select name="searchDateType" id="searchDateType" class="form_select group_item">
								<option value="REQ_DATE"  <c:out value="${ params.searchDateType eq 'REQ_DATE' ? 'selected' : '' }" /> >신청일자</option>
								<option value="ISSUE_DATE" <c:out value="${ params.searchDateType eq 'ISSUE_DATE' ? 'selected' : '' }" /> >발급일자</option>
							</select>

							<div class="group_datepicker group_item">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" name="searchStartDate" id="searchStartDate" class="txt datepicker" value="<c:out value="${ params.searchStartDate}" />" title="조회시작일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									</span>

									<!-- clear 버튼 -->
									<button type="button" class="dateClear" onclick="clearPickerValue('searchStartDate')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
								</div>

								<div class="spacing">~</div>

								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" name="searchEndDate" id="searchEndDate" class="txt datepicker"value="<c:out value="${ params.searchEndDate}" />"  title="조회종료일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									</span>

									<!-- clear 버튼 -->
									<button type="button" class="dateClear" onclick="clearPickerValue('searchEndDate')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
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

		<select id="pageUnit" name="pageUnit" title="목록수" class="form_select ml-auto" onchange="chgPageCnt();">
			<c:forEach var="item" items="${pageUnitList}" varStatus="status">
				<option value="${item.code}" <c:if test="${params.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
			</c:forEach>
		</select>
	</div>
	<div>
		<div id="cardIssueSheet" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){

		// 시작일 선택 이벤트
		datepickerById('searchStartDate', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('searchEndDate', toDateSelectEvent);

		setSheetHeader_cardIssueList();		// 사업 리스트 헤더
		getCardIssueList();					// 사업 리스트 조회

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

	function setSheetHeader_cardIssueList() {	// 사업 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '상태값'			, Type: 'Status'		, SaveName: 'status'		, Hidden: true});
		ibHeader.addHeader({Header: '카드신청ID'		, Type: 'Text'			, SaveName: 'cardReqId'		, Hidden: true});
		ibHeader.addHeader({Header: '무역업번호'		, Type: 'Text'			, SaveName: 'tradeNo'		, Hidden: true});
		ibHeader.addHeader({Header: 'No'			, Type: 'Text'			, SaveName: 'no'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '업체명'			, Type: 'Text'			, SaveName: 'corpNameKr'	, Edit: false	, Width: 60		, Align: 'Left'});
		ibHeader.addHeader({Header: '사업자등록번호'		, Type: 'Text'			, SaveName: 'corpRegNo'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '대표자'			, Type: 'Text'			, SaveName: 'repreNameKr'	, Edit: false	, Width: 40		, Align: 'Center'});
// 		ibHeader.addHeader({Header: '담당자'			, Type: 'Text'			, SaveName: 'manName'		, Edit: false	, Width: 40		, Align: 'Center'});
// 		ibHeader.addHeader({Header: '전화'			, Type: 'Text'			, SaveName: 'manTelno'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '카드종류'			, Type: 'Text'			, SaveName: 'cardName'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '카드코드'			, Type: 'Text'			, SaveName: 'cardCode'		, Hidden: true});
		ibHeader.addHeader({Header: '신청일'			, Type: 'Text'			, SaveName: 'reqDate'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '발급일'			, Type: 'Date'			, SaveName: 'issueDate'		, Edit: true	, Width: 40		, Align: 'Center', Format:"yyyy-MM-dd"});
		ibHeader.addHeader({Header: '상태'			, Type: 'Combo'			, SaveName: 'cardStatus'	, Edit: true	, Width: 20		, Align: 'Center'	, ComboCode: "30|90", ComboText: "해지|발급"});

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

		var container = $('#cardIssueSheet')[0];
		createIBSheet2(container, 'cardIssueSheet', '100%', '100%');
		ibHeader.initSheet('cardIssueSheet');

		cardIssueSheet.SetEllipsis(1); // 말줄임 표시여부
		cardIssueSheet.SetSelectionMode(4);

	}

	function doSearch() {
		$('#pageIndex').val(1);
		getCardIssueList();
	}

	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getCardIssueList();
	}

	function chgPageCnt() {
		doSearch();
	}

// 	function cardIssueSheet_OnSearchEnd() {
// 		// 제목에 볼드 처리
// 		cardIssueSheet.SetColFontBold('corpNameKr', 1);
// 	}

// 	function cardIssueSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {

// 		if(rowType == 'HeaderRow'){
// 			return;
// 		}

// 		var cardReqId = cardIssueSheet.GetCellValue(Row, 'cardReqId');
// 		var tradeNo = cardIssueSheet.GetCellValue(Row, 'tradeNo');

// 		if(cardIssueSheet.ColSaveName(Col) == 'corpNameKr') {
// 			goDetail(cardReqId, tradeNo);
// 		}
// 	}

	function getCardIssueList() {	// 사업정보 조회

		var searchparam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/kitaCard/selectKitaCardIssueList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchparam)
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

				cardIssueSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function goDetail(cardReqId, tradeNo) {

		$('#pTradeNo').val(tradeNo);
		$('#pCardReqId').val(cardReqId);
		$('#searchForm').attr('action', '/kitaCard/kitaCardIssueMngDetail.do');
		$('#searchForm').submit();

	}

	function doExcelDownload() {
		$('#searchForm').attr('action','/kitaCard/kitaCardIssueExcelDown.do');
		$('#searchForm').submit();
	}

	function excelUpload() {
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/kitaCard/popup/kitaCardExcelUpload.do'
			, params : { uploadType : 'issue'}
			, callbackFunction : function(resultObj){
				if(resultObj == 'true') {
					getCardIssueList();
				} else {
					return;
				}
			}
		});
	}

	function doSave() {

		var saveData = cardIssueSheet.GetSaveJson();

		if(saveData.Code == 'IBS000') {
			alert("작업할 데이터가 없습니다.");
			return;
		}

		if(!confirm('저장 하시겠습니까?')) {
			return;
		}

		global.ajax({
			type : 'POST'
			, url : "/kitaCard/kitaCardIssueStatusChg.do"
			, contentType : 'application/json'
			, data : JSON.stringify(saveData.data)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				getCardIssueList();
			}
		});
	}

	function doClear() {	// 초기화
		location.reload();
	}

</script>