<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value="" />
<input type="hidden" id="statusChk" name="statusChk" value="" />
<input type="hidden" id="svrId" name="svrId" value="<c:out value="${svrId}"/>" />
<input type="hidden" id="applySeq" name="applySeq" value="<c:out value="${applySeq}" />" />
<input type="hidden" id="readYn" name="readYn" value="Y" />
<input type="hidden" id="listPage" name="listPage" value="/tdms/asm/tradeDaySelectionList.do" />
<input type="hidden" id="bsnAplDt" name="bsnAplDt" value="<c:out value="${bsnAplDt}" />" />
<input type="hidden" id="priType" name="priType" />
<input type="hidden" id="priTypeNm" name="priTypeNm" value="" />
<input type="hidden" id="memberId" name="memberId" />
<input type="text" id="displayNone" name="displayNone" style="display: none;" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doCal();" class="btn_sm btn_primary btn_modify_auth">점수계산</button>
	</div>
	<div class="ml-15">
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
							<input type="text" id="searchBsnNm" name="searchBsnNm" value="<c:out value="${searchBsnNm}"/>" class="form_text" style="font-size: 14px;" readonly="readonly" />
							<button type="button" onclick="openLayerDlgSearchAwardPop();" class="btn_icon btn_search" title="포상검색"></button>
						</span>
					</td>
					<th>회사명</th>
					<td>
						<input type="text" id="searchCoNmKr" name="searchCoNmKr" value="" class="form_text" onkeydown="onEnter(getList);" maxlength="30" />
					</td>
					<th>무역업번호</th>
					<td>
						<input type="text" id="searchMemberId" name="searchMemberId" value="" class="form_text" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="8" />
					</td>
				</tr>
				<tr>
					<th>접수번호</th>
					<td>
						<input type="text" id="searchReceiptNo" name="searchReceiptNo" value="" class="form_text" onkeydown="onEnter(getList);" maxlength="30" />
					</td>
					<th>사업자번호</th>
					<td>
						<input type="text" id="searchBsNo" name="searchBsNo" value="" class="form_text" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="10" />
					</td>
					<th>대표자</th>
					<td>
						<input type="text" id="searchCeoKr" name="searchCeoKr" value="" class="form_text" onkeydown="onEnter(getList);" maxlength="30" />
					</td>
				</tr>
				<tr>
					<th>업체구분</th>
					<td>
						<select id="searchScale" name="searchScale" class="form_select">
							<option value="">전체</option>
							<c:forEach var="list" items="${awd007Select}" varStatus="status">
								<option value="${list.detailcd}"><c:out value="${list.detailnm}" /></option>
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
								<option value="${list.chgCode03}"><c:out value="${list.detailsortnm}" /></option>
							</c:forEach>
						</select>
					</td>
					<th>포상구분</th>
					<td>
						<select id="searchPriType" name="searchPriType" class="form_select">
							<option value="">전체</option>
							<c:forEach var="list" items="${awd001Select}" varStatus="status">
								<option value="${list.detailcd}"><c:out value="${list.detailnm}" /></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>검토여부</th>
					<td>
						<select id="searchChkYn" name="searchChkYn" class="form_select">
							<option value="">전체</option>
							<c:forEach var="list" items="${awd010Select}" varStatus="status">
								<option value="${list.detailcd}"><c:out value="${list.chgCode01}" /></option>
							</c:forEach>
						</select>
					</td>
					<th>특이업체</th>
					<td colspan="3">
						<select id="searchSpecialYn" name="searchSpecialYn" class="form_select">
							<option value="">전체</option>
							<c:forEach var="list" items="${awd010Select}" varStatus="status">
								<option value="${list.detailcd}"><c:out value="${list.chgCode02}" /></option>
							</c:forEach>
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
		setSheetHeader_tradeDaySelectionListSheet();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_tradeDaySelectionListSheet() {
		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No|No",					Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"|",						Type:"CheckBox",  Hidden:0, Width:40,   Align:"Center",  ColMerge:1,   SaveName:"chk" });
        ibHeader.addHeader({Header:"|",						Type:"Status",    Hidden:1, Width:60,   Align:"Center",  SaveName:"status" });
        ibHeader.addHeader({Header:"포상ID|포상ID",			Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"svrId",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID|포상신청ID",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"applySeq",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호|접수번호",			Type:"Text",      Hidden:0, Width:100,  Align:"Left",    ColMerge:1,   SaveName:"receiptNm",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"본부코드|본부코드",			Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"tradeDept",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호|무역업번호",		Type:"Text",      Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"memberId",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청일자|신청일자",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"reqDate",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체명|업체명",				Type:"Text",      Hidden:0, Width:180,  Align:"Left",    ColMerge:1,   SaveName:"coNmKr",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Cursor: 'Pointer' });
        ibHeader.addHeader({Header:"업체명_영문|업체명_영문",		Type:"Text",      Hidden:1, Width:100,  Align:"Left",  ColMerge:1,   SaveName:"coNmEn",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자|대표자",				Type:"Text",      Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"ceoKr",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자_영문|대표자_영문",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"ceoEn",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체구분|업체구분",			Type:"Combo",     Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"scale",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd007Sheet.detailcd}' , ComboText: '${awd007Sheet.detailnm}' });
        ibHeader.addHeader({Header:"전화번호|전화번호",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"coPhone",        CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상구분|포상구분",			Type:"Combo",     Hidden:0, Width:120,  Align:"Left",    ColMerge:1,   SaveName:"priType",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}' });
        ibHeader.addHeader({Header:"담당자연락처|담당자연락처",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"userPhone",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_핸드폰|담당자_핸드폰",	Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"userHp",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"평가점수|수출의탑",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"stScore",        	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"평가점수|소속업체",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"sctScore",       	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"평가점수|대표자",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"scUserNm",       	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"평가점수|대표자점수",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"scScore",         	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"평가점수|사무직",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"seUserNm",       	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"평가점수|사무직점수",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"seScore",         	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"평가점수|생산직",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"swUserNm",       	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"평가점수|생산직점수",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"swScore",         	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"특이업체|여부",				Type:"Text",      Hidden:0, Width:60,   Align:"Center",  SaveName:"specialYn",       	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"특이업체|내용",				Type:"Text",      Hidden:0, Width:200,  Align:"Left",    SaveName:"specialContent",  	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1000 });
        ibHeader.addHeader({Header:"검토내용|검토",				Type:"Text",      Hidden:0, Width:60,   Align:"Center",  ColMerge:1,   SaveName:"chkYn",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"검토내용|검토내용",			Type:"Text",      Hidden:0, Width:200,  Align:"Left",    SaveName:"remark",           	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1000 });

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
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true, HeaderCheck: 1});

		var container = $('#listSheet')[0];
		createIBSheet2(container, 'listSheet', '100%', '469px');
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
	}

	// 목록 가져오기
	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDaySelectionList.do"
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
		if (listSheet.ColSaveName(Col) == 'coNmKr' && Row > 1) {
			var rowData = listSheet.GetRowData(Row);
			goApplication(Row);
		}
	}

	function goApplication(Row) {
		var f = document.searchForm;
		f.svrId.value = listSheet.GetCellValue(Row, 'svrId');
		f.applySeq.value = listSheet.GetCellValue(Row, 'applySeq');
		f.memberId.value = listSheet.GetCellValue(Row, 'memberId');
		f.statusChk.value = 'C';

		// 로딩이미지 시작
		$('#loading_image').show();

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDaySelectionPopup.do" />'
			, params : {
				svrId : f.svrId.value
				, applySeq : f.applySeq.value
				, memberId : f.memberId.value
				, statusChk : 'C'
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

	function doCal() {
		var jsonParam = $('#searchForm').serializeObject();
		var saveJson = listSheet.GetSaveJson();
		jsonParam.tradeDaySelectionList = saveJson.data;

		if (saveJson.data == '') {
			alert('선택된 것이 없습니다. 확인 후 진행 바랍니다.');
			return false;
		}

		if (confirm('계산하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tdms/asm/saveTradeDaySelectionList.do'
				, data : JSON.stringify(jsonParam)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data){
					// alert('계산완료하였습니다.');
					getList();
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}
	}

	function doExcel() {
        downloadIbSheetExcel(listSheet, '신청서평가_리스트', '');
	}
</script>