<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchPgmName" value="${param.searchPgmName}" />
<input type="hidden" name="searchDetailYn" value="${param.searchDetailYn}" />
<input type="hidden" name="searchUrl" value="${param.searchUrl}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
</form>
<form id="programForm" name="programForm" method="post" onsubmit="return false;">
<input type="hidden" id="pgmId" name="pgmId" value="<c:out value='${resultView.pgmId}' default='0' />" />
<input type="hidden" id="bbsId" name="bbsId" value="<c:out value='${resultView.bbsId}' default='0' />" />
<h2>Home &gt; 메뉴 관리 &gt; 프로그램 관리</h2>
<div class="widget btn right" style="margin-top: 0px;">
	<c:choose>
		<c:when test="${empty resultView.pgmId}">
			<a href="javascript:doInsert();" class="ui-button ui-widget ui-corner-all">저장</a>
		</c:when>
		<c:otherwise>
			<a href="javascript:doDelete();" class="ui-button ui-widget ui-corner-all">삭제</a>
			<a href="javascript:doUpdate();" class="ui-button ui-widget ui-corner-all">저장</a>
		</c:otherwise>
	</c:choose>
	<a href="javascript:goList();" class="ui-button ui-widget ui-corner-all">목록</a>
</div>
<div class="contents">
	<div><font color="red"><b>◎</b></font> 는 필수 입력입니다.</div>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="boardwrite">
		<caption>등록/수정화면</caption>
		<colgroup>
			<col width="12%" />
			<col width="88%" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> 프로그램명</th>
				<td>
					<input type="text" name="pgmName" value="${resultView.pgmName}" class="textType" style="width: 98%;" />
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;">URL</th>
				<td>
					<input type="text" name="url" value="${resultView.url}" class="textType" style="width: 98%;" />
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> 새창</th>
				<td>
					<select name="linkTarget" class="jquerySelectbox">
						<option value="" <c:if test="${empty resultView.linkTarget or resultView.linkTarget eq ''}">selected="selected"</c:if>>::: 선택 :::</option>
						<option value="_self" <c:if test="${resultView.linkTarget eq '_self'}">selected="selected"</c:if>>현재창</option>
						<option value="_blank" <c:if test="${resultView.linkTarget eq '_blank'}">selected="selected"</c:if>>새창</option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;"> 비고</th>
				<td colspan="3">
					<input type="text" name="dscr" value="${resultView.dscr}" class="textType" style="width: 98%;" />
				</td>
			</tr>
		</tbody>
	</table>
</div>
<div class="widget btn right" style="margin-top: 0px;margin-bottom: 20px;">
	<a href="javascript:doRowAdd();" class="ui-button ui-widget ui-corner-all">추가</a>
</div>
<div class="contents">
	<div id="subList"></div>
