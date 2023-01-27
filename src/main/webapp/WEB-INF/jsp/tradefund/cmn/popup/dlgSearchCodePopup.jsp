<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="dlgSearchCodePopupForm" name="dlgSearchCodePopupForm" method="get" onsubmit="return false;">
<input type="hidden" name="dlgSearchCodePageIndex" value="<c:out value='${param.dlgSearchCodePageIndex}' default='1' />" />
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">
		<c:choose>
			<c:when test="${param.searchGb eq '32130'}">
				직급 검색
			</c:when>
			<c:otherwise>
				직위 검색
			</c:otherwise>
		</c:choose>
	</h2>
	<div class="ml-auto">
		<button type="button" onclick="doDlgSearchCodePopupSearch();" class="btn_sm btn_primary">검색</button>
		<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
	</div>
</div>
<div class="popup_body" style="max-width: 600px;">
	<!--검색 시작 -->
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width: 15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">
						<c:choose>
							<c:when test="${param.searchGb eq '32130'}">
								직급명
							</c:when>
							<c:otherwise>
								직위명
							</c:otherwise>
						</c:choose>
					</th>
					<td>
						<input type="text" id="searchPopupText" name="searchPopupText" value=""  maxlength="100" onkeydown="onEnter(doDlgSearchCodePopupSearch);" class="form_text w100p" title="직위명/직급명" />
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<!--검색 끝 -->
	<div class="cont_block mt-20">
		<div class="tbl_opt">
			<!-- 전체 게시글 -->
			<div id="dlgSearchCodePopupTotalCnt" class="total_count"></div>
			<fieldset class="ml-auto">
				<select id="dlgSearchCodePageUnit" name="dlgSearchCodePageUnit" onchange="doDlgSearchCodePopupSearch();" title="목록수" class="form_select">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${param.dlgSearchCodePageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>
			</fieldset>
		</div>
		<div style="width: 100%;height: 100%;">
			<div id="dlgSearchCodePopupList" class="sheet"></div>
		</div>
		<div id="dlgSearchCodePopupPaging" class="paging ibs"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	<c:choose>
		<c:when test="${param.searchGb eq '32130'}">
			ibHeader.addHeader({Header: '직급', Type: 'Text', SaveName: 'detailnm', Width: 150, Align: 'Center', Edit: 0, Cursor: 'Pointer'});
			ibHeader.addHeader({Header: '계급', Type: 'Text', SaveName: 'chgCode01', Width: 250, Align: 'Left', Edit: 0});
		</c:when>
		<c:otherwise>
			ibHeader.addHeader({Header: '직위', Type: 'Text', SaveName: 'detailnm', Width: 150, Align: 'Center', Edit: 0, Cursor: 'Pointer'});
			ibHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'chgCode01', Width: 250, Align: 'Left', Edit: 0});
		</c:otherwise>
	</c:choose>

	ibHeader.addHeader({Header: '직급직위코드', Type: 'Text', SaveName: 'detailcd', Hidden: true});
	ibHeader.addHeader({Header: '중분류', Type: 'Text', SaveName: 'chgCode02', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	$(document).ready(function(){
		var container = $('#dlgSearchCodePopupList')[0];
		if (typeof dlgSearchCodePopupSheet !== 'undefined' && typeof dlgSearchCodePopupSheet.Index !== 'undefined') {
			dlgSearchCodePopupSheet.DisposeSheet();
		}
		createIBSheet2(container, 'dlgSearchCodePopupSheet', '100%', '680px');
		ibHeader.initSheet('dlgSearchCodePopupSheet');
		dlgSearchCodePopupSheet.SetSelectionMode(4);

		getDlgSearchCodePopupList();
	});

	function doDlgSearchCodePopupSearch() {
		goDlgSearchCodePopupPage(1);
	}

	function goDlgSearchCodePopupPage(dlgSearchCodePageIndex) {
		document.dlgSearchCodePopupForm.dlgSearchCodePageIndex.value = dlgSearchCodePageIndex;

		getDlgSearchCodePopupList();
	}

	function getDlgSearchCodePopupList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradefund/cmn/popup/dlgSearchCodeList.do" />'
			, data : $('#dlgSearchCodePopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#dlgSearchCodePopupTotalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				setPaging(
					'dlgSearchCodePopupPaging'
					, goDlgSearchCodePopupPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				dlgSearchCodePopupSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function dlgSearchCodePopupSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('dlgSearchCodePopupSheet_OnSearchEnd : ', msg);
		} else {
			// 직급/직위 링크에 볼드 처리
			dlgSearchCodePopupSheet.SetColFontBold('detailnm', 1);
		}
	}

	function dlgSearchCodePopupSheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(Row > 0) {
			var rowData = dlgSearchCodePopupSheet.GetRowData(Row);

			// 콜백
			layerPopupCallback(rowData);

			// 레이어 닫기
			closeLayerPopup();
		}
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>