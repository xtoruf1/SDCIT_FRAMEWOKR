<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="noticeForm" name="noticeForm" method="post" onsubmit="return false;">
<input type="hidden" id="noticeId" name="noticeId" value="0" />
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
	   <button type="button" class="btn_sm btn_secondary" onclick="doInit();">초기화</button>
	   <button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>

<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">검색</th>
				<td colspan="3">
					<fieldset class="form_group">
						<div class="group_item">
							<select id="searchCondition" name="searchCondition" class="form_select wAuto">
								<option value="TITLE" <c:if test="${param.searchCondition eq 'TITLE'}">selected="selected"</c:if>>제목</option>
								<option value="CONTENT" <c:if test="${param.searchCondition eq 'CONTENT'}">selected="selected"</c:if>>내용</option>
							</select>
						</div>
						<div class="group_item">
							<input type="text" id="searchKeyword" name="searchKeyword" value="${param.searchKeyword}" onkeydown="onEnter(doSearch);" class="textType form_text" title="검색어" />
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
		<!-- 상담내역조회 -->
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
		<div id="noticeList" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
</div>
</form>

<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: 'No', Type: 'Text', SaveName: 'vnum', Width: 20, Align: 'Center' });
	ibHeader.addHeader({Header: '제목', Type: 'Text', SaveName: 'title', Width: 200, Align: 'Left', Cursor:"Pointer"});
	ibHeader.addHeader({Header: '공개여부', Type: 'Text', SaveName: 'viewYn', Width: 30, Align: 'Center' });

	ibHeader.addHeader({Header: '공지사항ID', Type: 'Text', SaveName: 'noticeId', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	$(document).ready(function(){
		f = document.noticeForm;

		var container = $('#noticeList')[0];
		createIBSheet2(container, 'noticeListSheet', '100%', '100%');
		ibHeader.initSheet('noticeListSheet');

		// 편집모드 OFF
		noticeListSheet.SetEditable(0);
		getList();
	});

	function noticeListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('tblGridSheet_OnSearchEnd : ', msg);
		} else {
			// 제목에 볼드 처리
			noticeListSheet.SetColFontBold('title', 1);
		}
	}

	function noticeListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (noticeListSheet.ColSaveName(col) == 'title') {
				var noticeId = noticeListSheet.GetCellValue(row, 'noticeId');

				goView(noticeId);
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
			, url : '<c:url value="/uss/olh/notice/selectList.do" />'
			, data : $('#noticeForm').serialize()
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

				noticeListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	// 등록화면
	function goWrite() {
		f.action = '<c:url value="/uss/olh/notice/noticeCnRegistView.do" />';
		f.target = '_self';
		f.submit();
	}

	// 조회화면
	function goView(noticeId) {
		f.action = '<c:url value="/uss/olh/notice/noticeInqireCoUpdt.do" />';
		f.noticeId.value = noticeId;
		f.target = '_self';
		f.submit();
	}

	function noticeListSheet_OnRowSearchEnd(row) {
	   // 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
	   notEditableCellColor('noticeListSheet', row);
	}

	function doInit() {
		location.href = '<c:url value="/uss/olh/notice/list.do" />';
	}

</script>