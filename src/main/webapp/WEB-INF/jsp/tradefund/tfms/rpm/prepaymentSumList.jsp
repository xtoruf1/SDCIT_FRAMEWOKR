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
		<a href="javascript:doSearch();" 		class="btn_sm btn_primary">검색</a>
	</div>
</div>

<div class="cont_block">

<div class="cont_block mt-20">
	<div class="tbl_opt">
		<!-- 전체 게시글 -->
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

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

        ibHeader.addHeader({Header:"선택",      	Type:"Text",      Hidden:true,   Width:50,   Align:"Center",  ColMerge:true,   SaveName:"delCheck"     });
        ibHeader.addHeader({Header:"Status",   	Type:"Status",    Hidden:true,   Width:80,   Align:"Center",  ColMerge:true,   SaveName:"status"       });
        ibHeader.addHeader({Header:"무역업번호",   	Type:"Text",      Hidden:false,  Width:90,   Align:"Left",    ColMerge:true,   SaveName:"fndTracd",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자은행",    	Type:"Text",      Hidden:false,  Width:150,  Align:"Center",  ColMerge:true,   SaveName:"fndBank",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  , Ellipsis:true});
        ibHeader.addHeader({Header:"차수",      	Type:"Text",      Hidden:false,  Width:30,   Align:"Center",  ColMerge:true,   SaveName:"loanSeq",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"사업자번호",   	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  ColMerge:true,   SaveName:"fndBizno",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"업체명",    	Type:"Text",      Hidden:false,  Width:180,  Align:"Left",    ColMerge:true,   SaveName:"fndBiznm",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 , Ellipsis:true });
        ibHeader.addHeader({Header:"융자액",     	Type:"AutoSum",   Hidden:false,  Width:80,   Align:"Right",   ColMerge:false,  SaveName:"fndFinamt",  CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"1차정기상환",  	Type:"AutoSum",   Hidden:false,  Width:90,   Align:"Right",   ColMerge:false,  SaveName:"fndYamt1",   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"2차정기상환",  	Type:"AutoSum",   Hidden:false,  Width:80,   Align:"Right",   ColMerge:false,  SaveName:"fndYamt2",   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"3차정기상환",  	Type:"AutoSum",   Hidden:false,  Width:90,   Align:"Right",   ColMerge:false,  SaveName:"fndYamt3",   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"4차정기상환",  	Type:"AutoSum",   Hidden:false,  Width:80,   Align:"Right",   ColMerge:false,  SaveName:"fndYamt4",   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"중도상환",    	Type:"AutoSum",   Hidden:false,  Width:90,   Align:"Right",   ColMerge:false,  SaveName:"fndRedamt",  CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"잔금오차",    	Type:"AutoSum",   Hidden:false,  Width:90,   Align:"Right",   ColMerge:false,  SaveName:"fndTamt",    CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2, NoFocusMode : 0, MergeSheet: 1, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		if (typeof sheet1 !== 'undefined' && typeof sheet1.Index !== 'undefined') {
			sheet1.DisposeSheet();
		}
		createIBSheet2(container, sheetId, "100%", "600px");
		ibHeader.initSheet(sheetId);

		sheet1.SetSelectionMode(4);			// 셀 선택 모드 설정

	}

	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
	   sheet1.SetScrollTop(0);
	}

	//조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/selectPrepaymentSumList.do" />'
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


</script>