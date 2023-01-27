<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="penaltyForm" name="penaltyForm" method="get" onsubmit="return false;">
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="openPenaltyPopup();" class="btn_sm btn_primary btn_modify_auth">패널티 등록</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doDownloadExcel();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">발생일자</th>
				<td colspan="3">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchFromDate" name="searchFromDate" value="<c:out value="${param.searchFromDate}" default="${firstDate}" />" class="txt datepicker" placeholder="발생시작일자" title="발생시작일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('searchFromDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchToDate" name="searchToDate" value="<c:out value="${param.searchToDate}" default="${sysDate}" />" class="txt datepicker" placeholder="발생종료일자" title="발생종료일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('searchToDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
				</td>
            </tr>
            <tr>
				<th scope="row">전문가</th>
				<td>
					<select id="searchExpertId" name="searchExpertId" class="form_select" title="전문가">
						<option value="">전체</option>
						<c:forEach var="item" items="${expertList}" varStatus="status">
							<option value="${item.expertId}" <c:if test="${param.searchExpertId eq item.expertId}">selected="selected"</c:if>>${item.expertNm}</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">발생사유</th>
				<td>
					<input type="text" id="searchPenaltyReason" name="searchPenaltyReason" value="${param.searchPenaltyReason}" onkeydown="onEnter(doSearch);" class="form_text w100p" />
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
		<fieldset class="ml-auto">
			<select id="pageUnit" name="pageUnit" onchange="doSearch();" class="form_select" title="목록수">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</fieldset>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="penaltyList" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<form id="excelForm" name="excelForm" method="post">
<input type="hidden" name="searchFromDate" />
<input type="hidden" name="searchToDate" />
<input type="hidden" name="searchExpertId" />
<input type="hidden" name="searchPenaltyReason" />
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '성명', Type: 'Text', SaveName: 'expertNm', Width: 100, Align: 'Center', Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '발생일자', Type: 'Text', SaveName: 'penaltyDate', Width: 100, Align: 'Center', Format: 'yyyy-MM-dd'});
	ibHeader.addHeader({Header: '발생사유', Type: 'Text', SaveName: 'penaltyReason', Width: 200, Align: 'Left'});
	ibHeader.addHeader({Header: '패널티점수', Type: 'Text', SaveName: 'penaltyScore', Width: 80, Align: 'Center'});

	ibHeader.addHeader({Header: 'penaltyId', Type: 'Text', SaveName: 'penaltyId', Width: 0, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: 'expertId', Type: 'Text', SaveName: 'expertId', Width: 0, Align: 'Center', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	$(document).ready(function() {
		var container = $('#penaltyList')[0];
		createIBSheet2(container, 'penaltyListSheet', '100%', '100%');
		ibHeader.initSheet('penaltyListSheet');
		penaltyListSheet.SetSelectionMode(4);

		// 편집모드 OFF
		penaltyListSheet.SetEditable(0);

		// 시작일 선택 이벤트
		datepickerById('searchFromDate', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('searchToDate', toDateSelectEvent);

		getList();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchFromDate').val());

		if ($('#searchToDate').val() != '') {
			if (startymd > Date.parse($('#searchToDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchFromDate').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchToDate').val());

		if ($('#searchFromDate').val() != '') {
			if (endymd < Date.parse($('#searchFromDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchToDate').val('');

				return;
			}
		}
	}

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.penaltyForm.pageIndex.value = pageIndex;
		getList();
	}

	function getList() {
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectExpertPenaltyList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				searchFromDate : $('#searchFromDate').val().replace(/-/gi, '')
				, searchToDate : $('#searchToDate').val().replace(/-/gi, '')
				, searchExpertId : $('#searchExpertId').val()
				, searchPenaltyReason : $('#searchPenaltyReason').val()
				, pageIndex : $('#pageIndex').val()
				, pageUnit : $('select[name="pageUnit"] option:selected').val()
			}
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

				penaltyListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function penaltyListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('penaltyListSheet', row);
	}

	function penaltyListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('penaltyListSheet_OnSearchEnd : ', msg);
		} else {
			// 성명 링크에 볼드 처리
			penaltyListSheet.SetColFontBold('expertNm', 1);
		}
	}

	// 상세 화면
 	function penaltyListSheet_OnClick(Row, Col, Value) {
 		if (Row > 0) {
			if (penaltyListSheet.ColSaveName(Col) == 'expertNm') {
				var rowData = penaltyListSheet.GetRowData(Row);

				goView(rowData);
			}
		}
	}

	// 상세 화면
	function goView(penaltyObj) {
		openPenaltyPopup(penaltyObj);
	}

	// 전문가 패널티 등록/수정 팝업 화면
	function openPenaltyPopup(penaltyObj) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPenaltyPopup.do" />'
			, params : {
				penaltyId : penaltyObj ? penaltyObj.penaltyId : ''
				, expertId : penaltyObj ? penaltyObj.expertId : ''
				, penaltyReason : penaltyObj ? penaltyObj.penaltyReason : ''
				, penaltyDate : penaltyObj ? penaltyObj.penaltyDate : ''
				, penaltyScore : penaltyObj ? penaltyObj.penaltyScore : ''
			}
			, callbackFunction : function(resultObj){
				var action = resultObj.action;

				if (action == 'IU') {
					mergeExpertPenalty(resultObj);
				} else if (action == 'D') {
					deleteExpertPenalty(resultObj);
				}
			}
		});
    }

	// 전문가 패널티 등록/수정
	function mergeExpertPenalty(penaltyObj) {
		var url = '<c:url value="/tradeSOS/exp/insertExpertPenalty.do" />';

		var penaltyId = penaltyObj.popupPenaltyId;

		if (!isStringEmpty(penaltyId)) {
			url = '<c:url value="/tradeSOS/exp/updateExpertPenalty.do" />';
		}

		var penaltyDate = (penaltyObj.popupPenaltyDate || '');

		global.ajax({
			url : url
			, dataType : 'json'
			, type : 'POST'
			, data : {
				penaltyId : penaltyId
				, expertId : penaltyObj.popupExpertId
				, penaltyReason : penaltyObj.popupPenaltyReason
				, penaltyDate : penaltyDate.replace(/-/gi, '')
				, penaltyScore : penaltyObj.popupPenaltyScore
			}
			, async : true
			, spinner : true
			, success : function(data){
				// 레이어 닫기
				closeLayerPopup();

				getList();
			}
		});
	}

	function deleteExpertPenalty(resultObj) {
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/deleteExpertPenalty.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				penaltyId : resultObj.penaltyId
			}
			, async : true
			, spinner : true
			, success : function(data){
				// 레이어 닫기
				closeLayerPopup();

				getList();
			}
		});
	}

	function setDefaultPickerValue(objId) {
		if (objId == 'searchFromDate') {
			$('#searchFromDate').val('');
		} else if (objId == 'searchToDate') {
			$('#searchToDate').val('');
		}
	}

	// 엑셀다운로드
	function doDownloadExcel() {
		var searchFromDate = $('#searchFromDate').val().replace(/-/gi, '');
		var searchToDate = $('#searchToDate').val().replace(/-/gi, '');

		var f = document.excelForm;
		f.action = '<c:url value="/tradeSOS/exp/expertPenaltyExcelList.do" />';
		f.searchFromDate.value = searchFromDate;
		f.searchToDate.value = searchToDate;
		f.searchExpertId.value = $('#searchExpertId').val();
		f.searchPenaltyReason.value = $('#searchPenaltyReason').val();
		f.target = '_self';
		f.submit();
	}
</script>