<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="programForm" name="programForm" method="get" onsubmit="return false;">
<input type="hidden" id="pgmId" name="pgmId" value="0" />
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
				<th scope="row">프로그램명</th>
				<td>
					<fieldset class="group_item">
						<input type="text" id="searchPgmName" name="searchPgmName" value="${param.searchPgmName}" onkeydown="onEnter(doSearch);" class="form_text" title="프로그램명" />
						<label class="label_form ml-30">
							<input type="checkbox" id="searchSubYn" class="form_checkbox" title="하위포함" <c:if test="${param.searchDetailYn eq 'Y'}">checked="checked"</c:if> />
							<span class="label">하위포함</span>
						</label>
						<input type="hidden" name="searchDetailYn" value="N" />
					</fieldset>					
				</td>
				<th scope="row">URL</th>
				<td>
					<input type="text" id="searchUrl" name="searchUrl" value="${param.searchUrl}" onkeydown="onEnter(doSearch);" class="form_text w100p" title="URL" />
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
		<div id="programList" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 25, Align: 'Center', Edit: 1, HeaderCheck: 0});
	ibHeader.addHeader({Header: '프로그램명', Type: 'Text', SaveName: 'pgmName', Width: 90, Align: 'Left', Edit: 0, Cursor: 'Pointer'});
	ibHeader.addHeader({Header: 'URL', Type: 'Text', SaveName: 'url', Width: 120, Align: 'Left', Edit: 0});
	ibHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'dscr', Width: 165, Align: 'Left', Edit: 0});
	ibHeader.addHeader({Header: '등록일시', Type: 'Text', SaveName: 'creDate', Width: 60, Align: 'Center', Edit: 0});
	
	ibHeader.addHeader({Header: '프로그램 시퀀스', Type: 'Text', SaveName: 'pgmId', Hidden: true});
	ibHeader.addHeader({Header: '메뉴등록여부', Type: 'Text', SaveName: 'settingYn', Hidden: true});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	$(document).ready(function(){
		f = document.programForm;
		
		var container = $('#programList')[0];
		createIBSheet2(container, 'programListSheet', '100%', '100%');
		ibHeader.initSheet('programListSheet');
		programListSheet.SetSelectionMode(4);
		
		getList();
	});
	
	function programListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('programListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 프로그램명에 볼드 처리
			programListSheet.SetColFontBold('pgmName', 1);
    	}
    }
	
	function programListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (programListSheet.ColSaveName(col) == 'pgmName') {
				var pgmId = programListSheet.GetCellValue(row, 'pgmId');
				
				goView(pgmId);
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
		if ($('#searchSubYn').is(':checked')) {
			f.searchDetailYn.value = 'Y';
		} else {
			f.searchDetailYn.value = 'N';
		}
		
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/menu/admin/program/selectList.do" />'
			, data : $('#programForm').serialize()
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

				programListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}
	
	function programListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('programListSheet', row);
		
		// 메뉴가 설정되어 있다면 삭제할 수 없도록 체크박스를 다 disabled 시킨다.
	    if (programListSheet.GetCellValue(row, 'settingYn') == 'Y') {
	    	programListSheet.SetCellEditable(row, 'delFlag', 0);
	    	// 편집시 컬럼 색깔 변경
			// programListSheet.SetCellBackColor(row, 'delFlag', '#ffffff');
	    	programListSheet.SetToolTipText(row, 'delFlag', '메뉴에 등록된 프로그램은 삭제할 수 없습니다.');
	    } 
	}
	
	// 등록화면
	function goWrite() {
		f.action = '<c:url value="/menu/admin/program/regist.do" />';
		f.pgmId.value = '0';
		f.target = '_self';
		f.submit();
	}
	
	// 조회화면
	function goView(pgmId) {
		f.action = '<c:url value="/menu/admin/program/modify.do" />';
		f.pgmId.value = pgmId;
		f.target = '_self';
		f.submit();
	}
	
	// 삭제
	function doDelete() {		
		var saveJson = programListSheet.GetSaveJson();
		
		// 대상목록의 정보
		if (saveJson.Message == 'KeyFieldError') {
			return false;
		}
		
		if (saveJson.Message == 'InvalidInputError') {
			return false;
		}
		
		if (saveJson.data.length) {
			if (confirm('삭제 하시겠습니까?')) {
				var pf = $('#programForm').serializeObject();
				
				var map = {};
				var list = [];
				$.each(saveJson, function(key1, value1) {
					map = {};
					$.each(value1, function(key2, value2) {
						map = value2;
						list.push(map);
					});
					
					pf['deleteList'] = list;
				});
				
				global.ajax({
					type : 'POST'
					, url : '<c:url value="/menu/admin/program/deleteList.do" />'
					, data : JSON.stringify(pf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						location.href = '<c:url value="/menu/admin/program/list.do" />';
					}
				});
			}
		} else {
			alert('삭제할 프로그램 정보를 선택해 주세요.');
		}
	}
</script>