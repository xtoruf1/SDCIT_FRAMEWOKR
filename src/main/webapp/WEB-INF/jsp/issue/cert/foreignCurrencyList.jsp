<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="frm" name="frm" method="get" onsubmit="return false;">
<input type="hidden" id="foreignReceiptId" name="foreignReceiptId" value="" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="btnGroup ml-auto">
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:10%" />
			<col style="width:13%" />
			<col style="width:10%" />
			<col style="width:13%" />
			<col style="width:10%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">업체명</th>
				<td>
					<input type="text" id="sCompanyName" name="sCompanyName" value="${param.sCompanyName}" onkeydown="onEnter(doSearch);" class="form_text w100p" title="업체명" />
				</td>
				<th scope="row">사업자번호</th>
				<td>
					<input type="text" id="sBusinessNo" name="sBusinessNo" value="${param.sBusinessNo}" onkeydown="onEnter(doSearch);" class="form_text w100p" title="사업자번호" />
				</td>
				<th scope="row">무역업번호</th>
				<td>
					<input type="text" id="sTradeNo" name="sTradeNo" value="${param.sTradeNo}" onkeydown="onEnter(doSearch);" class="form_text w100p" title="무역업번호" />
				</td>
            </tr>
			<tr>
				<th scope="row">대표자</th>
				<td>
					<input type="text" id="sCeoName" name="sCeoName" value="${param.sCeoName}" onkeydown="onEnter(doSearch);" class="form_text w100p" title="대표자" />
				</td>
				<th scope="row">상태</th>
				<td>
					<select id="sStatusCd" name="sStatusCd" class="form_select">
						<option value="" <c:if test="${empty param.sStatusCd or param.sStatusCd eq ''}">selected="selected"</c:if>>::: 전체 :::</option>
						<c:forEach var="list" items="${statusCdList}" varStatus="status">
						<option value="${list.code}" <c:if test="${param.sStatusCd eq list.code}">selected="selected"</c:if>>${list.codeNm}</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">출력여부</th>
				<td>
					<label class="label_form">
						<input type="radio" name="sPrintYn" value="" class="form_radio" title="개인정보 조회" <c:if test="${empty param.sPrintYn or param.sPrintYn eq ''}">checked="checked"</c:if> />
						<span class="label">전체</span>
					</label>
					<label class="label_form">
						<input type="radio" name="sPrintYn" value="Y" class="form_radio" title="개인정보 조회" <c:if test="${param.sPrintYn eq 'Y'}">checked="checked"</c:if> />
						<span class="label">출력</span>
					</label>
					<label class="label_form">
						<input type="radio" name="sPrintYn" value="N" class="form_radio" title="개인정보 조회" <c:if test="${param.sPrintYn eq 'N'}">checked="checked"</c:if> />
						<span class="label">미출력</span>
					</label>
				</td>
            </tr>
			<tr>
				<th scope="row">신청일</th>
				<td colspan="5">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="sStartDate" name="sStartDate" value="${param.sStartDate}" class="txt datepicker" style="width: 110px;" placeholder="신청기간 시작" title="신청기간 시작" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('sStartDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="sEndDate" name="sEndDate" value="${param.sEndDate}" class="txt datepicker" style="width: 110px;" placeholder="신청기간 종료" title="신청기간 종료" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('sEndDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div class="tbl_opt">
		<!-- 전체 게시글 -->
		<div id="totalCnt" class="total_count"></div>
		<fieldset class="ml-auto">
			<select id="pageUnit" name="pageUnit" onchange="doSearch();" title="목록수" class="form_select">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</fieldset>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="sheetDiv" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', 				Type: 'Status', SaveName: 'status', 		Hidden: true});
	ibHeader.addHeader({Header: 'foreignReceiptId',	Type: 'Text', 	SaveName: 'foreignReceiptId', Hidden: true});
	ibHeader.addHeader({Header: 'No',				Type: 'Text', 	SaveName: 'idx', 			Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '업체명',				Type: 'Text', 	SaveName: 'companyName', 	Width: 300, Align: 'Left', Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '사업자번호',			Type: 'Text', 	SaveName: 'businessNo', 	Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '무역업번호',			Type: 'Text', 	SaveName: 'tradeNo', 		Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '대표자',				Type: 'Text', 	SaveName: 'ceoName',		Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '신청일',				Type: 'Text', 	SaveName: 'reqDate', 		Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '상태',				Type: 'Text', 	SaveName: 'statusNm', 		Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '출력여부',			Type: 'Text', 	SaveName: 'printYn', 		Width: 100, Align: 'Center'});
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	var f;
	$(document).ready(function(){
		f = document.frm;

		//시트 초기화
		var container = $('#sheetDiv')[0];
		createIBSheet2(container, 'foreignCurrencySheet', '100%', '100%');
		ibHeader.initSheet('foreignCurrencySheet');
		foreignCurrencySheet.SetSelectionMode(4);

		// 시작일 선택 이벤트
		datepickerById('sStartDate', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('sEndDate', toDateSelectEvent);

		//목록조회 호출
		getList();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#sStartDate').val());
		if ($('#sEndDate').val() != '') {
			if (startymd > Date.parse($('#sEndDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#sStartDate').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#sEndDate').val());

		if ($('#sStartDate').val() != '') {
			if (endymd < Date.parse($('#sStartDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#sEndDate').val('');

				return;
			}
		}
	}

	//시트가 조회된 후 실행
	function foreignCurrencySheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('foreignCurrencySheet_OnSearchEnd : ', msg);
    	} else {
    		// 업체명에 볼드 처리
			foreignCurrencySheet.SetColFontBold('companyName', 1);
    	}
    }

	//시트 조회 완료 후 하나하나의 행마다 실행
	function foreignCurrencySheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('foreignCurrencySheet', row);
	}

	//시트 클릭 이벤트
	function foreignCurrencySheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (foreignCurrencySheet.ColSaveName(col) == 'companyName') {
				var foreignReceiptId = foreignCurrencySheet.GetCellValue(row, 'foreignReceiptId');
				goView(foreignReceiptId);
		    }
		}
	}

	//검색
	function doSearch() {
		goPage(1);
	}

	//페이징 검색
	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		getList();
	}

	//달력 초기화
	function setDefaultPickerValue(objId) {
		$('#'+objId).val('');
	}

	//목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/issue/cert/selectForeignCurrencyList.do" />'
			, data : $('#frm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				foreignCurrencySheet.LoadSearchData({Data: data.resultList});
			}
		});
	}



	//상세조회 화면
	function goView(foreignReceiptId) {
		f.action = '<c:url value="/issue/cert/foreignCurrencyDetail.do" />';
		f.foreignReceiptId.value = foreignReceiptId;
		f.target = '_self';
		f.submit();
	}

</script>