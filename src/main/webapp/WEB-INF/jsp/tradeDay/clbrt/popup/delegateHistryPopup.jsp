<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 무역의날 참석자 관리자 등록 팝업 -->
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">대리수령인 변동이력</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doSearch4();">검색</button>
		<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<div id="coSearchPop" class="layerPopUpWrap popup_body">
	<div class="layerPopUp">
		<div class="layerWrap" style="width:950px;">
			<div class="box">
				<form id="delegateHisFrm" name="delegateHisFrm">
					<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
					<input type="hidden" id="attendId" name="attendId" value="<c:out value='${param.attendId}' />" />
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
						</tbody>
					</table>
				</form>
				<div id="sheetDiv" class="colPosi mt-20" style="height:420px"></div>
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
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 300, SearchMode: 4, DeferredVScroll: 1, VScrollMode: 1, MouseHoverMode: 2, MergeSheet:msPrevColumnMerge + msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		ibHeader.addHeader({Type: "Text"	,Header: "attendId|attendId", SaveName: "attendId"		, Align: "Center"	, Hidden: true   , ColMerge: 0});
		ibHeader.addHeader({Type: "Text"	,Header: "seqNo|seqNo"		, SaveName: "seqNo"			, Align: "Center"	, Hidden: true   , ColMerge: 0});
		ibHeader.addHeader({Type: "Text"	,Header: "순번|순번"          , SaveName: "idx"		    , Align: "Center"   , ColMerge: 0});
		ibHeader.addHeader({Type: "Text"	,Header: "이전|이름"			, SaveName: "beforeName"	, Align: "Center"	, Width: 100		, Edit : false , ColMerge: 0});
		ibHeader.addHeader({Type: "Text"	,Header: "이전|연락처"		, SaveName: "beforePhone"	, Align: "Center"	, Width: 100		, Edit : false , ColMerge: 0});
		ibHeader.addHeader({Type: "Text"	,Header: "변경|이름"			, SaveName: "afterName"		, Align: "Center"	, Width: 100		, Edit : false , ColMerge: 0});
		ibHeader.addHeader({Type: "Text"	,Header: "변경|연락처"		, SaveName: "afterPhone"	, Align: "Center"	, Width: 100		, Edit : false , ColMerge: 0});
		ibHeader.addHeader({Type: "Text"	,Header: "변경일시|변경일시"	, SaveName: "changeDate"	, Align: "Center"	, Width: 100		, Edit : false , ColMerge: 0});

		if (typeof delegateHisSheet !== "undefined" && typeof delegateHisSheet.Index !== "undefined") {
			delegateHisSheet.DisposeSheet();
		}

		var container1 = $('#sheetDiv')[0];
		var div_heigth = $('#sheetDiv')[0].style.height;

		createIBSheet2(container1, 'delegateHisSheet', '100%', div_heigth);
		ibHeader.initSheet('delegateHisSheet');
		delegateHisSheet.SetSelectionMode(4);

		doSearch4();
	}


	function doSearch4() {
		goPage4(1);
	}

	function goPage4(pageIndex) {
		document.delegateHisFrm.pageIndex.value = pageIndex;
		getList4();
	}

	function getList4(){	 //대리수령인 변동이력
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeDay/clbrt/delegateHistryPopupList.do" />'
			, data : $('#delegateHisFrm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				delegateHisSheet.LoadSearchData({Data: data.resultInfo});
			}
		});

	}

</script>