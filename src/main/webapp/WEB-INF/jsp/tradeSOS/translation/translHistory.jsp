<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<form name="searchForm" id="searchForm" method="get">
	<input type="hidden" name="topMenuId" value="" />
	<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
	<input type="hidden" name="procType" id="procType" />
	<input type="hidden" name="orderSeq" id="orderSeq" />
	<input type="hidden" name="gubun" id="gubun"/>
	<input type="hidden" name="companyId" id="companyId"/>
	<input type="hidden" name="state" id="state"/>
	<input type="hidden" name="tableGubun" id="tableGubun"/>

<!-- 외국어 통번역 신청 내역- 리스트 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<div class="cont_block">
	<!-- 검색 테이블 -->
	<div class="foldingTable fold">
		<div class="foldingTable_inner">
			<table class="formTable">
				<colgroup>
					<col style="width:10%">
					<col>
					<col style="width:10%">
					<col>
					<col style="width:10%">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">등록일</th>
						<td colspan="3">
							<div class="group_datepicker">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="sStartDate" name="tempFrDt" value="${searchVO.tempFrDt}" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyStartDate" value="" />
									</span>
								</div>
								<!-- clear 버튼 -->
								<button type="button" class="ml-8" onclick="clearDate('sStartDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>

								<div class="spacing">~</div>

								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="sEndDate" name="tempToDt" value="${searchVO.tempToDt}" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyEndDate" value="" />
									</span>
								</div>
								<!-- clear 버튼 -->
								<button type="button" class="ml-8" onclick="clearDate('sEndDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
							</div>
						</td>
						<th scope="row">서비스</th>
						<td>
							<select name="searchGubun" id="searchGubun" class="form_select w100p">
								<option value="000">전체</option>
								<c:forEach items="${gubunList}" var="item" varStatus="status">
									<option value="${item.cdId}" <c:if test="${searchVO.searchGubun eq item.cdId}">selected</c:if>><c:out value="${item.cdNm}"/></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">신청언어</th>
						<td>
							<select name="searchLanguage" id="searchLanguage" class="form_select w100p">
								<option value="">전체</option>
								<c:forEach items="${languageList}" var="item" varStatus="status">
									<option value="${item.cdId}" <c:if test="${searchVO.searchLanguage eq item.cdId}">selected</c:if>><c:out value="${item.cdNm}"/></option>
								</c:forEach>
							</select>
						</td>
						<th scope="row">완료일</th>
						<td>
							<div class="group_datepicker">
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchBgnDe" name="searchBgnDe" value="${searchVO.searchBgnDe}" class="txt datepicker mtz-monthpicker-widgetcontainer" title="검색월" readonly="readonly">
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummySearchBgnDe" value="" />
									</span>
								</div>
									<!-- clear 버튼 -->
									<button type="button" class="ml-8" onclick="clearDate('searchBgnDe');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
							</div>
						</td>

						<th scope="row">컨설턴트</th>
						<td>
							<%-- <select name="searchExpertId" id="searchExpertId" class="w100p">
								<option value="">전체</option>
								<c:forEach items="${memberList}" var="item" varStatus="status">
									<option value="${item.expertid}" <c:if test="${searchVO.searchExpertId eq item.expertid}">selected</c:if>><c:out value="${item.name}"/></option>
								</c:forEach>
							</select> --%>

							<input type="text" id="searchExpertNm" name="searchExpertNm" class="form_text w100p" value="<c:out value="${searchVO.searchExpertNm}"/>" onkeydown="onEnter(doSearch);">

						</td>
					</tr>
					<tr>
						<th scope="row">통지서</th>
						<td>
							<label class="label_form">
								<input type="radio" name="searchMailYn" id="radio1_1"  value="all" checked="checked" class="form_radio">
								<span class="label">전체</span>
							</label>
							<label class="label_form">
								<input type="radio" name="searchMailYn" id="radio1_2" value="Y" <c:if test="${searchVO.searchMailYn eq 'Y'}">checked="checked"</c:if> class="form_radio">
								<span class="label">발송</span>
							</label>
							<label class="label_form">
								<input type="radio" name="searchMailYn" id="radio1_3" value="N" <c:if test="${searchVO.searchMailYn eq 'N'}">checked="checked"</c:if> class="form_radio">
								<span class="label">미발송</span>
							</label>
						</td>
						<th scope="row">진행상태</th>
						<td>
							<select name="searchState" id="searchState" class="form_select w100p">
								<option value="000">전체</option>
								<c:forEach items="${processList}" var="item" varStatus="status">
									<option value="${item.cdId}" <c:if test="${searchVO.searchState eq item.cdId}">selected</c:if>><c:out value="${item.cdNm}"/></option>
								</c:forEach>
							</select>
						</td>
						<th scope="row">무역업번호</th>
						<td>
							<input type="text" id="searchTradeNo" name="searchTradeNo" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value="${searchVO.searchTradeNo}"/>" onkeypress="press(event);">
						</td>
					</tr>
					<tr>
						<th scope="row">자기부담금</th>
						<td>
							<select name="searchSelfAmount" id="searchSelfAmount" class="form_select w100p">
								<option value="">전체</option>
								<option value="001">바우처지원</option>
								<option value="002">부분발생</option>
								<option value="003">전액발생</option>
							</select>
						</td>
						<th scope="row">업체명</th>
						<td colspan="3">
							<input type="text" id="searchCompanyNm" name="searchCompanyNm" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value="${searchVO.searchCompanyNm}"/>" onkeypress="press(event);">
						</td>
					</tr>
				</tbody>
			</table><!-- // 검색 테이블-->
			</div>
		<button type="button" class="btn_folding" title="테이블접기"></button>
	</div>

	<!-- 리스트 테이블 -->
	<div class="tbl_list mt-20">
		<div class="tbl_opt">
			<!-- 상담내역조회 -->
			<div id="totalCnt" class="total_count"></div>

			<fieldset class="ml-auto">
				<select id="pageUnit" name="pageUnit" onchange="doSearch();" title="목록수" class="form_select">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>
			</fieldset>
		</div>

		<div style="width: 100%;height: 100%;">
			<div id='tblSheet' class="colPosi"></div>
		</div>
		<!-- .paging-->
		<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
	</div>

