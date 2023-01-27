<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" 	uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" 		uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="form1" name="form1" method="post" onsubmit="return false;">
<input type="hidden" id="acctId" name="acctId" value="<c:out value="${userMap.acctId}"/>" />
<input type="hidden" id="searchUserSabun" name="searchUserSabun" value="<c:out value="${searchParam.searchUserSabun}"/>" />
<input type="hidden" id="searchUserName" name="searchUserName" value="<c:out value="${searchParam.searchUserName}"/>" />
<input type="hidden" id="searchAcctTypeId" name="searchAcctTypeId" value="<c:out value="${searchParam.searchAcctTypeId}"/>" />
<input type="hidden" id="searchDeptCd" name="searchDeptCd" value="<c:out value="${searchParam.searchDeptCd}"/>" />
<input type="hidden" id="systemMenuId" name="systemMenuId" value="<c:out value="${empty userMap.systemMenuId ? 0 : userMap.systemMenuId}" />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doSave();" class="btn_sm btn_primary btn_modify_auth">저장</a>
		<a href="javascript:doList();" class="btn_sm btn_secondary">목록</a>
	</div>
</div>
<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">사용자 등록</h3>
	</div>
	<table class="formTable">
		<colgroup>
			<col style="width:15%;">
			<col/>
			<col style="width:15%;">
			<col/>
		</colgroup>
		<tr>
			<th>ID<strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text w100p" id="userSabun" name="userSabun" value="<c:out value="${userMap.userSabun}"/>" maxlength="20" required="required"  title="KITANET 아이디" readonly="readonly"/>
			</td>
			<th>성명<strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text w100p" id="userName" name="userName" value="<c:out value="${userMap.userName}"/>" maxlength="20" required="required"  title="성명" />
			</td>
		</tr>
		<tr>
			<th>전화번호<strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text w100p" id="telNo" name="telNo" value="<c:out value="${userMap.telNo}"/>" maxlength="13" required="required"  title="전화번호" />
			</td>
			<th>핸드폰<strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text w100p" id="handTelNo" name="handTelNo" value="<c:out value="${userMap.handTelNo}"/>" maxlength="13" required="required"  title="핸드폰" />
			</td>
		</tr>
		<tr>
			<th>팩스번호</th>
			<td>
				<input type="text" class="form_text w100p" id="faxNo" name="faxNo" value="<c:out value="${userMap.faxNo}"/>" maxlength="13"  title="팩스번호" />
			</td>
			<th>이메일</th>
			<td>
				<input type="text" class="form_text w100p" id="email" name="email" value="<c:out value="${userMap.email}"/>" maxlength="20"  title="이메일" />
			</td>
		</tr>
		<tr>
			<th>부서<strong class="point">*</strong></th>
			<td>
				<select id="deptCd" name="deptCd" class="form_select" >
					<c:forEach var="item" items="${COM005}" varStatus="status">
						<c:if test="${item.detailcd lt '29999'}">
							<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq userMap.deptCd}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
						</c:if>
					</c:forEach>
				</select>
			</td>
			<th>권한구분<strong class="point">*</strong></th>
			<td>
				<div class="form_row" style="width: 300px;">
					<select id="acctTypeId" name="acctTypeId" class="form_select" onchange="getAuth(this.value)">
						<c:forEach var="item" items="${acctTypeUseList}" varStatus="status">
							<option value="<c:out value="${item.acctTypeId}"/>" <c:if test="${item.acctTypeId eq userMap.acctTypeId}">selected="selected"</c:if>><c:out value="${item.acctTypeName}"/></option>
						</c:forEach>
					</select>
					<select id="authId" name="authId" class="form_select">
						<c:forEach var="item" items="${authList}" varStatus="status">
							<option value="<c:out value="${item.authId}"/>" <c:if test="${item.authId eq userMap.authId}">selected="selected"</c:if>><c:out value="${item.authName}"/></option>
						</c:forEach>
					</select>
				</div>
			</td>
		</tr>
	 </table>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		var authList = '<c:out value="${authList}"/>';

		if (authList == '') {
			getAuth('1');
		}

		$("#deptCd").on("change", function(){
			var clickCd =  parseInt($(this).val());

			if (clickCd == 10000) {
				getAuth('1');
			}
		});

		deptFirst();

		// 전화번호 셋팅(회사 제외)
		setExpPhoneNumber(['#telNo', '#handTelNo', '#faxNo'], 'W');
	});

	// 리스트 이동
	function doList() {
	    var f = document.form1;
	    f.action = '<c:url value="/sycs/user/userList.do" />';
	    // f.target = "_self";
	    f.submit();
	}

	function getAuth(val) {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/user/selectUserFormAdminAuthList.do" />'
			, data : {'acctTypeId' : val}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				var result = data.resultList;

				if (val == '1') {
					$('#systemMenuId').val(0);
					$('#authId').hide();
					selectBoxChang(val);
				}

				if (val == '3') {
					$('#authId').show();
					$('#authId').empty();
					$('#systemMenuId').val(result[0].systemMenuId);
					for (var i = 0; i < result.length; i++){
						$('#authId').append('<option value="'+result[i].authId+'" label="'+result[i].authName+'" />')
					}
					selectBoxChang(val);
				}

				if (val == '5') {
					$('#authId').show();
					$('#authId').empty();
					$('#systemMenuId').val(result[0].systemMenuId);
					for(var i = 0; i < result.length; i++){
						$('#authId').append('<option value="'+result[i].authId+'" label="'+result[i].authName+'" />')
					}
					selectBoxChang(val);
				}
			}
		});
	}

	// 저장
	function doSave() {
		var f = document.form1;

		if (!doValidFormRequired(f)) {
			return;
		}

		if (!confirm("저장하시겠습니까?")) {
			return;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/user/userFormSave.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				alert("저장되었습니다.");
				doList();
			}
		});
	}

	// 사용자 선택 팝업
	function showUserList() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/authority/popup/userList.do" />'
			, callbackFunction : function(resultObj){
				$('#userNmId').val(resultObj.maskUserNm + ' (' + resultObj.userId + ')');
				$('#userNm').val(resultObj.userNm);
			}
		});
	}

	function selectBoxChang(code) {
		$('#deptCd option').each(function(){
			var thisVal = $(this).val();

			if (code == '1') {
				if (thisVal == '10000') {
					$(this).show();
					$("#deptCd option:eq(0)").prop("selected", true);
				} else {
					$(this).hide();
				}
			} else {
				if (thisVal == '10000') {
					$(this).hide();
				} else {
					$(this).show();
					$("#deptCd option:eq(1)").prop("selected", true);

				}
			}
		});
	}

	function deptFirst() {
		var selectedVal = $("#deptCd option:selected").val();

		if (selectedVal == '10000') {
			selectBoxChang('1');
		} else {
			selectBoxChang('2');
		}
	}
</script>