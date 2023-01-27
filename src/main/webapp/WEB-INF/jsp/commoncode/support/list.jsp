<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="commonCodeForm" name="commonCodeForm" method="get" onsubmit="return false;">
<input type="hidden" id="cls" name="cls" value="" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="goWrite();" class="btn_sm btn_primary btn_modify_auth">등록</button>
		<button type="button" onclick="doDelete();" class="btn_sm btn_secondary btn_modify_auth">삭제</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">조회</button>
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
								<option value="cls" <c:if test="${param.searchCondition eq 'cls'}">selected="selected"</c:if>>코드</option>
								<option value="name" <c:if test="${param.searchCondition eq 'name'}">selected="selected"</c:if>>코드명</option>
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
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 20, Align: 'Center', HeaderCheck: 0});
	ibHeader.addHeader({Header: '공통코드', Type: 'Text', SaveName: 'cls', Width: 50, Align: 'Center', Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '공통코드명', Type: 'Text', SaveName: 'name', Width: 60, Align: 'Center'});
	ibHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'note', Width: 120, Align: 'Left'});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
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
		// 편집모드 OFF
		codeListSheet.SetEditable(0);
		
		getList();
	});

	function codeListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('codeListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 공통코드에 볼드 처리
			codeListSheet.SetColFontBold('cls', 1);
    	}
    }

	function codeListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (codeListSheet.ColSaveName(col) == 'cls') {
				var cls = codeListSheet.GetCellValue(row, 'cls');

				goView(cls);
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
			, url : '<c:url value="/commonCode/support/selectList.do" />'
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

	// 등록화면
	function goWrite() {
		f.action = '<c:url value="/commonCode/support/regist.do" />';
		f.cls.value = '';
		f.target = '_self';
		f.submit();
	}
	
	// 조회화면
	function goView(cls) {
		f.action = '<c:url value="/commonCode/support/modify.do" />';
		f.cls.value = cls;
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
			if (confirm('선택한 공통코드 정보를 삭제하시겠습니까?')) {
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
					, url : '<c:url value="/commonCode/support/deleteList.do" />'
					, data : JSON.stringify(ccf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						if (data.result) {
							alert('공통코드 정보를 삭제하였습니다.');
							location.href = '<c:url value="/commonCode/support/list.do" />';	
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
</script>