</div>
</form>
<script type="text/javascript">
	var	ibSubHeader = new IBHeader();
	ibSubHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden : true});
	ibSubHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 20, Align: 'Center'});
	ibSubHeader.addHeader({Header: '하위 프로그램명', Type: 'Text', SaveName: 'pgmName', Width: 80, Align: 'Center'});
	ibSubHeader.addHeader({Header: 'URL', Type: 'Text', SaveName: 'url', Width: 160, Align: 'Left'});
	
	ibSubHeader.addHeader({Header: '프로그램 아이디', Type: 'Text', SaveName: 'pgmId', Align: 'Center', Hidden : true});
	ibSubHeader.addHeader({Header: '순번', Type: 'Text', SaveName: 'seq', Align: 'Center', Hidden : true});
	
	ibSubHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 1, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: -1, MergeSheet: 5, ChildPage: 10, MaxSort: 1});
	ibSubHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	var lf;
	$(document).ready(function(){
		f = document.programForm;
		lf = document.listForm;
		<c:if test="${empty resultView.pgmId}">
			f.pgmName.focus();
		</c:if>
		
		var container = $('#subList')[0];
		createIBSheet2(container, 'subListSheet', '100%', '100%');
		ibSubHeader.initSheet('subListSheet');
		subListSheet.SetWaitImageVisible(0);
		
		// 하위 프로그램 목록 가져오기
		getSubProgramList();
	});
	
	// 하위 프로그램 목록 가져오기
	function getSubProgramList() {
		subListSheet.DoSearch('<c:url value="/menu/program/selectSubList.do" />', {
			pgmId : f.pgmId.value
		});
	}
	
	function isValid() {
		if (
			parseInt(f.pgmId.value) > 0
			&& parseInt(f.bbsId.value) > 0
		) {
			alert('자동 생성된 게시판은 수정할 수 없습니다.');
			
			return false;
		}
		
		if (isStringEmpty(f.pgmName.value)) {
			alert('프로그램명을 입력해 주세요.');
			f.pgmName.focus();
			
			return false;
		}
		
		var linkTarget = $('select[name="linkTarget"] option:selected');
		
		if (isStringEmpty(linkTarget.val())) {
			alert('새창을 선택해 주세요.');
			linkTarget.focus();
			
			return false;
		}
		
		var saveJson = subListSheet.GetSaveJson();
		
		// 대상목록의 정보
		if (saveJson.Message == 'KeyFieldError') {
			return false;
		}
		
		if (saveJson.Message == 'InvalidInputError') {
			return false;
		}
		
		var isNmValid = true;
		
		if (saveJson.data.length) {
			$.each(saveJson, function(key1, value1) {
				$.each(value1, function(key2, value2) {
					// 삭제는 삭제 대상이기 때문에 유효성을 체크하지 않는다.
					if (value2.status == 'I' || value2.status == 'U') {
						if (isStringEmpty(value2.pgmName)) {
							isNmValid = false;
						}
					}
				});
			});
		}
		
		if (!isNmValid) {
			alert('하위 프로그램명을 입력해 주세요.');
			
			return false;
		}
		
		return true;
	}
	
	function doInsert() {
		if (isValid()) {
			if (confirm('프로그램 정보를 등록하시겠습니까?')) {
				var pf = $('#programForm').serializeObject();
				
				var saveJson = subListSheet.GetSaveJson();
				
				if (saveJson.data.length) {
					var map = {};
					var list = [];
					$.each(saveJson, function(key1, value1) {
						map = {};
						$.each(value1, function(key2, value2) {
							map = value2;
							list.push(map);
						});
						
						pf['subList'] = list;
					});
				}
								
				global.ajax({
					type : 'POST'
					, url : '<c:url value="/menu/program/insert.do" />'
					, data : JSON.stringify(pf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						if (data.result) {
							alert('프로그램 정보를 등록하였습니다.');
							goList();	
						} else {
							alert(data.message);
						}
					}
				});
			}
		}
	}
	
	function doUpdate() {
		if (isValid()) {
			if (confirm('프로그램 정보를 수정하시겠습니까?')) {
				var pf = $('#programForm').serializeObject();
				
				var saveJson = subListSheet.GetSaveJson();
				
				if (saveJson.data.length) {
					var map = {};
					var list = [];
					$.each(saveJson, function(key1, value1) {
						map = {};
						$.each(value1, function(key2, value2) {
							map = value2;
							list.push(map);
						});
						
						pf['subList'] = list;
					});
				}
				
				global.ajax({
					type : 'POST'
					, url : '<c:url value="/menu/program/update.do" />'
					, data : JSON.stringify(pf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						if (data.result) {
							alert('프로그램 정보를 수정하였습니다.');
							goList();	
						} else {
							alert(data.message);
						}
					}
				});
			}
		}
	}
	
	function doDelete() {
		if (confirm('프로그램 정보를 삭제하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/menu/program/delete.do" />'
				, data : $('#programForm').serialize()
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					alert('프로그램 정보를 삭제하였습니다.');
					goList();
				}
			});
		}
	}
	
	function goList() {
		lf.action = '<c:url value="/menu/program/list.do" />';
		lf.target = '_self';
		lf.submit();
	}
	
	// 코드 목록에 행 추가
	function doRowAdd() {
		subListSheet.DataInsert(-1);
	}
</script>