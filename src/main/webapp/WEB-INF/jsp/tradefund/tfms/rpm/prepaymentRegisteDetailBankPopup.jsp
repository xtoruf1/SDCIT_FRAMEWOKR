<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<form id="prepaymentRegisteDetailBankPopupForm" name="prepaymentRegisteDetailBankPopupForm" method="get" onsubmit="return false;">

<input type="hidden" name="fndYear" value="<c:out value="${param.fndYear}"/>" />
<input type="hidden" name="fndMonth" value="<c:out value="${param.fndMonth}"/>" />
<input type="hidden" name="fndTracd" value="<c:out value="${param.fndTracd}"/>" />
<input type="hidden" name="fndBank" value="<c:out value="${param.fndBank}"/>" />
<input type="hidden" name="loanSeq" value="<c:out value="${param.loanSeq}"/>" />

<input type="hidden" name="fndYear1" value="<c:out value="${fndVo.fndYear1}"/>" />
<input type="hidden" name="fndMonth1" value="<c:out value="${fndVo.fndMonth1}"/>" />
<input type="hidden" name="fndTracd1" value="<c:out value="${fndVo.fndTracd1}"/>" />
<input type="hidden" name="fndBank1" value="<c:out value="${fndVo.fndBank1}"/>" />
<input type="hidden" name="loanSeq1" value="<c:out value="${fndVo.loanSeq1}"/>" />

<input type="hidden" name="insertKey" value="N">

<input type="hidden" name="fndYdt1" value="<c:out value="${fndVo.fndYdt1}"/>" />
<input type="hidden" name="fndYdt2" value="<c:out value="${fndVo.fndYdt2}"/>" />
<input type="hidden" name="fndYdt3" value="<c:out value="${fndVo.fndYdt3}"/>" />
<input type="hidden" name="fndYdt4" value="<c:out value="${fndVo.fndYdt4}"/>" />

<input type="hidden" name="fndYamt1" value="<c:out value="${fndVo.fndYamt1}"/>" />
<input type="hidden" name="fndYamt2" value="<c:out value="${fndVo.fndYamt2}"/>" />
<input type="hidden" name="fndYamt3" value="<c:out value="${fndVo.fndYamt3}"/>" />
<input type="hidden" name="fndYamt4" value="<c:out value="${fndVo.fndYamt4}"/>" />
<input type="hidden" name="fndRedamt" value="<c:out value="${fndVo.fndRedamt}"/>" />

<input type="hidden" name="fndFindt" value="<c:out value="${fndVo.fndFindt}"/>" />

<div class="winPopContinent">

	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">업체상환정보</h2>
		<div class="ml-auto">
			<button class="btn_sm btn_secondary" 	onclick="doClose()">닫기</button>
		</div>
	</div>

	<div class="popup_body">

		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">업체정보</h3>
			</div>

			<table class="formTable">
				<colgroup>
					<col style="width:10%;">
					<col style="width:20%;">
					<col style="width:10%;">
					<col style="width:20%;">
					<col style="width:10%;">
					<col>
				</colgroup>
				<tr>
					<th>회사명</th>
					<td><c:out value="${fndVo.fndBiznm}"/></td>
					<th>사업자번호</th>
					<td><c:out value="${fndVo.fndBizno}"/></td>
					<th rowspan="3">비고</th>
					<td rowspan="3"><c:out value="${fndVo.fndMemo}"/></td>
				</tr>
				<tr>
					<th>대표자명</th>
					<td><c:out value="${fndVo.ceoNmKor}"/></td>
					<th>무역업번호</th>
					<td><c:out value="${fndVo.fndTracd}"/></td>
				</tr>
				<tr>
					<th>은행</th>
					<td><c:out value="${fndVo.fndBankNm}"/></td>
					<th>지점</th>
					<td><c:out value="${fndVo.fndSbank}"/></td>
				</tr>
			 </table>
		</div>

		<div class="cont_block mt-20">
			<div class="tit_bar">
				<h3 class="tit_block">융자정보</h3>
			</div>
			<table class="formTable">
				<colgroup>
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:15%;">
				</colgroup>
				<tr>
					<th>신청액</th>
					<th>추천액</th>
					<th>융자액</th>
					<th>정기상환액</th>
					<th>중도상환액</th>
					<th>총상환액</th>
					<th>잔액</th>
				</tr>
				<tr>
					<td class="align_r"><c:out value="${fndVo.fndReqamt}"/></td>
					<td class="align_r"><c:out value="${fndVo.fndRecamt}"/></td>
					<td class="align_r"><fmt:formatNumber value="${fndFinamtSum}"/></td>
					<td class="align_r"><fmt:formatNumber value="${vfnd_sum1}"/></td>
					<td class="align_r"><fmt:formatNumber value="${fndRedamtSum}"/></td>
					<td class="align_r"><fmt:formatNumber value="${vfnd_sum2}"/></td>
					<td class="align_r"><fmt:formatNumber value="${vfnd_bal}"/></td>
				</tr>
			 </table>
		</div>

		<div class="cont_block mt-20">
			<div class="tit_bar">
				<h3 class="tit_block">중도상환내역</h3>
			</div>
	<!-- 		<div class="tbl_opt mt-20"> -->
				<!-- 전체 게시글 -->
	<!-- 			<div id="prepaymentRegisteDetailBankPopupTotalCnt" class="total_count"></div> -->
	<!-- 		</div> -->

			<div class="w100p">
				<div id="prepaymentRegisteDetailBankPopupSheet" class="sheet"></div>
			</div>
		</div>
	</div>
