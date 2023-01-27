<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="popupExpertForm" name="popupExpertForm" method="get" onsubmit="return false;">
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">BEST상담위원 선정</h2>
	<div class="ml-auto">
		<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
	</div>
</div>
<!-- 팝업 내용 -->
<div class="popup_body">
	<div class="cont_block">
		※ 3명의 BEST 상담위원을 선정 하셔야 합니다.
		<div id="popupExpertList" class="sheet"></div>
	</div>
</div>
<div class="btn_group mt-20 _center">
	<button type="button" id="chooseExpertSave" onclick="doBestExpertSave();" class="btn btn_primary btn_modify_auth">저장</button>
</div>
</form>
<script type="text/javascript">
	var	ibExpertHeader = new IBHeader();
	ibExpertHeader.addHeader({Header: '순서', Type: 'Text', SaveName: 'seq', Width: 50, Align: 'Center', Edit: 0});
	ibExpertHeader.addHeader({Header: '상담분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 100, Align: 'Left', Edit: 0});
	ibExpertHeader.addHeader({Header: '전문가', Type: 'Text', SaveName: 'expertNm', Width: 90, Align: 'Center', Edit: 0});
	ibExpertHeader.addHeader({Header: 'BEST 적용기간', Type: 'Text', SaveName: 'bestQuarter', Width: 90, Align: 'Center', Edit: 0});
		
	ibExpertHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: 1, DragRowSelection: 1, MergeSheet: 5, MaxSort: 1});
	ibExpertHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	$(document).ready(function(){
		var popupExpertContainer = $('#popupExpertList')[0];
		if (typeof popupExpertListSheet !== 'undefined' && typeof popupExpertListSheet.Index !== 'undefined') {
			popupExpertListSheet.DisposeSheet();
		}
		createIBSheet2(popupExpertContainer, 'popupExpertListSheet', '700px', '600px');
		ibExpertHeader.initSheet('popupExpertListSheet');
		popupExpertListSheet.SetSelectionMode(4);
		
		// 편집모드 OFF
		popupExpertListSheet.SetEditable(0);
		
		var expertList = [];
		<c:forEach var="item" items="${expertList}" varStatus="status">
			var expert = {};
			expert.seq = '${status.count}';
			expert.consultTypeNm = '${item.consultTypeNm}';
			expert.expertNm = '${item.expertNm}';
			expert.bestQuarter = '${currentQuarter}';
			
			expertList.push(expert);
		</c:forEach>
		
		if (expertList.length < 3) {
			$('#chooseExpertSave').addClass('disabled');
			$('#chooseExpertSave').attr('disabled', true);
		}
		
		popupExpertListSheet.LoadSearchData({Data: expertList});
	});
	
	function popupExpertListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('popupExpertListSheet', row);
	}
	
	function popupExpertListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('popupExpertListSheet_OnSearchEnd : ', msg);
    	}
    }
	
	function doBestExpertSave() {
		// 콜백
		layerPopupCallback();
	}
</script>