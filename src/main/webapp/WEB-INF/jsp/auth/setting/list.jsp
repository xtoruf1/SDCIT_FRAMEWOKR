<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="authForm" name="authForm" method="get" onsubmit="return false;">
<input type="hidden" id="systemMenuId" name="systemMenuId" value="0" />
<input type="hidden" id="authId" name="authId" value="0" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="showAuthSystemList();" class="btn_sm btn_primary btn_modify_auth">신규</button>
		<button type="button" onclick="doDelete();" class="btn_sm btn_secondary btn_modify_auth">삭제</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doInit();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">시스템</th>
				<td>
					<select id="searchSystemMenuId" name="searchSystemMenuId" class="form_select">
						<option value="" <c:if test="${empty param.searchSystemMenuId or param.searchSystemMenuId eq ''}">selected="selected"</c:if>>::: 전체 :::</option>
						<c:forEach var="system" items="${systemList}" varStatus="status">
							<option value="${system.systemMenuId}" <c:if test="${param.searchSystemMenuId eq system.systemMenuId}">selected="selected"</c:if>>${system.systemMenuName}</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">권한명</th>
				<td>
					<input type="text" id="searchAuthName" name="searchAuthName" value="${param.searchAuthName}" onkeydown="onEnter(doSearch);" class="form_text w100p" title="비고" />
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div class="tbl_opt">
		<!-- 전체 게시글 -->
		<div id="totalCnt" class="total_count"></div>
		<fieldset class="ml-auto">
			<select id="pageUnit" name="pageUnit" title="목록수" onchange="doSearch();" class="form_select">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</fieldset>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="authList" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 20, Align: 'Center', Edit: 1, HeaderCheck: 0});
	ibHeader.addHeader({Header: '시스템명', Type: 'Text', SaveName: 'systemMenuName', Width: 100, Align: 'Left', Edit: 0, Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '권한명', Type: 'Text', SaveName: 'authName', Width: 160, Align: 'Left', Edit: 0, Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '등록일시', Type: 'Text', SaveName: 'creDate', Width: 70, Align: 'Center', Edit: 0});

	ibHeader.addHeader({Header: '시스템 메뉴아이디', Type: 'Text', SaveName: 'systemMenuId', Hidden: true});
	ibHeader.addHeader({Header: '권한아이디', Type: 'Text', SaveName: 'authId', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	$(document).ready(function(){
		f = document.authForm;

		var container = $('#authList')[0];
		createIBSheet2(container, 'authListSheet', '100%', '100%');
		ibHeader.initSheet('authListSheet');
		authListSheet.SetSelectionMode(4);

		getList();
	});

	function authListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('authListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 시스템명에 볼드 처리
			authListSheet.SetColFontBold('systemMenuName', 1);
			// 권한명에 볼드 처리
			authListSheet.SetColFontBold('authName', 1);
    	}
    }

	function authListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (
				authListSheet.ColSaveName(col) == 'systemMenuName'
				|| authListSheet.ColSaveName(col) == 'authName'
			) {
				var systemMenuId = authListSheet.GetCellValue(row, 'systemMenuId');
				var authId = authListSheet.GetCellValue(row, 'authId');

				goWrite(systemMenuId, authId);
		    }
		}
	}

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/authority/setting/selectList.do" />'
			, data : $('#authForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				authListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function authListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('authListSheet', row);
	}

	function showAuthSystemList() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/authority/popup/systemList.do" />'
			, callbackFunction : function(resultObj){
				goWrite(resultObj);
			}
		});
	}

	// 등록 / 수정화면
	function goWrite(systemMenuId, authId) {
		f.action = '<c:url value="/authority/setting/write.do" />';
		f.systemMenuId.value = systemMenuId;
		if (authId) {
			f.authId.value = authId;
		}
		f.target = '_self';
		f.submit();
	}

	// 삭제
	function doDelete() {
		var saveJson = authListSheet.GetSaveJson();

		// 대상목록의 정보
		if (saveJson.Message == 'KeyFieldError') {
			return false;
		}

		if (saveJson.Message == 'InvalidInputError') {
			return false;
		}

		if (saveJson.data.length) {
			if (confirm('해당 권한이 부여된 사용자 권한도 함께 삭제됩니다.')) {
				var af = $('#authForm').serializeObject();

				var map = {};
				var list = [];
				$.each(saveJson, function(key1, value1) {
					map = {};
					$.each(value1, function(key2, value2) {
						map = value2;
						list.push(map);
					});

					af['deleteAuthList'] = list;
				});

				global.ajax({
					type : 'POST'
					, url : '<c:url value="/authority/setting/deleteList.do" />'
					, data : JSON.stringify(af)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						location.href = '<c:url value="/authority/setting/list.do" />';
					}
				});
			}
		} else {
			alert('삭제할 권한 설정 정보를 선택해 주세요.');
		}
	}

	function doInit() {
		location.href = '<c:url value="/authority/setting/list.do" />';
	}
</script>