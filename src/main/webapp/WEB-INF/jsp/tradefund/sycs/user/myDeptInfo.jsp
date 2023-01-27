<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" 	uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" 		uri="http://java.sun.com/jsp/jstl/functions" %>

<form id="form1" name="form1" method="post" onsubmit="return false;">
<input type='hidden' id="deptNm" name="deptNm" value="" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doSave();" 			class="btn_sm btn_primary btn_modify_auth">저장</a>
	</div>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">부서정보 등록</h3>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:15%;">
			<col style="width:15%;">
			<col style="width:15%;">
			<col>
		</colgroup>
		<tr>
			<th>ID<strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text w100p" id="userSabun" name="userSabun" value="<c:out value="${user.memberId}"/>" maxlength="20" required="required"  title="아이디" readonly="readonly"/>
			</td>
			<th>부서<strong class="point">*</strong></th>
			<td>
				<select id="deptCd" name="deptCd" class="form_select" >
					<option value="">선택</option>
					<c:forEach var="item" items="${COM005}" varStatus="status">
						<c:if test="${item.detailcd lt '29999' }">
							<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq deptCd}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
						</c:if>
					</c:forEach>
				</select>
			</td>
		</tr>
	 </table>
</div>


</form>


<script type="text/javascript">

	$(document).ready(function(){
		if( '<c:out value="${deptCd}"/>' == '' ){
			alert('부서정보를 등록해야 시스템사용이 가능합니다.');
			$('#deptCd').focus();
		}

	});

	//저장
	function doSave(){

		var f = document.form1;

		if( $('#deptCd').val() == ''){
			alert('부서정보를 입력하세요');
			return false;
		}

		if(!confirm("저장하시겠습니까?")){
			return;
		}

		$('#deptNm').val($("#deptCd option:checked").text());

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/fundAward/saveMyDeptInfo.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				alert("저장되었습니다.");
			}
		});

	}

</script>