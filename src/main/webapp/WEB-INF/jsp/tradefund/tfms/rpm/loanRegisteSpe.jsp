<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">
<input type="hidden" name="pageIndex"	id="pageIndex"  	value="<c:out value='${param.pageIndex}' 	default='1' />" />
<input type="hidden" id="systemMenuId" 	name="systemMenuId" value="0" />
<input type="hidden" id="authId" 		name="authId" 		value="0" />
<input type="hidden" id="statusChk"  	name="statusChk"	value="" />
<input type="hidden" id="svrId"     	name="svrId"		value="" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doSave();" 			class="btn_sm btn_primary">저장</a>
		<a href="javascript:doExcelBank();" 	class="btn_sm btn_primary">엑셀 다운</a>
		<a href="javascript:doExcelUpload();" 	class="btn_sm btn_primary">엑셀 업로드</a>
	</div>

	<div class="ml-15">
		<a href="javascript:resetProc();" 		class="btn_sm btn_secondary">초기화</a>
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
				<td colspan="3">
					<div class="field_set flex align_center">
						<span class="form_search w100p">
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>" />
							<input type="text" class="form_text " placeholder="기금융자" title="기금융자" id="searchTitle" name="searchTitle" maxlength="150" readonly="readonly" onkeydown="onEnter(doSearch);" value="<c:out value="${searchTitle}"/>" />
							<button class="btn_icon btn_search" title="기금융자 검색" onclick="goFundPopup()"></button>
						</span>
						<button type="button" class="ml-8" onclick="setEmptyValue('.fundPopup')" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
					</div>
				</td>
				<th scope="row">지역본부</th>
				<td>
					<select id="searchDeptCd" name="searchDeptCd" class="form_select"  >
						<option value="" >::: 전체 :::</option>
						<c:forEach var="item" items="${COM001}" varStatus="status">
							<option value="<c:out value="${item.chgCode01}"/>" <c:if test="${item.chgCode01 eq param.sTradeDept}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
						</c:forEach>
					</select>
				</td>
            </tr>
			<tr>
				<th scope="row">은행</th>
				<td>
					<select id="searchMainBankCd" name="searchMainBankCd" class="form_select">
						<option value="" >::: 전체 :::</option>
						<c:forEach var="item" items="${COM004}" varStatus="status">
							<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq param.sSt}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
						</c:forEach>
					</select>
				</td>

				<th scope="row">회사명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchCoNmKor" name="searchCoNmKor" value="<c:out value="${param.searchCoNmKor}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="회사명" maxlength="200" />
					</fieldset>
				</td>

				<th scope="row">무역업번호</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchBsNo" name="searchBsNo" value="<c:out value="${param.searchBsNo}"/>" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="무역업번호" maxlength="8" />
					</fieldset>
				</td>
            </tr>
			<tr>

				<th scope="row">사업자등록번호</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchIndustryNo" name="searchIndustryNo" value="<c:out value="${param.searchIndustryNo}"/>" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="사업자등록번호" maxlength="10" />
					</fieldset>
				</td>
				<th scope="row">대표자명</th>
				<td>

					<fieldset class="widget">
						<input type="text" id="searchCeoNmKor" name="searchCeoNmKor" value="<c:out value="${param.searchCeoNmKor}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="대표자명" maxlength="40" />
					</fieldset>
				</td>
				<th scope="row">접수번호</th>
				<td>

					<fieldset class="widget">
						<input type="text" id="searchApplyId" name="searchApplyId" value="<c:out value="${param.searchApplyId}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="접수번호" maxlength="30" />
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

	<%-- 	<fieldset class="ml-auto">
			<select id="pageUnit" name="pageUnit" title="목록수" class="form_select" onchange="doSearch();">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</fieldset> --%>
	</div>
	<div style="width: 100%;">
		<div id="sheet1" class="sheet"></div>
	</div>
<!-- 	<div id="paging" class="paging ibs"></div> -->
</div>

	<div style="width: 100%; height: 300px; display: none;" >
		<div id="excelSheet" class="sheet"></div>
	</div>

