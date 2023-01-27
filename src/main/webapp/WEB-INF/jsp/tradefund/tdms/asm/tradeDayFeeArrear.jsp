<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value=""/>

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
						<input type="text" class="form_text" id="searchCompanyKor" name="searchCompanyKor" value="" onkeydown="onEnter(getList);" maxlength="30"/>
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
		setSheetHeader_tradeDayFeeArrearSheet();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_tradeDayFeeArrearSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"삭제",			Type:"DelCheck",  Hidden:0, Width:70,   Align:"Center",  ColMerge:1,   SaveName:"delCheck" });
        ibHeader.addHeader({Header:"Status",		Type:"Status",    Hidden:1, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"status" });
        //ibHeader.addHeader({Header:"권한구분",			Type:"Combo",     Hidden:0, Width:120,  Align:"Center",  ColMerge:1,   SaveName:"st", ComboCode: '${awd022Sheet.detailcd}' , ComboText: '${awd022Sheet.detailnm}' });
        ibHeader.addHeader({Header:"사용기간",			Type:"Date",      Hidden:0, Width:120,  Align:"Center",  ColMerge:1,   SaveName:"applyDate",    CalcLogic:"",   Format:"yyyy-MM-dd" });
        ibHeader.addHeader({Header:"무역업번호(ID)",	Type:"Text",      Hidden:0, Width:100,  Align:"Left",    ColMerge:1,   SaveName:"memberId",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"회사명",			Type:"Text",      Hidden:0, Width:130,  Align:"Left",    ColMerge:1,   SaveName:"companyKor",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"대표자",			Type:"Text",      Hidden:0, Width:80,   Align:"Center",  ColMerge:1,   SaveName:"presidentKor",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"이메일",			Type:"Text",      Hidden:0, Width:120,  Align:"Left",    ColMerge:1,   SaveName:"emEmailAddr",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"사업자번호",		Type:"Text",      Hidden:0, Width:120,  Align:"Left",    ColMerge:1,   SaveName:"enterRegNo",         CalcLogic:"",   Format:"SaupNo",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30, BackColor: '#F6F6F6' });
        ibHeader.addHeader({Header:"사유",			Type:"Text",      Hidden:0, Width:250,  Align:"Left",    ColMerge:1,   SaveName:"remark",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:200 });

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

	function doInsert() {
		var index = listSheet.DataInsert();
		// 편집시 컬럼 색깔 변경
		listSheet.SetCellBackColor(index, 'memberId', '#ffffff');
	}

	function doSave() {

		var jsonParam = $('#searchForm').serializeObject();
		var saveJson = listSheet.GetSaveJson();
		jsonParam.tradeDayFeeArrearList = saveJson.data;

		if(jsonParam.tradeDayFeeArrearList == '') {
			alert('저장 할 내용이 없습니다.');
			return false;
		}

		var chk = true;
		$(jsonParam.tradeDayFeeArrearList).each(function(i) {

			if($.trim(this.memberId) == '') {
				alert('무역업등록번호를 입력해주세요.');
				chk = false;
				return false;
			}

			//sheet에서 권한구분 combo 삭제하고 고정값으로 저장하기로 함
			this.st = 'C';	//List 에 st param 추가 -> 권한구분 : 신청기간이후등록 고정
		});

		if(!chk) return false;

		if(confirm('저장하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tdms/asm/saveTradeDayFeeArrear.do'
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

	function doDelete() {
		var jsonParam = {};
		var saveJson = listSheet.GetSaveJson({StdCol:1});
		jsonParam.tradeDayFeeArrearList = saveJson.data;

		if(jsonParam.tradeDayFeeArrearList == '') {
			alert('선택된것이 없습니다. 확인 후 진행 바랍니다.');
			return false;
		}

		if(confirm('삭제하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tdms/asm/deleteTradeDayFeeArrear.do'
				, data : JSON.stringify(jsonParam)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data) {
					getList();
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});

		}


	}

	// 목록 가져오기
	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDayFeeArrearList.do"
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

	}

</script>