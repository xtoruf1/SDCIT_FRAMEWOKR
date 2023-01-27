<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doExcelDownload();">엑셀 다운</button>
		<button type="button" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<form id="searchForm" method="post">
<div class="cont_block">
	<div class="search">
		<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
		<input type="hidden" id="traderId" name="traderId" value=""/>
		<input type="hidden" id="applId" name="applId" value=""/>
		<input type="hidden" id="exptBaseMonth" name="exptBaseMonth" value=""/>
		<input type="hidden" id="selectCount" name="selectCount" value=""/>
		<input type="hidden" id="sendYn" name="sendYn" value="${sendYn}"/>
		<table class="formTable">
			<colgroup>
				<col style="width:10%">
				<col style="width:23%">
				<col style="width:10%">
				<col style="width:25%">
				<col style="width:11%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th>회차</th>
					<td>
						<div class="field_set flex align_center">
							<span class="form_search w100p">
								<input type="hidden" id="searchTraderId" name="searchTraderId" value="${searchTraderId}"/>
								<input type="text" class="form_text"  title="기금융자" id="awardTitle" name="awardTitle" maxlength="150" readonly="readonly" value="<c:out value="${params.awardTitle}"/>" />
								<button type="button" class="btn_icon btn_search" title="기금융자 검색" onclick="openSearchPopup()"></button>
							</span>
						</div>
					</td>
					<th>신청일</th>
					<td colspan="5">
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="searchRegStartDt" id="searchRegStartDt" value="${param.searchRegStartDt}" class="txt datepicker" title="조회시작일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('searchRegStartDt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="searchRegEndDt" id="searchRegEndDt" value="${param.searchRegEndDt}" class="txt datepicker" title="조회종료일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('searchRegEndDt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<th>업체명</th>
					<td class="bRight">
						<input type="text" class="form_text w100p" name="searchCompanyName" id="searchCompanyName"  value="<c:out value="${ param.searchCorpNameKr }" />" onkeydown="onEnter(doSearch);"/>
					</td>
					<th>사업자번호</th>
					<td class="bRight">
						<input type="text" class="form_text w100p" name="searchBusinessNo" id="searchBusinessNo"  value="<c:out value="${ param.searchCorpNameKr }" />" onkeydown="onEnter(doSearch);"/>
					</td>
					<th>무역업번호</th>
					<td colspan="3">
						<input type="text" class="form_text w100p" name="searchTradeNo" id="searchTradeNo" value="<c:out value="${ param.searchCorpRegNo }" />"  onkeydown="onEnter(doSearch);"/>
					</td>
				</tr>
				<tr>
					<th>대표자</th>
					<td>
						<input type="text" class="form_text w100p" name="searchCeoName" id="searchCeoName" value="<c:out value="${ param.searchCorpRegNo }" />" onkeydown="onEnter(doSearch);" />
					</td>
					<th>평가점수</th>
					<td>
						<input type="text" class="form_text" style="width: 95px;" name="searchStartScore" id="searchStartScore" oninput="this.value = this.value.replace(/[^0-9]/g, '');" value="<c:out value="${ param.searchCorpRegNo }" />"  onkeydown="onEnter(doSearch);" maxlength="3"/>
						<span> ~ </span>
						<input type="text" class="form_text" style="width: 95px;" name="searchEndScore" id="searchEndScore" oninput="this.value = this.value.replace(/[^0-9]/g, '');" value="<c:out value="${ param.searchCorpRegNo }" />" onkeydown="onEnter(doSearch);" maxlength="3"/>
					</td>
					<th>선정여부</th>
					<td colspan="3">
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchStatus" value="" <c:if test="${ param.searchStatus eq '' }">checked</c:if> checked>
							<span class="label">전체</span>
						</label>

						<label class="label_form">
							<input type="radio" class="form_radio" name="searchStatus" value="Y" <c:if test="${ param.searchStatus eq 'Y' }">checked</c:if>>
							<span class="label">선정</span>
						</label>

						<label class="label_form">
							<input type="radio" class="form_radio" name="searchStatus" value="N" <c:if test="${ param.searchStatus eq 'N' }">checked</c:if>>
							<span class="label">미선정</span>
						</label>
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
		<div id="applicantListSheet" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_applicantList();	// 사업 리스트 헤더
		getApplicantList();				// 사업 목록 조회

	});

	function setSheetHeader_applicantList() {	// 사업 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '한빛회ID'		, Type: 'Text'			, SaveName: 'traderId'			, Hidden: true});
		ibHeader.addHeader({Header: '한빛회신청ID'		, Type: 'Text'			, SaveName: 'applId'			, Hidden: true});
		ibHeader.addHeader({Header: 'No'			, Type: 'Text'			, SaveName: 'no'				, Edit: false	, Width: 10		, Align: 'Center'});
		ibHeader.addHeader({Header: '회차'			, Type: 'Text'			, SaveName: 'awardRound'		, Edit: false	, Width: 10		, Align: 'Center'});
		ibHeader.addHeader({Header: '업체명'			, Type: 'Text'			, SaveName: 'companyName'		, Edit: false	, Width: 40		, Align: 'Left'	, Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '사업자번호'		, Type: 'Text'			, SaveName: 'businessNo'		, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '무역업번호'		, Type: 'Text'			, SaveName: 'tradeNo'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '대표자'			, Type: 'Text'			, SaveName: 'ceoName'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '회원사여부'		, Type: 'Text'			, SaveName: 'memberYn'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '평가점수'			, Type: 'Text'			, SaveName: 'totScore'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '신청일'			, Type: 'Text'			, SaveName: 'creDate'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '선정여부'			, Type: 'Text'			, SaveName: 'choiceYn'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '실적기준월'		, Type: 'Text'			, SaveName: 'exptBaseMonth'		, Hidden: true});
		ibHeader.addHeader({Header: '선정인원'			, Type: 'Text'			, SaveName: 'selectCount'		, Hidden: true});
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

		var container = $('#applicantListSheet')[0];
		createIBSheet2(container, 'applicantListSheet', '100%', '10%');
		ibHeader.initSheet('applicantListSheet');

		applicantListSheet.SetEllipsis(1); // 말줄임 표시여부
		applicantListSheet.SetSelectionMode(4);

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

	function doSearch() {
		$('#pageIndex').val(1);
		getApplicantList();
	}

	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getApplicantList();
	}

	function chgPageCnt() {
		doSearch();
	}

	function applicantListSheet_OnRowSearchEnd(row) {
		applicantListSheet.SetColFontBold('companyName', 1);
		applicantListSheet.SetColFontBold('choiceYn', 1);

		if(applicantListSheet.GetCellValue(row, 'choiceYn') == '선정') {
			applicantListSheet.SetCellFontColor(row ,'choiceYn' ,"#0080FF");

		}
	}

	function applicantListSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {

		if(rowType == 'HeaderRow'){
			return;
		}

		var traderId = applicantListSheet.GetCellValue(Row, 'traderId');
		var applId = applicantListSheet.GetCellValue(Row, 'applId');
		var exptBaseMonth = applicantListSheet.GetCellValue(Row, 'exptBaseMonth');
		var selectCount = applicantListSheet.GetCellValue(Row, 'selectCount');

		if(applicantListSheet.ColSaveName(Col) == 'companyName'){	// 상세페이지 이동

			$('#traderId').val(traderId);
			$('#applId').val(applId);
			$('#exptBaseMonth').val(exptBaseMonth);
			$('#selectCount').val(selectCount);
			$('#searchForm').attr('action', '/hanbit/hanbitApplicant/hanbitApplicantDetail.do');
			$('#searchForm').submit();

		}
	}

	function getApplicantList() {	// 회사 조회

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitApplicant/selectHanbitApplicantList.do"
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

				applicantListSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function doExcelDownload() {	// 엑셀다운
		$('#searchForm').attr('action','/hanbit/hanbitApplicant/hanbitApplicantListExcelDown.do');
		$('#searchForm').submit();
	}

	function doClear() {	// 초기화
		location.reload();
	}

	function openSearchPopup() {

		global.openLayerPopup({
			popupUrl : '/hanbit/popup/hanbitSearchPop.do'
			, callbackFunction : function(resultObj){

				$("#searchTraderId").val(resultObj.traderId);			// 한빛회ID
				$("#awardTitle").val(resultObj.awardTitle);	// 회차명
				$("#sendYn").val(resultObj.sendYn);	// 회차명

				getApplicantList();
			}
		});
	}

</script>