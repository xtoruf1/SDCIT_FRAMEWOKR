<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<form name="frmCountrySearch" id="frmCountrySearch"  method="post" >
<input type="hidden" name="pageIndex"			id="pageIndex"  		value="<c:out value='${param.pageIndex}' 	default='1' />" />
<input type="hidden" name="resultCnt"			id="resultCnt"			value="<c:out value='${resultCnt}' default='0' />" />

	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">국가검색</h2>
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="doCountrySearch()">검색</button>
			<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
		</div>
	</div>

	<div class="popup_body" style="max-width: 800px;">
	<!--검색 시작 -->
	<div class="search w100p">
		<table class="formTable">
			<colgroup>
				<col style="width:18%;">
				<col>
				<col style="width:18%;">
				<col>
			</colgroup>
			<tbody>
			<tr>
				<th>검색구분</th>
				<td colspan="3">
					<div class="group_item">
						<select class="form_select"  name="searchGubun">
							<option value="1">국가명</option>
							<option value="2">국가코드</option>
						</select>
					</div>
					<div class="group_item">
						<input type="text" name="searchCountry" id="searchCountry" value = "<c:out value="${svcexVO.searchCountry }"/>" onkeydown="onEnter(doCountrySearch);" class="form_text" title="검색어" />
					</div>
				</td>
			</tr>
			</tbody>
		</table>
	</div>
	<!--검색 끝 -->
	<div class="tbl_opt mt-20">
		<!-- 전체 게시글 -->
		<div id="searchCountryPopupSheetTotalCnt" class="total_count"></div>

		<fieldset class="ml-auto">
			<select id="pageUnit" name="pageUnit" title="목록수" class="form_select" onchange="doCountrySearch();">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</fieldset>
	</div>

	<div class="w100p">
		<div id="searchCountryPopupSheet" class="sheet"></div>
	</div>
	<!-- .paging-->
	<div id="searchCountryPopupSheetPaging" class="paging ibs""></div>
</div>
</form>

<script type="text/javascript">


	$(document).ready(function(){
		initGrid();
		searchCountryPopupPage(1);
	});

	function doCountrySearch() {
		var form = document.frmCountrySearch;
		form.pageIndex.value = 1;
		selectCountryList();
	}

	function selectCountryList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/popup/searchCountryList.do" />'
			, data : $('#frmCountrySearch').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#searchCountryPopupSheetTotalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');
				$('#resultCnt').val(data.resultCnt);
				setPaging(
					'searchCountryPopupSheetPaging'
					, searchCountryPopupPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				searchCountryPopupSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function initGrid(){
		if (typeof searchCountryPopupSheet !== "undefined" && typeof searchCountryPopupSheet.Index !== "undefined") {
			searchCountryPopupSheet.DisposeSheet();
		}

		var	ibCountryHeader = new IBHeader();
		ibCountryHeader.addHeader({Header: 'No', Type: 'Text', SaveName: 'rn', Width: 10, Align: 'Center', Hidden: false});
		ibCountryHeader.addHeader({Header: '국가코드', Type: 'Text', SaveName: 'detailcd', Width: 10, Align: 'Center', Hidden: false});
		ibCountryHeader.addHeader({Header: '한글명', Type: 'Text', SaveName: 'detailnm', Width: 30, Align: 'Center', Cursor:"Pointer"});
		ibCountryHeader.addHeader({Header: '영문명', Type: 'Text', SaveName: 'chgCode01', Width: 30, Align: 'Center'});

		ibCountryHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, editable: false, MergeSheet :5, VScrollMode: 1, NoFocusMode : 0 });
		ibCountryHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#searchCountryPopupSheet')[0];
		createIBSheet2(container, 'searchCountryPopupSheet', "100%", "300px");
		ibCountryHeader.initSheet('searchCountryPopupSheet');
		searchCountryPopupSheet.SetSelectionMode(4);
	}

	//페이징 조회
	function searchCountryPopupPage(pageIndex) {
		var form = document.frmCountrySearch;
		form.pageIndex.value = pageIndex;
		selectCountryList();
	}

	function searchCountryPopupSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if( searchCountryPopupSheet.ColSaveName(col) == "detailnm" ) {
				var detailcdPopup = searchCountryPopupSheet.GetCellValue(row, "detailcd");
				var detailnmPopup = searchCountryPopupSheet.GetCellValue(row, "detailnm");
				var returnObj = [];
				returnObj.push(detailcdPopup);
				returnObj.push(detailnmPopup);
				layerPopupCallback(returnObj);
				closeLayerPopup();
			}
		}
	}

	function searchCountryPopupSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
		}else{
			// 볼드 처리
			searchCountryPopupSheet.SetColFontBold('detailnm', 1);
		}
	}

	function searchCountryPopupSheet_OnRowSearchEnd(row) {
		if ( row > 0) {
			var index = searchCountryPopupSheet.GetCellValue(row, "rn");
			var resultCnt = $('#resultCnt').val();
			searchCountryPopupSheet.SetCellValue(row, "rn", parseInt(resultCnt - index)+1 );
		}

	};

	function onClose() {
		// 레이어 닫기
		closeLayerPopup();
	}


</script>