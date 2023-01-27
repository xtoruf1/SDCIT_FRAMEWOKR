<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value=""/>
<input type="hidden" id="bsnAplDt" name="bsnAplDt" value="<c:out value="${bsnAplDt}"/>"/>
<input type="hidden" id="state" name="state"/>

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
					<td colspan="5">
						<span class="form_search">
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>"/>
							<input type="text" id="searchBsnNm" name="searchBsnNm" class="form_text" value="<c:out value="${searchBsnNm}"/>" style="font-size:14px;" readonly>
							<button type="button" class="btn_icon btn_search" title="포상검색" onclick="openLayerDlgSearchAwardPop();"></button>
						</span>
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
		setSheetHeader_tradeDaySpecialStatusSheet();
	});

	function setSheetHeader_tradeDaySpecialStatusSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

		ibHeader.addHeader({Header:"상태",				Type:"Status",    Hidden:1,  Width:60,   Align:"Center",  SaveName:"status" });
        ibHeader.addHeader({Header:"추천부문",				Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"spRecKindNmKey",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"추천기관",				Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    SaveName:"spRecOrgNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 });
        ibHeader.addHeader({Header:"검토완료여부",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"chkCntNm",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"신청상태",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"stateCntNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"num_seq",			Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"numSeq" });
        ibHeader.addHeader({Header:"신청자",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"userNmKor",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"신청자(한문)",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"userNmCh",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"직급",				Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"pos",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"임원여부",				Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"imwonYn",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd010Sheet.detailcd}' , ComboText: '${awd010Sheet.detailnm}', BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"주민번호",				Type:"Text",      Hidden:0,  Width:140,  Align:"Center",  SaveName:"juminNo",           CalcLogic:"",   Format:"IdNo",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"업체명",				Type:"Text",      Hidden:0,  Width:160,  Align:"Left",    SaveName:"coNmKr",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"수공기간",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"wrkTerm",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"신청자연락처",			Type:"Text",      Hidden:0,  Width:130,  Align:"Left",    SaveName:"mobile",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"신청자E-mail",		Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    SaveName:"email",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"사업자번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"bsNo",              CalcLogic:"",   Format:"SaupNo",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"법인번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"corpoNo",           CalcLogic:"",   Format:"IdNo",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"산재번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"indusInsurNo",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"추천담당자",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  SaveName:"spRecName",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"추천담당자연락처",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    SaveName:"spRecTel",          CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"추천담당자HP",			Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    SaveName:"spRecHp",           CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"추천담당자E-mail",		Type:"Text",      Hidden:0,  Width:220,  Align:"Left",    SaveName:"spRecEmail",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"apply_seq",			Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  SaveName:"applySeq" });

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction",
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
		createIBSheet2(container, 'listSheet', '100%', '575px');
		ibHeader.initSheet('listSheet');

		listSheet.SetEllipsis(1); 				// 말줄임 표시여부
		listSheet.SetEditable(1);
		listSheet.SetVisible(1);

		getList();
	}

	function listSheet_OnRowSearchEnd(row) {

		//소계
		var numSeq = listSheet.GetCellValue(row, "numSeq");

		if(numSeq > 1 && numSeq < 8) {
			if(numSeq == "2" || numSeq == "3") {
				listSheet.SetRowBackColor(row,"#E8FECD");//232,254,205
			}

			if(numSeq == "4" || numSeq == "5") {
				listSheet.SetRowBackColor(row,"#F5EACD");//245,234,205
			}

			if(numSeq == "6" || numSeq == "7") {
				listSheet.SetRowBackColor(row,"#DAE4D8");//218,228,216
			}

			listSheet.SetCellFont("FontBold", row, "spRecKindNmKey", 1);
			listSheet.SetCellFont("FontBold", row, "spRecOrgNm", 1);
			listSheet.SetCellFont("FontBold", row, "chkCntNm", 1);
			listSheet.SetCellFont("FontBold", row, "stateCntNm", 1);

			listSheet.SetCellEditable(row, "spRecOrgNm", 0);
			listSheet.SetCellEditable(row, "spRecName", 0);
			listSheet.SetCellEditable(row, "spRecEmail", 0);
		}

	}

	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/agg/selectTradeDaySpecialStatusList.do"
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

	//저장 처리
	function doSave() {

		if(isValid()) {

			if(confirm('저장하시겠습니까?')) {

				var jsonParam = $('#searchForm').serializeObject();
				var saveJson = listSheet.GetSaveJson();
				jsonParam.tradeDaySpecialStatusList = saveJson.data;

				global.ajax({
					type : 'POST'
					, url : '/tdms/agg/saveTradeDaySpecialStatus.do'
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

	}

	function isValid() {

		var saveJson = listSheet.GetSaveJson();
		var isChk = true;

		if (saveJson.data.length) {

			$.each(saveJson, function(key1, value1) {
				$.each(value1, function(key2, value2) {
					// 삭제는 삭제 대상이기 때문에 유효성을 체크하지 않는다.
					if (value2.status == 'U') {

						if (value2.spRecOrgNm.length > 30) {
							alert('추천기관 30자 이하로 입력해 주세요.');
							isChk = false;
						}

						if (value2.spRecName.length > 30) {
							alert('추천담당자는 2자 이하로 입력해 주세요.');
							isChk = false;
						}

						if ($.trim(value2.spRecEmail) != '' && !checkEmail(value2.spRecEmail)) {
							alert('이메일 형식이 올바르지 않습니다.');
							isChk = false;
						}

					}
				});
			});

		}else {
			alert('저장할 내용이 없습니다.');
			return false;
		}

		return isChk;
	}

	function doExcel() {
		downloadIbSheetExcel(listSheet, '특수유공현황_리스트', '');
	}

</script>