<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="applyForm" name="applyForm" method="get" onsubmit="return false;">
<input type="hidden" id="applicationId" name="applicationId" value="0" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
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
				<th scope="row">신청일자</th>
				<td colspan="3">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchFromDate" name="searchFromDate" value="${searchVO.searchFromDate}" class="txt datepicker" placeholder="신청시작일자" title="신청시작일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('searchFromDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchToDate" name="searchToDate" value="${searchVO.searchToDate}" class="txt datepicker" placeholder="신청종료일자" title="신청종료일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('searchToDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
				</td>
            </tr>
            <tr>
				<th scope="row">지원분야</th>
				<td>
					<select id="searchConsult" name="searchConsult" class="form_select" title="지원분야">
						<option value="">전체</option>
						<c:forEach var="item" items="${consultList}" varStatus="status">
							<option value="${item.CONSULT_TYPE_CD}" <c:if test="${param.searchConsult eq item.CONSULT_TYPE_CD}">selected="selected"</c:if>>${item.CONSULT_TYPE_NM}</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">활동국가 / 지역</th>
				<td>
					<select id="searchNation" name="searchNation" onchange="setRegion(this.value);" class="form_select" title="활동국가">
						<option value="">전체</option>
						<c:forEach var="item" items="${nationList}" varStatus="status">
							<option value="${item.CODE}" <c:if test="${param.searchNation eq item.CODE}">selected="selected"</c:if>>${item.CODE_NM}</option>
						</c:forEach>
					</select>
					<select name="searchRegion" id="searchRegion" class="form_select" title="지역">
						<option value="">전체</option>
						<c:forEach var="item" items="${regionList}" varStatus="status">
							<option value="${item.cdId}" <c:if test="${param.searchRegion eq item.cdId}">selected="selected"</c:if>>${item.cdNm}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
            <tr>
            	<th scope="row">상태</th>
				<td>
					<select id="searchStatusCd" name="searchStatusCd" class="form_select" title="상태">
						<option value="">전체</option>
						<c:forEach var="item" items="${statusList}" varStatus="status">
							<option value="${item.cdId}" <c:if test="${param.searchStatusCd eq item.cdId}">selected="selected"</c:if>>${item.cdNm}</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">성명</th>
				<td>
					<input type="text" id="searchExpertNm" name="searchExpertNm" value="${param.searchExpertNm}" onkeydown="onEnter(doSearch);" class="form_text w100p" />
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
		<div id="applyList" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<form id="excelForm" name="excelForm" method="post">
<input type="hidden" name="searchFromDate" />
<input type="hidden" name="searchToDate" />
<input type="hidden" name="searchConsult" />
<input type="hidden" name="searchNation" />
<input type="hidden" name="searchRegion" />
<input type="hidden" name="searchStatusCd" />
<input type="hidden" name="searchExpertNm" />
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '지원분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 330, Align: 'Left', Ellipsis: 1});
	ibHeader.addHeader({Header: '성명', Type: 'Text', SaveName: 'expertNm', Width: 120, Align: 'Center', Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '활동국가', Type: 'Text', SaveName: 'atvCtrNm', Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '지역', Type: 'Text', SaveName: 'atvAreaNm', Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '휴대전화', Type: 'Text', SaveName: 'cellPhone', Width: 120, Align: 'Center', Format: '###-####-####'});
	ibHeader.addHeader({Header: '신청일자', Type: 'Text', SaveName: 'creDate', Width: 100, Align: 'Center', Format: '####-##-##'});
	ibHeader.addHeader({Header: '상태', Type: 'Text', SaveName: 'statusNm', Width: 80, Align: 'Center'});

	ibHeader.addHeader({Header: '시퀀스', Type: 'Text', SaveName: 'applicationId', Width: 0, Align: 'Center', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	$(document).ready(function(){
		var container = $('#applyList')[0];
		createIBSheet2(container, 'applyListSheet', '100%', '100%');
		ibHeader.initSheet('applyListSheet');
		applyListSheet.SetSelectionMode(4);

		// 편집모드 OFF
		applyListSheet.SetEditable(0);

		var nationValue = '${param.searchNation}';
		if (nationValue != 'KR') {
			$('#searchRegion').hide();
		} else {
			$('#searchRegion').val('');
			$('#searchRegion').show();
		}

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
		document.applyForm.pageIndex.value = pageIndex;
		getList();
	}

	function getList() {
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/expertSupportStatusListAjax.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				searchFromDate : $('#searchFromDate').val().replace(/-/gi, '')
				, searchToDate : $('#searchToDate').val().replace(/-/gi, '')
				, searchConsult : $('#searchConsult').val()
				, searchNation : $('#searchNation').val()
				, searchRegion : $('#searchRegion').val()
				, searchStatusCd : $('#searchStatusCd').val()
				, searchExpertNm : $('#searchExpertNm').val()
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

				applyListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function applyListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('applyListSheet', row);
	}

	function applyListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('applyListSheet_OnSearchEnd : ', msg);
		} else {
			// 성명 링크에 볼드 처리
			applyListSheet.SetColFontBold('expertNm', 1);
		}
	}

	// 상세 화면
 	function applyListSheet_OnClick(Row, Col, Value) {
 		if (Row > 0) {
			if (applyListSheet.ColSaveName(Col) == 'expertNm') {
				var applicationId = applyListSheet.GetCellValue(Row, 'applicationId');

				goView(applicationId);
			}
		}
	}

	function goView(applicationId) {
		document.applyForm.action = '<c:url value="/tradeSOS/exp/expertSupportStatusDetail.do" />';
		document.applyForm.applicationId.value = applicationId;
		document.applyForm.submit();
	}

	function setRegion(val) {
		if (val.trim() == 'KR'.trim()) {
			$('#searchRegion').show();
		} else {
			$('#searchRegion').hide();
		}
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
		f.action = '<c:url value="/tradeSOS/exp/expertSupportStatusExcelList.do" />';
		f.searchFromDate.value = searchFromDate;
		f.searchToDate.value = searchToDate;
		f.searchConsult.value = $('#searchConsult').val();
		f.searchNation.value = $('#searchNation').val();
		f.searchRegion.value = $('#searchRegion').val();
		f.searchStatusCd.value = $('#searchStatusCd').val();
		f.searchExpertNm.value = $('#searchExpertNm').val();
		f.target = '_self';
		f.submit();
	}
</script>