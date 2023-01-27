<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchSystemMenuName" value="${param.searchSystemMenuName}" />
<input type="hidden" name="searchNote" value="${param.searchNote}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10'/>" />
</form>
<form id="systemForm" name="systemForm" method="post" onsubmit="return false;">
<input type="hidden" id="systemMenuId" name="systemMenuId" value="<c:out value='${resultView.systemMenuId}' default='0' />" />
<h2>Home &gt; 메뉴 관리 &gt; 시스템 관리</h2>
<div class="widget btn right" style="margin-top: 0px;">
	<c:choose>
		<c:when test="${empty resultView.systemMenuId}">
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
				<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> 시스템명</th>
				<td>
					<input type="text" name="systemMenuName" value="${resultView.systemMenuName}" class="textType" style="width: 98%;" />
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;">비고</th>
				<td>
					<input type="text" name="note" value="${resultView.note}" class="textType" style="width: 98%;" />
				</td>
			</tr>
		</tbody>
	</table>
</div>
</form>
<script type="text/javascript">
	var f;
	var lf;
	$(document).ready(function(){
		f = document.systemForm;
		lf = document.listForm;
		<c:if test="${empty resultView.systemMenuId}">
			f.systemMenuId.focus();
		</c:if>
	});
	
	function isValid() {
		if (isStringEmpty(f.systemMenuName.value)) {
			alert('시스템명을 입력해 주세요.');
			f.systemMenuName.focus();
			
			return false;
		}
		
		return true;
	}
	
	function doInsert() {
		if (isValid()) {
			if (confirm('시스템 메뉴 정보를 등록하시겠습니까?')) {
				global.ajax({
					type : 'POST'
					, url : '<c:url value="/menu/system/insert.do" />'
					, data : $('#systemForm').serialize()
					, dataType : 'json'
					, async : true
					, spinner : true
					, success : function(data){
						if (data.result) {
							alert('시스템 메뉴 정보를 등록하였습니다.');
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
			if (confirm('시스템 메뉴 정보를 수정하시겠습니까?')) {
				global.ajax({
					type : 'POST'
					, url : '<c:url value="/menu/system/update.do" />'
					, data : $('#systemForm').serialize()
					, dataType : 'json'
					, async : true
					, spinner : true
					, success : function(data){
						if (data.result) {
							alert('시스템 메뉴 정보를 수정하였습니다.');
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
		if (confirm('시스템 메뉴 정보를 삭제하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/menu/system/delete.do" />'
				, data : $('#systemForm').serialize()
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					alert('시스템 메뉴 정보를 삭제하였습니다.');
					goList();
				}
			});
		}
	}
	
	function goList() {
		lf.action = '<c:url value="/menu/system/list.do" />';
		lf.target = '_self';
		lf.submit();
	}
</script>