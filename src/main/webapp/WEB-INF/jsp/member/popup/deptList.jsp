<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="organizationForm" name="organizationForm" method="get" onsubmit="return false;">
<h2>부서 목록</h2>
<div style="width: 100%;height: 100%;">
	<div id="organizationList" class="sheet"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '부서명', Type: 'Text', SaveName: 'organizationNm', Align: 'Left', MinWidth: 130, TreeCol: 1});
	ibHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'etc', Align: 'Left', MinWidth: 170});
	
	ibHeader.addHeader({Header: '부서 아이디', Type: 'Text', SaveName: 'organizationId', Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '상위 부서 아이디', Type: 'Text', SaveName: 'parentOrganizationId', Hidden: true});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 20, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, TreeNodeIcon: 0, TreeCheck: 1, HeaderCheckSync: 1, DragMode: -1, MergeSheet: 5, ChildPage: 10, MaxSort: 1, UseJsonTreeLevel: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});
		
	var f;
	$(document).ready(function(){
		f = document.organizationForm;
		
		$('#column_popup').css('min-height', '560px');
		
		var container = $('#organizationList')[0];
        createIBSheet2(container, 'organizationListSheet', '100%', '750px');
        ibHeader.initSheet('organizationListSheet');
        organizationListSheet.SetWaitImageVisible(0);
        organizationListSheet.SetEditable(0);
        
		// 조직 목록 가져오기
        getList();
	});
	
	// 조직 목록 가져오기
	function getList() {
		organizationListSheet.DoSearch('<c:url value="/organization/selectList.do" />');
	}
	
	function organizationListSheet_OnLoadData(data) {
		var jsonData = $.parseJSON(data);
		
		var newObj = {};
		
		// 객체에 새로 할당뒤 레벨 1단계만 필터링
		newObj = Object.assign(newObj, jsonData);
		
		var rowdata = newObj.data;
		rowdata.forEach(function(item){
			if (item.level == 1) {
				item.organizationNm = 'ROOT';
			}
		});
		
		return newObj;
    }
	
	function organizationListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (organizationListSheet.ColSaveName(col) == 'organizationNm' && !organizationListSheet.IsHaveChild(row, 1)) {
			var deptId = organizationListSheet.GetCellValue(row, 'organizationId');
			var deptNm = organizationListSheet.GetCellValue(row, 'organizationNm');
			
			opener.setDeptInfo(deptId, deptNm);
			
			window.close();
		}
   	}
</script>