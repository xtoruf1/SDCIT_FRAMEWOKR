<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value=""/>
<input type="hidden" id="statusChk" name="statusChk" value=""/>
<input type="text" id="displayNone" name="displayNone" style="display:none;"/>
<input type="hidden" id="svrId" name="svrId"/>
<input type="hidden" id="applySeq" name="applySeq"/>
<input type="hidden" id="readYn" name="readYn" value="Y"/>
<input type="hidden" id="listPage" name="listPage" value="/tdms/asm/tradeDayLedger.do"/>
<input type="hidden" id="bsnAplDt" name="bsnAplDt" value="<c:out value="${bsnAplDt}"/>"/>
<input type="hidden" id="priType" name="priType"/>
<input type="hidden" id="priTypeNm" name="priTypeNm" value=""/>
<input type="hidden" id="memberId" name="memberId"/>
<input type="hidden" id="proxyYn" name="proxyYn" value="Y"/>
<input type="hidden" id="editYn" name="editYn" value="N"/>

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
			<table class="formTable" id="tabSearchTable">
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
							<button type="button" class="btn_icon btn_search" title="포상검색" onclick="openLayerDlgSearchAwardPop();"></button>
						</span>
					</td>
					<th scope="row" rowspan="2">원장 구분</th>
					<td colspan="3">
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchPriType" value="T" checked>
							<span class="label">수출의 탑</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchPriType" value="P">
							<span class="label">일반유공자</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchPriType" value="S">
							<span class="label">특수유공자</span>
						</label>
						<!--
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchPriType" value="G">
							<span class="label">기관표창</span>
						</label>
						-->
					</td>
				</tr>
				<tr>
					<th class="tabTr">업체구분</th>
					<td class="tabTr">
						<select class="form_select" id="searchScale" name="searchScale">
							<option value="">전체</option>
							<c:forEach items="${awd007Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th class="personTr" style="display:none;">업체구분</th>
					<td class="personTr" style="display:none;">
						<select class="form_select" id="searchScaleIl" name="searchScaleIl">
							<option value="">전체</option>
							<c:forEach items="${awd007Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th class="specialTr" style="display:none;">신청구분</th>
					<td class="specialTr" style="display:none;">
						<select class="form_select" id="searchState" name="searchState">
							<option value="">전체</option>
							<c:forEach items="${awd003Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<td colspan="3">
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchPriType2" value="TL">
							<span class="label">탑포함 기업원장</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchPriType2" value="TL2">
							<span class="label">탑포함 기업원장(신규)</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchPriType2" value="PL">
							<span class="label">개인원장</span>
						</label>
					</td>
				</tr>
				<tr class="tabTr">
					<th>여성대표</th>
					<td>
						<select class="form_select" id="'searchSex'" name="searchSex">
							<option value="">전체</option>
							<option value="M">아니오</option>
							<option value="F">예</option>
						</select>
					</td>
					<th>외국인대표</th>
					<td colspan="3">
						<select class="form_select" id="searchFromYn" name="searchFromYn">
							<option value="">전체</option>
							<option value="Y">아니오</option>
							<option value="N">예</option>
						</select>
					</td>
				</tr>
				<tr class="tabTr">
					<th>업체취소</th>
					<td>
						<select class="form_select" id="searchCancelYn" name="searchCancelYn">
							<option value="">전체</option>
							<option value="N" selected>아니오</option>
							<option value="Y">예</option>
						</select>
					</td>
					<th>서류제출여부</th>
					<td colspan="3">
						<select class="form_select" id="searchArrivalDocYnTap" name="searchArrivalDocYnTap">
							<option value="">전체</option>
							<option value="N">아니오</option>
							<option value="Y">예</option>
						</select>
					</td>
				</tr>

				<!-- specialTr start -->
				<tr class="specialTr" style="display:none;">
					<th>서류도착여부</th>
					<td>
						<select class="form_select" id="searchArrivalDocYn" name="searchArrivalDocYn">
							<option value="">전체</option>
							<option value="N">아니오</option>
							<option value="Y">예</option>
						</select>
					</td>
					<th>검토여부</th>
					<td colspan="3">
						<select class="form_select" id="searchChkYn" name="searchChkYn">
							<option value="">전체</option>
							<option value="N">아니오</option>
							<option value="Y">예</option>
						</select>
					</td>
				</tr>
				<tr class="specialTr" style="display:none;">
					<th>추천부분명</th>
					<td colspan="5">
						<select class="form_select" id="searchSpRecKind" name="searchSpRecKind" style="width:400px;">
							<option value="">전체</option>
							<c:forEach items="${spe000Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr class="specialTr" style="display:none;">
					<th>추천기관명</th>
					<td colspan="3">
						<input type="text" class="form_text" id="searchSpRecOrg" name="searchSpRecOrg" style="width:300px;"/>
					</td>
					<th>추천순위저장</th>
					<td style="text-align:center;">
						<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
					</td>
				</tr>
				<!-- specialTr end -->

			</table>
		</div>
		<button type="button" class="btn_folding" title="테이블접기"></button>
	</div>
