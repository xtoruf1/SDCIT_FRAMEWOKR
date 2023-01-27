<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<div class="flex">
	<h2 class="popup_title">품목찾기</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<div class="popup_body">
	<form name="frmArticleSearch" id="frmArticleSearch"  method="post" onsubmit="return false;">
	<input type="hidden" name="popupEvent" id="popupEvent" value="">
		<div class="group_item w100p">
			<select class="form_select"  name="searchPopupItemLv1" id="searchPopupItemLv1" onchange="javascript:doItemPopupCodeChange('ITEM_LV2')">
				<option value="">-- 대분류 --</option>
			</select>
			<select class="form_select ml-8"  name="searchPopupItemLv2" id="searchPopupItemLv2" onchange="javascript:doItemPopupCodeChange('ITEM_LV3')">
				<option value="">-- 중분류 --</option>
			</select>
			<select class="form_select ml-8"  name="searchPopupItemLv3" id="searchPopupItemLv3" onchange="javascript:doItemPopupCodeChange('ITEM_LV4')">
				<option value="">-- 세분류 --</option>
			</select>
			<div class="form_search ml-8">
				<input type="text" name="searchDetailNm" id="searchDetailNm" value = "<c:out value="${svcexVO.searchDetailNm }"/>" onkeydown="onEnter(doArticleSearch);" class="form_text" title="검색어" />
				<button type="button" class="btn_icon btn_search" onclick="doArticleSearch()"></button>
			</div>
		</div>

	</form>
</div>

</br>
<div style="width: 900px;height: 250px;">
	<div id="searchArticlePopup" class="sheet"></div>
</div>

<script type="text/javascript">


	$(document).ready(function(){
		initGrid();
		doItemPopupCodeChange("ITEM_LV1");
	});

	function doArticleSearch() {
		var popupForm = document.frmArticleSearch;
		if( popupForm.searchDetailNm.value == "" && popupForm.searchPopupItemLv3.value == "" ) {
			alert("세분류나 코드명을 입력하십시오.");
			return;
		}
		selectArticleList();
	}

	function selectArticleList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/popup/searchArticleList.do" />'
			, data : $('#frmArticleSearch').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				searchArticlePopupSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function initGrid(){
		if (typeof searchArticlePopupSheet !== "undefined" && typeof searchArticlePopupSheet.Index !== "undefined") {
			searchArticlePopupSheet.DisposeSheet();
		}

		var	ibCountryHeader = new IBHeader();
		ibCountryHeader.addHeader({Header: '품목코드', Type: 'Text', SaveName: 'detailcd', Width: 10, Align: 'Center', Hidden: false});
		ibCountryHeader.addHeader({Header: '한글명', Type: 'Text', SaveName: 'detailnm', Width: 30, Align: 'Left'});

		ibCountryHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, editable: false, MergeSheet :5, VScrollMode: 0 , NoFocusMode : 0 });
		ibCountryHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#searchArticlePopup')[0];
		createIBSheet2(container, 'searchArticlePopupSheet', '100%', '100%');
		ibCountryHeader.initSheet('searchArticlePopupSheet');
		searchArticlePopupSheet.SetSelectionMode(4);
