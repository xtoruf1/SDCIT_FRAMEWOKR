<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="/js/tradeSosComm.js"></script>
<form id ="searchForm" name="searchForm" method="post">
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />"/>
<input type="hidden" id="expertId" name="expertId" value="" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doDownloadExcel();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width: 13%" />
			<col style="width: 15%" />
			<col style="width: 13%" />
			<col style="width: 15%" />
			<col style="width: 13%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">상담분야</th>
				<td>
					<select id="searchConsult" name="searchConsult" class="form_select">
						<option value="">전체</option>
						<c:forEach var="item" items="${consultList}" varStatus="status">
							<option value="${item.CONSULT_TYPE_CD}" <c:if test="${searchVO.searchConsult eq item.CONSULT_TYPE_CD}">selected="selected"</c:if>>${item.CONSULT_TYPE_NM}</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">성명</th>
				<td>
					<input type="text" id="searchExpertNm" name="searchExpertNm" value="${searchVO.searchExpertNm}" onkeydown="onEnter(doSearch);" class="form_text w100p" />
				</td>
				<th scope="row">활동국가 / 지역</th>
				<td>
					<select id="searchNation" name="searchNation" class="form_select" onchange="showRegion(this.value);" style="width: 220px;">
						<option value="">전체</option>
						<c:forEach var="item" items="${nationList}" varStatus="status">
							<option value="${item.CODE}" ${selected}>${item.CODE_NM}</option>
						</c:forEach>
					</select>
					<select name="searchRegion" id="searchRegion" class="form_select">
						<option value="">전체</option>
						<c:forEach var="item" items="${regionList}" varStatus="status">
							<option value="${item.cdId}" <c:if test="${searchVO.searchRegion eq item.cdId}">selected="selected"</c:if>>${item.cdNm}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">채용기간</th>
				<td colspan="5">
					<div class="flex align_center">
						<select id="searchDateStatus" name="searchDateStatus" class="form_select">
							<option value="">전체</option>
							<option value="001" <c:if test="${searchVO.searchDateStatus eq '001'}">selected="selected"</c:if>>채용시작일</option>
							<option value="002" <c:if test="${searchVO.searchDateStatus eq '002'}">selected="selected"</c:if>>채용종료일</option>
						</select>
						<div class="group_datepicker ml-8">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="searchFrDt" name="searchFrDt" value="" class="txt datepicker" title="시작일" placeholder="시작일" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyStartDate" value="" />
								</span>
								<!-- clear 버튼 -->
								<button type="button" onclick="clearPickerValue('searchFrDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
							<div class="spacing">~</div>
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="searchToDt" name="searchToDt" value="" class="txt datepicker" title="종료일" placeholder="종료일" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyEndDate" value="" />
								</span>
								<!-- clear 버튼 -->
								<button type="button" onclick="clearPickerValue('searchToDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
					</div>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
		<fieldset class="ml-auto">
			<select id="pageUnit" name="pageUnit" onchange="doSearch();" class="form_select" title="목록수">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</fieldset>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="tblSheet" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<form id="excelForm" name="excelForm" method="post">
