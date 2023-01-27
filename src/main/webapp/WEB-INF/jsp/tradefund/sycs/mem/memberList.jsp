<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doClear();" 		class="btn_sm btn_secondary">초기화</a>
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
				<th scope="row">회사명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchCompanyKor" name="searchCompanyKor" value="<c:out value="${param.searchCompanyKor}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="회사명"  maxlength="200" />
					</fieldset>
				</td>
				<th scope="row">무역업번호</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchMemberId" name="searchMemberId" value="<c:out value="${param.searchMemberId}"/>" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="무역업번호"  maxlength="8" />
					</fieldset>
				</td>
				<th scope="row">사용자아이디</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchUserId" name="searchUserId" value="<c:out value="${param.searchUserId}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="사용자아이디" maxlength="50"  />
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
	});

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"대표아이디",  	Type:"Text",      Hidden:false,  Width:120,  Align:"Left",    	ColMerge:true,   SaveName:"userId",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호",  	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",    ColMerge:true,   SaveName:"memberId",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"회사명",     	Type:"Text",      Hidden:false,  Width:80,   Align:"Left",    	ColMerge:true,   SaveName:"companyKor", CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis: true });
        ibHeader.addHeader({Header:"대표자명",    	Type:"Text",      Hidden:false,  Width:80,   Align:"Left",    	ColMerge:true,   SaveName:"userName",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"영문회사명",  	Type:"Text",      Hidden:true,   Width:80,   Align:"Left",    	ColMerge:true,   SaveName:"companyEng", CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"상태",       	Type:"Text",      Hidden:true,   Width:80,   Align:"Center",    ColMerge:true,   SaveName:"statusH",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"회비납부유무", 	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",    ColMerge:true,   SaveName:"cnt",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0, UseHeaderSortCancel: 1, MaxSort: 1 });
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "583px");
		ibHeader.initSheet(sheetId);

		sheet1.SetSelectionMode(4);			// 셀 선택 모드 설정
	}

	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
	   sheet1.SetScrollTop(0);
	}

	//초기화
	function doClear(){
		var f = document.form1;

		f.searchCompanyKor.value = "";
		f.searchMemberId.value = "";
		f.searchUserId.value = "";
	}

	//조회
	function doSearch() {

		var f = document.form1;

		if( (f.searchCompanyKor.value == "" || f.searchCompanyKor.value == null) &&
				(f.searchUserId.value == "" || f.searchUserId.value == null) &&
				(f.searchMemberId.value == "" || f.searchMemberId.value == null)
			){
			alert("검색어를 입력해 주세요.");
			return;
		}

		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/mem/selectMemberList.do" />'
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


	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
		}
	}

	function sheet1_OnSearchEnd(code, msg) {
		for( var i = 1 ; i <= sheet1.RowCount(); i++){
			if(sheet1.GetCellValue(i, "cnt") == "미생성"){
				sheet1.SetCellFontColor(i,"cnt",'#ff0000');
			}
		}
    }

</script>