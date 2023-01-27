<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">
<input type="hidden" id="systemMenuId" 	name="systemMenuId" value="0" />
<input type="hidden" id="authId" 		name="authId" 		value="0" />

<input type="hidden" id="statusChk"  	name="statusChk"	value="" />
<input type="hidden" id="svrId"     	name="svrId"		value="<c:out value="${svrMaxVo.svrId}"/>" />
<input type="hidden" id="deptCd"     	name="deptCd"		value="<c:out value="${user.fundDeptCd}"/>" />
<input type="hidden" id="deptNm"     	name="deptNm"		value="<c:out value="${user.fundDeptNm}"/>" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">

		<c:if test='${user.fundDeptCd ne ""}'>
			<a href="javascript:doDeadine();" 		class="btn_sm btn_primary bnt_modify_auth">지부마감</a>
		</c:if>
		<a href="javascript:doSendPopup();" 		class="btn_sm btn_primary bnt_modify_auth">발송</a>
<!--
		<a href="javascript:doSendFax();" 		class="btn_sm btn_primary">팩스발송</a>
		<a href="javascript:doSendMms();" 		class="btn_sm btn_primary">문자발송</a>
		<a href="javascript:doSendMail();" 		class="btn_sm btn_primary">메일발송</a>
 -->
	</div>
	<div class="ml-15">
		<a href="javascript:doExcel();" 		class="btn_sm btn_primary">엑셀 다운</a>
		<a href="javascript:doClear();" 		class="btn_sm btn_secondary">초기화</a>
		<a href="javascript:doSearch();" 		class="btn_sm btn_primary">검색</a>
	</div>
</div>

<div class="cont_block">

<!--검색 시작 -->
<div class="foldingTable fold">
	<div class="foldingTable_inner">
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
						<span class="form_search w100p fundPopup">
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>" />
							<input type="text" class="form_text " placeholder="기금융자" title="기금융자" id="searchTitle" name="searchTitle" maxlength="150" readonly="readonly" onkeydown="onEnter(doSearch);" value="<c:out value="${searchTitle}"/>" />
							<button type="button" class="btn_icon btn_search" title="기금융자 검색" onclick="goFundPopup()"></button>
						</span>
						<button type="button" class="ml-8" onclick="setEmptyValue('.fundPopup')" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
					</div>
				</td>
				<th scope="row">마감여부</th>
				<td>
					<input type="hidden" id="deadineSt" name="deadineSt" value="<c:out value="${svrMaxVo.deadineSt}"/>" />
					<div id="deadineStNm"><c:out value="${svrMaxVo.deadineStNm}"/></div>
				</td>
            </tr>
			<tr>
				<th scope="row">지역본부</th>
				<td>
				<fieldset class="widget">
					<select id="searchTradeDept" name="searchTradeDept" class="form_select"  >
						<c:if test='${user.fundAuthType eq "ADMIN"}'>
							<option value="" >::: 전체 :::</option>
						</c:if>

						<c:forEach var="item" items="${COM001}" varStatus="status">
						<c:if test='${user.fundAuthType eq "ADMIN"}'>
							<option value="<c:out value="${item.chgCode01}"/>"><c:out value="${item.detailnm}"/></option>
						</c:if>

						<c:if test='${user.fundAuthType ne "ADMIN"}'>
							<c:if test="${item.chgCode01 eq searchTradeDept}"> >
								<option value="<c:out value="${item.chgCode01}"/>" <c:if test="${item.chgCode01 eq searchTradeDept}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:if>
						</c:if>
						</c:forEach>
					</select>
				</fieldset>
				</td>

				<th scope="row">처리결과</th>
				<td>
					<fieldset class="widget">
						<select id="searchSt" name="searchSt" class="form_select" style="width: 100px;">
							<option value="" >::: 전체 :::</option>
							<c:forEach var="item" items="${LMS003}" varStatus="status">
								<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq param.searchSt}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
					</fieldset>
				</td>
				<th scope="row">발송여부</th>
				<td>
					<fieldset class="widget">
						<select id="searchRecoSendYn" name="searchRecoSendYn" class="form_select"  style="width: 100px;">
							<option value="" >::: 전체 :::</option>
							<c:forEach var="item" items="${SSM001}" varStatus="status">
								<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq param.searchRecoSendYn}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
					</fieldset>
				</td>
            </tr>
			<tr>
				<th scope="row">회사명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchCoNmKor" name="searchCoNmKor" value="<c:out value="${param.searchCoNmKor}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="회사명" maxlength="200" />
					</fieldset>
				</td>
				<th scope="row">무역업번호</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchBsNo" name="searchBsNo" value="<c:out value="${param.searchBsNo}"/>" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeydown="onEnter(doSearch);"  class="textType form_text w100p" title="무역업번호" maxlength="8" />
					</fieldset>
				</td>
				<th scope="row">사업자등록번호</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchIndustryNo" name="searchIndustryNo" value="<c:out value="${param.searchIndustryNo}"/>" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="사업자등록번호" maxlength="10" />
					</fieldset>
				</td>

            </tr>
            <tr>
           	 	<th scope="row">대표자명</th>
				<td>

					<fieldset class="widget">
						<input type="text" id="searchCeoNmKor" name="searchCeoNmKor" value="<c:out value="${param.searchCeoNmKor}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="대표자명" maxlength="40" />
					</fieldset>
				</td>
           	 	<th scope="row">접수번호</th>
				<td>
					<fieldset class="widget" >
						<input type="text" id="searchApplyId" name="searchApplyId" value="<c:out value="${param.searchApplyId}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="접수번호" placeholder="접수번호" maxlength="30" />
					</fieldset>
				</td>
				<th scope="row">회비납부</th>
				<td>
					<label class="label_form">
						<input type="checkbox" class="form_checkbox" id="searchFeeArrearYn" name="searchFeeArrearYn" value="Y">
						<span class="label">미납자만</span>
					</label>
				</td>
            </tr>

		</tbody>
	</table>
