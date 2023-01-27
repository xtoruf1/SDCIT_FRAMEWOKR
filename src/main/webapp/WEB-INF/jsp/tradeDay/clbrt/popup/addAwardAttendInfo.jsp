<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 무역의날 참석자 관리자 등록 팝업 -->
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">포상신청업체 검색</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doSearch3();">검색</button>
		<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>

</div>

<div id="coSearchPop" class="layerPopUpWrap popup_body">
	<div class="layerPopUp">
		<div class="layerWrap" style="width:950px;">
			<div class="box">
				<form id="addAttendFrm" name="addAttendFrm">
					<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
					<input type="hidden" id="svrId" name="svrId" value="<c:out value='${param.svrId}' />" />
					<table class="boardwrite formTable">
						<colgroup>
							<col style="width:10%">
							<col style="width:23%">
							<col style="width:10%">
							<col style="width:23%">
							<col style="width:10%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">업체명</th>
								<td>
									<span class="form_search w100p">
										<input type="text" id="companyName" name="companyName" class="form_text w100p" onkeydown="onEnter(doSearch3);" value="">
									</span>
								</td>
								<th scope="row">사업자 번호</th>
								<td>
									<span class="form_search w100p">
										<input type="text" id="businessNo" name="businessNo" class="form_text w100p" onkeydown="onEnter(doSearch3);" value="">
									</span>
								</td>
								<th scope="row">수상자명</th>
								<td>
									<span class="form_search w100p">
										<input type="text" id="laureateName" name="laureateName" class="form_text w100p" onkeydown="onEnter(doSearch3);" value="">
									</span>
								</td>
							</tr>
						</tbody>
					</table>
				</form>

				<div id="sheetDiv" class="colPosi mt-20" style="height:420px"></div>

				<!-- .paging-->
				<div id="addAttendPaging" class="paging ibs"></div>
				<!-- //.paging-->
			</div>
			<button type="button" class="btn_pop_close" onclick="closeLayerPopup();"></button>
		</div>
		<div class="layerFilter"></div>
	</div>
</div>

