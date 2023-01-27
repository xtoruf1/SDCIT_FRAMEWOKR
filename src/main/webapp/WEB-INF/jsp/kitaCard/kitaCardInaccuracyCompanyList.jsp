<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="btnGroup ml-auto">
		<button type="button" id="btnDelect" class="btn_sm btn_secondary" onclick="doDelete();">삭제</button>
	</div>

	<div class="ml-15">
		<button type="button" id="btnSearchReset" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" id="btnSearch" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<form id="searchForm" method="post">
<div class="cont_block">
	<div class="search">
	<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
	<input type="hidden" id="pCardReqId" name="cardReqId"  value=""/>
	<input type="hidden" id="tradeNo" name="tradeNo"  value=""/>
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
					<td><input type="text" class="form_text w100p" name="searchCorpNameKr" id="searchCorpNameKr" onkeydown="onEnter(doSearch);"/></td>
					<th>사업자번호</th>
					<td><input type="text" class="form_text w100p" name="searchCorpRegNo" id="searchCorpRegNo" onkeydown="onEnter(doSearch);"/></td>
					<th>무역업번호</th>
					<td><input type="text" class="form_text w100p" name="searchTradeNo" id="searchTradeNo" onkeydown="onEnter(doSearch);"/></td>
				</tr>
				<tr>
					<th>카드종류</th>
					<td>
						<select name="searchCardCode" id="searchCardCode" class="form_select w100p">
							<option value="">전체</option>
							<c:forEach items="${cardList}" var="vo" varStatus="status">
							<option value="<c:out value="${vo.cardCode}" />" label="<c:out value="${ vo.cardName}" />" <c:out value="${ param.searchCardCode eq vo.cardCode ? 'selected' : '' }" /> />
							</c:forEach>
						</select>
					</td>
					<th>발급일</th>
					<td colspan="3">
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="searchStartDate" id="searchStartDate" class="txt datepicker" value="<c:out value="${ param.searchStartDate}" />" title="조회시작일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('searchStartDate')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="searchEndDate" id="searchEndDate" class="txt datepicker"value="<c:out value="${ param.searchEndDate}" />"  title="조회종료일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('searchEndDate')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
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
				<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
			</c:forEach>
		</select>
	</div>
	<div>
		<div id="cardInaccCompanySheet" class="sheet"></div>
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

		setSheetHeader_cardInaccCompanyList();		// 부정확 업체정보 목록 헤더
		getCardInaccCompanyList();					// 부정확 업체정보 목록

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

	function setSheetHeader_cardInaccCompanyList() {	// 부정확 업체정보 목록 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '카드신청ID'		, Type: 'Text'			, SaveName: 'cardReqTempId'	, Hidden: true});
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'		, SaveName: 'status'		, Hidden: true});
		ibHeader.addHeader({Header: ''				, Type: 'CheckBox'		, SaveName: 'check'			, Width: 20});
		ibHeader.addHeader({Header: '업체명'			, Type: 'Text'			, SaveName: 'corpNameKr'	, Edit: false	, Width: 60		, Align: 'Left'});
		ibHeader.addHeader({Header: '사업자등록번호'		, Type: 'Text'			, SaveName: 'corpRegNo'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '카드종류'			, Type: 'Text'			, SaveName: 'cardName'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '요청상태'			, Type: 'Text'			, SaveName: 'cardStatusNm'	, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '발급일'			, Type: 'Text'			, SaveName: 'issueDate'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '매핑'			, Type: 'Html'			, SaveName: 'mapping'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '카드상태코드'		, Type: 'Text'			, SaveName: 'cardStatus'	, Hidden: true});
		ibHeader.addHeader({Header: '카드코드'			, Type: 'Text'			, SaveName: 'cardCode'		, Hidden: true});
		ibHeader.addHeader({Header: '미매칭카운트'		, Type: 'Text'			, SaveName: 'inacCnt'		, Hidden: true});

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

		var container = $('#cardInaccCompanySheet')[0];
		createIBSheet2(container, 'cardInaccCompanySheet', '100%', '100%');
		ibHeader.initSheet('cardInaccCompanySheet');

		cardInaccCompanySheet.SetEllipsis(1); 			// 말줄임 표시여부
		cardInaccCompanySheet.SetSelectionMode(4);
	}

	function cardInaccCompanySheet_OnRowSearchEnd(row) {

		//cardInaccCompanySheet.SetColFontBold('corpNameKr', 1);

		var inacCnt = cardInaccCompanySheet.GetCellValue(row, 'inacCnt');

		if(inacCnt >= 2) {
			cardInaccCompanySheet.SetCellValue(row, 'mapping', '<button type="button" style="margin:5px 0;" class="btn_tbl_primary" onclick="">업체매핑</button>');
		} else {
			cardInaccCompanySheet.SetCellValue(row, 'mapping', '데이터없음');
		}

		cardInaccCompanySheet.SetCellValue(row, 'status', '');

	}

	function doSearch() {
		$('#pageIndex').val(1);
		getCardInaccCompanyList();
	}

	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getCardInaccCompanyList();
	}

	function chgPageCnt() {
		doSearch();
	}

	function cardInaccCompanySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {

		if(rowType == 'HeaderRow'){
			return;
		}

		if(Col == 2) {
			return;
		}


		var inacCnt = cardInaccCompanySheet.GetCellValue(Row, 'inacCnt');

		if(cardInaccCompanySheet.ColSaveName(Col) == 'mapping') {
			if(inacCnt >= 2) {
				var corpRegNo = cardInaccCompanySheet.GetCellValue(Row, 'corpRegNo');
				var cardStatus = cardInaccCompanySheet.GetCellValue(Row, 'cardStatus');
				var issueDate = cardInaccCompanySheet.GetCellValue(Row, 'issueDate');
				var cardCode = cardInaccCompanySheet.GetCellValue(Row, 'cardCode');

				openCompayPop(corpRegNo, cardStatus, issueDate, cardCode);
			}
		}
	}

	function getCardInaccCompanyList() {	// 사업정보 조회

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/kitaCard/selectInaccuracyCompanyList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParam)
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

				cardInaccCompanySheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function openCompayPop(corpRegNo, cardStatus, issueDate, cardCode) {
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/kitaCard/popup/kitaCardInaccCompanyPop.do'
			, params : { 'corpRegNo' : corpRegNo,
						 'cardStatus' : cardStatus,
						 'issueDate' : issueDate,
						 'cardCode' : cardCode
			}
			, callbackFunction : function(resultObj){
				doSearch();
			}
		});
	}

	function doClear() {	// 초기화
		location.reload();
	}

	function doDelete() {

		var deleteCnt = cardInaccCompanySheet.FindCheckedRow('check');

		if(deleteCnt <= 0) {
			alert('선택한 항목이 없습니다.');
			return;
		}

		var deleteData = cardInaccCompanySheet.GetSaveJson();

		global.ajax({
			type : 'POST'
			, url : "/kitaCard/deleteInaccuracyInfo.do"
			, contentType : 'application/json'
			, data : JSON.stringify(deleteData.data)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				getCardInaccCompanyList();
			}
		});
	}

</script>