</div>
<button class="btn_folding" title="테이블접기"></button>
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

	$(document).ready(function(){
		initIBSheet();
		getList();
	});

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

        ibHeader.addHeader({Header:"No",            Type:"Text",      Hidden:true,   Width:60,   Align:"Center",  SaveName:"no"              });
        ibHeader.addHeader({Header:"",           	Type:"CheckBox",  Hidden:false,  Width:60,   Align:"Center",  SaveName:"chk"             });
        ibHeader.addHeader({Header:"기금융자코드",   	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"svrId",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"마감상태",   		Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"closeSt",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   UpdateEdit:false,  EditLen:30 });
        ibHeader.addHeader({Header:"접수번호",       	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"applyId",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호",     	Type:"Text",      Hidden:false,  Width:90,   Align:"Center",  SaveName:"bsNo",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"신청일자",       	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"creDate",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"회사명",         	Type:"Text",      Hidden:false,  Width:200,  Align:"Left",    SaveName:"coNmKor",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 , Ellipsis:true });
        ibHeader.addHeader({Header:"대표자",         	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"ceoNmKor",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"사업자번호",     	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"industryNo",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"매출액",         	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"salAmount",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_성명",    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"membNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"전화번호",       	Type:"Text",      Hidden:false,  Width:110,  Align:"Center",  SaveName:"membTel",       CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

        ibHeader.addHeader({Header:"담당자_핸드폰",  	Type:"Text",      Hidden:false,  Width:110,  Align:"Center",  SaveName:"membHp",        CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_팩스",    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"membFax",       CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_EMAIL",   	Type:"Text",      Hidden:false,  Width:200,  Align:"Left",    SaveName:"membEmail",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 , Ellipsis:true });
        ibHeader.addHeader({Header:"담당자_부서명",  	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"membDeptnm",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_직위",    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"membPosition",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"등급",           	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  SaveName:"levelGb",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"금리",           	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  SaveName:"interestRate",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"자금신청액",     	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"necessAmount",  CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"추천금액",       	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"recdAmount",    CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"기융자",         	Type:"Int",       Hidden:false,  Width:70,   Align:"Center",  SaveName:"loanCnt",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"기융자금액",     	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"loanSum",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"평점\n(신청)",   	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  SaveName:"pointComp",     CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"평점\n(협회)",   	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  SaveName:"pointKita",     CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"담당본부",       	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"tradeDept",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"결과",           	Type:"Combo",     Hidden:false,  Width:80,   Align:"Center",  SaveName:"st",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, ComboCode: "<c:out value="${saLMS003.detailcd}"/>", ComboText: "<c:out value="${saLMS003.detailnm}"/>" });
        ibHeader.addHeader({Header:"추천서",         	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  SaveName:"recoSendYn",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호_암호화",	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"applyIdPw",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });


		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0, FrozenCol:7,  statusColHidden: true, MergeSheet:msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "485px");
		ibHeader.initSheet(sheetId);
		sheet1.SetSelectionMode(4);

		sheet1.SetColFontColor("recoSendYn", "0000ff");
		sheet1.SetDataLinkMouse("recoSendYn", true);
	}

	//초기화
	function doClear(){
		var f = document.form1;
		f.searchCoNmKor.value = "";
		f.searchBsNo.value = "";
		f.searchIndustryNo.value = "";

		f.searchCeoNmKor.value = "";
		f.searchApplyId.value = "";

		$("input:checkbox[id='searchFeeArrearYn']").prop("checked", false);

		if( '<c:out value="${user.fundAuthType}"/>' == 'ADMIN' ){
			setSelect(f.searchTradeDept, '');
		}else {
			setSelect(f.searchTradeDept, '<c:out value="${searchTradeDept}"/>');
		}
		setSelect(f.searchSt, "");
		setSelect(f.searchRecoSendYn, "");
	}

	//조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/selectApplicationRecommendationSendList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				sheet1.LoadSearchData({Data: data.resultList});
			}
		});
	}

	//기금융자 검색
	function goFundPopup(){

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/lms/fundPopup.do" />'		//tfms/lms/popFundList.screen
			, callbackFunction : function(resultObj){
				console.log('deadineStNm='+resultObj.deadineStNm);
				$("input[name=searchSvrId]").val(resultObj.svrId);		//기금융자코드
				$("input[name=searchTitle]").val(resultObj.title);		//기금융자명
				$("#deadineStNm").text(resultObj.deadineStNm);			//지부명
				$("#deadineSt").val(resultObj.deadineSt);				//지부코드
				$("#svrId").val(resultObj.svrId);						//기금융자코드
				getList();
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

		var resultYn = 'N';
		var left, top, nWidth, nHeight, url ,strUrl ;
		nWidth = 780;
		nHeight = 550;
		left = ((screen.width - nWidth) / 2);
		top = ((screen.height - nHeight) / 2);

		strUrl = "/tfms/ssm/fundFaxSendPopup.do?";
		strUrl +=	 "&svrId="+sheet1.GetCellValue(Row, "svrId");
		strUrl +=	 "&applyId="+sheet1.GetCellValue(Row, "applyIdPw");

		window.open(strUrl, "ma_print_window", 'left='+left+',top='+top+',width='+nWidth+',height='+nHeight+',toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no');

/*
		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/ssm/fundFaxSendPopup.do" />'		///tfms/ssm/FundFaxSend.screen
			, params : {
				 svrId : sheet1.GetCellValue(Row, "svrId")
			   , applyId : sheet1.GetCellValue(Row, "applyIdPw")
			}
			, callbackFunction : function(resultObj){
			}
		}); */
	}

	//팩스발송
	function doSendFax(){
		var saveJson = sheet1.GetSaveJson({StdCol:'chk'});
		var ccf = getSaveDataSheetList('form1' , saveJson);

		if( saveJson.data.length == 0 ){
			alert('선택된것이 없습니다. 확인후 진행 바랍니다.');
			return ;
		}

		if(!confirm("추천서를 발송하시겠습니까?")){
			return;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/applicationRecommendationSendFaxList.do" />'
			, data : JSON.stringify(ccf)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				alert("총 "+saveJson.data.length+"건 중 "+data.sendCnt+"을 발송하였습니다.");
			}
		});
	}

	//문자발송
	function doSendMms(){
		var saveJson = sheet1.GetSaveJson({StdCol:'chk'});
		var ccf = getSaveDataSheetList('form1' , saveJson);

		if( saveJson.data.length == 0 ){
			alert('선택된것이 없습니다. 확인후 진행 바랍니다.');
			return ;
		}

		for( var i = 1 ; i <= sheet1.RowCount(); i++){

			if(sheet1.GetCellValue(i, "chk") == "1"){
				if(sheet1.GetCellValue(i, "membHp") == "" || sheet1.GetCellValue(i, "membHp") == null){
					alert("발송 할 연락처가 없습니다.");
					sheet1.SelectCell(i);
					return;
				}
			}
		}

		if(!confirm("추천서를 발송하시겠습니까?")){
			return;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/applicationRecommendationSendMmsList.do" />'
			, data : JSON.stringify(ccf)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				alert("총 "+saveJson.data.length+"건 중 "+data.sendCnt+"을 발송하였습니다.");
			}
		});
	}

	//메일발송
	function doSendMail(){
		var saveJson = sheet1.GetSaveJson({StdCol:'chk'});
		var ccf = getSaveDataSheetList('form1' , saveJson);

		if( saveJson.data.length == 0 ){
			alert('선택된것이 없습니다. 확인후 진행 바랍니다.');
			return ;
		}

		for( var i = 1 ; i <= sheet1.RowCount(); i++){

			if(sheet1.GetCellValue(i, "chk") == "1"){
				if(sheet1.GetCellValue(i, "membEmail") == "" || sheet1.GetCellValue(i, "membEmail") == null){
					alert("발송 할 메일정보가 없습니다.");
					sheet1.SelectCell(i);
					return;
				}
			}
		}

		if(!confirm("추천서를 발송하시겠습니까?")){
			return;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/applicationRecommendationSendMailList.do" />'
			, data : JSON.stringify(ccf)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				alert("총 "+saveJson.data.length+"건 중 "+data.sendCnt+"을 발송하였습니다.");
			}
		});
	}

	//엑셀다운
	function doExcel(){
	var cfg = ({AutoFitColWidth: 'colhidden|rowtransaction', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0, FrozenCol:7,  statusColHidden: true, MergeSheet:msHeaderOnly});

        if(sheet1.RowCount() > 0){
        	sheet1.SetColHidden([{Col:"chk", Hidden:1}]);
        	downloadIbSheetExcel(sheet1, "추천서발송", "");
        	sheet1.SetColHidden([{Col:"chk", Hidden:0}]);
        	sheet1.SetConfig(cfg);
        }else{
        	alert("다운로드 할 항목이 없습니다.");
        }
	}

	function doDeadine(){

		var deptCd  = $('#deptCd').val();
		if( isStringEmpty(deptCd) ){
			alert('지부가 존재하지 않습니다.');
			return ;
		}

		if($('#deadineSt').val() != '01'){
			alert('이미 마감되었습니다.');
			return ;
		}

		if(!confirm( $('#searchTitle').val() + "["+ $('#deptNm').val() +"] 를 마감하시겠습니까?")){
			return;
		}


		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/applicationRecommendationSendDeadine.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				$("#deadineStNm").text('마감');			//지부명
				$("#deadineSt").val('02');				//지부코드
				alert('마감처리되었습니다.');
				getList();
			}
		});

	}


	function doSendPopup(Row){

		var saveJson = sheet1.GetSaveJson({StdCol:'chk'});
		if( saveJson.data.length == 0 ){
			alert('선택항목이 없습니다. 확인후 진행 바랍니다.');
			return ;
		}

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/ssm/applicationRecommendationSendPopup.do" />'	//tfms/lms/FundRegisteDetail.screen
			, params : {
			}
			, callbackFunction : function(resultObj){
			}
		});


