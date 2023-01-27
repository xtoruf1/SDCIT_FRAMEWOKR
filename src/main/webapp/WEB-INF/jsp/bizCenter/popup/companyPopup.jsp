<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<div class="flex">
	<h2 class="popup_title">회원사 검색</h2>
	<div class="ml-auto">
		<button type="button" onclick="doSearch()" class="btn_sm btn_primary bnt_modify_auth">검색</a>
	</div>
	<div class="ml-15">
		<button type="button" onclick="closeLayerPopup()" 	class="btn_sm btn_secondary">닫기</a>
	</div>
</div>

<form id="popupForm1" name="popupForm1" method="post" onsubmit="return false;">
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />

<!--검색 시작 -->
<div class="popup_body">
	<table class="formTable">
		<colgroup>
			<col style="width:20%">
			<col>
			<col style="width:20%">
			<col>
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">회원사명</th>
				<td>
					<span class="form_search w100p">
						<input type="text" id="searchCompany" name="searchCompany" class="form_text w100p" onkeydown="onEnter(doSearch);" value="">
					</span>
				</td>
				<th scope="row">대표자</th>
				<td>
					<span class="form_search w100p">
						<input type="text" id="searchPresident" name="searchPresident" class="form_text w100p" onkeydown="onEnter(doSearch);" value="">
					</span>
				</td>
			</tr>
			<tr>
				<th scope="row">무역업 번호</th>
				<td>
					<span class="form_search w100p">
						<input type="text" id="searchMemberId" name="searchMemberId" class="form_text w100p" onkeydown="onEnter(doSearch);" value="">
					</span>
				</td>
				<th scope="row">사업자 번호</th>
				<td>
					<span class="form_search w100p">
						<input type="text" id="searchEnterRegNo" name="searchEnterRegNo" class="form_text w100p" onkeydown="onEnter(doSearch);" value="">
					</span>
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
					<option value="<c:out value="${item.code}" />" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>> <c:out value="${item.codeNm}" /></option>
				</c:forEach>
			</select>
		</fieldset>
	</div>
	<div style="width: 100%;" >
		<div id="sheet1" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>

</form>

<script type="text/javascript">
// 레이어팝 업업 크기조정
$(".modal-content").css("height", "auto");
$(".modal-content").css("max-width", "60%");
var p = document.popupForm1;

	$(document).ready(function() {
		sheet1_init();
		//getList();
	});

	function sheet1_init() {
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Type: "Text", Header: "회원사명"		, SaveName: "companyKor"	, Align: "Left"		, Width: 150	,Edit : false	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "대표자명"		, SaveName: "presidentKor"	, Align: "Center"	, Width: 80		,Edit : false	, Ellipsis:1});
		ibHeader.addHeader({Type: "Text", Header: "무역업 번호"	, SaveName: "memberId"		, Align: "Center"	, Width: 80		,Edit : false});
		ibHeader.addHeader({Type: "Text", Header: "사업자번호"		, SaveName: "enterRegNo"	, Align: "Center"	, Width: 80		,Edit : false});
		ibHeader.addHeader({Type: "Text", Header: "주소"			, SaveName: "corpAddr"		, Align: "Left"		, Width: 150	,Edit : false});

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck:false});

		if (typeof sheet1 !== "undefined" && typeof sheet1.Index !== "undefined") {
			sheet1.DisposeSheet();
		}

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);
		sheet1.SetSelectionMode(4);
		// 편집모드 OFF
		sheet1.SetEditable(0);
	}

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		p.pageIndex.value = pageIndex;
		getList();
	}

 	function getList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/bizCenter/reservation/companySearchList.do" />'
			, data : $('#popupForm1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.totalCount) + '</span> 건');

				setPaging(
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
					);
					sheet1.LoadSearchData({Data: data.resultList}, {Wait: 0});
			}
		});
	}

	function sheet1_OnSearchEnd(code, msg) {
		if (code != 0) {
		}else{
			// 볼드 처리
			sheet1.SetColFontBold('companyKor', 1);
		}
	}

	// 상세 페이지 & 팝업
	function sheet1_OnClick(Row, Col, Value) {
		if(sheet1.ColSaveName(Col) == "companyKor" && Row > 0) {
			var rowData = sheet1.GetRowData(Row);
			layerPopupCallback(rowData);
			closeLayerPopup();
		}
	}
</script>