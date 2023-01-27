<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">
<INPUT type="hidden" id="searchFndBank" name="searchFndBank" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doExcel();" 		class="btn_sm btn_primary">엑셀 다운(은행)</a>
		<a href="javascript:doExcelDetail();" 	class="btn_sm btn_primary">엑셀 다운(회원사)</a>
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
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">조회일자</th>
				<td>
					<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="searchFndFindt" name="searchFndFindt" value="<c:out value="${toDay}"/>" class="txt datepicker" title="조회일자" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="조회일자" title="조회일자" />
						</span>
					</div>
				</td>
				<th scope="row">업체명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchFndBiznm" name="searchFndBiznm" value="<c:out value="${param.searchFndBiznm}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="업체명"  maxlength="200" />
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
</div>

<div class="cont_block mt-20">
	<div class="tbl_opt">
		<!-- 전체 게시글 -->
		<div id="totalCntSheet2" class="total_count"></div>
	</div>
	<div style="width: 100%;">
		<div id="sheet2" class="sheet"></div>
	</div>
</div>

</div>

</form>

<script type="text/javascript">

	$(document).ready(function(){
		initIBSheet();
		initDetailIBSheet();
		getList();
	});

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

        ibHeader.addHeader({Header:"No",           	Type:"Seq",       Hidden:false,  Width:60,   Align:"Center",  ColMerge:true,   SaveName:"no"            });
        ibHeader.addHeader({Header:"No",           	Type:"Text",      Hidden:true,   Width:60,   Align:"Center",  ColMerge:true,   SaveName:"chk"           });
        ibHeader.addHeader({Header:"은행코드",       	Type:"Text",      Hidden:true,   Width:350,  Align:"Left",    ColMerge:true,   SaveName:"fndBank",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"은행",           	Type:"Text",      Hidden:false,  Width:250,  Align:"Left",    ColMerge:true,   SaveName:"bankNm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
        ibHeader.addHeader({Header:"업체수",         	Type:"AutoSum",   Hidden:false,  Width:100,  Align:"Center",  ColMerge:false,  SaveName:"fndCntSum",    CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자금액",       	Type:"AutoSum",   Hidden:false,  Width:150,  Align:"Right",   ColMerge:false,  SaveName:"fndFiamtSum",  CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"기정기상환금액", 	Type:"AutoSum",   Hidden:false,  Width:150,  Align:"Right",   ColMerge:false,  SaveName:"fndBefamt",    CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"기중도상환금액", 	Type:"AutoSum",   Hidden:false,  Width:150,  Align:"Right",   ColMerge:false,  SaveName:"fndRedamt",    CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"잔액",           Type:"AutoSum",   Hidden:false,  Width:150,  Align:"Right",   ColMerge:false,  SaveName:"fndAftamt",    CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2, NoFocusMode : 0, MergeSheet: 1, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		if (typeof sheet1 !== 'undefined' && typeof sheet1.Index !== 'undefined') {
			sheet1.DisposeSheet();
		}
		createIBSheet2(container, sheetId, "100%", "245px");
		ibHeader.initSheet(sheetId);

		sheet1.SetDataLinkMouse("no", true);
		sheet1.SetDataLinkMouse("bankNm", true);
		sheet1.SetDataLinkMouse("fndCntSum", true);
		sheet1.SetDataLinkMouse("fndFiamtSum", true);
		sheet1.SetDataLinkMouse("fndBefamt", true);
		sheet1.SetDataLinkMouse("fndRedamt", true);
		sheet1.SetDataLinkMouse("fndAftamt", true);

		sheet1.SetSelectionMode(4);			// 셀 선택 모드 설정

	}

	function initDetailIBSheet(){
		var	ibHeader = new IBHeader();

        ibHeader.addHeader({Header:"No",           	Type:"Seq",       Hidden:false,  Width:60,   Align:"Center",  ColMerge:true,   SaveName:"no"             });
        ibHeader.addHeader({Header:"",             	Type:"Text",      Hidden:true,   Width:60,   Align:"Center",  ColMerge:true,   SaveName:"chk"            });
        ibHeader.addHeader({Header:"융자년도",       	Type:"Text",      Hidden:true,   Width:100,  Align:"Left",    ColMerge:false,  SaveName:"fndYear",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자월",         	Type:"Text",      Hidden:true,   Width:100,  Align:"Left",    ColMerge:false,  SaveName:"fndMonth",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"은행",           	Type:"Text",      Hidden:true,   Width:100,  Align:"Left",    ColMerge:false,  SaveName:"fndBank",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"은행",           	Type:"Text",      Hidden:false,  Width:100,  Align:"Left",    ColMerge:false,  SaveName:"bankNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"업체명",         	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:false,  SaveName:"fndBiznm",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
        ibHeader.addHeader({Header:"융자차수",       	Type:"Text",      Hidden:false,  Width:60,   Align:"Center",  ColMerge:false,  SaveName:"loanSeq",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호",     	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"fndTracd",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"사업자등록번호", 	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  ColMerge:false,  SaveName:"fndBizno",      CalcLogic:"",   Format:"SaupNo",      PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자일",         	Type:"Date",      Hidden:false,  Width:100,  Align:"Center",  ColMerge:false,  SaveName:"fndFindt",      CalcLogic:"",   Format:"yyyy-MM-dd",  PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"구분",           	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:false,  SaveName:"speChk",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"등급",           	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:false,  SaveName:"levelGb",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"금리",           	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:false,  SaveName:"interestRate",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자금액",       	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",   ColMerge:false,  SaveName:"fndFinamt",     CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"1차상환일",      	Type:"Date",      Hidden:false,  Width:100,  Align:"Center",  ColMerge:false,  SaveName:"fndYdt1",       CalcLogic:"",   Format:"yyyy-MM-dd",  PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"1차상환금액",   	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",   ColMerge:false,  SaveName:"fndYamt1",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"2차상환일",      	Type:"Date",      Hidden:false,  Width:100,  Align:"Center",  ColMerge:false,  SaveName:"fndYdt2",       CalcLogic:"",   Format:"yyyy-MM-dd",  PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"2차상환금액",    	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",   ColMerge:false,  SaveName:"fndYamt2",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"3차상환일",      	Type:"Date",      Hidden:false,  Width:100,  Align:"Center",  ColMerge:false,  SaveName:"fndYdt3",       CalcLogic:"",   Format:"yyyy-MM-dd",  PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"3차상환금액",    	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",   ColMerge:false,  SaveName:"fndYamt3",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"4차상환일",      	Type:"Date",      Hidden:false,  Width:100,  Align:"Center",  ColMerge:false,  SaveName:"fndYdt4",       CalcLogic:"",   Format:"yyyy-MM-dd",  PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"4차상환금액",    	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",   ColMerge:false,  SaveName:"fndYamt4",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"기정기상환금액", 	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",   ColMerge:false,  SaveName:"vfndSum1",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"기중도상환금액", 	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",   ColMerge:false,  SaveName:"fndRedamt",     CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"잔액",           	Type:"AutoSum",   Hidden:false,  Width:120,  Align:"Right",   ColMerge:false,  SaveName:"vfndBal",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 50, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2, NoFocusMode : 0, MergeSheet: 1, FrozenCol:7, UseHeaderSortCancel: 1, MaxSort: 1 });
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet2";
		var container = $("#"+sheetId)[0];
		if (typeof sheet2 !== 'undefined' && typeof sheet2.Index !== 'undefined') {
			sheet2.DisposeSheet();
		}
		createIBSheet2(container, sheetId, "100%", "330px");
		ibHeader.initSheet(sheetId);

		sheet2.SetSelectionMode(4);			// 셀 선택 모드 설정
	}

	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
	   sheet1.SetScrollTop(0);
	}

	// sort시 스크롤 상위로 이동
	function sheet2_OnSort(col, order) {
	   sheet2.SetScrollTop(0);
	}

	//초기화
	function doClear(){
		var f = document.form1;
		f.searchFndBiznm.value = '';
		f.searchFndFindt.value = '<c:out value="${toDay}"/>';
	}

	//조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/selectPrepaymentHistoryByDayFirstList.do" />'
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


	function doSearchDetail(Row) {

		var f = document.form1;
		f.searchFndBank.value = sheet1.GetCellValue(Row, "fndBank");

		getDetailList();
	}

	//상세 조회
	function getDetailList() {

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/selectPrepaymentHistoryByDayDetailList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCntSheet2').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');
				sheet2.LoadSearchData({Data: data.resultList});
			}
		});
	}

	//엑셀저장(은행)
	function doExcel(){

        var f = document.form1;
        var rowSkip = sheet1.LastRow();
        var excelNm = "정기상환금조회(은행)";

        if(sheet1.RowCount() > 0){
        	downloadIbSheetExcel(sheet1, excelNm, "");
        }else{
        	alert("다운로드 할 항목이 없습니다.");
        }
	}

	//엑셀저장(회원사)
	function doExcelDetail(){

        var f = document.form1;
        var rowSkip = sheet2.LastRow();
        var excelNm = "정기상환금조회(은행별 회원사)";

        if(sheet2.RowCount() > 0){
        	downloadIbSheetExcel(sheet2, excelNm, "");
        }else{
        	alert("다운로드 할 항목이 없습니다.");
        }
	}


	function sheet1_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row == 0) {
			 return ;
		}

		var colNm = sheet1.ColSaveName(col);
	}

	function sheet1_OnSearchEnd(code, msg) {
		if( sheet1.RowCount() > 0){
			doSearchDetail(1);
		}

		sheet1.SetCellAlign(sheet1.LastRow(), 'bankNm', "Center");
		sheet1.SetSumText('bankNm', "총    계");
		sheet1.ReNumberSeq("desc");

    }


	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		doSearchDetail(NewRow)
	}

	function sheet2_OnSearchEnd(code, msg) {
		sheet2.SetCellAlign(sheet2.LastRow(), 'bankNm', "Center");
		sheet2.SetSumText('bankNm', "총    계");
		sheet2.ReNumberSeq("desc");
    }

</script>