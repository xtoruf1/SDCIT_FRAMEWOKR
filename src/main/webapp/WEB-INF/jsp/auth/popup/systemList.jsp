<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="popupMenuForm" name="popupMenuForm" method="get" onsubmit="return false;">
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">권한 시스템 선택</h2>
	<div class="ml-auto">
		<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
	</div>
</div>
<!-- 팝업 내용 -->
<div class="popup_body">
	<div id="popupMenuList" class="sheet"></div>
</div>
</form>
<script type="text/javascript">
	var	ibMenuHeader = new IBHeader();
	ibMenuHeader.addHeader({Header: 'No', Type: 'Text', SaveName: 'rn', Width: 30, Align: 'Center', Edit: 0});
	ibMenuHeader.addHeader({Header: '시스템명', Type: 'Text', SaveName: 'systemMenuName', Width: 80, Align: 'Left', Cursor: 'Pointer', Edit: 0});
	ibMenuHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'dscr', Width: 130, Align: 'Left', Edit: 0});
	
	ibMenuHeader.addHeader({Header: '시스템 메뉴아이디', Type: 'Text', SaveName: 'systemMenuId', Hidden: true});
		
	ibMenuHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: 1, DragRowSelection: 1, MergeSheet: 5, MaxSort: 1});
	ibMenuHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var pmf;
	$(document).ready(function(){
		pmf = document.popupMenuForm;
		
		var popupMenuContainer = $('#popupMenuList')[0];
		if (typeof popupMenuListSheet !== 'undefined' && typeof popupMenuListSheet.Index !== 'undefined') {
			popupMenuListSheet.DisposeSheet();
		}
		createIBSheet2(popupMenuContainer, 'popupMenuListSheet', '700px', '600px');
		ibMenuHeader.initSheet('popupMenuListSheet');
		popupMenuListSheet.SetSelectionMode(4);
		
		// 편집모드 OFF
		popupMenuListSheet.SetEditable(0);
		
		getMenuList();
	});
	
	function popupMenuListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('popupMenuListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 시스템명에 볼드 처리
			popupMenuListSheet.SetColFontBold('systemMenuName', 1);
    	}
    }
	
	// 목록 가져오기
	function getMenuList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/authority/popup/selectSystemList.do" />'
			, data : $('#popupMenuForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				popupMenuListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}
	
	function popupMenuListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('popupMenuListSheet', row);
	}
	
	function popupMenuListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (popupMenuListSheet.ColSaveName(col) == 'systemMenuName') {
				var systemMenuId = popupMenuListSheet.GetCellValue(row, 'systemMenuId');
				
				doSelectMenuId(systemMenuId);
		    }	
		}
	}
	
	// 시스템 메뉴아이디를 선택하여 콜백
	function doSelectMenuId(systemMenuId) {
		// 콜백
		layerPopupCallback(systemMenuId);
		
		// 레이어 닫기
		closeLayerPopup();
	}
</script>