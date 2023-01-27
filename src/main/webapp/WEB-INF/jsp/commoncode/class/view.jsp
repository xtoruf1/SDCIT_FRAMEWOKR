<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="egovframework.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchCondition" value="${param.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${param.searchKeyword}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10'/>" />
</form>
<form id="commonCodeForm" name="commonCodeForm" method="post" onsubmit="return false;">
<input type="hidden" name="clCode" value="${resultView.clCode}" />
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="goWrite();" class="btn_sm btn_primary btn_modify_auth">수정</button>
		<button type="button" onclick="doDelete();" class="btn_sm btn_secondary btn_modify_auth">삭제</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<div class="cont_block">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tr>
			<th>분류코드</th>
			<td>${resultView.clCode}</td>
		</tr>
		<tr>
			<th>분류코드명</th>
			<td>${resultView.clCodeNm}</td>
		</tr>
		<tr>
			<th>분류코드 설명</th>
			<td>${resultView.clCodeDc}</td>
		</tr>
		<tr>
			<th>사용여부</th>
			<td>${resultView.useAtNm}</td>
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
	});
	
	// 수정
	function goWrite() {
		f.action = '<c:url value="/commonCode/class/write.do" />';
		f.target = '_self';
		f.submit();
	}
	
	// 삭제
	function doDelete() {
		if (confirm('삭제 하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/commonCode/class/delete.do" />'
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
	
	// 목록
	function goList() {
		lf.action = '<c:url value="/commonCode/class/list.do" />';
		lf.target = '_self';
		lf.submit();
	}
</script>