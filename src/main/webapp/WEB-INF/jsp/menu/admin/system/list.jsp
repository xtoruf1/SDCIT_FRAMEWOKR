<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="systemForm" name="systemForm" method="get" onsubmit="return false;">
<input type="hidden" id="systemMenuId" name="systemMenuId" value="0" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="goWrite();" class="btn_sm btn_primary btn_modify_auth">신규</button>
		<button type="button" onclick="doDelete();" class="btn_sm btn_secondary btn_modify_auth">삭제</button>
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
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">시스템명</th>
				<td>
					<input type="text" id="searchSystemMenuName" name="searchSystemMenuName" value="${param.searchSystemMenuName}" onkeydown="onEnter(doSearch);" class="form_text w100p" title="시스템명" />
				</td>
				<th scope="row">비고</th>
				<td>
					<input type="text" id="searchDscr" name="searchDscr" value="${param.searchDscr}" onkeydown="onEnter(doSearch);" class="form_text w100p" />
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
			<select id="pageUnit" name="pageUnit" onchange="doSearch();" title="목록수" class="form_select">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</fieldset>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="systemList" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 20, Align: 'Center', Edit: 1, HeaderCheck: 0});
	ibHeader.addHeader({Header: '시스템명', Type: 'Text', SaveName: 'systemMenuName', Width: 60, Align: 'Left', Edit: 0, Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'dscr', Width: 150, Align: 'Left', Edit: 0});
	ibHeader.addHeader({Header: '등록일시', Type: 'Text', SaveName: 'creDate', Width: 40, Align: 'Center', Edit: 0});

	ibHeader.addHeader({Header: '시스템 메뉴아이디', Type: 'Text', SaveName: 'systemMenuId', Hidden: true});
	ibHeader.addHeader({Header: '메뉴등록여부', Type: 'Text', SaveName: 'settingYn', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	$(document).ready(function(){
		f = document.systemForm;

		var container = $('#systemList')[0];
		createIBSheet2(container, 'systemListSheet', '100%', '100%');
		ibHeader.initSheet('systemListSheet');
		systemListSheet.SetSelectionMode(4);

		getList();
	});

	function systemListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('systemListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 시스템명에 볼드 처리
			systemListSheet.SetColFontBold('systemMenuName', 1);
    	}
    }

	function systemListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (systemListSheet.ColSaveName(col) == 'systemMenuName') {
				var systemMenuId = systemListSheet.GetCellValue(row, 'systemMenuId');

				goView(systemMenuId);
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
			, url : '<c:url value="/menu/admin/system/selectList.do" />'
			, data : $('#systemForm').serialize()
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

				systemListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function systemListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('systemListSheet', row);

		// 메뉴가 설정되어 있다면 삭제할 수 없도록 체크박스를 다 disabled 시킨다.
	    if (systemListSheet.GetCellValue(row, 'settingYn') == 'Y') {
	    	systemListSheet.SetCellEditable(row, 'delFlag', 0);
	    	// 편집시 컬럼 색깔 변경
			// systemListSheet.SetCellBackColor(row, 'delFlag', '#ffffff');
	    	systemListSheet.SetToolTipText(row, 'delFlag', '메뉴에 등록된 시스템은 삭제할 수 없습니다.');
	    }
	}

	// 등록화면
	function goWrite() {
		f.action = '<c:url value="/menu/admin/system/regist.do" />';
		f.systemMenuId.value = '0';
		f.target = '_self';
		f.submit();
	}

	// 조회화면
	function goView(systemMenuId) {
		f.action = '<c:url value="/menu/admin/system/modify.do" />';
		f.systemMenuId.value = systemMenuId;
		f.target = '_self';
		f.submit();
	}

	// 삭제
	function doDelete() {
		var saveJson = systemListSheet.GetSaveJson();

		// 대상목록의 정보
		if (saveJson.Message == 'KeyFieldError') {
			return false;
		}

		if (saveJson.Message == 'InvalidInputError') {
			return false;
		}

		if (saveJson.data.length) {
			if (confirm('삭제 하시겠습니까?')) {
				var sf = $('#systemForm').serializeObject();

				var map = {};
				var list = [];
				$.each(saveJson, function(key1, value1) {
					map = {};
					$.each(value1, function(key2, value2) {
						map = value2;
						list.push(map);
					});

					sf['deleteMenuList'] = list;
				});

				global.ajax({
					type : 'POST'
					, url : '<c:url value="/menu/admin/system/deleteList.do" />'
					, data : JSON.stringify(sf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						location.href = '<c:url value="/menu/admin/system/list.do" />';
					}
				});
			}
		} else {
			alert('삭제할 시스템 메뉴 정보를 선택해 주세요.');
		}
	}
</script>