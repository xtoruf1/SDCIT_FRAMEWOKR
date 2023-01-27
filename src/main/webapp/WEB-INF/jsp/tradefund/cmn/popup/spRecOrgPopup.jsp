<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="spRecOrgPopupForm" name="spRecOrgPopupForm" method="get" onsubmit="return false;">
<input type="hidden" name="spRecOrgPageIndex" value="<c:out value='${param.spRecOrgPageIndex}' default='1' />" />
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">추천기관 검색</h2>
	<div class="ml-auto">
		<button type="button" onclick="doSpRecOrgPopupSearch();" class="btn_sm btn_primary">검색</button>
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
					<th scope="row">기관명</th>
					<td>
						<input type="text" id="searchDetailnm" name="searchDetailnm" value=""  maxlength="20" onkeydown="onEnter(doSpRecOrgPopupSearch);" class="form_text w100p" title="기관명" />
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<!--검색 끝 -->
	<div class="cont_block mt-20">
		<div class="tbl_opt">
			<!-- 전체 게시글 -->
			<div id="spRecOrgPopupTotalCnt" class="total_count"></div>
			<fieldset class="ml-auto">
				<select id="spRecOrgPageUnit" name="spRecOrgPageUnit" onchange="doSpRecOrgPopupSearch();" title="목록수" class="form_select">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${param.spRecOrgPageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>
			</fieldset>
		</div>
		<div style="width: 100%;height: 100%;">
			<div id="spRecOrgPopupList" class="sheet"></div>
		</div>
		<div id="spRecOrgPopupPaging" class="paging ibs"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '추천기관명', Type: 'Text', SaveName: 'detailnm', Width: 500, Align: 'Left', Edit: 0, Cursor: 'Pointer'});

	ibHeader.addHeader({Header: '추천기관코드', Type: 'Text', SaveName: 'detailcd', Hidden: true});
	ibHeader.addHeader({Header: '대분류', Type: 'Text', SaveName: 'chgCode01', Hidden: true});
	ibHeader.addHeader({Header: '중분류', Type: 'Text', SaveName: 'chgCode02', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	$(document).ready(function(){
		var container = $('#spRecOrgPopupList')[0];
		if (typeof spRecOrgPopupSheet !== 'undefined' && typeof spRecOrgPopupSheet.Index !== 'undefined') {
			spRecOrgPopupSheet.DisposeSheet();
		}
		createIBSheet2(container, 'spRecOrgPopupSheet', '100%', '680px');
		ibHeader.initSheet('spRecOrgPopupSheet');
		spRecOrgPopupSheet.SetSelectionMode(4);

		getSpRecOrgPopupList();
	});

	function doSpRecOrgPopupSearch() {
		goSpRecOrgPopupPage(1);
	}

	function goSpRecOrgPopupPage(spRecOrgPageIndex) {
		document.spRecOrgPopupForm.spRecOrgPageIndex.value = spRecOrgPageIndex;

		getSpRecOrgPopupList();
	}

	function getSpRecOrgPopupList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradefund/cmn/popup/spRecOrgList.do" />'
			, data : $('#spRecOrgPopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#spRecOrgPopupTotalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				setPaging(
					'spRecOrgPopupPaging'
					, goSpRecOrgPopupPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				spRecOrgPopupSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function spRecOrgPopupSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('spRecOrgPopupSheet_OnSearchEnd : ', msg);
		} else {
			// 추천기관명 링크에 볼드 처리
			spRecOrgPopupSheet.SetColFontBold('detailnm', 1);
		}
	}

	function spRecOrgPopupSheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(Row > 0) {
			var rowData = spRecOrgPopupSheet.GetRowData(Row);

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