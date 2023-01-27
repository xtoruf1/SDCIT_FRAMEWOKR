<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_primary" onclick="doExcelDownload();">엑셀 다운</button>
		<button type="button" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<form id="searchForm" method="post">
<div class="cont_block">
	<div class="search">
		<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
		<input type="hidden" id="winnerId" name="winnerId" value=""/>
		<table class="formTable">
			<colgroup>
				<col style="width:10%">
				<col style="width:23%">
				<col style="width:10%">
				<col style="width:25%">
			</colgroup>
			<tbody>
				<tr>
					<th>회차</th>
					<td>
						<input type="text" class="form_text w30p" id="searchAwardRound" name="searchAwardRound" value="<c:out value="${ param.searchAwardRound }" />" onkeydown="onEnter(doSearch);" oninput="this.value = this.value.replace(/[^0-9]/g, '');" maxlength="5"/>
					</td>
					<th>성공사례</th>
					<td>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchSuccessLink" value="" <c:if test="${empty param.searchSuccessLink}">checked</c:if>>
							<span class="label">전체</span>
						</label>

						<label class="label_form">
							<input type="radio" class="form_radio" name="searchSuccessLink" value="Y" <c:if test="${ param.searchSuccessLink eq 'Y' }">checked</c:if>>
							<span class="label">등록</span>
						</label>

						<label class="label_form">
							<input type="radio" class="form_radio" name="searchSuccessLink" value="N" <c:if test="${ param.searchSuccessLink eq 'N' }">checked</c:if>>
							<span class="label">미등록</span>
						</label>
					</td>
				</tr>
				<tr>
					<th>업체명</th>
					<td class="bRight">
						<input type="text" class="form_text w100p" name="searchCompanyName" id="searchCompanyName"  value="<c:out value="${ param.searchCompanyName }" />" onkeydown="onEnter(doSearch);"/>
					</td>
					<th>대표자</th>
					<td>
						<input type="text" class="form_text w100p" name="searchCeoName" id="searchCeoName" value="<c:out value="${ param.searchCeoName }" />"  onkeydown="onEnter(doSearch);"/>
					</td>

				</tr>
			</tbody>
		</table>
	</div>
</div>


<div class="cont_block">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>

		<select id="pageUnit" name="pageUnit" title="목록수" class="form_select ml-auto" onchange="chgPageCnt();">
			<c:forEach var="item" items="${pageUnitList}" varStatus="status">
				<option value="${item.code}" <c:if test="${searchParam.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
			</c:forEach>
		</select>
	</div>
	<div>
		<div id="selectedCompanyListSheet" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_selectedCompanyList();				// 사업 리스트 헤더
		getSelectedCompanyList();							// 사업 리스트 조회

	});

	function setSheetHeader_selectedCompanyList() {	// 사업 리스트 헤더

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: 'No'				, Type: 'Text'			, SaveName: 'no'				, Edit: false	, Width: 15		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '회차'				, Type: 'Text'			, SaveName: 'awardRound'		, Edit: false	, Width: 15		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '업체명'				, Type: 'Text'			, SaveName: 'companyName'		, Edit: false	, Width: 40		, Align: 'Left'		, BackColor: '#f6f6f6' , Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '대표자'				, Type: 'Text'			, SaveName: 'nameKor'			, Edit: false	, Width: 15		, Align: 'Center'	, BackColor: '#f6f6f6'});
		ibHeader.addHeader({Header: '성공사례 Link'		, Type: 'Text'			, SaveName: 'successLink'		, Edit: true	, Width: 60		, Align: 'Left'});
		ibHeader.addHeader({Header: '수상자ID'			, Type: 'Text'			, SaveName: 'winnerId'			, Hidden: true});
		ibHeader.addHeader({Header: '상태'				, Type: 'Status'		, SaveName: 'status'			, Hidden: true});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#selectedCompanyListSheet')[0];
		createIBSheet2(container, 'selectedCompanyListSheet', '100%', '100%');
		ibHeader.initSheet('selectedCompanyListSheet');

		selectedCompanyListSheet.SetEllipsis(1); // 말줄임 표시여부
		selectedCompanyListSheet.SetSelectionMode(4);
	}

	function selectedCompanyListSheet_OnRowSearchEnd(row) {
		selectedCompanyListSheet.SetColFontBold('companyName', 1);
	}

	function selectedCompanyListSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {

		if(rowType == 'HeaderRow') {
			return;
		}

		var winnerId = selectedCompanyListSheet.GetCellValue(Row, 'winnerId');

		if(selectedCompanyListSheet.ColSaveName(Col) == 'companyName') {	// 상세

			$('#winnerId').val(winnerId);
			$('#searchForm').attr('action', '/hanbit/hanbitSelectedCompany/hanbitSelectedCompanyDetail.do');
			$('#searchForm').submit();
		}
	}

	function doSearch() {
		$('#pageIndex').val(1);
		getSelectedCompanyList();
	}

	function goPage(pageIndex) {	// 페이징 함수

		var chgRow = selectedCompanyListSheet.RowCount('U');

		if(chgRow < 0) {
			if(confirm('수정된 항목이 존재합니다. 이전에 수정된 정보는 저장되지 않습니다. 이동하시겠습니까?')) {
				$('#pageIndex').val(pageIndex);
				getSelectedCompanyList();
			} else {
				return;
			}
		} else {
			$('#pageIndex').val(pageIndex);
			getSelectedCompanyList();
		}
	}

	function chgPageCnt() {
		doSearch();
	}

	function getSelectedCompanyList() {	// 회사 조회

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitSelectedCompany/selectHanbitSelectedCompanyList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParam)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				setPaging(	// 페이징
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
					);

				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

				selectedCompanyListSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function doExcelDownload() {	// 엑셀다운
		$('#searchForm').attr('action','/hanbit/hanbitSelectedCompany/hanbitSelectedCompanyListExcelDown.do');
		$('#searchForm').submit();
	}

	function doSave() {

		if(!confirm("저장하시겠습니까?")){
			return;
		}

		var saveData = selectedCompanyListSheet.ExportData({
			'Type' : 'json',
			'Cols' : 'successLink|winnerId'
		});

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitSelectedCompany/saveHanbitSuccessLink.do"
			, contentType : 'application/json'
			, data : JSON.stringify(saveData.data)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				alert("정상적으로 처리되었습니다.");
				getSelectedCompanyList();
			}
		});
	}

	function doClear() {	// 초기화
		location.reload();
	}

// 	function openSearchPopup() {

// 		global.openLayerPopup({
// 			popupUrl : '/hanbit/popup/hanbitSearchPop.do'
// 			, callbackFunction : function(resultObj){

// 				$("#searchTraderId").val(resultObj.traderId);			// 한빛회ID
// 				$("#awardTitle").val(resultObj.awardTitle);	// 회차명
// 				$("#sendYn").val(resultObj.sendYn);	// 회차명

// 				getSelectedCompanyList();
// 			}
// 		});
// 	}

</script>