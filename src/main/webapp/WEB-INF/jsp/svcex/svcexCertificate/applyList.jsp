<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<form name="viewForm" id="viewForm" method="post" onsubmit="return false;">
	<input type="hidden" name="event"				id="event"     			value="">
	<input type="hidden" name="statusChk"			id="statusChk"			value="">
	<input type="hidden" name="bsNo"				id="bsNo"				value=""/>
	<input type="hidden" name="transportServiceCd"	id="transportServiceCd"	value=""/>
	<input type="hidden" name="stateCd"				id="stateCd"			value=""/>
	<input type="hidden" name="reqno"				id="reqno"				value=""/>
	<input type="hidden" name="manCreYn"			id="manCreYn"			value=""/>
	<input type="hidden" name="listPage"			id="listPage"			value="<c:out value="/svcex/svcexCertificate/applyList.do"/>"/>
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

	<div class="foldingTable fold">
		<div class="foldingTable_inner">
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
							<input type="text" name="searchCompanyKor" id="searchCompanyKor" class="form_text w100p" onkeydown="onEnter(doSearch);" maxlength="150" value="<c:out value="${svcexVO.searchCompanyKor }"/>" desc="회사명" onKeyPress="check_Enter()">
						</td>
						<th>사업자등록번호</th>
						<td>
							<input type="text" name="searchEnterRegNo" id="searchEnterRegNo" class="form_text w100p" onkeydown="onEnter(doSearch);" maxlength="10" value="<c:out value="${svcexVO.searchEnterRegNo }"/>" desc="사업자등록번호" onKeyPress="check_Enter()">
						</td>
						<th>무역업고유번호</th>
						<td>
							<input type="text" name="searchBsNo" id="searchBsNo" class="form_text w100p" onkeydown="onEnter(doSearch);" maxlength="8" value="<c:out value="${svcexVO.searchBsNo }"/>" desc="무역업고유번호" onKeyPress="check_Enter()">
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
						<th>품목명(용역명)</th>
						<td>
							<input type="text" name="itemNm" id="itemNm" class="form_text w100p" onkeydown="onEnter(doSearch);" maxlength="8" value="<c:out value="${svcexVO.itemNm }"/>" desc="품목명" onKeyPress="check_Enter()">
						</td>
					</tr>
					<tr>
						<th>발급구분</th>
						<td>
							<select name="searchIssueCd" id="searchIssueCdId" class="form_select w100p">
								<c:forEach var="list" items="${com007}" varStatus="status">
									<option value="${list.detailcd}"<c:if test="${svcexVO.searchIssueCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
								</c:forEach>
							</select>
						</td>
						<th>수출입</th>
						<td>
							<select name="searchExpImpCd" id="searchExpImpCdId" class="form_select w100p">
								<c:forEach var="list" items="${com002}" varStatus="status">
									<option value="${list.detailcd}"<c:if test="${svcexVO.searchExpImpCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
								</c:forEach>
							</select>
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
						<th>담당본부</th>
						<td>
							<select name="searchOrgCd" id="searchOrgCdId" class="form_select w100p">
								<c:forEach var="list" items="${svc001}" varStatus="status">
									<option value="${list.detailcd}"<c:if test="${svcexVO.searchOrgCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</tbody>
			</table><!-- //formTable -->
		</div>
		<button class="btn_folding" id="btnFolding" title="테이블접기"></button>
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
		<div id="apllyList" class="sheet"></div>
		<div id="paging" class="paging ibs"></div>
	</div>

</form>

