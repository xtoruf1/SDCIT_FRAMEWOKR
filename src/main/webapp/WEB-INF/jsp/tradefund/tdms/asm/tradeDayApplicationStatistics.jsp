<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value="" />
<input type="hidden" id="statusChk" name="statusChk" value="" />
<input type="hidden" id="svrId" name="svrId" value="" />
<input type="hidden" id="applySeq" name="applySeq" value="" />
<input type="hidden" id="readYn" name="readYn" value="Y" />
<input type="hidden" id="listPage" name="listPage" value="/tdms/asm/tradeDayApplicationStatistics.do" />
<input type="hidden" id="bsnAplDt" name="bsnAplDt" value="<c:out value="${bsnAplDt}" />" />
<input type="hidden" id="priType" name="priType" value="" />
<input type="hidden" id="priTypeNm" name="priTypeNm" value="" />
<input type="hidden" id="memberId" name="memberId" value="<c:out value="${memberId}" />" />
<input type="hidden" id="proxyYn" name="proxyYn" value="Y" />
<input type="hidden" id="tempFileId" name="tempFileId" value="" />
<input type="hidden" id="appEditYn" name="appEditYn" value="Y" />
<input type="hidden" id="receiptNo" name="receiptNo" value="<c:out value="${receiptNo}" />" />
<input type="text" id="displayNone" name="displayNone" style="display: none;" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doExcel();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="clearForm('foldingTable_inner');" class="btn_sm btn_secondary">초기화</button>
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
							<input type="text" id="searchBsnNm" name="searchBsnNm" class="form_text" value="<c:out value="${searchBsnNm}"/>" style="font-size: 14px;" readonly="readonly" />
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}" />" />
							<button type="button" class="btn_icon btn_search" onclick="openLayerDlgSearchAwardPop();" title="포상검색"></button>
						</span>
					</td>
					<th>회사명</th>
					<td>
						<input type="text" id="searchCoNmKr" name="searchCoNmKr" onkeydown="onEnter(getList);" maxlength="30" class="form_text" />
					</td>
					<th>무역업번호</th>
					<td>
						<input type="text" id="searchMemberId" name="searchMemberId" onkeydown="onEnter(getList);return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="8" class="form_text" />
					</td>
				</tr>
				<tr>
					<th>사업자번호</th>
					<td>
						<input type="text" id="searchBsNo" name="searchBsNo" onkeydown="onEnter(getList);return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="10" class="form_text" />
					</td>
					<th>포상구분</th>
					<td>
						<select class="form_select" id="searchPriType" name="searchPriType">
							<option value="">전체</option>
							<c:forEach var="list" items="${awd001Select}" varStatus="status">
								<option value="<c:out value="${list.detailcd}" />"><c:out value="${list.detailnm}" /></option>
							</c:forEach>
						</select>
					</td>
					<th>대상자</th>
					<td>
						<input type="text" id="searchUserNmKor" name="searchUserNmKor" value="" onkeydown="onEnter(getList);" maxlength="30" class="form_text" />
					</td>
				</tr>
				<tr>
					<th>업체구분</th>
					<td>
						<select class="form_select" id="searchScale" name="searchScale">
							<option value="">전체</option>
							<c:forEach var="list" items="${awd007Select}" varStatus="status">
								<option value="<c:out value="${list.detailcd}" />"><c:out value="${list.detailnm}" /></option>
							</c:forEach>
						</select>
					</td>
					<th>지역구분</th>
					<td>
						<select id="searchTradeDept" name="searchTradeDept" class="form_select">
							<c:if test="${deptAllYn eq 'Y'}">
								<option value="">전체</option>
							</c:if>
							<c:forEach var="list" items="${com001Select}" varStatus="status">
								<option value="<c:out value="${list.chgCode03}" />"><c:out value="${list.detailsortnm}" /></option>
							</c:forEach>
						</select>
					</td>
					<th>포상종류</th>
					<td>
						<select id="searchPrvPriType" name="searchPrvPriType" class="form_select">
							<option value="">전체</option>
							<c:forEach var="list" items="${awd024Select}" varStatus="status">
								<option value="<c:out value="${list.detailcd}" />"><c:out value="${list.detailnm}" /></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>제조업유무</th>
					<td>
						<select id="searchJejoupYn" name="searchJejoupYn" class="form_select">
							<option value="">전체</option>
							<option value="Y">예</option>
							<option value="N">아니오</option>
						</select>
					</td>
					<th>서비스업여부</th>
					<td>
						<select id="searchServiceYn" name="searchServiceYn" class="form_select">
							<option value="">전체</option>
							<option value="Y">예</option>
							<option value="N">아니오</option>
						</select>
					</td>
					<th>선정여부</th>
					<td>
						<select id="searchKongSt" name="searchKongSt" class="form_select">
							<option value="">전체</option>
							<c:forEach var="list" items="${kongStSelect}" varStatus="status">
								<option value="<c:out value="${list.codeCd}" />"><c:out value="${list.codeNm}" /></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>추천부분</th>
					<td colspan="3">
						<select id="searchSpRecKind" name="searchSpRecKind" class="form_select" style="width: 500px;">
							<option value="">전체</option>
							<c:forEach var="list" items="${spe000Select}" varStatus="status">
								<option value="<c:out value="${list.detailcd}" />"><c:out value="${list.detailnm}" /></option>
							</c:forEach>
						</select>
					</td>
					<th>추천기관</th>
					<td>
						<input type="text" id="searchSpRecOrg" name="searchSpRecOrg" value="" onkeydown="onEnter(getList);" maxlength="30" class="form_text" />
					</td>
				</tr>
			</table>
		</div>
		<button type="button" class="btn_folding" title="테이블접기"></button>
	</div>
