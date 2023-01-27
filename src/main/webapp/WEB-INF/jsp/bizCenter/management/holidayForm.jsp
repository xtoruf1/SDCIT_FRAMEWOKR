<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<form id="form1" name="form1" method="post"  onsubmit="return false;">
<input type="hidden" id="year" name="year" value="<c:out value="${year}" />"/>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="addRow()" class="btn_sm btn_primary bnt_modify_auth">신규</button>
		<button type="button" onclick="doSave()" class="btn_sm btn_primary bnt_modify_auth">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doClear()" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="getList()" class="btn_sm btn_primary">검색</button>
	</div>
</div>

<table class="formTable">
	<colgroup>
		<col style="width:12%">
		<col>
	</colgroup>
	<tbody>
		<tr>
			<th scope="row">년도</th>
			<td>
				<div class="form_row w10p">
					<select id="hdayYear" name="hdayYear" class="form_select" onchange="changeYear()">
						    <fmt:parseNumber value="${year}" type="number" var="intYear"/>
						    <option value="" >::: 전체 :::</option>
							<option value="<c:out value="${intYear + 1}" />"> <c:out value="${intYear + 1}" /> </option>

						<c:forEach var="i" begin="2017" end="${intYear}" step="1">
							<option value="<c:out value="${intYear - i + 2017}" />" <c:if test="${intYear - i + 2017 == year}">selected</c:if>>
									<c:out value="${intYear -i + 2017}" />
							</option>
						</c:forEach>
					</select>
				</div>
			</td>
		</tr>
	</tbody>
</table>

<div class="cont_block">
	<div class="cont_block mt-20">
		<div class="tbl_opt">
			<div id="totalCnt" class="total_count"></div>
		</div>
		<div style="width: 100%;">
			<div id="sheet1" class="sheet"></div>
		</div>
	</div>
</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){
		initIBSheet();
		getList();
	});

	function initIBSheet() {
        var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header:"삭제",		Type:"DelCheck",  Hidden:false, Width:2, Align:"Center", SaveName:"delCheck", HeaderCheck:false, });
        ibHeader.addHeader({Header:"Status",	Type:"Status",    Hidden:true,  Width:4, Align:"Center", SaveName:"status" });
        ibHeader.addHeader({Header:"날짜",		Type:"Date",      Hidden:false, Width:5, Align:"Center", SaveName:"hdayYmd", Format:"yyyy-MM-dd", EditLen:10 });
        ibHeader.addHeader({Header:"휴일명",	Type:"Text",      Hidden:false, Width:50, Align:"Left", SaveName:"hdayName", UpdateEdit:true,   InsertEdit:true, EditLen: 30 	 });
        ibHeader.addHeader({Header:"원본key",	Type:"Text",      Hidden:true,  Width:5, Align:"Center", SaveName:"orgKey" });

        ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
        ibHeader.setHeaderMode({ Sort:0, ColMove:false, HeaderCheck:false, ColResize:false });

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/bizCenter/management/holidayList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');
				sheet1.LoadSearchData({Data: data.resultList, Sync: 1}, {Wait: 0});

			}
		});
	}

	//신규
	function addRow(){
		var rowIndex = sheet1.DataInsert(0);
	}

	//저장
	function doSave() {
		var f = document.form1;
		var checkCount = 0;

		var saveJson = sheet1.GetSaveJson({StdCol:"hdayYmd"});
		var ccf = getSaveDataSheetList('form1' , saveJson);

		for( var i = 1 ; i <= sheet1.RowCount(); i++){
			if(sheet1.GetCellValue(i, "status") == "I" || sheet1.GetCellValue(i, "status") == "U" ){
				if(sheet1.GetCellValue(i, "hdayYmd") == "" || sheet1.GetCellValue(i, "hdayYmd") == null){
					alert("일자를 입력하세요.");
					sheet1.SelectCell(i, "hdayYmd");
					return;
				}
				checkCount++;
			}
			if(sheet1.GetCellValue(i, "status") == "D" ){
				checkCount++;
			}
		}

		if ( checkCount <= 0){
			alert("저장할 내용이 없습니다. ");
			return;
		}

		if(!confirm("저장하시겠습니까?")){
			return;
		}

 		global.ajax({
			type : 'POST'
			, url : '<c:url value="/bizCenter/management/holidaySave.do" />'
			, data : JSON.stringify(ccf)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				getList();
			}
		});
	}

	//초기화
	function doClear(){
		var f = document.form1;
		f.hdayYear.value = ${year};
		getList();
	}

	function changeYear() {
		var changeY = $("#hdayYear").val();
		var f = document.form1;
		f.hdayYear.value = changeY;
		getList();

	}

	// ibsheet 로딩중 이벤트
	function sheet1_OnLoadData(data) {
		var jsonData = $.parseJSON(data);
		var newObj = {};
		newObj = $.extend(newObj, jsonData);
		var rowdata = newObj.Data;
		rowdata.forEach(function(item, index){
			var keyValue = item.hdayYmd;
			newObj.Data[index].orgKey = keyValue;
		});
		return newObj;
	}

	// ibsheet 검색 완료후 edit옵션별 cell색상 변경
 	function sheet1_OnRowSearchEnd(row) {
		notEditableCellColor('sheet1', row);

		var dateChk = sheet1.GetCellValue(row , "hdayYmd");
		if( dateChk == null || dateChk == "" ){
			//sheet1.SetCellValue(row, 'hdayName', "존재하지 않는 일자 입니다." );
			//sheet1.SetCellValue(row, "delCheck", true);
		}
	}

</script>