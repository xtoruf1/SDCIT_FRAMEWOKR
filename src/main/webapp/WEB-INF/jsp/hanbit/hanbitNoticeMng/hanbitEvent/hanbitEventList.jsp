<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="searchForm" name="searchForm" method="post">
	<input type="hidden" id="noticeId" name="noticeId" value="" />
	<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="goWrite()">신규</button>
		</div>

		<div class="ml-15">
			<button type="button" class="btn_sm btn_primary" onclick="doSearch()" >검색</button>
			<button type="button" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		</div>
	</div>
	<!--검색 시작 -->
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width: 10%;" />
				<col />
				<col style="width: 10%;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>구분</th>
					<td>
						<select name="searchGubun" id="searchGubun" class="form_select">
							<option value="" label="전체"/>
							<c:forEach items="${gubunList}" var="resultInfo" varStatus="status">
								<option value="<c:out value="${ resultInfo.code}" />" label="<c:out value="${ resultInfo.codeNm}" />" <c:out value="${ params.searchGubun eq resultInfo.code ? 'selected' : '' }" /> />
							</c:forEach>
						</select>
					</td>
					<th>작성일</th>
					<td>
						<div class="group_datepicker">
						<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="searchStdt" id="searchStdt" value="${param.searchStdt}" class="txt datepicker" title="조회시작일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('searchStdt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="searchEddt" id="searchEddt" value="${param.searchEddt}" class="txt datepicker" title="조회종료일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('searchEddt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
					</td>
	            </tr>
	            <tr>
	            	<th>제목</th>
					<td colspan="3">
						<input type="text" id="searchTitle" name="searchTitle" value="${param.searchTitle}" onkeydown="onEnter(doSearch);" class="form_text w100p" title="검색어" />
					</td>
	            </tr>
			</tbody>
		</table>
	</div>
	<!--검색 끝 -->
	<div class="cont_block mt-20">
		<div class="tbl_opt">
			<div id="totalCnt" class="total_count"></div>

			<select id="pageUnit" name="pageUnit" title="목록수" class="form_select ml-auto" onchange="chgPageCnt();">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${searchParam.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</div>
		<div>
			<div id="eventListSheet" class="sheet"></div>
		</div>
		<div id="paging" class="paging ibs"></div>
	</div>

</form>

<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_eventList();				// 행사 목록 헤더
		getNoticeList();							// 행사 목록 조회

	});

	function setSheetHeader_eventList() {	// 행사 목록 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '게시판ID'		, Type: 'Text'			, SaveName: 'noticeId'		, Hidden: true});
		ibHeader.addHeader({Header: '순번'			, Type: 'Text'			, SaveName: 'no'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '구분'			, Type: 'Text'			, SaveName: 'noticeGubun'	, Edit: false	, Width: 20		, Align: 'Left'});
		ibHeader.addHeader({Header: '제목'			, Type: 'Text'			, SaveName: 'noticeTitle'	, Edit: false	, Width: 40		, Align: 'Left'	, Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '작성일'			, Type: 'Text'			, SaveName: 'regDate'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '조회수'			, Type: 'Text'			, SaveName: 'views'			, Edit: false	, Width: 20		, Align: 'Center'});

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

		var container = $('#eventListSheet')[0];
		createIBSheet2(container, 'eventListSheet', '100%', '10%');
		ibHeader.initSheet('eventListSheet');

		eventListSheet.SetEllipsis(1); 				// 말줄임 표시여부
		eventListSheet.SetSelectionMode(4);

		// 시작일 선택 이벤트
		datepickerById('searchStdt', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('searchEddt', toDateSelectEvent);
	}

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchStdt').val());

		if ($('#searchEddt').val() != '') {
			if (startymd > Date.parse($('#searchEddt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchStdt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchEddt').val());

		if ($('#searchStdt').val() != '') {
			if (endymd < Date.parse($('#searchStdt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchEddt').val('');

				return;
			}
		}
	}

	function doSearch() {
		$('#pageIndex').val(1);
		getNoticeList();
	}

	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getNoticeList();
	}

	function chgPageCnt() {
		doSearch();
	}

	function eventListSheet_OnRowSearchEnd(row) {
		eventListSheet.SetColFontBold('noticeTitle', 1);
	}

	function getNoticeList() {	// 시상식 목록 조회

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitNoticeMng/selectHanbitEventList.do"
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

				eventListSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function eventListSheet_OnSearchEnd(row) {

		eventListSheet.SetColFontBold('noticeTitle', 1);

	}

	function eventListSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {

		if(rowType == 'HeaderRow') {
			return;
		}

		var noticeId = eventListSheet.GetCellValue(Row, 'noticeId');

		if(eventListSheet.ColSaveName(Col) == 'noticeTitle') {	// 상세

			$('#noticeId').val(noticeId);
			$('#searchForm').attr('action', '/hanbit/hanbitNoticeMng/hanbitEventDetail.do');
			$('#searchForm').submit();
		}
	}

	function goWrite() {

		$('#searchForm').attr('action', '/hanbit/hanbitNoticeMng/hanbitEventNewReg.do');
		$('#searchForm').submit();
	}

	function doClear() {
		location.reload();
	}

</script>