<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="menuForm" name="menuForm" method="get" onsubmit="return false;">
<input type="hidden" id="menuSetId" name="menuSetId" value="" />
<input type="hidden" id="systemMenuId" name="systemMenuId" value="0" />
<input type="hidden" id="pgmId" name="pgmId" value="0" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doDeleteList();" class="btn_sm btn_secondary btn_modify_auth">삭제</button>
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
			<col style="width:15%"  />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">시스템</th>
				<td>
					<select id="searchCondition" name="searchCondition" class="form_select">
						<option value="" <c:if test="${empty param.searchCondition or param.searchCondition eq ''}">selected="selected"</c:if>>::: 전체 :::</option>
						<c:forEach var="system" items="${systemList}" varStatus="status">
							<option value="${system.systemMenuId}" <c:if test="${param.searchCondition eq system.systemMenuId}">selected="selected"</c:if>>${system.systemMenuName}</option>
						</c:forEach>
					</select>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div style="width: 100%;height: 100%;">
		<div id="menuList" class="sheet"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 30, Align: 'Center', Edit: 1, HeaderCheck: 0});
	ibHeader.addHeader({Header: '시스템', Type: 'Html', SaveName: 'systemMenuName', Width: 65, Align: 'Left', Edit: 0});
	ibHeader.addHeader({Header: '대메뉴', Type: 'Html', SaveName: 'lev1Name', Width: 65, Align: 'Left', Edit: 0});
	ibHeader.addHeader({Header: '중메뉴', Type: 'Html', SaveName: 'lev2Name', Width: 80, Align: 'Left', Edit: 0});
	ibHeader.addHeader({Header: 'URL', Type: 'Html', SaveName: 'url', Width: 120, Align: 'Left', Edit: 0});

	ibHeader.addHeader({Header: '메뉴설정아이디', Type: 'Text', SaveName: 'menuSetId', Hidden: true});
	ibHeader.addHeader({Header: '프로그램아이디', Type: 'Text', SaveName: 'pgmId', Hidden: true});
	ibHeader.addHeader({Header: '상위아이디', Type: 'Text', SaveName: 'upperId', Hidden: true});
	ibHeader.addHeader({Header: '상위아이디2', Type: 'Text', SaveName: 'upperId2', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: -1, MergeSheet: 5, MaxSort: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	$(document).ready(function(){
		f = document.menuForm;

		var container = $('#menuList')[0];
		createIBSheet2(container, 'menuListSheet', '100%', '600px');
		ibHeader.initSheet('menuListSheet');
		menuListSheet.SetSelectionMode(4);

		getList();
	});

	function menuListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('menuListSheet_OnSearchEnd : ', msg);
		} else {
    		$('#menuList').height('100%');
    		menuListSheet.SetEllipsis(1);
    		menuListSheet.SetDataBackColor('#ffffff');
    		menuListSheet.SetMouseHoverMode(2);
    		menuListSheet.SetMousePointer('hand');
    		menuListSheet.ShowToolTip(0);
    	}
    }

	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/menu/admin/selectList.do" />'
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
		var systemMenuId;
		rowdata.forEach(function(item, index){
			var menuNm = '';
			menuNm += '<div style="display: flex;justify-content: space-between;">';
			menuNm += '	<div style="margin-top: 4px;margin-left: 5px;">';
			menuNm += '		<a href="javascript:void(0);" onclick="javascript:showMenuList(\'\', \'\');" style="color: #15498b;">';
			menuNm += item.systemMenuName;
			menuNm += '		</a>';
			menuNm += '	</div>';
			if (systemMenuId != item.systemMenuId) {
				menuNm += '	<div style="margin-bottom: 4px;margin-right: 5px;">';
				menuNm += '		<button type="button" onclick="showProgramList(\'\', \'' + item.systemMenuId + '\', \'' + item.systemMenuName + '\');" style="cursor: pointer;width: 16px;height: 16px;background: url(<c:url value="/images/icon/icon_plus.png" />) no-repeat center;border-radius: 2px;border: 1px solid #bbb;"><span class="blind"></span></button>';
				menuNm += '	</div>';
			}
			menuNm += '</div>';

			newObj.Data[index].systemMenuName = menuNm;

			menuNm = '';
			menuNm += '<div style="display: flex;justify-content: space-between;">';
			menuNm += '	<div style="margin-top: 4px;margin-left: 5px;">';
			menuNm += '		<a href="javascript:void(0);" onclick="javascript:showMenuList(\'' + item.menuSetId + '\', \'' + nvlString(item.upperId, '') + '\');" style="color: #15498b;">';

			var levName;
			if (item.menuDepth == 1) {
				menuNm += item.lev1Name;
				levName = item.lev1Name;
			} else if (item.menuDepth == 2) {
				menuNm += item.lev2Name;
				levName = item.lev2Name;
			} else if (item.menuDepth == 3) {
				menuNm += item.lev3Name;
				levName = item.lev3Name;
			}

			menuNm += '		</a>';

			menuNm += '	</div>';
			if (item.menuDepth < 2) {
				menuNm += '	<div style="margin-bottom: 4px;margin-right: 5px;">';
				menuNm += '		<button type="button" onclick="showProgramList(\'' + nvlString(item.menuSetId, '') + '\', \'' + item.systemMenuId + '\', \'' + nvlString(levName, '') + '\');" style="cursor: pointer;width: 16px;height: 16px;background: url(<c:url value="/images/icon/icon_plus.png" />) no-repeat center;border-radius: 2px;border: 1px solid #bbb;"><span class="blind"></span></button>';
				menuNm += '	</div>';
			}
			menuNm += '</div>';

			if (item.menuDepth == 1) {
				newObj.Data[index].lev1Name = menuNm;
			} else if (item.menuDepth == 2) {
				newObj.Data[index].lev2Name = menuNm;
			} else if (item.menuDepth == 3) {
				newObj.Data[index].lev3Name = menuNm;
			}

			if (item.url) {
				var url = '<div style="margin-top: 4px;margin-left: 5px;">';
				url += '	<a href="javascript:void(0);" onclick="goProgramLink(\'' + item.url + '\');" style="color: #15498b;">' + item.url + '</a>';
				url += '</div>';

				newObj.Data[index].url = url;
			}

			systemMenuId = item.systemMenuId;
		});

		return newObj;
    }

	function goProgramLink(url) {
		window.open('${pageContext.request.contextPath}' + url, '_blank');
	}

	function menuListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('menuListSheet', row);

		// 메뉴설정아이디가 없으면 체크박스를 다 disabled 시킨다.
	    if (isStringEmpty(menuListSheet.GetCellValue(row, 'menuSetId'))) {
	    	menuListSheet.SetCellEditable(row, 'delFlag', 0);
	    	// 편집시 컬럼 색깔 변경
			menuListSheet.SetCellBackColor(row, 'delFlag', '#ffffff');
	    }
	}

	function menuListSheet_OnChange(row, col, value) {
		if (row > 0) {
			var	saveName = menuListSheet.CellSaveName(row, col);

			// 삭제를 눌렀을 경우 하위의 모든 값을 체크하고 편집모드를 false 한다.
			// 반대로 체크를 풀었을 경우 하위의 모든 값의 체크를 풀고 편집모드를 true 한다.
			// SetCellValue 에서 Onchange 이벤트가 자동적으로 걸리므로 재귀를 자동적으로 해준다.
			if (saveName == 'delFlag') {
				var pgmId = menuListSheet.GetCellValue(row, 'pgmId');

				for (var i = 0; i < menuListSheet.LastRow(); i++) {
					var upperId = menuListSheet.GetCellValue(i, 'upperId');

					if (upperId == pgmId) {
						menuListSheet.SetCellValue(i, 'delFlag', value);
						menuListSheet.SetCellEditable(i, 'delFlag', !value);
					}
				}
			}
		}
	}

	function showProgramList(menuSetId, systemMenuId, menuName) {
		f.menuSetId.value = menuSetId;
		f.systemMenuId.value = systemMenuId;

		global.openLayerPopup({
			popupUrl : '<c:url value="/menu/admin/popup/programList.do" />'
			, callbackFunction : function(resultObj){
				if (confirm(menuName + ' 메뉴 하위로 저장 하시겠습니까?')) {
					doInsertMenuProgram(resultObj);
				}
			}
		});
	}

	function doInsertMenuProgram(pgmIdObj) {
		var mf = $('#menuForm').serializeObject();
		mf['pgmIdList'] = pgmIdObj.split(',');

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/menu/admin/insertMenuProgram.do" />'
			, data : JSON.stringify(mf)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				// 레이어 닫기
				closeLayerPopup();

				getList();
			}
		});
	}

	function showMenuList(menuSetId, upperId) {
		var menuGb = menuSetId ? 'M' : 'A';

		global.openLayerPopup({
			popupUrl : '<c:url value="/menu/admin/popup/menuList.do" />'
			, params : {
				menuGb : menuGb
				, menuSetId : menuSetId
				, upperId : upperId
			}
			, callbackFunction : function(resultObj){
				if (confirm('메뉴 정렬순서를 변경 하시겠습니까?')) {
					doUpdateMenuSort(menuGb, resultObj);
				}
			}
		});
	}

	function doUpdateMenuSort(menuGb, returnIds) {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/menu/admin/updateMenuSort.do" />'
			, data : {
				menuGb : menuGb
				, menuSetIds : returnIds
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				// 레이어 닫기
				closeLayerPopup();

				getList();
			}
		});
	}

	// 메뉴 목록 삭제
	function doDeleteList() {
		var saveJson = menuListSheet.GetSaveJson();

		// 대상목록의 정보
		if (saveJson.Message == 'KeyFieldError') {
			return false;
		}

		if (saveJson.Message == 'InvalidInputError') {
			return false;
		}

		if (saveJson.data.length) {
			if (confirm('삭제 하시겠습니까?')) {
				var mf = $('#menuForm').serializeObject();

				var map = {};
				var list = [];
				$.each(saveJson, function(key1, value1) {
					$.each(value1, function(key2, value2) {
						map = {};

						map.status = value2.status;
						map.delFlag = value2.delFlag;
						map.menuSetId = value2.menuSetId;
						map.pgmId = value2.pgmId;
						map.upperId = value2.upperId;
						map.upperId2 = value2.upperId2;

						list.push(map);
					});

					mf['menuList'] = list;
				});

				global.ajax({
					type : 'POST'
					, url : '<c:url value="/menu/admin/deleteMenuList.do" />'
					, data : JSON.stringify(mf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						getList();
					}
				});
			}
		} else {
			alert('삭제할 메뉴 정보를 선택해 주세요.');
		}
	}
</script>