</div>
<div class="cont_block" style="margin-top: 30px !important;">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div style="width: 100%;">
		<div id="listSheet" class="sheet"></div>
	</div>
</div>
</form>
<form id="wordForm" name="wordForm" method="post">
<input type="hidden" name="svrId" value="" />
<input type="hidden" name="applySeq" value="" />
<input type="hidden" name="memberId" value="" />
<input type="hidden" name="prvPriType" value="" />
<input type="hidden" name="priType" value="" />
<input type="hidden" name="coNmKr" value="" />
<input type="hidden" name="userNmKor" value="" />
<input type="hidden" name="scale" value="" />
<input type="hidden" name="prvPriTypeNm" value="" />
<input type="hidden" name="event" value="" />
<input type="hidden" name="reportGb1" value="" />
<input type="hidden" name="reportGb2" value="" />
<input type="hidden" name="reportGb3" value="" />
<input type="hidden" name="reportGb4" value="" />
</form>
<script type="text/javascript">
	$(document).ready(function(){
		setSheetHeader_tradeDayApplicationStatisticsSheet();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_tradeDayApplicationStatisticsSheet() {
		var	ibHeader = new IBHeader();
		var initSheet = {};

		ibHeader.addHeader({Header:"No",		Type:"Seq",       Hidden:0, Width:60,   Align:"Center",  SaveName:"no" });
		ibHeader.addHeader({Header:"",			Type:"Text",	  Hidden:1, Width:60,   Align:"Center",  SaveName:"chk" });
		ibHeader.addHeader({Header:"포상ID",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"svrId",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"포상신청ID",	Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"applySeq",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"접수번호",		Type:"Text",      Hidden:1, Width:80,   Align:"Center",  SaveName:"receipt_no",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"지역",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"tradeDept",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"포상년도",		Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"regYear",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"신청일자",		Type:"Text",      Hidden:1, Width:80,   Align:"Center",  SaveName:"reqDate",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"업체명",		Type:"Text",      Hidden:0, Width:200,  Align:"Left",    SaveName:"coNmKr",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Cursor: 'Pointer' });
		ibHeader.addHeader({Header:"업체명_영문",	Type:"Text",      Hidden:1, Width:100,  Align:"Left",  SaveName:"coNmEn",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"사업자등록번호",	Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"bsNo",          CalcLogic:"",   Format:"SaupNo",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"무역업번호",	Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"memberId",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"대상자",		Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"userNmKor",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Cursor: 'Pointer' });
		ibHeader.addHeader({Header:"포상구분",		Type:"Combo",     Hidden:0, Width:120,  Align:"Left",    SaveName:"priType",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}' });
		ibHeader.addHeader({Header:"포상종류",		Type:"Combo",     Hidden:0, Width:70,   Align:"Center",  SaveName:"prvPriType",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd002Sheet.detailcd}' , ComboText: '${awd002Sheet.detailnm}' });
		ibHeader.addHeader({Header:"신청탑",		Type:"Text",      Hidden:1, Width:70,   Align:"Center",    SaveName:"expTapPrizeCd", CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"신청탑",		Type:"Text",      Hidden:0, Width:70,   Align:"Left",    SaveName:"expTapPrizeNm", CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"업체구분",		Type:"Combo",     Hidden:0, Width:80,   Align:"Center",  SaveName:"scale",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd007Sheet.detailcd}' , ComboText: '${awd007Sheet.detailnm}' });
		ibHeader.addHeader({Header:"제조업여부",	Type:"Text",      Hidden:0, Width:80,   Align:"Center",    SaveName:"jejoupYn",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"서비스업여부",	Type:"Text",      Hidden:0, Width:100,  Align:"Center",    SaveName:"serviceYn",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"추천기관",		Type:"Text",      Hidden:0, Width:100,  Align:"Left",    SaveName:"spRecOrg",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"추천부문",		Type:"Combo",     Hidden:0, Width:130,  Align:"Left",    SaveName:"spRecKind",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${spe000Sheet.detailcd}' , ComboText: '${spe000Sheet.detailnm}' });
		ibHeader.addHeader({Header:"선정여부",		Type:"Text",      Hidden:0, Width:70,   Align:"Center",  SaveName:"state",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"포상코드",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"fAwardCd",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"포상명",		Type:"Text",      Hidden:0, Width:200,  Align:"Left",    SaveName:"fAwardNm",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자명",		Type:"Text",      Hidden:0, Width:80,   Align:"Center",    SaveName:"userNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자연락처",	Type:"Text",      Hidden:0, Width:100,  Align:"Center",    SaveName:"userPhone",     CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자FAX",	Type:"Text",      Hidden:0, Width:100,  Align:"Center",    SaveName:"userFax",       CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자HP",	Type:"Text",      Hidden:0, Width:100,  Align:"Center",    SaveName:"userHp",        CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자Email",	Type:"Text",      Hidden:0, Width:150,  Align:"Left",    SaveName:"userEmail",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"업체주소",		Type:"Text",      Hidden:0, Width:400,  Align:"Left",    SaveName:"coAddr",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction",
			DeferredVScroll: 1
			, Ellipsis: 1
			, SelectionRowsMode: 1
			, SearchMode: 2
			, NextPageCall : 90
			, NoFocusMode : 0
			, Alternate : 0
			, Page: 10
			, SizeMode: 4
			, MergeSheet: msNone
			, UseHeaderSortCancel: 1
			, MaxSort: 1
		});

		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true, HeaderCheck: 0});

		var container = $('#listSheet')[0];
		createIBSheet2(container, 'listSheet', '100%', '425px');
		ibHeader.initSheet('listSheet');

		listSheet.SetEllipsis(1); 				// 말줄임 표시여부
		listSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		listSheet.SetEditable(1);
		listSheet.SetVisible(1);

		getList();
	}

	function listSheet_OnSort(col, order) {
		listSheet.SetScrollTop(0);
	}

	// 목록 가져오기
	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDayApplicationStatisticsList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data) {
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				listSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function listSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('listSheet_OnSearchEnd : ', msg);
    	} else {
    		listSheet.HideProcessDlg();

    		listSheet.SetColFontBold('coNmKr', 1);
    		listSheet.SetColFontBold('userNmKor', 1);
    	}
		listSheet.ReNumberSeq('desc');
    }

	// 포상 검색(팝업)
	function openLayerDlgSearchAwardPop() {
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

	// 상세 페이지 & 팝업
	function listSheet_OnDblClick(Row, Col, Value) {
		if(Row > 0) {
			if (listSheet.ColSaveName(Col) == 'userNmKor') {
				doWord(listSheet.GetCellValue(Row, "svrId"), listSheet.GetCellValue(Row, "applySeq"), listSheet.GetCellValue(Row, "memberId"), listSheet.GetCellValue(Row, "prvPriType"), listSheet.GetCellValue(Row, "priType"), listSheet.GetCellValue(Row, "coNmKr"), listSheet.GetCellValue(Row, "userNmKor"), listSheet.GetCellText(Row, "scale"), listSheet.GetCellText(Row, "prvPriType"));
			} else if (listSheet.ColSaveName(Col) == 'coNmKr') {
				var rowData = listSheet.GetRowData(Row);

				goApplication(Row);
			}
		}
	}

	function goApplication(Row) {
		var f = document.searchForm;
		f.svrId.value = listSheet.GetCellValue(Row, 'svrId');
		f.applySeq.value = listSheet.GetCellValue(Row, 'applySeq');
		f.memberId.value = listSheet.GetCellValue(Row, 'memberId');
		f.priType.value = listSheet.GetCellValue(Row, 'priType');

		// 로딩이미지 시작
		$('#loading_image').show();

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDaySelectionPopup.do" />'
			, params : {
				svrId : f.svrId.value
				, applySeq : f.applySeq.value
				, memberId : f.memberId.value
				, priType : f.priType.value
			}
			, callbackFunction : function(resultObj) {
				var event = resultObj.event;

				// 평가 저장
				if (event == 'tradeDaySelectionSave') {
					// 레이어 닫기
					closeLayerPopup();

					// 레이어 다시 오픈
					goApplication(Row);
				}
			}
		});
	}

	function doExcel() {
        downloadIbSheetExcel(listSheet, '신청내역조회_리스트', '');
	}

	function doWord(svrId, applySeq, memberId, prvPriType, priType, coNmKr, userNmKor, scale, prvPriTypeNm) {
		$('#wordForm').each(function() {
			this.reset();
		});

		$('#wordForm input[name="svrId"]').val(svrId);
		$('#wordForm input[name="applySeq"]').val(applySeq);
		$('#wordForm input[name="memberId"]').val(memberId);
		$('#wordForm input[name="prvPriType"]').val(prvPriType);
		$('#wordForm input[name="priType"]').val(priType);
		$('#wordForm input[name="coNmKr"]').val(coNmKr);
		$('#wordForm input[name="userNmKor"]').val(userNmKor);
		$('#wordForm input[name="scale"]').val(scale);
		$('#wordForm input[name="prvPriTypeNm"]').val(prvPriTypeNm);
		$('#wordForm input[name="event"]').val('WORD');

		if (priType == 'A') {
			$('#wordForm input[name="reportGb1"]').val('Y');	// 수출업체종사자 포상신청서(A)
			$('#wordForm input[name="reportGb2"]').val('Y');	// 공 적 조 서
			$('#wordForm input[name="reportGb3"]').val('Y');	// 이력서
			$('#wordForm input[name="reportGb4"]').val('');		// 수출의 탑 신청서(B)
		} else if (priType == 'T') {
			$('#wordForm input[name="reportGb1"]').val('');		//수출업체종사자 포상신청서(A)
			$('#wordForm input[name="reportGb2"]').val('');		//공적조서
			$('#wordForm input[name="reportGb3"]').val('Y');	// 이력서
			$('#wordForm input[name="reportGb4"]').val('Y');	// 수출의 탑」 신청서(B)
		} else if (priType == 'P') {
			$('#wordForm input[name="reportGb1"]').val('Y');	// 수출업체종사자 포상신청서(A)
			$('#wordForm input[name="reportGb2"]').val('Y');	// 공 적 조 서
			$('#wordForm input[name="reportGb3"]').val('Y');	// 이력서
			$('#wordForm input[name="reportGb4"]').val('');
		} else if (priType == 'S') {
			$('#wordForm input[name="reportGb1"]').val('');		//수출업체종사자 포상신청서(A)
			$('#wordForm input[name="reportGb2"]').val('Y');	// 공 적 조 서
			$('#wordForm input[name="reportGb3"]').val('Y');	// 이력서
			$('#wordForm input[name="reportGb4"]').val('');		//수출의탑 신청서(B)
		} else if (priType == 'G') {
			alert('출력 없음');
			return false;
		}

		$('#wordForm').attr('action','/tdas/report/tradeDayInquiryPrintWord.do');
		$('#wordForm').submit();
	}
</script>