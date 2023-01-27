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
<input type="hidden" id="listPage" name="listPage" value="/tdms/asm/tradeDayApplicationList.do"/>
<input type="hidden" id="bsnAplDt" name="bsnAplDt" value="<c:out value="${awd0000t.bsnAplDt}"/>"/>
<input type="hidden" id="priType" name="priType" value=""/>
<input type="hidden" id="priTypeNm" name="priTypeNm" value=""/>
<input type="hidden" id="memberId" name="memberId" value=""/>
<input type="hidden" id="proxyYn" name="proxyYn" value="Y"/>


<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="openLayerDlgSearchCorpPop();" class="btn_sm btn_primary btn_modify_auth">신규</button>
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
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${awd0000t.svrId}"/>"/>
							<input type="text" id="searchBsnNm" name="searchBsnNm" class="form_text" value="<c:out value="${awd0000t.bsnNm}"/>" style="font-size:14px;" readonly>
							<button type="button" class="btn_icon btn_search" title="포상검색" onclick="openLayerDlgSearchAwardPop();"></button>
						</span>
					</td>
					<th>회사명</th>
					<td>
						<input type="text" class="form_text" id="searchCoNmKr" name="searchCoNmKr" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
					<th>무역업번호</th>
					<td>
						<input type="text" class="form_text" id="searchMemberId" name="searchMemberId" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="8" />
					</td>
				</tr>
				<tr>
					<th>사업자등록번호</th>
					<td>
						<input type="text" class="form_text" id="searchBsNo" name="searchBsNo" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="10" />
					</td>
					<th>접수번호</th>
					<td>
						<input type="text" class="form_text" id="searchReceiptNo" name="searchReceiptNo" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
					<th>대상자</th>
					<td>
						<input type="text" class="form_text" id="searchUserNmKor" name="searchUserNmKor" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
				</tr>
				<tr>
					<th>업체구분</th>
					<td>
						<select class="form_select" id="searchScale" name="searchScale">
							<option value="">전체</option>
							<c:forEach items="${awd007Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>지역구분</th>
					<td>
						<select class="form_select" id="searchTradeDept" name="searchTradeDept">
							<c:if test="${deptAllYn eq 'Y'}">
								<option value="">전체</option>
							</c:if>
							<c:forEach items="${com001Select}" var="list" varStatus="status">
								<option value="${list.chgCode03}">${list.detailsortnm}</option>
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
				</tr>
				<tr>
					<th>포상종류</th>
					<td>
						<select class="form_select" id="searchPrvPriType" name="searchPrvPriType">
							<option value="">전체</option>
							<c:forEach items="${awd002Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>추천기관</th>
					<td colspan="3">
						<input type="text" class="form_text w100p" name="searchSpRecOrg" value="" onkeydown="onEnter(getList);" maxlength="30"/>
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
	$(document).ready(function() {
		setSheetHeader_tradeDayApplicationListSheet();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_tradeDayApplicationListSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

		ibHeader.addHeader({Header:"No",			Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"no" });
		ibHeader.addHeader({Header:"",  			Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"chk" });
		ibHeader.addHeader({Header:"포상ID",			Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"svrId",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"포상신청ID",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"applySeq",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"접수번호",			Type:"Text",      Hidden:0, Width:160,  Align:"Center",  SaveName:"receiptNo",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"본부코드",			Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"tradeDept",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"무역업번호",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"memberId",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"신청일자",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"reqDate",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, });
		ibHeader.addHeader({Header:"신청상태",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"stateGb",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"업체명",			Type:"Text",      Hidden:0, Width:180,  Align:"Left",    SaveName:"coNmKr",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Cursor:"Pointer" });
		ibHeader.addHeader({Header:"업체명_영문",		Type:"Text",      Hidden:1, Width:100,  Align:"Left",  SaveName:"coNmEn",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"대표자",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"ceoKr",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"대표자_영문",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"ceoEn",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"업체구분",			Type:"Combo",     Hidden:0, Width:100,  Align:"Center",  SaveName:"scale",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd007Sheet.detailcd}' , ComboText: '${awd007Sheet.detailnm}' });
		ibHeader.addHeader({Header:"포상구분",			Type:"Combo",     Hidden:0, Width:100,  Align:"Center",  SaveName:"priType",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}' });
		ibHeader.addHeader({Header:"포상종류",			Type:"Combo",     Hidden:0, Width:100,  Align:"Center",  SaveName:"prvPriType",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd002Sheet.detailcd}' , ComboText: '${awd002Sheet.detailnm}' });
		ibHeader.addHeader({Header:"대상자",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"userNmKor",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"핸드폰",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"mobile",           CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자연락처",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"userPhone",        CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자_핸드폰",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"userHp",           CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"수출의탑_포상코드",	Type:"Text",      Hidden:1, Width:100,  Align:"Center",  SaveName:"expTapPrizeCd",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"신청탑",			Type:"Text",      Hidden:0, Width:100,  Align:"Left",    SaveName:"expTapPrizeNm",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"추천기관",			Type:"Text",      Hidden:0, Width:100,  Align:"Left",    SaveName:"spRecOrg",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"추천부문",			Type:"Combo",     Hidden:0, Width:130,  Align:"Left",    SaveName:"spRecKind",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${spe000Sheet.detailcd}' , ComboText: '${spe000Sheet.detailnm}' });

		//ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0 , FrozenCol:7});

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
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

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
			, url : "/tdms/asm/selectTradeDayApplicationList.do"
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

	function listSheet_OnSearchEnd() {
   		listSheet.SetColFontBold('coNmKr', 1);
    }

	/**
	 * 포상 검색(팝업)
	 */
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

	/**
	 * 포상 검색(팝업)
	 */
	function openLayerDlgSearchCorpPop() {

		var svrId = $('#searchSvrId').val();
		var jsonParams = {
			svrId:svrId
		}
		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/dlgSearchCorpPopup.do"/>',
			params : jsonParams

			, callbackFunction : function(resultObj) {
				closeLayerPopup();

				$('#memberId').val(resultObj.memberId);
				$('#priType').val(resultObj.priType);
				$('#priTypeNm').val(resultObj.priTypeNm);

				openLayerTradeDayApplicationPop();
			}
		});
	}

	function openLayerTradeDayApplicationPop() {
		// 로딩이미지 시작
		$('#loading_image').show();

		$('#svrId').val($('#searchSvrId').val());
		$('#applySeq').val('');
		$('#statusChk').val('I');

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayApplicationPopup.do"/>'
			, params : $('#searchForm').serializeObject()
			, callbackFunction : function(resultObj) {
				var event = resultObj.event;

				// 업체수정 처리
				if (event == 'tradeDayApplicationTempUpdate') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();

					// 레이어 다시 오픈
					openLayerTradeDayApplicationPop();
				// 삭제 처리
				} else if (event == 'tradeDayApplicationDelete') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();
				// 신청구분 변경
				} else if (event == 'tradeDayApplicationChangePriType') {
					// 레이어 닫기
					closeLayerPopup();

					// 레이어 다시 오픈
					openLayerTradeDayApplicationPop();
				// 신청서 저장
				} else if (event == 'tradeDayApplicationSave') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();

					// 레이어 다시 오픈
					openLayerTradeDayApplicationPop();
				// 신청서 임시저장
				} else if (event == 'tradeDayApplicationTempSave') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();

					// 레이어 다시 오픈
					openLayerTradeDayApplicationPop();
				}
			}
		});
	}

	// 상세 페이지 & 팝업
	function listSheet_OnClick(Row, Col, Value) {
		if(listSheet.ColSaveName(Col) == 'coNmKr' && Row > 0) {
			var rowData = listSheet.GetRowData(Row);
			goApplication(Row);
		}
	}

	function goApplication(Row) {
		$('#svrId').val(listSheet.GetCellValue(Row, 'svrId'));
		$('#memberId').val(listSheet.GetCellValue(Row, 'memberId'));
		$('#applySeq').val(listSheet.GetCellValue(Row, 'applySeq'));
		$('#priType').val(listSheet.GetCellValue(Row, 'priType'));
		$("#statusChk").val('U');

		// 로딩이미지 시작
		$('#loading_image').show();

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayApplicationPopup.do"/>',
			params : $('#searchForm').serializeObject()
			, callbackFunction : function(resultObj) {
				var event = resultObj.event;

				// 업체수정 처리
				if (event == 'tradeDayApplicationTempUpdate') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();

					// 레이어 다시 오픈
					goApplication(Row);
				// 삭제 처리
				} else if (event == 'tradeDayApplicationDelete') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();
				// 신청구분 변경
				} else if (event == 'tradeDayApplicationChangePriType') {
					// 레이어 닫기
					closeLayerPopup();

					// 레이어 다시 오픈
					goApplication(Row);
				// 신청서 저장
				} else if (event == 'tradeDayApplicationSave') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();

					// 레이어 다시 오픈
					goApplication(Row);
				// 신청서 임시저장
				} else if (event == 'tradeDayApplicationTempSave') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();

					// 레이어 다시 오픈
					goApplication(Row);
				}
			}
		});
	}

	function doExcel() {
        downloadIbSheetExcel(listSheet, '신청서_의뢰등록_리스트', '');
	}
</script>