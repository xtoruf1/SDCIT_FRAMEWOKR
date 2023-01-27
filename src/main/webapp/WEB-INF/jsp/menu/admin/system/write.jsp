<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchSystemMenuName" value="${param.searchSystemMenuName}" />
<input type="hidden" name="searchDscr" value="${param.searchDscr}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10'/>" />
</form>
<form id="systemForm" name="systemForm" method="post" onsubmit="return false;">
<input type="hidden" id="systemMenuId" name="systemMenuId" value="<c:out value='${resultView.systemMenuId}' default='0' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<c:choose>
			<c:when test="${empty resultView.systemMenuId}">
				<button type="button" onclick="doInsert();" class="btn_sm btn_primary btn_modify_auth">저장</button>
			</c:when>
			<c:otherwise>
				<button type="button" onclick="doUpdate();" class="btn_sm btn_primary btn_modify_auth">저장</button>
				<button type="button" onclick="doDelete();" class="btn_sm btn_secondary btn_modify_auth">삭제</button>
			</c:otherwise>
		</c:choose>
	</div>
	<div class="ml-15">
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<div class="contents">
	<div class="tbl_opt">
		<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
	</div>
	<table class="boardwrite formTable">
		<caption>등록/수정화면</caption>
		<colgroup>
			<col width="15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">시스템명 <strong class="point">*</strong></th>
				<td>
					<input type="text" name="systemMenuName" value="${resultView.systemMenuName}" maxlength="30" class="form_text w100p" />
				</td>
			</tr>
			<tr>
				<th scope="row">비고</th>
				<td>
					<input type="text" name="dscr" value="${resultView.dscr}" maxlength="500" class="form_text w100p" />
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
			f.systemMenuName.focus();
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
			if (confirm('저장 하시겠습니까?')) {
				global.ajax({
					type : 'POST'
					, url : '<c:url value="/menu/admin/system/insert.do" />'
					, data : $('#systemForm').serialize()
					, dataType : 'json'
					, async : true
					, spinner : true
					, success : function(data){
						if (data.result) {
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
			if (confirm('저장 하시겠습니까?')) {
				global.ajax({
					type : 'POST'
					, url : '<c:url value="/menu/admin/system/update.do" />'
					, data : $('#systemForm').serialize()
					, dataType : 'json'
					, async : true
					, spinner : true
					, success : function(data){
						if (data.result) {
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
		if (confirm('삭제 하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/menu/admin/system/delete.do" />'
				, data : $('#systemForm').serialize()
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					goList();
				}
			});
		}
	}
	
	function goList() {
		lf.action = '<c:url value="/menu/admin/system/list.do" />';
		lf.target = '_self';
		lf.submit();
	}
</script>