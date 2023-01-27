<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<form id="popSearchForm" name="popSearchForm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
	<div class="cont_block">
		<div class="flex">
			<h3 class="popup_title">한빛회 회차 선택</h3>
			<div class="ml-auto">
				<button type="button" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
				<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
				<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
			</div>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:17%" />
				<col />
				<col style="width:17%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>연도</th>
					<td>
						<input tpye="text" id="searchYear" name="searchYear" oninput="this.value = this.value.replace(/[^0-9]/g, '');" class="form_text w100p" onkeydown="onEnter(doSearch);" maxlength="4">
					</td>
					<th>회차</th>
					<td>
						<input tpye="text" id="searchAwardRound" name="searchAwardRound" oninput="this.value = this.value.replace(/[^0-9]/g, '');" class="form_text w100p" onkeydown="onEnter(doSearch);" maxlength="5">
					</td>
	            </tr>
	            <tr>
	            	<th>사업명</th>
					<td colspan="3">
						<input tpye="text" id="searchTitle" name="searchTitle" class="form_text w100p" onkeydown="onEnter(doSearch);">
					</td>
	            </tr>
			</tbody>
		</table>
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
			<div id="hanbitListSheet" class="sheet"></div>
		</div>
		<div id="paging" class="paging ibs"></div>
	</div>

</form>


<script type="text/javascript">

	$(document).ready(function(){
		setSheetHeader_traderList();
		getTraderList();
	});

	function setSheetHeader_traderList() {
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '한빛회마스터'	, Type: 'Text'			, SaveName: 'traderId'			, Hidden: true});
		ibHeader.addHeader({Header: '연도'		, Type: 'Text'			, SaveName: 'awardYear'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '회차'		, Type: 'Text'			, SaveName: 'awardRound'		, Edit: false	, Width: 15		, Align: 'Center'});
		ibHeader.addHeader({Header: '사업명'		, Type: 'Text'			, SaveName: 'awardTitle'		, Edit: false	, Width: 50		, Align: 'Left' , Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '선정일'		, Type: 'Text'			, SaveName: 'awardSelectDate'	, Edit: false	, Width: 30		, Align: 'Center'});
		ibHeader.addHeader({Header: '발송여부'		, Type: 'Text'			, SaveName: 'sendYn'			, Hidden: true	, Width: 30		, Align: 'Center'});

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

		var container = $('#hanbitListSheet')[0];
		if (typeof container !== 'undefined' && typeof hanbitListSheet.Index !== 'undefined') {
			hanbitListSheet.DisposeSheet();
		}
		createIBSheet2(container, 'hanbitListSheet', '100%', '10%');
		ibHeader.initSheet('hanbitListSheet');

		hanbitListSheet.SetEllipsis(1); // 말줄임 표시여부
		hanbitListSheet.SetSelectionMode(4);

	}

	function doSearch() {
		$('#pageIndex').val(1);
		getTraderList();
	}

	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getTraderList();
	}

	function hanbitListSheet_OnSearchEnd(row) {
		hanbitListSheet.SetColFontBold('awardTitle', 1);
	}

	function getTraderList() {

		var popSearchForm = $('#popSearchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/selectHanbitSearchPop.do"
			, contentType : 'application/json'
			, data : JSON.stringify(popSearchForm)
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

				hanbitListSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});

	}

	function hanbitListSheet_OnClick(Row, Col, Value, rowType) {

		if(rowType == 'HeaderRow'){
			return;
		}

		var rowData = hanbitListSheet.GetRowData(Row);

		if(hanbitListSheet.ColSaveName(Col) == 'awardTitle'){

			// 콜백
			layerPopupCallback(rowData);

			// 레이어 닫기
			closeLayerPopup();
		}
	}

	function doClear() {

		$('#searchYear').val('');
		$('#searchAwardRound').val('');
		$('#searchTitle').val('');
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>