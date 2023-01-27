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
<input type="hidden" id="bsnAplDt" name="bsnAplDt" value="<c:out value="${bsnAplDt}" />" />
<input type="hidden" id="priType" name="priType" value="" />
<input type="hidden" id="priTypeNm" name="priTypeNm" value="" />
<input type="hidden" id="memberId" name="memberId" value="" />
<input type="hidden" id="proxyYn" name="proxyYn" value="Y" />
<input type="hidden" id="listPage" name="listPage" value="/tdms/arm/awardResultNotice.do" />
<input type="text" id="displayNone" name="displayNone" style="display:none;" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<!--
		<button type="button" onclick="doSendAlimtalk();" class="btn_sm btn_primary btn_modify_auth">알림톡</button>
		-->
		<button type="button" onclick="doSendMail();" class="btn_sm btn_primary btn_modify_auth">MAIL</button>
		<button type="button" onclick="doSendFax();" class="btn_sm btn_primary btn_modify_auth">FAX</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="showViewEmail();" class="btn_sm btn_primary">미리보기</button>
		<button type="button" onclick="showSetEmailInfo();" class="btn_sm btn_primary btn_modify_auth">메일설정</button>
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
					<th>선정상태</th>
					<td>
						<select class="form_select" id="searchSt" name="searchSt">
							<option value="">전체</option>
							<option value="선정">선정</option>
							<option value="탈락">탈락</option>
						</select>
					</td>
					<th>대표자</th>
					<td>
						<input type="text" class="form_text" id="searchCeoKr" name="searchCeoKr" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
					<th>접수번호</th>
					<td>
						<input type="text" class="form_text" id="searchReceiptNo" name="searchReceiptNo" value="" onkeydown="onEnter(getList);" maxlength="30"/>
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
					<th>포상구분</th>
					<td>
						<select class="form_select" id="searchPriType" name="searchPriType">
							<option value="">전체</option>
							<c:forEach items="${awd001Select}" var="list" varStatus="status">
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
		setSheetHeader_awardResultNoticeSheet();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_awardResultNoticeSheet() {
		var	ibHeader = new IBHeader();
		var initSheet = {};

		ibHeader.addHeader({Header:"No|No",				Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"|",					Type:"Status",    Hidden:1, Width:60,   Align:"Center",  SaveName:"status" });
        ibHeader.addHeader({Header:"|",					Type:"CheckBox",  Hidden:0, Width:60,   Align:"Center",  ColMerge:1,   SaveName:"chk" });
        ibHeader.addHeader({Header:"포상ID|포상ID",		Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"svrId",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID|포상신청ID",	Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"applySeq",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호|접수번호",		Type:"Text",      Hidden:0, Width:130,  Align:"Center",  ColMerge:1,   SaveName:"receiptNo",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호|무역업번호",	Type:"Text",      Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"memberId",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체명|업체명",			Type:"Text",      Hidden:0, Width:180,  Align:"Left",    ColMerge:1,   SaveName:"coNmKr",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자|대표자",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"ceoKr",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상구분|포상구분",		Type:"Combo",     Hidden:0, Width:130,  Align:"Left",    ColMerge:1,   SaveName:"priType",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}' });
        ibHeader.addHeader({Header:"선정상태|선정상태",		Type:"Text",      Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"st",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자|담당자",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"userNm",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자|핸드폰",			Type:"Text",      Hidden:0, Width:120,  Align:"Center",  SaveName:"userHp",     CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자|메일",			Type:"Text",      Hidden:0, Width:180,  Align:"Left",    SaveName:"userEmail",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자|팩스",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"userFax",    CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전송여부|SMS",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"smsYn",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전송여부|E-MAIL",		Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"emailYn",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전송여부|FAX",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"faxYn",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"폼여부|폼여부",			Type:"Text",      Hidden:1, Width:80,   Align:"Center",  SaveName:"fromYn",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction|resize",
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
		createIBSheet2(container, 'listSheet', '100%', '452px');
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

	function listSheet_OnRowSearchEnd(row) {
		if(listSheet.GetCellValue(row, 'st') == '탈락') {
			listSheet.SetCellFontColor(row, 'st',"#FF0000");
		}
	}

	// 목록 가져오기
	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tdms/arm/selectAwardResultNoticeList.do" />'
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				listSheet.LoadSearchData({Data: (data.resultList || [])});
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

	function doExcel() {
		downloadIbSheetExcel(subSheet, '포상결과통보_리스트', '');
	}

	function showViewEmail() {
		var row = listSheet.GetSelectRow();

		if (row < 0) {
			alert('미리보기를 원하시는 데이터를 선택해 주세요.');

			return;
		}

		var svrId = listSheet.GetCellValue(row, 'svrId');
		var applySeq = listSheet.GetCellValue(row, 'applySeq');

		window.open('<c:url value="/tdms/arm/awardMailSendPopup.do" />?svrId=' + svrId + '&applySeq=' + applySeq, 'popupForm', 'width=800px,height=700px,top=100px,left=100px,scrollbars=yes,resizable=yes,status=no');
	}

	function doSendMail() {
		var jsonParam = {};
		var saveJson = listSheet.GetSaveJson();
		jsonParam.awardMailSendList = saveJson.data;

		if (jsonParam.awardMailSendList == '') {
			alert('선택된 것이 없습니다. 확인후 진행 바랍니다.');
			return false;
		}

		var chkCnt = 0;
		$(jsonParam.awardMailSendList).each(function(){
			if (this.chk == '1' && this.userEmail == '') {
				alert('메일 주소가 없습니다. 확인후 진행 바랍니다.');
				chkCnt++;

				return false;
			}
			if (this.chk == '1' && this.fromYn == 'N') {
				alert('해당 년도에 설정 내용이 없습니다. 확인후 진행 바랍니다.');
				chkCnt++;

				return false;
			}
		});

		if (chkCnt > 0) {
			return false;
		}

		if (confirm('메일 전송 하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tdms/arm/awardMailSend.do" />'
				, contentType : 'application/json'
				, data : JSON.stringify(jsonParam)
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data) {
					if (data.successYn == 'Y') {
						alert(data.message);

						getList();
					} else {
						alert(data.message);
					}
				}
			});
		}
	}

	function doSendAlimtalk() {
		var jsonParam = {};
		var saveJson = listSheet.GetSaveJson();
		jsonParam.awardTalkSendList = saveJson.data;

		if (jsonParam.awardTalkSendList == '') {
			alert('선택된 것이 없습니다. 확인후 진행 바랍니다.');
			return false;
		}

		var chkCnt = 0;
		$(jsonParam.awardTalkSendList).each(function(){
			if (this.chk == '1' && this.userHp == '') {
				alert('휴대전화번호가 없습니다. 확인후 진행 바랍니다.');
				chkCnt++;

				return false;
			}
		});

		if (chkCnt > 0) {
			return false;
		}

		if (confirm('알림톡 전송 하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tdms/arm/awardAlimtalkSend.do" />'
				, contentType : 'application/json'
				, data : JSON.stringify(jsonParam)
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data) {
					if (data.successYn == 'Y') {
						alert(data.message);

						getList();
					} else {
						alert(data.message);
					}
				}
			});
		}
	}

	function doSendFax() {
		var jsonParam = {};
		var saveJson = listSheet.GetSaveJson();
		jsonParam.awardFaxSendList = saveJson.data;

		if(jsonParam.awardFaxSendList == '') {
			alert('선택된 것이 없습니다. 확인후 진행 바랍니다.');
			return false;
		}

		var chkCnt = 0;
		$(jsonParam.awardFaxSendList).each(function() {
			if(this.chk == '1' && this.userFax == '') {
				alert('팩스번호가 없습니다. 확인후 진행 바랍니다.');
				chkCnt++
				return false;
			}
			if(this.chk == '1' && this.fromYn == 'N') {
				alert('해당 년도에 설정 내용이 없습니다. 확인후 진행 바랍니다.');
				chkCnt++
				return false;
			}
		});

		if(chkCnt > 0) {
			return false;
		}

		if(confirm('FAX 전송 하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : "/tdms/arm/awardFaxSend.do"
				, contentType : 'application/json'
				, data : JSON.stringify(jsonParam)
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data) {
					if(data.succYn == 'Y') {
						alert(data.message);
						getList();
					}else {
						alert(data.message);
					}
				}
			});
		}
	}

	function showSetEmailInfo() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/dlgSetEmalInfoPopup.do" />'
			, callbackFunction : function(resultObj){
			}
		});
	}
</script>