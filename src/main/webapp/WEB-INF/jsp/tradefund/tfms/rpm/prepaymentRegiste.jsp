<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">

<input type="hidden" name="hStartdt" value="<c:out value="${yearVo.startDate}"/>">
<input type="hidden" name="hEnddt" value="<c:out value="${yearVo.endDate}"/>">



<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doExcel();" 	class="btn_sm btn_primary">엑셀 다운</a>
		<a href="javascript:doClear();" 	class="btn_sm btn_secondary">초기화</a>
		<a href="javascript:doSearch();" 	class="btn_sm btn_primary">검색</a>
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
				<th scope="row">융자년월</th>
				<td colspan="3">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="fndFindtStart" name="fndFindtStart" value="<c:out value="${yearVo.startDate}"/>" onchange="fromDateSelectEvent();" class="txt monthpicker" placeholder="융자년월 시작" title="융자년월 시작" readonly="readonly"  />
								<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('fndFindtStart');" class="ui-monthpicker-trigger" alt="융자년월 시작" title="융자년월 시작" />
							</span>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="fndFindtEnd" name="fndFindtEnd" value="<c:out value="${yearVo.endDate}"/>" onchange="toDateSelectEvent();" class="txt monthpicker" placeholder="융자년월 종료" title="융자년월 종료" readonly="readonly"  />
								<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('endDate');" class="ui-monthpicker-trigger" alt="융자년월 종료" title="융자년월 종료" />
							</span>
						</div>
					</div>
				</td>
				<th scope="row">지역본부</th>
				<td>
					<select id="searchFndSitecd" name="searchFndSitecd" class="form_select w100p">
						<option value="" >::: 전체 :::</option>
						<c:forEach var="item" items="${COM001}" varStatus="status">
							<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq param.searchFndSitecd}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
						</c:forEach>
					</select>
				</td>
            </tr>
			<tr>
				<th scope="row">회사명</th>
				<td>
					<input type="text" id="searchFndBiznm" name="searchFndBiznm" value="<c:out value="${param.searchFndBiznm}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="회사명"  maxlength="200" />
				</td>
				<th scope="row">무역업번호</th>
				<td>
					<input type="text" id="searchFndTracd" name="searchFndTracd" value="<c:out value="${param.searchFndTracd}"/>" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="무역업번호"  maxlength="8" />
				</td>
				<th scope="row">사업자등록번호</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchFndBizno" name="searchFndBizno" value="<c:out value="${param.searchFndBizno}"/>" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="사업자등록번호" maxlength="10" />
					</fieldset>
				</td>
            </tr>
			<tr>
				<th scope="row">대표자명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchCeoNmKor" name="searchCeoNmKor" value="<c:out value="${param.searchCeoNmKor}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="대표자명"  maxlength="40" />
					</fieldset>
				</td>
				<th scope="row">은행</th>
				<td>
					<fieldset class="widget">
						<select id="searchFndBank" name="searchFndBank" class="form_select w100p">
							<option value="" >::: 전체 :::</option>
							<c:forEach var="item" items="${COM004}" varStatus="status">
								<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq param.searchFndBank}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
					</fieldset>
				</td>
				<th scope="row">상환여부</th>
				<td>
					<select id="searchStatus" name="searchStatus" class="form_select w100p">
							<option value="" >::: 전체 :::</option>
							<c:forEach var="item" items="${RPM001}" varStatus="status">
								<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq param.searchStatus}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
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

		if ('${pageModifyYn}' == 'Y') {
			$('.btn_modify_auth').removeClass('hide');
		}
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#fndFindtStart').val());

		if ($('#fndFindtEnd').val() != '') {
			if (startymd > Date.parse($('#fndFindtEnd').val())) {
				alert('시작월은 종료월 이전이어야 합니다.');
				$('#fndFindtStart').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#fndFindtEnd').val());

		if ($('#fndFindtStart').val() != '') {
			if (endymd < Date.parse($('#fndFindtStart').val())) {
				alert('종료월은 시작월 이후여야 합니다.');
				$('#fndFindtEnd').val('');

				return;
			}
		}
	}

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"No|No",              	Type:"Seq",       Hidden:false,  Width:40,   Align:"Center",  ColMerge:1,   SaveName:"no"                      });
        ibHeader.addHeader({Header:"지역본부|지역본부",         	Type:"Text",      Hidden:false,  Width:120,  Align:"Left",    ColMerge:1,   SaveName:"fndSitenm",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,    EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호|무역업번호",     	Type:"Text",      Hidden:false,  Width:120,  Align:"Center",  ColMerge:1,   SaveName:"fndTracd",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"☞회사명|☞회사명",         	Type:"Text",      Hidden:false,  Width:200,  Align:"Left",    ColMerge:1,   SaveName:"fndBiznm",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Ellipsis:true });
        ibHeader.addHeader({Header:"대표자|대표자",             Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"ceoNmKor",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"☞사업자번호|☞사업자번호", 	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"fndBizno",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"구분|구분",               	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"speChk",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"등급|등급",               	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"levelGb",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"등급코드|등급코드",          Type:"Text",      Hidden:true,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"levelGbCd",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"금리|금리",               	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"interestRate",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청액|신청액",             Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",   ColMerge:1,   SaveName:"fndReqamt",     CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"추천|추천일",             	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"fndRecdt",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"추천|추천액",             	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"fndRecamt",     CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"융자|융자일",             	Type:"Text",      Hidden:false,  Width:90,   Align:"Center",                SaveName:"fndFindt",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"융자|융자액",             	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"fndFinamt",     CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정기상환|Y1-1",           	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"y11",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정기상환|Y1-2",           	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"y12",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정기상환|Y1-3",           	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"y13",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정기상환|Y1-4",           	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"y14",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정기상환|Y2-1",           	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"y21",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정기상환|Y2-2",           	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"y22",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정기상환|Y2-3",           	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"y23",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정기상환|Y2-4",           	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"y24",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정기상환|Y3-1",           	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"y31",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정기상환|Y3-2",           	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"y32",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정기상환|Y3-3",          	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"y33",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정기상환|Y3-4",           	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",                 SaveName:"y34",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"중도상환금액|중도상환금액", 	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",   ColMerge:1,   SaveName:"fndRedamt",     CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"상환총액|상환총액",         	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",   ColMerge:1,   SaveName:"vfndSum",       CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"잔액|잔액",               	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",   ColMerge:1,   SaveName:"vfndBal",       CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"은행|은행",               	Type:"Text",      Hidden:false,  Width:180,  Align:"Center",  ColMerge:1,   SaveName:"fndBankNm",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"지점|지점",               	Type:"Text",      Hidden:false,  Width:180,  Align:"Left",    ColMerge:1,   SaveName:"fndSbank",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Ellipsis:true });
        ibHeader.addHeader({Header:"",                      Type:"Text",      Hidden:true,   Width:0,    Align:"Left",    ColMerge:1,   SaveName:"fndYear",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"",                      Type:"Text",      Hidden:true,   Width:0,    Align:"Left",    ColMerge:1,   SaveName:"fndMonth",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"",                      Type:"Text",      Hidden:true,   Width:0,    Align:"Left",    ColMerge:1,   SaveName:"fndBank",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"",                      Type:"Text",      Hidden:true,   Width:0,    Align:"Left",    ColMerge:1,   SaveName:"loanSeq",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction',  SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0 , FrozenCol:4, MergeSheet:msHeaderOnly, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "503px");
		ibHeader.initSheet(sheetId);

		sheet1.SetColFontBold("fndBiznm", true);
		sheet1.SetColFontBold("fndBizno", true);

		sheet1.SetDataLinkMouse("fndBiznm", true);
		sheet1.SetDataLinkMouse("fndBizno", true);
	}

	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
	   sheet1.SetScrollTop(0);
	}

	//초기화
	function doClear(){
		var f = document.form1;
		f.searchFndBiznm.value = "";
		f.searchFndTracd.value = "";
		setSelect(f.searchFndSitecd, "");
		f.searchFndBizno.value = "";
		f.searchCeoNmKor.value = "";
		setSelect(f.searchFndBank, "");
		setSelect(f.searchStatus, "");
		f.fndFindtStart.value = f.hStartdt.value;
		f.fndFindtEnd.value = f.hEnddt.value;

		if( '${user.fundAuthType}' == 'ADMIN' ){
			f.searchTradeDept.value = '${searchTradeDept}';
		}else {
			f.searchTradeDept.options[0].selected = true;
		}

	}

	//조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/selectPrepaymentRegiste.do" />'
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



	//추천서 팝업
	function goSendFax(Row){
	    var f = document.form1;

		if(sheet1.GetCellValue(Row, "st") != '03') {
			alert("선정 업체만 FAX 발송 하실수 있습니다.");
			return;
		}

		var left, top, nWidth, nHeight, url ,strUrl ;
		nWidth = 1000;
		nHeight = 700;
		left = ((screen.width - nWidth) / 2);
		top = ((screen.height - nHeight) / 2);

		strUrl = "/tfms/rpm/fundFaxSendPopup.do?";
		strUrl +=	 "&svrId="+sheet1.GetCellValue(Row, "svrId");
		strUrl +=	 "&applyId="+sheet1.GetCellValue(Row, "applyIdPw");

		window.open(strUrl, "ma_print_window", 'left='+left+',top='+top+',width='+nWidth+',height='+nHeight+',toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no');



/*
		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/rpm/fundFaxSendPopup.do" />'		///tfms/rpm/FundFaxSend.screen
			, params : {
				 svrId : sheet1.GetCellValue(Row, "svrId")
			   , applyId : sheet1.GetCellValue(Row, "applyIdPw")
			}
			, callbackFunction : function(resultObj){
			}
		});

		 */
	}



	//엑셀다운
	function doExcel(){

		var f = document.form1;
        var rowSkip = sheet1.LastRow();

        if(sheet1.RowCount() > 0){
			downloadIbSheetExcel(sheet1, "상환내역관리", "");
        }else{
        	alert("다운로드 할 항목이 없습니다.");
        }
	}


	function dlgSearchPrepaymentDetail(fnd_year, fnd_month, fnd_tracd, fnd_bank, loan_seq, level_gb, interest_rate){

		var f = document.form1;
	    var result = "false";

	    var array = new Array();

   		var resultYn = 'N';
		var left, top, nWidth, nHeight, url ,strUrl ;
		nWidth = 1000;
		nHeight = 900;
		left = ((screen.width - nWidth) / 2);
		top = ((screen.height - nHeight) / 2);

		strUrl = '<c:url value="/tfms/rpm/prepaymentRegisteDetailPopup.do" />?';
		strUrl +=	 "&fndYear="+fnd_year;
		strUrl +=	 "&fndMonth="+fnd_month;
		strUrl +=	 "&fndTracd="+fnd_tracd;
		strUrl +=	 "&fndBank="+fnd_bank;
		strUrl +=	 "&loanSeq="+loan_seq;
		strUrl +=	 "&levelGb="+level_gb;
		strUrl +=	 "&interestRate="+interest_rate;
		strUrl +=	 "&pageModifyYn=${pageModifyYn}";

		window.open(strUrl, "prepaymentRegisteDetailPopup", 'left='+left+',top='+top+',width='+nWidth+',height='+nHeight+',toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no');


		/*
		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/rpm/prepaymentRegisteDetailPopup.do" />'		///sycs/send/sendMsg.screen
			, params : {
				fndYear : fnd_year
			   , fndMonth : fnd_month
			   , fndTracd : fnd_tracd
			   , fndBank : fnd_bank
			   , loanSeq : loan_seq
			}
			, callbackFunction : function(resultObj){
			}
		});
		*/
	}

	function doContent(fnd_year, fnd_month, fnd_tracd, fnd_bank, loan_seq, fnd_findt){

		var f = document.form1;

		var left, top, nWidth, nHeight, url ,strUrl ;
		nWidth = 1000;
		nHeight = 650;
		left = ((screen.width - nWidth) / 2);
		top = ((screen.height - nHeight) / 2);

		strUrl = '/tfms/rpm/prepaymentRegisteDetailBankPopup.do';
		strUrl += "?fndYear="+fnd_year;
		strUrl += "&fndMonth="+fnd_month;
		strUrl += "&fndTracd="+fnd_tracd;
		strUrl += "&fndBank="+fnd_bank;
		strUrl += "&loanSeq="+loan_seq;
		strUrl += "&fndFindt="+fnd_findt;

		window.open(strUrl, "prepaymentRegisteDetailBankPopup", 'left='+left+',top='+top+',width='+nWidth+',height='+nHeight+',toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no');

/*
		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/rpm/prepaymentRegisteDetailBankPopup.do" />'		///sycs/send/sendMsg.screen
			, params : {
				fndYear : fnd_year
			   , fndMonth : fnd_month
			   , fndTracd : fnd_tracd
			   , fndBank : fnd_bank
			   , loanSeq : loan_seq
			   , fndFindt : fnd_findt
			}
			, callbackFunction : function(resultObj){
			}
		});
*/
	}


	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) return;

		var colNm = sheet1.ColSaveName(Col);
		var lastRow = sheet1.RowCount()+2;

		if( colNm  == 'fndBiznm' && Row != lastRow ){
			dlgSearchPrepaymentDetail(sheet1.GetCellValue(Row, "fndYear"), sheet1.GetCellValue(Row, "fndMonth") , sheet1.GetCellValue(Row, "fndTracd")
					                 ,sheet1.GetCellValue(Row, "fndBank"), sheet1.GetCellValue(Row, "loanSeq") , sheet1.GetCellValue(Row, "levelGbCd")
					                 , sheet1.GetCellValue(Row, "interestRate"));
		} else if( colNm  == 'fndBizno' && Row != lastRow ){
			doContent(sheet1.GetCellValue(Row, "fndYear"), sheet1.GetCellValue(Row, "fndMonth") , sheet1.GetCellValue(Row, "fndTracd")
					 ,sheet1.GetCellValue(Row, "fndBank"), sheet1.GetCellValue(Row, "loanSeq")  , sheet1.GetCellValue(Row, "fndFindt"));
		}
	}

	function sheet1_OnSearchEnd(code, msg) {
		sheet1.SetCellAlign(sheet1.LastRow(), 'fndSitenm', "Center");
		sheet1.SetSumText('fndSitenm', "합 계");

		sheet1.SetCellAlign(sheet1.LastRow(), 'fndTracd', "Right");
		sheet1.SetSumText('fndTracd', global.formatCurrency(sheet1.RowCount()));

		sheet1.ReNumberSeq("desc");

    }

</script>