<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="get" onsubmit="return false;">
<input type="hidden" name="boardId" id="boardId" value="" />
<input type="hidden" name="fileId" id="fileId" value="" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="goWrite();" class="btn_sm btn_primary btn_modify_auth">신규</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">키워드</th>
				<td>
					<div class="flex align_center">
						<select id="searchCondition" name="searchCondition" class="form_select">
							<option value="TITLE" <c:if test="${param.searchCondition eq 'TITLE'}">selected</c:if>>제목</option>
							<option value="CONTENT" <c:if test="${param.searchCondition eq 'CONTENT'}">selected</c:if>>내용</option>
							<option value="ALL" <c:if test="${param.searchCondition eq 'ALL'}">selected</c:if>>제목+내용</option>
						</select>
						<input type="text" id="searchKeyword" name="searchKeyword" value="${param.searchKeyword}" onkeydown="onEnter(doSearch);" class="form_text w100p ml-8" />
					</div>
				</td>
				<th scope="row">작성자</th>
				<td>
					<input type="text" id="searchCreNm" name="searchCreNm" value="${param.searchCreNm}" onkeydown="onEnter(doSearch);" class="form_text w100p" />
				</td>
			</tr>
		</tbody>
	</table>
</div>
<div class="cont_block mt-20">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
		<fieldset class="ml-auto">
			<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
			<select id="pageUnit" name="pageUnit" onchange="doSearch();" class="form_select" title="목록수">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</fieldset>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="boardListSheet" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		// IBSheet 호출
		// 리스트 Sheet 셋팅
		initBoardListSheet();
		
		// 목록 조회
		getList();
	});

	function initBoardListSheet() {
		// 세팅
		var	ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, Editable: false, statusColHidden: true});

    	ibHeader.addHeader({Header: 'No', Type: 'Text', SaveName: 'pageSeq', Align: 'Center', Width: 50});
    	ibHeader.addHeader({Header: '제목', Type: 'Text', SaveName: 'title', Align: 'Left', Width: 270, Cursor: 'Pointer'});
    	ibHeader.addHeader({Header: '댓글수', Type: 'Text', SaveName: 'replyCnt', Align: 'Center', Width: 55});
    	ibHeader.addHeader({Header: '조회수', Type: 'Text', SaveName: 'viewCnt', Align: 'Center', Width: 55});
    	ibHeader.addHeader({Header: '작성자', Type: 'Text', SaveName: 'creNm', Align: 'Center', Width: 85});
    	ibHeader.addHeader({Header: '작성일자', Type: 'Text', SaveName: 'creDate', Align: 'Center', Width: 85});
 		
    	ibHeader.addHeader({Header: '게시물아이디', Type: 'Text', SaveName: 'boardId', Align: 'Center', Width: 50, Hidden: true});
 		ibHeader.addHeader({Header: '파일아이디', Type: 'Text', SaveName: 'fileId', Align: 'Center', Width: 50, Hidden: true});
 		
        var sheetId = 'boardListSheet';
		var container = $('#' + sheetId)[0];
        createIBSheet2(container, sheetId, '100%', '100%');
        ibHeader.initSheet(sheetId);
        boardListSheet.SetSelectionMode(4);
        
     	// 편집모드 OFF
		boardListSheet.SetEditable(0);
	};
	
	function boardListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('boardListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 제목에 볼드 처리
			boardListSheet.SetColFontBold('title', 1);
    	}
    }
	
	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.searchForm.pageIndex.value = pageIndex;
		getList();
	}
	
	function getList() {
		global.ajax({
			url : '<c:url value="/tradePro/board/selectTradeProBoardList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : $('#searchForm').serialize()
			, async : true
			, spinner : true
			, success: function (data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				
				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				boardListSheet.LoadSearchData({Data: data.resultList});
			}
			, error:function(request,status,error){
				alert('게시판 조회에 실패했습니다.');
			}
		});
	}
	
	function boardListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('boardListSheet', row);
	}
	
	function goWrite() {
		$('#boardId').val('');
		
		<c:if test="${requestScope['javax.servlet.forward.servlet_path'] == '/tradePro/board/boardList.do'}">
			document.searchForm.action = '<c:url value="/tradePro/board/boardForm.do" />';
		</c:if>
		<c:if test="${requestScope['javax.servlet.forward.servlet_path'] == '/tradePro/board/memberBoardList.do'}">
			document.searchForm.action = '<c:url value="/tradePro/board/memberBoardForm.do" />';
		</c:if>
		
		document.searchForm.submit();
	}
	
	// 상세
 	function boardListSheet_OnClick(Row, Col, Value) {
 		if (Row > 0) {
			if (boardListSheet.ColSaveName(Col) == 'title') {
				var boardId = boardListSheet.GetCellValue(Row, 'boardId');
				var fileId = boardListSheet.GetCellValue(Row, 'fileId');
				
				goView(boardId, fileId);
			}	
		}
	}

	function goView(boardId, fileId) {
		$('#boardId').val(boardId);
		$('#fileId').val(fileId);
		
		<c:if test="${requestScope['javax.servlet.forward.servlet_path'] == '/tradePro/board/boardList.do'}">
			document.searchForm.action = '<c:url value="/tradePro/board/boardDetail.do" />';
		</c:if>
		<c:if test="${requestScope['javax.servlet.forward.servlet_path'] == '/tradePro/board/memberBoardList.do'}">
			document.searchForm.action = '<c:url value="/tradePro/board/memberBoardDetail.do" />';
		</c:if>
				
	    document.searchForm.submit();
	}
</script>