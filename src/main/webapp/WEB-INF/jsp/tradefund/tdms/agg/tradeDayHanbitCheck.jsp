<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value=""/>
<input type="hidden" id="bsnAplDt" name="bsnAplDt" value="<c:out value="${bsnAplDt}"/>"/>
<input type="hidden" id="state" name="state" value="<c:out value="${state}"/>"/>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doInsert();" class="btn_sm btn_primary btn_modify_auth">추가</button>
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doExcel();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="getList();" class="btn_sm btn_primary">검색</button>
		<button type="button" onclick="clearForm('foldingTable_inner');" class="btn_sm btn_secondary">초기화</button>
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
					<th>구분</th>
					<td>
						<select class="form_select" id="searchHanbitGb" name="searchHanbitGb">
							<option value="">전체</option>
							<c:forEach items="${awd031Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>업체명</th>
					<td>
						<input type="text" class="form_text" id="searchCompanyKor" name="searchCompanyKor" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
					<th>회원명</th>
					<td>
						<input type="text" class="form_text" id="searchHanbitUsernm" name="searchHanbitUsernm" value="" onkeydown="onEnter(getList);" maxlength="30"/>
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
		setSheetHeader_tradeDayHanbitCheckSheet();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_tradeDayHanbitCheckSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"삭제",			Type:"DelCheck",  Hidden:0, Width:60,   Align:"Center",  ColMerge:1,   SaveName:"delCheck" });
        ibHeader.addHeader({Header:"상태",			Type:"Status",    Hidden:1, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"status" });
        ibHeader.addHeader({Header:"seq",			Type:"Text",      Hidden:1, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"seqId" });
        ibHeader.addHeader({Header:"구분",			Type:"Combo",     Hidden:0, Width:190,  Align:"Left",    ColMerge:1,   SaveName:"hanbitGb",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, ComboCode: '${awd031Sheet.detailcd}' , ComboText: '${awd031Sheet.detailnm}' });
        ibHeader.addHeader({Header:"무역업등록번호",		Type:"Text",      Hidden:0, Width:130,  Align:"Left",    ColMerge:1,   SaveName:"memberId",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"업체명",			Type:"Text",      Hidden:0, Width:280,  Align:"Left",    ColMerge:1,   SaveName:"companyKor",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"회원명",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"hanbitUsernm",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직위",			Type:"Text",      Hidden:0, Width:80,   Align:"Left",    ColMerge:1,   SaveName:"pos",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"한빛회직위",		Type:"Text",      Hidden:0, Width:140,  Align:"Left",    ColMerge:1,   SaveName:"hanbitPos",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"구분",			Type:"Text",      Hidden:1, Width:40,   Align:"Left",    ColMerge:1,   SaveName:"hHanbitGb",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30 });

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
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true, HeaderCheck: 0});

		var container = $('#listSheet')[0];
		createIBSheet2(container, 'listSheet', '100%', '560px');
		ibHeader.initSheet('listSheet');

		listSheet.SetEllipsis(1); 				// 말줄임 표시여부
		listSheet.SetEditable(1);
		listSheet.SetVisible(1);

		getList();
	}

	function listSheet_OnSort(col, order) {
		listSheet.SetScrollTop(0);
	}

	function listSheet_OnClick(row, col, value) {
		if(row > 0) {
			if (listSheet.GetCellValue(row, 'delCheck') == 1) {
				listSheet.SetCellBackColor(row, 'hanbitGb', '#f6f6f6');
				listSheet.SetCellBackColor(row, 'hanbitUsernm', '#f6f6f6');
				listSheet.SetCellBackColor(row, 'pos', '#f6f6f6');
				listSheet.SetCellBackColor(row, 'hanbitPos', '#f6f6f6');
			} else {
				listSheet.SetCellBackColor(row, 'hanbitGb', '#ffffff');
				listSheet.SetCellBackColor(row, 'hanbitUsernm', '#ffffff');
				listSheet.SetCellBackColor(row, 'pos', '#ffffff');
				listSheet.SetCellBackColor(row, 'hanbitPos', '#ffffff');
			}
		}
	}

	// 목록 가져오기
	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/agg/selectTradeDayHanbitCheckList.do"
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

	function doExcel() {
		downloadIbSheetExcel(listSheet, '한빛회이사회_리스트', '');
	}

	function doInsert() {
		var index = listSheet.DataInsert();
	}

	function doSave() {

		var jsonParam = $('#searchForm').serializeObject();
		var saveJson = listSheet.GetSaveJson();
		jsonParam.tradeDayHanbitCheckList = saveJson.data;

		if(jsonParam.tradeDayHanbitCheckList == '') {
			alert('저장할 내용이 없습니다.');
			return false;
		}

		var chk = true;
		$(jsonParam.tradeDayHanbitCheckList).each(function(i) {

			if($.trim(this.memberId) == ''){
				alert('무역업등록번호를 입력해 주세요.');
				chk = false;
				return false;
			}

		});

		if(!chk) return false;

		if(confirm('저장하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tdms/agg/saveTradeDayHanbitCheck.do'
				, data : JSON.stringify(jsonParam)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data){
					if(data.succYn == 'Y') {
						getList();
					}else {
						alert(data.message);
					}
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});

		}

	}//doSave

</script>