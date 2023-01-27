<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!-- 화상상담 전송 데이터 값 처리(encode64)  -->
<script src="https://asp.4nb.co.kr/kita/_api/js/util.js"></script>
<form id="consultForm" name="consultForm" method="get" onsubmit="return false;">
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
				<th scope="row">상담예약일자</th>
				<td colspan="3">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchFromDate" name="searchFromDate" value="" class="txt datepicker" style="min-width: 125px;" placeholder="상담예약 시작일자" title="상담예약 시작일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('searchFromDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchToDate" name="searchToDate" value="" class="txt datepicker" style="min-width: 125px;" placeholder="상담예약 종료일자" title="상담예약 종료일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('searchToDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
				</td>
            </tr>
            <tr>
				<th scope="row">제목</th>
				<td>
					<input type="text" id="searchConsultText" name="searchConsultText" value="" onkeydown="onEnter(doSearch);" class="form_text w100p" />	
				</td>
				<th scope="row">상태</th>
				<td>
					<select id="searchStatusCd" name="searchStatusCd" class="form_select">
						<option value="">선택</option>
						<c:forEach var="list" items="${statusCdList}" varStatus="status">
							<option value="${list.cdId}">${list.cdNm}</option>
						</c:forEach>
					</select>
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
<form id="aiConsultForm" action="<c:url value="/tradeSOS/com/aiConsultServiceList.do" />" method="post" target="_blank">
<input type="hidden" name="apiCallYn" value="Y" />
<input type="hidden" id="reqContents" name="reqContents" />
</form>
<form id="videoOfficeForm" name="videoOfficeForm" action="${linkUrl}" method="post">
<input type="hidden" id="apiAuthCode" name="apiAuthCode" />
<input type="hidden" id="companyCode" name="companyCode" />
<input type="hidden" id="roomId" name="roomId" />
<input type="hidden" id="userId" name="userId" />
<input type="hidden" id="userName" name="userName" />
<!-- 1 = 진행자 / 0 = 참여자 -->
<input type="hidden" id="userLevel" name="userLevel" value="1" />
<input type="hidden" id="userDeptName" name="userDeptName" />
<input type="hidden" id="userPosName" name="userPosName" />
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: 'No', Type: 'Number', SaveName: 'pageSeq', Width: 50, Align: 'Center'});
	ibHeader.addHeader({Header: '예약일', Type: 'Text', SaveName: 'rsrvDate', Width: 80, Align: 'Center', Format: 'yyyy-MM-dd'});
	ibHeader.addHeader({Header: '예약시간', Type: 'Text', SaveName: 'rsrvTime', Width: 60, Align: 'Center', Format: 'HH:mm'});
	ibHeader.addHeader({Header: '분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '제목', Type: 'Text', SaveName: 'consultText', Width: 220, Align: 'Left', Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '작성자', Type: 'Text', SaveName: 'reqNm', Width: 80, Align: 'Center'});
	ibHeader.addHeader({Header: '신청일자', Type: 'Text', SaveName: 'creDate', Width: 80, Align: 'Center'});
	ibHeader.addHeader({Header: '상태', Type: 'Text', SaveName: 'statusNm', Width: 80, Align: 'Center'});
	ibHeader.addHeader({Header: '일지', Type: 'Text', SaveName: 'historyLog', Width: 70, Align: 'Center', Cursor: 'Pointer'});
	
	ibHeader.addHeader({Header: '상담아이디', Type: 'Text', SaveName: 'prvtConsultId', Width: 0, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '상태', Type: 'Text', SaveName: 'statusCd', Width: 0, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '취소사유', Type: 'Text', SaveName: 'cancelReason', Width: 0, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '취소사유', Type: 'Text', SaveName: 'consultChannelNm', Width: 0, Align: 'Center', Hidden: true});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	$(document).ready(function() {
		var container = $('#consultList')[0];
		createIBSheet2(container, 'consultListSheet', '100%', '100%');
		ibHeader.initSheet('consultListSheet');
		consultListSheet.SetSelectionMode(4);
		
		// 편집모드 OFF
		consultListSheet.SetEditable(0);
		
		// 시작일 선택 이벤트
		datepickerById('searchFromDate', fromDateSelectEvent);
		
		// 종료일 선택 이벤트
		datepickerById('searchToDate', toDateSelectEvent);
		
		getList();
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
			url : '<c:url value="/tradeSOS/exp/selectPrvtConsultList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				rsrvDateFrom : $('#searchFromDate').val().replace(/-/gi, '')
				, rsrvDateTo : $('#searchToDate').val().replace(/-/gi, '')
				, consultText : $('#searchConsultText').val()
				, statusCd : $('#searchStatusCd').val()
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
			}
		});
	}

	function consultListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('consultListSheet', row);
	}
	
	function consultListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('penaltyListSheet_OnSearchEnd : ', msg);
		} else {
			// 제목 링크에 볼드 처리
			consultListSheet.SetColFontBold('consultText', 1);
			// 일지 링크에 볼드 처리
			consultListSheet.SetColFontBold('historyLog', 1);
		}
	}
	
	// 상세 화면
 	function consultListSheet_OnClick(Row, Col, Value) {
 		if (Row > 0) {
			if (consultListSheet.ColSaveName(Col) == 'consultText') {
				var prvtConsultId = consultListSheet.GetCellValue(Row, 'prvtConsultId');
				var statusCd = consultListSheet.GetCellValue(Row, 'statusCd');
				
				goView(prvtConsultId, statusCd);
			} else if (consultListSheet.ColSaveName(Col) == 'historyLog') {
				var prvtConsultId = consultListSheet.GetCellValue(Row, 'prvtConsultId');
				
				if (consultListSheet.GetCellValue(Row, 'historyLog') == '취소사유') {
					openPrvtCancelPopup(prvtConsultId);
				} else {
					openPrvtConsultLogPopup(prvtConsultId);
				}
			}
		}
	}
	
 	function openPrvtCancelPopup(consultId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPrvtCancelPopup.do" />'
			, params : {
				prvtConsultId : consultId
			}
			, callbackFunction : function(resultObj){
				closeLayerPopup();
				closeLayerPopup();
				
				getList();
			}
		});
    }
 	
 	function openPrvtConsultLogPopup(prvtConsultId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPrvtConsultLogPopup.do" />'
			, params : {
				prvtConsultId : prvtConsultId
			}
			, callbackFunction : function(resultObj){
				closeLayerPopup();
				closeLayerPopup();
				
				getList();
			}
		});
    }
	
	function goView(prvtConsultId, statusCd) {
		if (statusCd == '04') {
			openPrvtPopup(prvtConsultId);
		} else {
			openPrvtConsultRequestPopup(prvtConsultId);
		}
	}
	
	function openPrvtPopup(prvtConsultId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPrvtConsultRatingPopup.do" />'
			, params : {
				prvtConsultId : prvtConsultId
			}
		});
    }
	
	function openPrvtConsultRequestPopup(prvtConsultId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPrvtConsultRequestPopup.do" />'
			, params : {
				prvtConsultId : prvtConsultId
			}
			, callbackFunction : function(resultObj){
				closeLayerPopup();
				
				openPrvtConsultRequestPopup(prvtConsultId);
				
				getList();
			}
		});
    }
	
	// 채팅 상담 시스템 접속
	function enterChatConsult() {
		window.open('${siteUrl}');
	}
	
	function doSearchAiConsult(reqContents) {
		$('#reqContents').val(reqContents);
		$('#aiConsultForm').submit();
	}
	
	function enterVideoOffice(roomId) {
		$('#roomId').val(roomId);
		$('#apiAuthCode').val(encode64Han('${apiAuthCode}'));
		$('#companyCode').val(encode64Han('${companyCode}'));
		$('#userId').val(encode64Han('${user.id}'));
		$('#userName').val(encode64Han('${user.memberNm}'));
		$('#videoOfficeForm').attr('target', '_blank');
		$('#videoOfficeForm').submit();
	}
	
	function encode64Han(str) {
		if (str != '') {
			return encode64(escape(str));
		} else {
			return ''
		}
	}
	
	function setDefaultPickerValue(objId) {
		$('#' + objId).val('');
	}
</script>