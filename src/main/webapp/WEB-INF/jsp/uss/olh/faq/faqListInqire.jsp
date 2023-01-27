<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="faqForm" name="faqForm" method="get" onsubmit="return false;">
<input type="hidden" id="faqId" name="faqId" value="0" />
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
					<fieldset class="widget form_group">
						<div class="group_item">
							<select name="searchCondition" class="select_n form_select">
								<option selected value=''>--선택하세요--</option>
							<c:forEach items="${faqCdList }" var="code">
								<option value="<c:out value="${code.code }"/>"  <c:if test="${searchVO.searchCondition eq code.code}">selected="selected"</c:if> ><c:out value="${code.codeNm }"/></option>
							</c:forEach>
								<%--<option value="" <c:if test="${empty param.searchCondition or param.searchCondition eq ''}">selected="selected"</c:if>>::: 전체 :::</option>
								<option value="FAQ01" <c:if test="${param.searchCondition eq 'FAQ01'}">selected="selected"</c:if>>FTA 상담</option>
								<option value="FAQ02" <c:if test="${param.searchCondition eq 'FAQ02'}">selected="selected"</c:if>>공동인증서</option>--%>
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
		<div id="faqList" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
</div>


</form>
<script type="text/javascript">
	var f;
	$(document).ready(function(){
		f = document.faqForm;

		var container = $('#faqList')[0];
		createIBSheet2(container, 'faqListSheet', '100%', '100%');
		ibHeader.initSheet('faqListSheet');

		// 편집모드 OFF
		faqListSheet.SetEditable(0);

		getList();
	});

	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '분류', Type: 'Text', SaveName: 'qestnCdNm', Width: 30, Align: 'Center' });
	ibHeader.addHeader({Header: '세부 분류', Type: 'Text', SaveName: 'qestnSubCdNm', Width: 30, Align: 'Center' });
	ibHeader.addHeader({Header: '질문 제목', Type: 'Text', SaveName: 'qestnSj', Width: 100, Align: 'Left', Cursor:"Pointer"});
	ibHeader.addHeader({Header: '등록일자', Type: 'Text', SaveName: 'lastUpdusrPnttm', Width: 30, Align: 'Center' });
	ibHeader.addHeader({Header: 'faq아이디', Type: 'Text', SaveName: 'faqId', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	function faqListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (faqListSheet.ColSaveName(col) == 'qestnSj') {
				var faqId = faqListSheet.GetCellValue(row, 'faqId');

				goView(faqId);
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
			, url : '<c:url value="/uss/olh/faq/selectList.do" />'
			, data : $('#faqForm').serialize()
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

				faqListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function faqListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('faqListSheet_OnSearchEnd : ', msg);
		} else {
			// 제목에 볼드 처리
			faqListSheet.SetColFontBold('qestnSj', 1);
		}
	}

	// 등록화면
	function goWrite() {
		f.action = '<c:url value="/uss/olh/faq/faqCnRegistView.do" />';
		f.target = '_self';
		f.submit();
	}

	// 조회화면
	function goView(faqId) {
		f.action = '<c:url value="/uss/olh/faq/faqInqireCoUpdt.do" />';
		f.faqId.value = faqId;
		f.target = '_self';
		f.submit();
	}

	function faqListSheet_OnRowSearchEnd(row) {
	   // 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
	   notEditableCellColor('faqListSheet', row);
	}

	function doInit() {
		location.href = '<c:url value="/uss/olh/faq/list.do" />';
	}



</script>