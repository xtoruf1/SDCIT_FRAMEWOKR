<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<form id="fundBeforePopupForm" name="fundBeforePopupForm" method="get" onsubmit="return false;">
<input type="hidden" name="industryNo"     	value="<c:out value="${param.industryNo}"/>"  />
<input type="hidden" name="applyId"     	value="<c:out value="${param.applyId}"/>"  />

<div style="min-width: 1000px; max-height: 700px;" class="fixed_pop_tit">
<!-- 팝업 타이틀 -->
<div class="flex popup_top">
	<h2 class="popup_title">무역기금 과거 융자확인</h2>
	<div class="ml-auto">
		<button class="btn_sm btn_primary" 		onclick="doFundBeforeExcel()">엑셀</button>
		<button class="btn_sm btn_secondary" 	onclick="closeLayerPopup();">닫기</button>
	</div>
</div>


<div class="popup_body " id="printTable" >
	<div class="tbl_opt">
		<!-- 전체 게시글 -->
		<div id="fundBeforePopupTotalCnt" class="total_count"></div>

	</div>

	<div class="w100p">
		<div id="fundBeforePopupSheet" class="sheet"></div>
	</div>
</div>
<div class="overlay"></div>
</div>
</form>

<script type="text/javascript">
	$(document).ready(function () {
		// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
		$('.modal').on('click', function(e){
			if (!$(e.target).is($('.modal-content, .modal-content *'))) {
				closeLayerPopup();
			}
		});

		initFundBeforePopupSheet();
		getFundBeforeList()
	});

	// Sheet의 초기화 작업
	function initFundBeforePopupSheet() {
		var ibHeader = new IBHeader();
		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1,  MouseHoverMode: 2, NoFocusMode : 0, FrozenCol:5 });

		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Header:"No",        Type:"Seq",       Hidden:false,  Width:60,   Align:"Center",  SaveName:"no"                  });
		ibHeader.addHeader({Header:"",          Type:"Text",      Hidden:true,   Width:20,   Align:"Center",  SaveName:"chk"                 });
		ibHeader.addHeader({Header:"접수번호",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"applyId",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"본부코드",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"tradeDept",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"본부명",     	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    SaveName:"tradeDeptNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
		ibHeader.addHeader({Header:"사업자번호",  	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"industryNo",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"업체명",     	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    SaveName:"coNmKor",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
		ibHeader.addHeader({Header:"대표자",     	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  SaveName:"ceoNmKor",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"추천일자",    	Type:"Text",      Hidden:false,  Width:150,  Align:"Center",  SaveName:"recdDate",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자추천금액", 	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"recdAmount",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"1차융자일자",  	Type:"Date",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"recdDt",             CalcLogic:"",   Format:"yyyy-MM-dd",  PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"1차융자금액", 	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"defntAmount",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"2차융자일자",  	Type:"Date",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"recdDt2",            CalcLogic:"",   Format:"yyyy-MM-dd",  PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"2차융자금액",  	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"defntAmount2",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자은행",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"mainBankCd",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자은행",    	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"mainBankNm",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
		ibHeader.addHeader({Header:"융자지점명",   	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"mainBankBranchNm",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });


		var sheetId = "fundBeforePopupSheet";
		var container = $("#"+sheetId)[0];
		if (typeof fundBeforePopupSheet !== 'undefined' && typeof fundBeforePopupSheet.Index !== 'undefined') {
			fundBeforePopupSheet.DisposeSheet();
		}
		createIBSheet2(container, sheetId, "100%", "300px");
		ibHeader.initSheet(sheetId);
	};

	// 검색
	function getFundBeforeList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/fundBeforePopupList.do" />'
			, data : $('#fundBeforePopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#fundBeforePopupTotalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

				fundBeforePopupSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	//엑셀 다운
	function doFundBeforeExcel(){
		fundBeforePopupSheet.Down2Excel({Mode:-1});
	}


</script>