// 		debugger;
// 		var svrIdStr = '';
// 		var applyIdStr = '';
// 		var applyIdPwStr = '';
// 		var cnt = 0;
// 		for( var i = 1 ; i <= sheet1.RowCount(); i++){
// 			var chk = sheet1.GetCellValue(i,'chk');

// 			if( chk == '1'){
// 				if( cnt != 0 ){
// 					svrIdStr = svrIdStr + '@';
// 					applyIdStr = applyIdStr + '@';
// 					applyIdPwStr = applyIdPwStr + '@';
// 				}
// 				svrIdStr = svrIdStr + sheet1.GetCellValue(i, "svrId");
// 				applyIdStr = applyIdStr + sheet1.GetCellValue(i, "applyId");
// 				applyIdPwStr = applyIdPwStr + sheet1.GetCellValue(i, "applyIdPw");
// 				cnt++;
// 			}
// 		}

// 		global.openLayerPopup({
// 			popupUrl : '<c:url value="/tfms/ssm/applicationRecommendationSendPopup.do" />'	//tfms/lms/FundRegisteDetail.screen
// 			, params : {
// 				svrIdStr : svrIdStr
// 			  ,	applyIdStr : applyIdStr
// 			  ,	applyIdPwStr : applyIdPwStr
// 			}
// 			, callbackFunction : function(resultObj){
// 			}
// 		});


	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
		}

		var colNm = sheet1.ColSaveName(Col);

		if( colNm  == 'recoSendYn'){
			goSendFax(Row);			//추천서 팝업
		}
	}

	function sheet1_OnSearchEnd(code, msg) {
		for( var i = 1 ; i <= sheet1.RowCount(); i++){
			var html = sheet1.GetCellValue(i,'rowView');

			if(sheet1.GetCellValue(i, "rowView") == "View"){
				html = '<img src="<c:url value="/images/btn_delete.png" />" alt="" />  ' +html;
				sheet1.SetCellFontColor(i,"rowView",'#0000ff');
			}else{
				html = '<img src="<c:url value="/images/favicon.png" />" alt="" />  ' +html;
				sheet1.SetCellFontColor(i,"rowView",'#ff0000');
			}

			sheet1.SetCellValue(i, 'rowView', html);

			var st = sheet1.GetCellValue(i, "st");
			var closeSt = sheet1.GetCellValue(i, "closeSt");

			if( closeSt == '02' ){
				if( st != '03'){	//포기
					sheet1.SetCellEditable(i, 'chk',  false);
				} else {
					sheet1.SetCellEditable( i,'chk', true);
				}
			} else {
				sheet1.SetCellEditable(i, 'chk',  false);
			}
		}
    }

</script>