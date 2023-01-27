<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchCondition" value="${param.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${param.searchKeyword}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
</form>
<form id="programForm" name="programForm" method="post" onsubmit="return false;">
<input type="hidden" id="programSeq" name="programSeq" value="<c:out value='${resultView.programSeq}' default='0' />" />
<h2>프로그램관리</h2>
<div class="contents">
	<div><font color="red"><b>◎</b></font> 는 필수 입력입니다.</div>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="boardwrite">
		<caption>등록/수정화면</caption>
		<colgroup>
			<col width="12%" />
			<col width="38%" />
			<col width="12%" />
			<col width="38%" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> 프로그램명</th>
				<td colspan="3">
					<input type="text" name="programNm" value="${resultView.programNm}" class="textType" style="width: 300px;" />
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;">URL</th>
				<td colspan="3">
					<input type="text" name="url" value="${resultView.url}" class="textType" style="width: 600px;" />
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> SSL적용</th>
				<td>
					<select name="sslYn" class="jquerySelectbox">
						<option value="" <c:if test="${empty resultView.sslYn or resultView.sslYn eq ''}">selected="selected"</c:if>>::: 선택 :::</option>
						<option value="Y" <c:if test="${resultView.sslYn eq 'Y'}">selected="selected"</c:if>>적용</option>
						<option value="N" <c:if test="${resultView.sslYn eq 'N'}">selected="selected"</c:if>>적용 안함</option>
					</select>
				</td>
				<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> 새창여부</th>
				<td>
					<select name="target" class="jquerySelectbox">
						<option value="" <c:if test="${empty resultView.target or resultView.target eq ''}">selected="selected"</c:if>>::: 선택 :::</option>
						<option value="_self" <c:if test="${resultView.target eq '_self'}">selected="selected"</c:if>>현재창</option>
						<option value="_blank" <c:if test="${resultView.target eq '_blank'}">selected="selected"</c:if>>새창</option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> 모바일 메뉴표시</th>
				<td colspan="3">
					<select name="mobileYn" class="jquerySelectbox">
						<option value="" <c:if test="${empty resultView.mobileYn or resultView.mobileYn eq ''}">selected="selected"</c:if>>::: 선택 :::</option>
						<option value="Y" <c:if test="${resultView.mobileYn eq 'Y'}">selected="selected"</c:if>>허용</option>
						<option value="N" <c:if test="${resultView.mobileYn eq 'N'}">selected="selected"</c:if>>허용 안함</option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;"> 비고</th>
				<td colspan="3">
					<input type="text" name="etc" value="${resultView.etc}" class="textType" style="width: 600px;" />
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;"> 하위 프로그램</th>
				<td colspan="3">
					<div id="subList"></div>
				</td>
			</tr>
		</tbody>
	</table>
	<div class="widget btn">
		<a href="javascript:doRowAdd();" class="ui-button ui-widget ui-corner-all">하위추가</a>
		<c:choose>
			<c:when test="${empty resultView.programSeq}">
				<a href="javascript:doInsert();" class="ui-button ui-widget ui-corner-all">저장</a>
				<a href="javascript:goList();" class="ui-button ui-widget ui-corner-all">취소</a>
			</c:when>
			<c:otherwise>
				<a href="javascript:doUpdate();" class="ui-button ui-widget ui-corner-all">저장</a>
				<a href="javascript:goList();" class="ui-button ui-widget ui-corner-all">목록</a>
			</c:otherwise>
		</c:choose>
	</div>
</div>
</form>
<script type="text/javascript">
	var	ibSubHeader = new IBHeader();
	ibSubHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden : true});
	ibSubHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 20, Align: 'Center'});
	ibSubHeader.addHeader({Header: '프로그램명', Type: 'Text', SaveName: 'programNm', Width: 80, Align: 'Center'});
	ibSubHeader.addHeader({Header: 'URL', Type: 'Text', SaveName: 'url', Width: 120, Align: 'Left'});
	ibSubHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'etc', Width: 120, Align: 'Left'});
	
	ibSubHeader.addHeader({Header: '하위 프로그램 시퀀스', Type: 'Text', SaveName: 'subProgramSeq', Align: 'Center', Hidden : true});
	
	ibSubHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 1, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: -1, MergeSheet: 5, ChildPage: 10, MaxSort: 1});
	ibSubHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	var lf;
	$(document).ready(function(){
		f = document.programForm;
		lf = document.listForm;
		<c:if test="${empty resultView.programSeq}">
			f.programNm.focus();
		</c:if>
		
		var container = $('#subList')[0];
		createIBSheet2(container, 'subListSheet', '98%', '100%');
		ibSubHeader.initSheet('subListSheet');
		subListSheet.SetWaitImageVisible(0);
		
		// 하위 프로그램 목록 가져오기
		getSubProgramList();
	});
	
	// 하위 프로그램 목록 가져오기
	function getSubProgramList() {
		subListSheet.DoSearch('<c:url value="/program/selectSubList.do" />', {
			programSeq: f.programSeq.value
		});
	}
	
	function isValid() {
		if (isStringEmpty(f.programNm.value)) {
			alert('프로그램명을 입력해 주세요.');
			f.programNm.focus();
			
			return false;
		}
		
		var sslYn = $('select[name="sslYn"] option:selected');
		
		if (isStringEmpty(sslYn.val())) {
			alert('SSL적용을 선택해 주세요.');
			sslYn.focus();
			
			return false;
		}
		
		var target = $('select[name="target"] option:selected');
		
		if (isStringEmpty(target.val())) {
			alert('새창여부를 선택해 주세요.');
			target.focus();
			
			return false;
		}
		
		var mobileYn = $('select[name="mobileYn"] option:selected');
		
		if (isStringEmpty(mobileYn.val())) {
			alert('모바일 메뉴표시를 선택해 주세요.');
			mobileYn.focus();
			
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
						if (isStringEmpty(value2.programNm)) {
							isNmValid = false;
						}
					}
				});
			});
		}
		
		if (!isNmValid) {
			alert('프로그램명을 입력해 주세요.');
			
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
					, url : '<c:url value="/program/insert.do" />'
					, data : JSON.stringify(pf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						alert('프로그램 정보를 등록하였습니다.');
						goList();
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
					, url : '<c:url value="/program/update.do" />'
					, data : JSON.stringify(pf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						alert('프로그램 정보를 수정하였습니다.');
						goList();
					}
				});
			}
		}
	}
	
	function goList() {
		lf.action = '<c:url value="/program/list.do" />';
		lf.target = '_self';
		lf.submit();
	}
	
	// 코드 목록에 행 추가
	function doRowAdd() {
		subListSheet.DataInsert(-1);
	}
</script>