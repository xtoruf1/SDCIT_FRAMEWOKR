<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="systemForm" name="systemForm" method="post" onsubmit="return false;">
<input type="hidden" id="systemMenuId" name="systemMenuId" value="0" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<h2>시스템 관리</h2>
<div class="location compact">
	<div class="ml-auto">
		<button type="button" onclick="goWrite();" class="btn_sm btn_primary">신규</button>
		<button type="button" onclick="doDelete();" class="btn_sm btn_secondary">삭제</button>
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
					<input type="text" id="searchNote" name="searchNote" value="${param.searchNote}" onkeydown="onEnter(doSearch);" class="form_text w100p" title="비고" />
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->

<div class="cont_block mt-20">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
<!-- 	<fieldset class="ml-auto"> -->
<!-- 		<select id="pageUnit" name="pageUnit" title="목록수" class="jquerySelectbox"> -->
<%-- 			<option value="10" <c:if test="${empty param.pageUnit or param.pageUnit eq '10'}">selected="selected"</c:if>>10개씩</option> --%>
<%-- 			<option value="50" <c:if test="${param.pageUnit eq '50'}">selected="selected"</c:if>>50개씩</option> --%>
<%-- 			<option value="100" <c:if test="${param.pageUnit eq '100'}">selected="selected"</c:if>>100개씩</option> --%>
<!-- 		</select> -->
<!-- 	</fieldset> -->
	</div>

	<div style="width: 100%;height: 100%;">
		<div id="systemGrid" ></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>

</form>
<script type="text/javascript">

	var f;
	var grid;
	$(document).ready(function(){
		f = document.systemForm;

		init_systemGrid();

		getList();
	});

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		getList();
	}

	function init_systemGrid() {

		grid = new tui.Grid({
			el: document.getElementById('systemGrid'),
			scrollX: false,
			scrollY: false,
			rowHeaders: ['rowNum', 'checkbox'],
			columns: [
			  { type: 'number', header: '시스템명', name: 'menuNm', width: 300, align: 'left', sorting: true, readOnly: true},
			  { type: 'text', header: '비고', name: 'rmk', align: 'left', sorting: true, readOnly: true,
				onBeforeChange(ev) {
					console.log('Before change:' + ev);
				},
				onAfterChange(ev) {
					console.log('After change:' + ev);
				},
			  },
			  { type: 'text', header: '등록일시', name: 'writngDt', width: 100, align: 'center', sorting: true, readOnly: true}
			]
		  });
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/menu/system/selectSystemList.do" />'
			, data : $('#systemForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

				grid.resetData(data.resultList);

				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

			}
		});
	}

	// 등록화면
	function goWrite() {
		f.action = '<c:url value="/menu/system/systemRegist.do" />';
		f.systemMenuId.value = '0';
		f.target = '_self';
		f.submit();
	}

	// 조회화면
	function goView(systemMenuId) {
		f.action = '<c:url value="/menu/system/write.do" />';
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
			if (confirm('시스템 메뉴 정보를 삭제하시겠습니까?')) {
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
					, url : '<c:url value="/menu/system/deleteList.do" />'
					, data : JSON.stringify(sf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						alert('시스템 메뉴 정보를 삭제하였습니다.');
						location.href = '<c:url value="/menu/system/list.do" />';
					}
				});
			}
		} else {
			alert('삭제할 시스템 메뉴 정보를 선택해 주세요.');
		}
	}
</script>