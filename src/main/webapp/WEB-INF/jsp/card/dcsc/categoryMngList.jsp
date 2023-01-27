<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<div class="location">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="goCategoryReg();">추가</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="getDcscCategoryList();">검색</button>
	</div>
</div>
<div class="cont_block">
	<form id="searchForm" method="post">
		<div class="search">
			<input type="text" style="display: none;" />
			<table class="formTable">
				<colgroup>
					<col style="width: 17%;" />
				</colgroup>
				<tbody>
					<tr>
						<th>카테고리명</th>
						<td>
							<input type="text" id="searchCategoryName" name="searchCategoryName" value="<c:out value="${params.searchCategoryName}" />" class="form_text" onkeydown="onEnter(getDcscCategoryList);" maxlength="30" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
</div>
<div class="cont_block">
	<div class="tbl_opt">
		<span id="totalCnt" class="total_count"></span>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="categorySheet" class="sheet"></div>
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		setSheetHeader_dcscCategorySheet();
		getDcscCategoryList();
	});

	function setSheetHeader_dcscCategorySheet() {
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '카테고리 ID'		, Type: 'Text'			, SaveName: 'categoryId'		, Edit: false	, Width: 40		, Align: 'Left', Hidden: true});
		ibHeader.addHeader({Header: '카테고리'			, Type: 'Text'			, SaveName: 'categoryName'		, Edit: false	, Width: 40		, Align: 'Left', Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '제휴 업체 수'		, Type: 'Int'			, SaveName: 'afCompanyCnt'		, Edit: false	, Width: 40		, Align: 'Center'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '등록일시'			, Type: 'Text'			, SaveName: 'creDate'			, Edit: false	, Width: 40		, Align: 'Center'});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 1,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 2,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#categorySheet')[0];
		createIBSheet2(container, 'categorySheet', '100%', '10px');
		ibHeader.initSheet('categorySheet');

		categorySheet.SetEllipsis(1); 				// 말줄임 표시여부
		categorySheet.SetSelectionMode(4);			// 셀 선택 모드 설정
	}

	function categorySheet_OnSearchEnd() {
		categorySheet.SetColFontBold('categoryName', 1);
	}

	// 카테고리 목록 조회
	function getDcscCategoryList() {
		var searchCategoryName = $('#searchCategoryName').val();
		if (searchCategoryName.length > 30) {
			alert('카테고리명은 30자이하로 입력해 주세요.');
			return false;
		}

		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : '/card/dcsc/selectDcscCategoryList.do'
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.totalCnt) + '</span> 건'	);
				categorySheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function goCategoryReg() {
		location.href = '/card/dcsc/categoryMngReg.do';
	}

	function categorySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (rowType == 'HeaderRow') {
			return;
		}

		if (categorySheet.ColSaveName(Col) == 'categoryName') {
			var categoryId = categorySheet.GetCellValue(Row, 'categoryId');
			var categoryName = categorySheet.GetCellValue(Row, 'categoryName');

			var url = '/card/dcsc/categoryMngReg.do?categoryId=' + categoryId;
			window.open(url, '_self');
		}
	}
</script>