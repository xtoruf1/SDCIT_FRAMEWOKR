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
<input type="hidden" id="listPage" name="listPage" value="/tdms/arm/awardResultUpdate.do"/>
<input type="hidden" id="bsnAplDt" name="bsnAplDt" value="<c:out value="${bsnAplDt}"/>"/>
<input type="hidden" id="priType" name="priType" value=""/>
<input type="hidden" id="priTypeNm" name="priTypeNm" value=""/>
<input type="hidden" id="memberId" name="memberId" value=""/>
<input type="hidden" id="proxyYn" name="proxyYn" value="Y"/>
<input type="hidden" id="uploadYn" name="uploadYn" value="N"/>
<input type="hidden" id="searchGb" name="searchGb" value="1"/>
<input type="hidden" id="searchPraYear" name="searchPraYear" value="<c:out value="${searchPraYear}"/>"/>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
		<button type="button" onclick="doExcelUpload();" class="btn_sm btn_primary btn_modify_auth">엑셀업로드</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doReceiptReport();" class="btn_sm btn_primary">인수증출력</button>
		<button type="button" onclick="doExcel();" class="btn_sm btn_primary">엑셀다운</button>
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
						<input type="text" class="form_text" id="searchCoNmKr" name="searchCoNmKr" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
					<th>무역업번호</th>
					<td>
						<input type="text" class="form_text" id="searchMemberId" name="searchMemberId" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="8" />
					</td>
				</tr>
				<tr>
					<th>신청구분</th>
					<td>
						<select class="form_select" id="searchPrvPriType" name="searchPrvPriType">
							<option value="">전체</option>
							<c:forEach items="${awd002Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>대상자</th>
					<td>
						<input type="text" class="form_text" id="searchUserNmKor" name="searchUserNmKor" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
					<th>사업자번호</th>
					<td>
						<input type="text" class="form_text" id="searchBsNo" name="searchBsNo" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="10" />
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
<div class="cont_block mt-20">
	<div class="tbl_opt" style="display: flex;justify-content: space-between;">
		<div id="mainTotalCnt" class="total_count" style="width:43%"></div>
		<div id="subTotalCnt" class="total_count" style="width:51%"></div>
	</div>
	<div style="width: 100%;height: 100%;display: flex;justify-content: space-between;">
		<div id="mainSheet" class="sheet"></div>
		<div style="width:5%;height:100%;margin-top:15%;text-align:center;">
			<img src="/images/bt_arrow_1.gif" style="cursor:pointer;" onclick="javascript:goSet();">
			<br/>
			<img src="/images/bt_arrow_3.gif" style="margin-top:10px;cursor:pointer;" onclick="javascript:doClear();">
		</div>
		<div id="subSheet" class="sheet"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function() {
		setSheetHeader_awardResultUpdateMainSheet();
		setSheetHeader_awardResultUpdateSubSheet();
		getMainList();
		getSubList();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_awardResultUpdateMainSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",			Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"",				Type:"Text",      Hidden:1, Width:60,   Align:"Center",  SaveName:"chk" });
        ibHeader.addHeader({Header:"무역업번호",		Type:"Text",      Hidden:1, Width:180,  Align:"Left",    SaveName:"memberId",    CalcLogic:"",   Format:"Number",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"주민등록번호",		Type:"Text",      Hidden:1, Width:180,  Align:"Left",    SaveName:"juminNo",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체명",			Type:"Text",      Hidden:0, Width:180,  Align:"Left",    SaveName:"coNmKr",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대상자",			Type:"Text",      Hidden:0, Width:100,  Align:"Left",    SaveName:"userNmKor",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직위",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  SaveName:"pos",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"휴대전화",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"mobile",      CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청구분",			Type:"Combo",     Hidden:0, Width:100,  Align:"Center",  SaveName:"prvPriType",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd002Sheet.detailcd}' , ComboText: '${awd002Sheet.detailnm}' });
        ibHeader.addHeader({Header:"포상ID",			Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"svrId",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",		Type:"Text",      Hidden:0, Width:100,  Align:"Center",  SaveName:"applySeq",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

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

		var container = $('#mainSheet')[0];
		createIBSheet2(container, 'mainSheet', '43%', '580px');
		ibHeader.initSheet('mainSheet');

		mainSheet.SetEllipsis(1); 				// 말줄임 표시여부
		mainSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		mainSheet.SetEditable(1);
		mainSheet.SetVisible(1);

	}

	function mainSheet_OnSort(col, order) {
		mainSheet.SetScrollTop(0);
	}

	// Sheet의 초기화 작업
	function setSheetHeader_awardResultUpdateSubSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",			Type:"Seq",       Hidden:0,  Width:60,   Align:"Center", SaveName:"no", BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"",				Type:"Status",    Hidden:1,  Width:60,   Align:"Center", SaveName:"status" });
        ibHeader.addHeader({Header:"결과ID",			Type:"Text",      Hidden:1,  Width:50,   Align:"Left",   SaveName:"resultId",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상ID",			Type:"Text",      Hidden:0,  Width:80,   Align:"Center", SaveName:"svrId",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",		Type:"Text",      Hidden:0,  Width:80,   Align:"Center", SaveName:"applySeq",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호",			Type:"Text",      Hidden:0,  Width:130,  Align:"Left",   SaveName:"receiptNo",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"무역업번호",		Type:"Text",      Hidden:0,  Width:80,   Align:"Center", SaveName:"memberId",    CalcLogic:"",   Format:"Number",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 });
        ibHeader.addHeader({Header:"수상번호",			Type:"Text",      Hidden:0,  Width:80,   Align:"Center", SaveName:"priNo",       CalcLogic:"",   Format:"Number",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"근무처명",			Type:"Text",      Hidden:0,  Width:180,  Align:"Left",   SaveName:"coNmKr",      KeyField:1,     CalcLogic:"",         Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 });
        ibHeader.addHeader({Header:"대상자명",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center", SaveName:"priUserNm",   KeyField:1,     CalcLogic:"",         Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 });
        ibHeader.addHeader({Header:"주민번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center", SaveName:"juminNo",     CalcLogic:"",   Format:"IdNo",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직위",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center", SaveName:"pos",         KeyField:1,     CalcLogic:"",         Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"상장",			Type:"Combo",     Hidden:0,  Width:100,  Align:"Left",   SaveName:"priCode",     KeyField:1,     CalcLogic:"",         Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, ComboCode: '${prizeCodeListSheet.prizeCd}' , ComboText: '${prizeCodeListSheet.prizeName}' });
        ibHeader.addHeader({Header:"포상구분",			Type:"Combo",     Hidden:0,  Width:100,  Align:"Left",   SaveName:"priGbn",      KeyField:1,     CalcLogic:"",         Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, ComboCode: '${awd002Sheet.detailcd}' , ComboText: '${awd002Sheet.detailnm}' });
        ibHeader.addHeader({Header:"특수유공부문",		Type:"Combo",     Hidden:0,  Width:100,  Align:"Left",   SaveName:"priGbn2",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, ComboCode: '${spe000Sheet.detailcd}' , ComboText: '${spe000Sheet.detailnm}' });
        ibHeader.addHeader({Header:"포상년도",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center", SaveName:"praYear",     KeyField:1,     CalcLogic:"",         Format:"Number",       PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 });
        ibHeader.addHeader({Header:"포상일",			Type:"Date",      Hidden:0,  Width:100,  Align:"Center", SaveName:"priDt",       KeyField:1,     CalcLogic:"",         Format:"yyyy-MM-dd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"부상",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",   SaveName:"addPrize",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:200 });
        ibHeader.addHeader({Header:"수령처",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",   SaveName:"receiveNm",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:200 });

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

		var container = $('#subSheet')[0];
		createIBSheet2(container, 'subSheet', '51%', '580px');
		ibHeader.initSheet('subSheet');

		subSheet.SetEllipsis(1); 				// 말줄임 표시여부
		subSheet.SetEditable(1);
		subSheet.SetVisible(1);

	}

	function subSheet_OnSort(col, order) {
		subSheet.SetScrollTop(0);
	}

	function mainSheet_OnClick() {
		$('#searchGb').val('1');
	}

	function subSheet_OnClick() {
		$('#searchGb').val('2');
	}

	function getList() {
		var searchGb = $('#searchGb').val();

		if(searchGb == '1') {
			getMainList();
		}else {
			getSubList();
		}
	}

	function getMainList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/arm/selectAwardResultUpdateMainList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#mainTotalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				mainSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function getSubList() {
		$('#uploadYn').val('N');
		var searchParams = $('#searchForm').serializeObject();
		global.ajax({
			type : 'POST'
			, url : "/tdms/arm/selectAwardResultUpdateSubList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#subTotalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				subSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function mainSheet_OnSearchEnd() {
		mainSheet.SetSelectRow(1);
	}

	function subSheet_OnSearchEnd() {
		subSheet.SetSelectRow(1);
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
				$('#searchPraYear').val(resultObj.svrId.substring(1,5));

				getMainList();
				getSubList();
			}
		});

	}

	// 상세 페이지 & 팝업
	function mainSheet_OnDblClick(Row, Col, Value) {

	}

	function doExcel() {
		downloadIbSheetExcel(subSheet, '결과등록(인수증출력)_리스트', '');
	}

	function doSave() {

		var jsonParam = $('#searchForm').serializeObject();
		var praYear = jsonParam.searchPraYear
		var saveJson = subSheet.GetSaveJson({AllSave:1});
		jsonParam.awardResultUpdateSubList = saveJson.data;

		if(jsonParam.awardResultUpdateSubList == '') {
			return false;
		}

		var chk = true;
		$(jsonParam.awardResultUpdateSubList).each(function(i) {

			if(this.praYear != praYear) {
				alert('포상년도가 ' + praYear + '가 아닙니다.');
				subSheet.SelectCell(i+1, 'praYear');
				chk = false;
				return false;
			}

			this.priGbn = (this.priGbn).replace(/\s/g,'');

		});

		if(!chk) return false;

		if(confirm('저장하시겠습니까?')) {
			$('.loading_wrapper').show();
			global.ajax({
				type : 'POST'
				, url : '/tdms/arm/saveAwardResultUpdate.do'
				, data : JSON.stringify(jsonParam)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: true
				, spinner : true
				, success : function(data){
					getMainList();
					getSubList();
					$('.loading_wrapper').hide();
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
					$('.loading_wrapper').hide();
				}
			});

		}

	}//doSave


	function doReceiptReport() {

		var svrId = subSheet.GetCellValue(subSheet.GetSelectRow(), "svrId");
		var applySeq = subSheet.GetCellValue(subSheet.GetSelectRow(), "applySeq");
		var resultId = subSheet.GetCellValue(subSheet.GetSelectRow(), "resultId");
		var row = subSheet.GetSelectRow();

		if($.trim(applySeq) == '' && $.trim(resultId) == '') {
			return false;
		}

		if(row <= 0) {
			alert('인수증출력 할 대상자 정보를 선택해주세요.');
			return false;
		}

		var url = '<c:url value="/tdas/report/tradeDayReceiptPrint.do" />?svrId=' + svrId + '&applySeq=' + applySeq + '&resultId=' + resultId;

		var result = null;

		window.open(url, 'search', 'width=770px,height=690px,scrollbars=yes');

		if (result == null) {
			return;
		}

	}

	function goSet() {

		var mainRow = mainSheet.GetSelectRow();
		var subRow = subSheet.GetSelectRow();

		if(mainRow <= 0){
			alert('매칭할 행을 선택 되지 않았습니다. 확인 후 진행 바랍니다.');
			return false;
		}

		if(subRow <= 0){
			alert('매칭대상이 선택 되지 않았습니다. 확인 후 진행 바랍니다.');
			return false;
		}

		var svrId = mainSheet.GetCellValue(mainRow, 'svrId');
		var applySeq = mainSheet.GetCellValue(mainRow, 'applySeq');
		subSheet.SetCellValue(subRow, 'svrId', svrId);
		subSheet.SetCellValue(subRow, 'applySeq', applySeq);

	}

	function doClear() {

		var subRow = subSheet.GetSelectRow();

		if(subRow <= 0){
			alert("매칭 제거 대상이 없습니다. 확인 후 진행 바랍니다.");
			return false;
		}

		subSheet.SetCellValue(subRow, 'svrId', '');
		subSheet.SetCellValue(subRow, 'applySeq', '');

	}

	function doExcelUpload() {

		var searchSvrId = $('#searchSvrId').val();
		var searchBsnNm = $('#searchBsnNm').val();

		if(searchSvrId == '') {
			alert('포상명을 선택해주세요.');
			return false;
		}

		if(confirm('엑셀 등록시 기존 데이터가 삭제됩니다. 진행하시겠습니까?\n  삭제 포상명 : ' + searchBsnNm)) {
			$('#uploadYn').val('Y');
			var ColumnMapping = "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20";
			subSheet.SetUploadingImage('/images/common/loading.gif');
			subSheet.LoadExcel({StartRow:1, ColumnMapping:ColumnMapping});
		}

	}

	function subSheet_OnLoadExcel(Row, Col, Value) {
		doMapping();
	}

	function doMapping() {

		var mainRowCnt = mainSheet.RowCount();
		var subRowCnt = subSheet.RowCount();
		$('#subTotalCnt').html('총 <span>' + global.formatCurrency(subRowCnt) + '</span> 건');

		for(var i = 1; i <= subRowCnt; i++) {
			var rowNum = 0;

			if(subSheet.GetCellValue(i, 'applySeq') == '') {

				if(subSheet.GetCellValue(i, 'juminNo') != '') {
					rowNum = mainSheet.FindText('juminNo', subSheet.GetCellValue(i, 'juminNo'));

					//구분이 수출의 탑인 경우 무역업번호로 다시 조회
					if(mainSheet.GetCellValue(rowNum, 'prvPriType') == '10') {
						rowNum = 0;
					}

				}

				if(rowNum == 0 && subSheet.GetCellValue(i, 'memberId') != '') {
					rowNum = mainSheet.FindText('memberId', subSheet.GetCellValue(i, 'memberId'));

					if(mainSheet.GetCellValue(rowNum, 'prvPriType') == '30') {
						rowNum = mainSheet.FindText('memberId', subSheet.GetCellValue(i, 'memberId'), rowNum+1);
					}

				}

				if(rowNum > 0) {

					subSheet.SetCellValue(i, 'svrId', mainSheet.GetCellValue(rowNum, 'svrId'));
					subSheet.SetCellValue(i, 'applySeq', mainSheet.GetCellValue(rowNum, 'applySeq'));

				}

			}

		}//for

	}

</script>