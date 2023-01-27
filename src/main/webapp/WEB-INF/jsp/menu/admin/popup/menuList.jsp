<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="popupMenuForm" name="popupMenuForm" method="get" onsubmit="return false;">
<input type="hidden" name="menuGb" value="${param.menuGb}" />
<input type="hidden" name="menuSetId" value="${param.menuSetId}" />
<input type="hidden" name="upperId" value="${param.upperId}" />
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">
		<c:choose>
			<c:when test="${param.menuGb eq 'A'}">
				시스템 순서 변경
			</c:when>
			<c:otherwise>
				메뉴 순서 변경
			</c:otherwise>
		</c:choose>
	</h2>
	<div class="ml-auto">
		<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
	</div>
</div>
<!-- 팝업 내용 -->
<div class="popup_body">
	<div class="cont_block">
		<div class="tbl_opt">
			<span><strong class="point">*</strong> 드래그해서 순서를 변경하세요.</span>
		</div>
		<div id="popupMenuList" class="sheet"></div>
	</div>
</div>
<div class="btn_group mt-20 _center">
	<button type="button" onclick="doSave();" class="btn btn_primary btn_modify_auth">저장</button>
</div>
</form>
<script type="text/javascript">
	var	ibMenuHeader = new IBHeader();
	<c:choose>
		<c:when test="${param.menuGb eq 'A'}">
			ibMenuHeader.addHeader({Header: 'No', Type: 'Text', SaveName: 'rn', Width: 30, Align: 'Center', Edit: 0});
			ibMenuHeader.addHeader({Header: '시스템명', Type: 'Text', SaveName: 'systemMenuName', Width: 80, Align: 'Left', Edit: 0});
			ibMenuHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'dscr', Width: 130, Align: 'Left', Edit: 0});
			
			ibMenuHeader.addHeader({Header: '시스템 메뉴아이디', Type: 'Text', SaveName: 'systemMenuId', Hidden: true});
		</c:when>
		<c:otherwise>
			ibMenuHeader.addHeader({Header: 'No', Type: 'Text', SaveName: 'rn', Width: 30, Align: 'Center', Edit: 0});
			ibMenuHeader.addHeader({Header: '프로그램명', Type: 'Text', SaveName: 'pgmName', Width: 80, Align: 'Left', Edit: 0});
			ibMenuHeader.addHeader({Header: 'URL', Type: 'Text', SaveName: 'url', Width: 130, Align: 'Left', Edit: 0});
			
			ibMenuHeader.addHeader({Header: '메뉴설정아이디', Type: 'Text', SaveName: 'menuSetId', Hidden: true});
		</c:otherwise>
	</c:choose>
		
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
    	}
    }
	
	// 목록 가져오기
	function getMenuList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/menu/admin/popup/menu/selectList.do" />'
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
	
	// 드래그 행을 드랍위치에 추가하고 드래그 시트에서 삭제
	function popupMenuListSheet_OnDropEnd(fromSheet, fromRow, toSheet, toRow) {
		toSheet.DataMove(toRow + 1, fromRow);
		
		var index = 1;
		for (var i = popupMenuListSheet.LastRow(); i > 0 ; i--) {
			if (i != 0) {
				popupMenuListSheet.SetCellValue(index, 'rn', i);
				
				index++;
			}
		}
	}
	
	function doSave() {
		// 시트의 모든 데이터를 json 객체로 추출 
		var jsonData = popupMenuListSheet.ExportData({
			'Type' : 'json'
		});
		
		<c:choose>
			<c:when test="${param.menuGb eq 'A'}">
				var saveIds = jsonData.data.map(function(item){
					return item.systemMenuId;
				});
			</c:when>
			<c:otherwise>
				var saveIds = jsonData.data.map(function(item){
					return item.menuSetId;
				});
			</c:otherwise>
		</c:choose>
		
		// 콜백
		layerPopupCallback(saveIds.join(','));
	}
</script>