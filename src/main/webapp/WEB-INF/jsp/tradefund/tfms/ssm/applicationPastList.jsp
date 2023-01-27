<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">
<input type="hidden" id="resultCnt"			name="resultCnt"        value="0" />

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
				<th scope="row">융자기간</th>
				<td colspan="3">
					<div class="group_datepicker">
						<!-- datepicker -->
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchLoanSt" name="searchLoanSt" value="<c:out value="${searchLoanSt}"/>" class="txt datepicker" placeholder="융자기간 시작일" title="융자기간 시작일" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								<input type="hidden" id="dummyStartDate" value="" />
							</span>

							<!-- clear 버튼 -->
<%-- 							<button type="button" onclick="clearPickerValue('searchLoanSt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button> --%>
						</div>
						<div class="spacing">~</div>
						<!-- datepicker -->
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchLoanEd" name="searchLoanEd" value="<c:out value="${searchLoanEd}"/>" class="txt datepicker" placeholder="융자기간 종료일" title="융자기간 종료일" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								<input type="hidden" id="dummyEndDate" value="" />
							</span>

							<!-- clear 버튼 -->
<%-- 							<button type="button" onclick="clearPickerValue('searchLoanEd');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button> --%>
						</div>
					</div>
				</td>
            </tr>
			<tr>
				<th scope="row">은행</th>
				<td>
					<fieldset class="widget">
						<select id="searchBank" name="searchBank" class="form_select" >
							<option value="" >::: 전체 :::</option>
							<c:forEach var="item" items="${COM004}" varStatus="status">
								<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq param.searchBank}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
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
				<td colspan="3">
					<fieldset class="widget">
						<input type="text" id="searchCeoNmKor" name="searchCeoNmKor" value="<c:out value="${param.searchCeoNmKor}"/>" onkeydown="onEnter(doSearch);" class="textType form_text " title="대표자명" maxlength="40" />
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

		// 시작일 선택 이벤트
		datepickerById('searchLoanSt', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('searchLoanEd', toDateSelectEvent);

		getList();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchLoanSt').val());

		if ($('#searchLoanEd').val() != '') {
			if (startymd > Date.parse($('#searchLoanEd').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchLoanSt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchLoanEd').val());

		if ($('#searchLoanSt').val() != '') {
			if (endymd < Date.parse($('#searchLoanSt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchLoanEd').val('');

				return;
			}
		}
	}

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"No",    Type:"Int",      Hidden:false,	 Width:60,   Align:"Center",  SaveName:"rn"             });
		ibHeader.addHeader({Header:"No",	Type:"Seq",      Hidden:true,	 Width:60,   Align:"Center",  SaveName:"no"              });
		ibHeader.addHeader({Header:"",         	Type:"Text",      Hidden:true,   Width:60,   Align:"Center",  SaveName:"chk"               });
		ibHeader.addHeader({Header:"접수번호",    	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"applyId",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"본부코드",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"tradeDept",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"본부명",     	Type:"Text",      Hidden:false,  Width:150,  Align:"Center",  SaveName:"tradeDeptNm",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
		ibHeader.addHeader({Header:"사업자등록번호",	Type:"Text",      Hidden:false,  Width:120,  Align:"Center",  SaveName:"industryNo",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"회사명",     	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    SaveName:"coNmKor",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true  });
		ibHeader.addHeader({Header:"대표자",     	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  SaveName:"ceoNmKor",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"무역업번호",  	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"bsNo",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"등급",      	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  SaveName:"levelGb",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"금리",      	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  SaveName:"interestRate",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자추천금액", 	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"recdAmount",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"1차\n융자일", 	Type:"Date",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"recdDt",           CalcLogic:"",   Format:"yyyy-MM-dd",  PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"1차\n융자금액",	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"defntAmount",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"2차\n융자일", 	Type:"Date",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"recdDt2",          CalcLogic:"",   Format:"yyyy-MM-dd",  PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"2차\n융자금액",	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"defntAmount2",     CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"3차\n융자일", 	Type:"Date",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"recdDt3",          CalcLogic:"",   Format:"yyyy-MM-dd",  PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"3차\n융자금액",	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"defntAmount3",     CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자은행",    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"mainBankCd",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자은행",    	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"mainBankNm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자지점",    	Type:"Text",      Hidden:false,  Width:120,  Align:"Left",    SaveName:"mainBankBranchNm", CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"자금용도",    	Type:"Text",      Hidden:false,  Width:200,  Align:"Left",    SaveName:"moneyUse",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
		ibHeader.addHeader({Header:"자금용도1",   	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"moneyUse1",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"자금용도2",   	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"moneyUse2",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"자금용도3",   	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"moneyUse3",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"추천일자",    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"recdDate",         CalcLogic:"",   Format:"yyyy-MM-dd",  PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 50, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0, FrozenCol:7,  statusColHidden: true, MergeSheet:msHeaderOnly, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "520px");
		ibHeader.initSheet(sheetId);
		sheet1.SetSelectionMode(4);
	}

	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
	   sheet1.SetScrollTop(0);
	}

	//초기화
	function doClear(){
		var f = document.form1;

		f.searchCoNmKor.value = "";
		f.searchBsNo.value = "";
		f.searchIndustryNo.value = "";
		f.searchCeoNmKor.value = "";

		f.searchLoanSt.value = "<c:out value="${searchLoanSt}"/>";
		f.searchLoanEd.value = "<c:out value="${searchLoanEd}"/>";

		setSelect(f.searchTradeDept, '<c:out value="${searchTradeDept}"/>');
		setSelect(f.search_BANK, "");
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
			, url : '<c:url value="/tfms/ssm/selectApplicationPastList.do" />'
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


	//엑셀다운
	function doExcel(){

        var f = document.form1;
        var rowSkip = sheet1.LastRow();

        if(sheet1.RowCount() > 0){
        	downloadIbSheetExcel(sheet1, "과거융자업체", "");
        }else{
        	alert("다운로드 할 항목이 없습니다.");
        }
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
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