</div> <!-- // .page_tradesos -->
</form>

<script type="text/javascript">
	var f;
	$(document).ready(function() {
		f = document.searchForm;

		//IBSheet 호출
		f_Init_tblSheet();		// 리스트  Sheet 셋팅

		// 시작일 선택 이벤트
		datepickerById('sStartDate', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('sEndDate', toDateSelectEvent);

		getList();			// 목록 조회
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#sStartDate').val());

		if ($('#sEndDate').val() != '') {
			if (startymd > Date.parse($('#sEndDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#sStartDate').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#sEndDate').val());

		if ($('#sStartDate').val() != '') {
			if (endymd < Date.parse($('#sStartDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#sEndDate').val('');

				return;
			}
		}
	}

	function f_Init_tblSheet() {
		var	ibHeader	=	new	IBHeader();

		 /** 리스트,헤더 옵션 */
    	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize',Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
    	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "No", SaveName: "vnum", Align: "Center", Width: 55, Edit: false});
		ibHeader.addHeader({Type: "Text", Header: "업체명", SaveName: "companyKor", Align: "Left", Width: 200, Ellipsis:1, Cursor:"Pointer", Edit: false});
		ibHeader.addHeader({Type: "Text", Header: "신청자", SaveName: "memberNm", Align: "Center", Width: 100, Edit: false});
		ibHeader.addHeader({Type: "Text", Header: "서비스", SaveName: "gubunNm", Align: "Center", Width: 60, Edit: false});
		ibHeader.addHeader({Type: "Text", Header: "신청언어", SaveName: "languageNm", Align: "Center", Width: 60, Edit: false});
		ibHeader.addHeader({Type: "Text", Header: "상태", SaveName: "stateNm", Align: "Center", Width: 60, Edit: false});
		ibHeader.addHeader({Type: "Text", Header: "희망 컨설턴트", SaveName: "firstExpertNm", Align: "Center", Width: 60, Edit: false});
		ibHeader.addHeader({Type: "Text", Header: "컨설턴트", SaveName: "expertNm", Align: "Center", Width: 60, Edit: false});
		ibHeader.addHeader({Type: "Text", Header: "등록일", SaveName: "registDt", Align: "Center", Width: 60, Format:"####-##-##", Edit: false});
		ibHeader.addHeader({Type: "Text", Header: "완료일", SaveName: "finalDate", Align: "Center", Width: 60, Format:"####-##-##", Edit: false});
		ibHeader.addHeader({Type: "Text", Header: "o", SaveName: "orderSeq", Align: "Center", Width: 0, Hidden: true});
		ibHeader.addHeader({Type: "Text", Header: "g", SaveName: "gubun", Align: "Center", Width: 0, Hidden: true});
		ibHeader.addHeader({Type: "Text", Header: "c", SaveName: "companyId", Align: "Center", Width: 0, Hidden: true});
		ibHeader.addHeader({Type: "Text", Header: "s", SaveName: "state", Align: "Center", Width: 0, Hidden: true});
		ibHeader.addHeader({Type: "Text", Header: "flag", SaveName: "tableGubun", Align: "Center", Width: 0, Hidden: true});

        var sheetId = "tblSheet";
		var container = $("#"+sheetId)[0];
        createIBSheet2(container,sheetId, "100%", "100%");
        ibHeader.initSheet(sheetId);

		tblSheet.SetSelectionMode(1);
		// 편집모드 OFF
		tblSheet.SetEditable(0);

	};

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/translation/translHistoryAjax.do" />'
			, data : $('#searchForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				tblSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function tblSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('tblSheet_OnSearchEnd : ', msg);
		} else {
			// 제목에 볼드 처리
			tblSheet.SetColFontBold('companyKor', 1);
		}
	}

	// 상세
 	function tblSheet_OnClick(Row, Col, Value) {
		/*var rowData = mySheet.GetRowData(Row);
		fn_detail(rowData['orderSeq'],rowData['gubun'],rowData['companyId'],rowData['state'], rowData['tableGubun']);*/
		if(tblSheet.ColSaveName(Col) == "companyKor" && Row > 0){
			fn_detail(tblSheet.GetCellValue(Row,"orderSeq"),tblSheet.GetCellValue(Row,"gubun"),tblSheet.GetCellValue(Row,"companyId"),tblSheet.GetCellValue(Row,"state"),tblSheet.GetCellValue(Row,"tableGubun"));
		}

	};

	function press(event) {
		if (event.keyCode==13) {
			dataList(1);
		}
	}

	function fn_detail(orderSeq, gubun, companyId, state, tableGubun) {
		document.searchForm.action = "/tradeSOS/translation/translHistoryDetail.do";
		document.searchForm.procType.value = "U";
		document.searchForm.orderSeq.value = orderSeq;
		document.searchForm.gubun.value = gubun;
		document.searchForm.companyId.value = companyId;
		document.searchForm.state.value = state;
		document.searchForm.tableGubun.value = tableGubun;

		document.searchForm.submit();
	}

	function clearDate( targetId){
		$("#"+targetId).val("");
	}

</script>