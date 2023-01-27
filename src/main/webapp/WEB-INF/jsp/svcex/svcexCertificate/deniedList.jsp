<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<form name="viewForm" id="viewForm" method="post" onsubmit="return false;">
	<input type="hidden" name="event"				id="event"    		 	value="">
	<input type="hidden" name="statusChk"			id="statusChk"			value="">
	<input type="hidden" name="bsNo"				id="bsNo"				value=""/>
	<input type="hidden" name="transportServiceCd"	id="transportServiceCd"	value=""/>
	<input type="hidden" name="stateCd"				id="stateCd"			value=""/>
	<input type="hidden" name="reqno"				id="reqno"				value=""/>
	<input type="hidden" name="manCreYn"			id="manCreYn"			value=""/>
	<INPUT type="hidden" name="returnNo"			id="returnNo"			value=""/>
	<input type="hidden" name="listPage"			id="listPage"			value="<c:out value="/svcex/svcexCertificate/deniedList.do"/>"/>
	<input type="hidden" name="pageIndex"			id="pageIndex"			value="<c:out value='${svcexVO.pageIndex}' default='1' />" />
	<input type="hidden" name="resultCnt"			id="resultCnt"			value="<c:out value='${resultCnt}' default='0' />" />

	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_secondary" onclick="fn_Reset();">초기화</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
		</div>
	</div>

	<div class="cont_block">
		<table class="formTable">
			<table class="formTable">
			<colgroup>
				<col style="width:15%;">
				<col />
				<col style="width:15%;">
				<col />
				<col style="width:15%;">
				<col />
			</colgroup>
			<tbody id="searchTableBody">
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
					<th>담당본부</th>
					<td>
						<select name="searchOrgCd" id="searchOrgCdId" class="form_select w100p">
							<c:forEach var="list" items="${svc001}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${svcexVO.searchOrgCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>

				</tr>
				<tr>
					<th>반려기간</th>
					<td colspan="3">
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" class="txt datepicker" name="returnStartDt" id="returnStartDt" readonly size="10" maxlength="50" isrequired="true" value="<c:out value="${svcexVO.returnStartDt }"/>">
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('returnStartDt');" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" class="txt datepicker" name="returnEndDt" id="returnEndDt" readonly size="10" maxlength="50" isrequired="true" value="<c:out value="${svcexVO.returnEndDt }"/>">
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('returnEndDt');" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
					</td>
					<th>수출입</th>
					<td>
						<select name="searchExpImpCd" id="searchExpImpCdId" class="form_select w100p">
							<c:forEach var="list" items="${com002}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${svcexVO.searchExpImpCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
			</table><!-- //formTable -->
	</div>


	<div class="cont_block">
		<div class="tbl_opt">
			<!-- 전체 게시글 -->
			<div id="totalCnt" class="total_count"></div>
			<fieldset class="ml-auto">
				<button type="button" class="btn_sm btn_primary" onclick="doDownloadExcel();">엑셀 다운</button>
				<select id="pageUnit" name="pageUnit" onchange="doSearch();" title="목록수" class="form_select ml-8">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${svcexVO.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>
			</fieldset>
		</div>
		<div id="deniedList" class="sheet"></div>
		<div id="paging" class="paging ibs"></div>
	</div>

</form>

<script type="text/javascript">

	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: 'No',			Type: 'Text', SaveName: 'rn',				Width: 6,  Align: 'Center'});
	ibHeader.addHeader({Header: '회사명',			Type: 'Text', SaveName: 'companyKor',			Width: 13, Align: 'Left', Ellipsis: true, Cursor:"Pointer"});
	ibHeader.addHeader({Header: '관리자등록',		Type: 'Text', SaveName: 'manCreYnNm',			Width: 7,  Align: 'Center'});
	ibHeader.addHeader({Header: '지역',			Type: 'Text', SaveName: 'cityNm',				Width: 8,  Align: 'Center', Ellipsis: true});
	ibHeader.addHeader({Header: '신청일',			Type: 'Text', SaveName: 'reqDate',				Width: 8,  Align: 'Center'});
	ibHeader.addHeader({Header: '상품수',			Type: 'Text', SaveName: 'cnt',					Width: 5,  Align: 'Center'});
	ibHeader.addHeader({Header: '무역업고유번호',	Type: 'Text', SaveName: 'bsNo',					Width: 10, Align: 'Center'});
	ibHeader.addHeader({Header: '금액($)',		Type: 'Int',  SaveName: 'checkAmount',			Width: 8,  Align: 'Right'});
	ibHeader.addHeader({Header: '수출입',			Type: 'Text', SaveName: 'expImpNm',				Width: 6,  Align: 'Center'});
	ibHeader.addHeader({Header: '구분',			Type: 'Text', SaveName: 'transportServiceCd',	Width: 8,  Align: 'Center'});
	ibHeader.addHeader({Header: '반려일자',		Type: 'Text', SaveName: 'returnDate',			Width: 8,  Align: 'Center'});
	ibHeader.addHeader({Header: '반려자',			Type: 'Text', SaveName: 'returnByNm',			Width: 6,  Align: 'Center'});
	ibHeader.addHeader({Header: '진행상태',		Type: 'Text', SaveName: 'stateNm',				Width: 6,  Align: 'Center'});
	ibHeader.addHeader({Header: '진행상태코드',		Type: 'Text', SaveName: 'stateCd',				Width: 6,  Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '신청번호',		Type: 'Text', SaveName: 'reqno',				Width: 6,  Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '반려번호',		Type: 'Text', SaveName: 'returnNo',				Width: 6,  Align: 'Center', Hidden: false});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode : 0 });
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f = document.viewForm;

	$(document).ready(function(){
		var container = $('#deniedList')[0];
		createIBSheet2(container, 'deniedListSheet', '100%', '100%');
		ibHeader.initSheet('deniedListSheet');
		deniedListSheet.SetSelectionMode(4);
		$("#searchDateGubun").val("cre").prop("selected", true);
		// 시작일 선택 이벤트
		datepickerById('startDt', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('endDt', toDateSelectEvent);
		// 시작일 선택 이벤트
		datepickerById('returnStartDt', fromDateSelectEvent2);
		// 종료일 선택 이벤트
		datepickerById('returnEndDt', toDateSelectEvent2);
		getIssueCheckList();
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
		var startymd = Date.parse($('#returnStartDt').val());
		if ($('#returnEndDt').val() != '') {
			if (startymd > Date.parse($('#returnEndDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#returnStartDt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent2() {
		var endymd = Date.parse($('#returnEndDt').val());

		if ($('#returnStartDt').val() != '') {
			if (endymd < Date.parse($('#returnStartDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#returnEndDt').val('');

				return;
			}
		}
	}

	function deniedListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {

		}else{
			// 볼드 처리
			deniedListSheet.SetColFontBold('companyKor', 1);
		}

		setCntBlank();
	}

	function deniedListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if( deniedListSheet.ColSaveName(col) == "companyKor" ) {
				var url = "";
				var stateCd = deniedListSheet.GetCellValue(row, "stateCd");
				var transportServiceCd = deniedListSheet.GetCellValue(row, "transportServiceCd");

				if( stateCd == "B" ) { if(!confirm("심사중으로 상태변경 하시겠습니까?"))return; }

				if( transportServiceCd == '운수' ){
			    	url = "/svcex/svcexCertificate/deniedDetail2View.do";
			    }else{
			    	url = "/svcex/svcexCertificate/deniedDetailView.do";
			    }
				var bsNo = deniedListSheet.GetCellValue(row, "bsNo");
				var reqno = deniedListSheet.GetCellValue(row, "reqno");
				var manCreYn = deniedListSheet.GetCellValue(row, "manCreYn");
				var returnNo = deniedListSheet.GetCellValue(row, "returnNo");

				f.bsNo.value = bsNo;
				f.reqno.value = reqno;
				f.stateCd.value = stateCd;
				f.transportServiceCd.value = transportServiceCd;
				f.manCreYn.value = manCreYn;
				f.returnNo.value = returnNo;

				f.action = url;
				f.target = '_self';
				f.submit();
			}
		}
	}

	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		getIssueCheckList();
	}

	function getIssueCheckList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/selectDeniedList.do" />'
			, data : $('#viewForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				$('#resultCnt').val(data.resultCnt);

				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				deniedListSheet.LoadSearchData({Data: data.resultList}, {Wait: 0});
			}
		});
	}

	function deniedListSheet_OnRowSearchEnd(row) {
		if ( row > 0) {
			var index = deniedListSheet.GetCellValue(row, "rn");
			var resultCnt = $('#resultCnt').val();
			deniedListSheet.SetCellValue(row, "rn", parseInt(resultCnt - index)+1 );
		}
	};

	function check_Enter() {
	  if (event.keyCode==13){
	   	  doSearch();
	  }
	}

	//Search
	function doSearch() {
		goPage(1);
	}

	// 검색조건 초기화 함수
	function fn_Reset() {
		f.searchCompanyKor.value = "";
		f.searchEnterRegNo.value = "";
		f.searchBsNo.value = "";
		f.returnStartDt.value = "";
		f.returnEndDt.value = "";
		f.searchOrgCdId.value = "";
		f.searchExpImpCdId.value = "";

		f.startDt.value = "";
		f.endDt.value = "";
	}

	// 엑셀다운로드
	function doDownloadExcel() {
		var f = document.viewForm;
		f.action = '<c:url value="/svcex/svcexCertificate/selectDeniedExcelList.do" />';
		f.method = 'post';
		f.target = '_self';
		f.submit();
		f.method = 'get';
	}

	//상품 수가 0인 칸은 빈칸으로 처리
	function setCntBlank() {
		var rowSize = parseInt(pageUnit.options[pageUnit.selectedIndex].value);

		for(var row = 1; row < rowSize + 1; row++) {
			var cnt = deniedListSheet.GetCellValue(row, 'cnt');
			if(cnt == 0) {
				deniedListSheet.SetCellValue(row, 'cnt', '');
			}
		}
	}

</script>
