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
<form id="memberForm" name="memberForm" method="post" onsubmit="return false;">
<input type="hidden" id="memberSeq" name="memberSeq" value="<c:out value='${resultView.memberSeq}' default='0' />" />
<h2>사용자관리</h2>
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
				<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> 아이디</th>
				<td colspan="3">
					<c:choose>
						<c:when test="${empty resultView.memberSeq}">
							<input type="text" name="loginId" value="" class="textType" style="width: 300px;" />
						</c:when>
						<c:otherwise>
							${resultView.loginId}
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;">
					<c:if test="${empty resultView.memberSeq}">
						<font color="red">◎</font>
					</c:if>
					비밀번호
				</th>
				<td>
					<input type="password" name="pwd" value="" class="textType" style="width: 300px;" <c:if test="${not empty resultView.memberSeq}">placeholder="변경할 비밀번호를 입력해 주세요."</c:if> />
				</td>
				<th scope="row" style="text-align: left;padding-left: 20px;">
					<c:if test="${empty resultView.memberSeq}">
						<font color="red">◎</font>
					</c:if>
					비밀번호 확인
				</th>
				<td>
					<input type="password" name="pwdCheck" value="" class="textType" style="width: 300px;" <c:if test="${not empty resultView.memberSeq}">placeholder="변경할 비밀번호를 입력해 주세요."</c:if> />
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> 이름</th>
				<td>
					<input type="text" name="memberNm" value="${resultView.memberNm}" class="textType" style="width: 300px;" />
				</td>
				<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> 타입</th>
				<td>
					<select name="memberType" class="jquerySelectbox">
						<option value="" <c:if test="${empty resultView.memberType or resultView.memberType eq ''}">selected="selected"</c:if>>::: 선택 :::</option>
						<option value="A" <c:if test="${resultView.memberType eq 'A'}">selected="selected"</c:if>>슈퍼관리자</option>
						<option value="U" <c:if test="${resultView.memberType eq 'U'}">selected="selected"</c:if>>일반사용자</option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;">이메일</th>
				<td>
					<input type="text" name="email" value="${resultView.email}" class="textType" style="width: 300px;" placeholder="이메일 형식에 맞게 입력해 주세요." />
				</td>
				<th scope="row" style="text-align: left;padding-left: 20px;">휴대폰</th>
				<td>
					<input type="text" name="hpTel" value="${resultView.hpTel}" onkeyup="this.value=this.value.replace(/[^-0-9]/g, '');" class="textType" style="width: 300px;" placeholder="숫자만 입력해 주세요." />
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: left;padding-left: 20px;">부서명</th>
				<td colspan="3">
					<input type="text" id="deptNm" value="${resultView.deptNm}" class="textType" style="width: 300px;" />
					<input type="hidden" id="deptId" name="deptId" value="${resultView.deptId}" />
					<a href="javascript:showDeptList();" class="ui-button ui-widget ui-corner-all">찾기</a>
				</td>
			</tr>
		</tbody>
	</table>
	<c:if test="${not empty resultView.memberSeq}">
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
					<th scope="row" style="text-align: left;padding-left: 20px;">가입일시</th>
					<td>${resultView.joinDate}</td>
					<th scope="row" style="text-align: left;padding-left: 20px;">로그인일시</th>
					<td>${resultView.loginDate}</td>
				</tr>
				<tr>
					<th scope="row" style="text-align: left;padding-left: 20px;">휴면여부</th>
					<td>${resultView.dormantYn}</td>
					<th scope="row" style="text-align: left;padding-left: 20px;">휴면일시</th>
					<td>${resultView.dormantDate}</td>
				</tr>
				<tr>
					<th scope="row" style="text-align: left;padding-left: 20px;">탈퇴여부</th>
					<td>${resultView.leaveYn}</td>
					<th scope="row" style="text-align: left;padding-left: 20px;">탈퇴일시</th>
					<td>${resultView.leaveDate}</td>
				</tr>
			</tbody>
		</table>
	</c:if>
	<div class="widget btn">
		<c:choose>
			<c:when test="${empty resultView.memberSeq}">
				<a href="javascript:doInsert();" class="ui-button ui-widget ui-corner-all">저장</a>
				<a href="javascript:goList();" class="ui-button ui-widget ui-corner-all">취소</a>
			</c:when>
			<c:otherwise>
				<a href="javascript:doUpdate();" class="ui-button ui-widget ui-corner-all">저장</a>
				<a href="javascript:doDormantUpdate();" class="ui-button ui-widget ui-corner-all">휴면처리</a>
				<a href="javascript:doLeaveUpdate();" class="ui-button ui-widget ui-corner-all">탈퇴처리</a>
				<a href="javascript:goList();" class="ui-button ui-widget ui-corner-all">목록</a>
			</c:otherwise>
		</c:choose>
	</div>
