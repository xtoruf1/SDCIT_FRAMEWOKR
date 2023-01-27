<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="programForm" name="programForm" method="get" onsubmit="return false;">
<input type="hidden" id="pgmId" name="pgmId" value="0" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<h2>Home &gt; 메뉴 관리 &gt; 프로그램 관리</h2>
<div class="widget btn right" style="margin-top: 0px;">
	<a href="javascript:goWrite();" class="ui-button ui-widget ui-corner-all">등록</a>
	<a href="javascript:doDelete();" class="ui-button ui-widget ui-corner-all">삭제</a>
	<a href="javascript:doSearch();" class="ui-button ui-widget ui-corner-all">조회</a>
</div>
<!--검색 시작 -->
<div class="search">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" summary="">
		<colgroup>
			<col width="10%" />
			<col width="40%" />
			<col width="10%" />
			<col width="40%" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">프로그램명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchPgmName" name="searchPgmName" value="${param.searchPgmName}" onkeydown="onEnter(doSearch);" class="textType" style="width: 70%;" title="프로그램명" />
						&nbsp;&nbsp;&nbsp;
						<input type="checkbox" id="searchSubYn" title="하위포함" <c:if test="${param.searchDetailYn eq 'Y'}">checked="checked"</c:if> /> 하위포함
						<input type="hidden" name="searchDetailYn" value="N" />
					</fieldset>					
				</td>
				<th scope="row">URL</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchUrl" name="searchUrl" value="${param.searchUrl}" onkeydown="onEnter(doSearch);" class="textType" style="width: 70%;" title="URL" />
					</fieldset>					
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<hr />
<div id="totalCnt" style="text-align: left;margin-bottom: 5px;font-size: 13px;font-weight: bold;"></div>
<div style="text-align: right;margin-bottom: 5px;">
	<fieldset>
		<select id="pageUnit" name="pageUnit" title="목록수" class="jquerySelectbox">
			<option value="10" <c:if test="${empty param.pageUnit or param.pageUnit eq '10'}">selected="selected"</c:if>>10개씩</option>
			<option value="50" <c:if test="${param.pageUnit eq '50'}">selected="selected"</c:if>>50개씩</option>
			<option value="100" <c:if test="${param.pageUnit eq '100'}">selected="selected"</c:if>>100개씩</option>
		</select>
	</fieldset>
</div>
<div style="width: 100%;height: 100%;">
	<div id="programList" class="sheet"></div>
</div>
<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 20, Align: 'Center'});
	ibHeader.addHeader({Header: '프로그램명', Type: 'Text', SaveName: 'pgmName', Width: 90, Align: 'Left', FontColor: 'blue'});
	ibHeader.addHeader({Header: 'URL', Type: 'Text', SaveName: 'url', Width: 120, Align: 'Left'});
	ibHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'dscr', Width: 175, Align: 'Left'});
	ibHeader.addHeader({Header: '등록일시', Type: 'Text', SaveName: 'creDate', Width: 55, Align: 'Center'});
	
	ibHeader.addHeader({Header: '프로그램 시퀀스', Type: 'Text', SaveName: 'pgmId', Hidden: true});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	$(document).ready(function(){
		f = document.programForm;
		
		$('#pageUnit').selectmenu({
			change : function(event, ui){
				doSearch();
			}
		});
		
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
			if (programListSheet.ColSaveName(col) == 'pgmName') {
				var pgmId = programListSheet.GetCellValue(row, 'pgmId');
				
				goView(pgmId);
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
		if ($('#searchSubYn').is(':checked')) {
			f.searchDetailYn.value = 'Y';
		} else {
			f.searchDetailYn.value = 'N';
		}
		
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/menu/program/selectList.do" />'
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
		f.action = '<c:url value="/menu/program/write.do" />';
		f.pgmId.value = '0';
		f.target = '_self';
		f.submit();
	}
	
	// 조회화면
	function goView(pgmId) {
		f.action = '<c:url value="/menu/program/write.do" />';
		f.pgmId.value = pgmId;
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
					, url : '<c:url value="/menu/program/deleteList.do" />'
					, data : JSON.stringify(pf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						alert('프로그램 정보를 삭제하였습니다.');
						location.href = '<c:url value="/menu/program/list.do" />';
					}
				});
			}
		} else {
			alert('삭제할 프로그램 정보를 선택해 주세요.');
		}
	}
</script>