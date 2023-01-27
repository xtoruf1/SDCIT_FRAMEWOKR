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
<input type="hidden" id="applySeq" name="applySeq"/>
<input type="hidden" id="readYn" name="readYn" value="Y"/>
<input type="hidden" id="listPage" name="listPage" value="/tdms/asm/tradeDaySearchByMTICode.do"/>
<input type="hidden" id="bsnAplDt" name="bsnAplDt" value="<c:out value="${bsnAplDt}"/>"/>
<input type="hidden" id="priType" name="priType"/>
<input type="hidden" id="priTypeNm" name="priTypeNm" value=""/>
<input type="hidden" id="memberId" name="memberId"/>
<input type="hidden" id="proxyYn" name="proxyYn"/>
<input type="hidden" id="editYn" name="editYn" value="N"/>

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
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>"/>
							<input type="text" id="searchBsnNm" name="searchBsnNm" class="form_text" value="<c:out value="${searchBsnNm}"/>" style="font-size:14px;" readonly>
							<button type="button" onclick="openLayerDlgSearchAwardPop();" class="btn_icon btn_search" title="포상검색"></button>
						</span>
					</td>
					<th>회사명</th>
					<td>
						<input type="text" class="form_text" id="searchCoNmKr" name="searchCoNmKr" onkeydown="onEnter(getList);" maxlength="70"/>
					</td>
					<th>서비스업 여부</th>
					<td>
						<label class="label_form">
							<input type="checkbox" class="form_checkbox" name="searchServiceYn" id="searchServiceYn" value="Y">
							<span class="label"></span>
						</label>
					</td>
				</tr>
				<tr>
					<th>성별</th>
					<td>
						<select class="form_select" id="searchSex" name="searchSex">
							<option value="">전체</option>
							<c:forEach items="${awd021Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>포상구분</th>
					<td>
						<select class="form_select" id="searchPriType" name="searchPriType">
							<option value="">전체</option>
							<c:forEach items="${awd001Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>업체구분</th>
					<td>
						<select class="form_select" id="searchScale" name="searchScale">
							<option value="">전체</option>
							<c:forEach items="${awd007Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>

				</tr>
				<tr>
					<th>지역구분</th>
					<td colspan="5">
						<select class="form_select" id="searchTradeDept" name="searchTradeDept">
							<c:if test="${deptAllYn eq 'Y'}">
								<option value="">전체</option>
							</c:if>
							<c:forEach items="${com001Select}" var="list" varStatus="status">
								<option value="${list.chgCode03}">${list.detailsortnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>품목구분</th>
					<td colspan="5">
						<select class="form_select" id="searchMtiLv1" name="searchMtiLv1">
							<option value="">전체</option>
						</select>
						<select class="form_select" id="searchMtiLv2" name="searchMtiLv2">
							<option value="">전체</option>
						</select>
						<select class="form_select" id="searchMtiLv3" name="searchMtiLv3">
							<option value="">전체</option>
						</select>
						<select class="form_select" id="searchMtiLv4" name="searchMtiLv4" style="width:350px;">
							<option value="">전체</option>
						</select>
					</td>
				</tr>
			</table>
		</div>
		<button type="button" class="btn_folding" title="테이블접기"></button>
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
		var com001 = '${com001Sheet.chgCode03}';
		var rtnObj = commonGetMtiCodeList({event:'mtiLv1'});
		commonSetMtiCodeComboBox('searchMtiLv1', rtnObj.mtiCdList);
		setSheetHeader_tradeDaySearchByBTICodeSheet();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_tradeDaySearchByBTICodeSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

		ibHeader.addHeader({Header:"No",		Type:"Seq",       Hidden:0, Width:60,   Align:"Center",  SaveName:"no" });
		ibHeader.addHeader({Header:"",			Type:"Text",	  Hidden:1, Width:60,   Align:"Center",  SaveName:"chk" });
        ibHeader.addHeader({Header:"포상ID",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"svrId",            CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",	Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"applySeq",         CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"Level1",	Type:"Text",      Hidden:0, Width:130,   Align:"Left",    SaveName:"korName1",         CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"Level2",	Type:"Text",      Hidden:0, Width:130,   Align:"Left",    SaveName:"korName2",         CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"Level3",	Type:"Text",      Hidden:0, Width:130,  Align:"Left",    SaveName:"korName3",         CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"Level4",	Type:"Text",      Hidden:0, Width:130,  Align:"Left",    SaveName:"korName4",         CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체명",		Type:"Text",      Hidden:0, Width:160,  Align:"Left",    SaveName:"coNmKr",           CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Cursor:"Pointer" });
        ibHeader.addHeader({Header:"무역업번호",	Type:"Text",      Hidden:0, Width:110,   Align:"Center",  SaveName:"memberId",         CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상구분",		Type:"Combo",     Hidden:0, Width:150,  Align:"Left",    SaveName:"priType",          CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}' });
        ibHeader.addHeader({Header:"업체구분",		Type:"Combo",     Hidden:0, Width:100,   Align:"Center",  SaveName:"scale",            CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd007Sheet.detailcd}' , ComboText: '${awd007Sheet.detailnm}' });
        ibHeader.addHeader({Header:"지역",		Type:"Combo",     Hidden:0, Width:100,  Align:"Center",  SaveName:"tradeDept",        CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${com001Sheet.chgCode03}' , ComboText: '${com001Sheet.detailsortnm}' });
        ibHeader.addHeader({Header:"품목코드1",	Type:"Text",      Hidden:1, Width:170,  Align:"Left",    SaveName:"expItemMticode1",  CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"품목1",		Type:"Text",      Hidden:0, Width:170,  Align:"Left",    SaveName:"expItemMtiname1",  CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"품목코드2",	Type:"Text",      Hidden:1, Width:170,  Align:"Left",    SaveName:"expItemMticode2",  CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"품목2",		Type:"Text",      Hidden:0, Width:170,  Align:"Left",    SaveName:"expItemMtiname2",  CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction",
			DeferredVScroll: 1,
			Ellipsis: 1,
			SelectionRowsMode: 1,
			SearchMode: 2,
			NoFocusMode : 0,
			Alternate : 0,
			Page: 10,
			SizeMode: 4,
			MergeSheet: msHeaderOnly,
			UseHeaderSortCancel: 1,
			MaxSort: 1
		});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true, HeaderCheck: 0});

		var container = $('#listSheet')[0];
		createIBSheet2(container, 'listSheet', '100%', '412px');
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

	function listSheet_OnSearchEnd() {
		listSheet.SetColFontBold('coNmKr', 1);
		listSheet.SetColFontBold('userNmKor', 1);
	}

	// 목록 가져오기
	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDaySearchByMTICodeList.do"
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

	// 상세 페이지 & 팝업
	function listSheet_OnDblClick(Row, Col, Value) {

		if(listSheet.ColSaveName(Col) == 'coNmKr' && Row > 0) {
			var rowData = listSheet.GetRowData(Row);
			goApplication(Row);
		}

	}

	function goApplication(Row) {
		$('#svrId').val(listSheet.GetCellValue(Row, 'svrId'));
		$('#memberId').val(listSheet.GetCellValue(Row, 'memberId'));
		$('#applySeq').val(listSheet.GetCellValue(Row, 'applySeq'));
		$('#editYn').val('N');

		// 로딩이미지 시작
		$('#loading_image').show();

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDaySelectionPopup.do"/>',
			params : $('#searchForm').serializeObject()
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
        downloadIbSheetExcel(listSheet, '품목별업체현황_리스트', '');
	}

	function doWord(svrId, applySeq, memberId, prvPriType, priType, coNmKr, userNmKor, scale, prvPriTypeNm) {

		var jsonParams = {
			event:'WORD',
			svrId:svrId,
			applySeq:applySeq,
			memberId:memberId,
			prvPriType:prvPriType,
			coNmKr:coNmKr,
			userNmKor:userNmKor,
			scale:scale,
			prvPriType:prvPriTypeNm
		}

		if(priType == 'A') {
			jsonParams.reportGB1 = 'Y';	//수출업체종사자 포상신청서(A)
			jsonParams.reportGB2 = 'Y';	//공적조서
			jsonParams.reportGB3 = 'Y';	//이력서
			jsonParams.reportGB4 = '';	// 수출의 탑 신청서(B)
		}else if(priType == 'T') {
			jsonParams.reportGB1 = '';	//수출업체종사자 포상신청서(A)
			jsonParams.reportGB2 = '';	//공적조서
			jsonParams.reportGB3 = 'Y';	//이력서
			jsonParams.reportGB4 = 'Y';	//수출의 탑 신청서(B)
		}else if(priType == 'P') {
			jsonParams.reportGB1 = 'Y';	//수출업체종사자 포상신청서(A)
			jsonParams.reportGB2 = 'Y';	//공적조서
			jsonParams.reportGB3 = 'Y';	//이력서
			jsonParams.reportGB4 = '';
		}else if(priType == 'S') {
			jsonParams.reportGB1 = '';	//수출업체종사자 포상신청서(A)
			jsonParams.reportGB2 = 'Y';	//공적조서
			jsonParams.reportGB3 = 'Y';	//이력서
			jsonParams.reportGB4 = '';	//수출의탑 신청서(B)
		}else if(priType == 'G') {
			alert('출력 없음.');
			return false;
		}

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdas/report/tradeDayInquiryPrintWord.do"/>',
			params : jsonParams

			, callbackFunction : function(resultObj) {

			}
		});

	}

	$('#searchMtiLv1, #searchMtiLv2, #searchMtiLv3, #searchMtiLv4').on('change', function() {

		var selId = $(this).attr('id');
		var event;
		var searchMtiLv1;
		var searchMtiLv2;
		var searchMtiLv3;
		var targetId;
		var defaultOpt = '<option value="">전체</option>';

		if(selId == 'searchMtiLv1') {
			event = 'mtiLv2';
			searchMtiLv1 = $(this).val();
			targetId = 'searchMtiLv2';
			$('#searchMtiLv3, #searchMtiLv4').empty();
			$('#searchMtiLv3, #searchMtiLv4').append(defaultOpt);
		}else if(selId == 'searchMtiLv2') {
			event = 'mtiLv3';
			searchMtiLv2 = $(this).val();
			targetId = 'searchMtiLv3';
			$('#searchMtiLv4').empty();
			$('#searchMtiLv4').append(defaultOpt);
		}else  if(selId == 'searchMtiLv3') {
			event = 'mtiLv4';
			searchMtiLv3 = $(this).val();
			targetId = 'searchMtiLv4';
		}else  if(selId == 'searchMtiLv4') {
			getList();
			return false;
		}

		var param = {
			event:event,
			searchMtiLv1:searchMtiLv1,
			searchMtiLv2:searchMtiLv2,
			searchMtiLv3:searchMtiLv3
		}
		var rtnObj = commonGetMtiCodeList(param);
		commonSetMtiCodeComboBox(targetId, rtnObj.mtiCdList);
	});

</script>