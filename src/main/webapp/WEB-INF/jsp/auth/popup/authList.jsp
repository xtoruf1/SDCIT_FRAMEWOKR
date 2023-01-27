<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="popupAuthForm" name="popupAuthForm" method="get" onsubmit="return false;">
<input type="hidden" name="exceptIds" value="${param.exceptIds}" />
<div style="width: 800px;height: 720px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">권한 선택</h2>
		<div class="ml-auto">
			<button type="button" onclick="doSelectAuthIdAdd();" class="btn_sm btn_primary btn_modify_auth">추가</button>
		</div>
		<div class="ml-15">
			<button type="button" onclick="doAuthSearch();" class="btn_sm btn_primary">검색</button>
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>

	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<!--검색 시작 -->
		<div class="search">
			<table class="formTable">
				<colgroup>
					<col style="width:15%;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">시스템</th>
						<td>
							<select id="searchSystemMenuId" name="searchSystemMenuId" class="form_select" onchange="getAuthList();">
								<option value="" <c:if test="${empty param.searchSystemMenuId or param.searchSystemMenuId eq ''}">selected="selected"</c:if>>::: 전체 :::</option>
								<c:forEach var="system" items="${systemList}" varStatus="status">
									<option value="${system.systemMenuId}" <c:if test="${param.searchSystemMenuId eq system.systemMenuId}">selected="selected"</c:if>>${system.systemMenuName}</option>
								</c:forEach>
							</select>
						</td>
		            </tr>
				</tbody>
			</table>
		</div>
		<!--검색 끝 -->
		<div class="cont_block mt-20">
			<div id="popupAuthList" class="sheet"></div>
		</div>
	</div>
</div>
</form>
<script type="text/javascript">
	var	ibAuthHeader = new IBHeader();
	ibAuthHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibAuthHeader.addHeader({Header: '선택', Type: 'CheckBox', SaveName: 'checkAuthId', Width: 30, Align: 'Center', Edit: 1, HeaderCheck: 0});
	ibAuthHeader.addHeader({Header: '시스템', Type: 'Text', SaveName: 'systemMenuName', Width: 100, Align: 'Left', Edit: 0, Cursor: 'Pointer'});
	ibAuthHeader.addHeader({Header: '권한명', Type: 'Text', SaveName: 'authName', Width: 100, Align: 'Left', Edit: 0, Cursor: 'Pointer'});
	ibAuthHeader.addHeader({Header: '등록일시', Type: 'Text', SaveName: 'creDate', Width: 80, Align: 'Center', Edit: 0});

	ibAuthHeader.addHeader({Header: '시스템 메뉴아이디', Type: 'Text', SaveName: 'systemMenuId', Hidden: true});
	ibAuthHeader.addHeader({Header: '권한아이디', Type: 'Text', SaveName: 'authId', Hidden: true});

	ibAuthHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: 1, DragRowSelection: 1, MergeSheet: 5, MaxSort: 1});
	ibAuthHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var paf;
	$(document).ready(function(){
		paf = document.popupAuthForm;

		// 셀렉트 박스 값을 갱신
		$('.jquerySelectbox').selectmenu().selectmenu('refresh');

		var popupAuthContainer = $('#popupAuthList')[0];
		if (typeof popupAuthListSheet !== 'undefined' && typeof popupAuthListSheet.Index !== 'undefined') {
			popupAuthListSheet.DisposeSheet();
		}
		createIBSheet2(popupAuthContainer, 'popupAuthListSheet', '100%', '600px');
		ibAuthHeader.initSheet('popupAuthListSheet');
		popupAuthListSheet.SetSelectionMode(4);

		getAuthList();
	});

	function popupAuthListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('popupAuthListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 시스템에 볼드 처리
			popupAuthListSheet.SetColFontBold('systemMenuName', 1);
			// 권한명에 볼드 처리
			popupAuthListSheet.SetColFontBold('authName', 1);
    	}
    }

	function doAuthSearch() {
		getAuthList();
	}

	// 목록 가져오기
	function getAuthList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/authority/popup/selectAuthList.do" />'
			, data : $('#popupAuthForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				popupAuthListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function popupAuthListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('popupAuthListSheet', row);
	}

	function popupAuthListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (
				popupAuthListSheet.ColSaveName(col) == 'systemMenuName'
				|| popupAuthListSheet.ColSaveName(col) == 'authName'
			) {
				doSelectAuthId(popupAuthListSheet.GetRowData(row));
		    }
		}
	}

	// 권한을 선택하여 콜백
	function doSelectAuthId(returnObj) {
		var returnArray = [];

		// 오브젝트에서 등록일자 삭제
		delete returnObj.creDate;

		returnArray.push(returnObj);

		// 콜백
		layerPopupCallback(returnArray);

		// 레이어 닫기
		closeLayerPopup();
	}

	function doSelectAuthIdAdd() {
		var saveJson = popupAuthListSheet.GetSaveJson();

		if (saveJson.data.length) {
			var saveList = (saveJson.data || []).map(function(item){
				// 오브젝트에서 등록일자 삭제
				delete item.creDate;

				return item;
			});

			// 콜백
			layerPopupCallback(saveList);

			// 레이어 닫기
			closeLayerPopup();
		}
	}
</script>