// 		selectArticleList();
	}

	function searchArticlePopupSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			var detailcdPopup = searchArticlePopupSheet.GetCellValue(row, "detailcd");
			var detailnmPopup = searchArticlePopupSheet.GetCellValue(row, "detailnm");
			var returnObj = [];
			returnObj.push(detailcdPopup);
			returnObj.push(detailnmPopup);
			layerPopupCallback(returnObj);
			closeLayerPopup();
		}
	}

	function doItemPopupCodeChange(lv) {
		var popupForm = document.frmArticleSearch;

		if(lv != ""){
			popupForm.popupEvent.value = lv;
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/svcex/svcexCertificate/popup/selectArticleCodeList.do" />'
				, data : $('#frmArticleSearch').serialize()
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					setPopupComboBox(data);
				}
			});
		}
	}

	function setPopupComboBox(resultObj) {
		var svcexVO = resultObj.svcexVO;
		var resultList = resultObj.resultList;
		var popupForm = document.frmArticleSearch;
		var itemCd = '<c:out value="${svcexVO.itemCd}"/>';
		var lvl = '<c:out value="${svcexVO.searchGroupCd}"/>';
		var searchPopupItemLv1 = '<c:out value="${svcexVO.searchPopupItemLv1}"/>';
		var searchPopupItemLv2 = '<c:out value="${svcexVO.searchPopupItemLv2}"/>';
		var searchPopupItemLv3 = '<c:out value="${svcexVO.searchPopupItemLv3}"/>';

		if( svcexVO.popupEvent == "ITEM_LV1" ) {

			clear_select(eval('popupForm.searchPopupItemLv1'));
			add_select(eval('popupForm.searchPopupItemLv1'), "-- 대분류 --", "", 0);
			for( var i = 0; resultList.length > i; i++ ) {
				addSectSelect( resultList[i].detailcd, resultList[i].detailnm, "searchPopupItemLv1");
			}

			if( "" != itemCd ||"" != searchPopupItemLv1 || "" != searchPopupItemLv2 || "" != searchPopupItemLv3 ){
				if ( "" == searchPopupItemLv1 ){
					popupForm.searchPopupItemLv1.value = itemCd.substring(0,2);
				}else{
					popupForm.searchPopupItemLv1.value = searchPopupItemLv1;
				}

				doItemPopupCodeChange('ITEM_LV2');
			}
		}else if( svcexVO.popupEvent == "ITEM_LV2" ) {

			clear_select(eval('popupForm.searchPopupItemLv2'));
			add_select(eval('popupForm.searchPopupItemLv2'), "-- 중분류 --", "", 0);
			clear_select(eval('popupForm.searchPopupItemLv3'));
			add_select(eval('popupForm.searchPopupItemLv3'), "-- 세분류 --", "", 0);
			for( var i = 0; resultList.length > i; i++ ) {
				addSectSelect( resultList[i].detailcd, resultList[i].detailnm, "searchPopupItemLv2" );
			}

			if( itemCd.length > 3 || "" != searchPopupItemLv2 || "" != searchPopupItemLv3 ) {
				if("" == searchPopupItemLv2){
					popupForm.searchPopupItemLv2.value=itemCd.substring(0,4);
				}else{
					popupForm.searchPopupItemLv2.value=searchPopupItemLv2;
				}
				doItemPopupCodeChange('ITEM_LV3');
			}
		}else if( svcexVO.popupEvent == "ITEM_LV3" ) {

			clear_select(eval('popupForm.searchPopupItemLv3'));
			add_select(eval('popupForm.searchPopupItemLv3'), "-- 세분류 --", "", 0);
			for( var i = 0; resultList.length > i; i++ ) {
				addSectSelect( resultList[i].detailcd, resultList[i].detailnm, "searchPopupItemLv3" );
			}

			if(itemCd.length > 5 || "" != searchPopupItemLv3 ){
				if("" == searchPopupItemLv3){
					popupForm.searchPopupItemLv3.value = itemCd.substring(0,6);

				}else{
					popupForm.searchPopupItemLv3.value = searchPopupItemLv3;
				}
			}
		}
	}

	function add_select(obj, add_value, add_text, pos) {
		var opt = new Option(add_value, add_text);
		obj.options[pos] = opt;
		return;
	}
	function addSectSelect(value, dscr, formname) {
		var popupForm = document.frmArticleSearch;
		var selectObj = eval("popupForm."+formname);
		addOption(selectObj, value, dscr);
	}
	function addOption(obj, value, desc) {
		var option = new Option( desc , value , false );
		obj.options[obj.options.length] = option;
	}
	function clear_select(obj) {
		sel_len = obj.length;
		for(i = 0 ; i < sel_len; i++) {
			obj.options[0] = null;
		}
		return ;
	}

	function onClose() {
		// 레이어 닫기
		closeLayerPopup();
	}


</script>