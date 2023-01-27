<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doInsert();">신규</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<form id="searchForm" method="post">
	<div class="cont_block">
		<div class="search">
		<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
		<input type="hidden" id="scoreMstId" name="scoreMstId" />
		<input type="hidden" id="startBase" name="startBase" />
			<table class="formTable">
				<colgroup>
					<col width="15%" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">심사기준일</th>
						<td>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="searchStartBase" name="searchStartBase" value="${detailParams.searchStartBase}" class="txt datepicker" title="시작일" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" onclick="clearPickerValue('searchStartBase');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
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
					<option value="${item.code}" >${item.codeNm}</option>
				</c:forEach>
			</select>
		</div>
		<div>
			<div id="judgingCrieriaListSheet" class="sheet"></div>
		</div>
		<div id="paging" class="paging ibs"></div>
	</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_judgingCrieriaList();	// 심사기준 목록 헤더
		getJudgingCrieria();					// 심사기준 목록 조회

	});

	function setSheetHeader_judgingCrieriaList() {	// 심사기준 목록 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '심사기준ID'	, Type: 'Text'			, SaveName: 'scoreMstId'	, Hidden: true});
		ibHeader.addHeader({Header: '순번'		, Type: 'Text'			, SaveName: 'no'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '개정일'		, Type: 'Text'			, SaveName: 'startBase'		, Edit: false	, Width: 40		, Align: 'Center' , Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '종료일'		, Type: 'Text'			, SaveName: 'endDate'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '등록자'		, Type: 'Text'			, SaveName: 'creBy'			, Edit: false	, Width: 60		, Align: 'Center'});
		ibHeader.addHeader({Header: '등록일시'		, Type: 'Text'			, SaveName: 'creDate'		, Edit: false	, Width: 60		, Align: 'Center'});

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

		var container = $('#judgingCrieriaListSheet')[0];
		createIBSheet2(container, 'judgingCrieriaListSheet', '100%', '100%');
		ibHeader.initSheet('judgingCrieriaListSheet');

		judgingCrieriaListSheet.SetEllipsis(1); // 말줄임 표시여부
		judgingCrieriaListSheet.SetSelectionMode(4);
	}

	function doSearch() {
		$('#pageIndex').val(1);
		getJudgingCrieria();
	}

	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getJudgingCrieria();
	}

	function chgPageCnt() {
		doSearch();
	}

	function judgingCrieriaListSheet_OnSearchEnd(code, msg) {

		judgingCrieriaListSheet.SetColFontBold('startBase', 1);	// 개정일에 bold처리
	}

	function judgingCrieriaListSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {

		var scoreMstId = judgingCrieriaListSheet.GetCellValue(Row, 'scoreMstId');
		var startBase = judgingCrieriaListSheet.GetCellValue(Row, 'startBase');

		if(rowType == 'HeaderRow'){
			return;
		}

		if(judgingCrieriaListSheet.ColSaveName(Col) == 'startBase'){	// 상세
			$('#startBase').val(startBase);
			$('#scoreMstId').val(scoreMstId);
			goDetail();
		}
	}

	function goDetail() {	// 상세페이지
		$('#searchForm').attr('action', '/hanbit/judgingMng/judgingCriteriaDetail.do');
		$('#searchForm').submit();
	}

	function getJudgingCrieria() {	// 심사기준 목록 조회

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/judgingMng/selectJudgingCriteriaList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParam)
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

				judgingCrieriaListSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function doInsert() {	// 신규등록
		$('#searchForm').attr('action', '/hanbit/judgingMng/judgingCriteriaReg.do');
		$('#searchForm').submit();
	}

	function doClear() {	// 초기화
		location.reload();
	}

</script>