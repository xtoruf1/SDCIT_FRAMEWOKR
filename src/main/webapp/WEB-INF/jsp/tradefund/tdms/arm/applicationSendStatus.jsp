<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value=""/>
<input type="hidden" id="statusChk" name="statusChk" value=""/>
<input type="text" id="displayNone" name="displayNone" style="display:none;"/>
<input type="hidden" id="svrId" name="svrId" value=""/>
<input type="hidden" id="applySeq" name="applySeq" value=""/>
<input type="hidden" id="readYn" name="readYn" value="Y"/>
<input type="hidden" id="listPage" name="listPage" value="/tdms/arm/applicationSendStatus.do"/>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doExcel();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="initForm();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="getList();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="cont_block">
	<div class="foldingTable fold">
		<div class="foldingTable_inner">
			<table class="formTable">
				<colgroup>
					<col style="width:15%;" />
					<col />
					<col style="width:15%;" />
					<col />
					<col style="width:15%;" />
					<col />
				</colgroup>
				<tr>
					<th>포상명</th>
					<td>
						<span class="form_search">
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>"/>
							<input type="text" id="searchBsnNm" name="searchBsnNm" class="form_text" value="<c:out value="${searchBsnNm}"/>" style="font-size:14px;" readonly>
							<button type="button" onclick="openLayerDlgSearchAwardPop();" class="btn_icon btn_search" title="포상검색"></button>
						</span>
					</td>
					<th>발송 요청일자</th>				<!-- asis부터 DB에 해당 조회에 대한 컬럼 데이터가 null인데 조회 조건이 왜 달려있는지 모르겠으나 화면 그대로 구현함 -->
					<td colspan="3">
						<div class="group_datepicker">
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="searchSendSt" name="searchSendSt" value="<c:out value="${searchSendSt}"/>" class="txt datepicker" placeholder="시작일" title="시작일" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyStartDate" value="" />
								</span>
								<button type="button" onclick="clearPickerValue('searchSendSt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
							<div class="spacing">~</div>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="searchSendEd" name="searchSendEd" value="<c:out value="${searchSendEd}"/>" class="txt datepicker" placeholder="종료일" title="종료일" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyEndDate" value="" />
								</span>
								<button type="button" onclick="clearPickerValue('searchSendEd');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<th>회사명</th>
					<td>
						<input type="text" class="form_text" id="searchCoNmKr" name="searchCoNmKr" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
					<th>구분</th>
					<td colspan="3">
						<select class="form_select" id="searchSendType" name="searchSendType">
							<option value="">전체</option>
							<c:forEach items="${com016Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
<div class="cont_block">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div style="width: 100%;">
		<div id="listSheet" class="sheet"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		// 시작일 선택 이벤트
		datepickerById('searchSendSt', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('searchSendEd', toDateSelectEvent);
		setSheetHeader_applicationSendStatusSheet();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchSendSt').val());
		if ($('#searchSendEd').val() != '') {
			if (startymd > Date.parse($('#searchSendEd').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchSendSt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchSendEd').val());

		if ($('#searchSendSt').val() != '') {
			if (endymd < Date.parse($('#searchSendSt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchSendEd').val('');

				return;
			}
		}
	}

	// Sheet의 초기화 작업
	function setSheetHeader_applicationSendStatusSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",		Type:"Seq",       Hidden:0, Width:30,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"",			Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"chk" });
        ibHeader.addHeader({Header:"포상명",		Type:"Text",      Hidden:0, Width:150,  Align:"Center",  SaveName:"bsnNm",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"SEND_SEQ",	Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"sendSeq",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"시스템키1",	Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"useAtt1",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"시스템키2",	Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"useAtt2",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"회사명",		Type:"Text",      Hidden:0, Width:250,  Align:"Left",    SaveName:"coNmKr",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호",	Type:"Text",      Hidden:0, Width:100,  Align:"Left",    SaveName:"memberId",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수신자",		Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"userNm",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"구분",		Type:"Combo",     Hidden:0, Width:80,   Align:"Center",  SaveName:"sendType",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${com016Sheet.detailcd}' , ComboText: '${com016Sheet.detailnm}' });
        ibHeader.addHeader({Header:"상태",		Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"stateCd",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"상태명",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"stateNm",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"발송시간",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"sendTime",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction|resize",
			DeferredVScroll: 1,
			Ellipsis: 1,
			SelectionRowsMode: 1,
			SearchMode: 4,
			NoFocusMode : 0,
			Alternate : 0,
			Page: 10,
			SizeMode: 4,
			MergeSheet: msHeaderOnly
		});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		var container = $('#listSheet')[0];
		createIBSheet2(container, 'listSheet', '100%', '429px');
		ibHeader.initSheet('listSheet');

		listSheet.SetEllipsis(1); 				// 말줄임 표시여부
		listSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		listSheet.SetEditable(1);
		listSheet.SetVisible(1);

		getList();
	}

	// 목록 가져오기
	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/arm/selectApplicationSendStatusList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				listSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	/**
	 * 포상 검색(팝업)
	 */
	function openLayerDlgSearchAwardPop(){

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/dlgSearchAwardPopup.do" />'

			, callbackFunction : function(resultObj) {
				$('#searchSvrId').val(resultObj.svrId);
				$('#searchBsnNm').val(resultObj.bsnNm);
				$('#bsnAplDt').val(resultObj.bsnAplDt);
				getList();
			}
		});

	}

	function doExcel() {
		downloadIbSheetExcel(listSheet, '전송결과조회_리스트', '');
	}

	function initForm() {
		clearForm('foldingTable_inner');
		$('#searchSendSt').val('<c:out value="${searchSendSt}"/>');
		$('#searchSendEd').val('<c:out value="${searchSendEd}"/>');
	}
</script>