<script type="text/javascript">

	$(document).ready(function() { //IBSheet 호출
		fInitSheet();		// 헤더  Sheet 셋팅
	});

	function fInitSheet() {

		// 세팅
		var	ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		ibHeader.addHeader({Type: "Text"	,Header: "svrId"			,SaveName: "svrId"			,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "applySeq"			,SaveName: "applySeq"		,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "topYn"			,SaveName: "topYn"			,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "topCeoYn"			,SaveName: "topCeoYn"		,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "ceoYn"			,SaveName: "ceoYn"			,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "whiteYn"			,SaveName: "whiteYn"		,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "blueYn"			,SaveName: "blueYn"			,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "speYn"			,SaveName: "speYn"			,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "topAttend"		,SaveName: "topAttend"		,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "topCeoAttend"		,SaveName: "topCeoAttend"	,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "ceoAttend"		,SaveName: "ceoAttend"		,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "whiteAttend"		,SaveName: "whiteAttend"	,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "blueAttend"		,SaveName: "blueAttend"		,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "speAttend"		,SaveName: "speAttend"		,Align: "Center"	,Hidden: true});
		ibHeader.addHeader({Type: "Text"	,Header: "회사명"			,SaveName: "companyName"	,Align: "Left"		,Width: 200		,Edit : false});
		ibHeader.addHeader({Type: "Text"	,Header: "사업자번호"			,SaveName: "businessNo"		,Align: "Center"	,Width: 100		,Edit : false});
		ibHeader.addHeader({Type: "Button"	,Header: "수출의탑"			,SaveName: "topName"		,Align: "Center"	,Width: 100		,Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Button"	,Header: "수출의탑&대표자"		,SaveName: "topCeoName"		,Align: "Center"	,Width: 100		,Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Button"	,Header: "대표자"			,SaveName: "ceoName"		,Align: "Center"	,Width: 100		,Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Button"	,Header: "사무직"			,SaveName: "whiteName"		,Align: "Center"	,Width: 100		,Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Button"	,Header: "생산직"			,SaveName: "blueName"		,Align: "Center"	,Width: 100		,Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Button"	,Header: "특수유공"			,SaveName: "speName"		,Align: "Center"	,Width: 100		,Cursor:"Pointer"});

		if (typeof addAttendSheet !== "undefined" && typeof addAttendSheet.Index !== "undefined") {
			addAttendSheet.DisposeSheet();
		}


		var container1 = $('#sheetDiv')[0];
		var div_heigth = $('#sheetDiv')[0].style.height;

		createIBSheet2(container1, 'addAttendSheet', '100%', div_heigth);
		ibHeader.initSheet('addAttendSheet');
		addAttendSheet.SetSelectionMode(4);

		doSearch3();
	}

	function addAttendSheet_OnSearchEnd(row) {

		//버튼활성화
		for( var i = 1 ; i <= addAttendSheet.RowCount(); i++){

			if( addAttendSheet.GetCellValue(i,'topYn') == 'Y' && addAttendSheet.GetCellValue(i,'topAttend') != 'Y' ){
				addAttendSheet.SetCellEditable(i,'topName',true);
			}else {
				addAttendSheet.SetCellEditable(i,'topName',false);
			}

			if( addAttendSheet.GetCellValue(i,'topCeoYn') == 'Y' && addAttendSheet.GetCellValue(i,'topCeoAttend') != 'Y' ){
				addAttendSheet.SetCellEditable(i,'topCeoName',true);
			}else {
				addAttendSheet.SetCellEditable(i,'topCeoName',false);
			}

			if( addAttendSheet.GetCellValue(i,'ceoYn') == 'Y' && addAttendSheet.GetCellValue(i,'ceoAttend') != 'Y' ){
				addAttendSheet.SetCellEditable(i,'ceoName',true);
			}else {
				addAttendSheet.SetCellEditable(i,'ceoName',false);
			}

			if( addAttendSheet.GetCellValue(i,'whiteYn') == 'Y' && addAttendSheet.GetCellValue(i,'whiteAttend') != 'Y' ){
				addAttendSheet.SetCellEditable(i,'whiteName',true);
			}else {
				addAttendSheet.SetCellEditable(i,'whiteName',false);
			}

			if( addAttendSheet.GetCellValue(i,'blueYn') == 'Y' && addAttendSheet.GetCellValue(i,'blueAttend') != 'Y' ){
				addAttendSheet.SetCellEditable(i,'blueName',true);
			}else {
				addAttendSheet.SetCellEditable(i,'blueName',false);
			}

			if( addAttendSheet.GetCellValue(i,'speYn') == 'Y' && addAttendSheet.GetCellValue(i,'speAttend') != 'Y' ){
				addAttendSheet.SetCellEditable(i,'speName',true);
			}else {
				addAttendSheet.SetCellEditable(i,'speName',false);
			}

		}
    }

	function doSearch3() {
		goPage3(1);
	}

	function goPage3(pageIndex) {
		document.addAttendFrm.pageIndex.value = pageIndex;
		getList3();
	}

	function getList3(){	 //무역업체 목록 조회

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeDay/clbrt/selectAwardAttendInfoList.do" />'
			, data : $('#addAttendFrm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				setPaging(
						'addAttendPaging'
						, goPage3
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
				);

				addAttendSheet.LoadSearchData({Data: data.resultList});
			}
		});

	}

	function addAttendSheet_OnButtonClick(row, col) {
	    if( confirm(addAttendSheet.GetCellValue(row, addAttendSheet.ColSaveName(col)) + '님의 참석정보를 등록 하시겠습니까?') ){
	    	var returnCd = '';
	    	if( addAttendSheet.ColSaveName(col) == 'topName' ){
	    		returnCd = '10';
	    	}else if( addAttendSheet.ColSaveName(col) == 'topCeoName' ){
	    		returnCd = '50';
	    	}else if( addAttendSheet.ColSaveName(col) == 'ceoName' ){
	    		returnCd = '21';
	    	}else if( addAttendSheet.ColSaveName(col) == 'whiteName' ){
	    		returnCd = '22';
	    	}else if( addAttendSheet.ColSaveName(col) == 'blueName' ){
	    		returnCd = '23';
	    	}else if( addAttendSheet.ColSaveName(col) == 'speName' ){
	    		returnCd = '30';
	    	}

	    	var addData = {
	    					svrId:addAttendSheet.GetCellValue(row,'svrId')
	    					,applySeq:addAttendSheet.GetCellValue(row,'applySeq')
	    					,awardTypeCd:returnCd
	    	};

	    	// 콜백
			layerPopupCallback(addData);
	    }
	}

	function addAttendSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		var sName = addAttendSheet.ColSaveName(col);
		if( row > 0 ){
			if( sName == 'topName' || sName == 'topCeoName' || sName == 'ceoName' || sName == 'whiteName' || sName == 'blueName' || sName == 'speName' ){
				if( addAttendSheet.GetCellEditable(row,col) == false && addAttendSheet.GetCellValue(row,col) != ''){
					alert(addAttendSheet.GetCellValue(row,col)+'님은 이미 등록하셨습니다.');
				}
			}
		}
	}



</script>