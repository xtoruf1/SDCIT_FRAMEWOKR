<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="consultForm" name="consultForm" method="get" onsubmit="return false;">
<input type="hidden" id="pblcConsultId" name="pblcConsultId" value="" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">분야</th>
				<td>
					<select id="searchConsultTypeCd" name="searchConsultTypeCd" class="form_select">
						<option value="">전체</option>
						<c:forEach var="item" items="${consultTypeList}" varStatus="status">
							<option value="${item.consultTypeCd}" <c:if test="${param.searchConsultTypeCd eq item.consultTypeCd}">selected="selected"</c:if>>${item.consultTypeNm}</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">상태</th>
				<td>
					<select id="searchStatusCd" name="searchStatusCd" class="form_select">
						<option value="">전체</option>
						<c:forEach var="item" items="${statusCdList}" varStatus="status">
							<option value="${item.cdId}" <c:if test="${param.searchStatusCd eq item.cdId}">selected="selected"</c:if>>${item.cdNm}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">작성일자</th>
				<td>
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchStartDate" name="searchStartDate" value="${param.searchStartDate}" class="txt datepicker" placeholder="작성시작일자" title="작성시작일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('searchStartDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchEndDate" name="searchEndDate" value="${param.searchEndDate}" class="txt datepicker" placeholder="작성종료일자" title="작성종료일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('searchEndDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
				</td>
				<th scope="row">작성자</th>
				<td>
					<input type="text" id="searchReqNm" name="searchReqNm" value="${param.searchReqNm}" onkeydown="onEnter(doSearch);" class="form_text w100p" />
				</td>
            </tr>
            <tr>
				<th scope="row">답변/채택 전문가</th>
				<td>
					<select id="searchExptTypeCd" name="searchExptTypeCd" class="form_select" style="width: 30%;">
						<option value="">전체</option>
						<c:forEach var="item" items="${exptTypeCdList}" varStatus="status">
							<option value="${item.cdId}" <c:if test="${param.searchExptTypeCd eq item.cdId}">selected="selected"</c:if>>${item.cdNm}</option>
						</c:forEach>
					</select>
					<input type="text" id="searchExptText" name="searchExptText" value="${param.searchExptText}" onkeydown="onEnter(doSearch);" class="form_text" style="width: 55%;" />
				</td>
				<th scope="row">제목</th>
				<td>
					<input type="text" id="searchPblcTitle" name="searchPblcTitle" value="${param.searchPblcTitle}" onkeydown="onEnter(doSearch);" class="form_text w100p" />
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
		<div id="consultList" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: 'No', Type: 'Text', SaveName: 'pageSeq', Width: 50, Align: 'Center'});	
	ibHeader.addHeader({Header: '분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 120, Align: 'Left'});
	ibHeader.addHeader({Header: '제목', Type: 'Text', SaveName: 'pblcTitle', Width: 210, Align: 'Left', Cursor: 'Pointer', Ellipsis: 1});
	ibHeader.addHeader({Header: '작성자', Type: 'Text', SaveName: 'reqNm', Width: 90, Align: 'Center'});
	ibHeader.addHeader({Header: '상태', Type: 'Text', SaveName: 'statusNm', Width: 90, Align: 'Center'});
	ibHeader.addHeader({Header: '답변수', Type: 'Text', SaveName: 'answerCnt', Width: 50, Align: 'Center'});
	ibHeader.addHeader({Header: '채택된 전문가', Type: 'Text', SaveName: 'expertNm', Width: 90, Align: 'Center'});
	ibHeader.addHeader({Header: '작성일자', Type: 'Text', SaveName: 'creDate', Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '조회수', Type: 'Text', SaveName: 'hitsCount', Width: 50, Align: 'Center'});
	
	ibHeader.addHeader({Header: '오픈상담아이디', Type: 'Text', SaveName: 'pblcConsultId', Width: 50, Align: 'Center', Hidden: true});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	var f;
	$(document).ready(function(){
		f = document.consultForm;
		
		var container = $('#consultList')[0];
		createIBSheet2(container, 'consultListSheet', '100%', '100%');
		ibHeader.initSheet('consultListSheet');
		consultListSheet.SetSelectionMode(4);
		
		// 편집모드 OFF
		consultListSheet.SetEditable(0);
		
		// 시작일 선택 이벤트
		datepickerById('searchStartDate', fromDateSelectEvent);
		
		// 종료일 선택 이벤트
		datepickerById('searchEndDate', toDateSelectEvent);
		
		getList();
	});
	
	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchStartDate').val());
		
		if ($('#searchEndDate').val() != '') {
			if (startymd > Date.parse($('#searchEndDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchStartDate').val('');
				
				return;
			}
		}
	}
	
	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchEndDate').val());
		
		if ($('#searchStartDate').val() != '') {
			if (endymd < Date.parse($('#searchStartDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchEndDate').val('');
				
				return;
			}
		}
	}
	
	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.consultForm.pageIndex.value = pageIndex;
		getList();
	}
	
	// 오픈상담 목록
	function getList() {
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectPblcConsultList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : $('#consultForm').serialize()
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
				
				consultListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}
	
	function consultListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('consultListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 제목에 볼드 처리
			consultListSheet.SetColFontBold('pblcTitle', 1);
    	}
    }
	
	function consultListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('consultListSheet', row);
	}
	
	// 목록 클릭 이벤트
 	function consultListSheet_OnClick(Row, Col, Value) {
 		if (Row > 0) {
			if (consultListSheet.ColSaveName(Col) == 'pblcTitle') {
				var pblcConsultId = consultListSheet.GetCellValue(Row, 'pblcConsultId');
				
		 		goView(pblcConsultId);
		    }	
		}
	}
	
	// 상세화면
	function goView(pblcConsultId) {
		f.action = '<c:url value="/tradeSOS/exp/pblcConsultDetail.do" />';
		f.pblcConsultId.value = pblcConsultId;
		f.target = '_self';
		f.submit();
	}
	
	// 검색 필터 초기화
	function doInit() {
		location.href = '<c:url value="/tradeSOS/exp/pblcConsultList.do" />';
	}
	
	function setDefaultPickerValue(objId) {
		if (objId == 'searchStartDate') {
			$('#searchStartDate').val('${param.searchStartDate}');
		} else if (objId == 'searchEndDate') {
			$('#searchEndDate').val('${param.searchEndDate}');
		}
	}
</script>