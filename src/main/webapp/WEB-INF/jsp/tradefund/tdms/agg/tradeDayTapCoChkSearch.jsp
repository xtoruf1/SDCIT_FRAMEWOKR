<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value=""/>
<input type="hidden" id="statusChk" name="statusChk" value=""/>
<input type="text" id="displayNone" name="displayNone" style="display:none;"/>
<input type="hidden" id="svrId" name="svrId" value="<c:out value="${svrId}"/>"/>
<input type="hidden" id="applySeq" name="applySeq" value="<c:out value="${applySeq}"/>"/>
<input type="hidden" id="readYn" name="readYn" value="Y"/>
<input type="hidden" id="listPage" name="listPage" value="/tdms/agg/tradeDayTapCoChkSearch.do"/>
<input type="hidden" id="bsnAplDt" name="bsnAplDt" value="<c:out value="${bsnAplDt}"/>"/>
<input type="hidden" id="priType" name="priType" value="<c:out value="${pritype}"/>"/>
<input type="hidden" id="priTypeNm" name="priTypeNm" value=""/>
<input type="hidden" id="memberId" name="memberId" value="<c:out value="${memberId}"/>"/>
<input type="hidden" id="proxyYn" name="proxyYn" value=""/>
<input type="hidden" id="tempFileId" name="tempFileId" value=""/>
<input type="hidden" id="appEditYn" name="appEditYn" value="Y"/>
<input type="hidden" id="receiptNo" name="receiptNo" value="<c:out value="${receiptNo}"/>"/>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doExcel();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="clearForm('foldingTable_inner');" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="getList();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="cont_block">
	<div class="foldingTable">
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
					<th>체크여부</th>
					<td>
						<select class="form_select" id="searchTapCoChkYn" name="searchTapCoChkYn">
							<option value="">전체</option>
							<option value="Y">체크</option>
							<option value="N">미체크</option>
						</select>
					</td>
					<th>무역업번호</th>
					<td>
						<input type="text" class="form_text" id="searchMemberId" name="searchMemberId" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="8" />
					</td>
				</tr>
				<tr>
					<th>회사명</th>
					<td>
						<input type="text" class="form_text" id="searchCoNmKr" name="searchCoNmKr" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
					<th>접수번호</th>
					<td>
						<input type="text" class="form_text" id="searchReceiptNo" name="searchReceiptNo" value="" onkeydown="onEnter(getList);" maxlength="30"/>
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
					<th>사업자번호</th>
					<td>
						<input type="text" class="form_text" id="searchBsNo" name="searchBsNo" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="10" />
					</td>
					<th>신청탑종류</th>
					<td colspan="3">
						<select class="form_select" id="searchExpTapPrizeCd" name="searchExpTapPrizeCd">
							<option value="">전체</option>
							<c:forEach items="${awd0092tSelect}" var="list" varStatus="status">
								<option value="${list.prizeCd}">${list.prizeName}</option>
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
		setSheetHeader_tradeDayTapCoChkSearchSheet();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_tradeDayTapCoChkSearchSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"상태",			Type:"Status",    Hidden:1, Width:60,   Align:"Center",  SaveName:"status" });
        ibHeader.addHeader({Header:"seq",			Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"applySeq",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"svrId",			Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"svrId",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"체크여부",			Type:"CheckBox",  Hidden:0, Width:70,   Align:"Center",  ColMerge:1,   SaveName:"tapCoChkYn",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, TrueValue: 'Y', FalseValue: 'N' });
        ibHeader.addHeader({Header:"수출의탑업체명",		Type:"Text",      Hidden:0, Width:180,  Align:"Left",    ColMerge:1,   SaveName:"tapCoNmKr",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호",			Type:"Text",      Hidden:0, Width:120,  Align:"Center",  ColMerge:1,   SaveName:"receiptNo",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"무역업번호",		Type:"Text",      Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"memberId",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"사업자등록번호",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"bsNo",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"신청구분",			Type:"Combo",     Hidden:0, Width:120,  Align:"Left",    ColMerge:1,   SaveName:"priType",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}', BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"신청탑코드",		Type:"Text",      Hidden:1, Width:100,  Align:"Left",    ColMerge:1,   SaveName:"expTapPrizeCd",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청탑종류",		Type:"Text",      Hidden:0, Width:100,  Align:"Left",    ColMerge:1,   SaveName:"expTapPrizeNm",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"업체명",			Type:"Text",      Hidden:0, Width:180,  Align:"Left",    ColMerge:1,   SaveName:"coNmKr",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"대표자명",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"ceoKr",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"담당자명",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"userNm",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"담당자TEL",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"userPhone",      CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"담당자FAX",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"userFax",        CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"담당자HP",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"userHp",         CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"담당자E-mail",	Type:"Text",      Hidden:0, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"userEmail",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"담당자E-mail2",	Type:"Text",      Hidden:0, Width:150,  Align:"Left",    ColMerge:1,   SaveName:"userEmail2",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"담당자직위",		Type:"Text",      Hidden:0, Width:100,  Align:"Left",    ColMerge:1,   SaveName:"userPosition",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"담당자부서",		Type:"Text",      Hidden:0, Width:100,  Align:"Left",    ColMerge:1,   SaveName:"userDeptNm",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });

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
		createIBSheet2(container, 'listSheet', '100%', '500px');
		ibHeader.initSheet('listSheet');

		listSheet.SetEllipsis(1); 				// 말줄임 표시여부
		listSheet.SetEditable(1);
		listSheet.SetVisible(1);

		getList();
	}

	function listSheet_OnSort(col, order) {
		listSheet.SetScrollTop(0);
	}

	function listSheet_OnSearchEnd() {

		listSheet.SetColFontBold('receiptNo', 1);

		var receiptNo = $('#receiptNo').val();
		if(receiptNo != '') {
			var rowNum = listSheet.FindText('receiptNo', receiptNo, 0, 0, 1);
			listSheet.SelectCell(rowNum, 'coNmKr', false, false);
			$('#receiptNo').val('');
		}

	}

	// 목록 가져오기
	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/agg/selectTradeDayTapCoChkSearchList.do"
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

		if(listSheet.ColSaveName(Col) == 'receiptNo' && Row > 0) {
			doReport(listSheet.GetCellValue(Row, "svrId"), listSheet.GetCellValue(Row, "applySeq"), listSheet.GetCellValue(Row, "memberId"), listSheet.GetCellValue(Row, "priType"));
		}

	}

	function goApplication(Row) {
		$('#svrId').val(listSheet.GetCellValue(Row, 'svrId'));
		$('#memberId').val(listSheet.GetCellValue(Row, 'memberId'));
		$('#applySeq').val(listSheet.GetCellValue(Row, 'applySeq'));
		$('#priType').val(listSheet.GetCellValue(Row, 'priType'));

		// 로딩이미지 시작
		$('#loading_image').show();

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
		downloadIbSheetExcel(listSheet, '수출의탑결과확인_리스트', '');
	}

	function doSave() {
		var jsonParam = $('#searchForm').serializeObject();
		var saveJson = listSheet.GetSaveJson();
		jsonParam.tradeDayTapCoChkSearchList = saveJson.data;

		if(confirm('저장하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tdms/agg/saveTradeDayTapCoChkSearch.do'
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

	function doReport(svrId, applySeq, memberId, priType) {
		var reportGb = '';

		if (priType == 'A') {
			reportGb += '&reportGB1=Y';		// 수출업체종사자 포상신청서(A)
			reportGb += '&reportGB2=Y';		// 공적조서
			reportGb += '&reportGB3=Y';		// 이력서
		} else if (priType == 'T') {
			reportGb += '&reportGB3=Y';		// 이력서
			reportGb += '&reportGB4=Y';		// 수출의 탑」 신청서(B)
		} else if (priType == 'P') {
			reportGb += '&reportGB1=Y';		// 수출업체종사자 포상신청서(A)
			reportGb += '&reportGB2=Y';		// 공적조서
			reportGb += '&reportGB3=Y';		// 이력서
		} else if (priType == 'S') {
			reportGb += '&reportGB2=Y';		// 공적조서
			reportGb += '&reportGB3=Y';		// 이력서
		} else if (priType == 'G') {
			alert('출력 없음');

			return false;
		}

		var url = '';
		<c:choose>
			<c:when test="${profile eq 'prod'}">
				url = 'https://membership.kita.net/fai/award/popup/tradeDayInquiryPrint.do';
			</c:when>
			<c:otherwise>
				url = 'https://devmembership.kita.net/fai/award/popup/tradeDayInquiryPrint.do';
			</c:otherwise>
		</c:choose>
		url += '?svr_id=' + svrId + '&apply_seq=' + applySeq + reportGb;

		var popFocus = window.open(url, 'search', 'width=770px,height=690px,scrollbars=yes');
		popFocus.focus();

		return;

		/*
		var param = '';
		var url = '<c:url value="/tdas/report/tradeDayInquiryPrint.do" />?svrId=' + svrId + '&applySeq=' + applySeq + '&memberId=' + memberId;

		if (priType == 'A') {
			param += '&reportGb1=Y';		// 수출업체종사자 포상신청서(A)
			param += '&reportGb2=Y';		// 공 적 조 서
			param += '&reportGb3=Y';		// 이력서
		} else if (priType == 'T') {
			param += '&reportGb3=Y';		// 이력서
			param += '&reportGb4=Y';		// 수출의 탑」 신청서(B)
		} else if (priType == 'P') {
			param += '&reportGb1=Y';		// 수출업체종사자 포상신청서(A)
			param += '&reportGb2=Y';		// 공 적 조 서
			param += '&reportGb3=Y';		// 이력서
		} else if (priType == 'S') {
			param += '&reportGb2=Y';		// 공 적 조 서
			param += '&reportGb3=Y';		// 이력서
		} else if (priType == 'G') {
			alert('출력 없음');

			return false;
		}

		url += param;

		var result = null;

		window.open(url, 'search', 'width=770px,height=690px,scrollbars=yes');

		if (result == null) {
			return;
		}
		*/
	}
</script>