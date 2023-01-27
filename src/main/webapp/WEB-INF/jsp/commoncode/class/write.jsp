<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="egovframework.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchCondition" value="${param.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${param.searchKeyword}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10'/>" />
</form>
<form id="commonCodeForm" name="commonCodeForm" method="post" onsubmit="return false;">
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<c:choose>
			<c:when test="${empty resultView.clCode}">
				<button type="button" onclick="doInsert();" class="btn_sm btn_primary btn_modify_auth">저장</button>
			</c:when>
			<c:otherwise>
				<button type="button" onclick="doUpdate();" class="btn_sm btn_primary btn_modify_auth">저장</button>
			</c:otherwise>
		</c:choose>
	</div>
	<div class="ml-15">
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<div class="cont_block">
	<div class="tbl_opt">
		<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
	</div>
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tr>
			<th>분류코드 <strong class="point">*</strong></th>
			<td>
				<c:choose>
					<c:when test="${empty resultView.clCode}">
						<input type="text" id="clCode" name="clCode" value="${resultView.clCode}" maxlength="3" class="form_text w100p" title="분류코드" />
					</c:when>
					<c:otherwise>
						${resultView.clCode}
						<input type="hidden" id="clCode" name="clCode" value="${resultView.clCode}" />
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th>분류코드명 <strong class="point">*</strong></th>
			<td>
				<input type="text" id="clCodeNm" name="clCodeNm" value="${resultView.clCodeNm}" maxlength="20" class="form_text w100p" title="분류코드명" />
			</td>
		</tr>
		<tr>
			<th>분류코드 설명 <strong class="point">*</strong></th>
			<td>
				<textarea id="clCodeDc" name="clCodeDc" rows="5" maxlength="60" onkeyup="return textareaMaxLength(this);" class="form_textarea" title="분류코드 설명">${resultView.clCodeDc}</textarea>
			</td>
		</tr>
		<tr>
			<th>사용여부 <strong class="point">*</strong></th>
			<td>
				<select id="useAt" name="useAt" class="form_select" title="사용여부">
					<option value="Y" <c:if test="${resultView.useAt eq 'Y'}">selected="selected"</c:if>>사용</option>
					<option value="N" <c:if test="${resultView.useAt eq 'N'}">selected="selected"</c:if>>미사용</option>
				</select>
			</td>
		</tr>
	 </table>
</div>
</form>
<script type="text/javascript">
	var f;
	var lf;
	$(document).ready(function(){
		f = document.commonCodeForm;
		lf = document.listForm;
		<c:if test="${empty resultView.clCode}">
			f.clCode.focus();
		</c:if>
	});
	
	function isValid() {
		if (isStringEmpty(f.clCode.value)) {
			alert('분류코드를 입력해 주세요.');
			f.clCode.focus();
			
			return false;
		}
		
		if (isStringEmpty(f.clCodeNm.value)) {
			alert('분류코드명을 입력해 주세요.');
			f.clCodeNm.focus();
			
			return false;
		}
		
		if (isStringEmpty(f.clCodeDc.value)) {
			alert('분류코드 설명을 입력해 주세요.');
			f.clCodeDc.focus();
			
			return false;
		}
		
		var useAt = $('select[name="useAt"] option:selected');
		
		if (isStringEmpty(useAt.val())) {
			alert('사용여부를 선택해 주세요.');
			useAt.focus();
			
			return false;
		}
		
		return true;
	}
	
	function doInsert() {
		if (isValid()) {
			if (confirm('저장 하시겠습니까?')) {
				global.ajax({
					type : 'POST'
					, url : '<c:url value="/commonCode/class/insert.do" />'
					, data : $('#commonCodeForm').serialize()
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
					, url : '<c:url value="/commonCode/class/update.do" />'
					, data : $('#commonCodeForm').serialize()
					, dataType : 'json'
					, async : true
					, spinner : true
					, success : function(data){
						goList();
					}
				});
			}
		}					
	}
	
	function goList() {
		lf.action = '<c:url value="/commonCode/class/list.do" />';
		lf.target = '_self';
		lf.submit();
	}
</script>