<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="ml-auto">
		<button type="button" onclick="fn_newAdd();" class="btn_sm btn_primary btn_modify_auth">신규</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="doInit();">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>


<!-- 상담회 관리 리스트 -->
<div class="page_tradesos">

	<form name="searchForm" id="searchForm" action ="" method="get">
		<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
		<input type="hidden" name="devCfrcId" id="devCfrcId" value=""/>
		<input type="hidden" id="totalCount" name="totalCount" value="0" default='0'>
		<div class="search">
			<table class="formTable">
				<colgroup>
					<col style="width:8%">
					<col style="width:25%">
					<col style="width:8%">
					<col>
					<col style="width:8%">
					<col style="width:25%">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">연도</th>
						<td>
						<select id="searchCondition" name="searchCondition" class="form_select">
							<option value="">전체</option>
							<c:forEach var="list" items="${yearList}" varStatus="status">
							<option value="${list.yyyy}" <c:if test="${param.searchYear eq list.yyyy}">selected="selected"</c:if>>${list.yyyy}</option>
							</c:forEach>
						</select>
					</td>
						<th scope="row">상담회명</th>
						<td>
							<input type="text" name="searchKeyword" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value="${searchVO.cfrcName}"/>">
						</td>
						<th scope="row">장소</th>
						<td>
							<input type="text" name="searchKeyword2" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value="${searchVO.cfrcPlace}"/>">
						</td>
					</tr>
					<tr>
						<th scope="row">협력기관</th>
						<td>
							<select name="partner" class="form_select w100p">
								<option value="">전체</option>
							<c:forEach items="${TC001}" var="code">
								<option value="<c:out value="${code.code }"/>"  <c:if test="${searchVO.partner eq code.code}">selected="selected"</c:if> ><c:out value="${code.codeNm }"/></option>
							</c:forEach>
							</select>
						</td>
						<th scope="row">개최일</th>
						<td>
							<div class="group_datepicker">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="cfrcStartDate" name="cfrcStartDate" value="${searchVO.cfrcStartDate}" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyStartDate" value="" />
									</span>
									<!-- clear 버튼 -->
									<button type="button" class="ml-8" onclick="mtiClearDate('cfrcStartDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>

								<div class="spacing">~</div>

								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="cfrcEndDate" name="cfrcEndDate" value="${searchVO.cfrcEndDate}" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyEndDate" value="" />
									</span>
									<!-- clear 버튼 -->
									<button type="button" class="ml-8" onclick="mtiClearDate('cfrcEndDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>
							</div>
						</td>
						<th scope="row">상태</th>
						<td>
							<select id="statusCd" name="statusCd" class="form_select">
								<option value="">전체</option>
								<c:forEach var="list" items="${DEV001}" varStatus="status">
								<option value="${list.code}" <c:if test="${param.code eq list.code}">selected="selected"</c:if>>${list.codeNm}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</tbody>
			</table><!-- // 검색 테이블-->
		</div>

		<div class="cont_block mt-20">
			<div class="tbl_opt">
				<!-- 무역의 날 기념식 관리 -->
				<div id="totalCnt" class="total_count"></div>

				<fieldset class="ml-auto">
					<select id="pageUnit" name="pageUnit" onchange="doSearch();" title="목록수" class="form_select">
						<c:forEach var="item" items="${pageUnitList}" varStatus="status">
							<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
						</c:forEach>
					</select>
				</fieldset>
			</div>
			<!-- 리스트 테이블 -->
			<div style="width: 100%;height: 100%;">
				<div id='tblGridSheet' class="colPosi"></div>
			</div>
			<!-- .paging-->
			<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
			<!-- //.paging-->
		</div>
	</form>
</div> <!-- // .page_tradesos -->

<script type="text/javascript">
	$(document).ready(function () {

		f_Init_tblGridSheet();  //상담회 관리 Sheet

		// 시작일 선택 이벤트
		datepickerById('cfrcStartDate', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('cfrcEndDate', toDateSelectEvent);

		getList(); // 조회

	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#cfrcStartDate').val());

		if ($('#cfrcEndDate').val() != '') {
			if (startymd > Date.parse($('#cfrcEndDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#cfrcStartDate').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#cfrcEndDate').val());

		if ($('#cfrcStartDate').val() != '') {
			if (endymd < Date.parse($('#cfrcStartDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#cfrcEndDate').val('');

				return;
			}
		}
	}

	function f_Init_tblGridSheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "상담회아이디",  SaveName: "devCfrcId",      Align: "Center", Width: 70,Hidden:true});
		ibHeader.addHeader({Type: "Text", Header: "No",          SaveName: "vnum",           Align: "Center", Width: 50});
		ibHeader.addHeader({Type: "Text", Header: "개최일",       SaveName: "cfrcStartDate",  Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "상담회명",      SaveName: "cfrcName",      Align: "Left", Width: 150, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "장소",         SaveName: "cfrcPlace",     Align: "Left", Ellipsis:1, Width: 150, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "협력기관",      SaveName: "partnerNm",     Align: "Left",  Ellipsis:1, Width: 100, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "신청",         SaveName: "aplctCnt",      Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "선정",         SaveName: "cnfCnt",        Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "참석",         SaveName: "attendCnt",     Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "QR발급",       SaveName: "qrYn",          Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "진행상태",      SaveName: "statusNm",      	Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "비고",         SaveName: "dscr",          Align: "Left", Width: 150, Cursor:"Pointer",Hidden:true});

		var sheetId = "tblGridSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);

        // 편집모드 OFF
		tblGridSheet.SetEditable(0);
	};

	/**
	 * ibsheet 조회 후 이벤트
	 * @param row
	 */
	function tblGridSheet_OnRowSearchEnd(row) {
 	  // 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
	   notEditableCellColor('tblGridSheet', row);
	}

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.searchForm.pageIndex.value = pageIndex;
		getList();
	}

	/**
	 * 상담회 관리 조회
	 */
	function getList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/technicalConsulting/conferenceManagementList.do" />'
			, data : $('#searchForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				$("#totalCount").val(data.resultCnt); // 총 갯수 저장
				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				tblGridSheet.LoadSearchData({Data: data.resultList});
			}
		});

	}

	/**
	 * 신규 생성
	 */
	function fn_newAdd() {
		document.searchForm.action = '<c:url value="/technicalConsulting/conferenceManagementAdd.do" />';
		document.searchForm.target = '_self';
		document.searchForm.submit();
	}

	/**
	 * 상세클릭 이벤트
	 * @param Row
	 * @param Col
	 * @param Value
	 */
 	function tblGridSheet_OnClick(Row, Col, Value) {
		if( Row > 0) {
			var devCfrcId = tblGridSheet.GetCellValue(Row, "devCfrcId");
			fn_detail(devCfrcId);
		}

	};

	/**
	 * 상담회관리 상세 이동
	 * @param devCfrcId
	 */
	function fn_detail( devCfrcId) {
		$("#devCfrcId").val( devCfrcId);

		document.searchForm.action = '<c:url value="/technicalConsulting/conferenceManagementDetail.do" />';
		document.searchForm.target = '_self';
		document.searchForm.submit();
	}

	/**
	 * value 초기화 버튼
	 * @param targetId
	 */
	function mtiClearDate( targetId){
		$("#"+targetId).val("");
	}

	function doInit() {
		location.href = '<c:url value="/technicalConsulting/conferenceManagement.do" />';
	}


</script>