</div>
<div class="overlay"></div>
</form>

<script type="text/javascript">
	$(document).ready(function () {
		initPrepaymentRegisteDetailBankPopupSheet();
		getFundBeforeList()
	});

	// Sheet의 초기화 작업
	function initPrepaymentRegisteDetailBankPopupSheet() {
		var ibHeader = new IBHeader();
		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1,  MouseHoverMode: 2, NoFocusMode : 0, FrozenCol:2,MergeSheet:msHeaderOnly, UseHeaderSortCancel: 1, MaxSort: 1 });

		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		ibHeader.addHeader({Header:"은행|은행",       	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"fndBankNm",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false });
		ibHeader.addHeader({Header:"지점|지점",       	Type:"Text",      Hidden:false,  Width:120,  Align:"Center",  ColMerge:1,   SaveName:"fndSbank",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:true,   InsertEdit:true });
		ibHeader.addHeader({Header:"융자일|융자일",    	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"fndFindt",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
		ibHeader.addHeader({Header:"융자금액|융자금액",  	Type:"Float",     Hidden:false,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"fndFinamt",  CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
		ibHeader.addHeader({Header:"1차정기상환|일자",  	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",                SaveName:"fndYdt1",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"1차정기상환|금액",  	Type:"Float",     Hidden:false,  Width:120,  Align:"Right",                 SaveName:"fndYamt1",   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"2차정기상환|일자",  	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",                SaveName:"fndYdt2",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"2차정기상환|금액",  	Type:"Float",     Hidden:false,  Width:120,  Align:"Right",                 SaveName:"fndYamt2",   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"3차정기상환|일자",  	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",                SaveName:"fndYdt3",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"3차정기상환|금액",  	Type:"Float",     Hidden:false,  Width:120,  Align:"Right",                 SaveName:"fndYamt3",   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"4차정기상환|일자",  	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",                SaveName:"fndYdt4",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"4차정기상환|금액",  	Type:"Float",     Hidden:false,  Width:120,  Align:"Right",                 SaveName:"fndYamt4",   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"중도상환|일자",    	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",                SaveName:"fndReddt",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"중도상환|금액",    	Type:"Float",     Hidden:false,  Width:120,  Align:"Right",                 SaveName:"fndRedamt",  CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

		var sheetId = "prepaymentRegisteDetailBankPopupSheet";
		var container = $("#"+sheetId)[0];
		if (typeof prepaymentRegisteDetailBankPopupSheet !== 'undefined' && typeof prepaymentRegisteDetailBankPopupSheet.Index !== 'undefined') {
			prepaymentRegisteDetailBankPopupSheet.DisposeSheet();
		}
		createIBSheet2(container, sheetId, "100%", "300px");
		ibHeader.initSheet(sheetId);
	};

	// sort시 스크롤 상위로 이동
	function prepaymentRegisteDetailBankPopupSheet_OnSort(col, order) {
		prepaymentRegisteDetailBankPopupSheet.SetScrollTop(0);
	}

	// 검색
	function getFundBeforeList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/selectRedAmtList.do" />'
			, data : $('#prepaymentRegisteDetailBankPopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
// 				$('#prepaymentRegisteDetailBankPopupTotalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

				prepaymentRegisteDetailBankPopupSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function doClose(){
		window.close();
// 		closeLayerPopup();
	}
</script>