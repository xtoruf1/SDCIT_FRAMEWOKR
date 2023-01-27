<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<form id="consultForm" name="consultForm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">컨설턴트 검색</h2>
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" title="검색" onclick="doSearch();">검색</button>
			<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
		</div>
	</div>

	<div class="popup_body" style="width: 900px;">
	<!-- 컨설턴트 검색 팝업 -->
		<!--검색 시작 -->
		<div class="search">
			<div class="tbl_opt">
				<span>컨설턴트명이나 컨설턴트ID를 입력하시고 검색하셔야 합니다.</span>
			</div>
			<table class="formTable">
				<colgroup>
					<col style="width:15%">
					<col>
					<col style="width:15%">
					<col>
				</colgroup>
				<tbody>
				<tr>
					<th scope="row">컨설턴트명</th>
					<td>
						<input type="text" id="searchMemberNm" name="searchMemberNm" onkeydown="onEnter(doSearch);" class="form_text w100p">
					</td>
					<th scope="row">컨설턴트ID</th>
					<td>
						<input type="text" id="searchMemberId" name="searchMemberId" onkeydown="onEnter(doSearch);" class="form_text w100p">
					</td>
				</tr>
				</tbody>
			</table>
		</div>
		<div class="w100p mt-20">
			<div id='tblSheet3' class="colPosi"></div>
		</div>
		<!-- .paging-->
		<div id="consultantPaging" class="paging ibs"></div>
	</div>
<div class="overlay"></div>
</form>


<script type="text/javascript" src="/js/tradeSosComm.js"></script>
<script type="text/javascript">

	$(document).ready(function() {
		f_Init_tblSheet3(); //IBSheet 호출
	});

	function f_Init_tblSheet3() {				//컨설턴트

		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
	    ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2});
	    ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		// 컨설턴트 검색
		ibHeader.addHeader({Type: "Seq"	, Header: "번호"			, SaveName: "rnum"			, Align: "Center"	, Width: 70		, Edit: false, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "컨설턴트 명"	, SaveName: "memberNm"		, Align: "Center"	, Width: 100	, Edit: false, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "컨설턴트 ID"	, SaveName: "memberId"		, Align: "Left"		, Width: 100	, Edit: false, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "이메일"		, SaveName: "emailAddr"		, Align: "Center"	, Width: 100	, Edit: false	, Hidden:true});
		ibHeader.addHeader({Type: "Text", Header: "전화번호"		, SaveName: "handTel"		, Align: "Center"	, Width: 100	, Edit: false	, Hidden:true});

		if (typeof tblSheet3 !== "undefined" && typeof tblSheet3.Index !== "undefined") {
			tblSheet3.DisposeSheet();
		}

	    var sheetId = "tblSheet3";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "500px");
	    ibHeader.initSheet(sheetId);

		if($('#searchMemberNm').val() != '' && $('#searchMemberId').val() != ''){
			doSearch();
		}else{
				//tblSheet.LoadSearchData({Data: ''});
//	 			loadSearchDataGrid('mySheet3', [
//	 				{"colA": "",		"colB": "" , "colC": ""}
//	 			]);
		}
	}

	function tblSheet3_OnClick(Row,Col,Value){
		if(Row > 0){
			var rowData = tblSheet3.GetRowData(Row);
			$('#name').val(rowData['memberNm']);
			$('#expertId').val(rowData['memberId']);
			$('#email').val(rowData['emailAddr']);
			$('#email1').val(rowData['emailAddr'] != '' ? rowData['emailAddr'].split('@')[0] : '');
			$('#email2').val(rowData['emailAddr'] != '' ? rowData['emailAddr'].split('@')[1] : '');
			if(rowData['handTel'] != ''){
				$('#tel').val(rowData['handTel']);
				if(rowData['handTel'].length = 10){
					$('#tel1').val(rowData['handTel'].substr(0,3));
					$('#tel2').val(rowData['handTel'].substr(3,4));
					$('#tel3').val(rowData['handTel'].substr(7,4));
				}else if(rowData['handTel'].length = 11){
					$('#tel1').val(rowData['handTel'].substr(0,3));
					$('#tel2').val(rowData['handTel'].substr(3,3));
					$('#tel3').val(rowData['handTel'].substr(6,4));
				}
			}

			closeLayerPopup();
		}
	}


	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.consultForm.pageIndex.value = pageIndex;
		doSearch();
	}

	//컨설턴트검색
	function doSearch(){
		if ($("input[name=searchMemberNm]").val().trim() == "" && $("input[name=searchMemberId]").val().trim() == "" ){
			alert("컨설턴트명 또는 컨설턴트 ID를 입력해주세요.");
			$("input[name=searchMemberNm]").focus();
			return;
		}

		global.ajax({
			 type : 'POST'
			, url : '<c:url value="/tradeSOS/com/consultantListAjax.do" />'
			, data : $('#consultForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				 setPaging(
					 'consultantPaging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				tblSheet3.LoadSearchData({Data: data.resultList});
			}
		});
}

</script>