<script type="text/javascript">

	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: 'No',		    Type: 'Text', SaveName: 'rn',				Width: 6,	Align: 'Center'});
	ibHeader.addHeader({Header: '회사명',			Type: 'Text', SaveName: 'companyKor',			Width: 13,	Align: 'Left', Ellipsis: true, Cursor:"Pointer"});
	ibHeader.addHeader({Header: '관리자등록',		Type: 'Text', SaveName: 'manCreYnNm',			Width: 7,	Align: 'Center'});
	ibHeader.addHeader({Header: '지역',			Type: 'Text', SaveName: 'cityNm',				Width: 8,	Align: 'Center', Ellipsis: true});
	ibHeader.addHeader({Header: '신청일',			Type: 'Text', SaveName: 'reqDate',				Width: 8,	Align: 'Center'});
	ibHeader.addHeader({Header: '발급일',			Type: 'Text', SaveName: 'issueDate',			Width: 8,	Align: 'Center'});
	ibHeader.addHeader({Header: '발급구분',		Type: 'Text', SaveName: 'issueCd',				Width: 6,	Align: 'Center'});
	ibHeader.addHeader({Header: '용역명(품목명)',	Type: 'Text', SaveName: 'itemNm',				Width: 17, Align: 'Center'});
	ibHeader.addHeader({Header: '상품수',			Type: 'Text', SaveName: 'cnt',					Width: 5,	Align: 'Center'});
	ibHeader.addHeader({Header: '무역업고유번호',	Type: 'Text', SaveName: 'bsNo',					Width: 10,	Align: 'Center'});
	ibHeader.addHeader({Header: '금액($)',		Type: 'Text', SaveName: 'checkAmount',			Width: 8,	Align: 'Right'});
	ibHeader.addHeader({Header: '수출입',			Type: 'Text', SaveName: 'expImpNm',				Width: 5,	Align: 'Center'});
	ibHeader.addHeader({Header: '구분',			Type: 'Text', SaveName: 'transportServiceCd',	Width: 8,	Align: 'Center'});
	ibHeader.addHeader({Header: '진행상태',		Type: 'Text', SaveName: 'stateNm',				Width: 6,	Align: 'Center'});
	ibHeader.addHeader({Header: '진행상태코드',		Type: 'Text', SaveName: 'stateCd',				Width: 6,	Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '신청번호',		Type: 'Text', SaveName: 'reqno',				Width: 6,	Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '관리자등록여부',	Type: 'Text', SaveName: 'manCreYn',			Width: 6,	Align: 'Center', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode : 0 });
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f = document.viewForm;

	$(document).ready(function(){
		var container = $('#apllyList')[0];
		createIBSheet2(container, 'apllyListSheet', '100%', '100%');
		ibHeader.initSheet('apllyListSheet');

		if('<c:out value="${svcexVO.defaultValue }"/>' == 'none') {
			$('.btn_folding').click();
		}

		// 시작일 선택 이벤트
		datepickerById('startDt', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('endDt', toDateSelectEvent);
		// 시작일 선택 이벤트
		datepickerById('issueStartDt', fromDateSelectEvent2);
		// 종료일 선택 이벤트
		datepickerById('issueEndDt', toDateSelectEvent2);

		getApplyList();
		
		// 대쉬보드에서 값 넘어올떄
		if($("#searchKeyword").val() != "" && $("#sStartDate").val() != "") {
			document.getElementById('btnFolding').click();
		}
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

	function apllyListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
		}else{
			// 볼드 처리
			apllyListSheet.SetColFontBold('companyKor', 1);
		}

		setCntBlank();
	}

	function apllyListSheet_OnRowSearchEnd(row) {
		if ( row > 0) {
			var index = apllyListSheet.GetCellValue(row, "rn");
			var resultCnt = $('#resultCnt').val();
			apllyListSheet.SetCellValue(row, "rn", parseInt(resultCnt - index)+1 );
		}
	}

	function apllyListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if( apllyListSheet.ColSaveName(col) == "companyKor" ) {
				var url = "";
				var stateCd = apllyListSheet.GetCellValue(row, "stateCd");
				var transportServiceCd = apllyListSheet.GetCellValue(row, "transportServiceCd");

				if( stateCd == "B" ) { if(!confirm("심사중으로 상태변경 하시겠습니까?"))return; }

				if( transportServiceCd == '운수' ){
			    	url = "/svcex/svcexCertificate/applyDetail2View.do";
			    }else{
			    	url = "/svcex/svcexCertificate/applyDetailView.do";
			    }
				var bsNo = apllyListSheet.GetCellValue(row, "bsNo");
				var reqno = apllyListSheet.GetCellValue(row, "reqno");
				var manCreYn = apllyListSheet.GetCellValue(row, "manCreYn");

				f.bsNo.value = bsNo;
				f.reqno.value = reqno;
				f.stateCd.value = stateCd;
				f.transportServiceCd.value = transportServiceCd;
				f.manCreYn.value = manCreYn;
				f.action = url;
				f.target = '_self';
				f.submit();
			}
		}
	}

	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		getApplyList();
	}

	function getApplyList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/selectApplyList.do" />'
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
				apllyListSheet.SetSelectionMode(4);
				apllyListSheet.LoadSearchData({Data: data.resultList}, {Wait: 0});
			}
		});
	}

	function check_Enter()
	{
	  if (event.keyCode==13){
	   	  doSearch();
	  }
	}
	//Search
	function doSearch() {
		/* if(f.reqStartDt.value != "" && f.reqEndDt.value != ""){
			if(f.reqStartDt.value > f.reqEndDt.value){
				alert("신청기간 날짜를 확인 하십시요.");
				return;
			}
		}
		if(f.creStartDt.value != "" && f.creEndDt.value != ""){
			if(f.creStartDt.value > f.creEndDt.value){
				alert("작성일 날짜를 확인 하십시요.");
				return;
			}
		} */
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

		goPage(1);
	}

	// 검색조건 초기화 함수
	function fn_Reset() {
		f.searchCompanyKor.value = "";
		f.searchEnterRegNo.value = "";
		f.searchBsNo.value = "";
		f.issueStartDt.value = "";
		f.issueEndDt.value = "";
		f.searchIssueCdId.value = "";
		f.searchExpImpCdId.value = "";
		f.searchStateCdId.value = "";
		f.searchOrgCdId.value = "";
		f.itemNm.value = "";

		f.startDt.value = "";
		f.endDt.value = "";
	}

	// 엑셀다운로드
	function doDownloadExcel() {
		var f = document.viewForm;
		f.action = '<c:url value="/svcex/svcexCertificate/selectApplyExcelList.do" />';
		f.method = 'post';
		f.target = '_self';
		f.submit();
		f.method = 'get';
	}

	//상품 수가 0인 칸은 빈칸으로 처리
	function setCntBlank() {
		var rowSize = parseInt(pageUnit.options[pageUnit.selectedIndex].value);

		for(var row = 1; row < rowSize + 1; row++) {
			var cnt = apllyListSheet.GetCellValue(row, 'cnt');
			if(cnt == 0) {
				apllyListSheet.SetCellValue(row, 'cnt', '');
			}
		}
	}

</script>
