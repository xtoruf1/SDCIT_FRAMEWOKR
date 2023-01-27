<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="organizationForm" name="organizationForm" method="get" onsubmit="return false;">
<h2>조직관리</h2>
<div style="display: flex;justify-content: space-between;">
	<div style="width: 100%;height: 100%;">
		<div>▶ 조직</div>
		<div class="widget btn right" style="margin-top: -17px;">
			<a href="javascript:doRowAdd();" class="ui-button ui-widget ui-corner-all">추가</a>
			<a href="javascript:doSave();" class="ui-button ui-widget ui-corner-all">저장</a>
		</div>
		<div style="margin-top: -6px;">
			<div id="organizationList" class="sheet" style="margin-top: 10px;"></div>
		</div>
	</div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 40, Align: 'Center'});
	ibHeader.addHeader({Header: '조직 아이디', Type: 'Text', SaveName: 'organizationId', Align: 'Left', MinWidth: 200, Edit: 0, TreeCol: 1});
	ibHeader.addHeader({Header: '조직명', Type: 'Text', SaveName: 'organizationNm', Align: 'Left', MinWidth: 100});
	ibHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'etc', Align: 'Left', MinWidth: 400});
	
	ibHeader.addHeader({Header: '상위 조직 아이디', Type: 'Text', SaveName: 'parentOrganizationId', Hidden: true});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 20, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, TreeNodeIcon: 0, TreeCheck: 1, HeaderCheckSync: 1, DragMode: -1, MergeSheet: 5, ChildPage: 10, MaxSort: 1, UseJsonTreeLevel: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});
		
	var f;
	var treeObj;
	$(document).ready(function(){
		f = document.organizationForm;
		
		var container = $('#organizationList')[0];
        createIBSheet2(container, 'organizationListSheet', '100%', '750px');
        ibHeader.initSheet('organizationListSheet');
        organizationListSheet.SetWaitImageVisible(0);
        
		// 조직 목록 가져오기
        getList();
	});
	
	// 조직 목록 가져오기
	function getList() {
		organizationListSheet.DoSearch('<c:url value="/organization/selectList.do" />');
	}
	
	// 조직에 행 추가
	function doRowAdd() {
		var index = organizationListSheet.DataInsert();
		
		// 편집을 할수 있도록 변경
		organizationListSheet.SetCellEditable(index, 'organizationId', 1);
	}
	
	function isValid() {
		var saveJson = organizationListSheet.GetSaveJson();
		
		// 대상목록의 정보
		if (saveJson.Message == 'KeyFieldError') {
			return false;
		}
		
		if (saveJson.Message == 'InvalidInputError') {
			return false;
		}
		
		var isIdValid = true;
		var isNmValid = true;
		
		if (saveJson.data.length) {
			$.each(saveJson, function(key1, value1) {
				$.each(value1, function(key2, value2) {
					// 삭제는 삭제 대상이기 때문에 유효성을 체크하지 않는다.
					if (value2.status == 'I' || value2.status == 'U') {
						if (isStringEmpty(value2.organizationId)) {
							isIdValid = false;
						}
						
						if (isStringEmpty(value2.organizationNm)) {
							isNmValid = false;
						}
					}
				});
			});
		}
		
		if (!isIdValid) {
			alert('조직 아이디를 입력해 주세요.');
			
			return false;
		}
		
		if (!isNmValid) {
			alert('조직명을 입력해 주세요.');
			
			return false;
		}
		
		return true;
	}
	
	// 조직 트리를 재귀 json 목록 변경
	function recursiveTree(list, tree, parentId) {
		if (tree) {
			var map = {};
			for (var i = 0; i < tree.length; i++) {
				map = {};
				map.status = tree[i].status;
				map.organizationId = tree[i].organizationId;
				map.organizationNm = tree[i].organizationNm;
				map.parentOrganizationId = parentId ? parentId : '';
				map.etc = tree[i].etc;
				
				list.push(map);
				
				recursiveTree(list, tree[i].Items, tree[i].organizationId);
			}	
		}
	}
	
	function doSave() {
		if (isValid()) {
			 if (confirm('조직 정보를 저장하시겠습니까?')) {
				var treeJson = organizationListSheet.GetTreeJson();
				
				if (treeJson.data.length) {
					var list = [];
					recursiveTree(list, treeJson.data);
					
					// 읽기는 가져올 필요가 없음.
					list = list.filter(function(element){ 
						return element.status != 'R';
					});
					
					var of = $('#organizationForm').serializeObject();
					
					of['organizationList'] = list;
					
					global.ajax({
						type : 'POST'
						, url : '<c:url value="/organization/saveOrganization.do" />'
						, data : JSON.stringify(of)
						, contentType : 'application/json'
						, dataType : 'json'
						, async: false
						, spinner : true
						, success : function(data){
							alert('조직 정보를 저장하였습니다.');
							getList();
						}
					});
				}
			}
		}
	}
</script>