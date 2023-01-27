<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
<input type="hidden" id="pInsId" name="pInsId" value="${param.insId}">
<input type="hidden" id="pTradeNo" name="pTradeNo" value="${param.tradeNo}">

<div class="cont_block">
	<div class="tit_bar">
		<h3 class="tit_block">수출단체보험 상태 변경 이력 </h3>
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
		</div>
	</div>

	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>

		<select id="pageUnit" name="pageUnit" title="목록수" class="form_select ml-auto" onchange="chgPageCnt();">
			<c:forEach var="item" items="${pageUnitList}" varStatus="status">
				<option value="${item.code}" <c:if test="${searchParam.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
			</c:forEach>
		</select>
	</div>
	<div>
		<div id="insuranceHistoryListSheet" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>

<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_insuranceHistory();			// 회사정보 헤더
		getInsuranceHistoryList();						// 회사정보 조회

	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function setSheetHeader_insuranceHistory() {	// 회사정보 헤더

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '일시'			, Type: 'Text'			, SaveName: 'changeDate'		, Edit: false	, Width: 10		, Align: 'Center'});
		ibHeader.addHeader({Header: '이력'			, Type: 'Text'			, SaveName: 'changeDscr'		, Edit: false	, Width: 40		, Align: 'Left'});
		ibHeader.addHeader({Header: '변경자'			, Type: 'Text'			, SaveName: 'changeName'		, Edit: false	, Width: 10		, Align: 'Center'});


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

		var container = $('#insuranceHistoryListSheet')[0];
		if (typeof container !== 'undefined' && typeof insuranceHistoryListSheet.Index !== 'undefined') {
			insuranceHistoryListSheet.DisposeSheet();
		}
		createIBSheet2(container, 'insuranceHistoryListSheet', '1000px', '10%');
		ibHeader.initSheet('insuranceHistoryListSheet');

		insuranceHistoryListSheet.SetEllipsis(1); // 말줄임 표시여부
		insuranceHistoryListSheet.SetSelectionMode(4);

	}

	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getInsuranceHistoryList();
	}

	function doSearch() {
		$('#pageIndex').val(1);
		getInsuranceHistoryList();
	}

	function chgPageCnt() {
		doSearch();
	}

	function getInsuranceHistoryList() {

		var test = $('#pInsId').val();

		global.ajax({
			type : 'POST'
			, url : "/insurance/selectInsuranceHistoryList.do"
			, data : {'insId' : $('#pInsId').val(),
					  'tradeNo' : $('#pTradeNo').val(),
					  'pageUnit' : $('#pageUnit').val()
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				setPaging(	// 페이징
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
					);

				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

				insuranceHistoryListSheet.LoadSearchData({data: (data.resultList || []) });
			}
		});
	}

</script>