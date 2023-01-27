<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="consultForm" name="consultForm" method="get" onsubmit="return false;">
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doFileUpload();" class="btn_sm btn_primary btn_modify_auth">파일 업로드</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doDownloadExcel();" class="btn_sm btn_primary">엑셀 다운로드</button>
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
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">상담 서비스</th>
				<td>
					<select id="searchConsultService" name="searchConsultService" class="form_select" title="상담 서비스">
						<option value="">전체</option>
						<option value="0" <c:if test="${param.searchConsultService eq '0'}">selected="selected"</c:if>>오픈상담</option>
						<option value="1" <c:if test="${param.searchConsultService eq '1'}">selected="selected"</c:if>>1:1상담</option>
					</select>
				</td>
				<th scope="row">상담채널</th>
				<td>
					<select id="searchConsultChannel" name="searchConsultChannel" class="form_select" title="상담채널">
						<option value="">전체</option>
						<c:forEach var="item" items="${consultChannelList}" varStatus="status">
							<option value="${item.cdId}" <c:if test="${param.searchConsultChannel eq item.cdId}">selected="selected"</c:if>>${item.cdNm}</option>
						</c:forEach>
						<option value="04" <c:if test="${param.searchConsultChannel eq '04'}">selected="selected"</c:if>>온라인</option>
					</select>
				</td>
				<th scope="row">상담분야</th>
				<td>
					<select id="searchConsultTypeCd" name="searchConsultTypeCd" class="form_select" title="상담분야">
						<option value="">전체</option>
						<c:forEach var="item" items="${consultTypeList}" varStatus="status">
							<option value="${item.consultTypeCd}" <c:if test="${param.consultTypeCd eq item.consultTypeCd}">selected="selected"</c:if>>${item.consultTypeNm}</option>
						</c:forEach>
					</select>
				</td>
            </tr>
            <tr>
            	<th scope="row">제목 및 상담요지</th>
				<td>
					<input type="text" id="searchConsultText" name="searchConsultText" value="${param.searchConsultText}" onkeydown="onEnter(doSearch);" class="form_text w100p" />
				</td>
				<th scope="row">공개 여부</th>
				<td>
					<select id="searchOpenYn" name="searchOpenYn" class="form_select" title="공개 여부">
						<option value="">전체</option>
						<option value="Y" <c:if test="${param.searchOpenYn eq 'Y'}">selected="selected"</c:if>>공개</option>
						<option value="N" <c:if test="${param.searchOpenYn eq 'N'}">selected="selected"</c:if>>비공개</option>
					</select>
				</td>
				<th scope="row">Data 사용여부</th>
				<td>
					<select id="searchDataUseYn" name="searchDataUseYn" class="form_select" title="Data 사용여부">
						<option value="">NULL</option>
						<option value="Y" <c:if test="${param.searchDataUseYn eq 'Y'}">selected="selected"</c:if>>Y</option>
						<option value="N" <c:if test="${param.searchDataUseYn eq 'N'}">selected="selected"</c:if>>N</option>
					</select>
				</td>
            </tr>
            <tr>
            	<th scope="row">일자</th>
				<td colspan="5">
					<div class="group_datepicker">
						<div style="margin-right: 10px;">
							<select id="searchDateType" name="searchDateType" class="form_select" title="일자">
								<option value="1" <c:if test="${param.searchDateType eq '1'}">selected="selected"</c:if>>상담일자</option>
								<option value="2" <c:if test="${param.searchDateType eq '2'}">selected="selected"</c:if>>답변일자</option>
								<option value="3" <c:if test="${param.searchDateType eq '3'}">selected="selected"</c:if>>검수일자</option>
							</select>
						</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchFromDate" name="searchFromDate" value="${param.searchFromDate}" class="txt datepicker" style="width: 100px;" placeholder="시작일자" title="시작일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('searchFromDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchToDate" name="searchToDate" value="${param.searchToDate}" class="txt datepicker" style="width: 100px;" placeholder="종료일자" title="종료일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('searchToDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
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
		<div id="consultList" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<form id="excelForm" name="excelForm" method="post">
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '번호', Type: 'Number', SaveName: 'pageSeq', Width: 60, Align: 'Center'});
	ibHeader.addHeader({Header: '구분', Type: 'Text', SaveName: 'typeNm', Width: 70, Align: 'Center'});
	ibHeader.addHeader({Header: '상담분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 120, Align: 'Left'});
	ibHeader.addHeader({Header: '상담채널', Type: 'Text', SaveName: 'consultChannelNm', Width: 80, Align: 'Center'});
	ibHeader.addHeader({Header: '제목', Type: 'Text', SaveName: 'consultText', Width: 220, Align: 'Left', Cursor: 'Pointer', Ellipsis: 1});
	ibHeader.addHeader({Header: '업체명', Type: 'Text', SaveName: 'companyNm', Width: 120, Align: 'Center'});
	ibHeader.addHeader({Header: '신청자', Type: 'Text', SaveName: 'reqNm', Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '전문가', Type: 'Text', SaveName: 'expertNm', Width: 80, Align: 'Center'});
	ibHeader.addHeader({Header: '신청일자', Type: 'Text', SaveName: 'creDate', Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '예약/답변일', Type: 'Text', SaveName: 'rsrvDate', Width: 100, Align: 'Center', Format: 'yyyy-MM-dd'});
	ibHeader.addHeader({Header: '예약시간', Type: 'Text', SaveName: 'rsrvTime', Width: 80, Align: 'Center', Format: 'HH:mm'});
	ibHeader.addHeader({Header: '상태', Type: 'Text', SaveName: 'statusNm', Width: 120, Align: 'Center'});
		
	ibHeader.addHeader({Header: 'prvtConsultId', Type: 'Text', SaveName: 'prvtConsultId', Width: 0, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: 'pblcConsultId', Type: 'Text', SaveName: 'pblcConsultId', Width: 0, Align: 'Center', Hidden: true});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});
	
	// 엑셀다운로드 가능(조회 후 가능)
	var isSearch = false;
	$(document).ready(function() {
		$('#searchConsultChannel,#searchReqNm,#searchConsultText,#searchExpertNm,#searchDateType,#searchFromDate').on('change', function() {
			isSearch = false;
		});
		
		$('#searchToDate,#searchPrvtStatusCd,#searchPblcStatusCd,#searchConsultTypeCd,#searchMemberCheck').on('change', function() {
			isSearch = false;
		});
		
		/*
		var container = $('#consultList')[0];
		createIBSheet2(container, 'consultListSheet', '100%', '100%');
		ibHeader.initSheet('consultListSheet');
		// 편집모드 OFF
		consultListSheet.SetEditable(0);
		*/
		
		// 시작일 선택 이벤트
		datepickerById('searchFromDate', fromDateSelectEvent);
		
		// 종료일 선택 이벤트
		datepickerById('searchToDate', toDateSelectEvent);
		
		// getList();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchFromDate').val());
		
		if ($('#searchToDate').val() != '') {
			if (startymd > Date.parse($('#searchToDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchFromDate').val('');
				
				return;
			}
		}
	}
	
	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchToDate').val());
		
		if ($('#searchFromDate').val() != '') {
			if (endymd < Date.parse($('#searchFromDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchToDate').val('');
				
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
	
	function getList() {
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectConsultList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				searchConsultChannel : $('#searchConsultChannel').val()
				, searchReqNm : $('#searchReqNm').val()
				, searchConsultText : $('#searchConsultText').val()
				, searchExpertNm : $('#searchExpertNm').val()
				, searchDateType : $('#searchDateType').val()
				, searchFromDate : $('#searchFromDate').val().replace(/-/gi, '')
				, searchToDate : $('#searchToDate').val().replace(/-/gi, '')
				, searchPrvtStatusCd : $('#searchPrvtStatusCd').val()
				, searchPblcStatusCd : $('#searchPblcStatusCd').val()
				, searchConsultTypeCd : $('#searchConsultTypeCd').val()
				, searchMemberCheck : $('#searchMemberCheck').val()
				, pageIndex : $('#pageIndex').val()
				, pageUnit : $('select[name="pageUnit"] option:selected').val()
			}
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
				
				isSearch = true;
			}
		});
	}

	function consultListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('consultListSheet_OnSearchEnd : ', msg);
		} else {
			// 제목 링크에 볼드 처리
			consultListSheet.SetColFontBold('consultText', 1);
		}
	}
	
	// 상세화면
 	function consultListSheet_OnClick(Row, Col, Value) {
		if (Row > 0) {
			if (consultListSheet.ColSaveName(Col) == 'consultText') {
				var rowData = consultListSheet.GetRowData(Row);
				
				goView(rowData);
			}	
		}
	};
	
	function goView(jsonInfo) {
		if (jsonInfo['prvtConsultId'] != '') {
			var prvtConsultId = jsonInfo['prvtConsultId'];
			
			// 1:1 상담
			openPrvtPopup(prvtConsultId);
		} else {
			var pblcConsultId = jsonInfo['pblcConsultId'];
			
			// 오픈 상담
			openPblcPopup(pblcConsultId);
		}
	}
	
	// 1:1 상담
	function openPrvtPopup(prvtConsultId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPrvtConsultRatingPopup.do" />'
			, params : {
				prvtConsultId : prvtConsultId
			}
			, callbackFunction : function(resultObj){
				getList();
			}
		});
    }
	
	// 오픈 상담
	function openPblcPopup(pblcConsultId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPblcConsultRatingPopup.do" />'
			, params : {
				pblcConsultId : pblcConsultId
			}
		});
    }
	
	// 엑셀다운로드
	function doDownloadExcel() {
		if (!isSearch) {
			alert('데이터 조회 후 엑셀다운로드가 가능합니다.');
			
			return;
		}
		
		var f = document.excelForm;
		f.action = '<c:url value="/tradeSOS/exp/selectConsultExcelList.do" />';
		f.target = '_self';
		f.submit();
	}
</script>