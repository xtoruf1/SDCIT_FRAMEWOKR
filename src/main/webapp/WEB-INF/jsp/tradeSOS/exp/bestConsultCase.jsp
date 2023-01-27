<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="consultForm" name="consultForm" method="get" onsubmit="return false;">
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<input type="hidden" name="consultTypeArray" value="" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" id="bestCaseSave" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doDownloadExcel();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<div class="foldingTable fold">
		<div class="foldingTable_inner">
			<table class="formTable">
				<colgroup>
					<col style="width: 15%;" />
					<col />
					<col style="width: 15%;" />
					<col />
					<col style="width: 15%;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">상담서비스</th>
						<td>
							<select id="searchConsultService" name="searchConsultService" class="form_select" title="상담 서비스">
								<option value="">전체</option>
								<option value="0" <c:if test="${param.searchConsultService eq '0'}">selected="selected"</c:if>>오픈상담</option>
								<option value="1" <c:if test="${param.searchConsultService eq '1'}">selected="selected"</c:if>>1:1상담</option>
							</select>
						</td>
						<th scope="row">상담채널</th>
						<td colspan="3">
							<select id="searchConsultChannel" name="searchConsultChannel" class="form_select" title="상담채널">
								<option value="">전체</option>
								<c:forEach var="item" items="${consultChannelList}" varStatus="status">
									<option value="${item.cdId}" <c:if test="${param.searchConsultChannel eq item.cdId}">selected="selected"</c:if>>${item.cdNm}</option>
								</c:forEach>
								<option value="04" <c:if test="${param.searchConsultChannel eq '04'}">selected="selected"</c:if>>온라인</option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">상담분야</th>
						<td colspan="5">
							<c:forEach var="item" items="${consultTypeList}" varStatus="status">
								<label class="label_form list">
									<input type="checkbox" name="searchConsultTypeCd" value="${item.consultTypeCd}" class="form_checkbox" title="${item.consultTypeNm}" />
									<span class="label">${item.consultTypeNm}</span>
								</label>
							</c:forEach>
						</td>
		            </tr>
		            <tr>
		            	<th scope="row">신청자</th>
						<td>
							<input type="text" id="searchReqNm" name="searchReqNm" value="${param.searchReqNm}" onkeydown="onEnter(doSearch);" class="form_text w100p" />
						</td>
						<th scope="row">전문가</th>
						<td>
							<select id="searchExpertId" name="searchExpertId" class="form_select" title="전문가">
								<option value="">전체</option>
								<c:forEach var="item" items="${expertList}" varStatus="status">
									<option value="${item.expertId}" <c:if test="${param.searchExpertId eq item.expertId}">selected="selected"</c:if>>${item.expertNm}</option>
								</c:forEach>
							</select>
						</td>
						<th scope="row">제목 및 상담요지</th>
						<td>
							<input type="text" id="searchConsultText" name="searchConsultText" value="${param.searchConsultText}" onkeydown="onEnter(doSearch);" class="form_text w100p" />
						</td>
		            </tr>
		            <tr>
		            	<th scope="row">채택 여부</th>
						<td>
							<select id="searchChooseYn" name="searchChooseYn" class="form_select" title="채택 여부">
								<option value="">전체</option>
								<option value="Y" <c:if test="${param.searchChooseYn eq 'Y'}">selected="selected"</c:if>>채택</option>
								<option value="N" <c:if test="${param.searchChooseYn eq 'N'}">selected="selected"</c:if>>미채택</option>
							</select>
						</td>
						<th scope="row">일자</th>
						<td colspan="3">
							<div class="group_datepicker">
								<div style="margin-right: 10px;">
									<select id="searchDateType" name="searchDateType" class="form_select" title="일자">
										<option value="1" <c:if test="${param.searchDateType eq '1'}">selected="selected"</c:if>>답변일자</option>
										<option value="2" <c:if test="${param.searchDateType eq '2'}">selected="selected"</c:if>>접수일자</option>
									</select>
								</div>
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchFromDate" name="searchFromDate" value="${param.searchFromDate}" class="txt datepicker" style="width: 100px;" placeholder="시작일자" title="시작일자" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									</span>
									<button type="button" onclick="setDefaultPickerValue('searchFromDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
								</div>
								<div class="spacing">~</div>
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchToDate" name="searchToDate" value="${param.searchToDate}" class="txt datepicker" style="width: 100px;" placeholder="종료일자" title="종료일자" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									</span>
									<button type="button" onclick="setDefaultPickerValue('searchToDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
								</div>
							</div>
						</td>
		            </tr>
				</tbody>
			</table>
		</div>
		<button class="btn_folding" title="테이블접기"></button>
	</div>
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
		<div id="consultList" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상담서비스', Type: 'Text', SaveName: 'consultService', Width: 80, Align: 'Center', Edit: false});
	ibHeader.addHeader({Header: '상담채널', Type: 'Text', SaveName: 'consultChannel', Width: 80, Align: 'Center', Edit: false});
	ibHeader.addHeader({Header: '상담분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 120, Align: 'Center', Edit: false});
	ibHeader.addHeader({Header: '상담제목', Type: 'Text', SaveName: 'reqTitle', Width: 240, Align: 'Left', Cursor: 'Pointer', Ellipsis: true, Edit: false});
	ibHeader.addHeader({Header: '신청자', Type: 'Text', SaveName: 'reqUserNm', Width: 100, Align: 'Center', Ellipsis: true, Edit: false});
	ibHeader.addHeader({Header: '전문가', Type: 'Text', SaveName: 'expertNm', Width: 90, Align: 'Center', Ellipsis: true, Edit: false});
	ibHeader.addHeader({Header: '평점', Type: 'Int', SaveName: 'avgScore', Width: 70, Align: 'Center', Format: '#,##0', Edit: false});
	ibHeader.addHeader({Header: '채택여부', Type: 'Text', SaveName: 'chooseYn', Width: 70, Align: 'Center', Edit: false});
	ibHeader.addHeader({Header: '조회수', Type: 'Int', SaveName: 'viewCnt', Width: 70, Align: 'Center', Format: '#,##0', Edit: false});
	ibHeader.addHeader({Header: '신청일', Type: 'Text', SaveName: 'reqDt', Width: 90, Align: 'Center', Format: 'yyyy-MM-dd', Edit: false});
	ibHeader.addHeader({Header: '답변일', Type: 'Text', SaveName: 'ansDt', Width: 90, Align: 'Center', Format: 'yyyy-MM-dd', Edit: false});
	ibHeader.addHeader({Header: 'BEST 사례 선정', Type: 'CheckBox', SaveName: 'selectYn', Width: 110, Align: 'Center', ItemCode: 'Y|N', ItemText: '&nbsp;Y|&nbsp;N', MaxCheck: 1, RadioIcon: 1, Edit: true});

	ibHeader.addHeader({Header: 'consultCd', Type: 'Text', SaveName: 'consultCd', Width: 0, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: 'consultId', Type: 'Text', SaveName: 'consultId', Width: 0, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: 'answerId', Type: 'Text', SaveName: 'answerId', Width: 0, Align: 'Center', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	$(document).ready(function() {
		var now = new Date();				// 현재 날짜 및 시간
		var day = now.getDate();

		// 매월 1 ~ 15일만 저장을 할 수 있다.
		/*
		if (day > 15) {
			$('#bestCaseSave').addClass('disabled');
			$('#bestCaseSave').attr('disabled', true);
		}
		*/

		var container = $('#consultList')[0];
		createIBSheet2(container, 'consultListSheet', '100%', '100%');
		ibHeader.initSheet('consultListSheet');
		consultListSheet.SetSelectionMode(4);

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
		document.consultForm.pageIndex.value = pageIndex;
		getList();
	}

	function getList() {
		var consultTypeArray = [];
		for (var i = 0; i < $('input[name="searchConsultTypeCd"]').length; i++) {
			if ($('input[name="searchConsultTypeCd"]').eq(i).is(':checked')) {
				consultTypeArray.push($('input[name="searchConsultTypeCd"]').eq(i).val());
			}
		}

		var searchFromDate = $('#searchFromDate').val().replace(/-/gi, '');
		var searchToDate = $('#searchToDate').val().replace(/-/gi, '');

		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectBestCaseList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				searchConsultService : $('#searchConsultService').val()
				, searchConsultChannel : $('#searchConsultChannel').val()
				, consultTypeCdList : consultTypeArray
				, searchReqNm : $('#searchReqNm').val()
				, searchExpertId : $('#searchExpertId').val()
				, searchConsultText : $('#searchConsultText').val()
				, searchChooseYn : $('#searchChooseYn').val()
				, searchDateType : $('#searchDateType').val()
				, searchFromDate : searchFromDate
				, searchToDate : searchToDate
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

				consultListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function consultListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('consultListSheet', row);
	}

	function consultListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('consultListSheet_OnSearchEnd : ', msg);
		} else {
			// 제목 링크에 볼드 처리
			consultListSheet.SetColFontBold('reqTitle', 1);
		}
	}

	// 상세화면
 	function consultListSheet_OnClick(Row, Col, Value) {
		if (Row > 0) {
			if (consultListSheet.ColSaveName(Col) == 'reqTitle') {
				var rowData = consultListSheet.GetRowData(Row);

				var consultCd = consultListSheet.GetCellValue(Row, 'consultCd');
				var consultId = consultListSheet.GetCellValue(Row, 'consultId');
				var answerId = consultListSheet.GetCellValue(Row, 'answerId');

				openBestCasePopup(consultCd, consultId, answerId);
			}
		}
	}

	// BEST 상담사례 상세 팝업
	function openBestCasePopup(consultCd, consultId, answerId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/bestConsultCaseDetailPopup.do" />'
			, params : {
				consultCd : consultCd
				, consultId : consultId
				, answerId : (answerId || '0')
			}
			, callbackFunction : function(resultObj){
				// 레이어 닫기
				closeLayerPopup();

				getList();
			}
		});
    }

	// BEST 사례 선정 여부 저장
	function doSave() {
		if (confirm('BEST 상담 사례로 선정 하시겠습니까?')) {
			// 시트의 모든 데이터를 json 객체로 추출
			var jsonData = consultListSheet.ExportData({
				'Type' : 'json'
			});

			var paramList = [];
			if (jsonData.data.length > 0) {
				jsonData.data.forEach(function(item){
					paramList.push({
						consultCd : item.consultCd
						, selectYn : (item.selectYn || '') == 'Y:1|N:0' ? 'Y' : 'N'
						, consultId : item.consultId
						, answerId : (item.answerId || '0')
					});
				});
			}

			global.ajax({
				url : '<c:url value="/tradeSOS/exp/saveSelectBestConsultCase.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					caseList : paramList
				}
				, async : true
				, spinner : true
				, success : function(data){
					getList();
				}
			});
		}
	}

	// 엑셀다운로드
	function doDownloadExcel() {
		var consultTypeArray = [];
		for (var i = 0; i < $('input[name="searchConsultTypeCd"]').length; i++) {
			if ($('input[name="searchConsultTypeCd"]').eq(i).is(':checked')) {
				consultTypeArray.push($('input[name="searchConsultTypeCd"]').eq(i).val());
			}
		}

		var f = document.consultForm;
		f.action = '<c:url value="/tradeSOS/exp/selectBestCaseExcelList.do" />';
		f.consultTypeArray.value = consultTypeArray.join(',')
		f.method = 'post';
		f.target = '_self';
		f.submit();
		f.method = 'get';
	}

	function setDefaultPickerValue(objId) {
		$('#' + objId).val('');
	}
</script>