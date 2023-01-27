<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="programForm" name="programForm" method="get" onsubmit="return false;">
<input type="hidden" id="programSeq" name="programSeq" value="0" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<h2>프로그램관리</h2>
<!--검색 시작 -->
<div class="search">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" summary="">
		<colgroup>
			<col width="10%" />
			<col width="90%" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">검색</th>
				<td colspan="3">
					<fieldset class="widget">
						<select id="searchCondition" name="searchCondition" class="jquerySelectbox" style="width: 30%;">
							<option value="" <c:if test="${empty param.searchCondition or param.searchCondition eq ''}">selected="selected"</c:if>>::: 전체 :::</option>
							<option value="programNm" <c:if test="${param.searchCondition eq 'programNm'}">selected="selected"</c:if>>프로그램명</option>
							<option value="url" <c:if test="${param.searchCondition eq 'url'}">selected="selected"</c:if>>URL</option>
						</select>
						<input type="text" id="searchKeyword" name="searchKeyword" value="${param.searchKeyword}" onkeydown="onEnter(doSearch);" class="textType" style="width: 200px;" title="검색어" />
						<a href="javascript:doSearch();" class="ui-button ui-widget ui-corner-all">검색</a>
					</fieldset>					
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<hr />
<div id="totalCnt" style="text-align: right;margin-bottom: 5px;font-size: 13px;font-weight: bold;"></div>
<div style="width: 100%;height: 100%;">
	<div id="programList" class="sheet"></div>
</div>
<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
<div class="widget btn right" style="margin-top: 0px;">
	<a href="javascript:goWrite();" class="ui-button ui-widget ui-corner-all">등록</a>
	<a href="javascript:doDelete();" class="ui-button ui-widget ui-corner-all">삭제</a>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 20, Align: 'Center'});
	ibHeader.addHeader({Header: '번호', Type: 'Text', SaveName: 'pageSeq', Width: 20, Align: 'Center'});
	ibHeader.addHeader({Header: '프로그램명', Type: 'Text', SaveName: 'programNm', Width: 90, Align: 'Center', FontColor: 'blue'});
	ibHeader.addHeader({Header: 'URL', Type: 'Text', SaveName: 'url', Width: 130, Align: 'Left'});
	ibHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'etc', Width: 180, Align: 'Left'});
	
	ibHeader.addHeader({Header: '프로그램 시퀀스', Type: 'Text', SaveName: 'programSeq', Hidden: true});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	$(document).ready(function(){
		f = document.programForm;
		
		var container = $('#programList')[0];
		createIBSheet2(container, 'programListSheet', '100%', '100%');
		ibHeader.initSheet('programListSheet');
		
		getList();
	});
	
	function programListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('programListSheet_OnSearchEnd : ', msg);
    	} else {
    		programListSheet.SetEllipsis(1);
    		programListSheet.SetDataBackColor('#ffffff');
    		programListSheet.SetMouseHoverMode(0);
    		programListSheet.SetMousePointer('hand');
    	}
    }
	
	function programListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (programListSheet.ColSaveName(col) == 'programNm') {
				var programSeq = programListSheet.GetCellValue(row, 'programSeq');
				
				goView(programSeq);
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
			, url : '<c:url value="/program/selectList.do" />'
			, data : $('#programForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span style="color: orange;">' + global.formatCurrency(data.resultCnt) + '</span> 건');

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
	
	// 등록화면
	function goWrite() {
		f.action = '<c:url value="/program/write.do" />';
		f.programSeq.value = '0';
		f.target = '_self';
		f.submit();
	}
	
	// 조회화면
	function goView(programSeq) {
		f.action = '<c:url value="/program/write.do" />';
		f.programSeq.value = programSeq;
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
			if (confirm('프로그램 정보를 삭제하시겠습니까?')) {
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
					, url : '<c:url value="/program/deleteList.do" />'
					, data : JSON.stringify(pf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						alert('프로그램 정보를 삭제하였습니다.');
						location.href = '<c:url value="/program/list.do" />';
					}
				});
			}
		} else {
			alert('삭제할 프로그램 정보를 선택해 주세요.');
		}
	}
</script>