<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="commonCodeForm" name="commonCodeForm" method="get" onsubmit="return false;">
<input type="hidden" id="clCode" name="clCode" value="" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="goWrite();" class="btn_sm btn_primary btn_modify_auth">신규</button>
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
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">검색</th>
				<td colspan="3">
					<fieldset class="form_group">
						<div class="group_item">
							<select id="searchCondition" name="searchCondition" class="form_select">
								<option value="clCode" <c:if test="${param.searchCondition eq 'clCode'}">selected="selected"</c:if>>분류코드</option>
								<option value="clCodeNm" <c:if test="${param.searchCondition eq 'clCodeNm'}">selected="selected"</c:if>>분류코드명</option>
							</select>
						</div>
						<div class="group_item">
							<input type="text" id="searchKeyword" name="searchKeyword" value="${param.searchKeyword}" onkeydown="onEnter(doSearch);" class="form_text" title="검색어" />
						</div>
					</fieldset>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
		<select id="pageUnit" name="pageUnit" onchange="doSearch();" class="form_select ml-auto" title="목록수">
			<c:forEach var="item" items="${pageUnitList}" varStatus="status">
				<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
			</c:forEach>
		</select>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="codeList" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: 'No', Type: 'Text', SaveName: 'pageSeq', Width: 20, Align: 'Center'});
	ibHeader.addHeader({Header: '분류코드', Type: 'Text', SaveName: 'clCode', Width: 30, Align: 'Center'});
	ibHeader.addHeader({Header: '분류코드명', Type: 'Text', SaveName: 'clCodeNm', Width: 60, Align: 'left', Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '사용여부', Type: 'Text', SaveName: 'useAtNm', Width: 30, Align: 'Center'});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	$(document).ready(function(){
		f = document.commonCodeForm;

		var container = $('#codeList')[0];
		if (typeof codeListSheet !== 'undefined' && typeof codeListSheet.Index !== 'undefined') {
			codeListSheet.DisposeSheet();
		}
		createIBSheet2(container, 'codeListSheet', '100%', '100%');
		ibHeader.initSheet('codeListSheet');
		codeListSheet.SetSelectionMode(4);

		// 편집모드 OFF
		codeListSheet.SetEditable(0);

		getList();
	});

	function codeListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('codeListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 분류코드명에 볼드 처리
			codeListSheet.SetColFontBold('clCodeNm', 1);
    	}
    }

	function codeListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (codeListSheet.ColSaveName(col) == 'clCodeNm') {
				var clCode = codeListSheet.GetCellValue(row, 'clCode');

				goView(clCode);
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
			, url : '<c:url value="/commonCode/class/selectList.do" />'
			, data : $('#commonCodeForm').serialize()
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

				codeListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function codeListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('codeListSheet', row);
	}

	// 등록화면
	function goWrite() {
		f.action = '<c:url value="/commonCode/class/write.do" />';
		f.clCode.value = '';
		f.target = '_self';
		f.submit();
	}

	// 조회화면
	function goView(clCode) {
		f.action = '<c:url value="/commonCode/class/view.do" />';
		f.clCode.value = clCode;
		f.target = '_self';
		f.submit();
	}

	function doInit() {
		location.href = '<c:url value="/commonCode/class/list.do" />';
	}
</script>