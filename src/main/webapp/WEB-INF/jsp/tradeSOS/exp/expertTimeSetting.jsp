<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="openTimeSettingPopup();" class="btn_sm btn_primary btn_modify_auth">상담시간 변경</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">현재 상담시간</th>
				<td>${nowSetTime}</td>
				<th scope="row">변경예정 상담시간</th>
				<td>${nextSetTime}</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div style="width: 100%;height: 100%;">
		<div id="settingList" class="sheet"></div>
	</div>
</div>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '시작월', Type: 'Text', SaveName: 'fromDate', Width: 200, Align: 'Center'});
	ibHeader.addHeader({Header: '종료월', Type: 'Text', SaveName: 'endDate', Width: 200, Align: 'Center'});
	ibHeader.addHeader({Header: '설정시간', Type: 'Text', SaveName: 'setTime', Width: 200, Align: 'Center'});
	ibHeader.addHeader({Header: '등록자', Type: 'Text', SaveName: 'creBy', Width: 200, Align: 'Center'});
	ibHeader.addHeader({Header: '등록일시', Type: 'Text', SaveName: 'creDate', Width: 200, Align: 'Center'});
	ibHeader.addHeader({Header: '삭제', Type: 'Text', SaveName: 'delTxt', Width: 100, Align: 'Center', Cursor:'Pointer'});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	$(document).ready(function(){
		var container = $('#settingList')[0];
		createIBSheet2(container, 'settingListSheet', '100%', '100%');
		ibHeader.initSheet('settingListSheet');
		settingListSheet.SetSelectionMode(4);
		
		// 편집모드 OFF
		settingListSheet.SetEditable(0);
		
		getList();
	});
	
	// 1:1상담 시간 설정 조회
	function getList() {
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectTimeSettingList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {}
			, async : true
			, spinner : true
			, success : function(data){
				settingListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}
	
	function settingListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('settingListSheet', row);
		
		if (settingListSheet.GetCellValue(row, 'delTxt') == '삭제') {
			settingListSheet.SetCellFontColor(row, 'delTxt', '#ff0000');
			settingListSheet.SetCellFontUnderline(row, 'delTxt', 1);
		}
	}
	
	function settingListSheet_OnClick(row, col, value) {
	    if (settingListSheet.ColSaveName(col) == 'delTxt' && value == '삭제') {
	    	doDeleteTimeSetting(row);
	    }
	}
	
	function openTimeSettingPopup() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertTimeSettingPopup.do" />'
			, callbackFunction : function(resultObj){
				doSaveTimeSetting(resultObj);
			}
		});
	}
	
	function doSaveTimeSetting(settingObj) {
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/saveTimeSetting.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				fromYear : settingObj ? settingObj.popupFromYear : ''
				, fromMonth : settingObj ? settingObj.popupFromMonth : ''
				, setTime : settingObj ? settingObj.popupSetTime : ''
			}
			, async : true
			, spinner : true
			, success : function(data){
				if (data.result) {
					// 레이어 닫기
					closeLayerPopup();
					
					getList();	
				} else {
					alert(data.message);
				}
			}
		});
	}
	
	function doDeleteTimeSetting(row) {
		var fromMonth = settingListSheet.GetCellValue(row, 'fromDate');
		var setTime = settingListSheet.GetCellValue(row, 'setTime');
		
		if (confirm('[' + fromMonth + ']월 등록된 설정시간 [' + setTime + ']분을 삭제 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/resetTimeSetting.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					fromDate : fromMonth
				}
				, async : true
				, spinner : true
				, success : function(data){
					if (data.result) {
						getList();	
					} else {
						alert(data.message);
					}
				}
			});
		}
	}
</script>