</div>
<div class="cont_block">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div id="tabDiv" style="width: 100%;">
		<div id="tabSheet" class="sheet"></div>
	</div>
	<div id="personDiv" style="width: 100%; display:none;">
		<div id="personSheet" class="sheet"></div>
	</div>
	<div id="person2Div" style="width: 100%; display:none;">
		<div id="person2Sheet" class="sheet"></div>
	</div>
	<div id="person3Div" style="width: 100%; display:none;">
		<div id="person3Sheet" class="sheet"></div>
	</div>
	<div id="institutionDiv" style="width: 100%; display:none;">
		<div id="institutionSheet" class="sheet"></div>
	</div>
	<div id="specialDiv" style="width: 100%; display:none;">
		<div id="specialSheet" class="sheet"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function() {
		$('input[name="searchPriType2"]').prop('disabled', true);
		setSheetHeader_tradeDayLedgerTabSheet();
		setSheetHeader_tradeDayLedgerPersonSheet();
		setSheetHeader_tradeDayLedgerPerson2Sheet();
		setSheetHeader_tradeDayLedgerPerson3Sheet();
		setSheetHeader_tradeDayLedgerSpecialSheet();
		setSheetHeader_tradeDayLedgerInstitutionSheet();
	});

	function setSheetHeader_tradeDayLedgerTabSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",			Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"",				Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"chk" });
        ibHeader.addHeader({Header:"포상ID",			Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"svrId",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",		Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"applySeq",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"지역",			Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"tradeDept",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${com001Sheet.chgCode03}' , ComboText: '${com001Sheet.detailsortnm}' });
        ibHeader.addHeader({Header:"무역업번호",		Type:"Text",      Hidden:0,  Width:80,   Align:"Center",  SaveName:"memberId",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수상탑",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"expTapPrizeNmSuc",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체명",			Type:"Text",      Hidden:0,  Width:180,  Align:"Left",    SaveName:"coNmKr",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Cursor:"Pointer" });
        ibHeader.addHeader({Header:"접수번호",			Type:"Text",      Hidden:0,  Width:120,  Align:"Center",  SaveName:"receiptNo",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"사업자번호",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"bsNo",                 CalcLogic:"",   Format:"SaupNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"법인번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"corpoNo",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자",			Type:"Text",      Hidden:0,  Width:80,   Align:"Center",  SaveName:"ceoKr",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"외국인여부",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"fromYn",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체구분",			Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"scale",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd007Sheet.detailcd}' , ComboText: '${awd007Sheet.detailnm}' });
        ibHeader.addHeader({Header:"주민번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"juminNo",              CalcLogic:"",   Format:"IdNo",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"주소",			Type:"Text",      Hidden:0,  Width:180,  Align:"Left",    SaveName:"coAddr",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체tel",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"coPhone",              CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체팩스",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"coFax",                CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체홈피",			Type:"Text",      Hidden:0,  Width:180,  Align:"Left",    SaveName:"coHomepage",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"userNm",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당전화",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"userPhone",            CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당휴대폰",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"userHp",               CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자E-Mail",	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"userEmail",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자fax",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"userFax",              CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상종류",			Type:"Combo",     Hidden:0,  Width:120,  Align:"Left",    SaveName:"priType",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}' });
        ibHeader.addHeader({Header:"신청탑코드",		Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"expTapPrizeCd",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청탑",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"expTapPrizeNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청탑숫자",		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"tapCount",             CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전전년도_직수출",	Type:"Int",       Hidden:0,  Width:120,  Align:"Right",   SaveName:"twoDrExpAmt",          CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전전년도_로컬수출",	Type:"Int",       Hidden:0,  Width:120,  Align:"Right",   SaveName:"twoLcExpAmt",          CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전년도_직수출",		Type:"Int",       Hidden:0,  Width:120,  Align:"Right",   SaveName:"pastDrExpAmt",         CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전년도_로컬수출",	Type:"Int",       Hidden:0,  Width:120,  Align:"Right",   SaveName:"pastLcExpAmt",         CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"당해년도_직수출",	Type:"Int",       Hidden:0,  Width:120,  Align:"Right",   SaveName:"currDrExpAmt",         CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"당해년도_로컬수출",	Type:"Int",       Hidden:0,  Width:120,  Align:"Right",   SaveName:"currLcExpAmt",         CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"당해년도_합계",		Type:"Int",       Hidden:0,  Width:120,  Align:"Right",   SaveName:"currExpSum",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"과거수상년도",		Type:"Text",      Hidden:0,  Width:80,   Align:"Center",  SaveName:"praYear",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"과거수상탑",		Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    SaveName:"priCodeNm",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"서류제출여부",		Type:"Text",      Hidden:0,  Width:80,   Align:"Center",  SaveName:"arrivalDocYn",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

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

		var container = $('#tabSheet')[0];
		createIBSheet2(container, 'tabSheet', '100%', '429px');
		ibHeader.initSheet('tabSheet');

		tabSheet.SetEllipsis(1); 				// 말줄임 표시여부
		tabSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		tabSheet.SetEditable(1);
		tabSheet.SetVisible(1);

		getList();
	}

	function tabSheet_OnSort(col, order) {
		tabSheet.SetScrollTop(0);
	}

	function setSheetHeader_tradeDayLedgerPersonSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",				Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"",					Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"chk" });
        ibHeader.addHeader({Header:"포상ID",				Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"svrId",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",			Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"applySeq",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"본부코드",				Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"tradeDept",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업고유번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"memberId",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"receiptNo",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상종류",				Type:"Combo",     Hidden:0,  Width:130,  Align:"Left",    SaveName:"priType",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}' });
        ibHeader.addHeader({Header:"업체구분",				Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"scale",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd007Sheet.detailcd}' , ComboText: '${awd007Sheet.detailnm}' });
        ibHeader.addHeader({Header:"업체명",				Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"coNmKr",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"사업자등록번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"bsNo",                    CalcLogic:"",   Format:"SaupNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출의탑_포상코드",		Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"expTapPrizeCd",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출의탑",				Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    SaveName:"expTapPrizeNm",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직수출전전년도",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"twoDrExpAmt",             CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직수출전년도",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"pastDrExpAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직수출당해년도",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"currDrExpAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직수출신장률",			Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"drExpRate",               CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"로컬전전년도",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"twoLcExpAmt",             CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"로컬전년도",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"pastLcExpAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"로컬당해년도",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"currLcExpAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"로컬신장률",			Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"lcExpRate",               CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전전년도합계",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"twoExpSum",               CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전년도합계",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"pastExpSum",              CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"당해년도합계",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"currExpSum",              CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전체신장률",			Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"expIncrsRate",            CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자외국인유무",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"fromYn",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수입실적",				Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"impSiljuk",               CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역수지",				Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"tradeIndex",              CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역수지개선율",			Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"tradeIndexImprvRate",     CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장개척금액",		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"dvlpExploAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장개척금액_비중",	Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"dvlpExploAmtPor",         CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장외개척금액",		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"newMktExploAmt",          CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장외개척금액_비중",	Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"newMktExploAmtPor",       CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신기술개발품목명",		Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    SaveName:"newTechItemNm",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신기술개발인정기관",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"newTechTerm",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정부기술개발참여사업명",	Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    SaveName:"govTechNm",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정부기술개발참여시행기간",	Type:"Text",      Hidden:0,  Width:100,  Align:"Right",   SaveName:"govTechInst",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수입대체상품생산품목명",	Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    SaveName:"impReplItemNm",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수입대체상품생산품목수",	Type:"Text",      Hidden:0,  Width:100,  Align:"Right",   SaveName:"impReplItemCnt",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"자기상표제품수출상표수",	Type:"Text",      Hidden:0,  Width:100,  Align:"Right",   SaveName:"selfBrandExpCnt",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"자기상표제품수출품목수",	Type:"Text",      Hidden:0,  Width:100,  Align:"Right",   SaveName:"selfBrandExpItemCnt",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"자기상표제품수출상표명",	Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    SaveName:"selfBrandExpItemNm",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목HSCODE1",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"expItemHscode1",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목명",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"expItemNm1",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목HSCODE2",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"expItemHscode2",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목명2",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"expItemNm2",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목MTICODE1",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"expItemMticode1",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목MTINAME1",		Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"expItemMtiname1",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목MTICODE2",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"expItemMticode2",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목MTINAME2",		Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"expItemMtiname2",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"본사지방소재여부",		Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"bonsaYn",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd010Sheet.detailcd}' , ComboText: '${awd010Sheet.detailnm}' });
        ibHeader.addHeader({Header:"제조업/서비스업/농림수산업여부",			Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"jejo",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd010Sheet.detailcd}' , ComboText: '${awd010Sheet.detailnm}' });
        ibHeader.addHeader({Header:"단가상승률",			Type:"Float",      Hidden:0,  Width:100,  Align:"Right",    SaveName:"priceInflation",                  CalcLogic:"",   Format:"Float",            PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"주소",				Type:"Text",      Hidden:0,  Width:250,  Align:"Left",    SaveName:"coAddr",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청상태",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"state",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

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

		var container = $('#personSheet')[0];
		createIBSheet2(container, 'personSheet', '100%', '480px');
		ibHeader.initSheet('personSheet');

		personSheet.SetEllipsis(1); 				// 말줄임 표시여부
		personSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		personSheet.SetEditable(1);
		personSheet.SetVisible(1);

	}

	function personSheet_OnSort(col, order) {
		personSheet.SetScrollTop(0);
	}

	function setSheetHeader_tradeDayLedgerPerson2Sheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",			Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"",				Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"chk" });
        ibHeader.addHeader({Header:"포상ID",			Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"svrId",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",		Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"applySeq",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업고유번호",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"memberId",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"사업자등록번호",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"bsNo",         CalcLogic:"",   Format:"SaupNo",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"법인번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"corpoNo",      CalcLogic:"",   Format:"IdNo",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"공적구분",			Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"prvPriType",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd002Sheet.detailcd}' , ComboText: '${awd002Sheet.detailnm}' });
        ibHeader.addHeader({Header:"한글명",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"userNmKor",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체구분",			Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"scale",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd007Sheet.detailcd}' , ComboText: '${awd007Sheet.detailnm}' });
        ibHeader.addHeader({Header:"주민번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"juminNo",      CalcLogic:"",   Format:"IdNo",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직위",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"pos",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"근무기간년",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"wrkTermYy",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"근무기간월",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"wrkTermMm",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"소속회사",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"coNmKr",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자명",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"ceoKr",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"회사주소",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"coAddr",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"receiptNo",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"한자명",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"userNmCh",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"연령",			Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  SaveName:"age",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"성별",			Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  SaveName:"sex",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"군번",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"armyNo",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"국적",			Type:"Text",      Hidden:0,  Width:80,   Align:"Center",  SaveName:"bonjuk",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"우편번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"zipCd",        CalcLogic:"",   Format:"PostNo",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"주소",			Type:"Text",      Hidden:0,  Width:200,  Align:"Center",  SaveName:"addr",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직업",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"job",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"등급(직급계급)",	Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"rank",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"공적요지",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"kongjukSum",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"해외근무경력",		Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"fognWorkYn",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd010Sheet.detailcd}' , ComboText: '${awd010Sheet.detailnm}' });
        ibHeader.addHeader({Header:"담당자",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"userNm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자전화번호",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"userPhone",    CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자FAX",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"userFax",      CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"임원여부",			Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  SaveName:"imwonYn",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd010Sheet.detailcd}' , ComboText: '${awd010Sheet.detailnm}' });
        ibHeader.addHeader({Header:"근속기간",			Type:"Text",      Hidden:0,  Width:80,   Align:"Center",  SaveName:"wrkTerm",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청상태",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"state",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

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

		var container = $('#person2Sheet')[0];
		createIBSheet2(container, 'person2Sheet', '100%', '480px');
		ibHeader.initSheet('person2Sheet');

		person2Sheet.SetEllipsis(1); 				// 말줄임 표시여부
		person2Sheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		person2Sheet.SetEditable(1);
		person2Sheet.SetVisible(1);

	}

	function person2Sheet_OnSort(col, order) {
		person2Sheet.SetScrollTop(0);
	}

	function setSheetHeader_tradeDayLedgerPerson3Sheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",					Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"",						Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"chk" });
        ibHeader.addHeader({Header:"포상ID",					Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"svrId",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",				Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"applySeq",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"본부코드",					Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"tradeDept",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업고유번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"memberId",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호",					Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"receiptNo",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상종류",					Type:"Combo",     Hidden:0,  Width:130,  Align:"Left",    SaveName:"priType",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}' });
        ibHeader.addHeader({Header:"기업구분",					Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"scale",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd007Sheet.detailcd}' , ComboText: '${awd007Sheet.detailnm}' });
        ibHeader.addHeader({Header:"업체명",					Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"coNmKr",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"사업자등록번호",				Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"bsNo",                    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출의탑_포상코드",			Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"expTapPrizeCd",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출의탑",					Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    SaveName:"expTapPrizeNm",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직수출전년도",				Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"pastDrExpAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직수출당해년도",				Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"currDrExpAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직수출신장률",				Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"drExpRate",               CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"로컬전년도",				Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"pastLcExpAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"로컬당해년도",				Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"currLcExpAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"로컬신장률",				Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"lcExpRate",               CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전년도합계",				Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"pastExpSum",              CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"당해년도합계",				Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"currExpSum",              CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전체신장률",				Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"expIncrsRate",            CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자외국인유무",			Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"fromYn",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수입실적",					Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"impSiljuk",               CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역수지",					Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"tradeIndex",              CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역수지개선율",				Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"tradeIndexImprvRate",     CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장개척금액",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"dvlpExploAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장개척금액_비중",		Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"dvlpExploAmtPor",         CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장외개척금액",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"newMktExploAmt",          CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장외개척금액_비중",		Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"newMktExploAmtPor",       CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신기술개발품목명",			Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    SaveName:"newTechItemNm",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신기술개발인정기관",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"newTechTerm",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정부기술개발참여사업명",		Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    SaveName:"govTechNm",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정부기술개발참여시행기간",		Type:"Text",      Hidden:0,  Width:100,  Align:"Right",   SaveName:"govTechInst",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수입대체상품생산품목명",		Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    SaveName:"impReplItemNm",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수입대체상품생산품목수",		Type:"Text",      Hidden:0,  Width:100,  Align:"Right",   SaveName:"impReplItemCnt",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"자기상표제품수출상표수",		Type:"Text",      Hidden:0,  Width:100,  Align:"Right",   SaveName:"selfBrandExpCnt",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"자기상표제품수출품목수",		Type:"Text",      Hidden:0,  Width:100,  Align:"Right",   SaveName:"selfBrandExpItemCnt",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"자기상표제품수출상표명",		Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    SaveName:"selfBrandExpItemNm",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목HSCODE1",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"expItemHscode1",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목명",				Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"expItemNm1",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목HSCODE2",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"expItemHscode2",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목명2",				Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"expItemNm2",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목MTICODE1",			Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"expItemMticode1",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목MTINAME1",			Type:"Text",      Hidden:1,  Width:200,  Align:"Left",    SaveName:"expItemMtiname1",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목MTICODE2",			Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"expItemMticode2",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목MTINAME2",			Type:"Text",      Hidden:1,  Width:200,  Align:"Left",    SaveName:"expItemMtiname2",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체구분",			Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"scale2",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd007Sheet.detailcd}' , ComboText: '${awd007Sheet.detailnm}' });
        ibHeader.addHeader({Header:"본사지방소재여부",			Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"bonsaYn",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd010Sheet.detailcd}' , ComboText: '${awd010Sheet.detailnm}' });
        ibHeader.addHeader({Header:"제조업/서비스업/농림수산업여부",				Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"jejo",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd010Sheet.detailcd}' , ComboText: '${awd010Sheet.detailnm}' });
        ibHeader.addHeader({Header:"단가상승률",				Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"priceInflation",          CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"주소",					Type:"Text",      Hidden:0,  Width:250,  Align:"Left",    SaveName:"coAddr",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직수출 전전년도",					Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"twoDrExpAmt",             CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"로컬 전전년도",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"twoLcExpAmt",             CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전전년도합계",	Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"twoExpSum",               CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청상태",				Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"state",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

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

		var container = $('#person3Sheet')[0];
		createIBSheet2(container, 'person3Sheet', '100%', '480px');
		ibHeader.initSheet('person3Sheet');

		person3Sheet.SetEllipsis(1); 				// 말줄임 표시여부
		person3Sheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		person3Sheet.SetEditable(1);
		person3Sheet.SetVisible(1);

	}

	function person3Sheet_OnSort(col, order) {
		person3Sheet.SetScrollTop(0);
	}

	function setSheetHeader_tradeDayLedgerSpecialSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",				Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"",					Type:"Status",    Hidden:1,  Width:60,   Align:"Center",  SaveName:"status" });
        ibHeader.addHeader({Header:"포상ID",				Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"svrId",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",			Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"applySeq",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"공적구분",				Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"prvPriType",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청상태",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"stateNm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"서류도착여부",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"arrivalDocYn",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"추천명단일치여부",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"recListMatchYn",CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"검토여부",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"chkYnNm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"특수유공_추천부문",		Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"spRecKind",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"추천부분명",			Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    SaveName:"spRecKindNm",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"특수유공_추천기관명",		Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    SaveName:"spRecOrg",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"추천순위",				Type:"Text",      Hidden:0,  Width:80,   Align:"Right",   SaveName:"awardNo",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, AcceptKeys: 'N' });
        ibHeader.addHeader({Header:"과거수상이력",			Type:"Text",      Hidden:0,  Width:180,  Align:"Left",    SaveName:"history",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"한글명",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"userNmKor",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"직위",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"pos",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"임원여부",				Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"imwonYn",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd010Sheet.detailcd}' , ComboText: '${awd010Sheet.detailnm}', BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"주민번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"juminNo",       CalcLogic:"",   Format:"IdNo",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"업체구분",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"scaleNm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"소속업체",				Type:"Text",      Hidden:0,  Width:160,  Align:"Left",    SaveName:"coNmKr",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"근무기간",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"wrkTerm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"핸드폰",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"mobile",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"이메일",				Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  SaveName:"email",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"업체대표자명",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"ceoKr",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"업체주소",				Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"coAddr",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"우편번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"coZipCd",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"전화번호",				Type:"Text",      Hidden:0,  Width:110,  Align:"Center",  SaveName:"coPhone",       CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"사업자등록번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"bsNo",          CalcLogic:"",   Format:"SaupNo",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"법인번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"corpoNo",       CalcLogic:"",   Format:"IdNo",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"산재번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"indusInsurNo",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"무역업고유번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"memberId",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"국적",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"bonjuk",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"여권번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"passportNo",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"특수유공_추천자",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"spRecName",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"특수유공_추천자전화",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"spRecTel",      CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"특수유공_추천자핸드폰",	Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  SaveName:"spRecHp",       CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"특수유공_추천자이메일",	Type:"Text",      Hidden:0,  Width:160,  Align:"Left",    SaveName:"spRecEmail",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });

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

		var container = $('#specialSheet')[0];
		createIBSheet2(container, 'specialSheet', '100%', '480px');
		ibHeader.initSheet('specialSheet');

		specialSheet.SetEllipsis(1); 				// 말줄임 표시여부
		specialSheet.SetEditable(1);
		specialSheet.SetVisible(1);

	}

	function specialSheet_OnSort(col, order) {
		specialSheet.SetScrollTop(0);
	}

	function setSheetHeader_tradeDayLedgerInstitutionSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",				Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"",					Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"chk" });
        ibHeader.addHeader({Header:"포상ID",				Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"svrId",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",			Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"applySeq",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"본부코드",				Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"tradeDept",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업고유번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"memberId",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"receiptNo",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상종류",				Type:"Combo",     Hidden:0,  Width:130,  Align:"Left",    SaveName:"priType",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}' });
        ibHeader.addHeader({Header:"업체구분",				Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"scale",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd007Sheet.detailcd}' , ComboText: '${awd007Sheet.detailnm}' });
        ibHeader.addHeader({Header:"업체명",				Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"coNmKr",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출의탑_포상코드",		Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  SaveName:"expTapPrizeCd",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출의탑",				Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    SaveName:"expTapPrizeNm",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직수출전년도",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"pastDrExpAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직수출당해년도",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"currDrExpAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직수출신장률",			Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"drExpRate",               CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"로컬전년도",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"pastLcExpAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"로컬당해년도",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"currLcExpAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"로컬신장률",			Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"lcExpRate",               CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전년도합계",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"pastExpSum",              CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"당해년도합계",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"currExpSum",              CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전체신장률",			Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"expIncrsRate",            CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자외국인유무",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"fromYn",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수입실적",				Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"impSiljuk",               CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역수지",				Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"tradeIndex",              CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역수지개선율",			Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"tradeIndexImprvRate",     CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장개척금액",		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"dvlpExploAmt",            CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장개척금액_비중",	Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"dvlpExploAmtPor",         CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장외개척금액",		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   SaveName:"newMktExploAmt",          CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장외개척금액_비중",	Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"newMktExploAmtPor",       CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신기술개발품목명",		Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    SaveName:"newTechItemNm",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신기술개발인정기관",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"newTechTerm",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정부기술개발참여사업명",	Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    SaveName:"govTechNm",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정부기술개발참여시행기간",	Type:"Text",      Hidden:0,  Width:100,  Align:"Right",   SaveName:"govTechInst",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수입대체상품생산품목명",	Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    SaveName:"impReplItemNm",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수입대체상품생산품목수",	Type:"Text",      Hidden:0,  Width:100,  Align:"Right",   SaveName:"impReplItemCnt",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"자기상표제품수출상표수",	Type:"Text",      Hidden:0,  Width:100,  Align:"Right",   SaveName:"selfBrandExpCnt",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"자기상표제품수출품목수",	Type:"Text",      Hidden:0,  Width:100,  Align:"Right",   SaveName:"selfBrandExpItemCnt",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"자기상표제품수출상표명",	Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    SaveName:"selfBrandExpItemNm",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목HSCODE1",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"expItemHscode1",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목명",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"expItemNm1",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목HSCODE2",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"expItemHscode2",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목명2",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"expItemNm2",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목MTICODE1",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"expItemMticode1",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목MTINAME1",		Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"expItemMtiname1",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목MTICODE2",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"expItemMticode2",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목MTINAME2",		Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"expItemMtiname2",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"본사지방소재여부",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"bonsaYn",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"제조업여부",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"jejoupYn",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"서비스업여부",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"serviceYn",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"단가상승률",			Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   SaveName:"priceInflation",          CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"주소",				Type:"Text",      Hidden:0,  Width:250,  Align:"Left",    SaveName:"coAddr",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

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

		var container = $('#institutionSheet')[0];
		createIBSheet2(container, 'institutionSheet', '100%', '480px');
		ibHeader.initSheet('institutionSheet');

		institutionSheet.SetEllipsis(1); 				// 말줄임 표시여부
		institutionSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		institutionSheet.SetEditable(1);
		institutionSheet.SetVisible(1);

	}

	function institutionSheet_OnSort(col, order) {
		institutionSheet.SetScrollTop(0);
	}

	$('input[name="searchPriType"]').on('click', function() {

		var searchPriType = $(this).val();

		if(searchPriType == 'P') {

			$('.personTr').show();
			$('.tabTr, .specialTr').hide();
			$('.foldingTable').removeClass('fold');//필수
			$('.btn_folding').hide();

			$('input[name="searchPriType2"]').prop('disabled', false);
			$('input[name="searchPriType2"]').eq(0).prop('checked', true);

		}else {

			$('.foldingTable').removeClass('fold');//필수
			if(searchPriType == 'T') {
				$('.tabTr').show();
				$('.personTr, .specialTr').hide();
			}

			if(searchPriType == 'S') {
				$('.specialTr').show();
				$('.tabTr, .personTr').hide();
			}

			$('.btn_folding').show();
			$('input[name="searchPriType2"]').prop('checked', false);
			$('input[name="searchPriType2"]').prop('disabled', true);

		}

		getList();

	});

	$('input[name="searchPriType2"]').on('click', function() {
		getList();
	});

	function getList() {

		var searchPriType = $('input[name="searchPriType"]:checked').val();
		var searchPriType2 = $('input[name="searchPriType2"]:checked').val();

		$('#tabDiv, #personDiv, #person2Div, #person3Div, #institutionDiv, #specialDiv').css('display', 'none');

		if(searchPriType == 'T') {
			//수출의 탑 (tap)
			getTabList();
			$('#tabDiv').css('display', 'block');

		}else if(searchPriType == 'P') {
			//일반유공자

			if(searchPriType2 == 'TL') {
				//일반유공자 : 탑포함 기업원장 (person)
				getPersonList();
				$('#personDiv').css('display', 'block');

			}else if(searchPriType2 == 'PL') {
				//일반유공자 : 개인원장 (person2)
				getPerson2List();
				$('#person2Div').css('display', 'block');

			}else if(searchPriType2 == 'TL2') {
				//일반유공자 : 탑포함 기업원장 (person3)
				getPerson3List();
				$('#person3Div').css('display', 'block');

			}

		}else if(searchPriType == 'S') {
			//특수유공자 (special)
			getSpecialList();
			$('#specialDiv').css('display', 'block');


		}else if(searchPriType == 'G') {
			//기관표창 (institution)
			getInstitutionList();
			$('#institutionDiv').css('display', 'block');

		}
	}

	function getTabList() {
		tabSheet.ColumnSort('');	//sort 초기화
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDayLedgerTabList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				tabSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});

	}

	function getPersonList() {
		personSheet.ColumnSort('');	//sort 초기화
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDayLedgerPersonList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				personSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function getPerson2List() {
		person2Sheet.ColumnSort('');	//sort 초기화
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDayLedgerPerson2List.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				person2Sheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function getPerson3List() {
		person3Sheet.ColumnSort('');	//sort 초기화
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDayLedgerPerson3List.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				person3Sheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function getSpecialList() {
		specialSheet.ColumnSort('');	//sort 초기화
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDayLedgerSpecialList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				specialSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function getInstitutionList() {
		institutionSheet.ColumnSort('');	//sort 초기화
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDayLedgerInstitutionList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				institutionSheet.LoadSearchData({Data: (data.resultList || []) });
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

	function doSave() {

		if(confirm('저장하시겠습니까?')) {

			var jsonParam = $('#searchForm').serializeObject();
			var saveJson = specialSheet.GetSaveJson();
			jsonParam.tradeDayLedgerSpecialList = saveJson.data;

			global.ajax({
				type : 'POST'
				, url : '/tdms/asm/saveTradeDayLedgerSpecial.do'
				, data : JSON.stringify(jsonParam)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data){
					getList();
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}

	}

	function doExcel() {

		var searchPriType = $('input[name="searchPriType"]:checked').val();
		var searchPriType2 = $('input[name="searchPriType2"]:checked').val();

		if(searchPriType == 'T') {
			//수출의 탑 (tap)
			downloadIbSheetExcel(tabSheet, '수출의탑_리스트', '');

		}else if(searchPriType == 'P') {
			//일반유공자
			if(searchPriType2 == 'TL') {
				//일반유공자 : 탑포함 기업원장 (person)
				downloadIbSheetExcel(personSheet, '일반유공자_탑포함_기업원장_리스트', '');

			}else if(searchPriType2 == 'PL') {
				//일반유공자 : 개인원장 (person2)
				downloadIbSheetExcel(person2Sheet, '일반유공자_개인원장_리스트', '');

			}else if(searchPriType2 == 'TL2') {
				//일반유공자 : 탑포함 기업원장 (person3)
				downloadIbSheetExcel(person3Sheet, '일반유공자_탑포함_기업원장(신규)_리스트', '');

			}

		}else if(searchPriType == 'S') {
			//특수유공자 (special)
			downloadIbSheetExcel(specialSheet, '특수유공자_리스트', '');

		}else if(searchPriType == 'G') {
			//기관표창 (institution)
			downloadIbSheetExcel(institutionSheet, '기관표창_리스트', '');

		}

	}

	function initForm() {
		clearForm('foldingTable_inner');

		$('.foldingTable').removeClass('fold');//필수
		$('.tabTr').show();
		$('.personTr, .specialTr').hide();

		$('.btn_folding').show();
		$('input[name="searchPriType2"]').prop('checked', false);
		$('input[name="searchPriType2"]').prop('disabled', true);

		$('#searchCancelYn option').eq(1).prop('selected', true);
	}
</script>