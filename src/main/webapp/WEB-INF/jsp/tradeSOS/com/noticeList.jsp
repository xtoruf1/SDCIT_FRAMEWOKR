<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="searchForm" name="searchForm" method="get" onsubmit="return false;">
<input type="hidden" id="noticeId" name="noticeId" value="" />
<input type="hidden" id="fileId" name="fileId" value="" />
<input type="hidden" id="authType" name="authType" value="${noticeAuthType}" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<c:if test="${empty noticeAuthType}">
			<button type="button" onclick="goWrite();" class="btn_sm btn_primary btn_modify_auth">신규</button>
		</c:if>
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
				<th scope="row">구분</th>
				<td>
					<select id="searchNoticeTypeCd" name="searchNoticeTypeCd" class="form_select w100p">
						<option value="">전체</option>
						<c:forEach var="list" items="${codeList}" varStatus="varStatus">
							<option value="${list.cdId}" <c:if test="${param.searchNoticeTypeCd eq list.cdId}">selected</c:if>>${list.cdNm}</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">키워드</th>
				<td>
					<div class="flex align_center">
						<select id="searchCondition" name="searchCondition" class="form_select">
							<option value="TITLE" <c:if test="${param.searchCondition eq 'TITLE'}">selected</c:if>>제목</option>
							<option value="CONTENT" <c:if test="${param.searchCondition eq 'CONTENT'}">selected</c:if>>내용</option>
							<option value="ALL" <c:if test="${param.searchCondition eq 'ALL'}">selected</c:if>>제목+내용</option>
						</select>
						<input type="text" id="searchKeyword" name="searchKeyword" value="${param.searchKeyword}" onkeydown="onEnter(doSearch);" class="form_text form_text w100p ml-8" />
					</div>
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
		<div id="noticeListSheet" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		// IBSheet 호출
		// 리스트 Sheet 셋팅
		initNoticeListSheet();

		// 목록 조회
		getList();
	});

	function initNoticeListSheet() {
		// 세팅
		var	ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

    	ibHeader.addHeader({Header: 'No', Type: 'Text', SaveName: 'pageSeq'	, Align: 'Center', Width: 40});
    	ibHeader.addHeader({Header: '구분', Type: 'Text', SaveName: 'noticeTypeNm', Align: 'Center', Width: 70});
    	ibHeader.addHeader({Header: '제목', Type: 'Text', SaveName: 'title', Align: 'Left', Width: 300, Cursor: 'Pointer'});
    	ibHeader.addHeader({Header: '작성일자', Type: 'Text', SaveName: 'creDate', Align: 'Center', Width: 70});
 		ibHeader.addHeader({Header: '조회수', Type: 'Text', SaveName: 'viewCnt', Align: 'Center', Width: 50});

 		ibHeader.addHeader({Header: '게시물아이디', Type: 'Text', SaveName: 'noticeId', Align: 'Center', Width: 50, Hidden: true});
 		ibHeader.addHeader({Header: '파일아이디', Type: 'Text', SaveName: 'fileId', Align: 'Center', Width: 50, Hidden: true});

        var sheetId = 'noticeListSheet';
		var container = $('#' + sheetId)[0];
        createIBSheet2(container, sheetId, '100%', '100%');
        ibHeader.initSheet(sheetId);
        noticeListSheet.SetSelectionMode(4);
        
     	// 편집모드 OFF
		noticeListSheet.SetEditable(0);
	};

	function noticeListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('noticeListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 제목에 볼드 처리
			noticeListSheet.SetColFontBold('title', 1);
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
			url : '<c:url value="/tradeSOS/notice/getTradeSOSNotice.do" />'
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

				noticeListSheet.LoadSearchData({Data: data.resultList});
			}
			, error:function(request,status,error){
				alert('공지사항 조회에 실패했습니다.');
			}
		});
	}

	function noticeListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('noticeListSheet', row);
	}

	function goWrite() {
		document.searchForm.action = '<c:url value="/tradeSOS/notice/noticeForm.do" />';
		document.searchForm.noticeId.value = 0;
		document.searchForm.submit();
	}

	// 상세
 	function noticeListSheet_OnClick(Row, Col) {
		if (Row > 0) {
			if (noticeListSheet.ColSaveName(Col) == 'title') {
				var noticeId = noticeListSheet.GetCellValue(Row, 'noticeId');
				var fileId = noticeListSheet.GetCellValue(Row, 'fileId');

				goView(noticeId, fileId);
			}
		}
	};

	function goView(noticeId, fileId) {
		$('#noticeId').val(noticeId);
		$('#fileId').val(fileId);

		<c:if test="${noticeAuthType eq 'pro'}">
			document.searchForm.action = '<c:url value="/tradeSOS/notice/proNoticeDetail.do" />';
		</c:if>
		<c:if test="${noticeAuthType eq 'trade'}">
			document.searchForm.action = '<c:url value="/tradeSOS/notice/tradeNoticeDetail.do" />';
		</c:if>
		<c:if test="${noticeAuthType eq 'consult'}">
			document.searchForm.action = '<c:url value="/tradeSOS/notice/consultNoticeDetail.do" />';
		</c:if>
		<c:if test="${noticeAuthType eq 'trans'}">
			document.searchForm.action = '<c:url value="/tradeSOS/notice/transNoticeDetail.do" />';
		</c:if>
		<c:if test="${empty noticeAuthType}">
			document.searchForm.action = '<c:url value="/tradeSOS/notice/noticeForm.do" />';
		</c:if>

		document.searchForm.submit();
	}
</script>