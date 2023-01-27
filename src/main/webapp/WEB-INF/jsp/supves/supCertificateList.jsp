<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<form name="viewForm" id="viewForm" method="post" onsubmit="return false;">
	<input type="hidden" name="event"		id="event"		value=""/>
	<input type="hidden" name="listPage"	id="listPage"	value="<c:out value="/supves/supCertificateList.do"/>"/>
	<input type="hidden" name="pageIndex"	id="pageIndex"	value="<c:out value='${svcexVO.pageIndex}' default='1' />" />
	<input type="hidden" name="bsNo"		id="bsNo"		value=""/>
	<input type="hidden" name="stateCd"		id="stateCd"	value=""/>
	<input type="hidden" name="reqno"		id="reqno"		value=""/>
	<input type="hidden" name="manCreYn"	id="manCreYn"	value=""/>
	<input type="hidden" name="reqstUuid"	id="reqstUuid"	value=""/>
	<input type="hidden" name="resultCnt"	id="resultCnt"	value="<c:out value='${resultCnt}' default='0' />" />

	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_secondary" onclick="javascript:fn_Reset();">초기화</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
		</div>
	</div>

	<div class="cont_block">
		<table class="formTable">
			<colgroup>
				<col style="width:15%;">
				<col />
				<col style="width:15%;">
				<col />
				<col style="width:15%;">
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>회사명</th>
					<td>
						<input type="text" name="searchCompanyKor" id="searchCompanyKor" class="form_text w100p" maxlength="150" value="<c:out value="${svcexVO.searchCompanyKor }"/>" desc="회사명" onKeyPress="check_Enter()">
					</td>
					<th>사업자등록번호</th>
					<td>
						<input type="text" name="searchEnterRegNo" id="searchEnterRegNo" class="form_text w100p" maxlength="10" value="<c:out value="${svcexVO.searchEnterRegNo }"/>" desc="사업자등록번호" onKeyPress="check_Enter()">
					</td>
					<th>무역업고유번호</th>
					<td>
						<input type="text" name="searchBsNo" id="searchBsNo" class="form_text w100p" maxlength="8" value="<c:out value="${svcexVO.searchBsNo }"/>" desc="무역업고유번호" onKeyPress="check_Enter()">
					</td>
				</tr>
				<tr>
					<th>기간검색구분</th>
					<td class="pick_area" colspan="3">
						<div class="flex align_center">
							<select name="searchDateGubun" id="searchDateGubun" class="form_select wAuto">
								<option value="req">신청기간</option>
								<option value="cre">작성일</option>
							</select>
							<div class="group_datepicker ml-8">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" class="txt datepicker" name="startDt" id="startDt" readonly size="10" maxlength="50" value="<c:out value="${svcexVO.startDt }"/>">
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									</span>

									<!-- clear 버튼 -->
									<button type="button" class="dateClear" onclick="clearPickerValue('startDt');" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
								</div>

								<div class="spacing">~</div>

								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text"  class="txt datepicker" name="endDt" id="endDt" readonly size="10" maxlength="50" value="<c:out value="${svcexVO.endDt }"/>">
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									</span>

									<!-- clear 버튼 -->
									<button type="button" class="dateClear" onclick="clearPickerValue('endDt');" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
								</div>
							</div>
						</div>
					</td>
					<th>진행상태</th>
					<td>
						<select name="searchStateCd" id="searchStateCdId" class="form_select w100p">
							<c:forEach var="list" items="${com006}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${svcexVO.searchStateCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>발급기간</th>
					<td colspan="3">
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" class="txt datepicker" name="issueStartDt" id="issueStartDt" readonly size="10" maxlength="50" isrequired="true" value="<c:out value="${svcexVO.issueStartDt }"/>">
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('issueStartDt');" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" class="txt datepicker" name="issueEndDt" id="issueEndDt" readonly size="10" maxlength="50" isrequired="true" value="<c:out value="${svcexVO.issueEndDt }"/>">
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('issueEndDt');" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
					</td>
					<th>발급구분</th>
					<td>
						<select name="searchIssueCd" id="searchIssueCdId" class="form_select w100p">
							<c:forEach var="list" items="${com007}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${svcexVO.searchIssueCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tbl_opt">
			<!-- 전체 게시글 -->
			<div id="totalCnt" class="total_count"></div>

			<fieldset class="ml-auto">
				<button type="button" class="btn_sm btn_primary" onclick="doDownloadExcel();">엑셀 다운</button>
				<select id="pageUnit" name="pageUnit" onchange="doSearch();" title="목록수" class="form_select">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${svcexVO.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>
			</fieldset>
		</div>
		<!-- 리스트 테이블 -->
		<div style="width: 100%;height: 100%;">
			<div id="selectList" class="sheet"></div>
		</div>
		<!-- .paging-->
		<div id="paging" class="paging ibs"></div>
		<!-- //.paging-->

	</div>

</form>

<script type="text/javascript">
	var f;

	$(document).ready(function(){
		f = document.viewForm;
		// 시작일 선택 이벤트
		datepickerById('startDt', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('endDt', toDateSelectEvent);
		// 시작일 선택 이벤트
		datepickerById('issueStartDt', fromDateSelectEvent2);
		// 종료일 선택 이벤트
		datepickerById('issueEndDt', toDateSelectEvent2);
		selectList();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#startDt').val());
		if ($('#endDt').val() != '') {
			if (startymd > Date.parse($('#endDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#startDt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#endDt').val());

		if ($('#startDt').val() != '') {
			if (endymd < Date.parse($('#startDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#endDt').val('');

				return;
			}
		}
	}

	function fromDateSelectEvent2() {
		var startymd = Date.parse($('#issueStartDt').val());
		if ($('#issueEndDt').val() != '') {
			if (startymd > Date.parse($('#issueEndDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#issueStartDt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent2() {
		var endymd = Date.parse($('#issueEndDt').val());

		if ($('#issueStartDt').val() != '') {
			if (endymd < Date.parse($('#issueStartDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#issueEndDt').val('');

				return;
			}
		}
	}

	function doSearch() {
		if(f.startDt.value != "" && f.endDt.value != ""){
			if(f.startDt.value > f.endDt.value){
				if( $("#searchDateGubun option:selected").val() == "req" ){
					alert("신청기간 날짜를 확인 하십시요.");
				}else if( $("#searchDateGubun option:selected").val() == "cre" ) {
					alert("작성일 날짜를 확인 하십시요.");
				}
				return;
			}
		}
		if(f.issueStartDt.value != "" && f.issueEndDt.value != ""){
			if(f.issueStartDt.value > f.issueEndDt.value){
				alert("발급기간 날짜를 확인 하십시요.");
				return;
			}
		}
		if(f.issueStartDt.value != "" && f.issueEndDt.value != ""){
			if(f.issueStartDt.value > f.issueEndDt.value){
				alert("발급기간 날짜를 확인 하십시요.");
				return;
			}
		}
		goPage(1);
	}

	function check_Enter() {
		if (event.keyCode==13) { doSearch(); }
	}

	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		selectList();
	}

	function selectList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/supves/supCertificateListData.do" />'
			, data : $('#viewForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');
				$('#resultCnt').val(data.resultCnt);

				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				setGrid(data);
			}
		});
	}

	function setGrid(data){

		if (typeof selectListSheet !== "undefined" && typeof selectListSheet.Index !== "undefined") {
			selectListSheet.DisposeSheet();
		}

		var	ibHeader = new IBHeader();
		var svcexVO = data.svcexVO;

		ibHeader.addHeader({Header: 'stateCd',		SaveName: 'stateCd',		Type: 'Text', Width: 6,		Align: 'Center', ColMerge: 0, Hidden: true});
		ibHeader.addHeader({Header: 'reqno',		SaveName: 'reqno',			Type: 'Text', Width: 6,		Align: 'Center', ColMerge: 0, Hidden: true});
		ibHeader.addHeader({Header: 'manCreYn',		SaveName: 'manCreYn',		Type: 'Text', Width: 6,		Align: 'Center', ColMerge: 0, Hidden: true});
		ibHeader.addHeader({Header: 'uuid',			SaveName: 'reqstUuid',		Type: 'Text', Width: 6,		Align: 'Center', ColMerge: 0, Hidden: true});
		ibHeader.addHeader({Header: 'No',			SaveName: 'rn',				Type: 'Text', Width: 6,		Align: 'Center', ColMerge: 0, Hidden: false});
		ibHeader.addHeader({Header: '회사명',			SaveName: 'companyNm',		Type: 'Text', Width: 29,	Align: 'Left', ColMerge: 0, Hidden: false, Cursor:"Pointer"});
		ibHeader.addHeader({Header: '신청일',			SaveName: 'reqDate',		Type: 'Text', Width: 4,		Align: 'Center', ColMerge: 0, Hidden: false});
		ibHeader.addHeader({Header: '발급일',			SaveName: 'issueDate',		Type: 'Text', Width: 4,		Align: 'Center', ColMerge: 0, Hidden: false});
		ibHeader.addHeader({Header: '발급구분',		SaveName: 'issueCd',		Type: 'Text', Width: 4,		Align: 'Center', ColMerge: 0, Hidden: false});
		ibHeader.addHeader({Header: '무역업고유번호',	SaveName: 'bsNo',			Type: 'Text', Width: 6,	Align: 'Center', ColMerge: 0, Hidden: false});
		ibHeader.addHeader({Header: '기존실적 포함여부',	SaveName: 'oriDataYnText',	Type: 'Text', Width: 6.5,	Align: 'Center', ColMerge: 0, Hidden: false});
		ibHeader.addHeader({Header: '진행상태',		SaveName: 'stateNm',		Type: 'Text', Width: 4,		Align: 'Center', ColMerge: 0, Hidden: false});

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode : 0});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#selectList')[0];
		createIBSheet2(container, 'selectListSheet', '100%', '100%');
		ibHeader.initSheet('selectListSheet');
		selectListSheet.SetSelectionMode(4);
		selectListSheet.LoadSearchData({Data: data.resultList}, {Wait: 0});
	}

	function selectListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if( selectListSheet.ColSaveName(col) == "companyNm" ) {
				var url = "/supves/supCertificateApplyDetailView.do";
				var bsNo = selectListSheet.GetCellValue(row, "bsNo");
				var stateCd = selectListSheet.GetCellValue(row, "stateCd");
				var reqno = selectListSheet.GetCellValue(row, "reqno");
				var manCreYn = selectListSheet.GetCellValue(row, "manCreYn");
				var reqstUuid = selectListSheet.GetCellValue(row, "reqstUuid");

				if( stateCd == 'B' ) {
					if( !confirm("심사중으로 상태변경 하시겠습니까?") ) { return; }
				}

				f.event.value = "SIMSA";
				f.bsNo.value = bsNo;
				f.stateCd.value = stateCd;
				f.reqno.value = reqno;
				f.reqstUuid.value = reqstUuid;
				f.action = url;
				f.target = '_self';
				f.submit();
			}

		}
	}
	function selectListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
		}else{
			// 볼드 처리
			selectListSheet.SetColFontBold('companyNm', 1);
		}
	}
	function selectListSheet_OnRowSearchEnd(row) {
		if ( row > 0) {
			var index = selectListSheet.GetCellValue(row, "rn");
			var resultCnt = $('#resultCnt').val();
			selectListSheet.SetCellValue(row, "rn", parseInt(resultCnt - index)+1 );
		}
	};

	function fn_Reset() {
		f.searchCompanyKor.value = "";
		f.searchEnterRegNo.value = "";
		f.searchBsNo.value = "";
		f.issueStartDt.value = "";
		f.issueEndDt.value = "";
		setSelect(f.searchIssueCd,'');
		setSelect(f.searchStateCd,'');
		f.searchCompanyKor.focus();

		f.startDt.value = "";
		f.endDt.value = "";
	}
	// 엑셀다운로드
	function doDownloadExcel() {
		var f = document.viewForm;
		f.action = '<c:url value="/supves/supCertificateListDataExcelList.do" />';
		f.method = 'post';
		f.target = '_self';
		f.submit();
		f.method = 'get';
	}

</script>
