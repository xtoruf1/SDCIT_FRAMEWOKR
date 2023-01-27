<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doAdd();">신규</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_primary" onclick="doExcelDownload();">엑셀 다운</button>
		<button type="button" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>


<form id="searchForm" name="searchForm" method="post">
	<div class="cont_block">
		<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
		<input type="hidden" id="traderId" name="traderId"/>
		<input type="hidden" id="nowSelectCount" name="nowSelectCount" value=""/>
		<table class="formTable">
			<colgroup>
				<col style="width:17%" />
				<col style="width:25%" />
				<col style="width:17%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>회차</th>
					<td>
						<input type="text" class="form_text" id="searchAwardRound" name="searchAwardRound" onkeydown="onEnter(doSearch);" oninput="this.value = this.value.replace(/[^0-9]/g, '');" maxlength="5">
					</td>
					<th scope="row">선정일</th>
					<td>
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="searchSelectStartDt" id="searchSelectStartDt" value="${param.searchSelectStartDt}" class="txt datepicker" title="조회시작일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('searchSelectStartDt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="searchSelectEndDt" id="searchSelectEndDt" value="${param.searchSelectEndDt}" class="txt datepicker" title="조회종료일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('searchSelectEndDt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
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

		setSheetHeader_hanbitList();
		getHanbitList();

	});

	function setSheetHeader_hanbitList() {	// 사업 리스트 헤더

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '무역인상ID'		, Type: 'Text'			, SaveName: 'traderId'			, Hidden: true});
		ibHeader.addHeader({Header: '회차'			, Type: 'Text'			, SaveName: 'awardRound'		, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '사업명'			, Type: 'Text'			, SaveName: 'awardTitle'		, Edit: false	, Width: 60		, Align: 'Left'	, Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '선정업체'			, Type: 'Text'			, SaveName: 'selectCount'		, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '신청기한'			, Type: 'Text'			, SaveName: 'regDate'			, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '선정일'			, Type: 'Text'			, SaveName: 'selectionDate'		, Edit: false	, Width: 30		, Align: 'Center'});
		ibHeader.addHeader({Header: '수출실적기준'		, Type: 'Text'			, SaveName: 'exptBaseMonth'		, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '신청업체'			, Type: 'Text'			, SaveName: 'regCnt'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '발송여부'			, Type: 'Html'			, SaveName: 'sendYn'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '현재선정인원'		, Type: 'Text'			, SaveName: 'nowSelectCount'	, Hidden: true});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            ToolTip: false});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#hanbitListSheet')[0];
		createIBSheet2(container, 'hanbitListSheet', '100%', '100%');
		ibHeader.initSheet('hanbitListSheet');

		hanbitListSheet.SetEllipsis(1); // 말줄임 표시여부
		hanbitListSheet.SetSelectionMode(4);

		// 시작일 선택 이벤트
		datepickerById('searchSelectStartDt', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('searchSelectEndDt', toDateSelectEvent);
	}

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchSelectStartDt').val());

		if ($('#searchSelectEndDt').val() != '') {
			if (startymd > Date.parse($('#searchSelectEndDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchSelectStartDt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchSelectEndDt').val());

		if ($('#searchSelectStartDt').val() != '') {
			if (endymd < Date.parse($('#searchSelectStartDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchSelectEndDt').val('');

				return;
			}
		}
	}

	function hanbitListSheet_OnRowSearchEnd(row) {
		hanbitListSheet.SetColFontBold('awardTitle', 1);

		var sendYn = hanbitListSheet.GetCellValue(row, 'sendYn');
		var traderId = hanbitListSheet.GetCellValue(row, 'traderId');

		if(sendYn == 'N') {
			hanbitListSheet.SetCellValue(row, 'sendYn', '<button type="button" class="btn_sm btn_primary" onclick="doSend('+traderId+');">발송</button>');
		} else {
			hanbitListSheet.SetCellValue(row, 'sendYn', '발송완료');
		}
	}

	function hanbitListSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {

		if(rowType == 'HeaderRow'){
			return;
		}

		var traderId = hanbitListSheet.GetCellValue(Row, 'traderId');
		var nowSelectCount = hanbitListSheet.GetCellValue(Row, 'nowSelectCount');

		if(hanbitListSheet.ColSaveName(Col) == 'awardTitle') {
			$('#traderId').val(traderId);
			$('#nowSelectCount').val(nowSelectCount);
			goDetail();
		}

	}

	function doSearch() {
		$('#pageIndex').val(1);
		getHanbitList();
	}

	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getHanbitList();
	}

	function chgPageCnt() {
		doSearch();
	}

	function getHanbitList() {	// 회사 조회

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitMng/selectHanbitMngList.do"
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

				hanbitListSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function goDetail() {	// 상세
		$('#searchForm').attr('action', '/hanbit/hanbitMng/hanbitMngDetail.do');
		$('#searchForm').submit();
	}

	function doAdd() {	// 신규
		$('#searchForm').attr('action', '/hanbit/hanbitMng/hanbitMngRegst.do');
		$('#searchForm').submit();
	}

	function doExcelDownload() {	// 엑셀다운로드
		$('#searchForm').attr('action','/hanbit/hanbitMng/hanbitListExcelDown.do');
		$('#searchForm').submit();
	}

	function doClear() {	// 초기화
		location.reload();
	}

	function doSend(traderId) {	// 결과발송

		var idx = hanbitListSheet.FindText(0,traderId+'');
		var selectionDate = hanbitListSheet.GetCellValue(idx, 'selectionDate');
		var nowSelectCount = hanbitListSheet.GetCellValue(idx, 'nowSelectCount');
		var selectCount = hanbitListSheet.GetCellValue(idx, 'selectCount');

		var today = new Date();

		var year = today.getFullYear();
		var month = ('0' + (today.getMonth() + 1)).slice(-2);
		var day = ('0' + today.getDate()).slice(-2);

		var dateString = year + '-' + month  + '-' + day;

		if(selectionDate > dateString) {
			alert('선정일이 아직 지나지않았습니다.');
			return;
		}

		if(selectCount != nowSelectCount) {
			alert('선정된 업체수와 설정한 선정수가 맞지 않습니다.\n설정한 선정업체수 ['+selectCount+']\n선정된 업체수 ['+nowSelectCount+']');
			return;
		}

		if(!confirm('발송하시겠습니까?')) {
			return;
		}

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitMng/hanbitResultSend.do"
			, data : {'traderId' : traderId}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				location.reload();
			}
		});
	}
</script>
