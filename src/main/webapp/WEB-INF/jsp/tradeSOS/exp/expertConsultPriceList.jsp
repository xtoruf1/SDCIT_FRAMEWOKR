<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="priceForm" name="priceForm" method="get" onsubmit="return false;">
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doRowAdd();" class="btn_sm btn_primary btn_modify_auth">추가</button>
		<button type="button" onclick="doSavePrice();" class="btn_sm btn_primary btn_modify_auth">저장</button>
		<button type="button" onclick="doRowDelete();" class="btn_sm btn_secondary btn_modify_auth">삭제</button>
	</div>
	<div class="ml-15">
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
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">연도</th>
				<td>
					<select id="searchBaseYear" name="searchBaseYear" class="form_select" title="연도">
						<option value="">전체</option>
						<c:forEach var="item" items="${expertConsultPriceBaseYearList}" varStatus="status">
							<option value="${item}">${item}</option>
						</c:forEach>
					</select>
				</td>
           		<th scope="row">월</th>
				<td>
					<select id="searchBaseQuarter" name="searchBaseQuarter" class="form_select" title="월">
						<option value="">전체</option>
						<option value="01">1월</option>
						<option value="02">2월</option>
						<option value="03">3월</option>
						<option value="04">4월</option>
						<option value="05">5월</option>
						<option value="06">6월</option>
						<option value="07">7월</option>
						<option value="08">8월</option>
						<option value="09">9월</option>
						<option value="10">10월</option>
						<option value="11">11월</option>
						<option value="12">12월</option>
					</select>
				</td>
				<th scope="row">상담분야</th>
				<td>
					<select id="searchConsultTypeCd" name="searchConsultTypeCd" class="form_select" title="상담분야">
						<option value="">전체</option>
						<c:forEach var="list" items="${consultTypeList}" varStatus="status">
							<option value="${list.consultTypeCd}">${list.consultTypeNm}</option>
						</c:forEach>
					</select>
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
		<div id="priceList" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '연도', Type: 'Int', SaveName: 'baseYear', Width: 40, Align: 'Center', Format: '####', Edit: false});
	ibHeader.addHeader({Header: '월', Type: 'Text', SaveName: 'baseQuarter', Width: 40, Align: 'Center', Edit: false});
	ibHeader.addHeader({Header: '상담분야', Type: 'Combo', SaveName: 'consultTypeCd', Width: 80, Align: 'Center', ComboCode: '${consultTypeCd}', ComboText: '${consultTypeNm}', Edit: false});
	ibHeader.addHeader({Header: '금액', Type: 'Int', SaveName: 'consultPrice', Width: 500, Align: 'Right', Edit: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 1, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: -1, MergeSheet: 5, ChildPage: 10, MaxSort: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	$(document).ready(function(){
		var container1 = $('#priceList')[0];
		createIBSheet2(container1, 'priceListSheet', '100%', '100%');
		ibHeader.initSheet('priceListSheet');

		getList();
	});

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.priceForm.pageIndex.value = pageIndex;
		getList();
	}

	function getList() {
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectExpertConsultPriceList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				searchBaseYear : $('#searchBaseYear').val()
				, searchBaseQuarter : $('#searchBaseQuarter').val()
				, searchConsultTypeCd : $('#searchConsultTypeCd').val()
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

				priceListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function priceListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('priceListSheet', row);
	}

	function priceListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('priceListSheet_OnSearchEnd : ', msg);
		}
	}

	function doRowAdd() {
		var index = priceListSheet.DataInsert(-1);
		// 편집을 할수 있도록 변경
		priceListSheet.SetCellEditable(index, 'baseYear', 1);
		priceListSheet.SetCellEditable(index, 'baseQuarter', 1);
		priceListSheet.SetCellEditable(index, 'consultTypeCd', 1);
		// 편집시 컬럼 색깔 변경
		priceListSheet.SetCellBackColor(index, 'baseYear', '#ffffff');
		priceListSheet.SetCellBackColor(index, 'baseQuarter', '#ffffff');
		priceListSheet.SetCellBackColor(index, 'consultTypeCd', '#ffffff');
	}

	function doRowDelete() {
		var rowIndex = priceListSheet.GetSelectRow();
		priceListSheet.SetCellValue(rowIndex, 'status', 'D');
		priceListSheet.SetCellFont("FontStrike", rowIndex, 1, rowIndex, priceListSheet.LastCol(), true);
	}

	function priceListSheet_OnValidation(Row, Col, Value) {
		switch (priceListSheet.ColSaveName(Col)) {
			case 'baseYear' :
				if (Value == '') {
					alert('연도는 필수항목입니다.');

					priceListSheet.ValidateFail(1);
					priceListSheet.SelectCell(Row, Col);
				} else if (Value.length > 4) {
					alert('4글자로 입력해주세요.');

					priceListSheet.ValidateFail(1);
					priceListSheet.SelectCell(Row, Col);
				}

				break;
			case 'consultPrice' :
				if (Value == '') {
					alert('금액은 필수항목입니다.');

					priceListSheet.ValidateFail(1);
					priceListSheet.SelectCell(Row, Col);
				}

				break;
		}
	}

	function doSavePrice() {
		var result = priceListSheet.GetSaveJson();
		var priceList = result['data'];

		// validate 실패 시 목록이 0 으로 처리됨
		if (priceList.length < 1) {
			alert('변경 사항이 없습니다.');

			return false;
		}

		if (confirm('저장 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/registerExpertConsultPrice.do" />'
				, dataType : 'json'
				, contentType : 'application/json'
				, type : 'POST'
				, data : JSON.stringify({
					priceList : priceList
				})
				, async : true
				, spinner : true
				, success : function(data){
					getList();
				}
			});
		}
	}
</script>