</div>
</form>
<script type="text/javascript">
	var f;
	var lf;
	$(document).ready(function(){
		f = document.memberForm;
		lf = document.listForm;
		<c:if test="${empty resultView.memberSeq}">
			f.loginId.focus();
		</c:if>
	});
	
	function isValid() {
		<c:if test="${empty resultView.memberSeq}">
			if (isStringEmpty(f.loginId.value)) {
				alert('아이디를 입력해 주세요.');
				f.loginId.focus();
				
				return false;
			}
		
			if (isStringEmpty(f.pwd.value)) {
				alert('비밀번호를 입력해 주세요.');
				f.pwd.focus();
				
				return false;
			}
			
			if (isStringEmpty(f.pwdCheck.value)) {
				alert('비밀번호 확인을 입력해 주세요.');
				f.pwdCheck.focus();
				
				return false;
			}
		</c:if>
		
		if (!isStringEmpty(f.pwd.value) && !isStringEmpty(f.pwdCheck.value)) {
			if (f.pwd.value != f.pwdCheck.value) {
				alert("비밀번호와 확인이 일치하지 않습니다.");
				f.pwdCheck.value = '';
				f.pwdCheck.focus();
				
				return false;
			}			
		}
		
		if (isStringEmpty(f.memberNm.value)) {
			alert('이름을 입력해 주세요.');
			f.memberNm.focus();
			
			return false;
		}
		
		var memberType = $('select[name="memberType"] option:selected');
		
		if (isStringEmpty(memberType.val())) {
			alert('타입을 선택해 주세요.');
			memberType.focus();
			
			return false;
		}
		
		// 이메일이 입력되면 이메일 형식을 체크한다.
		if (!isStringEmpty(f.email.value)) {
			if (!global.isEmail(f.email.value)) {
				alert('이메일 형식이 잘못되었습니다.');
				f.email.value = '';
				f.email.focus();

				return false;
			}
		}
		
		// 휴대폰이 입력되면 휴대폰 형식을 체크한다.
		if (!isStringEmpty(f.hpTel.value)) {
			if (!global.isHpTel(f.hpTel.value)) {
				alert('휴대폰 형식이 잘못되었습니다.');
				f.hpTel.value = '';
				f.hpTel.focus();

				return false;
			}
		}
		
		return true;
	}
	
	function doInsert() {
		if (isValid()) {
			if (confirm('사용자 정보를 등록하시겠습니까?')) {
				global.ajax({
					type : 'POST'
					, url : '<c:url value="/member/insert.do" />'
					, data : $('#memberForm').serialize()
					, dataType : 'json'
					, async : true
					, spinner : true
					, success : function(data){
						alert('사용자 정보를 등록하였습니다.');
						goList();
					}
				});
			}
		}
	}
	
	function doUpdate() {
		if (isValid()) {
			if (confirm('사용자 정보를 수정하시겠습니까?')) {
				global.ajax({
					type : 'POST'
					, url : '<c:url value="/member/update.do" />'
					, data : $('#memberForm').serialize()
					, dataType : 'json'
					, async : true
					, spinner : true
					, success : function(data){
						alert('사용자 정보를 수정하였습니다.');
						goList();
					}
				});
			}
		}
	}
	
	function doDormantUpdate() {
		if (confirm('해당 사용자를 휴면처리 하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/member/dormantUpdate.do" />'
				, data : {
					memberSeq : f.memberSeq.value
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					alert('해당 사용자를 휴면처리 하였습니다.');
					goList();
				}
			});
		}
	}
	
	function doLeaveUpdate() {
		if (confirm('해당 사용자를 탈퇴처리 하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/member/dormantLeave.do" />'
				, data : {
					memberSeq : f.memberSeq.value
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					alert('해당 사용자를 탈퇴처리 하였습니다.');
					goList();
				}
			});
		}
	}
	
	function goList() {
		lf.action = '<c:url value="/member/list.do" />';
		lf.target = '_self';
		lf.submit();
	}
	
	function showDeptList() {
		window.open('<c:url value="/member/popup/deptList.do" />', 'SDCIT', 'width=800, height=600');
	}
	
	function setDeptInfo(deptId, deptNm) {
		$('#deptId').val(deptId);
		$('#deptNm').val(deptNm);
	}
</script>