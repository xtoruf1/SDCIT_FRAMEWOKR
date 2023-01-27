<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchSystemMenuId" value="${param.searchSystemMenuId}" />
<input type="hidden" name="searchAuthName" value="${param.searchAuthName}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10'/>" />
</form>
<form id="authForm" name="authForm" method="get" onsubmit="return false;">
<input type="hidden" id="systemMenuId" name="systemMenuId" value="<c:out value='${resultView.systemMenuId}' default='0' />" />
<input type="hidden" id="authId" name="authId" value="<c:out value='${resultView.authId}' default='0' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<div class="tbl_opt">
	<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
</div>
<div class="search">
	<table class="formTable">
		<colgroup>
			<col width="15%" />
			<col width="30%" />
			<col width="15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">시스템 <strong class="point">*</strong></th>
				<td>${resultView.systemMenuName}</td>
				<th scope="row">권한명 <strong class="point">*</strong></th>
				<td>
					<input type="text" id="authName" name="authName" value="${resultView.authName}" maxlength="30" class="form_text w100p" title="권한명" />
				</td>
            </tr>
            <tr>
				<th scope="row">기타코드</th>
				<td>
					<input type="text" id="etcCode" name="etcCode" value="${resultView.etcCode}" maxlength="30" class="form_text w100p" title="기타코드" />
				</td>
				<th scope="row">비고</th>
				<td>
					<input type="text" id="dscr" name="dscr" value="${resultView.dscr}" maxlength="300" class="form_text w100p" title="비고" />
				</td>
            </tr>
		</tbody>
	</table>
</div>
<div class="mt-20">
	<div id="authList" class="sheet"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 30, Align: 'Center', Hidden : true});
	ibHeader.addHeader({Header: '대메뉴', Type: 'Text', SaveName: 'lev1Name', Width: 75, Align: 'Left', Edit: false});
	ibHeader.addHeader({Header: '중메뉴', Type: 'Text', SaveName: 'lev2Name', Width: 75, Align: 'Left', Edit: false});
	ibHeader.addHeader({Header: 'URL', Type: 'Html', SaveName: 'url', Width: 100, Align: 'Left', Edit: false});
	ibHeader.addHeader({Header: '메뉴 접근 권한', Type: 'CheckBox', SaveName: 'accessAuthYn', Width: 35, Align: 'Center', Edit: true, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N'});
	ibHeader.addHeader({Header: '데이터 수정 권한', Type: 'CheckBox', SaveName: 'modifyAuthYn', Width: 35, Align: 'Center', Edit: true, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N'});

	ibHeader.addHeader({Header: '시스템 메뉴아이디', Type: 'Text', SaveName: 'systemMenuId', Hidden: true});
	ibHeader.addHeader({Header: '메뉴설정아이디', Type: 'Text', SaveName: 'menuSetId', Hidden: true});
	ibHeader.addHeader({Header: '권한아이디', Type: 'Text', SaveName: 'authId', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: -1, MergeSheet: 5, MaxSort: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	var lf;
	$(document).ready(function(){
		f = document.authForm;
		lf = document.listForm;
		<c:if test="${empty resultView.authId}">
			f.authName.focus();
		</c:if>

		var container = $('#authList')[0];
		createIBSheet2(container, 'authListSheet', '100%', '585px');
		ibHeader.initSheet('authListSheet');
		authListSheet.SetSelectionMode(4);

		getList();
	});

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/authority/setting/authList.do" />'
			, data : $('#authForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				authListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function authListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('authListSheet_OnSearchEnd : ', msg);
		} else {
    		$('#authList').height('100%');
    		authListSheet.SetEllipsis(1);
    		authListSheet.SetDataBackColor('#ffffff');
    		authListSheet.SetMouseHoverMode(2);
    		authListSheet.SetMousePointer('hand');
    		authListSheet.ShowToolTip(0);
    	}
    }

	function authListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('authListSheet', row);
	}

	function authListSheet_OnLoadData(data) {
		var jsonData = $.parseJSON(data);

		var newObj = {};

		// 객체에 값을 새로 할당
		newObj = Object.assign(newObj, jsonData);

		var rowdata = newObj.Data;
		rowdata.forEach(function(item, index){
			if (item.url) {
				var url = '';
				if (item.accessAuthYn == 'Y') {
					url += '<div style="margin-top: 4px;margin-left: 5px;">';
					url += '	<a href="javascript:void(0);" onclick="goProgramLink(\'' + item.url + '\');" style="color: #15498b;">' + item.url + '</a>';
					url += '</div>';
				} else if (item.accessAuthYn == 'N') {
					url += '<div style="margin-top: 4px;margin-left: 5px;">' + item.url + '</div>';
				}

				newObj.Data[index].url = url;
			}
		});

		return jsonData;
    }

	function goProgramLink(url) {
		window.open('${pageContext.request.contextPath}' + url, '_blank');
	}

	function authListSheet_OnChange(row, col, value) {
		if (row > 0) {
			var	saveName = authListSheet.CellSaveName(row, col);

			// 접근권한이 N 수정권한도 N 이다.
			if (saveName == 'accessAuthYn' && value == 'N') {
				authListSheet.SetCellValue(row, 'modifyAuthYn', 'N');
			}

			// 수정권한이 Y 접근권한도 Y 이다.
			if (saveName == 'modifyAuthYn' && value == 'Y') {
				authListSheet.SetCellValue(row, 'accessAuthYn', 'Y');
			}
		}
	}

	function isValid() {
		if (isStringEmpty(f.authName.value)) {
			alert('권한명을 입력해 주세요.');
			f.authName.focus();

			return false;
		}

		return true;
	}

	function doSave() {
		if (isValid()) {
			if (confirm('저장 하시겠습니까?')) {
				var af = $('#authForm').serializeObject();

				var saveJson = authListSheet.GetSaveJson();

				if (saveJson.data.length) {
					var map = {};
					var list = [];
					$.each(saveJson, function(key1, value1) {
						$.each(value1, function(key2, value2) {
							map = {};

							map.status = value2.status;
							map.lev1Name = value2.lev1Name;
							map.lev2Name = value2.lev2Name;
							map.accessAuthYn = value2.accessAuthYn;
							map.modifyAuthYn = value2.modifyAuthYn;
							map.systemMenuId = value2.systemMenuId;
							map.menuSetId = value2.menuSetId;
							map.authId = value2.authId;

							list.push(map);
						});

						af['authList'] = list;
					});
				}

				global.ajax({
					type : 'POST'
					, url : '<c:url value="/authority/setting/saveAuthInfo.do" />'
					, data : JSON.stringify(af)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						goList();
					}
				});
			}
		}
	}

	function goList() {
		lf.action = '<c:url value="/authority/setting/list.do" />';
		lf.target = '_self';
		lf.submit();
	}
</script>