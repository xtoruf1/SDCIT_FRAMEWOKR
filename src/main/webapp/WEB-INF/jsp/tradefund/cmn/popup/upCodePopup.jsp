<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="upCodePopupForm" name="upCodePopupForm" method="get" onsubmit="return false;">
<input type="hidden" name="upCodePageIndex" value="<c:out value='${param.upCodePageIndex}' default='1' />" />
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">업종코드 검색</h2>
	<div class="ml-auto">
		<button type="button" onclick="doUpCodePopupSearch();" class="btn_sm btn_primary">검색</button>
		<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
	</div>
</div>
<div class="popup_body" style="max-width: 900px;">
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
					<th scope="row">대분류</th>
					<td>
						<select id="searchChgCode01" name="searchChgCode01" onchange="showUpCodePopupChgCodeList();" class="form_select" style="width: 100%;" title="대분류"">
							<option value="">::: 선택 :::</option>
							<c:forEach var="item" items="${upCodeDep1}" varStatus="status">
								<option value="<c:out value="${item.chgCode01}" />"><c:out value="${item.chgCode01}" /></option>
							</c:forEach>
						</select>
					</td>
					<th scope="row">중분류</th>
					<td>
						<select id="searchChgCode02" name="searchChgCode02" class="form_select" style="width: 100%;" title="중분류"">
							<option value="">::: 선택 :::</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">업종코드</th>
					<td>
						<input type="text" id="searchDetailcd" name="searchDetailcd" value=""  maxlength="6" onkeydown="onEnter(doUpCodePopupSearch);" class="form_text w100p" title="업종코드" />
					</td>
					<th scope="row">업종명</th>
					<td>
						<input type="text" id="searchDetailnm" name="searchDetailnm" value=""  maxlength="50" onkeydown="onEnter(doUpCodePopupSearch);" class="form_text w100p" title="업종명" />
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<!--검색 끝 -->
	<div class="cont_block mt-20">
		<div class="tbl_opt">
			<!-- 전체 게시글 -->
			<div id="upCodePopupTotalCnt" class="total_count"></div>
			<fieldset class="ml-auto">
				<select id="upCodePageUnit" name="upCodePageUnit" onchange="doUpCodePopupSearch();" title="목록수" class="form_select">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${param.upCodePageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>
			</fieldset>
		</div>
		<div style="width: 100%;height: 100%;">
			<div id="upCodePopupList" class="sheet"></div>
		</div>
		<div id="upCodePopupPaging" class="paging ibs"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '업종코드', Type: 'Text', SaveName: 'detailcd', Width: 120, Align: 'Center', Edit: 0, Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '대분류', Type: 'Text', SaveName: 'chgCode01', Width: 150, Align: 'Left', Edit: 0});
	ibHeader.addHeader({Header: '중분류', Type: 'Text', SaveName: 'chgCode02', Width: 150, Align: 'Left', Edit: 0});
	ibHeader.addHeader({Header: '업종명', Type: 'Text', SaveName: 'detailnm', Width: 330, Align: 'Left', Edit: 0});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	$(document).ready(function(){
		var container = $('#upCodePopupList')[0];
		if (typeof upCodePopupSheet !== 'undefined' && typeof upCodePopupSheet.Index !== 'undefined') {
			upCodePopupSheet.DisposeSheet();
		}
		createIBSheet2(container, 'upCodePopupSheet', '100%', '680px');
		ibHeader.initSheet('upCodePopupSheet');
		upCodePopupSheet.SetSelectionMode(4);

		getUpCodePopupList();
	});

	function showUpCodePopupChgCodeList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradefund/cmn/popup/upCodeChgCodeList.do" />'
			, data : $('#upCodePopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#searchChgCode02').html('');

				var codeList = '';
				codeList += '<option value="">::: 선택 :::</option>';
				$.each(data.upCodeDep2, function(index, value){
					codeList += '<option value="' + value.chgCode02 + '">' + value.chgCode02 + '</option>';
				});

				$('#searchChgCode02').html(codeList);
			}
		});
	}

	function doUpCodePopupSearch() {
		goUpCodePopupPage(1);
	}

	function goUpCodePopupPage(upCodePageIndex) {
		document.upCodePopupForm.upCodePageIndex.value = upCodePageIndex;

		getUpCodePopupList();
	}

	function getUpCodePopupList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradefund/cmn/popup/upCodeList.do" />'
			, data : $('#upCodePopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#upCodePopupTotalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				setPaging(
					'upCodePopupPaging'
					, goUpCodePopupPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				upCodePopupSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function upCodePopupSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('upCodePopupSheet_OnSearchEnd : ', msg);
		} else {
			// 업종코드 링크에 볼드 처리
			upCodePopupSheet.SetColFontBold('detailcd', 1);
		}
	}

	function upCodePopupSheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(Row > 0) {
			var rowData = upCodePopupSheet.GetRowData(Row);

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