</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){
		initIBSheet();
		initIBExcelSheet();
	});

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"초기화",    	Type:"CheckBox",Hidden:false,  Width:70,   Align:"Center",  SaveName:"delCheck"                   });
        ibHeader.addHeader({Header:"Status",   	Type:"Status", 	Hidden:true,   Width:80,   Align:"Center",  SaveName:"status"                     });
        ibHeader.addHeader({Header:"접수번호",     Type:"Text",   	Hidden:false,  Width:90,   Align:"Left",    SaveName:"applyId",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호",   	Type:"Text",   	Hidden:false,  Width:80,   Align:"Left",    SaveName:"bsNo",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"회사명",     	Type:"Text",   	Hidden:false,  Width:150,  Align:"Left",    SaveName:"coNmKor",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
        ibHeader.addHeader({Header:"대표자",     	Type:"Text",   	Hidden:false,  Width:70,   Align:"Center",  SaveName:"ceoNmKor",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"사업자번호",   	Type:"Text",   	Hidden:false,  Width:100,  Align:"Center",  SaveName:"industryNo",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"지부명",     	Type:"Text",   	Hidden:false,  Width:150,  Align:"Left",    SaveName:"tradeDeptNm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
        ibHeader.addHeader({Header:"추천일",     	Type:"Text",   	Hidden:false,  Width:80,   Align:"Center",  SaveName:"recdDate",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"등급",      	Type:"Text",   	Hidden:false,  Width:50,   Align:"Center",  SaveName:"levelGb",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"금리",      	Type:"Text",   	Hidden:false,  Width:50,   Align:"Center",  SaveName:"interestRate",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"추천금액",    	Type:"AutoSum",	Hidden:false,  Width:100,  Align:"Right",   SaveName:"recdAmount",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자일",     	Type:"Date", 	Hidden:false,  Width:120,  Align:"Center",  SaveName:"recdDt",            CalcLogic:"",   Format:"yyyy-MM-dd" });
        ibHeader.addHeader({Header:"융자금",     	Type:"AutoSum",	Hidden:false,  Width:100,  Align:"Right",   SaveName:"defntAmount",       CalcLogic:"",   Format:"Integer" });
        ibHeader.addHeader({Header:"융자은행",    	Type:"Combo",  	Hidden:false,  Width:100,  Align:"Center",  SaveName:"mainBankCd",         ComboCode: "<c:out value="${saCOM004.detailcd}"/>", ComboText: "<c:out value="${saCOM004.detailnm}"/>"        });
        ibHeader.addHeader({Header:"융자지점명",   	Type:"Text",   	Hidden:false,  Width:130,  Align:"Left",    SaveName:"mainBankBranchNm", Ellipsis:true           });
        ibHeader.addHeader({Header:"사업자번호",   	Type:"Text",   	Hidden:true,   Width:50,   Align:"Left",    SaveName:"industryNoKey",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자은행코드", 	Type:"Text",   	Hidden:true,   Width:50,   Align:"Left",    SaveName:"mainBankNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"상환내역1",    Type:"Text",   	Hidden:true,   Width:50,   Align:"Left",    SaveName:"cntLoan1",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"상환내역2",    Type:"Text",   	Hidden:true,   Width:50,   Align:"Left",    SaveName:"cntLoan2",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"상환내역3",    Type:"Text",   	Hidden:true,   Width:50,   Align:"Left",    SaveName:"cntLoan3",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"비고",      	Type:"Text",   	Hidden:false,  Width:150,  Align:"Left",    SaveName:"fndMemo"          , Ellipsis:true          });

		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0,  statusColHidden: true, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "550px");
		ibHeader.initSheet(sheetId);

	}

	function initIBExcelSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"융자희망은행",  Type:"Text",      Hidden:false,  Width:200,  Align:"Left",    SaveName:"mainBankNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"지점",       	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    SaveName:"mainBankBranchNm",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"지부명",      Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    SaveName:"tradeDeptNm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"회사명",      Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    SaveName:"coNmKor",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자",      Type:"Text",      Hidden:false,  Width:70,   Align:"Center",  SaveName:"ceoNmKor",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"사업자등록번호",	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"industryNoNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"등급",       	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  SaveName:"levelGb",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"금리",       	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  SaveName:"interestRate",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"추천금액",    	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"recdAmount",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자일",     	Type:"Text",      Hidden:false,  Width:120,  Align:"Center",  SaveName:"recdDt",            CalcLogic:"",   Format:"" });
        ibHeader.addHeader({Header:"확정금액",    	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"defntAmount",       CalcLogic:"",   Format:"Integer" });
        ibHeader.addHeader({Header:"융자은행",    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"mainBankCd"         });
        ibHeader.addHeader({Header:"은행수",     	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"cnt"                });
        ibHeader.addHeader({Header:"비고",      	Type:"Text",      Hidden:false,  Width:120,  Align:"Center",  SaveName:"fndMemo",           CalcLogic:"",   Format:"" });

        ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var sheetId = "excelSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "550px");
		ibHeader.initSheet(sheetId);

	}

	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
	   sheet1.SetScrollTop(0);
	}

	//초기화
	function resetProc() {
		var f = document.form1;

		f.searchTitle.value = "";
		f.searchSvrId.value = "";
		setSelect(f.searchDeptCd, "");
		setSelect(f.searchMainBankCd, "");
		f.searchCoNmKor.value = "";
		f.searchBsNo.value = "";
		f.searchIndustryNo.value = "";
		f.searchApplyId.value = "";
		f.searchCeoNmKor.value = "";

		if( '${user.fundAuthType}' == 'ADMIN' ){
			f.searchTradeDept.value = '${searchTradeDept}';
		}else {
			f.searchTradeDept.options[0].selected = true;
		}
	}

	//조회
	function doSearch() {

		if($('#searchSvrId').val() == '' || $('#searchSvrId').val() == null) {
			alert('기금융자명을 선택해주세요.');
			return;
		} else {
			getList();
			getExcelList();
		}
	}

	//페이징 조회
/* 	function goPage(pageIndex) {
		var form = document.form1;
		form.pageIndex.value = pageIndex;
		geList();
	} */

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/selectLoanRegisteSpeList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

			/* 	setPaging(
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
					); */

				sheet1.LoadSearchData({Data: data.resultList});
			}
		});
	}

	//엑세 데이터 검색
	function getExcelList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/selectLoanRegisteSpeExcelList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				excelSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}


	//저장 처리
	function doSave() {

		var f = document.form1;

// 		if(f.searchSvrId.value == "" || f.searchSvrId.value == null){
		if(isStringEmpty(f.searchSvrId.value)){
			alert("기금융자명을 선택해주세요.");
			return;
		}


		var saveJson = sheet1.GetSaveJson();
		var ccf = getSaveDataSheetList('form1' , saveJson);

		if( saveJson.data.length == 0 ){
			alert('수정된 데이타가 존재하지 않습니다.');
			return ;
		}

		if(!sheetValueCheck()){
			return;
		}

		if(!confirm("저장하시겠습니까?")){
			return;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/saveLoanRegisteSpeList.do" />'
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


	//기금융자 검색
	function goFundPopup(){

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/lms/fundPopup.do" />'		//tfms/lms/popFundList.screen
			, params : {
				speChk : 'Y'
			}
			, callbackFunction : function(resultObj){
				$("input[name=searchSvrId]").val(resultObj.svrId);			//기금융자코드
				$("input[name=searchTitle]").val(resultObj.title);			//기금융자명
				getList();
				getExcelList();
			}
		});
	}


	//추천서 팝업
	function goSendFax(Row){
	    var f = document.form1;

		if(sheet1.GetCellValue(Row, "st") != '03') {
			alert("선정 업체만 FAX 발송 하실수 있습니다.");
			return;
		}

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/rpm/fundFaxSendPopup.do" />'		///tfms/rpm/FundFaxSend.screen
			, params : {
				 svrId : sheet1.GetCellValue(Row, "svrId")
			   , applyId : sheet1.GetCellValue(Row, "applyIdPw")
			}
			, callbackFunction : function(resultObj){
			}
		});
	}


	function doExcelBank(){

        var f = document.form1;
        var rowSkip = excelSheet.LastRow();
        var colSkip = "";
        var excelNm = f.searchTitle.value;

        if(excelSheet.RowCount() > 0){
        	downloadIbSheetExcel(excelSheet, excelNm , '');
        }else{
        	alert("다운로드 할 항목이 없습니다.");
        }
	}


	function doExcelUpload(){

		var f = document.form1;

		if(f.searchSvrId.value == "" || f.searchSvrId.value == null){
			alert("기금융자명을 선택해주세요.");
			return;
		}


		//var ColumnMapping = "0|0|0|0|4|5|6|3|0|0|0|9|10|11|1|2|0|1=>MAIN_BANK_NM|0|0|0|12";

		var ColumnMapping = "0|0|0|0|4|5|6|3|0|0|0|9|10|11|1|2|0|1|0|0|0|14";

		sheet1.LoadExcel({Mode:'HeaderMatch',WorkSheetNo:1, StartRow:1, ColumnMapping: ColumnMapping});

	}


	function sheetValueCheck(){

		var sheetObj = sheet1;


		if(sheetObj.RowCount() > 0){

			for(var i = 0; sheetObj.RowCount()+1 > i; i++){

				if(i == 0){
					i++;
				}

				if( (sheetObj.GetCellValue(i, "defntAmount") != 0 && sheetObj.GetCellValue(i, "defntAmount") != "" && sheetObj.GetCellValue(i, "recdDt") == "") ){
					alert("1차 융자일을 입력하세요.");
					sheetObj.selectCell(i, "recdDt");
					return false;
				}

				if((sheetObj.GetCellValue(i, "recdDt") != "" && (sheetObj.GetCellValue(i, "defntAmount") == "" || sheetObj.GetCellValue(i, "defntAmount") == 0) ) ){
					alert("1차 융자금액을 입력하세요.");
					sheetObj.selectCell(i, "defntAmount", true);
					return false;
				}

/*
				if( (sheetObj.GetCellValue(i, "defntAmount2") != 0 && sheetObj.GetCellValue(i, "defntAmount2") != "" && sheetObj.GetCellValue(i, "recdDt2") == "") ){
					alert("2차 융자일을 입력하세요.");
					sheetObj.selectCell(i, "recdDt2");
					return false;
				}

				if((sheetObj.GetCellValue(i, "recdDt2") != "" && (sheetObj.GetCellValue(i, "defntAmount2") == "" || sheetObj.GetCellValue(i, "defntAmount2") == 0) ) ){
					alert("2차 융자금액을 입력하세요.");
					sheetObj.selectCell(i, "defntAmount2", true);
					return false;
				}

				if( (sheetObj.GetCellValue(i, "defntAmount3") != 0 && sheetObj.GetCellValue(i, "defntAmount3") != "" && sheetObj.GetCellValue(i, "recdDt3") == "") ){
					alert("3차 융자일을 입력하세요.");
					sheetObj.selectCell(i, "recdDt2");
					return false;
				}

				if((sheetObj.GetCellValue(i, "recdDt3") != "" && (sheetObj.GetCellValue(i, "defntAmount3") == "" || sheetObj.GetCellValue(i, "defntAmount3") == 0) ) ){
					alert("3차 융자금액을 입력하세요.");
					sheetObj.selectCell(i, "defntAmount3", true);
					return false;
				}
*/
				if(sheetObj.GetCellValue(i, "recdDt") != ""){

					if(parseFloat(sheetObj.GetCellValue(i, "recdDt").substring(4, 6)) > 12 || parseFloat(sheetObj.GetCellValue(i, "recdDt").substring(4, 6)) <= 0){

						alert("월은 1~12 까지 입력가능합니다.");
						sheetObj.selectCell(i, "recdDt");
						return false;

					}else{

						if(sheetObj.GetCellValue(i, "recdDt").substring(6, 8) > dlgLastDay(sheetObj.GetCellValue(i, "recdDt").substring(0, 6)) ){
							alert(sheetObj.GetCellValue(i, "recdDt").substring(0, 4)+"년 "+sheetObj.GetCellValue(i, "recdDt").substring(4, 6)+"월은 "+dlgLastDay(sheetObj.GetCellValue(i, "recdDt").substring(0, 6))+"일 까지 있습니다.");
							sheetObj.selectCell(i, "recdDt");
							return false;
						}else if(sheetObj.GetCellValue(i, "recdDt").length != 8){
							alert("날짜를 제대로 입력해주세요");
							sheetObj.selectCell(i, "recdDt");
							return false;
						}

					}

				}
/*
				if(sheetObj.GetCellValue(i, "recdDt2") != ""){

					if(parseFloat(sheetObj.GetCellValue(i, "recdDt2").substring(4, 6)) > 12 || parseFloat(sheetObj.GetCellValue(i, "recdDt2").substring(4, 6)) <= 0){

						alert("월은 1~12 까지 입력가능합니다.");
						sheetObj.selectCell(i, "recdDt2");
						return false;

					}else{

						if(sheetObj.GetCellValue(i, "recdDt2").substring(6, 8) > dlgLastDay(sheetObj.GetCellValue(i, "recdDt2").substring(0, 6)) ){
							alert(sheetObj.GetCellValue(i, "recdDt2").substring(0, 4)+"년 "+sheetObj.GetCellValue(i, "recdDt2").substring(4, 6)+"월은 "+dlgLastDay(sheetObj.GetCellValue(i, "recdDt2").substring(0, 6))+"일 까지 있습니다.");
							sheetObj.selectCell(i, "recdDt2");
							return false;
						}else if(sheetObj.GetCellValue(i, "recdDt2").length != 8){
							alert("날짜를 제대로 입력해주세요");
							sheetObj.selectCell(i, "recdDt2");
							return false;
						}

					}

				}

				if(sheetObj.GetCellValue(i, "recdDt3") != ""){

					if(parseFloat(sheetObj.GetCellValue(i, "recdDt3").substring(4, 6)) > 12 || parseFloat(sheetObj.GetCellValue(i, "recdDt3").substring(4, 6)) <= 0){

						alert("월은 1~12 까지 입력가능합니다.");
						sheetObj.selectCell(i, "recdDt3");
						return false;

					}else{

						if(sheetObj.GetCellValue(i, "recdDt3").substring(6, 8) > dlgLastDay(sheetObj.GetCellValue(i, "recdDt3").substring(0, 6)) ){
							alert(sheetObj.GetCellValue(i, "recdDt3").substring(0, 4)+"년 "+sheetObj.GetCellValue(i, "recdDt3").substring(4, 6)+"월은 "+dlgLastDay(sheetObj.GetCellValue(i, "recd_dt3").substring(0, 6))+"일 까지 있습니다.");
							sheetObj.selectCell(i, "recdDt3");
							return false;
						}else if(sheetObj.GetCellValue(i, "recdDt3").length != 8){
							alert("날짜를 제대로 입력해주세요");
							sheetObj.selectCell(i, "recdDt3");
							return false;
						}

					}

				}
*/
				if(sheetObj.GetCellValue(i, "defntAmount") == ""){
					sheetObj.SetCellValue(i, "defntAmount", 0);
				}
/*
				if(sheetObj.GetCellValue(i, "defntAmount2") == ""){
					sheetObj.SetCellValue(i, "defntAmount2", 0);
				}

				if(sheetObj.GetCellValue(i, "DEFNT_AMOUNT3") == ""){
					sheetObj.SetCellValue(i, "defntAmount3", 0);
				}
*/
// 				if(sheetObj.GetCellValue(i, "defntAmount") != 0 && sheetObj.GetCellValue(i, "defntAmount") != ""){

// 					if(parseFloat(sheetObj.GetCellValue(i, "defntAmount")) > parseFloat(sheetObj.GetCellValue(i, "recdAmount"))){
// 						alert("융자금이 추천금액보다 많을 수 없습니다.");
// 						sheetObj.selectCell(i, "defntAmount");
// 						return false;
// 					}

// 				}
/*
				if(sheetObj.GetCellValue(i, "defntAmount2") != 0 && sheetObj.GetCellValue(i, "defntAmount2") != ""){

					if(parseFloat(sheetObj.GetCellValue(i, "defntAmount2")) > parseFloat(sheetObj.GetCellValue(i, "recdAmount"))){
						alert("2차 융자금이 추천금액보다 많을 수 없습니다.");
						sheetObj.selectCell(i, "defntAmount2");
						return false;
					}

				}

				if(sheetObj.GetCellValue(i, "defntAmount3") != 0 && sheetObj.GetCellValue(i, "defntAmount3") != ""){

					if(parseFloat(sheetObj.GetCellValue(i, "defntAmount3")) > parseFloat(sheetObj.GetCellValue(i, "recdAmount"))){
						alert("3차 융자금이 추천금액보다 많을 수 없습니다.");
						sheetObj.selectCell(i, "defntAmount3");
						return false;
					}

				}
*/
				if( parseFloat(sheetObj.GetCellValue(i, "defntAmount"))  > parseFloat(sheetObj.GetCellValue(i, "recdAmount")) ){
					alert(i+"번째 행 융자금이 추천금액 보다 많을 수 없습니다.");
					//sheetObj.selectCell(i, "defntAmount" );
					return false;
				}

			}

		}

		return true;

	}

	function sheet1_OnLoadExcel(result, code, msg) {

		if(sheet1.LastRow()>1){
			for(var i = 1; i<= sheet1.LastRow(); i++){

				sheet1.SetCellEditable(i, "delCheck", 		false);
				sheet1.SetCellEditable(i, "applyId", 		false);
				sheet1.SetCellEditable(i, "bsNo", 			false);
				sheet1.SetCellEditable(i, "coNmKor", 		false);
				sheet1.SetCellEditable(i, "ceoNmKor", 		false);
				sheet1.SetCellEditable(i, "coTelNum", 		false);
				sheet1.SetCellEditable(i, "industryNo", 	false);
				sheet1.SetCellEditable(i, "tradeDeptNm", 	false);
				sheet1.SetCellEditable(i, "recdAmount", 	false);
				sheet1.SetCellEditable(i, "recdDate", 		false);
				sheet1.SetCellEditable(i, "levelGb", 		false);
				sheet1.SetCellEditable(i, "interestRate", 	false);

			}
		}
	}


	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		var sName = sheet1.ColSaveName(Col);

		if(sName == "mainBankCd"){
			sheet1.SetCellValue(Row, "mainBankNm", sheet1.GetCellText(Row, "mainBankCd"));
		}
	}


	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
		}
	}

	function sheet1_OnSearchEnd(code, msg) {

		with(sheet1) {
			for(var i=1; i<=LastRow(); i++){

				if(parseFloat(GetCellValue(i , "cntLoan1")) > 0 ){

					SetCellEditable(i, "delCheck", 			false);
					SetCellEditable(i, "recdDt", 			false);
					SetCellEditable(i, "defntAmount", 		false);
					SetCellEditable(i, "mainBankCd", 		false);
					SetCellEditable(i, "mainBankBranchNm",	false);

					//RowEditable(i) = false;
					SetCellBackColor(i, 'delCheck', '#f6f6f6');
					SetCellBackColor(i, 'recdDt', '#f6f6f6');
					SetCellBackColor(i, 'defntAmount', '#f6f6f6');
					SetCellBackColor(i, 'mainBankCd', '#f6f6f6');
					SetCellBackColor(i, 'mainBankBranchNm', '#f6f6f6');

				}

// 				if(parseFloat(GetCellValue(i , "cntLoan2")) > 0 ){

// 					SetCellEditable(i, "delCheck", 			false);
// 					SetCellEditable(i, "recdDt2", 			false);
// 					SetCellEditable(i, "defntAmount2", 		false);
// 					SetCellEditable(i, "mainBankCd", 		false);
// 					SetCellEditable(i, "mainBankBranchNm", 	false);

// 					SetCellBackColor(i, 'delCheck', '#f6f6f6');
// 					SetCellBackColor(i, 'recdDt2', '#f6f6f6');
// 					SetCellBackColor(i, 'defntAmount2', '#f6f6f6');
// 					SetCellBackColor(i, 'mainBankCd', '#f6f6f6');
// 					SetCellBackColor(i, 'mainBankBranchNm', '#f6f6f6');
// 				}

// 				if(parseFloat(GetCellValue(i , "cntLoan3")) > 0 ){

// 					SetCellEditable(i, "delCheck", 			false);
// 					SetCellEditable(i, "recdDt3", 			false);
// 					SetCellEditable(i, "defntAmount3", 		false);
// 					SetCellEditable(i, "mainBankCd", 		false);
// 					SetCellEditable(i, "mainBankBranchNm", 	false);

// 					SetCellBackColor(i, 'delCheck', '#f6f6f6');
// 					SetCellBackColor(i, 'recdDt3', '#f6f6f6');
// 					SetCellBackColor(i, 'defntAmount3', '#f6f6f6');
// 					SetCellBackColor(i, 'mainBankCd', '#f6f6f6');
// 					SetCellBackColor(i, 'mainBankBranchNm', '#f6f6f6');

// 				}

			}
		}
    }

	function sheet1_OnRowSearchEnd(row) {
	   // 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
	   notEditableCellColor('sheet1', row);
	   // 편집시 컬럼 색깔 변경

	}

</script>