<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="menuForm" name="menuForm" method="get" onsubmit="return false;">
<input type="hidden" id="menuSeq" name="menuSeq" value="0" />
<input type="hidden" id="depth" name="depth" value="1" />
<h2>Home &gt; 메뉴 관리 &gt; 메뉴관리</h2>
<div class="widget btn right" style="margin-top: 0px;">
	<a href="javascript:doSave();" class="ui-button ui-widget ui-corner-all">저장</a>
</div>
<div style="width: 100%;height: 100%;margin-top: 10px;">
	<div id="menuList" class="sheet"></div>
</div>
</form>
<!-- 프로그램 선택 레이어 영역 -->
<div id="programSearchPopup" class="modal modal-pop">
</div>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 40, Align: 'Center'});
	ibHeader.addHeader({Header: '시스템', Type: 'Html', SaveName: 'systemMenuName', Width: 70, Align: 'Left'});
	ibHeader.addHeader({Header: '대메뉴', Type: 'Html', SaveName: 'level1Name', Width: 70, Align: 'Left'});
	ibHeader.addHeader({Header: '중메뉴', Type: 'Html', SaveName: 'level2Name', Width: 70, Align: 'Left'});
	ibHeader.addHeader({Header: '하위메뉴', Type: 'Html', SaveName: 'level3Name', Width: 70, Align: 'Left'});
	ibHeader.addHeader({Header: 'URL', Type: 'Text', SaveName: 'url', Width: 130, Align: 'Left'});
	
	/*
	ibHeader.addHeader({Header: '메뉴 시퀀스', Type: 'Text', SaveName: 'menuSeq', Hidden: true});
	ibHeader.addHeader({Header: '상위 메뉴 시퀀스', Type: 'Text', SaveName: 'parentMenuSeq', Hidden: true});
	ibHeader.addHeader({Header: '프로그램 시퀀스', Type: 'Text', SaveName: 'programMenuSeq', Hidden: true});
	*/
	ibHeader.addHeader({Header: '뎁스', Type: 'Text', SaveName: 'menuDepth', Hidden: true});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	$(document).ready(function(){
		f = document.menuForm;
		
		var container = $('#menuList')[0];
		createIBSheet2(container, 'menuListSheet', '100%', '100%');
		ibHeader.initSheet('menuListSheet');
		
		getList();
	});
	
	function menuListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('menuListSheet_OnSearchEnd : ', msg);
    	} else {
    		menuListSheet.SetEllipsis(1);
    		menuListSheet.SetDataBackColor('#ffffff');
    		menuListSheet.SetMouseHoverMode(0);
    		menuListSheet.SetMousePointer('hand');
    		menuListSheet.ShowToolTip(0);
    	}
    }
	
	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/menu/selectList.do" />'
			, data : $('#menuForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				menuListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}
	
	function menuListSheet_OnLoadData(data) {
		var jsonData = $.parseJSON(data);
		
		var newObj = {};
		
		// 객체에 값을 새로 할당
		newObj = Object.assign(newObj, jsonData);
		
		var rowdata = newObj.Data;
		rowdata.forEach(function(item, index){
			var menuNm = '';
			menuNm += '<div style="display: flex;justify-content: space-between;">';
			menuNm += '	<div style="margin-top: 4px;margin-left: 7px;">';
			/*
			if (item.depth) {
				menuNm += '		<a href="javascript:showMenuList(\'' + item.menuSeq + '\', \'' + item.depth + '\');" style="color: #15498b;">';	
			}
			*/
			
			// DEPTH가 0이면 SYSTEM MENU
			if (item.menuDepth) {
				if (item.depth == 1) {
					menuNm += item.level1Name;
				} else if (item.depth == 2) {
					menuNm += item.level2Name;
				} else if (item.depth == 3) {
					menuNm += item.level3Name;
				}
			} else {
				menuNm += item.systemMenuName;
			}
			
			/*
			if (item.depth) {
				menuNm += '		</a>';	
			}
			*/
			menuNm += '	</div>';
			if (item.menuDepth != 3) {
				menuNm += '	<div style="margin-bottom: 4px;margin-right: 5px;">';
				menuNm += '		<button type="button" onclick="showProgramList(\'' + nvlString(item.menuId, '') + '\', \'' + item.systemMenuId + '\');" style="cursor: pointer;width: 16px;height: 16px;background: url(<c:url value="/images/icon/icon_plus.png" />) no-repeat center;border-radius: 2px;border: 1px solid #bbb;"><span class="blind"></span></button>';
				menuNm += '	</div>';	
			}
			menuNm += '</div>';

			// DEPTH가 0이면 SYSTEM MENU
			if (item.menuDepth) {
				if (item.depth == 1) {
					newObj.Data[index].level1Name = menuNm;
				} else if (item.depth == 2) {
					newObj.Data[index].level2Name = menuNm;
				} else if (item.depth == 3) {
					newObj.Data[index].level3Name = menuNm;
				}
			} else {
				newObj.Data[index].systemMenuName = menuNm;
			}
		});
		
		return newObj;
    }
	
	function showProgramList(menuId, systemMenuId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/menu/popup/programList.do" />'
		});
	}
		
	/*
	function showMenuList(menuSeq, depth) {
		window.open('<c:url value="/menu/popup/menuList.do" />?menuSeq=' + menuSeq + '&depth=' + depth, 'SDCIT', 'width=600, height=470');
	}
	
	// 저장
	function doSave() {
		var saveJson = menuListSheet.GetSaveJson();
		
		// 대상목록의 정보
		if (saveJson.Message == 'KeyFieldError') {
			return false;
		}
		
		if (saveJson.Message == 'InvalidInputError') {
			return false;
		}
		
		if (saveJson.data.length) {
			if (confirm('메뉴 정보를 저장하시겠습니까?')) {
				var mf = $('#menuForm').serializeObject();
				
				var map = {};
				var list = [];
				$.each(saveJson, function(key1, value1) {
					map = {};
					$.each(value1, function(key2, value2) {
						map = value2;
						list.push(map);
					});
					
					mf['menuList'] = list;
				});
				
				global.ajax({
					type : 'POST'
					, url : '<c:url value="/menu/updateMenu.do" />'
					, data : JSON.stringify(mf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						alert('메뉴 정보를 저장하였습니다.');
						getList();
					}
				});
			}
		}
	}
	*/
</script>