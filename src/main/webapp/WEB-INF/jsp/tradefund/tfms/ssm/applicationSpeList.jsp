<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">

<input type="hidden" id="svrId"     		name="svrId"	value="" />
<input type="hidden" id="applyId"     		name="applyId"	value="" />
<input type="hidden" id="bsNo"     			name="bsNo"    	value="" />
<input type="hidden" id="resultCnt"			name="resultCnt"        value="0" />
<input type="hidden" id="gubun"				name="gubun"        value="appl" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doExcel();" 		class="btn_sm btn_primary">엑셀 다운</a>
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
				<td colspan="3">
					<div class="field_set flex align_center">
						<span class="form_search w100p fundPopup">
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>" />
							<input type="text" class="form_text " placeholder="기금융자" title="기금융자" id="searchTitle" name="searchTitle" maxlength="150" readonly="readonly" onkeydown="onEnter(doSearch);" value="<c:out value="${searchTitle}"/>" />
							<button class="btn_icon btn_search" title="기금융자 검색" onclick="goFundPopup()"></button>
						</span>
						<button type="button" class="ml-8" onclick="setEmptyValue('.fundPopup')" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
					</div>
				</td>
				<th scope="row">지역본부</th>
				<td>

					<fieldset class="widget">
						<select id="searchTradeDept" name="searchTradeDept" class="form_select"  >
							<c:if test='${user.fundAuthType eq "ADMIN"}'>
								<option value="" >::: 전체 :::</option>
							</c:if>

							<c:forEach var="item" items="${COM001}" varStatus="status">
							<c:if test='${user.fundAuthType eq "ADMIN"}'>
								<option value="<c:out value="${item.chgCode01}"/>" ><c:out value="${item.detailnm}"/></option>
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
            </tr>
			<tr>
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
				<th scope="row">회사명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchCoNmKor" name="searchCoNmKor" value="<c:out value="${param.searchCoNmKor}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="회사명" maxlength="200" />
					</fieldset>
				</td>
            </tr>
			<tr>
				<th scope="row">무역업번호</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchBsNo" name="searchBsNo" value="<c:out value="${param.searchBsNo}"/>" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="무역업번호" maxlength="8" />
					</fieldset>
				</td>
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

	$(document).ready(function(){
		initIBSheet();
		getList();
	});

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"No",            Type:"Int",       Hidden:false,	 Width:60,   Align:"Center",  SaveName:"rn"             });
        ibHeader.addHeader({Header:"No",       		Type:"Seq",       Hidden:true,	 Width:60,   Align:"Center",  SaveName:"no"              });
        ibHeader.addHeader({Header:"",         		Type:"Text",      Hidden:true,   Width:60,   Align:"Center",  SaveName:"chk"             });
        ibHeader.addHeader({Header:"기금융자코드",  Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"svrId",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호",    	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"applyId",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호",  	Type:"Text",      Hidden:false,  Width:90,   Align:"Center",  SaveName:"bsNo",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"신청일자",    	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"creDate",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"회사명",     	Type:"Text",      Hidden:false,  Width:200,  Align:"Left",    SaveName:"coNmKor",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true  });
        ibHeader.addHeader({Header:"대표자",     	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"ceoNmKor",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"사업자번호",  	Type:"Text",      Hidden:false,  Width:110,  Align:"Center",  SaveName:"industryNo",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"매출액",     	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"salAmount",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_성명",  	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"membNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"전화번호",    	Type:"Text",      Hidden:false,  Width:110,  Align:"Center",  SaveName:"membTel",       CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_팩스", 	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"membFax",       CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_EMAIL",Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"membEmail",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_부서명",	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"membDeptnm",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_직위", 	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"membPosition",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"등급",       	Type:"Text",      Hidden:false,  Width:40,   Align:"Center",  SaveName:"levelGb",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"금리",      	Type:"Text",      Hidden:false,  Width:40,   Align:"Center",  SaveName:"interestRate",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"자금신청액",  	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"necessAmount",  CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"추천금액",    	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"recdAmount",    CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"기융자",     	Type:"Int",       Hidden:false,  Width:70,   Align:"Right",   SaveName:"loanCnt",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"기융자금액",   	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"loanSum",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"평점\n(신청)",	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  SaveName:"pointComp",     CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"평점\n(협회)",	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  SaveName:"pointKita",     CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"담당본부",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"tradeDept",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"결과",      	Type:"Combo",     Hidden:false,  Width:80,   Align:"Center",  SaveName:"st",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, ComboCode: "<c:out value="${saLMS003.detailcd}"/>", ComboText: "<c:out value="${saLMS003.detailnm}"/>" });
        ibHeader.addHeader({Header:"추천서",     	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  SaveName:"recoSendYn",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"주소",      	Type:"Text",      Hidden:false,  Width:400,  Align:"Left",    SaveName:"coAddr",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true  });

		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 50, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0, FrozenCol:7,  statusColHidden: true, MergeSheet:msHeaderOnly, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "520px");
		ibHeader.initSheet(sheetId);
		sheet1.SetSelectionMode(4);

		sheet1.SetColFontBold("loanSum", true);
		sheet1.SetColFontBold("coNmKor", true);

		sheet1.SetDataLinkMouse("loanSum", true);
		sheet1.SetDataLinkMouse("coNmKor", true);
	}

	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
	   sheet1.SetScrollTop(0);
	}

	//초기화
	function doClear(){
		var f = document.form1;
		f.searchSvrId.value = "";
		f.searchTitle.value = "";
		f.searchCoNmKor.value = "";
		f.searchBsNo.value = "";
		f.searchIndustryNo.value = "";
		f.searchCeoNmKor.value = "";

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

		if($('#searchSvrId').val() == '' || $('#searchSvrId').val() == null) {
			alert('기금융자명을 선택해주세요.');
			return;
		} else {
			getList();
		}
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/selectApplicationSpeList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				$('#resultCnt').val(data.resultCnt);
				sheet1.LoadSearchData({Data: data.resultList});
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
				$("input[name=searchSvrId]").val(resultObj.svrId);		//기금융자코드
				$("input[name=searchTitle]").val(resultObj.title);		//기금융자명
				getList();
			}
		});
	}

	//엑셀다운
	function doExcel(){

        var f = document.form1;
        var rowSkip = sheet1.LastRow();

        if(sheet1.RowCount() > 0){
        	downloadIbSheetExcel(sheet1, '신청업체조회(특별)', '');
        }else{
        	alert("다운로드 할 항목이 없습니다.");
        }
	}


	//신청업체선정 상세
	function goApplicationSelect(Row){
	    var f = document.form1;
	    f.svrId.value 		= sheet1.GetCellValue(Row, "svrId");
	    f.applyId.value 	= sheet1.GetCellValue(Row, "applyId");
	    f.bsNo.value 		= sheet1.GetCellValue(Row, "bsNo");

		var url = '<c:url value="/tfms/ssm/applicationSpeDetail.do" />';
		f.action = url;
		f.target = "_self";
		f.submit();
	}



	//무역기금 과거 융자확인 팝업
	function goInqueryDetail(row){

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/ssm/fundBeforePopup.do" />'
			, params : {
				industryNo : sheet1.GetCellValue(row, "industryNo")
		      , applyId : sheet1.GetCellValue(row, "applyId")
			}
			, callbackFunction : function(resultObj){
			}
		});
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
		}

		var colNm = sheet1.ColSaveName(Col);

		if( colNm  == 'coNmKor'){
			goApplicationSelect(Row);
		} else if( colNm  == 'loanSum'){
			goInqueryDetail(Row);
		}
	}

	function sheet1_OnRowSearchEnd(row) {
		if ( row > 0) {
		var index = sheet1.GetCellValue(row, "no");
		var resultCnt = $('#resultCnt').val();
		sheet1.SetCellValue(row, "rn", parseInt(resultCnt - index)+1 );
		}
	}

	function sheet1_OnSearchEnd(code, msg) {
    }

</script>