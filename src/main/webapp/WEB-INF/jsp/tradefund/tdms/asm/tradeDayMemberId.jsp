<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value="" />
<input type="hidden" id="listPage" name="listPage" value="/tdms/asm/tradeDayMemberId.do" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doInsert();" class="btn_sm btn_primary btn_modify_auth">추가</button>
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
		<button type="button" onclick="doDelete();" class="btn_sm btn_primary btn_modify_auth">삭제</button>
	</div>
	<div class="ml-15">
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
					<th>무역업번호</th>
					<td>
						<input type="text" class="form_text" id="searchMemberId" name="searchMemberId" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="8" />
					</td>
					<th>업체명</th>
					<td colspan="3">
						<input type="text" class="form_text" id="searchCompanyKor" name="searchCompanyKor" value="" onkeydown="onEnter(getList);" maxlength="30" />
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
		setSheetHeader_tradeDayMemberIdSheet();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_tradeDayMemberIdSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

		ibHeader.addHeader({Header:" ",			Type:"DelCheck",  Hidden:0, Width:200,  Align:"Center",  ColMerge:1,   SaveName:"chk" });
        ibHeader.addHeader({Header:"status",	Type:"Status",    Hidden:1, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"status" });
        ibHeader.addHeader({Header:"seqNo",		Type:"Text",      Hidden:1, Width:60,   Align:"Left",    ColMerge:1,   SaveName:"seqNo",     CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"svrId",		Type:"Text",      Hidden:1, Width:60,   Align:"Left",    ColMerge:1,   SaveName:"svrId",     CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호",	Type:"Text",      Hidden:0, Width:330,  Align:"Left",    ColMerge:1,   SaveName:"memberId",  CalcLogic:"",   Format:"Number",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 });
        ibHeader.addHeader({Header:"사업자등록번호",	Type:"Text",      Hidden:0, Width:330,  Align:"Left",    ColMerge:1,   SaveName:"bsNo",      CalcLogic:"",   Format:"SaupNo",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 });
        ibHeader.addHeader({Header:"회사명",		Type:"Text",      Hidden:0, Width:430,  Align:"Left",    ColMerge:1,   SaveName:"coNm",      CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30, BackColor: '#F6F6F6' });

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
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
		createIBSheet2(container, 'listSheet', '100%', '525px');
		ibHeader.initSheet('listSheet');

		listSheet.SetEllipsis(1); 				// 말줄임 표시여부
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
			, url : "/tdms/asm/selectTradeDayMemberIdList.do"
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

	/**
	 * 포상 검색(팝업)
	 */
	function openLayerDlgSearchCorpPop(){

		var svrId = $('#searchSvrId').val();
		var jsonParams = {
			svrId:svrId
		}
		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/dlgSearchCorpPopup.do"/>',
			params : jsonParams

			, callbackFunction : function(resultObj) {
				$('#memberId').val(resultObj.memberId);
				$('#priType').val(resultObj.priType);
				$('#priTypeNm').val(resultObj.priTypeNm);

				openLayerTradeDayApplicationPop();
			}
		});

	}

	function openLayerTradeDayApplicationPop() {

		$('#svrId').val($("#searchSvrId").val());
		$('#statusChk').val('I');

		return false;//todo : 팝업 완성시 아래 구현

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayApplication.do"/>',
			params : $('#searchForm').serializeObject()

			, callbackFunction : function(resultObj) {

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

	function doInsert() {
		var index = listSheet.DataInsert();
	}

	function doSave() {
		var jsonParam = $('#searchForm').serializeObject();
		var saveJson = listSheet.GetSaveJson();
		jsonParam.tradeDayMemberIdList = saveJson.data;

		if(jsonParam.tradeDayMemberIdList == '') {
			alert('저장할 내용이 없습니다.');
			return false;
		}

		$(jsonParam.tradeDayMemberIdList).each(function() {

			if($.trim(this.memberId) == '') {
				alert('무역업등록번호를 입력해주세요.');
				return false;
			}

		});

		if(confirm('저장하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tdms/asm/saveTradeDayMemberId.do'
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

	function doDelete() {
		var jsonParam = $('#searchForm').serializeObject();
		var saveJson = listSheet.GetSaveJson();
		jsonParam.tradeDayMemberIdList = saveJson.data;

		var chkCnt = 0;
		$(jsonParam.tradeDayMemberIdList).each(function() {
			if(this.status == 'D') {
				chkCnt++;
			}
		});

		if(chkCnt < 1) {
			alert('선택된 자료가 없습니다.');
			return false;
		}

		if(confirm('삭제하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tdms/asm/deleteTradeDayMemberId.do'
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

</script>