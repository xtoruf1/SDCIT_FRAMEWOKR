<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="commonCodeForm" name="commonCodeForm" method="get" onsubmit="return false;">
<input type="hidden" id="cdGrpId" name="cdGrpId" value="" />
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
								<option value="cdGrpId" <c:if test="${param.searchCondition eq 'cdGrpId'}">selected="selected"</c:if>>코드</option>
								<option value="cdGrpNm" <c:if test="${param.searchCondition eq 'cdGrpNm'}">selected="selected"</c:if>>코드명</option>
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
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="codeList" class="sheet"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 20, Align: 'Center', Edit: 1, HeaderCheck: 0});
	ibHeader.addHeader({Header: '공통코드', Type: 'Text', SaveName: 'cdGrpId', Width: 30, Align: 'Center', Edit: 0, Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '공통코드명', Type: 'Text', SaveName: 'cdGrpNm', Width: 80, Align: 'Left', Edit: 0});
	ibHeader.addHeader({Header: '사용여부', Type: 'Text', SaveName: 'useYn', Width: 30, Align: 'Center', Edit: 0});
	ibHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'explain', Width: 120, Align: 'Left', Edit: 0});
	ibHeader.addHeader({Header: '등록일자', Type: 'Text', SaveName: 'regstDt', Width: 50, Align: 'Center', Edit: 0});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: -1, MergeSheet: 5, MaxSort: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	$(document).ready(function(){
		f = document.commonCodeForm;

		var container = $('#codeList')[0];
		if (typeof codeListSheet !== 'undefined' && typeof codeListSheet.Index !== 'undefined') {
			codeListSheet.DisposeSheet();
		}
		createIBSheet2(container, 'codeListSheet', '100%', '600px');
		ibHeader.initSheet('codeListSheet');
		codeListSheet.SetSelectionMode(4);

		getList();
	});

	function codeListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('codeListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 공통코드에 볼드 처리
			codeListSheet.SetColFontBold('cdGrpId', 1);
    	}
    }

	function codeListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (codeListSheet.ColSaveName(col) == 'cdGrpId') {
				var cdGrpId = codeListSheet.GetCellValue(row, 'cdGrpId');

				goView(cdGrpId);
		    }
		}
	}

	function doSearch() {
		goPage();
	}

	function goPage() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/commonCode/counsel/selectList.do" />'
			, data : $('#commonCodeForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

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
		f.action = '<c:url value="/commonCode/counsel/regist.do" />';
		f.cdGrpId.value = '';
		f.target = '_self';
		f.submit();
	}

	// 조회화면
	function goView(cdGrpId) {
		f.action = '<c:url value="/commonCode/counsel/modify.do" />';
		f.cdGrpId.value = cdGrpId;
		f.target = '_self';
		f.submit();
	}

	// 삭제
	function doDelete() {
		var saveJson = codeListSheet.GetSaveJson();

		// 대상목록의 정보
		if (saveJson.Message == 'KeyFieldError') {
			return false;
		}

		if (saveJson.Message == 'InvalidInputError') {
			return false;
		}

		if (saveJson.data.length) {
			if (confirm('삭제 하시겠습니까?')) {
				var ccf = $('#commonCodeForm').serializeObject();

				var map = {};
				var list = [];
				$.each(saveJson, function(key1, value1) {
					map = {};
					$.each(value1, function(key2, value2) {
						map = value2;
						list.push(map);
					});

					ccf['deleteCodeList'] = list;
				});

				global.ajax({
					type : 'POST'
					, url : '<c:url value="/commonCode/counsel/deleteList.do" />'
					, data : JSON.stringify(ccf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						if (data.result) {
							location.href = '<c:url value="/commonCode/counsel/list.do" />';
						} else {
							alert(data.message);
						}
					}
				});
			}
		} else {
			alert('삭제할 공통코드 정보를 선택해 주세요.');
		}
	}

	function goPortalPage() {
		location.href = '<c:url value="/commonCode/portal/list.do" />';
	}

	function goServicePage() {
		location.href = '<c:url value="/commonCode/service/list.do" />';
	}

	function goSupportPage() {
		location.href = '<c:url value="/commonCode/support/list.do" />';
	}

	function goCounselPage() {
		location.href = '<c:url value="/commonCode/counsel/list.do" />';
	}

	function doInit() {
		location.href = '<c:url value="/commonCode/counsel/list.do" />';
	}
</script>