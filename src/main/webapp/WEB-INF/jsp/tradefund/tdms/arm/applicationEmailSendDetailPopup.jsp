<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="applicationEmailSendDetailPopupForm" name="applicationEmailSendDetailPopupForm" method="get" onsubmit="return false;">
<input type="hidden" name="sendSeq"			id="sendSeq"  		value="<c:out value='${result.sendSeq}' />" />
<input type="hidden" name="applySeq"		id="applySeq"  		value="<c:out value='${result.applySeq}' />" />
<input type="hidden" name="crmSendSno"		id="crmSendSno"  	value="<c:out value='${result.crmSendSno}' />" />
<input type="hidden" name="msgGb"			id="msgGb"  		value="<c:out value='${result.msgGb}' />" />
<input type="hidden" name="msgType"			id="msgType"  		value="<c:out value='${result.sendType}' />" />
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title"><c:out value="${result.sendType}"/> 상세정보</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>
<div class="popup_body" style="max-width: 800px;">
	<table class="formTable">
		<colgroup>
			<col style="width:15%;">
			<col >
			<col style="width:15%;">
			<col >
		</colgroup>
		<tr>
			<th>무역업고유번호</th>
			<td>
				<c:out value="${result.memberId}"/>
			</td>
			<th>회사명</th>
			<td>
				<c:out value="${result.coNm}"/>
			</td>
		</tr>
		<tr>
			<th>전송분류</th>
			<td>
				<c:out value="${result.msgGb}"/>
			</td>
			<th>발신구분</th>
			<td>
				<c:out value="${result.sendType}"/>
			</td>
		</tr>
		<tr>
			<th>발신자</th>
			<td>
				<c:out value="${result.sendUserName}"/>
			</td>
			<th>수신자</th>
			<td>
				<c:out value="${result.receiveUserName}"/>
			</td>
		</tr>
		<c:if test="${result.sendType eq 'EMAIL' }">
		<tr>
			<th>발신메일</th>
			<td>
				<c:out value="${result.sendUserEmail}"/>
			</td>
			<th>수신메일</th>
			<td>
				<c:out value="${result.receiveUserEmail}"/>
			</td>
		</tr>
		</c:if>
		<c:if test="${result.sendType ne 'EMAIL' }">
		<tr>
			<th>발신자 전화번호</th>
			<td class="phoneNum">
				<c:out value="${result.sendUserTelNo}"/>
			</td>
			<th>수신자 전화번호</th>
			<td class="phoneNum">
				<c:out value="${result.receiveUserTelNo}"/>
			</td>
		</tr>
		</c:if>
		<tr>
			<th>제목</th>
			<td colspan="3">
				<c:out value="${result.sendTitl}"/>
			</td>
		</tr>
		<tr>
			<th>내용</th>
			<td colspan="3">
				<textarea rows="10" class="form_textarea" id="mailMsg" name="mailMsg"  title="메일 내용" style="height:280px; width:100%" required="required"
				onKeyUp="textareachk(this)"  ><c:out value="${result.sendCont}"/></textarea>
			</td>
		</tr>

	 </table>
</div>
</form>
<script type="text/javascript">
	var oEditors = [];
	$(document).ready(function(){
		var msgType = $("#msgType").val();

		if (msgType == "EMAIL") {
			nhn.husky.EZCreator.createInIFrame({
				oAppRef: oEditors,
				elPlaceHolder: "mailMsg",
				sSkinURI: '<c:url value="/lib/smarteditor2/SmartEditor2Skin.html" />',
				htParams : {
					bUseToolbar : true,									// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
					bUseVerticalResizer : true,							// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
					bUseModeChanger : true,								// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
					// aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
					fOnBeforeUnload : function(){
						// alert('완료!');
					}
				}, // boolean
				fOnAppLoad : function(){
					// 예제 코드
					// oEditors.getById["contEditor"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);

					doCodeComSearch();
				},
				fCreator: "createSEditor2"
			});
		}

		// 전화번호 셋팅(회사 제외)
		setExpPhoneNumber(['#applicationEmailSendDetailPopupForm .phoneNum'], 'R');
	});
</script>