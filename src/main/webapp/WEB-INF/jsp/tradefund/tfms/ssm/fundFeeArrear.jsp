<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">

<input type="hidden" name="svrId" value="<c:out value="${searchSvrId}"/>" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doInsert();" 		class="btn_sm btn_primary btn_modify_auth">추가</a>
		<a href="javascript:doSave();" 			class="btn_sm btn_primary btn_modify_auth">저장</a>
		<a href="javascript:doDelete();" 		class="btn_sm btn_secondary btn_modify_auth">삭제</a>
	</div>

	<div class="ml-15">
		<a href="javascript:doClear();" 		class="btn_sm btn_secondary">초기화</a>
		<a href="javascript:doSearch();" 		class="btn_sm btn_primary">검색</a>
	</div>
</div>

<div class="cont_block">

<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">기금융자 명</th>
				<td>
					<div class="field_set flex align_center">
						<span class="form_search w100p fundPopup">
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>" />
							<input type="text" class="form_text " placeholder="기금융자" title="기금융자" id="searchTitle" name="searchTitle" maxlength="150" readonly="readonly" onkeydown="onEnter(doSearch);" value="<c:out value="${searchTitle}"/>" />
							<button class="btn_icon btn_search" title="기금융자 검색" onclick="goFundPopup()"></button>
						</span>
						<%-- <button type="button" class="ml-8" onclick="doClear()" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button> --%>
					</div>
				</td>
				<th scope="row">무역업번호</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchBsNo" name="searchBsNo" value="<c:out value="${param.searchBsNo}"/>" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="무역업번호" maxlength="8" />
					</fieldset>
				</td>
				<th scope="row">업체명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchCreNm" name="searchCreNm" value="<c:out value="${param.searchCreNm}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="업체명"  maxlength="200" />
					</fieldset>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->

<div class="cont_block mt-20">
	<div class="tbl_opt">
		<!-- 전체 게시글 -->
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div style="width: 100%;">
		<div id="sheet1" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>

</div>

</form>