<input type="hidden" name="searchConsult" />
<input type="hidden" name="searchExpertNm" />
<input type="hidden" name="searchNation" />
<input type="hidden" name="searchRegion" />
<input type="hidden" name="searchDateStatus" />
<input type="hidden" name="searchFrDt" />
<input type="hidden" name="searchToDt" />
</form>
<script type="text/javascript">
	$(document).ready(function(){

		// 시작일 선택 이벤트
		datepickerById('searchFrDt', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('searchToDt', toDateSelectEvent);

		// IBSheet 호출
		// 리스트 Sheet 셋팅
		f_Init_tblSheet();
		// 목록 조회
		getList();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchFrDt').val());

		if ($('#searchToDt').val() != '') {
			if (startymd > Date.parse($('#searchToDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchFrDt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchToDt').val());

		if ($('#searchFrDt').val() != '') {
			if (endymd < Date.parse($('#searchFrDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchToDt').val('');

				return;
			}
		}
	}

	function f_Init_tblSheet(){
		// 세팅
		var	ibHeader = new	IBHeader();

    	ibHeader.addHeader({Type: 'Text', Header: '상담분야'		, SaveName: 'consultTypeNm'	, Align: 'Left'		, Width: 350});
    	ibHeader.addHeader({Type: 'Text', Header: '성명'			, SaveName: 'expertNm'		, Align: 'Center'	, Width: 150	, Ellipsis: 1,  Cursor: 'Pointer'});
    	ibHeader.addHeader({Type: 'Text', Header: '활동국가'		, SaveName: 'atvCtrNm'		, Align: 'Center'	, Width: 150});
    	ibHeader.addHeader({Type: 'Text', Header: '지역'			, SaveName: 'atvAreaNm'		, Align: 'Center'	, Width: 150});
    	ibHeader.addHeader({Type: 'Text', Header: '휴대전화'		, SaveName: 'cellPhone'		, Align: 'Center'	, Width: 150	, Format: '###-####-####'});
    	ibHeader.addHeader({Type: 'Text', Header: '채용기간'		, SaveName: 'recruitDate'	, Align: 'Center'	, Width: 250});

    	ibHeader.addHeader({Type: 'Text', Header: '전문가아이디'	, SaveName: 'expertId'		, Align: 'Center'	, Width: 150	, Hidden:true});

    	// 리스트, 헤더 옵션 */
    	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
    	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

        var sheetId = 'tblSheet';
		var container = $('#' + sheetId)[0];
        createIBSheet2(container, sheetId, '100%', '100%');
        ibHeader.initSheet(sheetId);
        tblSheet.SetSelectionMode(4);

     	// 편집모드 OFF
		tblSheet.SetEditable(0);

		var searchNationVal = '${searchVO.searchNation}';
		if (searchNationVal != 'KR') {
			$('#searchRegion').hide();
		} else {
			$('#searchRegion').show();
		}
	}

	function tblSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('tblSheet_OnSearchEnd : ', msg);
		} else {
			// 제목에 볼드 처리
			tblSheet.SetColFontBold('expertNm', 1);
		}
	}

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.searchForm.pageIndex.value = pageIndex;
		getList();
	}

	function getList() {
		global.ajax({
			url : '<c:url value="/tradeSOS/com/expertMemberListAjax.do" />'
			, type : 'post'
			, data : $('#searchForm').serializeArray()
			, async : false
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
			, error : function(request, status, error) {
				alert('전문가 조회에 실패했습니다.');
			}
		});
	}

	// 상세
 	function tblSheet_OnClick(Row, Col, Value) {
		if (Row > 0) {
			if (tblSheet.ColSaveName(Col) == 'expertNm') {
				goDetail(tblSheet.GetCellValue(Row, 'expertId'));
			}
		}
	};

	function goDetail(expertId) {
		document.searchForm.action = '<c:url value="/tradeSOS/com/expertMemberDetail.do" />';
		document.searchForm.expertId.value = expertId;
		document.searchForm.submit();
	}

	function showRegion(val) {
		if (val.trim() == 'KR'.trim()) {
			$('#searchRegion').show();
		} else {
			$('#searchRegion').hide();
		}
	}

	// 엑셀다운로드
	function doDownloadExcel() {
		var searchFrDt = $('#searchFrDt').val().replace(/-/gi, '');
		var searchToDt = $('#searchToDt').val().replace(/-/gi, '');

		var f = document.excelForm;
		f.action = '<c:url value="/tradeSOS/com/expertMemberExcelList.do" />';
		f.searchConsult.value = $('#searchConsult').val();
		f.searchExpertNm.value = $('#searchExpertNm').val();
		f.searchNation.value = $('#searchNation').val();
		f.searchRegion.value = $('#searchRegion').val();
		f.searchDateStatus.value = $('#searchDateStatus').val();
		f.searchFrDt.value = searchFrDt;
		f.searchToDt.value = searchToDt;
		f.target = '_self';
		f.submit();
	}
</script>