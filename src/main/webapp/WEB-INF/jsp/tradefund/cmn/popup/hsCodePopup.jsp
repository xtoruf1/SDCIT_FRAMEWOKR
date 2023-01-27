<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="hsCodePopupForm" name="hsCodePopupForm" method="get" onsubmit="return false;">
<input type="hidden" name="hsCodePageIndex" value="<c:out value='${param.hsCodePageIndex}' default='1' />" />
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">HS CODE 검색</h2>
	<div class="ml-auto">
		<button type="button" onclick="doHsCodePopupSearch();" class="btn_sm btn_primary">검색</button>
		<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
	</div>
</div>
<div class="popup_body" style="max-width: 700px;">
	<!--검색 시작 -->
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width: 15%" />
				<col />
				<col style="width: 15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">코드</th>
					<td>
						<input type="text" id="searchHsCd" name="searchHsCd" value=""  maxlength="10" onkeydown="onEnter(doHsCodePopupSearch);" class="form_text w100p" title="코드" />
					</td>
					<th scope="row">품목명</th>
					<td>
						<input type="text" id="searchKorName" name="searchKorName" value=""  maxlength="20" onkeydown="onEnter(doHsCodePopupSearch);" class="form_text w100p" title="품목명" />
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<!--검색 끝 -->
	<div class="cont_block mt-20">
		<div class="tbl_opt">
			<!-- 전체 게시글 -->
			<div id="hsCodePopupTotalCnt" class="total_count"></div>
			<fieldset class="ml-auto">
				<select id="hsCodePageUnit" name="hsCodePageUnit" onchange="doHsCodePopupSearch();" title="목록수" class="form_select">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${param.hsCodePageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>
			</fieldset>
		</div>
		<div style="width: 100%;height: 100%;">
			<div id="hsCodePopupList" class="sheet"></div>
		</div>
		<div id="hsCodePopupPaging" class="paging ibs"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: 'HS CODE', Type: 'Text', SaveName: 'hsCd', Width: 150, Align: 'Left', Edit: 0, Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '품목명', Type: 'Text', SaveName: 'korName', Width: 250, Align: 'Left', Edit: 0});

	ibHeader.addHeader({Header: 'MTI CODE', Type: 'Text', SaveName: 'mtiCd', Width: 100, Align: 'Center', Edit: 0, Hidden: true});
	ibHeader.addHeader({Header: 'MTI명', Type: 'Text', SaveName: 'mtiNm', Width: 100, Align: 'Center', Edit: 0, Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	$(document).ready(function(){
		var container = $('#hsCodePopupList')[0];
		if (typeof hsCodePopupSheet !== 'undefined' && typeof hsCodePopupSheet.Index !== 'undefined') {
			hsCodePopupSheet.DisposeSheet();
		}
		createIBSheet2(container, 'hsCodePopupSheet', '100%', '680px');
		ibHeader.initSheet('hsCodePopupSheet');
		hsCodePopupSheet.SetSelectionMode(4);

		getHsCodePopupList();
	});

	function doHsCodePopupSearch() {
		goHsCodePopupPage(1);
	}

	function goHsCodePopupPage(hsCodePageIndex) {
		document.hsCodePopupForm.hsCodePageIndex.value = hsCodePageIndex;

		getHsCodePopupList();
	}

	function getHsCodePopupList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradefund/cmn/popup/hsCodeList.do" />'
			, data : $('#hsCodePopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#hsCodePopupTotalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				setPaging(
					'hsCodePopupPaging'
					, goHsCodePopupPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				hsCodePopupSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function hsCodePopupSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('hsCodePopupSheet_OnSearchEnd : ', msg);
		} else {
			// HS CODE 링크에 볼드 처리
			hsCodePopupSheet.SetColFontBold('hsCd', 1);
		}
	}

	function hsCodePopupSheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(Row > 0) {
			var rowData = hsCodePopupSheet.GetRowData(Row);

			// 콜백
			layerPopupCallback(rowData);
		}
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>