<script type="text/javascript">
        var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header:"선택"	,		Type:"DelCheck",  Hidden:false, Width:30,   Align:"Center",     SaveName:"delCheck" });
        ibHeader.addHeader({Header:"Status",	Type:"Status",    Hidden:true,  Width:80,   Align:"Center",     SaveName:"status" });
        ibHeader.addHeader({Header:"권한구분",		Type:"Combo",     Hidden:false, Width:50,   Align:"Center",     SaveName:"st", ComboCode: "<c:out value="${saLMS004.detailcd}"/>", ComboText: "<c:out value="${saLMS004.detailnm}"/>"  });
        ibHeader.addHeader({Header:"사용기간",		Type:"Date", 	  Hidden:false, Width:50,   Align:"Center",     SaveName:"applyDate",    CalcLogic:"",   Format:"Ymd" });
        ibHeader.addHeader({Header:"무역업번호",	Type:"Text",      Hidden:false,  Width:60,   Align:"Left",      SaveName:"memberId",     CalcLogic:"",   Format:"",            PointCount:false,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"대표아이디",	Type:"Text",      Hidden:false,  Width:60,   Align:"Left",      SaveName:"userId",       CalcLogic:"",   Format:"",            PointCount:false,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
        ibHeader.addHeader({Header:"사업자등록번호",	Type:"Text",      Hidden:false,  Width:60,   Align:"Left",       SaveName:"enterRegNo",  CalcLogic:"",   Format:"",            PointCount:false,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
        ibHeader.addHeader({Header:"업체명",      Type:"Text",      Hidden:false,  Width:130,  Align:"Left",      SaveName:"coNmKor",     CalcLogic:"",   Format:"",            PointCount:false,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자명",		Type:"Text",      Hidden:false,  Width:50,   Align:"Center",    SaveName:"ceoNmKor",    CalcLogic:"",   Format:"",            PointCount:false,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
        ibHeader.addHeader({Header:"사유",       Type:"Text",      Hidden:false,  Width:250,  Align:"Left",      SaveName:"fnMemo",       CalcLogic:"",   Format:"",            PointCount:false,   UpdateEdit:true,   InsertEdit:true,   EditLen:200 });
        ibHeader.addHeader({Header:"등록자",      Type:"Text",      Hidden:false,  Width:50,   Align:"Center",    SaveName:"creNm",        CalcLogic:"",   Format:"",            PointCount:false,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
        ibHeader.addHeader({Header:"svr_id",	Type:"Text",      Hidden:true, Width:50,   Align:"Center",      SaveName:"svrId",        CalcLogic:"",   Format:"",            PointCount:false,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
        ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1, UseHeaderSortCancel: 1, MaxSort: 1});
        ibHeader.setHeaderMode({ Sort:1, ColMove:false, HeaderCheck:false, ColResize:false });

	$(document).ready(function(){
		var container = $('#sheet1')[0];
		createIBSheet2(container, 'sheet1', '100%', '100%');
		ibHeader.initSheet('sheet1');
		getList();
	});

	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
	   sheet1.SetScrollTop(0);
	}

	//조회
	function doSearch() {
		var f = document.form1;

		if(f.searchSvrId.value == "" || f.searchSvrId.value == null){
			alert("기금융자 명을 선택해 주세요");
			return;
		}else{
			getList();
		}

	}

	//추가입력
	function doInsert() {
		var rowIndex = sheet1.DataInsert(0);
		sheet1.SetCellEditable(rowIndex, "memberId", true);
		sheet1.SetCellValue(rowIndex, "st", "C" );
	}

	//저장
	function doSave() {
		var f = document.form1;
		var checkCount = 0;

		var saveJson = sheet1.GetSaveJson({StdCol:"memberId"});
		var ccf = getSaveDataSheetList('form1' , saveJson);

		for( var i = 1 ; i <= sheet1.RowCount(); i++){
			if(sheet1.GetCellValue(i, "status") == "I"){
				if(sheet1.GetCellValue(i, "memberId") == "" || sheet1.GetCellValue(i, "memberId") == null){
					alert("무역업번호를 입력하세요.");
					sheet1.SelectCell(i, "memberId");
					return;
				}

				if(sheet1.GetCellValue(i, "status") == "I" ){
					checkCount++;
				}
			}

			if (sheet1.GetCellValue(i, "status") == "U"){
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
			, url : '<c:url value="/tfms/ssm/fundFeeArrearSave.do" />'
			, data : JSON.stringify(ccf)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				alert('저장되었습니다.');
				doSearch();
			}
		});
	}


	//삭제
	function doDelete() {
		var f = document.form1;
		var checkCount = 0;

		var saveJson = sheet1.GetSaveJson({StdCol:"status"});
		var ccf = getSaveDataSheetList('form1' , saveJson);

		for( var i = 1 ; i <= sheet1.RowCount(); i++){
			if(sheet1.GetCellValue(i, "delCheck") == "1" ){
				checkCount ++;
			}
		}

		if ( checkCount <= 0){
			alert("선택된 자료가 없습니다.");
			return;
		}

		if(!confirm("삭제하시겠습니까?")){
			return;
		}

 		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/fundFeeArrearDelete.do" />'
			, data : JSON.stringify(ccf)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				alert('삭제되었습니다.');
				doSearch();
			}
		});
	}

	//초기화
	function doClear(){
		var f = document.form1;
		f.searchBsNo.value = "";
		f.searchCreNm.value = "";

	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/selectFundFeeArrear.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');
				sheet1.LoadSearchData({Data: data.resultList});
			}
		});
	}

	// ibsheet 검색 완료후 edit옵션별 cell색상 변경
 	function sheet1_OnRowSearchEnd(row) {
		notEditableCellColor('sheet1', row);
	}

	//기금융자 검색
	function goFundPopup(){
		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/lms/fundPopup.do?speChk=A" />'		//tfms/lms/popFundList.screen
			, callbackFunction : function(resultObj){
				$("input[name=searchSvrId]").val(resultObj.svrId);		//기금융자코드
				$("input[name=searchTitle]").val(resultObj.title);		//기금융자명
				getList();
			}
		});
	}


</script>